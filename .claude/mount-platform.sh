#!/usr/bin/env bash
# Put the platform layers index.lock.json pins on disk for this session
# (smart-base, fhir-harness, cat-harness, ...), as site-publish.yml does in
# litlfred/smart-immunizations. Without it no SMART authoring skill or process
# is on disk, and an agent cannot find smart-guideline-end-to-end
# (smart-base smart-guideline-create §6). Idempotent.
set -uo pipefail
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/..}" || exit 0
ref=$(python3 -c "import json;print(next(m['ref'] for m in json.load(open('index.lock.json'))['mounts'] if m['harness']=='cat-harness-tools'))") || exit 0
M="${TMPDIR:-/tmp}/uganda-mounter"
if [ ! -d "$M/.git" ] || [ "$(git -C "$M" rev-parse HEAD 2>/dev/null)" != "$ref" ]; then
  rm -rf "$M"; git init -q "$M"
  git -C "$M" fetch -q --depth 1 https://github.com/litlfred/cat-harness-tools.git "$ref" \
    && git -C "$M" checkout -q FETCH_HEAD \
    || { echo "mount-platform: could not fetch cat-harness-tools@$ref" >&2; exit 0; }
fi
bun run "$M/scripts/mount-from-lock.ts" --root . 2>&1 | tail -1
for d in $(python3 -c "import json;print(' '.join(sorted({i['path'] for i in json.load(open('index.lock.json'))['instances']})))"); do
  [ -f "$d/package.json" ] && (cd "$d" && bun install --no-save >/dev/null 2>&1)
done
# smart-base's kg/ (the L1/L2 graph schemas its L1 scripts import as ../../kg)
# lives at the smart-base repository root, outside the mounted smart-base/
# subtree: lay it down at the same pin, beside the mounts.
sb=$(python3 -c "import json;print(next(m['ref'] for m in json.load(open('index.lock.json'))['mounts'] if m['harness']=='smart-base'))")
K="${TMPDIR:-/tmp}/uganda-smart-base-kg"
if [ "$(git -C "$K" rev-parse HEAD 2>/dev/null)" != "$sb" ]; then
  rm -rf "$K"; git init -q "$K"
  git -C "$K" fetch -q --depth 1 https://github.com/litlfred/smart-base.git "$sb" && git -C "$K" checkout -q FETCH_HEAD \
    || echo "mount-platform: could not fetch smart-base@$sb for kg/" >&2
fi
[ -d "$K/kg" ] && ln -sfn "$K/kg" kg && (cd kg && bun install >/dev/null 2>&1)
exit 0
