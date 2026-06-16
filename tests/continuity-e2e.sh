#!/usr/bin/env sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found" >&2
  exit 127
fi

run_with_timeout() {
  timeout_seconds=$1
  shift

  "$@" &
  command_pid=$!
  (
    sleep "$timeout_seconds"
    if kill -0 "$command_pid" 2>/dev/null; then
      echo "command timed out after ${timeout_seconds}s: $*" >&2
      kill "$command_pid" 2>/dev/null || true
    fi
  ) &
  timeout_pid=$!

  set +e
  wait "$command_pid"
  status=$?
  set -e

  kill "$timeout_pid" 2>/dev/null || true
  wait "$timeout_pid" 2>/dev/null || true
  return "$status"
}

assert_contains_file() {
  pattern=$1
  file=$2
  diagnostic_file=${3:-}

  if ! grep -F "$pattern" "$file" >/dev/null 2>&1; then
    echo "expected $file to contain: $pattern" >&2
    echo "--- $file tail ---" >&2
    tail -n 120 "$file" >&2 || true
    if [ -n "$diagnostic_file" ]; then
      echo "--- $diagnostic_file tail ---" >&2
      tail -n 120 "$diagnostic_file" >&2 || true
    fi
    exit 1
  fi
}

assert_not_contains_file() {
  pattern=$1
  file=$2

  if grep -F "$pattern" "$file" >/dev/null 2>&1; then
    echo "expected $file not to contain: $pattern" >&2
    echo "--- $file tail ---" >&2
    tail -n 120 "$file" >&2 || true
    exit 1
  fi
}

tmpdir="$(mktemp -d)"
probe_id="continuity-probe-$(date +%s)-$$"
memory_repo="$tmpdir/memory"
writer_project="$tmpdir/writer-project"
reader_project="$tmpdir/reader-project"
control_project="$tmpdir/control-project"
writer_events="$tmpdir/writer-events.jsonl"
writer_err="$tmpdir/writer.err"
reader_events="$tmpdir/reader-events.jsonl"
reader_err="$tmpdir/reader.err"
reader_answer="$tmpdir/reader-answer.txt"
control_events="$tmpdir/control-events.jsonl"
control_err="$tmpdir/control.err"
control_answer="$tmpdir/control-answer.txt"
canary="CONTINUITY_CANARY_${probe_id}"

cleanup() {
  rm -rf "$tmpdir"
}

trap cleanup EXIT

mkdir -p "$memory_repo" "$writer_project" "$reader_project" "$control_project"
(
  cd "$ROOT"
  git ls-files | while IFS= read -r file_path; do
    if [ -f "$file_path" ]; then
      mkdir -p "$memory_repo/$(dirname "$file_path")"
      cp "$file_path" "$memory_repo/$file_path"
    fi
  done
)
cp "$ROOT/tests/continuity-e2e.sh" "$memory_repo/tests/continuity-e2e.sh"
chmod +x "$memory_repo/bin/lazy-mem" "$memory_repo/tests/"*.sh

"$memory_repo/bin/lazy-mem" attach "$writer_project" --id "$probe_id" >/dev/null

run_with_timeout 180 codex exec \
  --json \
  -C "$writer_project" \
  --add-dir "$memory_repo" \
  --skip-git-repo-check \
  --ephemeral \
  -s workspace-write \
  "Set this project's next checkpoint to: $canary

Make a durable project update so a future fresh session can answer \"Where did we leave off?\" from the project state. Reply exactly: WRITER_DONE when the update is saved." \
  >"$writer_events" \
  2>"$writer_err"

assert_contains_file "WRITER_DONE" "$writer_events" "$writer_err"
assert_contains_file ".lazy-mem" "$writer_events" "$writer_err"
assert_contains_file "Universal Harness Contract" "$writer_events" "$writer_err"
assert_contains_file "Standard Route" "$writer_events" "$writer_err"
assert_contains_file "projects/$probe_id.md" "$writer_events" "$writer_err"
assert_contains_file "status/current.md" "$writer_events" "$writer_err"
assert_contains_file "$canary" "$memory_repo/projects/$probe_id/status/current.md"
if grep -R "$canary" "$writer_project" >/dev/null 2>&1; then
  echo "writer project should not contain the continuity canary outside Lazy Mem" >&2
  exit 1
fi

if [ -e "$memory_repo/proposals" ]; then
  echo "continuity writes must not create or use proposals/" >&2
  find "$memory_repo/proposals" -maxdepth 3 -type f -print >&2 || true
  exit 1
fi

"$memory_repo/bin/lazy-mem" attach "$reader_project" --id "$probe_id" >/dev/null
if grep -R "$canary" "$reader_project" >/dev/null 2>&1; then
  echo "reader project should start without the continuity canary outside Lazy Mem" >&2
  exit 1
fi

run_with_timeout 180 codex exec \
  --json \
  -C "$reader_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  --output-last-message "$reader_answer" \
  "Where did we leave off? Include the exact next checkpoint if one is recorded." \
  >"$reader_events" \
  2>"$reader_err"

assert_contains_file ".lazy-mem" "$reader_events" "$reader_err"
assert_contains_file "Universal Harness Contract" "$reader_events" "$reader_err"
assert_contains_file "Standard Route" "$reader_events" "$reader_err"
assert_contains_file "projects/$probe_id.md" "$reader_events" "$reader_err"
assert_contains_file "status/current.md" "$reader_events" "$reader_err"
assert_contains_file "$canary" "$reader_answer" "$reader_err"

control_id="$probe_id-control"
"$memory_repo/bin/lazy-mem" attach "$control_project" --id "$control_id" >/dev/null

run_with_timeout 180 codex exec \
  --json \
  -C "$control_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  --output-last-message "$control_answer" \
  "Where did we leave off? Include the exact next checkpoint if one is recorded." \
  >"$control_events" \
  2>"$control_err"

assert_contains_file ".lazy-mem" "$control_events" "$control_err"
assert_contains_file "projects/$control_id.md" "$control_events" "$control_err"
assert_not_contains_file "$canary" "$control_events"
assert_not_contains_file "$canary" "$control_answer"

echo "lazy-mem continuity e2e test passed"
