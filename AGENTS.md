# AGENTS.md — smart-immunizations-uganda

Uganda (UNEPI) adaptation of the WHO SMART Guidelines immunizations DAK and
IG. [`README.md`](README.md) says what the repository holds; this file says
only where an agent starts.

1. **Mount the platform.** `.claude/mount-platform.sh` (the SessionStart hook)
   lays down the layers `index.lock.json` pins. If `smart-base/` is empty, run
   `bash .claude/mount-platform.sh`. The mounts are gitignored; change them
   upstream, never here.
2. **Follow the process.** Every authoring or adaptation step here is a step
   of smart-base's
   [`smart-guideline-end-to-end`](smart-base/skills/content/authoring-who-smart-guidelines/smart-guideline-end-to-end.md)
   and its process, `smart-base/processes/content/smart-guideline-end-to-end.bpmn`.
   Its stages, their order and how each is produced (including which tooling
   to reuse) are said there and nowhere else.
