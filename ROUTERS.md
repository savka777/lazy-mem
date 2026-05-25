# Lazy Mem Routers

Read this file after `SYSTEM.md`.

## Standard Route

1. Identify the current project from `.lazy-mem` `project_id`.
2. Read `projects/<project_id>.md` if it exists.
3. Use the project hub as the first layer.
4. Follow only the `Open First` or `Context Index` links that match the task.
5. Read `state/current-focus.md` if the task concerns active work or priorities outside the project hub.
6. Read `state/active-projects.md` if the task spans projects.
7. Read procedures only when the task matches a procedure trigger.
8. Read people files only when user preferences, identity, or relationship context matters.
9. Read sources only when evidence or citation is needed.
10. Stop reading once enough context exists.

## Project Layer Routes

| Route | Use When | Stop Condition |
| --- | --- | --- |
| `projects/<project_id>.md` | Starting any project-specific task | The hub gives enough context or points to one useful next file. |
| `projects/<project_id>/status/current.md` | Needing current focus, active threads, blockers, or next steps | You know what is active now. |
| `projects/<project_id>/decisions/README.md` | Needing durable choices or rejected approaches | You found the relevant decision or confirmed none is listed. |
| `projects/<project_id>/features/README.md` | Working on a feature or product surface | You found the feature row or a linked feature note. |
| `projects/<project_id>/specs/README.md` | Needing deeper design context | You found the relevant spec or confirmed the hub is enough. |

If a route does not answer the task, backtrack to the project hub before opening a broader area.

## Routing Rules

- Read projects/ before procedures/ when project_id is known.
- Read project hubs before project section indexes.
- Read routers and summaries before payload-like files.
- Prefer primary authority before secondary authority.
- Prefer fresh files before stale files when authority is equal.
- Do not preload the whole memory repo.
- Track why each file was opened.

## Procedure Triggers

Read `procedures/code-recall.md` when:

- resuming code work
- explaining a codebase
- debugging prior implementation choices
- measuring recall or context usage

Read `procedures/project-handoff.md` when:

- preparing a handoff
- summarizing current status
- pausing work for another agent
- creating a plan from project memory

Read `procedures/memory-explorer.md` when:

- the task spans multiple memory areas
- answering would require reading too many files in the main context
- subagents can scout project, trace, person, source, or procedure memory
- the user asks for status, history, prior decisions, or cross-project context
