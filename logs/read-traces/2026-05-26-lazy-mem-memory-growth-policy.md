---
id: trace.read.2026-05-26.lazy-mem-memory-growth-policy
type: read-trace
project_id: lazy-mem
task: "Rework Lazy Mem write policy so memory grows over time"
created: 2026-05-26
files_read:
  - .lazy-mem
  - SYSTEM.md
  - ROUTERS.md
  - RULES.md
  - lazy-mem.yaml
  - projects/lazy-mem.md
  - projects/lazy-mem/status/current.md
  - projects/lazy-mem/decisions/README.md
  - projects/lazy-mem/features/README.md
why:
  .lazy-mem: "Confirm the dev repo is locally attached for dogfooding."
  SYSTEM.md: "Load the active Lazy Mem operating instructions."
  ROUTERS.md: "Choose the project memory route."
  RULES.md: "Inspect current write policy before changing it."
  lazy-mem.yaml: "Update machine-readable write policy defaults."
  projects/lazy-mem.md: "Update the project hub with the new policy direction."
  projects/lazy-mem/status/current.md: "Record active work and next project status."
  projects/lazy-mem/decisions/README.md: "Capture the durable policy decision."
  projects/lazy-mem/features/README.md: "Track memory growth policy as a product feature."
outcome: "Enough context to replace proposal-first writes with direct useful memory growth."
---

# Read Trace

Lazy Mem was used while changing Lazy Mem.

The useful route was:

```text
.lazy-mem -> SYSTEM.md -> ROUTERS.md -> projects/lazy-mem.md -> status/current.md
```

The session exposed one dogfood issue: the dev repo needed a local `.lazy-mem` pointer and `AGENTS.md` bootstrap, but those files should not be committed because the pointer contains an absolute machine path.
