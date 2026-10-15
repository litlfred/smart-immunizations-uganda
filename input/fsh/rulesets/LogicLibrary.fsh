// Adapted from the WHO Immunization IG ruleset of the same name
// (rulesets are not exported in FHIR packages, so they are copied here).
RuleSet: UGLogicLibrary( library )
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-shareablelibrary"
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-publishablelibrary"
* meta.profile[+] = "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-library"
* meta.profile[+] = "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-module"
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-knowledgeCapability"
  * valueCode = #computable
* name = "{library}"
* status = #draft
* experimental = true
* type = $library-type#logic-library
* content
  * id = "ig-loader-{library}.cql"
