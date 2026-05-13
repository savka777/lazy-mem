# Lazy Mem V0 Design

## Purpose

Lazy Mem V0 is a central markdown memory repo that agents can attach to while working in any project.

The core system is:

- markdown as the durable human-readable memory surface
- pointer files inside projects to tell agents where the central memory repo lives
- an inferred graph built from frontmatter, wikilinks, tags, and project IDs
- proposal-based writes so agents do not silently mutate durable memory
- read/write traces so recall quality and token spend can be measured later

V0 is not a UI, database, Obsidian plugin, SaaS backend, or generic graph visualization tool.

## V0 Thesis

V0 is not primarily about making users initialize memory from scratch. The central Lazy Mem folder is already the installed memory system.

The hard problem is simpler and more important:

> Any agent harness should be able to discover Lazy Mem, read the system instructions, and use the central markdown memory without special integration.

That means V0 should optimize for a universal harness contract:

```text
If a project has a .lazy-mem pointer file, read it first.
Then read the central Lazy Mem SYSTEM.md it points to.
Follow SYSTEM.md before deciding what memory to load.
Do not preload the whole memory repo.
```

## Product Shape

The central repo lives at:

```text
/Users/sav/Desktop/Projects/lazy-mem
```

Any project can opt in with a small pointer file:

```text
.lazy-mem
```

The pointer file contains:

```yaml
memory_repo: /Users/sav/Desktop/Projects/lazy-mem
project_id: example-project
system_file: SYSTEM.md
```

When an agent starts work inside a project, it can read `.lazy-mem`, load the central `SYSTEM.md`, then route into only the relevant Lazy Mem files.

## Setup And Attachment Flow

The nicest V0 install path should feel like:

1. User downloads, clones, or saves the Lazy Mem folder somewhere stable.
2. Lazy Mem already contains the central scaffold and `SYSTEM.md`.
3. User runs one attach command inside any project.
4. The attach command writes a `.lazy-mem` pointer file.
5. Any harness can now use Lazy Mem by following the pointer.

The attach command should be:

```bash
/path/to/lazy-mem/bin/lazy-mem attach .
```

It should create this file in the current project:

```text
.lazy-mem
```

With content like:

```yaml
memory_repo: /Users/sav/Desktop/Projects/lazy-mem
project_id: example-project
system_file: SYSTEM.md
```

The attach command may also offer to create a central project memory page at:

```text
projects/example-project.md
```

But creating that page is secondary. The essential V0 behavior is the pointer plus the harness instructions.

## Harness Contract

Lazy Mem should work with Codex, Claude, Pi, Cursor, or any other agent that can read files.

The universal instruction for a harness is:

```text
Before working in a project, check whether `.lazy-mem` exists in the project root.
If it exists, read it as YAML.
Then read `${memory_repo}/${system_file}`.
Follow those Lazy Mem system instructions before answering or editing files.
```

The harness does not need a plugin, API key, server, database, or native Lazy Mem integration.

For V0, the user-facing invocation can be as simple as:

```text
Use Lazy Mem.
```

The agent should interpret that as:

1. Find `.lazy-mem`.
2. Load central `SYSTEM.md`.
3. Read only the routed memory needed for the task.
4. Explain the Lazy Mem read path if useful.
5. Write traces and proposals according to `SYSTEM.md`.

## Repository Scaffold

V0 should create this central repo structure:

```text
README.md
SYSTEM.md
RULES.md
ROUTERS.md
lazy-mem.yaml

projects/
  _template.md
  lazy-mem.md

people/
  _template.md
  sav.md

procedures/
  _template.md
  code-recall.md
  project-handoff.md

state/
  current-focus.md
  active-projects.md

sources/
  README.md

proposals/
  README.md
  pending/

logs/
  README.md
  read-traces/
  write-traces/
  experiments/

benchmarks/
  README.md

.lazy-mem/
  README.md

bin/
  lazy-mem

templates/
  project-pointer.yaml
  project.md
```

The visible folders should feel like a normal markdown memory workspace. Graph machinery stays implicit or inside `.lazy-mem/`.

## Core Files

`SYSTEM.md` is the first file agents read. It explains how to use Lazy Mem from any project, how to follow pointers, how to route reads, and how to write proposals.

`RULES.md` defines memory safety rules: do not overwrite durable truth without a proposal, keep temporary state separate, preserve source references, and surface contradictions.

`ROUTERS.md` is the top-level routing map. It tells agents when to read `projects/`, `people/`, `procedures/`, `state/`, `sources/`, `proposals/`, and `logs/`.

`lazy-mem.yaml` defines the repo schema, version, pointer convention, canonical folders, and trace policy.

`projects/*.md` files are project memory pages. They hold project identity, current architecture, key commands, durable decisions, known gotchas, links to sources, and pointers to relevant procedures.

`procedures/*.md` files are reusable agent operating procedures. V0 starts with `code-recall.md` and `project-handoff.md`.

`state/*.md` files are active working memory. They are useful but lower authority than project or procedure files.

`proposals/pending/` stores proposed memory updates as reviewable markdown patches.

`logs/read-traces/` and `logs/write-traces/` store agent-readable traces for future recall and token-spend experiments.

`bin/lazy-mem` is the small V0 helper command. It only needs to support `attach` at first.

