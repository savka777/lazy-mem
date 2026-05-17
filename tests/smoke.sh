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
  if ! grep -F "$pattern" "$ROOT/$file" >/dev/null 2>&1; then
    echo "expected '$file' to contain: $pattern" >&2
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
assert_file "templates/project-pointer.yaml"
assert_file "templates/project.md"
assert_file "projects/_template.md"
assert_file "projects/lazy-mem.md"
assert_file "people/_template.md"
assert_file "people/sav.md"
assert_file "procedures/_template.md"
assert_file "procedures/code-recall.md"
assert_file "procedures/project-handoff.md"
assert_file "state/current-focus.md"
assert_file "state/active-projects.md"
assert_file "sources/README.md"
assert_file "proposals/README.md"
assert_file "logs/README.md"
assert_file "benchmarks/README.md"
assert_file ".lazy-mem/README.md"

assert_dir "proposals/pending"
assert_dir "logs/read-traces"
assert_dir "logs/write-traces"
assert_dir "logs/experiments"

assert_executable "bin/lazy-mem"

assert_contains "SYSTEM.md" "If a project has a .lazy-mem pointer file, read it first."
assert_contains "SYSTEM.md" "Do not preload the whole memory repo."
assert_contains "ROUTERS.md" "Read projects/ before procedures/ when project_id is known."
assert_contains "RULES.md" "Do not directly edit durable memory by default."
assert_contains "lazy-mem.yaml" "schema_version: 0.1.0"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"; rm -f "$ROOT/projects/example-project.md"' EXIT

mkdir -p "$tmpdir/example-project"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id example-project >/dev/null

if [ ! -f "$tmpdir/example-project/.lazy-mem" ]; then
  echo "attach did not create .lazy-mem pointer" >&2
  exit 1
fi

grep -F "memory_repo: $ROOT" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "project_id: example-project" "$tmpdir/example-project/.lazy-mem" >/dev/null
grep -F "system_file: SYSTEM.md" "$tmpdir/example-project/.lazy-mem" >/dev/null

echo "lazy-mem smoke test passed"
