// Copied from litlfred/smart-immunizations input/fsh/rulesets/rulesets-plandefinition.fsh: FHIR packages do not export
// rulesets, so the generator's output (processDTSchedule.js) needs them here. Changed for Uganda:
// the publisher (Uganda changes are not WHO's) and, for PlanDefinitions, the Uganda citation.

RuleSet: PlanDefMain( library, version )
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-shareableplandefinition"
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-publishableplandefinition"
* library = Canonical({library}Logic)
* extension[+]
  * url = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-knowledgeCapability"
  * valueCode = #computable
* version = "{version}"
* name = "{library}"
* status = #draft
* experimental = false
* publisher = "smart-immunizations-uganda (draft adaptation of WHO SMART Immunizations; not an official Ministry of Health publication)"
* relatedArtifact[+]
  * type = #citation
  * citation = "WHO recommendations for routine immunization - summary tables (January 2025)"
* relatedArtifact[+]
  * type = #citation
  * citation = "Ministry of Health, Uganda. Uganda Routine Immunisation Schedule; UNEPI, User requirements for SMART Guidelines (library/ of smart-immunizations-uganda)"

RuleSet: PlanDefMRAction( title, description, rationale, condition, code, display )
* action[+]
  * extension[+]
    * url = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-rationale"
    * valueMarkdown = {rationale}
  * title = "{title}"
  * description = {description}
  * condition[+]
    * kind = #applicability
    * expression
      * description = "{condition}"
      * language = #text/cql-identifier
      * expression = "{condition}"
  * definitionCanonical = Canonical(IMMZD2DTMR)
  * dynamicValue[+]
    * path = "status"
    * expression
      * language = #text/cql-expression
      * expression = "'draft'"
  * dynamicValue[+]
    * path = "intent"
    * expression
      * language = #text/cql-expression
      * expression = "'proposal'"
  * dynamicValue[+]
    * path = "medication"
    * expression
      * language = #text/cql-expression
      * expression = "Concept { codes: { Code { {code}, display: '{display}' } }, display: '{display}' }"

RuleSet: PlanDefMRUpdate( title, description, condition, mrid, code, display )
* action[+]
  * title = "{title}"
  * description = {description}
  * type = $action-type#update
  * condition[+]
    * kind = #applicability
    * expression
      * description = "{condition}"
      * language = #text/cql-identifier
      * expression = "{condition}"
  * definitionCanonical = Canonical(IMMZD5DTMR)
  * dynamicValue[+]
    * path = "id"
    * expression
      * description = "{mrid}"
      * language = #text/cql-identifier
      * expression = "{mrid}"
  * dynamicValue[+]
    * path = "medication"
    * expression
      * language = #text/cql-expression
      * expression = "Concept { codes: { Code { {code}, display: '{display}' } }, display: '{display}' }"

RuleSet: PlanDefCommunicationRequestAction( title, description, condition, text )
* action[+]
  * title = "{title}"
  * description = {description}
  * condition[+]
    * kind = #applicability
    * expression
      * description = "{condition}"
      * language = #text/cql-identifier
      * expression = "{condition}"
  * definitionCanonical = Canonical(IMMZD2DTCR)
  * dynamicValue[+]
    * path = "status"
    * expression
      * language = #text/cql-expression
      * expression = "'active'"
  * dynamicValue[+]
    * path = "payload.contentString"
    * expression
      * language = #text/cql-identifier
      * expression = "{text}"
/*
  * dynamicValue[+]
    * path = "payload.contentAttachment.language"
    * expression
      * language = #text/cql-expression
      * expression = "'en-US'"
  * dynamicValue[+]
    * path = "payload.contentAttachment.contentType"
    * expression
      * language = #text/cql-expression
      * expression = "'text/plain'"
*/
  * dynamicValue[+]
    * path = "category.coding"
    * expression
      * description = "Category of communication"
      * language = #text/cql-expression
      * expression = "Code { system: 'http://terminology.hl7.org/CodeSystem/communication-category', code: 'alert' }"
  * dynamicValue[+]
    * path = "priority"
    * expression
      * description = "Alert priority"
      * language = #text/cql-expression
      * expression = "Code { system: 'http://hl7.org/fhir/request-priority', code: 'routine' }"