# CLAUDE.md — litlfred/smart-immunizations-uganda

Uganda (UNEPI) adaptation of the WHO SMART Guidelines immunization DAK and IG.

## Entry point: `smart-guideline-end-to-end`

All authoring and adaptation work in this repository follows smart-base's
[`smart-guideline-end-to-end`](smart-base/skills/content/authoring-who-smart-guidelines/smart-guideline-end-to-end.md)
skill and its process (`smart-base/processes/content/smart-guideline-end-to-end.bpmn`).
Read it before changing anything under `library/`, `input/` or `tests/`.

**The order is a rule (owner, 2026-10-15: "order strict, sign-off QA"):**
L1 library and extraction (`library/`), then L2 DAK assets, then L3 (FSH, CQL).
Each stage's output exists, and its review is requested, before the next
stage starts. Every L3 asset names the L2 asset it implements; every L2 asset
the L1 node it rests on. Source documents (the schedule poster, the UNEPI
deck) are L1 input, never direct input to L3.

## The platform is mounted, not absent

`.claude/mount-platform.sh` (SessionStart hook) lays down the layers
`index.lock.json` pins: smart-base, fhir-harness, cat-harness,
cat-harness-tools, folio-assistant-core, bootstrap, bootstrap-tools. If
`smart-base/` is empty, run `bash .claude/mount-platform.sh`. The mounts are
gitignored; never edit them here.
