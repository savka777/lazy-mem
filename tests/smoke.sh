#!/usr/bin/env sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

assert_file() {
  if [ ! -f "$ROOT/$1" ]; then
    echo "missing file: $1" >&2
    exit 1
  fi
}

assert_dir() {
  if [ ! -d "$ROOT/$1" ]; then
    echo "missing directory: $1" >&2
    exit 1
  fi
}

assert_contains() {
  file="$1"
  pattern="$2"
  if ! grep -F -- "$pattern" "$ROOT/$file" >/dev/null 2>&1; then
    echo "expected '$file' to contain: $pattern" >&2
    exit 1
  fi
}

assert_not_contains() {
  file="$1"
  pattern="$2"
  if grep -F -- "$pattern" "$ROOT/$file" >/dev/null 2>&1; then
    echo "expected '$file' not to contain: $pattern" >&2
    exit 1
  fi
}

assert_executable() {
  if [ ! -x "$ROOT/$1" ]; then
    echo "expected executable: $1" >&2
    exit 1
  fi
}

assert_malformed_adapter_fails() {
  adapter_file=$1
  label=$2
  content=$3
  malformed_before="$tmpdir/$label-before.txt"
  malformed_out="$tmpdir/$label.out"
  malformed_err="$tmpdir/$label.err"

  printf '%b' "$content" >"$tmpdir/example-project/$adapter_file"
  cp "$tmpdir/example-project/$adapter_file" "$malformed_before"
  if "$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >"$malformed_out" 2>"$malformed_err"; then
    echo "attach should fail on malformed Lazy Mem markers: $label" >&2
    exit 1
  fi
  grep -F "malformed Lazy Mem block" "$malformed_err" >/dev/null
  cmp "$malformed_before" "$tmpdir/example-project/$adapter_file" >/dev/null
  rm -f "$tmpdir/example-project/$adapter_file"
  "$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
}

assert_file_unchanged() {
  before_file=$1
  after_file=$2
  label=$3

  if ! cmp "$before_file" "$after_file" >/dev/null; then
    echo "failed attach changed $label" >&2
    exit 1
  fi
}

assert_file "README.md"
assert_file "SYSTEM.md"
assert_file "RULES.md"
assert_file "ROUTERS.md"
assert_file "lazy-mem.yaml"
assert_file "bin/lazy-mem"
assert_file "tests/codex-agents-autoload.sh"
assert_file "tests/continuity-e2e.sh"
assert_file "templates/AGENTS.md"
assert_file "templates/adapter.md"
assert_file "templates/project-pointer.yaml"
assert_file "templates/project.md"
assert_file "templates/project-decisions-readme.md"
assert_file "templates/project-features-readme.md"
assert_file "templates/project-specs-readme.md"
assert_file "templates/project-status-current.md"
assert_file "projects/_template.md"
assert_file "projects/lazy-mem.md"
assert_file "projects/lazy-mem/status/current.md"
assert_file "projects/lazy-mem/status/todo.md"
assert_file "projects/lazy-mem/decisions/README.md"
assert_file "projects/lazy-mem/features/README.md"
assert_file "projects/lazy-mem/specs/README.md"
assert_file "people/_template.md"
assert_file "people/sav.md"
assert_file "procedures/_template.md"
assert_file "procedures/code-recall.md"
assert_file "procedures/memory-growth.md"
assert_file "procedures/memory-explorer.md"
assert_file "procedures/project-handoff.md"
assert_file "state/current-focus.md"
assert_file "state/active-projects.md"
assert_file "sources/README.md"
assert_file "logs/README.md"
assert_file "benchmarks/README.md"
assert_file "lazy-cache/README.md"

assert_dir "logs/read-traces"
assert_dir "logs/write-traces"
assert_dir "logs/experiments"

assert_executable "bin/lazy-mem"
assert_executable "tests/codex-agents-autoload.sh"
assert_executable "tests/continuity-e2e.sh"

if [ -e "$ROOT/proposals" ]; then
  echo "proposals should not be part of the active Lazy Mem contract" >&2
  exit 1
fi

cmp "$ROOT/templates/adapter.md" "$ROOT/templates/AGENTS.md" >/dev/null

