// Copied from litlfred/smart-immunizations input/fsh/rulesets/LogicLibrary.fsh: FHIR packages do not export
// rulesets, so the generator's output (processDTSchedule.js) needs them here. Changed for Uganda:
// the publisher (Uganda changes are not WHO's) and, for PlanDefinitions, the Uganda citation.
RuleSet: LogicLibrary( library )
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-shareablelibrary"
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-publishablelibrary"
* meta.profile[+] = "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-library"
* meta.profile[+] = "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-module"
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-knowledgeCapability"
  * valueCode = #computable
* name = "{library}"
* status = #draft
* experimental = false
* publisher = "smart-immunizations-uganda (draft adaptation of WHO SMART Immunizations; not an official Ministry of Health publication)"
* type = $library-type#logic-library
* content
  * id = "ig-loader-{library}.cql"

