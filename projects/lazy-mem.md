---
id: project.lazy-mem
type: project
title: Lazy Mem
project_id: lazy-mem
authority: primary
freshness: 2026-05-17
tags:
  - lazy-mem
  - agent-memory
  - markdown
  - graph
links_to:
  - project.lazy-mem.status.current
  - project.lazy-mem.status.todo
  - project.lazy-mem.decisions
  - project.lazy-mem.features
  - project.lazy-mem.specs
  - procedure.memory-growth
  - procedure.code-recall
  - procedure.project-handoff
  - state.current-focus
---

# Lazy Mem

Project memory hub for `lazy-mem`.

## Summary

- Central repo path: `/Users/sav/Desktop/Projects/lazy-mem`
- Core system: markdown + pointers + inferred graph
- Project attachment: `.lazy-mem` pointer files
- Current status: V0 scaffold with attach flow, AGENTS bootstrap, and layered project memory

## Open First

| Need | Open | Why |
| --- | --- | --- |
| Current focus or latest state | [Current Status](lazy-mem/status/current.md) | Active work and next steps |
| Product todo | [Todo](lazy-mem/status/todo.md) | Next product chunks and dogfood notes |
| Durable decisions | [Decisions](lazy-mem/decisions/README.md) | Choices that shape the product |
| Feature context | [Features](lazy-mem/features/README.md) | Work grouped by product surface |
| Specs or design docs | [Specs](lazy-mem/specs/README.md) | Deeper design context |

## Context Index

| Area | Files | Notes |
| --- | --- | --- |
| Status | [Current Status](lazy-mem/status/current.md) | Active Lazy Mem work and recent progress. |
| Todo | [Todo](lazy-mem/status/todo.md) | Product backlog and immediate next chunks. |
| Decisions | [Decisions](lazy-mem/decisions/README.md) | Central repo, markdown-first, and harness behavior decisions. |
| Features | [Features](lazy-mem/features/README.md) | Attach flow, autoload, memory explorer, and project layers. |
| Specs | [Specs](lazy-mem/specs/README.md) | Design notes for larger product chunks. |

## Durable Decisions

- Lazy Mem is central, not copied into each project.
- V0 does not need a server, database, Obsidian plugin, or native harness integration.
- The first product surface is the harness contract plus pointer file.
- Project memory should be layered: project hub first, then narrow linked files.
- Memory should grow directly when updates are clear, useful, low-risk, and easy to inspect.

## Project Notes

- Keep this hub short and link-heavy.
- Move feature, decision, and spec detail into `projects/lazy-mem/`.
- When adding a deeper file, update the nearest section index.
- The dev repo is self-attached locally for dogfooding; the local `.lazy-mem` pointer is not committed.

## Relevant Procedures

- [Code Recall](../procedures/code-recall.md)
- [Project Handoff](../procedures/project-handoff.md)
- [Memory Growth](../procedures/memory-growth.md)
