#!/usr/bin/env python3
"""Render the L1/L2 review page (docs/review/index.html) from the repository.

Reads the authored L1 (library/l1-recommendation-scenarios/uganda/*.l1.yaml),
the scenario mappings and candidates, the L2 dependency table
(input/l2/dependencies.yaml) and the decision tables (input/dmn/*.dmn), and
renders source pages from the pinned uploads (uploads/<doc_id>/*.pdf) when
they are present. One self-contained HTML page for reviewers.
"""
import base64, glob, html, json, re, sys
from pathlib import Path
import xml.etree.ElementTree as ET

import yaml

ROOT = Path(__file__).resolve().parents[2]
U = ROOT / "library/l1-recommendation-scenarios/uganda"
NS = {"dmn": "https://www.omg.org/spec/DMN/20240513/MODEL/"}
e = html.escape


def page_image(doc, page, width=1100):
    pdf = ROOT / f"uploads/{doc}/{doc}.pdf"
    if not pdf.exists():
        return None
    try:
        import pymupdf
    except ImportError:
        import fitz as pymupdf
    d = pymupdf.open(pdf)
    p = d[page - 1]
    zoom = width / p.rect.width
    pix = p.get_pixmap(matrix=pymupdf.Matrix(zoom, zoom))
    return "data:image/jpeg;base64," + base64.b64encode(pix.tobytes("jpeg", jpg_quality=72)).decode()


def load_l1():
    out = {}
    for name in ["ug-moh-schedule-poster", "unepi-deck"]:
        doc = yaml.safe_load(open(U / f"{name}.l1.yaml", encoding="utf-8"))
        mp = yaml.safe_load(open(U / f"{name}-mapping.yaml", encoding="utf-8"))
        warn = (U / f"candidates/{name}/scenario-warnings.md").read_text(encoding="utf-8")
        warned = set(re.findall(r"WARNING \S+ (\w+):", warn))
        out[name] = (doc, mp, warned)
    return out


def chip(key, file):
    return f'<a class="chip" href="#l1-{e(key)}" title="{e(file)}#{e(key)}">{e(key)}</a>'


def l1_section(l1):
    parts = []
    srcs = {"ug-moh-schedule-poster": ("ug-moh-routine-immunisation-schedule", [1], "Ministry of Health poster"),
            "unepi-deck": ("unepi-user-requirements-smart-guidelines", [6, 7, 8], "UNEPI deck, slides 6–8")}
    for name, (doc, mp, warned) in l1.items():
        entry, pages, label = srcs[name]
        pub = doc["publication"]
        imgs = "".join(f'<figure><img loading="lazy" alt="{e(label)}, page {p}" src="{src}"><figcaption>Page {p}</figcaption></figure>'
                       for p in pages if (src := page_image(entry, p)))
        rows = []
        for r in doc["recommendations"]:
            m = mp["entries"][r["key"]]
            proc = m["process"]["id"]
            persona = ", ".join(p.get("id", p.get("candidate", "")) for p in m["personas"])
            src = r.get("image") or f'transcription {r.get("from")}'
            scope = f'<div class="scope">Applies to: {e(r["scope"]["row"])}</div>' if r.get("scope") else ""
            flag = '<span class="pill warn">no process</span>' if r["key"] in warned else ""
            rows.append(f'<tr id="l1-{e(r["key"])}"><td class="key">{e(r["key"])}</td><td><q>{e(r["statement"])}</q>{scope}</td>'
                        f'<td class="mono small">{e(src)}</td><td class="small">{e(persona)}<br><span class="mono">{e(proc)}</span> {flag}</td>'
                        f'<td class="small">{e(m["act"])}</td></tr>')
        cls = pub.get("classification", {}).get("layer", "")
        parts.append(f'''<section class="source" id="src-{name}">
<h3>{e(pub["title"])}</h3>
<p class="meta">{e(pub.get("creator", ""))} · classification <span class="pill">{e(cls)}</span> · {len(rows)} statements · <span class="mono">{e(name)}.l1.yaml</span></p>
<div class="figs">{imgs}</div>
<div class="tablewrap"><table class="l1"><thead><tr><th>Key</th><th>Statement (verbatim)</th><th>Source</th><th>Persona · process</th><th>User story act</th></tr></thead><tbody>{"".join(rows)}</tbody></table></div>
</section>''')
    return "".join(parts)