assert_contains "README.md" "harness startup adapters"
assert_contains "README.md" "AGENTS.md"
assert_contains "README.md" "CLAUDE.md"
assert_contains "README.md" "GEMINI.md"
assert_contains "README.md" "AGENT.md"
assert_contains "README.md" "Codex runtime-probed through \`AGENTS.md\`."
assert_contains "README.md" "Generated adapters are not the same as runtime proof for every harness."
assert_contains "README.md" "cold-start continuity"
assert_not_contains "README.md" "proposals/"
assert_contains "SYSTEM.md" "If a project has a .lazy-mem pointer file, read it first."
assert_contains "SYSTEM.md" "Do not preload the whole memory repo."
assert_contains "SYSTEM.md" "Project memory is layered."
assert_contains "SYSTEM.md" "Memory should grow over time."
assert_contains "SYSTEM.md" 'If the task spans several memory areas, read `procedures/memory-explorer.md`.'
assert_not_contains "SYSTEM.md" "Do not directly edit durable memory by default."
assert_not_contains "SYSTEM.md" "proposal"
assert_contains "ROUTERS.md" "Read projects/ before procedures/ when project_id is known."
assert_contains "ROUTERS.md" "Use the project hub as the first layer."
assert_contains "ROUTERS.md" 'Read `procedures/memory-growth.md` when:'
assert_contains "ROUTERS.md" 'Read `procedures/memory-explorer.md` when:'
assert_not_contains "ROUTERS.md" "proposal"
assert_contains "RULES.md" "Memory should grow over time."
assert_contains "RULES.md" "If a memory update is uncertain, conflicting, broad, destructive, secret-bearing, or speculative, do not write it."
assert_not_contains "RULES.md" "Do not directly edit durable memory by default."
assert_not_contains "RULES.md" "proposal"
assert_contains "lazy-mem.yaml" "schema_version: 0.1.0"
assert_contains "lazy-mem.yaml" "cache: lazy-cache"
assert_contains "lazy-mem.yaml" "durable_memory_default: direct_when_clear"
assert_not_contains "lazy-mem.yaml" "proposal"
assert_contains "procedures/memory-explorer.md" "task: {}"
assert_contains "procedures/memory-explorer.md" "- none by default"
assert_contains "procedures/memory-growth.md" "Default to useful memory growth."
assert_contains "procedures/memory-growth.md" "When an update is unsafe, ask, skip, or record only the safe blocker."
assert_not_contains "procedures/memory-growth.md" "proposal"
assert_not_contains "tests/continuity-e2e.sh" "read -r -d"
assert_not_contains "tests/continuity-e2e.sh" "read -d"

tmpdir="$(mktemp -d)"
project_id="smoke-project-$$"
project_page="$ROOT/projects/$project_id.md"
project_dir="$ROOT/projects/$project_id"
project_status_current="$project_dir/status/current.md"
project_decisions_index="$project_dir/decisions/README.md"
project_features_index="$project_dir/features/README.md"
project_specs_index="$project_dir/specs/README.md"
counter=0
while [ -e "$project_page" ] || [ -e "$project_dir" ]; do
  counter=$((counter + 1))
  project_id="smoke-project-$$-$counter"
  project_page="$ROOT/projects/$project_id.md"
  project_dir="$ROOT/projects/$project_id"
  project_status_current="$project_dir/status/current.md"
  project_decisions_index="$project_dir/decisions/README.md"
  project_features_index="$project_dir/features/README.md"
  project_specs_index="$project_dir/specs/README.md"
done
fresh_project_id="$project_id-fresh"
fresh_project_page="$ROOT/projects/$fresh_project_id.md"
fresh_project_dir="$ROOT/projects/$fresh_project_id"
fresh_project_status_current="$fresh_project_dir/status/current.md"
fresh_counter=0
while [ -e "$fresh_project_page" ] || [ -e "$fresh_project_dir" ]; do
  fresh_counter=$((fresh_counter + 1))
  fresh_project_id="$project_id-fresh-$fresh_counter"
  fresh_project_page="$ROOT/projects/$fresh_project_id.md"
  fresh_project_dir="$ROOT/projects/$fresh_project_id"
  fresh_project_status_current="$fresh_project_dir/status/current.md"
done
git_project_id="$project_id-git"
git_project_page="$ROOT/projects/$git_project_id.md"
git_project_dir="$ROOT/projects/$git_project_id"
atomic_project_id="$project_id-atomic"
atomic_project_page="$ROOT/projects/$atomic_project_id.md"
atomic_project_dir="$ROOT/projects/$atomic_project_id"

cleanup() {
  rm -rf "$tmpdir"
  rm -f "$project_page"
  rm -rf "$project_dir"
  rm -f "$fresh_project_page"
  rm -rf "$fresh_project_dir"
  rm -f "$git_project_page"
  rm -rf "$git_project_dir"
  rm -f "$atomic_project_page"
  rm -rf "$atomic_project_dir"
}

trap cleanup EXIT

mkdir -p "$tmpdir/example-project"
printf '# Existing Instructions\n\nKeep this line.\n' >"$tmpdir/example-project/AGENTS.md"
attach_output="$tmpdir/attach-output.txt"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >"$attach_output"

