# Proposals

Proposals are exceptional.

Use `proposals/pending/` only when a memory update is uncertain, conflicting, broad, destructive, or explicitly requested for review.

Do not let proposals become a permanent backlog.

Most useful memory should be written directly to the nearest relevant project, status, index, trace, or generated map file.

A proposal should include:

- affected files
- reason for the change
- source evidence
- confidence
- exact replacement or append text

## Lifecycle

Pending proposals should be short-lived.

When an agent encounters pending proposals, it should:

1. Apply the proposal if it is now clear, useful, low-risk, and source-backed.
2. Fold the useful part into a direct memory update if the proposal is too detailed.
3. Keep it pending only when a real decision is still needed.
4. Move stale, obsolete, duplicate, or rejected proposals to `proposals/archive/`.

If several proposals are related, bundle them into one digest before asking the user.

Do not create many tiny proposals.