def deps_section():
    d = yaml.safe_load(open(ROOT / "input/l2/dependencies.yaml", encoding="utf-8"))
    rows = []
    for c in d["candidates"]:
        comps = ""
        if c.get("components"):
            comps = '<ul class="comps">' + "".join(f'<li><span class="pill {v["decision"]}">{e(v["decision"])}</span> <b>{e(k)}</b> — {e(v["reason"])}</li>' for k, v in c["components"].items()) + "</ul>"
        rows.append(f'<tr><td class="mono">{e(c["packageId"])}<div class="small">{e(c["publisher"])}</div></td><td><span class="pill {c["decision"]}">{e(c["decision"])}</span></td><td>{e(c["reason"])}{comps}</td></tr>')
    return f'<div class="tablewrap"><table class="deps"><thead><tr><th>Candidate DAK</th><th>Decision</th><th>Reason</th></tr></thead><tbody>{"".join(rows)}</tbody></table></div>'


def dmn_tables():
    out = []
    for f in sorted(glob.glob(str(ROOT / "input/dmn/*.dmn"))):
        t = ET.parse(f).getroot()
        dec = t.find("dmn:decision", NS)
        q = dec.find("dmn:question", NS).text
        table = dec.find("dmn:decisionTable", NS)
        ins = [i.find("dmn:inputExpression/dmn:text", NS).text for i in table.findall("dmn:input", NS)]
        rows = []
        for r in table.findall("dmn:rule", NS):
            ie = [x.find("dmn:text", NS).text for x in r.findall("dmn:inputEntry", NS)]
            oe = [x.find("dmn:text", NS).text for x in r.findall("dmn:outputEntry", NS)]
            notes = [x.find("dmn:text", NS).text for x in r.findall("dmn:annotationEntry", NS)]
            refs = [s.strip() for s in (oe[4] or "").split(",") if "#" in s]
            chips = " ".join(chip(s.split("#")[1], s.split("#")[0]) for s in refs) or '<span class="small muted">none</span>'
            pend = "".join(f'<div class="note {"pending" if "Not stated" in n or "Open question" in n else ""}">{e(n)}</div>' for n in notes)
            rows.append(f'<tr><td>{e(ie[0])}</td><td class="small">{e(ie[2])}</td><td><b>{e(oe[0])}</b></td><td class="mono small">{e(oe[1])}</td><td class="mono small">{e(oe[2])}</td><td class="small">{e(oe[3])}{pend}</td><td>{chips}</td></tr>')
        tid = dec.get("id")
        n_pending = sum(1 for r in rows if 'class="note pending"' in r)
        badge = f' <span class="pill warn">{n_pending} rule(s) rest on WHO or an open question</span>' if n_pending else ' <span class="pill reuse">all rules cite Uganda L1</span>'
        out.append(f'''<details class="dt" id="dt-{e(tid)}"><summary><span class="mono">{e(tid)}</span> — {e(q)}{badge}</summary>
<p class="small muted">Counts: {e(ins[0])}</p>
<div class="tablewrap"><table class="dmn"><thead><tr><th>Doses given</th><th>Applies when</th><th>Status</th><th>Due date</th><th>Expiration</th><th>Guidance</th><th>L1</th></tr></thead><tbody>{"".join(rows)}</tbody></table></div></details>''')
    return "".join(out)


REVIEW = [("Clinical SME", "Are the poster and the UNEPI deck the right L1 sources, and are they L1? Both are marked undetermined."),
          ("Clinical SME", "Confirm or reject the 39 image descriptions, above all slide 6 (schedule grid), slide 7 (catch-up chart: the only source of the catch-up rules) and slide 8 (injection sites)."),
          ("Clinical SME", "Check the poster transcription: the text layer holds no digits, and the Td 'Month after' column is not in it."),
          ("L1 extraction reviewer", "Sign or reject the two proposed exclusions in the deck."),
          ("Business analyst", "Review the 53 scenario links: persona, process, domain."),
          ("Business analyst / programme manager", "Decide the four process gaps: AEFI reporting, caregiver health education, vitamin A, deworming."),
          ("Programme manager + business analyst", "Adjudicate the L2 dependency table: adapt the WHO immunization DAK, reuse SMART Base, reject the others."),
          ("Clinical SME", "Review the 12 Uganda decision tables, rule by rule, against the L1 they cite; the highlighted rules rest on WHO values pending UNEPI.")]


