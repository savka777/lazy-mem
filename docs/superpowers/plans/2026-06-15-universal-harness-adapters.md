# Universal Harness Adapters Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `lazy-mem attach` create a `.lazy-mem` pointer plus first-class Markdown startup adapters so supported harnesses begin by reading Lazy Mem instructions.

**Architecture:** Keep the implementation POSIX shell and template-driven. Replace the single-purpose `write_agents_md` function with a generic adapter-block writer that applies one canonical `templates/adapter.md` file to `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `AGENT.md`.

**Tech Stack:** POSIX `sh`, `sed`, `awk`, `grep`, Markdown templates, existing shell smoke tests.

---

## File Structure

- Create `templates/adapter.md`: canonical Lazy Mem bootstrap block shared by all adapter files.
- Modify `templates/AGENTS.md`: replace its content with the same canonical Lazy Mem bootstrap block as `templates/adapter.md` so older references remain consistent.
- Modify `bin/lazy-mem`: add an adapter filename list, generic adapter writer, malformed marker detection, and multi-adapter attach output.
- Modify `tests/smoke.sh`: add failing tests first for adapter template existence, file creation, preservation, idempotency, refresh, malformed markers, and output.
- Modify `README.md`: describe the pointer plus adapter model without claiming unprobed runtime support.
- Keep `tests/codex-agents-autoload.sh`: unchanged; it continues verifying Codex through `AGENTS.md`.

## Task 1: Expand Smoke Tests For Adapter Creation And Output

**Files:**
- Modify: `tests/smoke.sh`

- [ ] **Step 1: Write the failing test**

In `tests/smoke.sh`, add `templates/adapter.md` to the static file assertions near the current `templates/AGENTS.md` check:

```sh
assert_file "templates/adapter.md"
```

In the first attach scenario, add adapter existence checks after the existing `AGENTS.md` check:

```sh
for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  if [ ! -f "$tmpdir/example-project/$adapter_file" ]; then
    echo "attach did not create $adapter_file" >&2
    exit 1
  fi
done
```

Add content checks for each adapter after the current `AGENTS.md` Lazy Mem block checks:

```sh
for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  grep -F "<!-- lazy-mem:start -->" "$tmpdir/example-project/$adapter_file" >/dev/null
  grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/$adapter_file" >/dev/null
  grep -F "<!-- lazy-mem:end -->" "$tmpdir/example-project/$adapter_file" >/dev/null
done
```

Replace the attach output assertion:

```sh
grep -F "Compatible agents will read AGENTS.md, follow .lazy-mem, and load $ROOT/SYSTEM.md." "$attach_output" >/dev/null
```

with:

```sh
grep -F "Adapters:" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/AGENTS.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/CLAUDE.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/GEMINI.md" "$attach_output" >/dev/null
grep -F "$tmpdir/example-project/AGENT.md" "$attach_output" >/dev/null
grep -F "Supported adapters will point compatible harnesses to .lazy-mem and Lazy Mem system instructions." "$attach_output" >/dev/null
```

- [ ] **Step 2: Run the test to verify it fails**

Run:

```sh
./tests/smoke.sh
```

Expected: FAIL with `missing file: templates/adapter.md` or a missing adapter file assertion.

- [ ] **Step 3: Stop**

Do not change production code in this task. Do not commit failing tests. Continue directly to Task 2.

## Task 2: Add Canonical Adapter Template And Generic Writer

**Files:**
- Create: `templates/adapter.md`
- Modify: `bin/lazy-mem`
- Test: `tests/smoke.sh`

- [ ] **Step 1: Create the canonical adapter template**

Create `templates/adapter.md` with exactly:

```md
<!-- lazy-mem:start -->
## Lazy Mem

