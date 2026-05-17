# Lazy Mem Rules

## Durable Memory

Do not directly edit durable memory by default.

Durable memory includes:

- `projects/`
- `people/`
- `procedures/`
- committed source summaries

Use proposals for meaningful changes.

## Temporary State

State files are working memory, not durable truth.
Do not promote state into durable memory without a proposal or explicit user request.

## Sources

Do not rewrite raw sources.
Use `sources/` for references, imports, and evidence.

## Secrets

Never store API keys, passwords, private tokens, or credentials in Lazy Mem.
Reject memory proposals that contain secrets.

## Authority

When files conflict:

1. Prefer higher `authority`.
2. Prefer newer `freshness` when authority is equal.
3. Surface unresolved contradictions.

## Traces

Read traces and write traces should be append-only records of what happened.
