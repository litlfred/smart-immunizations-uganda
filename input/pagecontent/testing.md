Test patients follow the WHO DAK's own layout: one directory per Logic library,
`input/tests/plandefinition/<Library>/<Library>.yaml`, turned into FHIR test
bundles by WHO's `tools/node/makeExample.js` (`npm run logic:examples`; every
file is built on each pull request). Each library's `Test Validation`
expression names, per test patient, the output that should hold, as the WHO
libraries do.

| Library | Test patients | Checks |
|---|---|---|
| IMMZD18SHepatitisBBirthDoseLogic | UGHepB01, UGHepB02 | birth dose due and expiring at 7 days; complete when given on day 3 |
| IMMZD18SPolioBOPVPlusIPVLogic | UGPolio01, UGPolio02 | IPV 1 due at 6 weeks; IPV 2 due at 14 weeks |
| IMMZD18SDTPOnTimeStartLogic | UGDTP01, UGDTP02 | DTP 1 at 6 weeks; no booster after the primary series |
| IMMZD18SMeaslesOngoingTransmissionLogic | UGMR01 | MCV2 due at 18 months |
| IMMZD18SMalariaLogic | UGMal01, UGMal02 | dose 1 at 6 months; dose 4 at 18 months |
| IMMZD18SHPVSingleDoseLogic | UGHPV01, UGHPV02 | girls at 9 years; not boys |
| IMMZD18SDTPTdWCBALogic | UGTd01–UGTd03 | Td 1 at first contact; Td 3 after Td 2; not men |
{:.grid}

The CQL is compiled by the IG build (`fhirbuild.yml`, the WHO path). The WHO DAK
toolchain has no runner that executes `Test Validation` on each change; the
WHO checklist runs it by hand. That gap is reported to the platform rather than
filled with a script in this repository.