At the start of a session or task, before replying, check for `.lazy-mem` in this project.
If present, read it as YAML, resolve `memory_repo` and `system_file`, then follow the Lazy Mem system instructions.
This applies even when the user's first message is casual or small.
Do not preload the whole memory repo.
<!-- lazy-mem:end -->
```

- [ ] **Step 2: Add adapter constants and malformed marker detection**

In `bin/lazy-mem`, near the existing helper functions, add:

```sh
ADAPTER_FILES="AGENTS.md CLAUDE.md GEMINI.md AGENT.md"
ADAPTER_TEMPLATE="$MEMORY_REPO/templates/adapter.md"
START_MARKER='<!-- lazy-mem:start -->'
END_MARKER='<!-- lazy-mem:end -->'
```

Add this helper before the adapter writer:

```sh
count_marker() {
  marker=$1
  file=$2
  grep -F -c "$marker" "$file" 2>/dev/null || true
}
```

- [ ] **Step 3: Replace `write_agents_md` with a generic adapter writer**

Replace the whole `write_agents_md()` function with:

```sh
write_adapter_file() {
  adapter_file=$1
  tmp_file="$adapter_file.tmp.$$"

  if [ -f "$adapter_file" ]; then
    start_count=$(count_marker "$START_MARKER" "$adapter_file")
    end_count=$(count_marker "$END_MARKER" "$adapter_file")

    if [ "$start_count" -eq 0 ] && [ "$end_count" -eq 0 ]; then
      {
        cat "$adapter_file"
        printf '\n\n'
        cat "$ADAPTER_TEMPLATE"
      } >"$tmp_file"
    elif [ "$start_count" -eq 1 ] && [ "$end_count" -eq 1 ]; then
      awk -v start="$START_MARKER" -v end="$END_MARKER" -v template="$ADAPTER_TEMPLATE" '
        function print_template() {
          while ((getline line < template) > 0) {
            print line
          }
          close(template)
        }
        $0 == start {
          print_template()
          in_lazy_mem_block = 1
          seen_start = 1
          next
        }
        in_lazy_mem_block && $0 == end {
          in_lazy_mem_block = 0
          seen_end = 1
          next
        }
        !in_lazy_mem_block {
          print
        }
        END {
          if (!seen_start || !seen_end || in_lazy_mem_block) {
            exit 2
          }
        }
      ' "$adapter_file" >"$tmp_file" || {
        rm -f "$tmp_file"
        die "malformed Lazy Mem block in $adapter_file"
      }
    else
      die "malformed Lazy Mem block in $adapter_file"
    fi
  else
    cat "$ADAPTER_TEMPLATE" >"$tmp_file"
  fi

  mv "$tmp_file" "$adapter_file"
}
```

- [ ] **Step 4: Write all adapters during attach**

In `attach()`, replace:

```sh
agents_file="$project_abs/AGENTS.md"
```

with:

```sh
adapters_written=
```

Replace:

```sh
write_agents_md "$agents_file"
```

with:

```sh
for adapter_name in $ADAPTER_FILES; do
  adapter_file="$project_abs/$adapter_name"
  write_adapter_file "$adapter_file"
  adapters_written="${adapters_written}${adapter_file}
"
done
```

Replace the output lines:

```sh
echo "Agents: $agents_file"
echo "System: $MEMORY_REPO/SYSTEM.md"
echo
echo "Ready: start your agent from this project root."
echo "Compatible agents will read AGENTS.md, follow .lazy-mem, and load $MEMORY_REPO/SYSTEM.md."
```

with:

```sh
echo "Adapters:"
printf '%s' "$adapters_written" | while IFS= read -r adapter_file; do
  [ -n "$adapter_file" ] && echo "  - $adapter_file"
