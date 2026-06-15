![lazy-mem banner](assets/lazy-mem-banner.png)

# lazy-mem

**Switch agents without losing the thread.**

Lazy Mem is an under-engineered memory system for agents.

It gives each project a tiny `.lazy-mem` pointer file. That pointer leads compatible agents to shared markdown memory: project notes, system rules, routing hints, procedures, traces, and useful updates.

The point is simple: every agent run should leave behind context the next one can use.

```text
project/.lazy-mem
  -> shared memory repo
  -> SYSTEM.md
  -> ROUTERS.md
  -> projects/<project>.md
  -> projects/<project>/status / decisions / features / specs
  -> traces / direct memory updates
```

## why

Chat is a bad place for memory.

You explain the project. The agent does the work. The session ends. The next agent starts cold, and suddenly you are the memory layer again.

Lazy Mem moves that context into plain files you control.

- readable by humans
- diffable in git
- shareable across machines
- usable by different agents
- small enough to work without a server

The goal is cold-start continuity: a fresh agent should be able to open a project, follow the memory route, and continue without making you re-explain what the project is or where it left off.

## what it is

Lazy Mem starts from a small contract:

1. A project can point to shared memory.
2. An agent can discover that memory.
3. `SYSTEM.md` explains how to use it.
4. `ROUTERS.md` tells the agent where to look.
5. The agent reads the smallest useful set of files.
6. The agent writes useful memory directly when it matters and is safe.

No database.
No daemon.
No hidden cloud memory.

Just files, git, and enough structure for agents to find their way back.

## quick start

From inside any project:

```bash
/path/to/lazy-mem/bin/lazy-mem attach .
```

That creates:

```text
.lazy-mem
AGENTS.md
CLAUDE.md
GEMINI.md
AGENT.md
shared-memory/projects/<project>.md
shared-memory/projects/<project>/status/current.md
shared-memory/projects/<project>/decisions/README.md
shared-memory/projects/<project>/features/README.md
shared-memory/projects/<project>/specs/README.md
```

`.lazy-mem` points back to the shared memory repo.

The harness startup adapters give compatible tools a small bootstrap instruction: check for `.lazy-mem`, read the Lazy Mem system instructions, follow the routers, and load only the memory needed for the task.

## what it stores

Lazy Mem is markdown organized around work:

```text
projects/      project hubs and layered project context
people/        user preferences and durable context
procedures/    repeatable agent workflows
state/         current focus and active work
sources/       evidence and references
logs/          read/write traces
lazy-cache/    future generated indexes and helper files
```

`.lazy-mem` is always the project pointer file.

Each project starts with a hub at `projects/<project>.md`. The hub gives a short summary and links to narrower project layers: current status, decisions, features, and specs. Agents should read the hub first, then open only the smallest useful linked file.

`lazy-cache/` is reserved for generated support data later.

## the agent contract

Agents should:

1. Read the project `.lazy-mem` file.
2. Load the central `SYSTEM.md`.
3. Follow `ROUTERS.md`.
4. Read the smallest useful set of memory files.
5. Stop when there is enough context.
6. Leave a trace or write useful memory directly when it actually matters.

This makes memory visible instead of hidden. The product should feel easy because the continuity comes from ordinary files the user can open, diff, and repair.

If an agent says it remembered something, you should be able to see what it read, why it trusted it, and what it changed.

## continuity objective

Lazy Mem should optimize for fresh-agent continuation success per unit of context read.

A continuity run is successful when a fresh compatible agent:

1. Starts from normal user wording like "Where did we leave off?"
2. Reads `.lazy-mem`, `SYSTEM.md`, `ROUTERS.md`, and the project hub before answering.
3. Opens only the smallest useful linked memory files.
4. Recovers the current project state without user re-explanation.
5. Takes or names the correct next action from memory.
6. Writes one small direct memory update when useful and safe.

The run fails if the agent needs the user to mention Lazy Mem, reads broadly instead of following the route, cannot act from remembered context, or writes speculative/bloated memory.

## portable by default

Lazy Mem is local-first, not local-only.

The memory is just files in a git repo. Keep it private on one machine, sync it across laptops, share it with a team, or point different harnesses at the same repo.

The important part is ownership: project context lives outside any one chat, model, tool, or machine.

## status

Lazy Mem is in v0.

Today it can:

- attach a project with a `.lazy-mem` pointer
- add harness startup adapters: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `AGENT.md`
- create a project hub with status, decisions, features, and specs
- give agents a small routing contract
- let memory grow through direct, inspectable file updates

Lazy Mem does not keep a deferred update queue in the active product model. Agents write directly when an update is clear, useful, factual, low-risk, and small. If an update is unsafe, uncertain, broad, destructive, or speculative, the agent asks, skips it, or records only the safe blocker.

Adapter generation is tracked separately from runtime proof. Codex runtime-probed through `AGENTS.md`. `CLAUDE.md`, `GEMINI.md`, and `AGENT.md` are generated for harnesses that document those startup files. Generated adapters are not the same as runtime proof for every harness.

The next proof:

```text
same memory
different agents
less re-explaining
```

That is the bar.
