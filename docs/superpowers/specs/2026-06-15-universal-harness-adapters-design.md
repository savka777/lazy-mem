# Universal Harness Adapters Design

Date: 2026-06-15

## Goal

Make Lazy Mem useful as managed markdown state for memory so a project can attach once and give supported agent harnesses the same first instruction: read `.lazy-mem`, resolve the shared memory repo, load the Lazy Mem system file, and follow its routing rules before answering or doing work.

## Current State

Lazy Mem already has the core memory contract:

- `.lazy-mem` points from a project to a central markdown memory repo.
- `SYSTEM.md` defines the universal read contract.
- `ROUTERS.md` tells agents which memory files to open first.
- `bin/lazy-mem attach` creates `.lazy-mem`, `AGENTS.md`, and project memory scaffolding.
- Tests verify the existing attach flow and Codex `AGENTS.md` autoload path.

The gap is that `attach` currently writes only one harness startup adapter. That proves the Codex path, but it leaves the broader "any harness can attach" goal as documentation rather than product behavior.

## Design

Add a small adapter model around one canonical Lazy Mem bootstrap block.

`lazy-mem attach .` should create or update:

```text
.lazy-mem
AGENTS.md
CLAUDE.md
GEMINI.md
AGENT.md
projects/<project>.md
projects/<project>/status/current.md
projects/<project>/decisions/README.md
projects/<project>/features/README.md
projects/<project>/specs/README.md
```

The adapter files are plain Markdown startup files used by different harnesses. Each file gets the same marked Lazy Mem block:

```text
<!-- lazy-mem:start -->
## Lazy Mem

At the start of a session or task, before replying, check for `.lazy-mem` in this project.
If present, read it as YAML, resolve `memory_repo` and `system_file`, then follow the Lazy Mem system instructions.
This applies even when the user's first message is casual or small.
Do not preload the whole memory repo.
<!-- lazy-mem:end -->
```

The block stays intentionally generic. Harness-specific files differ by filename, not by behavior. The canonical contract remains in `SYSTEM.md`; adapter files only bootstrap the first read.

## Adapter Scope

Initial generated adapters:

| File | Harness family | Confidence |
| --- | --- | --- |
| `AGENTS.md` | Codex and AGENTS-compatible tools | Runtime-probed locally for Codex. |
| `CLAUDE.md` | Claude Code | Supported by upstream docs; runtime probe can be added separately. |
| `GEMINI.md` | Gemini CLI / Gemini Code Assist style context | Supported by upstream docs; runtime probe can be added separately. |
| `AGENT.md` | Gemini Code Assist documented alternate context file | Supported by upstream docs; runtime probe can be added separately. |

This is not a claim that every possible harness has been runtime-probed. It makes attach produce the startup files that known harnesses already look for and creates a clean path to add more adapters.

## CLI Behavior

Keep the `attach` command simple:

```sh
lazy-mem attach [project_path] [--id project-id]
```

For now, attach writes all first-class adapters by default. There is no `--harness` flag in this slice. A registry flag would be useful later, but it adds configuration surface before the default product behavior is solid.

The attach output should list all adapter files it wrote or updated so users can inspect them.

## File Update Rules

Adapter updates should preserve human-written content:

- If the target file does not exist, create it from the Lazy Mem adapter template.
- If the file exists and has no Lazy Mem block, append the block after existing content.
- If the file exists and has one Lazy Mem block, replace only that block with the current template.
- Re-running attach must not duplicate the block.

All adapter files use the same markers, so the update logic can be shared.

## Testing

Add tests before implementation.

Static attach tests should verify:

- `templates/adapter.md` or equivalent canonical adapter template exists.
- `attach` creates `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `AGENT.md`.
- Existing content in each adapter file is preserved.
- Re-running attach does not duplicate the Lazy Mem block.
- Existing Lazy Mem blocks are refreshed from the canonical template.
- Attach output lists all adapters.
- Project memory scaffold behavior remains unchanged.

Runtime tests should keep the existing Codex autoload probe:

- Codex still loads `AGENTS.md`.
- A fresh Codex run in an attached project reads `.lazy-mem`, `SYSTEM.md`, and `ROUTERS.md`.

Claude and Gemini runtime probes are out of this implementation slice unless their CLIs are available and stable in the local environment. Until those probes exist, documentation must say "adapter generated" rather than "runtime verified" for those harnesses.

## Documentation

Update README status and quick start to explain:

- Lazy Mem attaches projects by writing a pointer plus harness startup adapters.
- The managed memory lives in Markdown under the shared memory repo.
- Adapter support means Lazy Mem writes the startup file a harness is expected to read.
- Runtime verification is tracked per harness; Codex is currently probed locally.

Avoid claiming universal runtime proof until each target harness has a test.

## Non-Goals

This slice does not add:

- A database, daemon, server, or Obsidian plugin.
- A dynamic harness registry.
- Harness-specific divergent instructions.
- Automatic runtime tests for CLIs that are not installed locally.
- Any memory preloading behavior.

## Success Criteria

This design is complete when:

- `attach` writes `.lazy-mem` and all four first-class adapter files.
- Adapter file updates are idempotent and preserve existing user content.
- The Lazy Mem bootstrap block remains canonical and shared.
- Tests cover creation, preservation, refresh, no duplication, and attach output.
- Existing Codex autoload verification still passes.
- README describes the adapter model without overstating unprobed harnesses.

