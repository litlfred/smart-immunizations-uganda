// Adapted from the WHO Immunization IG rulesets PlanDefMain and
// PlanDefCommunicationRequestAction.
RuleSet: UGPlanDefMain( name, library, version )
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-shareableplandefinition"
* meta.profile[+] = "http://hl7.org/fhir/uv/crmi/StructureDefinition/crmi-publishableplandefinition"
* library = Canonical({library})
* extension[+]
  * url = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-knowledgeCapability"
  * valueCode = #computable
* version = "{version}"
* name = "{name}"
* status = #draft
* experimental = true
* relatedArtifact[+]
  * type = #citation
  * citation = "Uganda Ministry of Health, Uganda Routine Immunisation Schedule (poster)"
* relatedArtifact[+]
  * type = #citation
  * citation = "UNEPI, User requirements for SMART Guidelines (presentation): current schedule, catch-up schedule, sites of vaccines"
* relatedArtifact[+]
  * type = #depends-on
  * resource = "http://smart.who.int/immunizations/ImplementationGuide/smart.who.int.immunizations"

RuleSet: UGScheduleAction( title, description, condition, text )
* action[+]
  * title = "{title}"
  * description = {description}
  * condition[+]
    * kind = #applicability
    * expression
      * description = "{condition}"
      * language = #text/cql-identifier
      * expression = "{condition}"
  * definitionCanonical = $IMMZCR
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