if [ ! -f "$tmpdir/example-project/.lazy-mem" ]; then
  echo "attach did not create .lazy-mem pointer" >&2
  exit 1
fi

if [ ! -f "$project_page" ]; then
  echo "attach did not create project memory page" >&2
  exit 1
fi

if [ ! -f "$project_status_current" ]; then
  echo "attach did not create project current status file" >&2
  exit 1
fi

if [ ! -f "$project_decisions_index" ]; then
  echo "attach did not create project decisions index" >&2
  exit 1
fi

if [ ! -f "$project_features_index" ]; then
  echo "attach did not create project features index" >&2
  exit 1
fi

if [ ! -f "$project_specs_index" ]; then
  echo "attach did not create project specs index" >&2
  exit 1
fi

if [ ! -f "$tmpdir/example-project/AGENTS.md" ]; then
  echo "attach did not create AGENTS.md" >&2
  exit 1
fi

for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  if [ ! -f "$tmpdir/example-project/$adapter_file" ]; then
    echo "attach did not create $adapter_file" >&2
    exit 1
  fi
done

grep -F "memory_repo: $ROOT" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "project_id: $project_id" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "system_file: SYSTEM.md" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "# Existing Instructions" "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "Keep this line." "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "<!-- lazy-mem:start -->" "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "<!-- lazy-mem:end -->" "$tmpdir/example-project/AGENTS.md" >/dev/null
for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  grep -F "<!-- lazy-mem:start -->" "$tmpdir/example-project/$adapter_file" >/dev/null
  grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/$adapter_file" >/dev/null
  grep -F "<!-- lazy-mem:end -->" "$tmpdir/example-project/$adapter_file" >/dev/null
done
grep -F "id: project.$project_id" "$project_page" >/dev/null
grep -F "Project memory hub for \`$project_id\`." "$project_page" >/dev/null
grep -F "## Open First" "$project_page" >/dev/null
grep -F "$project_id/status/current.md" "$project_page" >/dev/null
grep -F "$project_id/decisions/README.md" "$project_page" >/dev/null
grep -F "$project_id/features/README.md" "$project_page" >/dev/null
grep -F "$project_id/specs/README.md" "$project_page" >/dev/null
grep -F "id: project.$project_id.status.current" "$project_status_current" >/dev/null
grep -F "id: project.$project_id.decisions" "$project_decisions_index" >/dev/null
grep -F "id: project.$project_id.features" "$project_features_index" >/dev/null
grep -F "id: project.$project_id.specs" "$project_specs_index" >/dev/null
if grep -F "Project memory scaffold" "$project_features_index" >/dev/null; then
  echo "generic project feature index should not include Lazy Mem-specific rows" >&2
  exit 1
fi
if grep -F "Project memory layers" "$project_specs_index" >/dev/null; then
  echo "generic project spec index should not include Lazy Mem-specific rows" >&2
  exit 1
fi
grep -F "Ready: start your agent from this project root." "$attach_output" >/dev/null
grep -F "Adapters:" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/AGENTS.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/CLAUDE.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/GEMINI.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/AGENT.md" "$attach_output" >/dev/null
grep -F "Supported adapters will point compatible harnesses to .lazy-mem and Lazy Mem system instructions." "$attach_output" >/dev/null
if grep -F "say: hello" "$attach_output" >/dev/null; then
  echo "attach output should not include smoke-test prompt copy" >&2
  exit 1
fi

"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  block_count=$(grep -c "<!-- lazy-mem:start -->" "$tmpdir/example-project/$adapter_file" || true)
  if [ "$block_count" -ne 1 ]; then
    echo "attach duplicated Lazy Mem block in $adapter_file" >&2
    exit 1
  fi
done

mkdir -p "$tmpdir/atomic-before"
for artifact_file in .lazy-mem AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  cp "$tmpdir/example-project/$artifact_file" "$tmpdir/atomic-before/$artifact_file"
done
printf '# Existing Instructions\n\n<!-- lazy-mem:start -->\nmissing end\n' >"$tmpdir/example-project/GEMINI.md"
cp "$tmpdir/example-project/GEMINI.md" "$tmpdir/atomic-before/GEMINI.md"
if "$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$atomic_project_id" >"$tmpdir/atomic.out" 2>"$tmpdir/atomic.err"; then
  echo "attach should fail before writing anything when any adapter is malformed" >&2
  exit 1