done
echo "System: $MEMORY_REPO/SYSTEM.md"
echo
echo "Ready: start your agent from this project root."
echo "Supported adapters will point compatible harnesses to .lazy-mem and Lazy Mem system instructions."
```

- [ ] **Step 5: Run test to verify it passes**

Run:

```sh
./tests/smoke.sh
```

Expected: PASS with `lazy-mem smoke test passed`.

- [ ] **Step 6: Commit**

```sh
git add templates/adapter.md bin/lazy-mem tests/smoke.sh
git commit -m "feat: generate harness adapter files"
```

## Task 3: Add Tests For Idempotency, Refresh, And Malformed Markers

**Files:**
- Modify: `tests/smoke.sh`
- Modify: `bin/lazy-mem`

- [ ] **Step 1: Write failing tests for idempotency across every adapter**

Replace the current `AGENTS.md` duplicate-count check with:

```sh
for adapter_file in AGENTS.md CLAUDE.md GEMINI.md AGENT.md; do
  block_count=$(grep -c "<!-- lazy-mem:start -->" "$tmpdir/example-project/$adapter_file" || true)
  if [ "$block_count" -ne 1 ]; then
    echo "attach duplicated Lazy Mem block in $adapter_file" >&2
    exit 1
  fi
done
```

- [ ] **Step 2: Write failing test for refreshing an existing block**

After the duplicate-count loop, add:

```sh
printf '# Existing Instructions\n\n<!-- lazy-mem:start -->\nold block\n<!-- lazy-mem:end -->\n' >"$tmpdir/example-project/CLAUDE.md"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
grep -F "# Existing Instructions" "$tmpdir/example-project/CLAUDE.md" >/dev/null
grep -F "old block" "$tmpdir/example-project/CLAUDE.md" >/dev/null && {
  echo "attach did not refresh existing Lazy Mem block in CLAUDE.md" >&2
  exit 1
}
grep -F "At the start of a session or task, before replying, check for \`.lazy-mem\` in this project." "$tmpdir/example-project/CLAUDE.md" >/dev/null
```

- [ ] **Step 3: Write failing test for malformed markers leaving files unchanged**

After the refresh test, add:

```sh
malformed_before="$tmpdir/malformed-before.txt"
printf '# Existing Instructions\n\n<!-- lazy-mem:start -->\nmissing end\n' >"$tmpdir/example-project/GEMINI.md"
cp "$tmpdir/example-project/GEMINI.md" "$malformed_before"
if "$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >"$tmpdir/malformed.out" 2>"$tmpdir/malformed.err"; then
  echo "attach should fail on malformed Lazy Mem markers" >&2
  exit 1
fi
grep -F "malformed Lazy Mem block" "$tmpdir/malformed.err" >/dev/null
cmp "$malformed_before" "$tmpdir/example-project/GEMINI.md" >/dev/null
rm -f "$tmpdir/example-project/GEMINI.md"
"$ROOT/bin/lazy-mem" attach "$tmpdir/example-project" --id "$project_id" >/dev/null
```

- [ ] **Step 4: Run test to verify behavior**

Run:

```sh
./tests/smoke.sh
```

Expected: PASS if Task 2 already satisfies idempotency, refresh, and malformed-marker behavior. If it fails, the failure must identify the missing behavior before implementation is changed.

- [ ] **Step 5: Fix implementation after a failing behavior check**

If the malformed marker test fails, update `write_adapter_file()` so it checks marker counts before writing and removes any temp file before `die`. If the refresh test fails, update the single-block `awk` branch so it replaces the old block with `templates/adapter.md` and preserves text outside the markers. If the idempotency test fails, update the attach loop so each adapter is passed to `write_adapter_file()` exactly once per run.

- [ ] **Step 6: Run test to verify it passes**

Run:

```sh
./tests/smoke.sh
```

Expected: PASS with `lazy-mem smoke test passed`.

- [ ] **Step 7: Commit**

```sh
git add tests/smoke.sh bin/lazy-mem
git commit -m "test: cover adapter refresh and marker failures"
```

## Task 4: Update README For Adapter Model

**Files:**
- Modify: `README.md`
- Test: `tests/smoke.sh`

- [ ] **Step 1: Write failing documentation assertions**

In `tests/smoke.sh`, near the README assertions, add:

```sh
assert_contains "README.md" "harness startup adapters"
assert_contains "README.md" "AGENTS.md"
assert_contains "README.md" "CLAUDE.md"
assert_contains "README.md" "GEMINI.md"
assert_contains "README.md" "AGENT.md"
assert_contains "README.md" "Codex runtime-probed through \`AGENTS.md\`."
assert_contains "README.md" "Generated adapters are not the same as runtime proof for every harness."
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```sh
./tests/smoke.sh
```

