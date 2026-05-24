<!-- lazy-mem:start -->
## Lazy Mem

At the start of a session or task, before replying, check for `.lazy-mem` in this project.
If present, read it as YAML, resolve `memory_repo` and `system_file`, then follow the Lazy Mem system instructions.
This applies even when the user's first message is casual or small.
Do not preload the whole memory repo.
<!-- lazy-mem:end -->
