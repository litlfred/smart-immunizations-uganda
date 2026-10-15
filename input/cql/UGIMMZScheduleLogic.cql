/*
 * Library: UGIMMZScheduleLogic
 * Uganda routine immunisation schedule (UNEPI).
 *
 * Sources:
 *  - Uganda Ministry of Health, "Uganda Routine Immunisation Schedule" poster
 *  - UNEPI, "User requirements SMART Guidelines" presentation: current
 *    immunisation schedule (slide 6) and catch-up schedule (slide 7)
 *
 * For each vaccine the library computes the next dose the client should
 * receive, its due date and, where Uganda sets one, its expiration (the last
 * date on which the dose may be given). A due date that is on or before Today
 * means the dose is due now: Uganda's rule is "at the scheduled age, or as
 * soon as possible thereafter". Uganda does not define an overdue date.
 *
 * Catch-up rules applied throughout (UNEPI catch-up schedule):
 *  - a dose is not given before 4 weeks have passed since the previous dose
 *    of the same vaccine;
 *  - a series is never restarted, however long the gap between doses;
 *  - there is no upper age limit, except rotavirus (not after 2 years of age)
 *    and the hepatitis B birth dose (not after 7 days of age). The childhood
 *    schedule is offered while the client is younger than the parameter
 *    "Childhood schedule upper age in years".
 */
library UGIMMZScheduleLogic

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

include UGIMMZElements called UG

parameter Today Date default Today()
parameter EncounterId String

/*
Upper age limit (exclusive, in years) for offering doses of the childhood
schedule (all vaccines except HPV and Td). Uganda states "no upper age limit
for most vaccines" for catch-up but does not say until what age the childhood
schedule is offered; 5 years is a placeholder pending confirmation by UNEPI
(see Open Questions).
*/
parameter "Childhood schedule upper age in years" Integer default 5

context Patient

/*
@internal: Date of birth of the client
*/
define "Date of birth":
  UG."Date of birth"

/*
@internal: The client is young enough to be offered doses of the childhood schedule
*/
define "Childhood schedule applies":
  AgeInYearsAt(Today) < "Childhood schedule upper age in years"

/*
@internal: Next dose number in a series of the given length, null once the series is complete
*/
define function NextDose(given Integer, seriesLength Integer):
  if given < seriesLength then given + 1 else null

/*
@internal: Due date of a dose: the scheduled age, but not earlier than the
minimum interval after the previous dose
*/
define function DueDate(scheduledDate Date, previousDose Date, minimumInterval System.Quantity):
  Max({ scheduledDate, previousDose + minimumInterval })

/*
@internal: A recommendation for the next dose of a vaccine
*/
define function Recommendation(vaccine String, doseNumber Integer, seriesLength Integer,
    dueDate Date, expiration Date, guidance String):
  if doseNumber is null or dueDate is null then null
  else Tuple {
    vaccine: vaccine,
    doseNumber: doseNumber,
    seriesLength: seriesLength,
    dueDate: dueDate,
    expiration: expiration,
    status:
      case
        when expiration is not null and Today > expiration then 'expired'
        when dueDate <= Today then 'due'
        else 'upcoming'
      end,
    guidance: guidance
  }

/*
@internal: Text shown to the health worker for a recommendation
*/
define function Message(R Tuple { vaccine String, doseNumber Integer, seriesLength Integer,
    dueDate Date, expiration Date, status String, guidance String }):
  if R is null or R.status = 'expired' then ''
  else R.vaccine + ' dose ' + ToString(R.doseNumber) + ' of ' + ToString(R.seriesLength)
    + ': ' + R.guidance
    + '\nDue Date: ' + ToString(R.dueDate)
    + Coalesce('\nExpiration: ' + ToString(R.expiration), '')

/*
@internal: The recommendation can still be acted on (it exists and has not expired)
*/
define function Actionable(R Tuple { vaccine String, doseNumber Integer, seriesLength Integer,
    dueDate Date, expiration Date, status String, guidance String }):
  R is not null and R.status != 'expired'


/* ----------------------------------------------------------------------
 * BCG: one dose at birth
 * -------------------------------------------------------------------- */

define "BCG next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."BCG doses"), 1) else null

define "BCG due date":
  if "BCG next dose" = 1 then "Date of birth" else null

define "BCG recommendation":
  Recommendation('BCG', "BCG next dose", 1, "BCG due date", null,
    'Give at birth, or as soon as possible thereafter. Intradermal, right upper arm.')

/*
@output: BCG dose
@description: Provision of the BCG dose
*/
define "BCG recommended":
  Actionable("BCG recommendation")

define "BCG message":
  Message("BCG recommendation")


