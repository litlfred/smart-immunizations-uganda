#!/usr/bin/env python3
"""Write the Uganda scheduling decision tables (input/dmn/UG.D18.S.*.dmn).

Source: tools/l2/ug-schedule-tables.yaml. Format: smart-base's DAK DMN
(input/dmn/DAK.DT.IMMZ.D2.DT.BCG.dmn in litlfred/smart-base): one decision
table per vaccine, inputs and outputs as human-readable expressions, and a
`Reference(s)` output that cites the L1 statements each rule rests on.

Refuses a reference to an L1 key that the authored L1
(library/l1-recommendation-scenarios/uganda/*.l1.yaml) does not hold.
`--check` exits 1 when a written table differs from what the source gives.
"""
import glob, sys
from pathlib import Path
from xml.sax.saxutils import escape

import yaml

ROOT = Path(__file__).resolve().parents[2]
L1_DIR = ROOT / "library/l1-recommendation-scenarios/uganda"
FILES = {"P": "ug-moh-schedule-poster.l1.yaml", "S": "unepi-deck.l1.yaml", "C": "unepi-deck.l1.yaml", "A": "unepi-deck.l1.yaml"}
NS = "https://litlfred.github.io/smart-immunizations-uganda"


def l1_keys():
    keys = {}
    for f in glob.glob(str(L1_DIR / "*.l1.yaml")):
        doc = yaml.safe_load(open(f, encoding="utf-8"))
        for r in doc.get("recommendations", []):
            keys[r["key"]] = (Path(f).name, r["statement"])
    return keys


def ref_text(keys, refs, problems, where):
    out = []
    for k in refs:
        if k not in keys:
            problems.append(f"{where}: L1 key {k} does not exist")
            continue
        out.append(f"{keys[k][0]}#{k}")
    return ", ".join(out)


def entry(desc, text):
    return f"        <dmn:inputEntry>\n          <dmn:description>{escape(desc)}</dmn:description>\n          <dmn:text>{escape(text)}</dmn:text>\n        </dmn:inputEntry>\n"


def out(desc, text):
    return f"        <dmn:outputEntry>\n          <dmn:description>{escape(desc)}</dmn:description>\n          <dmn:text>{escape(text)}</dmn:text>\n        </dmn:outputEntry>\n"


def annotation(text):
    return f"        <dmn:annotationEntry>\n          <dmn:text>{escape(text)}</dmn:text>\n        </dmn:annotationEntry>\n"


