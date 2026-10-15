
/*
 * Library: IMMZD18SDTPTdWCBALogic (UG.IMMZ.D18.S.DTP.Td women of childbearing age schedule)
 * Schedule Table: Tetanus and diphtheria (Td) vaccination schedule for women of childbearing age (15-49 years), Uganda

 * New Uganda table (no WHO counterpart), generated from the Uganda workbook's DTP tab by
 * processDTSchedule.js and completed from its pseudocode; citing L1 P11-P15, S14.
 */
library IMMZD18SDTPTdWCBALogic

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
@output: Td dose 1
@description: Provision of Td dose 1 for a woman of childbearing age
@trigger: Client is female, aged 15-49 years, and no Td dose was administered
@triggerDate: "Contact date"
*/
/*
@internal: Woman of childbearing age
@pseudocode: Client is female and aged 15-49 years (S14)
*/
define "Woman of childbearing age":
  Patient.gender = 'female'
    and AgeInYearsAt(Today) between 15 and 49

define "Td dose 1":
  "Woman of childbearing age"
    and not "First Td dose was administered"

/*
@output: Td dose 1 Create
@create: At first contact.
*/
define "Td dose 1 Create":
  if "Td dose 1" 
  then 'At first contact.' + '
Due Date: ' + ToString("Td dose 1 Due Date")
  else ''

/*
@dynamicValue: Td dose 1 Due Date
@pseudocode: "Contact date"
*/
define "Td dose 1 Due Date":
  if "Td dose 1" then Today
  else null

/*
@dynamicValue: Td dose 1 Overdue
@pseudocode: To be determined by Member States; however, there is no recommended overdue date.
*/
define "Td dose 1 Overdue":
  null

/*
@dynamicValue: Td dose 1 Expiration
@pseudocode: To be determined by Member States; however, there is no recommended expiration date.
*/
define "Td dose 1 Expiration":
  null
  
/*
@complete: First Td dose was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") = 1
*/
define "First Td dose was administered":
  Count(Encounter."Td Doses Administered to Patient") >= 1


/*
@output: Td dose 2
@description: Provision of Td dose 2 for a woman of childbearing age
@trigger: First Td dose was administered
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
*/
define "Td dose 2":
  "Woman of childbearing age"
    and "First Td dose was administered"
    and not "Second Td dose was administered"

/*
@output: Td dose 2 Create
@create: 1 month after dose 1.
*/
define "Td dose 2 Create":
  if "Td dose 2" 
  then '1 month after dose 1.' + '
Due Date: ' + ToString("Td dose 2 Due Date")
  else ''

/*
@dynamicValue: Td dose 2 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") + 1 month
*/
define "Td dose 2 Due Date":
  if "Td dose 2" then Encounter."Date of Latest Td Dose" + 1 month
  else null

/*
@dynamicValue: Td dose 2 Overdue
@pseudocode: To be determined by Member States; however, there is no recommended overdue date.
*/
define "Td dose 2 Overdue":
  null

/*
@dynamicValue: Td dose 2 Expiration
@pseudocode: To be determined by Member States; however, there is no recommended expiration date.
*/
define "Td dose 2 Expiration":
  null
  
/*
@complete: Second Td dose was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") = 2
*/
define "Second Td dose was administered":
  Count(Encounter."Td Doses Administered to Patient") >= 2


/*
@output: Td dose 3
@description: Provision of Td dose 3 for a woman of childbearing age
@trigger: Second Td dose was administered
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
*/
define "Td dose 3":
  "Woman of childbearing age"
    and "Second Td dose was administered"
    and not "Third Td dose was administered"

/*
@output: Td dose 3 Create
@create: 6 months after dose 2.
*/
define "Td dose 3 Create":
  if "Td dose 3" 
  then '6 months after dose 2.' + '
Due Date: ' + ToString("Td dose 3 Due Date")
  else ''

/*
@dynamicValue: Td dose 3 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") + 6 months
*/
define "Td dose 3 Due Date":
  if "Td dose 3" then Encounter."Date of Latest Td Dose" + 6 months
  else null

/*
@dynamicValue: Td dose 3 Overdue
@pseudocode: To be determined by Member States; however, there is no recommended overdue date.
*/
define "Td dose 3 Overdue":
  null

/*
@dynamicValue: Td dose 3 Expiration
@pseudocode: To be determined by Member States; however, there is no recommended expiration date.
*/
define "Td dose 3 Expiration":
  null
  
/*
@complete: Third Td dose was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") = 3
*/
define "Third Td dose was administered":
  Count(Encounter."Td Doses Administered to Patient") >= 3


/*
@output: Td dose 4
@description: Provision of Td dose 4 for a woman of childbearing age
@trigger: Third Td dose was administered
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
*/
define "Td dose 4":
  "Woman of childbearing age"
    and "Third Td dose was administered"
    and not "Fourth Td dose was administered"

/*
@output: Td dose 4 Create
@create: 12 months after dose 3.
*/
define "Td dose 4 Create":
  if "Td dose 4" 
  then '12 months after dose 3.' + '
Due Date: ' + ToString("Td dose 4 Due Date")
  else ''

/*
@dynamicValue: Td dose 4 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") + 12 months
*/
define "Td dose 4 Due Date":
  if "Td dose 4" then Encounter."Date of Latest Td Dose" + 12 months
  else null

/*
@dynamicValue: Td dose 4 Overdue
@pseudocode: To be determined by Member States; however, there is no recommended overdue date.
*/
define "Td dose 4 Overdue":
  null

/*
@dynamicValue: Td dose 4 Expiration
@pseudocode: To be determined by Member States; however, there is no recommended expiration date.
*/
define "Td dose 4 Expiration":
  null
  
/*
@complete: Fourth Td dose was administered
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") = 4
*/
define "Fourth Td dose was administered":
  Count(Encounter."Td Doses Administered to Patient") >= 4


/*
@output: Td dose 5
@description: Provision of Td dose 5 for a woman of childbearing age
@trigger: Fourth Td dose was administered
@triggerDate: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
*/
define "Td dose 5":
  "Woman of childbearing age"
    and "Fourth Td dose was administered"
    and not "Fifth Td dose was administered. The schedule is complete."

/*
@output: Td dose 5 Create
@create: 12 months after dose 4.
*/
define "Td dose 5 Create":
  if "Td dose 5" 
  then '12 months after dose 4.' + '
Due Date: ' + ToString("Td dose 5 Due Date")
  else ''

/*
@dynamicValue: Td dose 5 Due Date
@pseudocode: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") + 12 months
*/
define "Td dose 5 Due Date":
  if "Td dose 5" then Encounter."Date of Latest Td Dose" + 12 months
  else null

/*
@dynamicValue: Td dose 5 Overdue
@pseudocode: To be determined by Member States; however, there is no recommended overdue date.
*/
define "Td dose 5 Overdue":
  null

/*
@dynamicValue: Td dose 5 Expiration
@pseudocode: To be determined by Member States; however, there is no recommended expiration date.
*/
define "Td dose 5 Expiration":
  null
  
/*
@complete: Fifth Td dose was administered. The schedule is complete.
@pseudocode: Count of vaccines administered (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines") = 5
*/
define "Fifth Td dose was administered. The schedule is complete.":
  Count(Encounter."Td Doses Administered to Patient") >= 5


/*
@test: Test expected results based on example patients
*/
define "Test Validation":
  case
    when Patient.id = 'UGTd01' then "Td dose 1"
    when Patient.id = 'UGTd02' then "Td dose 3"
    when Patient.id = 'UGTd03' then not "Td dose 1"
    else 'No test case set'
  end