/* ----------------------------------------------------------------------
 * Hepatitis B birth dose: at birth, ideally within 24 hours, not after 7 days
 * -------------------------------------------------------------------- */

define "Hepatitis B birth dose next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."Hepatitis B birth doses"), 1) else null

define "Hepatitis B birth dose due date":
  if "Hepatitis B birth dose next dose" = 1 then "Date of birth" else null

define "Hepatitis B birth dose expiration":
  "Date of birth" + 7 days

define "Hepatitis B birth dose recommendation":
  Recommendation('Hepatitis B birth dose', "Hepatitis B birth dose next dose", 1,
    "Hepatitis B birth dose due date", "Hepatitis B birth dose expiration",
    'Give as soon as possible after birth, ideally within 24 hours. Not after 7 days. Intramuscular.')

/*
@output: Hepatitis B birth dose
@description: Provision of the hepatitis B birth dose
*/
define "Hepatitis B birth dose recommended":
  Actionable("Hepatitis B birth dose recommendation")

define "Hepatitis B birth dose message":
  Message("Hepatitis B birth dose recommendation")


/* ----------------------------------------------------------------------
 * OPV0: oral polio birth dose. Only offered while no later polio dose has
 * been given. Uganda does not set a cut-off; the WHO Immunization IG
 * (IMMZD18SPolioBirthDoseLogic) uses 1 week after birth.
 * -------------------------------------------------------------------- */

define "OPV0 next dose":
  if "Childhood schedule applies" and Count(UG."OPV0 doses") = 0 and Count(UG."OPV primary doses") = 0
  then 1 else null

define "OPV0 due date":
  if "OPV0 next dose" = 1 then "Date of birth" else null

define "OPV0 expiration":
  "Date of birth" + 1 week

define "OPV0 recommendation":
  Recommendation('OPV0 (oral polio birth dose)', "OPV0 next dose", 1, "OPV0 due date", "OPV0 expiration",
    'Give at birth, or as soon as possible thereafter. Oral.')

/*
@output: OPV0
@description: Provision of the oral polio birth dose
*/
define "OPV0 recommended":
  Actionable("OPV0 recommendation")

define "OPV0 message":
  Message("OPV0 recommendation")


/* ----------------------------------------------------------------------
 * OPV1-OPV3: 6, 10 and 14 weeks; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "OPV next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."OPV primary doses"), 3) else null

define "OPV due date":
  case "OPV next dose"
    when 1 then "Date of birth" + 6 weeks
    when 2 then DueDate("Date of birth" + 10 weeks, UG.LatestDate(UG."OPV primary doses"), 4 weeks)
    when 3 then DueDate("Date of birth" + 14 weeks, UG.LatestDate(UG."OPV primary doses"), 4 weeks)
    else null
  end

define "OPV recommendation":
  Recommendation('OPV', "OPV next dose", 3, "OPV due date", null,
    'Scheduled at 6, 10 and 14 weeks, or as soon as possible thereafter; at least 4 weeks after the previous dose. Oral.')

/*
@output: OPV dose
@description: Provision of the next oral polio primary series dose
*/
define "OPV recommended":
  Actionable("OPV recommendation")

define "OPV message":
  Message("OPV recommendation")


/* ----------------------------------------------------------------------
 * IPV: 6 and 14 weeks; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "IPV next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."IPV doses"), 2) else null

define "IPV due date":
  case "IPV next dose"
    when 1 then "Date of birth" + 6 weeks
    when 2 then DueDate("Date of birth" + 14 weeks, UG.LatestDate(UG."IPV doses"), 4 weeks)
    else null
  end

define "IPV recommendation":
  Recommendation('IPV', "IPV next dose", 2, "IPV due date", null,
    'Scheduled at 6 and 14 weeks, or as soon as possible thereafter; at least 4 weeks after the previous dose. Intramuscular, right thigh, 2 cm from PCV.')

/*
@output: IPV dose
@description: Provision of the next inactivated polio vaccine dose
*/
define "IPV recommended":
  Actionable("IPV recommendation")

define "IPV message":
  Message("IPV recommendation")


/* ----------------------------------------------------------------------
 * Pentavalent DTP-HepB-Hib: 6, 10 and 14 weeks; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "Penta next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."Penta doses"), 3) else null

define "Penta due date":
  case "Penta next dose"
    when 1 then "Date of birth" + 6 weeks
    when 2 then DueDate("Date of birth" + 10 weeks, UG.LatestDate(UG."Penta doses"), 4 weeks)
    when 3 then DueDate("Date of birth" + 14 weeks, UG.LatestDate(UG."Penta doses"), 4 weeks)
    else null
  end

define "Penta recommendation":
  Recommendation('DTP-HepB-Hib (pentavalent)', "Penta next dose", 3, "Penta due date", null,
    'Scheduled at 6, 10 and 14 weeks, or as soon as possible thereafter; at least 4 weeks after the previous dose. Intramuscular, left thigh.')

/*
@output: Pentavalent dose
@description: Provision of the next DTP-HepB-Hib dose
*/
define "Penta recommended":
  Actionable("Penta recommendation")

