---
id: project.lazy-mem.status.todo
type: project-status
title: Lazy Mem Todo
project_id: lazy-mem
authority: primary
freshness: 2026-06-15
tags:
  - lazy-mem
  - todo
links_to:
  - project.lazy-mem
  - project.lazy-mem.status.current
  - procedure.memory-growth
---

# Lazy Mem Todo

Back to [Lazy Mem](../../lazy-mem.md).

## Near-Term Product Work

| Item | Status | Notes |
| --- | --- | --- |
| Continuity objective function | active | Optimize for fresh-agent continuation success per unit of context read. |
| Continuity E2E | active proof | Use ordinary prompts, direct memory writes, fresh reader recovery, and a control project. |
| Rework memory write policy | direct-write-only | Memory should grow through safe direct writes; unsafe updates should be asked, skipped, or recorded only as safe blockers. |
| Repo indexing swarm | parked | Useful later, but not part of the continuity proof. |
| Same memory, five agents demo | parked | Wait until single-harness continuity is conclusive. |
| Doctor/status/route commands | parked | Useful later, but not the current goal. |
| Trace helpers | planned later | Keep traces simple; do not make trace work feel like bureaucracy. |
| Harness adapters | implemented for first-class adapters | Codex works through `AGENTS.md`; other harnesses need proof paths later. |
| Dogfood Lazy Mem while building Lazy Mem | active | Use the repo's own memory files during each product session. |

## Local Bases

| Path | Purpose | State |
| --- | --- | --- |
| `/Users/sav/Desktop/Projects/lazy-mem` | Development repo | Self-attached locally; pointer is not committed. |
| `/Users/sav/Documents/lazy-mem` | Live test base | Records memory updates from active Lazy Mem work. |

## Product Notes

- Avoid turning Lazy Mem into review bureaucracy.
- Generated maps, traces, and project status should be direct writes.
- Do not maintain a deferred update queue in the active product model.
- The product should feel like attach and it starts collecting useful context over time.
