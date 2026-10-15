/*
 * Library: IMMZD18SDTPOnTimeStartLogic (IMMZ.D18.S.DTP.On-time start schedule)
 * Schedule Table: Diphtheria–tetanus–pertussis (DTP) vaccination schedule, on-time start (at ≤ 12 months of age)

 * Uganda adaptation of the WHO library of the same name: the definitions marked
 * 'Uganda' follow the Uganda copy of the DAK workbook
 * (input/decision-logic/IMMZ DAK_decision-support logic.xlsx), citing L1 S04.
 */
library IMMZD18SDTPOnTimeStartLogic

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

include WHOCommon called WC

include IMMZCommon called Common
include IMMZConcepts called Concepts

include IMMZEncounterElements called IE
include IMMZD2DTDTPEncounterElements called Encounter

parameter Today Date default Today()


context Patient


/*
@output: DTP dose 1
@description: Provision of DTP dose 1
@trigger: Child's birth
@pseudo: 
@triggerDate: "Date of birth"
*/
define "DTP dose 1":
  Encounter."No DTP primary series doses were administered"
  and "DTP dose 1 Expiration" after day of Today


/*
@output: DTP dose 1 Create
@create: DTP dose 1 should be provided if the client is older than 6 weeks of age.
*/
define "DTP dose 1 Create":
  if "DTP dose 1"
  then 'DTP dose 1 should be provided if the client is older than 6 weeks of age.' + '
Due Date: ' + ToString("DTP dose 1 Due Date") + '
Expiration: ' + ToString("DTP dose 1 Expiration")
  else ''


/*
@dynamicValue: DTP dose 1 Due Date
@pseudocode: "Date of birth" + 6 weeks
*/
define "DTP dose 1 Due Date":
  if "DTP dose 1" then Patient.birthDate + 6 weeks
  else null


/*
@dynamicValue: DTP dose 1 Overdue
@pseudocode: To be determined by Member States. The third dose of the primary series should be completed by 6 months of age if possible.
*/
define "DTP dose 1 Overdue":
  null


/*
@dynamicValue: DTP dose 1 Expiration
@pseudocode: "Date of birth" + 1 year
*/
define "DTP dose 1 Expiration":
  Patient.birthDate + 1 year

  
/*
@complete: First DTP dose from the primary series was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series") = 1
*/
define "First DTP dose from the primary series was administered":
  Encounter."One DTP primary series dose was administered"



/*
@output: DTP dose 2
@description: Provision of DTP dose 2
@trigger: First DTP dose from the primary series was administered
@pseudo: Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series") = 1
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines")
*/
define "DTP dose 2":
  "First DTP dose from the primary series was administered" and
  not "Second DTP dose from the primary series was administered"


/*
@output: DTP dose 2 Create
@create: DTP dose 2 should be provided if the client was given the previous DTP dose more than 4 weeks ago.
*/
define "DTP dose 2 Create":
  if "DTP dose 2"
  then 'DTP dose 2 should be provided if the client was given the previous DTP dose more than 4 weeks ago.' + '
Due Date: ' + ToString("DTP dose 2 Due Date") + '
Overdue: ' + ToString("DTP dose 2 Overdue")
  else ''


/*
@dynamicValue: DTP dose 2 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines") + 4 weeks
*/
define "DTP dose 2 Due Date":
  if "DTP dose 2" then Encounter."Date of Latest DTP Dose" + 4 weeks
  else null


/*
@dynamicValue: DTP dose 2 Overdue
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines") + 8 weeks
*/
define "DTP dose 2 Overdue":
  if "DTP dose 2" then Encounter."Date of Latest DTP Dose" + 8 weeks
  else null


/*
@dynamicValue: DTP dose 2 Expiration
@pseudocode: To be determined by Member States. However, there is no recommended expiration date and individuals remain eligible to be vaccinated.
*/
define "DTP dose 2 Expiration":
  null

  
/*
@complete: Second DTP dose from the primary series was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series") = 2
*/
define "Second DTP dose from the primary series was administered":
  Encounter."Two DTP primary series doses were administered"



/*
@output: DTP dose 3
@description: Provision of DTP dose 3
@trigger: Second DTP dose from the primary series was administered
@pseudo: Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series" ) = 2
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines")
*/
define "DTP dose 3":
  "Second DTP dose from the primary series was administered" and
  not "Third DTP dose from the primary series was administered. The primary DTP series has been completed"


/*
@output: DTP dose 3 Create
@create: DTP dose 3 should be provided if the client received the previous dose more than 4 weeks ago.
*/
define "DTP dose 3 Create":
  if "DTP dose 3"
  then 'DTP dose 3 should be provided if the client received the previous dose more than 4 weeks ago.' + '
Due Date: ' + ToString("DTP dose 3 Due Date") + '
Overdue: ' + ToString("DTP dose 3 Overdue")
  else ''


/*
@dynamicValue: DTP dose 3 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines") + 4 weeks
*/
define "DTP dose 3 Due Date":
  if "DTP dose 3" then Encounter."Date of Latest DTP Dose" + 4 weeks
  else null


/*
@dynamicValue: DTP dose 3 Overdue
@pseudocode: "Date of birth" + 6 months
*/
define "DTP dose 3 Overdue":
  if "DTP dose 3" then Patient.birthDate + 6 months
  else null


/*
@dynamicValue: DTP dose 3 Expiration
@pseudocode: To be determined by Member States. However, there is no recommended expiration date and individuals remain eligible to be vaccinated.
*/
define "DTP dose 3 Expiration":
  null

  
/*
@complete: Third DTP dose from the primary series was administered. The primary DTP series has been completed
@pseudocode: Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series") = 3
"Completed the primary vaccination series" = TRUE (where "Vaccine type" = "DTP-containing vaccines")
*/
define "Third DTP dose from the primary series was administered. The primary DTP series has been completed":
  Encounter."Three DTP primary series doses were administered"



/*
 Uganda: the booster rows of this table are not in the Uganda childhood schedule (S04, P02-P04)
 and are not generated; adjudication pending.
*/

/*
@test: Test expected results based on example patients
*/
define "Test Validation":
  case
    when Patient.id = 'UGDTP01' then "DTP dose 1"
    when Patient.id = 'UGDTP02' then "Third DTP dose from the primary series was administered. The primary DTP series has been completed"
    else 'No test case set'
  end
