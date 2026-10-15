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

## Review requested — what each reviewer signs

| # | item | role | how |
|---|---|---|---|
| 1 | The two documents are the right L1 sources, and whether each is L1 (`classification.layer` is `undetermined`) | Clinical SME (programme) | declare on each `*.l1.yaml` and intake |
| 2 | The 39 image descriptions, above all slide 6 (schedule grid), slide 7 (catch-up chart: the **only** source of the catch-up rules) and slide 8 (injection sites, sides read from the arrows) | Clinical SME | `bun run cat narratives` → confirm or reject each |
| 3 | The poster transcription (`ug-moh-schedule-poster.l1.yaml`, `transcription`), especially the digits, the age grouping and the Td table's "Month after" column, which the text layer does not hold | Clinical SME | compare with the poster |
| 4 | Two proposed exclusions in the deck (`l1-extraction/exclusions.proposed.json`) | `l1-extraction-reviewer` | sign `signedOffBy` |
| 5 | The 53 scenario links (persona, process, domain) | Business analyst | add `review: {by, at}` to each mapping entry |
| 6 | Four process gaps: AEFI reporting (P18), caregiver health education (P19), vitamin A (S11) and deworming (S12) have no IMMZ process | Business analyst / programme manager | decide at L2: extend the WHO process set, or leave out of scope |
