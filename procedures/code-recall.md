---
id: procedure.code-recall
type: procedure
title: Code Recall
authority: primary
freshness: 2026-05-17
tags:
  - procedure
  - code
  - recall
links_to:
  - project.lazy-mem
---

# Code Recall

## Use When

- Resuming work in a codebase.
- Explaining project state.
- Looking for prior decisions or gotchas.
- Measuring files read and rough context spend.

## Steps

1. Read the project's `.lazy-mem` pointer.
2. Load central `SYSTEM.md`.
3. Read `ROUTERS.md`.
4. Read the matching `projects/<project_id>.md` file if present.
5. Search the target project with `rg --files` and focused `rg` queries.
6. Read only files that answer the current question.
7. Stop when enough context exists.
8. Record a read trace if Lazy Mem materially helped.

## Output

Report:

- files read
- why they were read
- answer or action taken
- missing memory that should be written directly if it is safe
