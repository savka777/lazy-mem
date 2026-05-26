---
id: trace.write.2026-05-26.lazy-mem-memory-growth-policy
type: write-trace
project_id: lazy-mem
task: "Rework Lazy Mem write policy so memory grows over time"
created: 2026-05-26
files_changed:
  - SYSTEM.md
  - RULES.md
  - ROUTERS.md
  - lazy-mem.yaml
  - procedures/memory-growth.md
  - projects/lazy-mem.md
  - projects/lazy-mem/status/current.md
  - projects/lazy-mem/status/todo.md
  - projects/lazy-mem/decisions/README.md
  - projects/lazy-mem/features/README.md
  - logs/read-traces/2026-05-26-lazy-mem-memory-growth-policy.md
reason: "The proposal-first policy was too heavy for a product that should collect useful context over time."
confidence: high
---

# Write Trace

The write policy now defaults to memory growth when updates are clear, useful, low-risk, and easy to inspect in git.

Proposals remain available for uncertain, conflicting, broad, destructive, or explicitly review-requested changes, but they are exceptional and should be applied, folded, or archived rather than left as a permanent queue.

The remaining strategic work was captured in `projects/lazy-mem/status/todo.md`.
