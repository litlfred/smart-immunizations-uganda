# SMART Immunizations – Uganda adaptation (draft)

Draft adaptation of the [WHO SMART Guidelines Immunization implementation guide](https://smart.who.int/immunizations)
to the Uganda routine immunisation schedule (UNEPI), for review with UNEPI.
Not an official Ministry of Health publication.

See [issue #1](https://github.com/litlfred/smart-immunizations-uganda/issues/1) for the source documents.

## Contents

| Path | What |
|---|---|
| `input/cql/UGIMMZElements.cql` | Doses grouped as the Uganda schedule counts them (on top of the WHO data elements and value sets) |
| `input/cql/UGIMMZScheduleLogic.cql` | Uganda schedule: next dose, due date, expiration and status per vaccine |
| `input/fsh/` | Library and PlanDefinition resources (SUSHI) |
| `input/pagecontent/` | Schedule, catch-up rules, routes and sites, differences from WHO, UNEPI requirements, open questions |
| `tests/cases.json` | Hand-computed test cases |
| `tools/cql/compile.sh`, `tests/run-tests.mjs` | Compile the CQL and execute the test cases |

## Running the checks

Needs Java 17, Maven and Node.js 22.

```sh
tools/cql/compile.sh          # CQL -> ELM (clones the WHO IG CQL into tests/vendor/)
cd tests && npm ci && npm test
```

The IG itself is built with SUSHI and the HL7 IG Publisher (`sushi build .`, then the publisher), and depends on the continuous build of `smart.who.int.immunizations`.
