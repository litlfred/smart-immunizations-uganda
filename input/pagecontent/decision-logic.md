The Uganda scheduling logic is the WHO DAK's own scheduling logic, adapted where
the Uganda schedule differs. It is built the way the WHO immunization DAK builds
it ([IG Starter Kit](https://smart.who.int/ig-starter-kit/l3_decisiontables.html);
litlfred/smart-immunizations `tools/antigenchecklist.md`):

1. **L2, the workbook.** `input/decision-logic/IMMZ DAK_decision-support logic.xlsx`
   is a copy of the WHO DAK workbook. Uganda changes only the cells of the
   scheduling tables (`IMMZ.D18.S.*`) listed below. Each changed row's
   *Comments* cell names the Uganda L1 statements it rests on
   (`library/l1-recommendation-scenarios/uganda/`).
2. **L3, generated.** WHO's converter `tools/node/processDTSchedule.js` turns
   each adapted table into a PlanDefinition and its Library
   (`input/fsh/plandefinitions/`, `input/fsh/libraries/`; `npm run logic:generate`,
   checked on every pull request).
3. **L3, completed.** Each adapted CQL library is WHO's finished library of the
   same name, with only the definitions whose cells changed rewritten, each
   marked `// Uganda:` with its L1 key. The new Td table's library is the
   converter's skeleton, completed from its pseudocode on WHO's DTP data elements.

Every other WHO table is used unchanged from the WHO IG this guide depends on.
The full record, one row per table with its decision and evidence, is
`input/l2/dependencies.yaml`.

### Adapted and added tables

| WHO table | Uganda change | L1 |
|---|---|---|
| IMMZ.D18.S.Hepatitis B.Birth dose schedule | expires at birth + 7 days | C01, C08 |
| IMMZ.D18.S.Polio.bOPV plus IPV schedule | IPV dose 1 at 6 weeks, IPV dose 2 at 14 weeks | S03, S07 |
| IMMZ.D18.S.DTP.On-time start schedule | primary series only (6, 10, 14 weeks); booster rows not generated — *review pending* | S04 |
| IMMZ.D18.S.Measles.Ongoing transmission schedule | MCV2 at 18 months, at least 4 weeks after MCV1 | S08, P09, C07, C13 |
| IMMZ.D18.S.Malaria schedule | doses at 6, 7, 8 and 18 months | S10, P05–P07, P09 |
| IMMZ.D18.S.HPV.Single-dose schedule | girls, at 9 years (SAMPLE change, issue #215 walk) | P10, S13 |
| UG.IMMZ.D18.S.DTP.Td women of childbearing age schedule *(new)* | Td 1 at first contact, then 1, 6, 12 and 12 months — *review pending* | P11–P15, S14 |
{:.grid}

### Reused unchanged

BCG, polio birth dose, Hib 3 doses, pneumococcal 3 doses, rotavirus (WHO
already expires every dose at 24 months, which is the Uganda rule C09–C11),
rubella high-incidence (one dose from 9 months, given as MR1) and yellow fever.

### Configuration

Two Uganda rules are values of parameters the WHO libraries already expose; they
are configured, not forked:

| WHO parameter | Library | WHO default | Uganda | L1 |
|---|---|---|---|---|
| `HepBLowerLimitWeeks` | `IMMZD2DTHepatitisBEncounterElements` (used by the 3- and 4-dose schedules) | 4 | 6 | S04, P02, C03 |
| `HepBBirthDoseAgeLimitDays` | `IMMZD2DTHepatitisBElements` (birth-dose eligibility) | 1 | 7 | C01, C08 |
{:.grid}

### Not in scope

Vitamin A and deworming are not vaccines and are outside the WHO immunization
DAK (review item 6). Contraindications (`IMMZ.D5.DT.*`) and the eligibility
tables (`IMMZ.D2.DT.*`) are WHO's, unchanged. See [open questions](open-questions.html).
