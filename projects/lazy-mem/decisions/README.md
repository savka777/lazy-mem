---
id: project.lazy-mem.decisions
type: project-section
title: Lazy Mem Decisions
project_id: lazy-mem
authority: primary
freshness: 2026-05-25
tags:
  - lazy-mem
  - decisions
links_to:
  - project.lazy-mem
---

# Lazy Mem Decisions

Back to [Lazy Mem](../../lazy-mem.md).

## How To Use

- Capture durable product or technical choices here.
- Keep entries brief unless the decision needs its own file.
- When adding a decision file, add it to the index below.

## Decision Index

| Decision | Date | Status | Notes |
| --- | --- | --- | --- |
| Central memory repo | 2026-05-17 | accepted | Lazy Mem is central and shared, not copied into every project. |
| File-native memory | 2026-05-17 | accepted | Markdown plus git remains the V0 storage model. |
| `.lazy-mem` pointer | 2026-05-17 | accepted | The project pointer file is reserved for attaching projects to memory. |
| `AGENTS.md` bootstrap | 2026-05-25 | accepted | Compatible harnesses should load Lazy Mem from project start. |
| Layered project memory | 2026-05-25 | accepted | Project hub first, then narrow linked files for status, decisions, features, and specs. |
