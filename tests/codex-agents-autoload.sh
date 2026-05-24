#!/usr/bin/env sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found" >&2
  exit 127
fi

tmpdir="$(mktemp -d)"
probe_id="lazy-mem-autoload-probe-$(date +%s)-$$"
created_project_page="$ROOT/projects/$probe_id.md"

cleanup() {
  rm -rf "$tmpdir"
  rm -f "$created_project_page"
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

codex exec \
  -C "$canary_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  "codex-agents-autoload-probe" \
  >"$tmpdir/canary.out" \
  2>"$tmpdir/canary.err"

grep -F "AGENTS_CANARY_LOADED_2026_05_24" "$tmpdir/canary.out" >/dev/null

lazy_mem_project="$tmpdir/lazy-mem-project"
mkdir -p "$lazy_mem_project"
"$ROOT/bin/lazy-mem" attach "$lazy_mem_project" --id "$probe_id" >/dev/null

codex exec \
  --json \
  -C "$lazy_mem_project" \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  "hello" \
  >"$tmpdir/lazy-mem-events.jsonl" \
  2>"$tmpdir/lazy-mem.err"

grep -F ".lazy-mem" "$tmpdir/lazy-mem-events.jsonl" >/dev/null
grep -F "$ROOT/SYSTEM.md" "$tmpdir/lazy-mem-events.jsonl" >/dev/null
grep -F "$ROOT/ROUTERS.md" "$tmpdir/lazy-mem-events.jsonl" >/dev/null

echo "codex AGENTS.md autoload test passed"
