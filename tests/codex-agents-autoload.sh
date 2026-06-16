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
    tail -n 80 "$file" >&2 || true
    if [ -n "$diagnostic_file" ]; then
      echo "--- $diagnostic_file tail ---" >&2
      tail -n 80 "$diagnostic_file" >&2 || true
    fi
    exit 1
  fi
}

tmpdir="$(mktemp -d)"
probe_id="lazy-mem-autoload-probe-$(date +%s)-$$"
created_project_page="$ROOT/projects/$probe_id.md"
created_project_dir="$ROOT/projects/$probe_id"

cleanup() {
  rm -rf "$tmpdir"
  rm -f "$created_project_page"
  rm -rf "$created_project_dir"
}

trap cleanup EXIT

canary_project="$tmpdir/agents-canary"
mkdir -p "$canary_project"
cat >"$canary_project/AGENTS.md" <<'EOF'
# AGENTS.md Canary

If the user says exactly `codex-agents-autoload-probe`, reply exactly:
AGENTS_CANARY_LOADED_2026_05_24

Do not run tools for that probe.
EOF

run_with_timeout 90 codex exec \
  -C "$canary_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  "codex-agents-autoload-probe" \
  >"$tmpdir/canary.out" \
  2>"$tmpdir/canary.err"

assert_contains_file "AGENTS_CANARY_LOADED_2026_05_24" "$tmpdir/canary.out" "$tmpdir/canary.err"

lazy_mem_project="$tmpdir/lazy-mem-project"
mkdir -p "$lazy_mem_project"
"$ROOT/bin/lazy-mem" attach "$lazy_mem_project" --id "$probe_id" >/dev/null

run_with_timeout 120 codex exec \
  --json \
  -C "$lazy_mem_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  "Follow the project startup instructions, then reply exactly: LAZY_MEM_RUNTIME_PROBE_DONE" \
  >"$tmpdir/lazy-mem-events.jsonl" \
  2>"$tmpdir/lazy-mem.err"

assert_contains_file ".lazy-mem" "$tmpdir/lazy-mem-events.jsonl" "$tmpdir/lazy-mem.err"
assert_contains_file "Universal Harness Contract" "$tmpdir/lazy-mem-events.jsonl" "$tmpdir/lazy-mem.err"
assert_contains_file "Standard Route" "$tmpdir/lazy-mem-events.jsonl" "$tmpdir/lazy-mem.err"
assert_contains_file "projects/$probe_id.md" "$tmpdir/lazy-mem-events.jsonl" "$tmpdir/lazy-mem.err"
assert_contains_file "LAZY_MEM_RUNTIME_PROBE_DONE" "$tmpdir/lazy-mem-events.jsonl" "$tmpdir/lazy-mem.err"

echo "codex AGENTS.md autoload test passed"
