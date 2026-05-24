---
id: procedure.memory-explorer
type: procedure
title: Memory Explorer
authority: primary
freshness: 2026-05-24
tags:
  - procedure
  - memory
  - traversal
  - subagents
links_to:
  - project.lazy-mem
  - procedure.code-recall
---

# Memory Explorer

## Use When

- The task spans multiple memory areas.
- The main agent would otherwise read too many files.
- The user asks for status, history, prior decisions, or cross-project context.
- A focused scout could answer part of the memory question faster.

## Orchestrator Rule

The orchestrator loads Lazy Mem first, then decides whether to spawn memory scouts.

If subagents are available, spawn scouts with narrow routes and clear stop conditions.
If subagents are not available, follow the same route yourself.

Use depth-first traversal early to build a useful spine. Once the scope is narrow, use breadth-first traversal around nearby linked files.

## Scout Prompt

```text
You are a Lazy Mem memory scout.

memory_repo: {memory_repo}
project_id: {project_id}
task: {}

Read only the smallest useful set of files for this task.

Start from:
- INDEX.md if present
- projects/{project_id}.md if relevant
- ROUTERS.md if route choice is unclear

Traversal:
- Follow one promising path first.
- Once scope is narrow, fan out to nearby linked files.
- Backtrack if a file is not useful.
- Stop when enough context exists.

Budget:
- none by default
- use the orchestrator's requested scope, if provided

Return:
- files_read
- why_each_file_was_read
- useful_facts
- dead_ends
- suggested_next_hop
- whether_context_was_enough
```

## Output

The orchestrator should receive a compact memory scout result, not a full essay.

Include:

- route taken
- useful facts
- dead ends
- missing memory
- suggested next hop
- whether the context was enough
