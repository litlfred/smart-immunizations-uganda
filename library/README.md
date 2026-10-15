# Library — the Uganda adaptation's L1 sources

Stage 2 of smart-base's `smart-guideline-end-to-end` (skills `dak-l1-library`,
`recommendation-extraction`). Everything here is a **candidate** until the
person in the named role reviews it. Adjudication is QA, not a gate (owner,
2026-10-14), but the order is a rule (owner, 2026-10-15): this stage's output
exists, and its review is requested below, before the L2 stage starts.

## The entries

| entry | what | how |
|---|---|---|
| [`ug-moh-routine-immunisation-schedule/`](ug-moh-routine-immunisation-schedule/) | Ministry of Health, *Uganda Routine Immunisation Schedule* (poster) | `bun run cat ingest … --library ../library`, promoted |
| [`unepi-user-requirements-smart-guidelines/`](unepi-user-requirements-smart-guidelines/) | UNEPI, *User requirements for SMART Guidelines* (deck, rendered to PDF one page per slide) | same |

Both come from [issue #1](https://github.com/litlfred/smart-immunizations-uganda/issues/1).
`../uploads/<doc_id>/intake.json` pins each file by sha256; the files are not
committed. Licence: `unknown` (looked for in the document and the issue).

## The L1

The mechanical pass (`<entry>/l1-extraction/`) found no normative sentence:
the poster prints its schedule as age bubbles with no "should", and its text
layer maps every digit to a private-use glyph; the deck's schedule, catch-up
rules and injection sites are images. So the L1 is **authored** on the measles
pattern, in [`l1-recommendation-scenarios/uganda/`](l1-recommendation-scenarios/uganda/):

| file | what |
|---|---|
| `ug-moh-schedule-poster.l1.yaml` | 19 statements from the poster, each verbatim in a transcription of the rendered page whose words are corroborated by the text layer |
| `unepi-deck.l1.yaml` | 34 statements (schedule grid, catch-up rules, injection sites) verbatim in the inspected image transcriptions, and the target-population shares |
| `immz-vocabulary.json` | the WHO immunization guide's personas and processes (`l1-scenario-vocabulary.ts`, litlfred/smart-immunizations@a48d95a) — reused, since Uganda has no L2 yet |
| `*-mapping.yaml` | per statement: persona, process, act, outcome, domain, each with source and basis |
| `candidates/*/` | `scenario-candidates.l2.json` (L2 user-scenario candidates) and `scenario-warnings.md` |

Checks: `bun run l1:verbatim` (also in CI) and `bun run l1-scenarios:uganda:check`.

## Review

What each reviewer signs is listed on the pull request that stages this
library ([#3](https://github.com/litlfred/smart-immunizations-uganda/pull/3)),
and reviewed on its staged preview, per `smart-guideline-end-to-end`
§*Per-asset review*.
