# Lazy Mem Rules

## Durable Memory

Memory should grow over time.

Agents may directly update durable memory when the update is clear, useful, low-risk, and easy to inspect in git.

Good direct writes include:

- project status, next steps, and blockers
- source-backed project facts
- user-confirmed product direction
- generated maps, indexes, traces, and run summaries
- short links from a hub or index to deeper notes

Durable memory includes:

- `projects/`
- `people/`
- `procedures/`
- committed source summaries

Use proposals when the change is uncertain, conflicting, broad, destructive, or explicitly requested for review.

Do not use proposals as the default path for every useful memory update.
Do not let pending proposals become a permanent backlog.
Apply, fold, or archive proposals when their status becomes clear.

## Temporary State

State files are working memory, not durable truth.
Promote state into durable memory only when it becomes useful, source-backed, or user-confirmed.

## Sources

Do not rewrite raw sources.
Use `sources/` for references, imports, and evidence.

## Secrets

Never store API keys, passwords, private tokens, or credentials in Lazy Mem.
Reject memory updates that contain secrets.

## Authority

When files conflict:

1. Prefer higher `authority`.
2. Prefer newer `freshness` when authority is equal.
3. Surface unresolved contradictions.

## Traces

Read traces and write traces should be append-only records of what happened.