Expected: FAIL on the first missing README phrase.

- [ ] **Step 3: Update quick start output block**

In `README.md`, replace the quick start file list:

```text
.lazy-mem
AGENTS.md
shared-memory/projects/<project>.md
shared-memory/projects/<project>/status/current.md
shared-memory/projects/<project>/decisions/README.md
shared-memory/projects/<project>/features/README.md
shared-memory/projects/<project>/specs/README.md
```

with:

```text
.lazy-mem
AGENTS.md
CLAUDE.md
GEMINI.md
AGENT.md
shared-memory/projects/<project>.md
shared-memory/projects/<project>/status/current.md
shared-memory/projects/<project>/decisions/README.md
shared-memory/projects/<project>/features/README.md
shared-memory/projects/<project>/specs/README.md
```

- [ ] **Step 4: Update explanatory copy**

Replace:

```md
`AGENTS.md` gives compatible harnesses a small bootstrap instruction: check for `.lazy-mem`, read the Lazy Mem system instructions, follow the routers, and load only the memory needed for the task.
```

with:

```md
The harness startup adapters give compatible tools a small bootstrap instruction: check for `.lazy-mem`, read the Lazy Mem system instructions, follow the routers, and load only the memory needed for the task.
```

Add this paragraph near the status section:

```md
Adapter generation is tracked separately from runtime proof. Codex is runtime-probed through `AGENTS.md`. `CLAUDE.md`, `GEMINI.md`, and `AGENT.md` are generated for harnesses that document those startup files, but generated adapters are not the same as runtime proof for every harness.
```

- [ ] **Step 5: Run test to verify it passes**

Run:

```sh
./tests/smoke.sh
```

Expected: PASS with `lazy-mem smoke test passed`.

- [ ] **Step 6: Commit**

```sh
git add README.md tests/smoke.sh
git commit -m "docs: describe harness adapter support"
```

## Task 5: Run Runtime Verification

**Files:**
- Test only: `tests/codex-agents-autoload.sh`

- [ ] **Step 1: Run static smoke test**

Run:

```sh
./tests/smoke.sh
```

Expected: `lazy-mem smoke test passed`.

- [ ] **Step 2: Run Codex autoload integration probe**

Run:

```sh
./tests/codex-agents-autoload.sh
```

Expected: `codex AGENTS.md autoload test passed`.

- [ ] **Step 3: Check git status**

Run:

```sh
git status --short --branch
```

Expected: clean working tree on the implementation branch, ahead by the new commits.

- [ ] **Step 4: Commit only if verification caused intentional file changes**

No commit is needed after this task because the verification scripts clean up their temporary files.

## Task 6: Update Lazy Mem Project Memory

**Files:**
- Modify: `/Users/sav/Documents/lazy-mem/projects/lazy-mem/status/current.md`
- Modify: `/Users/sav/Documents/lazy-mem/projects/lazy-mem/status/todo.md`

- [ ] **Step 1: Update current status**

Add one dated bullet to `status/current.md`:

```md
- Universal harness adapters implementation landed on 2026-06-15: `attach` now writes `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `AGENT.md` from one canonical bootstrap template, with malformed marker protection and Codex runtime verification.
```

- [ ] **Step 2: Update todo row**

Change the `Universal harness attach/read proof` row status from `design review` to `implemented for first-class adapters`.

- [ ] **Step 3: Verify memory diff**

Run:

```sh
git -C /Users/sav/Documents/lazy-mem diff -- projects/lazy-mem/status/current.md projects/lazy-mem/status/todo.md
```

Expected: only the status/todo updates for this adapter implementation.
