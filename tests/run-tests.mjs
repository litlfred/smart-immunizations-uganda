// Executes UGIMMZScheduleLogic (compiled ELM in tests/elm, see
// tools/cql/compile.sh) against the test cases in tests/cases.json and
// compares the "Recommendations" output with the expected values.
//
// Value set expansions are read from the WHO Immunization IG FSH sources
// (input/fsh/valuesets) of the same WHO checkout used to compile the CQL.
//
// Usage: node run-tests.mjs   (from tests/, after tools/cql/compile.sh)
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import cql from 'cql-execution';
import cqlfhir from 'cql-exec-fhir';

const here = path.dirname(fileURLToPath(import.meta.url));
const whoRepo = process.env.WHO_IMMZ_REPO_DIR ?? path.join(here, 'vendor', 'smart-immunizations');

// --- ELM ---------------------------------------------------------------
const elmDir = path.join(here, 'elm');
const libraries = {};
for (const f of fs.readdirSync(elmDir).filter((f) => f.endsWith('.json'))) {
  const elm = JSON.parse(fs.readFileSync(path.join(elmDir, f), 'utf8'));
  libraries[elm.library.identifier.id] = elm;
}
const main = new cql.Library(libraries.UGIMMZScheduleLogic, new cql.Repository(libraries));

// --- Value sets from the WHO FSH sources -----------------------------------
const aliases = {
  $SCT: 'http://snomed.info/sct',
  $LNC: 'http://loinc.org',
  $ICD11: 'http://id.who.int/icd/release/11/mms',
  $ATC: 'http://www.whocc.no/atc',
  $CVX: 'http://hl7.org/fhir/sid/cvx',
  'IMMZ.Z': 'http://smart.who.int/immunizations/CodeSystem/IMMZ.Z',
};
const vsDir = path.join(whoRepo, 'input', 'fsh', 'valuesets');
const valueSets = {};
for (const f of fs.readdirSync(vsDir).filter((f) => f.endsWith('.fsh'))) {
  const text = fs.readFileSync(path.join(vsDir, f), 'utf8');
  const id = /^ValueSet:\s*(\S+)/m.exec(text)?.[1];
  if (!id) continue;
  const codes = [];
  for (const m of text.matchAll(/insert AddWithExpand(?:Canonical)?\(\s*([^,\s]+)\s*,\s*#([^,\s]+)/g)) {
    const system = aliases[m[1]];
    if (system) codes.push({ code: m[2], system });
  }
  valueSets[`http://smart.who.int/immunizations/ValueSet/${id}`] = { '': codes };
}
const codeService = new cql.CodeService(valueSets);

// --- Test cases ------------------------------------------------------------
const ATC = 'http://www.whocc.no/atc';

function bundleFor(tc) {
  const entry = [{
    resource: { resourceType: 'Patient', id: tc.id, gender: tc.gender, birthDate: tc.birthDate },
  }];
  (tc.doses ?? []).forEach((d, i) => {
    entry.push({
      resource: {
        resourceType: 'Immunization',
        id: `${tc.id}-dose-${i + 1}`,
        status: 'completed',
        patient: { reference: `Patient/${tc.id}` },
        vaccineCode: { coding: [{ system: ATC, code: d.atc }] },
        occurrenceDateTime: d.date,
        ...(d.series ? { protocolApplied: [{ series: d.series, doseNumberPositiveInt: 1 }] } : {}),
      },
    });
  });
  return { resourceType: 'Bundle', type: 'collection', entry };
}

const show = (r) => `${r.vaccine} #${r.doseNumber} ${r.dueDate}${r.expiration ? ` (exp ${r.expiration})` : ''} ${r.status}`;

const cases = JSON.parse(fs.readFileSync(path.join(here, 'cases.json'), 'utf8'));
let failures = 0;
for (const tc of cases) {
  const today = cql.Date.parse(tc.today);
  const executor = new cql.Executor(main, codeService, { Today: today });
  const source = cqlfhir.PatientSource.FHIRv401();
  source.loadBundles([bundleFor(tc)]);
  const results = await executor.exec(source, cql.DateTime.parse(`${tc.today}T12:00:00.000Z`));
  const recs = (results.patientResults[tc.id].Recommendations ?? []).map((r) => ({
    vaccine: r.vaccine,
    doseNumber: r.doseNumber,
    dueDate: r.dueDate?.toString(),
    expiration: r.expiration?.toString() ?? null,
    status: r.status,
  }));
  const actual = recs.map(show);
  const expected = tc.expected.map((e) => show({ expiration: null, ...e }));
  const ok = actual.length === expected.length && actual.every((a, i) => a === expected[i]);
  if (ok) {
    console.log(`PASS ${tc.id}: ${tc.description}`);
  } else {
    failures++;
    console.log(`FAIL ${tc.id}: ${tc.description}`);
    console.log('  expected:\n    ' + expected.join('\n    '));
    console.log('  actual:\n    ' + actual.join('\n    '));
  }
}
console.log(`\n${cases.length - failures}/${cases.length} test cases passed`);
process.exit(failures ? 1 : 0);