define "Penta message":
  Message("Penta recommendation")


/* ----------------------------------------------------------------------
 * PCV: 6, 10 and 14 weeks; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "PCV next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."PCV doses"), 3) else null

define "PCV due date":
  case "PCV next dose"
    when 1 then "Date of birth" + 6 weeks
    when 2 then DueDate("Date of birth" + 10 weeks, UG.LatestDate(UG."PCV doses"), 4 weeks)
    when 3 then DueDate("Date of birth" + 14 weeks, UG.LatestDate(UG."PCV doses"), 4 weeks)
    else null
  end

define "PCV recommendation":
  Recommendation('PCV', "PCV next dose", 3, "PCV due date", null,
    'Scheduled at 6, 10 and 14 weeks, or as soon as possible thereafter; at least 4 weeks after the previous dose. Intramuscular, right thigh, 2 cm from IPV.')

/*
@output: PCV dose
@description: Provision of the next pneumococcal conjugate vaccine dose
*/
define "PCV recommended":
  Actionable("PCV recommendation")

define "PCV message":
  Message("PCV recommendation")


/* ----------------------------------------------------------------------
 * Rotavirus: 6, 10 and 14 weeks; at least 4 weeks apart; not after 2 years
 * -------------------------------------------------------------------- */

define "Rotavirus next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."Rotavirus doses"), 3) else null

define "Rotavirus due date":
  case "Rotavirus next dose"
    when 1 then "Date of birth" + 6 weeks
    when 2 then DueDate("Date of birth" + 10 weeks, UG.LatestDate(UG."Rotavirus doses"), 4 weeks)
    when 3 then DueDate("Date of birth" + 14 weeks, UG.LatestDate(UG."Rotavirus doses"), 4 weeks)
    else null
  end

define "Rotavirus expiration":
  "Date of birth" + 2 years - 1 day

define "Rotavirus recommendation":
  Recommendation('Rotavirus', "Rotavirus next dose", 3, "Rotavirus due date", "Rotavirus expiration",
    'Scheduled at 6, 10 and 14 weeks, or as soon as possible thereafter; at least 4 weeks after the previous dose. Not after 2 years of age. Oral.')

/*
@output: Rotavirus dose
@description: Provision of the next rotavirus vaccine dose
*/
define "Rotavirus recommended":
  Actionable("Rotavirus recommendation")

define "Rotavirus message":
  Message("Rotavirus recommendation")


/* ----------------------------------------------------------------------
 * Measles-rubella: MR1 at 9 months, MR2 at 18 months; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "MR next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."MR doses"), 2) else null

define "MR due date":
  case "MR next dose"
    when 1 then "Date of birth" + 9 months
    when 2 then DueDate("Date of birth" + 18 months, UG.LatestDate(UG."MR doses"), 4 weeks)
    else null
  end

define "MR recommendation":
  Recommendation('Measles-rubella (MR)', "MR next dose", 2, "MR due date", null,
    'MR1 at 9 months and MR2 at 18 months, or as soon as possible thereafter; MR2 at least 4 weeks after MR1. Not before 9 months of age. Subcutaneous, left upper arm.')

/*
@output: Measles-rubella dose
@description: Provision of the next measles-rubella dose
*/
define "MR recommended":
  Actionable("MR recommendation")

define "MR message":
  Message("MR recommendation")


/* ----------------------------------------------------------------------
 * Yellow fever: one dose at 9 months
 * -------------------------------------------------------------------- */

define "Yellow fever next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."Yellow fever doses"), 1) else null

define "Yellow fever due date":
  if "Yellow fever next dose" = 1 then "Date of birth" + 9 months else null

define "Yellow fever recommendation":
  Recommendation('Yellow fever', "Yellow fever next dose", 1, "Yellow fever due date", null,
    'Give at 9 months, or as soon as possible thereafter. Not before 9 months of age. Subcutaneous, right upper arm.')

/*
@output: Yellow fever dose
@description: Provision of the yellow fever dose
*/
define "Yellow fever recommended":
  Actionable("Yellow fever recommendation")

define "Yellow fever message":
  Message("Yellow fever recommendation")


/* ----------------------------------------------------------------------
 * Malaria: 6, 7, 8 and 18 months; at least 4 weeks apart
 * -------------------------------------------------------------------- */

