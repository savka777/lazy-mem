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
  - procedure.code-recall
  - procedure.project-handoff
  - state.current-focus
---

# Lazy Mem

Lazy Mem is a central markdown memory repo for agent harnesses.

## Current Shape

- Central repo path: `/Users/sav/Desktop/Projects/lazy-mem`
- Core system: markdown + pointers + inferred graph
- Project attachment: `.lazy-mem` pointer files
- First helper command: `bin/lazy-mem attach`

## V0 Goal

Build a scaffold that lets any agent harness:

1. discover `.lazy-mem`
2. load central `SYSTEM.md`
3. route to project memory
4. avoid preloading the whole repo
5. write traces and proposals

## Durable Decisions

- Lazy Mem is central, not copied into each project.
- V0 does not need a server, database, Obsidian plugin, or native harness integration.
- The first product surface is the harness contract plus pointer file.

## Relevant Procedures

- [[Code Recall]]
- [[Project Handoff]]
