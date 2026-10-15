# SMART Immunizations – Uganda adaptation (draft)

Draft adaptation of the [WHO SMART Guidelines Immunization implementation guide](https://smart.who.int/immunizations)
to the Uganda routine immunisation schedule (UNEPI), for review with UNEPI.
Not an official Ministry of Health publication.

See [issue #1](https://github.com/litlfred/smart-immunizations-uganda/issues/1) for the source documents.

## Contents

| Path | What |
|---|---|
| `library/` | L1: the two sources (schedule poster, UNEPI deck), ingested, and the L1 authored from them |
| `input/l2/dependencies.yaml` | L2 dependency choice: what is reused, adapted or added from the WHO DAK, table by table, with the toolchain |
| `input/decision-logic/IMMZ DAK_decision-support logic.xlsx` | L2: a copy of the WHO DAK workbook with the Uganda cells changed, each citing its L1 |
| `input/fsh/plandefinitions/`, `input/fsh/libraries/` | L3, generated from the workbook by WHO's `processDTSchedule.js` |
| `input/cql/` | L3: WHO's scheduling libraries with the Uganda definitions changed, and the new Td library |
| `input/tests/plandefinition/` | Test patients in the WHO test format |
| `input/pagecontent/` | Schedule, catch-up rules, routes and sites, differences from WHO, UNEPI requirements, open questions |

## Running the checks

The tools are the upstream ones, run in place from checkouts of litlfred/smart-immunizations
(`IMMZ_HOME`) and litlfred/smart-base (`SMART_BASE_HOME`); `checks.yml` pins both by commit.

```sh
IMMZ_HOME=../smart-immunizations npm run logic:generate   # workbook -> PlanDefinition and Library FSH
IMMZ_HOME=$PWD/../smart-immunizations npm run logic:examples   # test yaml -> FHIR test bundles
SMART_BASE_HOME=../smart-base bun run l1:verbatim          # authored L1 is verbatim
```

The IG is built with SUSHI and the HL7 IG Publisher (`fhirbuild.yml`, the WHO path, which also compiles the CQL), and depends on the continuous build of `smart.who.int.immunizations`.