CSS = """
:root{--bg:#f6f8f6;--surface:#ffffff;--ink:#17231f;--muted:#5b6b65;--line:#d6e0dc;--green:#0b5a4a;--green-soft:#e2efe9;--amber:#a45c00;--amber-soft:#fbefd9;--blue:#245b8f;--blue-soft:#e3edf7;
--display:"Bitter",Georgia,serif;--body:"Public Sans",system-ui,sans-serif;--mono:"JetBrains Mono",ui-monospace,monospace}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#0f1715;--surface:#16211e;--ink:#e3ece8;--muted:#9bb0a8;--line:#2a3a35;--green:#6fcfb2;--green-soft:#173a31;--amber:#f0b45c;--amber-soft:#3a2a12;--blue:#8fbbe6;--blue-soft:#18293a;color-scheme:dark}}
:root[data-theme="dark"]{--bg:#0f1715;--surface:#16211e;--ink:#e3ece8;--muted:#9bb0a8;--line:#2a3a35;--green:#6fcfb2;--green-soft:#173a31;--amber:#f0b45c;--amber-soft:#3a2a12;--blue:#8fbbe6;--blue-soft:#18293a;color-scheme:dark}
body{background:var(--bg);color:var(--ink);font-family:var(--body);font-size:15px;line-height:1.5}
.wrap{max-width:1180px;margin:0 auto;padding-block:28px 64px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));display:grid;gap:28px}
h1,h2,h3{font-family:var(--display);text-wrap:balance;margin:0;color:var(--ink)}
h1{font-size:1.9rem;line-height:1.2}h2{font-size:1.35rem;border-bottom:2px solid var(--green);padding-bottom:6px}h3{font-size:1.1rem}
p{margin:0;max-width:72ch}.lede{color:var(--muted)}
nav{display:flex;flex-wrap:wrap;gap:8px}nav a{color:var(--green);text-decoration:none;border:1px solid var(--line);border-radius:999px;padding:3px 12px;background:var(--surface)}nav a:hover,nav a:focus-visible{border-color:var(--green);outline:none}
section{display:grid;gap:14px}
.stages{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:8px}
.stage{background:var(--surface);border:1px solid var(--line);border-radius:8px;padding:10px 12px;display:grid;gap:4px}
.stage b{font-size:.8rem;letter-spacing:.06em;text-transform:uppercase;color:var(--muted)}
.ok{color:var(--green)}.todo{color:var(--muted)}.bad{color:var(--amber)}
ol.review{margin:0;padding-left:1.4em;display:grid;gap:6px}ol.review li span{font-size:.78rem;letter-spacing:.05em;text-transform:uppercase;color:var(--green);font-weight:600;margin-right:6px}
.tablewrap{overflow-x:auto;border:1px solid var(--line);border-radius:8px;background:var(--surface)}
table{border-collapse:collapse;width:100%;font-variant-numeric:tabular-nums}
th{text-align:left;font-size:.75rem;letter-spacing:.06em;text-transform:uppercase;color:var(--muted);background:var(--green-soft);padding:8px 10px;position:sticky;top:0}
td{padding:8px 10px;border-top:1px solid var(--line);vertical-align:top}
tr:target{background:var(--amber-soft)}
.key{font-family:var(--mono);font-weight:600;color:var(--green);white-space:nowrap}
.mono{font-family:var(--mono);font-size:.82rem}.small{font-size:.85rem}.muted{color:var(--muted)}
q{quotes:"“" "”"}.scope{font-size:.8rem;color:var(--muted);margin-top:3px}
.pill{display:inline-block;font-size:.72rem;font-weight:600;letter-spacing:.03em;padding:1px 8px;border-radius:999px;background:var(--blue-soft);color:var(--blue);white-space:nowrap}
.pill.warn{background:var(--amber-soft);color:var(--amber)}.pill.adapt{background:var(--amber-soft);color:var(--amber)}.pill.reuse,.pill.extend{background:var(--green-soft);color:var(--green)}.pill.reject{background:var(--line);color:var(--muted)}
.chip{font-family:var(--mono);font-size:.75rem;color:var(--green);text-decoration:none;border:1px solid var(--line);border-radius:4px;padding:0 5px;margin:1px;display:inline-block}.chip:hover,.chip:focus-visible{border-color:var(--green);outline:none}
.figs{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:10px}
figure{margin:0;background:var(--surface);border:1px solid var(--line);border-radius:8px;padding:6px}figure img{display:block;width:100%;height:auto;border-radius:4px}figcaption{font-size:.78rem;color:var(--muted);padding-top:4px}
.meta{font-size:.85rem;color:var(--muted)}
ul.comps{margin:6px 0 0;padding-left:1.1em;display:grid;gap:3px;font-size:.85rem}
details.dt{background:var(--surface);border:1px solid var(--line);border-radius:8px;padding:10px 12px}details.dt[open]{display:grid;gap:8px}
summary{cursor:pointer;font-weight:600}summary:focus-visible{outline:2px solid var(--green);outline-offset:2px}
.note{font-size:.8rem;margin-top:4px;color:var(--muted)}.note.pending{color:var(--amber)}
@media (prefers-reduced-motion:reduce){*{scroll-behavior:auto}}
"""


