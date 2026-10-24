#!/usr/bin/env node
// The hand-completed CQL says what the Uganda workbook says.
//
// `logic:generate` turns the workbook into FSH and CQL SKELETONS, and the
// `logic` gate already fails when the FSH differs from the converter's output.
// The CQL is completed by hand from the skeletons' pseudocode, and nothing
// compared the two: a due date changed in the workbook and not in the CQL (or
// the other way round) passed every check. The folio-assistant#215 walk found
// that gap (smart-immunizations-uganda#12, 2026-10-24).
//
// For every skeleton define that carries a `@pseudocode` ending in an offset
// (`"Date of birth" + 10 years`), the committed define must add the same
// offset. For every `... Create` define, the committed message must start with
// the skeleton's. Anything else in the CQL is the author's.
//
// Usage: IMMZ_HOME=<smart-immunizations checkout> node scripts/check-cql-vs-workbook.mjs
import { execFileSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

/** Every define in a CQL text: its name, the comment block before it, and its body. */
export function defines(cql) {
  const out = new Map();
  const re = /(?:\/\*([\s\S]*?)\*\/\s*)?define\s+"([^"]+)"\s*:\s*([\s\S]*?)(?=\n\s*(?:\/\*|define\s)|$)/g;
  for (const m of cql.matchAll(re)) out.set(m[2], { comment: m[1] ?? "", body: m[3] });
  return out;
}

const UNIT = { year: "years", years: "years", month: "months", months: "months", week: "weeks", weeks: "weeks", day: "days", days: "days" };

/** The trailing `+ N unit` of an expression, normalised, or undefined. */
export function offsetOf(text) {
  const all = [...text.matchAll(/\+\s*(\d+)\s*(years?|months?|weeks?|days?)\b/g)];
  const m = all.at(-1);
  return m ? `+ ${m[1]} ${UNIT[m[2]]}` : undefined;
}

/** The first single-quoted literal of a define body. */
export function messageOf(body) {
  return /'((?:[^']|'')*)'/.exec(body)?.[1];
}

/** Every disagreement between a skeleton and the committed CQL of one library. */
export function compare(skeleton, committed) {
  const problems = [];
  const sk = defines(skeleton);
  const co = defines(committed);
  for (const [name, s] of sk) {
    const c = co.get(name);
    const pseudo = /@pseudocode:\s*(.+)/.exec(s.comment)?.[1];
    const want = pseudo ? offsetOf(pseudo) : undefined;
    if (want) {
      if (!c) problems.push(`"${name}": the workbook gives ${pseudo.trim()}, and the CQL has no such define`);
      else if (offsetOf(c.body) !== want) problems.push(`"${name}": the workbook gives ${pseudo.trim()}, the CQL adds ${offsetOf(c.body) ?? "no offset"}`);
    }
    if (name.endsWith(" Create")) {
      const msg = messageOf(s.body);
      if (msg && c && !(messageOf(c.body) ?? "").startsWith(msg)) problems.push(`"${name}": the workbook's message is '${msg}', the CQL's is '${messageOf(c.body) ?? "(none)"}'`);
    }
  }
  return problems;
}

function main() {
  const said = execFileSync("npm", ["run", "--silent", "logic:generate"], { encoding: "utf-8" });
  const dir = /CQL skeletons in ([^\s:]+)/.exec(said)?.[1];
  if (!dir || !existsSync(dir)) {
    console.error("check-cql-vs-workbook: logic:generate did not say where it wrote the CQL skeletons; nothing was compared");
    process.exit(2);
  }
  const problems = [];
  let compared = 0;
  for (const f of readdirSync(dir).filter((x) => x.endsWith(".cql")).sort()) {
    const committed = join("input", "cql", f);
    if (!existsSync(committed)) {
      problems.push(`${f}: the workbook generates it, and input/cql/ has no such library`);
      continue;
    }
    compared += 1;
    for (const p of compare(readFileSync(join(dir, f), "utf-8"), readFileSync(committed, "utf-8"))) problems.push(`${f}: ${p}`);
  }
  if (compared === 0) {
    console.error("check-cql-vs-workbook: no library compared; nothing was checked");
    process.exit(2);
  }
  if (problems.length) {
    console.error(`The CQL disagrees with the workbook in ${problems.length} place(s):`);
    for (const p of problems) console.error(`  ✗ ${p}`);
    console.error("Change the workbook and the CQL together: the workbook is the source, the CQL is completed from it.");
    process.exit(1);
  }
  console.log(`✓ ${compared} CQL libraries agree with the workbook's due dates and messages`);
}

if (import.meta.url === `file://${process.argv[1]}`) main();
