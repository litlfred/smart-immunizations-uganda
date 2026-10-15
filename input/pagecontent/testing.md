The scheduling logic is executed against hand-computed test cases on every
pull request (GitHub workflow `checks.yml`):

1. `tools/cql/compile.sh` compiles the Uganda CQL, together with the WHO
   Immunization IG CQL it depends on, to ELM with the CQL-to-ELM translator.
2. `tests/run-tests.mjs` runs `UGIMMZScheduleLogic` with the
   [cql-execution](https://github.com/cqframework/cql-execution) engine on each
   case in `tests/cases.json`, using value set expansions read from the WHO IG
   value set definitions, and compares `Recommendations` with the expected
   values.

The expected values were computed by hand from the Uganda rules, independently
of the CQL.

| Case | Situation | Checks |
|---|---|---|
| UG01 | Newborn girl on the day of birth, no doses | Full schedule from birth, including HPV at 10 years |
| UG02 | Boy aged 9 days, no doses | Hepatitis B birth dose and OPV0 expired after 7 days |
| UG03 | 6-week doses given at 7 weeks 1 day | 10-week doses move to 4 weeks after them; IPV2 stays at 14 weeks |
| UG04 | Unvaccinated 2-year-old | Catch-up for all infant vaccines; rotavirus expired |
| UG05 | Measles-containing dose at 7 months | Does not count as MR1; malaria dose 4 at 18 months |
| UG06 | MR1 given at 14 months | MR2 at 18 months |
| UG07 | Malaria started at 8.5 months | Dose 3 is 4 weeks after dose 2 |
| UG08 | Woman aged 30 with Td1 and Td2 | Td3 6 months after Td2; HPV window closed |
| UG09 | Girl aged 10 | HPV due; childhood schedule and Td not offered |
| UG10 | Girl aged 15 with infant pentavalent doses | Infant doses do not count as Td; Td1 due |
| UG11 | Hepatitis B recorded as Dose 0 and OPV at day 3 | Both count as birth doses |
{:.grid}

To run locally (Java 17, Maven and Node.js 22):

    tools/cql/compile.sh
    cd tests && npm ci && npm test
