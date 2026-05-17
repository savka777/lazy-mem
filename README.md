# Lazy Mem

Lazy Mem is a central markdown memory repo for agent harnesses.

The V0 idea is simple:

1. Keep durable memory in this folder.
2. Attach any project with a `.lazy-mem` pointer file.
3. Teach any agent to read `.lazy-mem`, then `SYSTEM.md`.
4. Route to the smallest useful memory files instead of preloading everything.
5. Write memory updates as proposals unless the user explicitly asks for direct edits.

## Quick Start

From inside any project:

```bash
/path/to/lazy-mem/bin/lazy-mem attach .
```

Then tell an agent:

```text
Use Lazy Mem.
```

The agent should read the project's `.lazy-mem` pointer, load this repo's `SYSTEM.md`, and follow the routing rules.

## Core Contract

Lazy Mem works with any harness that can read files:

```text
If a project has a .lazy-mem pointer file, read it first.
Then read the central Lazy Mem SYSTEM.md it points to.
Do not preload the whole memory repo.
```
