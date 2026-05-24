# Lazy Mem Routers

Read this file after `SYSTEM.md`.

## Standard Route

1. Identify the current project from `.lazy-mem` `project_id`.
2. Read `projects/<project_id>.md` if it exists.
3. Read `state/current-focus.md` if the task concerns active work or priorities.
4. Read `state/active-projects.md` if the task spans projects.
5. Read procedures only when the task matches a procedure trigger.
6. Read people files only when user preferences, identity, or relationship context matters.
7. Read sources only when evidence or citation is needed.
8. Stop reading once enough context exists.

## Routing Rules

- Read projects/ before procedures/ when project_id is known.
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
