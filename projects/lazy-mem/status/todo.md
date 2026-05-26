---
id: project.lazy-mem.status.todo
type: project-status
title: Lazy Mem Todo
project_id: lazy-mem
authority: primary
freshness: 2026-05-26
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
| Rework memory write policy | active | Memory should grow over time without making proposals the default path. |
| Repo indexing swarm | next | Create a procedure for mapping existing large repos with many focused agents. |
| Same memory, five agents demo | planned | Prove cross-harness continuity with less re-explaining. |
| Doctor/status/route commands | planned | Make the protocol executable and debuggable. |
| Trace and proposal helpers | planned | Keep traces/proposals consistent when they are needed. |
| Harness adapters | planned | Codex works through `AGENTS.md`; other harnesses need proof paths. |
| Dogfood Lazy Mem while building Lazy Mem | active | Use the repo's own memory files during each product session. |

## Local Bases

| Path | Purpose | State |
| --- | --- | --- |
| `/Users/sav/Desktop/Projects/lazy-mem` | Development repo | Self-attached locally; pointer is not committed. |
| `/Users/sav/Documents/lazy-mem` | Live test base | Clean clone of merged `main` at `03f1430`. |

## Product Notes

- Avoid turning Lazy Mem into review bureaucracy.
- Generated maps, traces, and project status should be direct writes.
- Proposals should be exceptional, bundled when related, and resolved or archived instead of sitting forever.
- The product should feel like attach and it starts collecting useful context over time.
