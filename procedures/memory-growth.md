---
id: procedure.memory-growth
type: procedure
title: Memory Growth
authority: primary
freshness: 2026-05-26
tags:
  - procedure
  - memory
  - writes
  - growth
links_to:
  - project.lazy-mem
  - procedure.memory-explorer
---

# Memory Growth

## Use When

- Useful context appears during work.
- The next agent would otherwise rediscover the same thing.
- A project status, index, map, trace, or todo should be updated.
- The agent needs to decide whether a direct memory update is safe.

## Rule

Default to useful memory growth.

Directly update memory when the update is clear, useful, low-risk, and easy to inspect in git.

When an update is unsafe, ask, skip, or record only the safe blocker.

## Direct Update Shape

Keep direct updates small:

- add one status bullet
- add one index row
- add one todo
- add one link to a deeper note
- append one trace or generated map summary

Prefer updating the nearest relevant file instead of creating a new file.

## Stop Conditions

Stop writing memory when:

- the context is already captured
- the fact is a guess
- the update is too detailed to help routing
- the update would store secrets
- the memory change is larger than the current task

If stopping would leave the next agent blocked, add a short factual blocker to the nearest status file instead of drafting a deferred change.
