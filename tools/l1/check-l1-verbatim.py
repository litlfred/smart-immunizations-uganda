#!/usr/bin/env python3
"""Check the authored Uganda L1 against its library entries.

For each *.l1.yaml under library/l1-recommendation-scenarios/uganda/:

* a statement with `image: <id>` must be a verbatim substring of that image's
  narrative in the entry's images.json (the inspection transcription);
* a statement with `from: <key>` must be a verbatim substring of that
  `transcription` block; and every non-digit word of every transcription block
  must occur in the entry's text layer (sections/*.md) after NFKC
  normalisation, so only digits and grouping rest on the inspection alone
  (a block may list `inspectionOnly` words, each list with its basis);
* keys are unique.

Exit 0 when everything holds, 1 with one line per finding otherwise.
"""
import glob, json, re, sys, unicodedata
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[2]


def norm(s: str) -> str:
    s = unicodedata.normalize("NFKC", s)
    s = "".join(c for c in s if not (0xE000 <= ord(c) <= 0xF8FF or 0x20D0 <= ord(c) <= 0x20FF))
    return re.sub(r"\s+", " ", s).strip()


def words(s: str) -> list[str]:
    return [w.lower() for w in re.findall(r"[A-Za-z][A-Za-z'-]*", norm(s))]


def main() -> int:
    findings: list[str] = []
    files = sorted(glob.glob(str(ROOT / "library/l1-recommendation-scenarios/uganda/*.l1.yaml")))
    for f in files:
        doc = yaml.safe_load(open(f, encoding="utf-8"))
        name = Path(f).name
        entry = ROOT / doc["graph"]["source"]["entry"]
        narratives = {}
        if (entry / "images.json").exists():
            for img in json.load(open(entry / "images.json", encoding="utf-8"))["images"]:
                narratives[img["id"]] = norm((img.get("narrative") or {}).get("text") or "")
        layer = " ".join(words(" ".join(open(p, encoding="utf-8").read() for p in glob.glob(str(entry / "sections/*.md")))))
        layer_words = set(layer.split())
        blocks = {t["key"]: norm(t["text"]) for t in doc.get("transcription", [])}
        allowed = {t["key"]: set((t.get("inspectionOnly") or {}).get("words", [])) for t in doc.get("transcription", [])}
        for key, text in blocks.items():
            missing = sorted({w for w in words(text) if w not in layer_words and w not in allowed[key]})
            if missing:
                findings.append(f"{name} {key}: words not in the text layer: {', '.join(missing)}")
        seen = set()
        items = [("recommendation", r) for r in doc.get("recommendations", [])] + [("indicator", i) for i in doc.get("indicators", [])]
        for kind, r in items:
            key = r["key"]
            if key in seen:
                findings.append(f"{name} {key}: duplicate key")
            seen.add(key)
            text = norm(r.get("statement") or r.get("definition") or "")
            if "image" in r:
                hay, where = narratives.get(r["image"]), f"narrative of {r['image']}"
            elif "from" in r:
                hay, where = blocks.get(r["from"]), f"transcription {r['from']}"
            else:
                findings.append(f"{name} {key}: names neither an image nor a transcription block")
                continue
            if hay is None:
                findings.append(f"{name} {key}: {where} does not exist")
            elif text not in hay:
                findings.append(f"{name} {key}: {kind} is not verbatim in the {where}")
        print(f"{name}: {len(items)} statement(s), {len(blocks)} transcription block(s)")
    for line in findings:
        print("FINDING " + line)
    return 1 if findings or not files else 0


if __name__ == "__main__":
    sys.exit(main())