def build(t, scope, keys, problems):
    tid, vac = t["id"], t["vaccine"]
    counts = t.get("counts", f'"Vaccine type" = "{vac}"')
    exp = t["expiration"]
    x = [f'<dmn:definitions xmlns:dmn="https://www.omg.org/spec/DMN/20240513/MODEL/" namespace="{NS}" label="{escape(tid)} {escape(vac)} schedule (Uganda)" id="{tid}">\n',
         f'  <dmn:decision id="{tid}" label="{escape(tid)} {escape(vac)} schedule (Uganda)">\n',
         f"    <dmn:question>Which {escape(vac)} dose is the client due for, and when?</dmn:question>\n",
         f'    <dmn:decisionTable id="{tid}.table">\n']
    inputs = [("doses", f"Number of {vac} doses administered", f"Count of vaccines administered (where {counts})"),
              ("age", "Age", "Today's date − \"Date of birth\""),
              ("applies", "Applicability", t.get("applies", scope["text"]))]
    for iid, label, expr in inputs:
        x.append(f'      <dmn:input id="{tid}.input.{iid}" label="{escape(label)}">\n        <dmn:inputExpression id="{tid}.inputExpression.{iid}" typeRef="string">\n          <dmn:text>{escape(expr)}</dmn:text>\n        </dmn:inputExpression>\n      </dmn:input>\n')
    for oid, label, desc in [("status", "Recommendation status", "Due, upcoming, expired or complete"),
                             ("due", "Due date", "Date from which the dose may be given"),
                             ("expiration", "Expiration", "Last date on which the dose may be given"),
                             ("guidance", "Guidance displayed to health worker", "Request to communicate guidance to the health worker"),
                             ("references", "Reference(s)", "The L1 statements the rule rests on, as <l1 file>#<key>")]:
        x.append(f'      <dmn:output id="{tid}.output.{oid}" label="{escape(label)}">\n        <dmn:description>{escape(desc)}</dmn:description>\n      </dmn:output>\n')
    applies_refs = t.get("applies_refs", scope["refs"])
    applies_txt = t.get("applies", scope["text"])
    doses = t["doses"]
    for i, d in enumerate(doses):
        where = f"{tid} dose {d['n']}"
        refs = ref_text(keys, d["refs"] + applies_refs, problems, where)
        x.append(f'      <dmn:rule id="{tid}.rule.dose{d["n"]}">\n')
        x.append(entry(f"= {i}", f"{i} dose(s) administered" if d['n'] != 0 else "No dose administered"))
        x.append(entry("–", "–"))
        x.append(entry(applies_txt, "Applies"))
        x.append(out('"Immunization recommendation status" = "Due" when Due date ≤ Today, else "Upcoming"', f"Client is due for {vac} dose {d['n']}"))
        x.append(out(d["due"], d["due"]))
        x.append(out(exp["text"], exp["text"]))
        x.append(out("Guidance", d["guidance"]))
        x.append(out("L1", refs))
        for note_key in ("note",):
            if d.get(note_key):
                x.append(annotation(d[note_key]))
        if d.get("upstream"):
            x.append(annotation(f"Not stated in the Uganda sources; adapted from WHO {d['upstream']}. {d.get('pending', '')}".strip()))
        x.append("      </dmn:rule>\n")
    # expired, complete, out of scope
    exp_refs = ref_text(keys, exp.get("refs", []), problems, f"{tid} expiration")
    x.append(f'      <dmn:rule id="{tid}.rule.expired">\n')
    x.append(entry(f"< {len(doses)}", "Series not complete"))
    x.append(entry(f"Today > {exp['text']}", "Past the expiration"))
    x.append(entry(applies_txt, "Applies"))
    x.append(out('"Immunization recommendation status" = "Expired"', f"Do not give {vac}"))
    x.append(out("–", "–"))
    x.append(out(exp["text"], exp["text"]))
    x.append(out("Guidance", f"The next {vac} dose may no longer be given."))
    x.append(out("L1", exp_refs or "none"))
    if exp.get("upstream"):
        x.append(annotation(f"Not stated in the Uganda sources; adapted from WHO {exp['upstream']}. {exp.get('pending', '')}".strip()))
    elif exp["text"] == "none":
        x.append(annotation("No expiration: this rule never applies (C15, no upper age limit)."))
    x.append("      </dmn:rule>\n")
    x.append(f'      <dmn:rule id="{tid}.rule.complete">\n')
    x.append(entry(f"≥ {len(doses)}", "Series complete"))
    x.append(entry("–", "–"))
    x.append(entry("–", "–"))
    x.append(out('"Immunization recommendation status" = "Complete"', f"{vac} series complete"))
    for _ in range(3):
        x.append(out("–", "–"))
    x.append(out("L1", ref_text(keys, [doses[-1]["refs"][0]], problems, f"{tid} complete")))
    x.append("      </dmn:rule>\n")
    if "applies" not in t:
        x.append(f'      <dmn:rule id="{tid}.rule.outOfScope">\n')
        x.append(entry("–", "–"))
        x.append(entry("–", "–"))
        x.append(entry(f"NOT ({scope['text']})", "Childhood schedule does not apply"))
        x.append(out('"Immunization recommendation status" = "Not applicable"', "Not offered"))
        for _ in range(3):
            x.append(out("–", "–"))
        x.append(out("L1", ref_text(keys, scope["refs"], problems, f"{tid} scope")))
        x.append(annotation(scope["pending"]))
        x.append("      </dmn:rule>\n")
    for extra in ("counts_upstream", "pending_counts"):
        if t.get(extra):
            x.insert(4, f"    <!-- {escape(t[extra])} -->\n")
    x.append("    </dmn:decisionTable>\n  </dmn:decision>\n</dmn:definitions>\n")
    return "".join(x)


def main():
    check = "--check" in sys.argv
    src = yaml.safe_load(open(ROOT / "tools/l2/ug-schedule-tables.yaml", encoding="utf-8"))
    keys, problems, stale = l1_keys(), [], []
    for t in src["tables"]:
        text = build(t, src["childhood_scope"], keys, problems)
        path = ROOT / "input/dmn" / f"{t['id']}.dmn"
        if check:
            if not path.exists() or path.read_text(encoding="utf-8") != text:
                stale.append(path.name)
        else:
            path.write_text(text, encoding="utf-8")
    for p in problems:
        print("REFUSED " + p)
    for s in stale:
        print("STALE " + s)
    print(f"{len(src['tables'])} table(s){' checked' if check else ' written'}")
    return 1 if problems or stale else 0


if __name__ == "__main__":
    sys.exit(main())