`templates/project-pointer.yaml` is the template used to create `.lazy-mem` pointer files inside projects.

`templates/project.md` is the template for optional central project memory pages.

## Markdown And Graph Model

Lazy Mem does not expose `nodes/` or `edges/` folders in V0.

Each memory file is a graph node because it has:

- a stable `id`
- a `type`
- a `title`
- optional `project_id`
- `authority`
- `freshness`
- `tags`
- `links_to`
- markdown wikilinks

Example:

```md
---
id: project.lazy-mem
type: project
title: Lazy Mem
project_id: lazy-mem
authority: primary
freshness: 2026-05-09
tags:
  - agent-memory
  - markdown
  - graph
links_to:
  - procedure.code-recall
  - state.current-focus
---

# Lazy Mem

Related: [[Code Recall]], [[Current Focus]]
```

The graph is inferred from:

- frontmatter IDs
- `links_to`
- `related`
- tags
- `[[wikilinks]]`
- source references
- git history

V0 can work without a built index. A later runtime can generate `.lazy-mem/index.json` or `.lazy-mem/index.sqlite` without changing the human-facing folder layout.

## Agent Read Flow

When working in any project:

1. Check for a `.lazy-mem` pointer file in the project root.
2. Read the pointed `SYSTEM.md`.
3. Read `ROUTERS.md`.
4. Identify the project ID from the pointer file.
5. Read the matching `projects/<project-id>.md` page if it exists.
6. Read only procedures or state files that the router or project page indicates are relevant.
7. Stop reading when enough context exists.
8. Record a read trace if the task used Lazy Mem meaningfully.

The agent should be able to explain why every Lazy Mem file was opened.

## Agent Write Flow

Agents should not directly edit durable memory by default.

For meaningful updates:

1. Create a proposal in `proposals/pending/`.
2. Include the requested memory change, rationale, affected files, source evidence, confidence, and exact patch-style replacement text.
3. Append a write trace in `logs/write-traces/`.
4. Tell the user what was proposed.

Direct edits are allowed only for low-risk append-only logs, or when the user explicitly asks the agent to update memory immediately.

## Trace Format

A read trace should be markdown with YAML frontmatter so it stays readable and parseable.

Example:

```md
---
id: trace.read.2026-05-09.lazy-mem-v0
type: read-trace
project_id: lazy-mem
task: "Plan Lazy Mem V0 scaffold"
created: 2026-05-09T00:00:00Z
files_read:
  - SYSTEM.md
  - ROUTERS.md
  - projects/lazy-mem.md
why:
  SYSTEM.md: "Load Lazy Mem operating instructions."
  ROUTERS.md: "Decide which memory class to inspect."
  projects/lazy-mem.md: "Load the project-specific context."
outcome: "Enough context to plan scaffold."
---

# Read Trace

The agent read the minimum central memory needed for the task.
```

V0 does not need precise token accounting. Approximate character counts or file counts are enough until the benchmark harness exists.

## Error Handling

If a project has no `.lazy-mem` pointer, the agent should proceed normally and optionally ask whether to attach Lazy Mem.

If the pointer file exists but the central repo is missing, the agent should report the missing path and continue without Lazy Mem.

If the pointer file is malformed, the agent should report the invalid field and continue without Lazy Mem.

If the project page does not exist, the agent should use `ROUTERS.md`, relevant procedures, and `state/active-projects.md`, then propose creating a new project page.

If two memory files conflict, the agent should prefer higher `authority`, then newer `freshness`, and should surface the contradiction instead of silently merging it.

If a proposed memory update includes secrets, credentials, or private tokens, the agent should reject the proposal and report that the memory update was unsafe.

## Testing Goal

The first experiment should prove:

> An agent can enter a project, find the central Lazy Mem repo through a pointer, read the minimum useful markdown files, explain the read path, and propose a memory update without directly editing durable memory.

The first setup experiment should prove:

> A user can place the Lazy Mem folder anywhere stable, run one attach command inside a project, and then get a generic agent harness to load Lazy Mem through `.lazy-mem`.

The first recall/token-spend benchmark is deliberately future work. V0 only needs logs and trace structure that make the future benchmark possible.

## Success Criteria

V0 is successful when:

- the central scaffold exists and is committed
- a project can opt in with one attach command that creates a `.lazy-mem` pointer file
- the pointer file is plain YAML and readable by any agent harness
- an agent can follow `SYSTEM.md` and `ROUTERS.md`
- `SYSTEM.md` contains the universal harness instructions
- project, people, procedure, and state pages have consistent frontmatter
- memory write proposals go to `proposals/pending/`
- read traces go to `logs/read-traces/`
- the first experiment can be run on a branch without changing durable memory directly

## Build Order

1. Create the central repo scaffold.
2. Add system instructions and safety rules.
3. Add templates for project, person, procedure, and state pages.
4. Add initial Lazy Mem project memory.
5. Add initial Sav person memory.
6. Add code recall and project handoff procedures.
7. Add log and proposal formats.
8. Add `templates/project-pointer.yaml`.
9. Add `templates/project.md`.
10. Add `bin/lazy-mem attach`.
11. Commit the baseline scaffold.
12. Create a test branch or worktree for the first agent recall experiment.