def main():
    l1 = load_l1()
    n_l1 = sum(len(v[0]["recommendations"]) for v in l1.values())
    stages = [("0 · Use case", "Issue #1", "ok"), ("1–2 · L1", f"{n_l1} statements, review requested", "ok"),
              ("3 · L2 dependencies", "Recommendation, review requested", "ok"), ("4 · L2 assets", "12 decision tables; more to come", "todo"),
              ("5–6 · L3", "Written first, out of order; to be re-derived", "bad")]
    st = "".join(f'<div class="stage"><b>{e(a)}</b><span class="{c}">{e(b)}</span></div>' for a, b, c in stages)
    rv = "".join(f"<li><span>{e(r)}</span>{e(t)}</li>" for r, t in REVIEW)
    doc = f'''<title>Uganda Immunisation DAK Review</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Bitter:wght@600;700&family=JetBrains+Mono:wght@400;600&family=Public+Sans:wght@400;600&display=swap">
<style>{CSS}</style>
<div class="wrap">
<header style="display:grid;gap:10px">
<p class="mono small muted">litlfred/smart-immunizations-uganda · PR #3 · smart-guideline-end-to-end</p>
<h1>Uganda immunisation adaptation: L1 and L2 for review</h1>
<p class="lede">What the agent extracted from the Ministry of Health schedule poster and the UNEPI deck, the scenario each statement implies, and the Uganda decision tables built on them. Everything here is a candidate until the named reviewer signs it.</p>
<nav><a href="#stages">Stages</a><a href="#review">Review</a><a href="#l1">L1 statements</a><a href="#deps">L2 dependencies</a><a href="#dmn">Decision tables</a></nav>
</header>
<section id="stages"><h2>Where the work stands</h2><div class="stages">{st}</div></section>
<section id="review"><h2>Review requested</h2><ol class="review">{rv}</ol></section>
<section id="l1"><h2>L1 statements</h2><p class="small muted">Each statement is verbatim in its source: an inspected transcription of a slide image, or of the rendered poster with its words checked against the text layer. Persona and process are reused from the WHO immunization DAK.</p>{l1_section(l1)}</section>
<section id="deps"><h2>L2 dependencies</h2>{deps_section()}</section>
<section id="dmn"><h2>Uganda scheduling decision tables</h2><p class="small muted">One table per vaccine (DMN, input/dmn). Click an L1 chip to jump to the statement a rule rests on. Rules marked in amber use a WHO value because the Uganda sources are silent.</p>{dmn_tables()}</section>
</div>'''
    out = ROOT / "docs/review/index.html"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(doc, encoding="utf-8")
    print(f"wrote {out.relative_to(ROOT)} ({len(doc)//1024} KB)")


if __name__ == "__main__":
    sys.exit(main())
