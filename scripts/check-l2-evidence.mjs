#!/usr/bin/env node
// An adaptation does not contradict the evidence it cites.
//
// Each adapted table in input/l2/dependencies.yaml says what Uganda changed
// (`change:`) and which authored L1 statements justify it (`evidence:`). When
// the change names an age or an interval ("+ 10 years", "18 months", "4 weeks")
// and NONE of its cited statements names that quantity, the change has drifted
// from its evidence: the folio-assistant#215 walk moved the HPV dose to 9 years
// while P10 and S13 still said 10, and no check noticed (2026-10-24).
//
// Only quantities are compared. Whether a statement supports the rest of a
// change is a reviewer's call, not this check's.
//
// Usage: node scripts/check-l2-evidence.mjs
import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";

const L1_ROOT = "library/l1-recommendation-scenarios";
const DEPENDENCIES = "input/l2/dependencies.yaml";

const UNIT = { y: "years", yr: "years", yrs: "years", year: "years", years: "years", month: "months", months: "months", mo: "months", week: "weeks", weeks: "weeks", wk: "weeks", wks: "weeks", day: "days", days: "days" };

/** Every age or interval a text names, normalised to "<n> <unit>". "10yr Girl", "10 Yrs" and "+ 10 years" all read 10 years. */
export function quantities(text) {
  const out = new Set();
  for (const m of text.matchAll(/(\d+(?:\.\d+)?)\s*(years?|yrs?|y|months?|mo|weeks?|wks?|days?)\b/gi)) out.add(`${Number(m[1])} ${UNIT[m[2].toLowerCase()]}`);
  return out;
}

/** The authored L1 statements, by key, from every `*.l1.yaml` under the library. */
export function statements(files) {
  const out = new Map();
  for (const text of files) {
    for (const m of text.matchAll(/\{\s*key:\s*([A-Za-z0-9_-]+)\b[^\n]*?\bstatement:\s*"((?:[^"\\]|\\.)*)"/g)) out.set(m[1], m[2]);
  }
  return out;
}

/** Each adapted table's change and evidence, read from its one-line entry. */
export function adaptations(text) {
  const out = [];
  for (const m of text.matchAll(/\{\s*id:\s*([^,]+?),\s*decision:\s*adapt\b[^\n]*?\bchange:\s*"((?:[^"\\]|\\.)*)"[^\n]*?\bevidence:\s*\[([^\]]*)\]/g)) {
    out.push({ id: m[1].trim(), change: m[2].replace(/\\"/g, '"'), evidence: m[3].split(",").map((s) => s.trim()).filter(Boolean) });
  }
  return out;
}

/** Every quantity a change names that none of its cited statements names. */
export function unsupported(adaptation, byKey) {
  const cited = adaptation.evidence.map((k) => byKey.get(k)).filter((s) => s !== undefined);
  const said = new Set(cited.flatMap((s) => [...quantities(s)]));
  const missing = adaptation.evidence.filter((k) => !byKey.has(k));
  return { quantities: [...quantities(adaptation.change)].filter((q) => !said.has(q)), missing };
}

function l1Files(dir) {
  const out = [];
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    if (statSync(p).isDirectory()) out.push(...l1Files(p));
    else if (name.endsWith(".l1.yaml")) out.push(readFileSync(p, "utf-8"));
  }
  return out;
}

function main() {
  if (!existsSync(DEPENDENCIES) || !existsSync(L1_ROOT)) {
    console.error(`check-l2-evidence: ${DEPENDENCIES} or ${L1_ROOT}/ is missing; nothing was checked`);
    process.exit(2);
  }
  const byKey = statements(l1Files(L1_ROOT));
  const list = adaptations(readFileSync(DEPENDENCIES, "utf-8"));
  if (list.length === 0 || byKey.size === 0) {
    console.error(`check-l2-evidence: read ${list.length} adaptation(s) and ${byKey.size} L1 statement(s); nothing was checked`);
    process.exit(2);
  }
  const problems = [];
  for (const a of list) {
    const u = unsupported(a, byKey);
    for (const k of u.missing) problems.push(`${a.id}: cites ${k}, which no authored L1 statement has`);
    if (u.quantities.length) problems.push(`${a.id}: "${a.change}" names ${u.quantities.join(", ")}, and none of ${a.evidence.join(", ")} does (${a.evidence.map((k) => `${k}: "${byKey.get(k) ?? "?"}"`).join("; ")})`);
  }
  if (problems.length) {
    console.error(`${problems.length} adaptation(s) do not match the evidence they cite:`);
    for (const p of problems) console.error(`  ✗ ${p}`);
    console.error("Cite the statement that supports the change, or change the adaptation back.");
    process.exit(1);
  }
  console.log(`✓ ${list.length} adaptation(s): every age and interval they name is in the evidence they cite (${byKey.size} L1 statements)`);
}

if (import.meta.url === `file://${process.argv[1]}`) main();
