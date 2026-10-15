/*
 * Library: IMMZD18SHepatitisBBirthDoseLogic (IMMZ.D18.S.Hepatitis B.Birth dose schedule)
 * Schedule Table: Birth dose schedule

 * Uganda adaptation of the WHO library of the same name: the definitions marked
 * 'Uganda' follow the Uganda copy of the DAK workbook
 * (input/decision-logic/IMMZ DAK_decision-support logic.xlsx), citing L1 C01, C08.
 */
library IMMZD18SHepatitisBBirthDoseLogic

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

include WHOCommon called WC

include IMMZCommon called Common
include IMMZConcepts called Concepts

include IMMZEncounterElements called IE
include IMMZD2DTHepatitisBEncounterElements called Encounter

parameter Today Date default Today()


context Patient


/*
@output: Hepatitis B birth dose
@description: Provision of hepatitis B birth dose
@trigger: Child's birth
@pseudo: 
@triggerDate: "Date of birth"
*/
define "Hepatitis B birth dose":
  not "Hepatitis B birth dose was administered"


/*
@output: Hepatitis B birth dose Create
@create: All infants should receive a first dose of the hepatitis B-containing vaccine as soon as possible after birth, ideally within 24 hours
*/
define "Hepatitis B birth dose Create":
  if "Hepatitis B birth dose"
  then 'All infants should receive a first dose of the hepatitis B-containing vaccine as soon as possible after birth, ideally within 24 hours' + '
Due Date: ' + ToString("Hepatitis B birth dose Due Date") + '
Overdue: ' + ToString("Hepatitis B birth dose Overdue") + '
Expiration: ' + ToString("Hepatitis B birth dose Expiration")
  else ''


/*
@dynamicValue: Hepatitis B birth dose Due Date
@pseudocode: "Date of birth"
*/
define "Hepatitis B birth dose Due Date":
  if "Hepatitis B birth dose" then Patient.birthDate
  else null


/*
@dynamicValue: Hepatitis B birth dose Overdue
@pseudocode: "Date of birth" + 24 hours
*/
define "Hepatitis B birth dose Overdue":
  if "Hepatitis B birth dose" then Patient.birthDate + 24 hours
  else null


/*
@dynamicValue: Hepatitis B birth dose Expiration
@pseudocode: "Date of birth" + 7 days
*/
define "Hepatitis B birth dose Expiration":
  // Uganda: C08 "Hep B BD: Not after 7 days"
  if "Hepatitis B birth dose" then Patient.birthDate + 7 days
  else null

  
/*
@complete: Hepatitis B birth dose was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Hepatitis B-containing vaccines" and "Birth Dose" = TRUE) = 1
*/
define "Hepatitis B birth dose was administered":
  Encounter."Hepatitis B birth dose was administered"



/*
@test: Test expected results based on example patients
*/
define "Test Validation":
  case
    when Patient.id = 'UGHepB01' then "Hepatitis B birth dose"
    when Patient.id = 'UGHepB02' then not "Hepatitis B birth dose"
    else 'No test case set'
  end
