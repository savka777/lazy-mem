---
id: project.lazy-mem.status.current
type: project-status
title: Lazy Mem Current Status
project_id: lazy-mem
authority: primary
freshness: 2026-05-25
tags:
  - lazy-mem
  - status
links_to:
  - project.lazy-mem
  - project.lazy-mem.decisions
  - project.lazy-mem.features
  - project.lazy-mem.specs
---

# Lazy Mem Current Status

Back to [Lazy Mem](../../lazy-mem.md).

## Current Focus

- Project attach works through `.lazy-mem` and `AGENTS.md`.
- Casual session startup has been tested with Rex: compatible agents loaded Lazy Mem before replying.
- The current feature is layered project memory: hub first, then status, decisions, features, and specs.

## Active Threads

| Thread | State | Next Read |
| --- | --- | --- |
| Attach onboarding | ready | [Features](../features/README.md) |
| Project memory layers | active | [Specs](../specs/README.md) |
| Agent memory writes | upcoming | [Decisions](../decisions/README.md) |

## Next Useful Reads

| Need | Open | Why |
| --- | --- | --- |
| Durable product choices | [Decisions](../decisions/README.md) | Reuse settled direction. |
| Feature inventory | [Features](../features/README.md) | See what exists and what is next. |
| Deeper project-layer design | [Specs](../specs/README.md) | Understand the layered context model. |

## Update Notes

- Keep this file current when Lazy Mem work resumes or pauses.
- Link out instead of pasting full implementation history here.
