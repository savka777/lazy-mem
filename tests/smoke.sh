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

assert_file "README.md"
assert_file "SYSTEM.md"
assert_file "RULES.md"
assert_file "ROUTERS.md"
assert_file "lazy-mem.yaml"
assert_file "bin/lazy-mem"
assert_file "tests/codex-agents-autoload.sh"
assert_file "templates/AGENTS.md"
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
assert_file "proposals/README.md"
assert_file "proposals/archive/README.md"
assert_file "logs/README.md"
assert_file "benchmarks/README.md"
assert_file "lazy-cache/README.md"

assert_dir "proposals/pending"
assert_dir "proposals/archive"
assert_dir "logs/read-traces"
assert_dir "logs/write-traces"
assert_dir "logs/experiments"

assert_executable "bin/lazy-mem"
assert_executable "tests/codex-agents-autoload.sh"

assert_contains "SYSTEM.md" "If a project has a .lazy-mem pointer file, read it first."
assert_contains "SYSTEM.md" "Do not preload the whole memory repo."
assert_contains "SYSTEM.md" "Project memory is layered."
assert_contains "SYSTEM.md" "Memory should grow over time."
assert_contains "SYSTEM.md" 'If the task spans several memory areas, read `procedures/memory-explorer.md`.'
assert_not_contains "SYSTEM.md" "Do not directly edit durable memory by default."
assert_contains "ROUTERS.md" "Read projects/ before procedures/ when project_id is known."
assert_contains "ROUTERS.md" "Use the project hub as the first layer."
assert_contains "ROUTERS.md" 'Read `procedures/memory-growth.md` when:'
assert_contains "ROUTERS.md" 'Read `procedures/memory-explorer.md` when:'
assert_contains "RULES.md" "Memory should grow over time."
assert_contains "RULES.md" "Use proposals when the change is uncertain, conflicting, broad, destructive, or explicitly requested for review."
assert_not_contains "RULES.md" "Do not directly edit durable memory by default."
assert_contains "proposals/README.md" "Proposals are exceptional."
assert_contains "proposals/README.md" "Do not let proposals become a permanent backlog."
assert_not_contains "proposals/README.md" "Agents should create proposals instead of directly editing durable memory"
assert_contains "lazy-mem.yaml" "schema_version: 0.1.0"
assert_contains "lazy-mem.yaml" "cache: lazy-cache"
assert_contains "lazy-mem.yaml" "durable_memory_default: direct_when_clear"
assert_contains "lazy-mem.yaml" "pending_proposals_are_backlog: false"
assert_contains "procedures/memory-explorer.md" "task: {}"
assert_contains "procedures/memory-explorer.md" "- none by default"
assert_contains "procedures/memory-growth.md" "Default to useful memory growth."
assert_contains "procedures/memory-growth.md" "Pending proposals are not a backlog."

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

cleanup() {
  rm -rf "$tmpdir"
  rm -f "$project_page"
  rm -rf "$project_dir"
  rm -f "$fresh_project_page"
  rm -rf "$fresh_project_dir"
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

grep -F "memory_repo: $ROOT" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "project_id: $project_id" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "system_file: SYSTEM.md" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "# Existing Instructions" "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "Keep this line." "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "<!-- lazy-mem:start -->" "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/AGENTS.md" >/dev/null
grep -F "<!-- lazy-mem:end -->" "$tmpdir/example-project/AGENTS.md" >/dev/null
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
grep -F "Compatible agents will read AGENTS.md, follow .lazy-mem, and load $ROOT/SYSTEM.md." "$attach_output" >/dev/null
if grep -F "say: hello" "$attach_output" >/dev/null; then
  echo "attach output should not include smoke-test prompt copy" >&2
  exit 1
fi

"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
agents_block_count=$(grep -c "<!-- lazy-mem:start -->" "$tmpdir/example-project/AGENTS.md" || true)
if [ "$agents_block_count" -ne 1 ]; then
  echo "attach duplicated Lazy Mem AGENTS.md block" >&2
  exit 1
fi
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

echo "lazy-mem smoke test passed"