fi
grep -F "malformed Lazy Mem block" "$tmpdir/atomic.err" >/dev/null
for artifact_file in .lazy-mem AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  assert_file_unchanged "$tmpdir/atomic-before/$artifact_file" "$tmpdir/example-project/$artifact_file" "$artifact_file"
done
if [ -e "$atomic_project_page" ] || [ -e "$atomic_project_dir" ]; then
  echo "failed attach created project memory for malformed adapter run" >&2
  exit 1
fi
rm -f "$tmpdir/example-project/GEMINI.md"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null

printf '# Existing Instructions\n\n<!-- lazy-mem:start -->\nold block\n<!-- lazy-mem:end -->\n' >"$tmpdir/example-project/CLAUDE.md"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
grep -F "# Existing Instructions" "$tmpdir/example-project/CLAUDE.md" >/dev/null
if grep -F "old block" "$tmpdir/example-project/CLAUDE.md" >/dev/null; then
  echo "attach did not refresh existing Lazy Mem block in CLAUDE.md" >&2
  exit 1
fi
grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/CLAUDE.md" >/dev/null
assert_malformed_adapter_fails "GEMINI.md" "missing-end" '# Existing Instructions\n\n<!-- lazy-mem:start -->\nmissing end\n'
assert_malformed_adapter_fails "GEMINI.md" "end-without-start" '# Existing Instructions\n\n<!-- lazy-mem:end -->\nmissing start\n'
assert_malformed_adapter_fails "GEMINI.md" "duplicate-start" '# Existing Instructions\n\n<!-- lazy-mem:start -->\nfirst\n<!-- lazy-mem:start -->\nsecond\n<!-- lazy-mem:end -->\n'
assert_malformed_adapter_fails "GEMINI.md" "duplicate-end" '# Existing Instructions\n\n<!-- lazy-mem:start -->\nbody\n<!-- lazy-mem:end -->\n<!-- lazy-mem:end -->\n'
assert_malformed_adapter_fails "GEMINI.md" "reversed-markers" '# Existing Instructions\n\n<!-- lazy-mem:end -->\nbody\n<!-- lazy-mem:start -->\n'
assert_malformed_adapter_fails "GEMINI.md" "nested-markers" '# Existing Instructions\n\n<!-- lazy-mem:start -->\nouter\n<!-- lazy-mem:start -->\ninner\n<!-- lazy-mem:end -->\n<!-- lazy-mem:end -->\n'
assert_malformed_adapter_fails "GEMINI.md" "same-line-markers" '# Existing Instructions\n\n<!-- lazy-mem:start --> inline <!-- lazy-mem:end -->\n'
printf 'SENTINEL existing feature index\n' >"$project_features_index"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
grep -F "SENTINEL existing feature index" "$project_features_index" >/dev/null

mkdir -p "$tmpdir/API: Gateway"
"$ROOT/bin/lazy-mem" attach "$tmpdir/API: Gateway" --id "$fresh_project_id" >/dev/null

if [ ! -f "$tmpdir/API: Gateway/AGENTS.md" ]; then
  echo "attach did not create fresh AGENTS.md" >&2
  exit 1
fi

if [ ! -f "$fresh_project_status_current" ]; then
  echo "attach did not create fresh project current status file" >&2
  exit 1
fi

grep -F "<!-- lazy-mem:start -->" "$tmpdir/API: Gateway/AGENTS.md" >/dev/null
grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/API: Gateway/AGENTS.md" >/dev/null
grep -F "<!-- lazy-mem:end -->" "$tmpdir/API: Gateway/AGENTS.md" >/dev/null
grep -F "title: 'API: Gateway Current Status'" "$fresh_project_status_current" >/dev/null

git_project="$tmpdir/git-project"
mkdir -p "$git_project"
git -C "$git_project" init -q
"$ROOT/bin/lazy-mem" attach "$git_project" --id "$git_project_id" >/dev/null
exclude_file="$git_project/.git/info/exclude"
for artifact_file in .lazy-mem AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  grep -Fx "$artifact_file" "$exclude_file" >/dev/null
done
git_status=$(git -C "$git_project" status --short -- .lazy-mem AGENTS.md CLAUDE.md GEMINI.md AGENT.md)
if [ -n "$git_status" ]; then
  echo "Lazy Mem artifacts should be locally excluded from git status" >&2
  printf '%s\n' "$git_status" >&2
  exit 1
fi
"$ROOT/bin/lazy-mem" attach "$git_project" --id "$git_project_id" >/dev/null
for artifact_file in .lazy-mem AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  artifact_count=$(grep -Fx "$artifact_file" "$exclude_file" | wc -l | tr -d ' ')
  if [ "$artifact_count" -ne 1 ]; then
    echo "expected one local exclude entry for $artifact_file, found $artifact_count" >&2
    exit 1
  fi
done

echo "lazy-mem smoke test passed"
