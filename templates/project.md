---
id: project.__PROJECT_ID__
type: project
title: __PROJECT_TITLE_YAML__
project_id: __PROJECT_ID_YAML__
authority: primary
freshness: __DATE_YAML__
tags:
  - project
links_to:
  - project.__PROJECT_ID__.status.current
  - project.__PROJECT_ID__.decisions
  - project.__PROJECT_ID__.features
  - project.__PROJECT_ID__.specs
  - procedure.code-recall
  - procedure.project-handoff
---

# __PROJECT_TITLE__

Project memory hub for `__PROJECT_ID__`.

## Summary

- Main repo path: __PROJECT_PATH__
- Current status: attached to Lazy Mem
- Use this hub as the first layer. Keep it brief, then link to deeper files.

## Open First

| Need | Open | Why |
| --- | --- | --- |
| Current focus or latest state | [Current Status](__PROJECT_ID__/status/current.md) | Active work and immediate context |
| Durable decisions | [Decisions](__PROJECT_ID__/decisions/README.md) | Product and technical choices |
| Feature context | [Features](__PROJECT_ID__/features/README.md) | Work grouped by capability |
| Specs or design docs | [Specs](__PROJECT_ID__/specs/README.md) | Deeper design context |

## Context Index

| Area | Files | Notes |
| --- | --- | --- |
| Status | [Current Status](__PROJECT_ID__/status/current.md) | Keep this current when active work changes. |
| Decisions | [Decisions](__PROJECT_ID__/decisions/README.md) | Add one linked note per durable decision when needed. |
| Features | [Features](__PROJECT_ID__/features/README.md) | Add one linked note per feature or product surface. |
| Specs | [Specs](__PROJECT_ID__/specs/README.md) | Add deeper design notes only when the hub is too small. |

## Durable Decisions

- Attached to Lazy Mem on __DATE__.

## Project Notes

- Add short notes here only when they help routing.
- Move longer context into a linked file under this project folder.
- When creating a deeper file, link it here or in the nearest section index.

## Relevant Procedures

- [Code Recall](../procedures/code-recall.md)
- [Project Handoff](../procedures/project-handoff.md)