define "Malaria next dose":
  if "Childhood schedule applies" then NextDose(Count(UG."Malaria doses"), 4) else null

define "Malaria due date":
  case "Malaria next dose"
    when 1 then "Date of birth" + 6 months
    when 2 then DueDate("Date of birth" + 7 months, UG.LatestDate(UG."Malaria doses"), 4 weeks)
    when 3 then DueDate("Date of birth" + 8 months, UG.LatestDate(UG."Malaria doses"), 4 weeks)
    when 4 then DueDate("Date of birth" + 18 months, UG.LatestDate(UG."Malaria doses"), 4 weeks)
    else null
  end

define "Malaria recommendation":
  Recommendation('Malaria', "Malaria next dose", 4, "Malaria due date", null,
    'Scheduled at 6, 7, 8 and 18 months, or as soon as possible thereafter; at least 4 weeks after the previous dose.')

/*
@output: Malaria dose
@description: Provision of the next malaria vaccine dose
*/
define "Malaria recommended":
  Actionable("Malaria recommendation")

define "Malaria message":
  Message("Malaria recommendation")


/* ----------------------------------------------------------------------
 * HPV: one dose for girls at 10 years of age
 * -------------------------------------------------------------------- */

define "HPV next dose":
  if UG."Client is female" then NextDose(Count(UG."HPV doses"), 1) else null

define "HPV due date":
  if "HPV next dose" = 1 then "Date of birth" + 10 years else null

/*
Uganda does not state an upper age for HPV. The WHO single-dose schedule
covers girls and women aged 9 to 20 years, so the dose is offered until the
day before the 21st birthday (see Open Questions).
*/
define "HPV expiration":
  "Date of birth" + 21 years - 1 day

define "HPV recommendation":
  Recommendation('HPV', "HPV next dose", 1, "HPV due date", "HPV expiration",
    'One dose for girls at 10 years of age, to prevent cancer of the cervix.')

/*
@output: HPV dose
@description: Provision of the single HPV dose
*/
define "HPV recommended":
  Actionable("HPV recommendation")

define "HPV message":
  Message("HPV recommendation")


/* ----------------------------------------------------------------------
 * Tetanus-diphtheria (Td) for women of child-bearing age (15 to 49 years):
 * Td1 at first contact, Td2 1 month after Td1, Td3 6 months after Td2,
 * Td4 12 months after Td3, Td5 12 months after Td4
 * -------------------------------------------------------------------- */

define "Client is a woman of child-bearing age":
  UG."Client is female"
    and AgeInYearsAt(Today) >= 15
    and AgeInYearsAt(Today) <= 49

define "Td next dose":
  if "Client is a woman of child-bearing age" then NextDose(Count(UG."Td doses"), 5) else null

define "Date of latest Td dose":
  UG.LatestDate(UG."Td doses")

define "Td due date":
  case "Td next dose"
    when 1 then "Date of birth" + 15 years
    when 2 then "Date of latest Td dose" + 1 month
    when 3 then "Date of latest Td dose" + 6 months
    when 4 then "Date of latest Td dose" + 12 months
    when 5 then "Date of latest Td dose" + 12 months
    else null
  end

define "Td recommendation":
  Recommendation('Tetanus-diphtheria (Td)', "Td next dose", 5, "Td due date", null,
    'Women of child-bearing age (15 to 49 years): Td1 at first contact, Td2 1 month after Td1, Td3 6 months after Td2, Td4 12 months after Td3, Td5 12 months after Td4.')

/*
@output: Td dose
@description: Provision of the next Td dose for a woman of child-bearing age
*/
define "Td recommended":
  Actionable("Td recommendation")

define "Td message":
  Message("Td recommendation")


/* ----------------------------------------------------------------------
 * Summary
 * -------------------------------------------------------------------- */

/*
@output: All recommendations
@description: Next dose of each vaccine in the Uganda routine schedule, with
its status ('due', 'upcoming' or 'expired'), in schedule order
*/
define "Recommendations":
  ({ "BCG recommendation", "Hepatitis B birth dose recommendation", "OPV0 recommendation",
     "OPV recommendation", "IPV recommendation", "Penta recommendation", "PCV recommendation",
     "Rotavirus recommendation", "Malaria recommendation", "MR recommendation",
     "Yellow fever recommendation", "HPV recommendation", "Td recommendation" }) R
    where R is not null

/*
@output: Doses due now
*/
define "Doses due":
  "Recommendations" R where R.status = 'due'

/*
@output: Upcoming doses
*/
define "Upcoming doses":
  "Recommendations" R where R.status = 'upcoming'
