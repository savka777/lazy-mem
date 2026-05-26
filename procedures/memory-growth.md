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
- The agent needs to decide between a direct memory update and a proposal.

## Rule

Default to useful memory growth.

Directly update memory when the update is clear, useful, low-risk, and easy to inspect in git.

Use proposals when the change is uncertain, conflicting, broad, destructive, or explicitly requested for review.

## Direct Update Shape

Keep direct updates small:

- add one status bullet
- add one index row
- add one todo
- add one link to a deeper note
- append one trace or generated map summary

Prefer updating the nearest relevant file instead of creating a new file.

## Proposal Shape

Create one proposal when direct editing would make the memory less trustworthy.

Pending proposals are not a backlog.

A proposal should include:

- affected files
- reason for the change
- source evidence
- confidence
- exact replacement or append text

Do not create many tiny proposals when one digest would be easier to review.

## Proposal Lifecycle

When you see pending proposals:

1. Apply the proposal if it is now clear, useful, low-risk, and source-backed.
2. Fold the useful part into a direct memory update if the proposal is too detailed.
3. Keep it pending only when a real decision is still needed.
4. Move stale, obsolete, duplicate, or rejected proposals to `proposals/archive/`.

If related proposals pile up, summarize them into one digest and archive the duplicates.

## Stop Conditions

Stop writing memory when:

- the context is already captured
- the fact is a guess
- the update is too detailed to help routing
- the update would store secrets
- the memory change is larger than the current task
