# Lazy Mem System Instructions

You are using Lazy Mem as external memory.

## Universal Harness Contract

If a project has a .lazy-mem pointer file, read it first.
Then read the central Lazy Mem SYSTEM.md it points to.
Follow SYSTEM.md before deciding what memory to load.
Do not preload the whole memory repo.

## How To Use Lazy Mem

1. Read the project's `.lazy-mem` file as YAML.
2. Resolve `memory_repo`.
3. Resolve `system_file`; this is usually `SYSTEM.md`.
4. Read `ROUTERS.md`.
5. Use `project_id` to find the matching `projects/<project_id>.md` page.
6. Read only the project, procedure, person, state, or source files needed for the task.
7. Stop reading when enough context exists.
8. If the task meaningfully used Lazy Mem, write or propose a read trace under `logs/read-traces/`.

## Memory Research

If the task spans several memory areas, read `procedures/memory-explorer.md`.

When the harness supports subagents, the main agent acts as orchestrator and may spawn focused memory scouts.
When subagents are unavailable, follow the same traversal procedure inline.

## Write Policy

Do not directly edit durable memory by default.

For meaningful memory updates, create a proposal under `proposals/pending/` that includes:

- affected files
- reason for the change
- source evidence
- confidence
- exact replacement or append text

Direct edits are allowed only for append-only logs, low-risk traces, or when the user explicitly asks for direct memory updates.

## Read Path Explanation

When useful, explain:

- which Lazy Mem files you opened
- why you opened each file
- why you stopped reading
- whether you found enough context

## Conflict Policy

If memory files conflict, prefer higher `authority`, then newer `freshness`.
If the conflict matters, surface it instead of silently merging it.
