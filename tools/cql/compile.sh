#!/usr/bin/env bash
# Compile the Uganda CQL libraries (input/cql/UG*.cql) to ELM JSON.
#
# The Uganda libraries include libraries of the WHO Immunization IG, so the
# WHO CQL sources are needed on the library path:
#   WHO_IMMZ_CQL=/path/to/smart-immunizations/input/cql tools/cql/compile.sh
# If WHO_IMMZ_CQL is not set, a shallow clone of the WHO IG is made in
# tests/vendor/.
#
# Output: tests/elm/*.json (ELM for the Uganda libraries, their WHO
# dependencies and FHIRHelpers). Exits non-zero on any translation error.
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
here="$root/tools/cql"
who_repo="${WHO_IMMZ_REPO:-https://github.com/WorldHealthOrganization/smart-immunizations.git}"

if [ ! -d "$here/lib" ]; then
  mvn -q -f "$here/pom.xml" dependency:copy-dependencies -DoutputDirectory="$here/lib"
fi

if [ -z "${WHO_IMMZ_CQL:-}" ]; then
  if [ ! -d "$root/tests/vendor/smart-immunizations" ]; then
    git clone --depth 1 -q "$who_repo" "$root/tests/vendor/smart-immunizations"
  fi
  WHO_IMMZ_CQL="$root/tests/vendor/smart-immunizations/input/cql"
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cp "$WHO_IMMZ_CQL"/*.cql "$work/"
cp "$root"/input/cql/UG*.cql "$work/"
unzip -p "$here"/lib/quick-*.jar org/hl7/fhir/FHIRHelpers-4.0.1.cql > "$work/FHIRHelpers.cql"

out="$root/tests/elm"
mkdir -p "$out"
status=0
for lib in FHIRHelpers WHOCommon WHOConcepts WHOElements IMMZCommon IMMZConcepts IMMZElements \
           IMMZEncounterElements UGIMMZElements UGIMMZScheduleLogic; do
  log="$(java -cp "$here/lib/*" org.cqframework.cql.cql2elm.cli.Main \
          --input "$work/$lib.cql" --output "$out" --format JSON \
          --result-types --signatures Overloads --detailed-errors 2>&1 \
        | grep -v '^Picked up JAVA_TOOL_OPTIONS' || true)"
  if echo "$log" | grep -q '^Error'; then
    echo "$log" | grep -E '^Error'
    echo "FAILED: $lib"
    status=1
  else
    echo "ok: $lib"
  fi
done
# The translator names files after the source file; give FHIRHelpers its library name.
exit $status
