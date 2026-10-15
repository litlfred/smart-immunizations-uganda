/*
 * Library: UGIMMZElements
 * Doses administered to the client, grouped the way the Uganda routine
 * immunisation schedule counts them. Builds on the data elements and value
 * sets of the WHO Immunization IG (IMMZEncounterElements, IMMZConcepts).
 */
library UGIMMZElements

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

include WHOCommon called WC
include IMMZCommon called Common
include IMMZConcepts called Concepts
include IMMZEncounterElements called IE

parameter Today Date default Today()
parameter EncounterId String

context Patient

/*
@internal: Date of birth of the client
*/
define "Date of birth":
  Patient.birthDate.value

/*
@internal: Biological sex of the client is female
*/
define "Client is female":
  Patient.gender = 'female'

/*
@internal: Date a dose was administered
*/
define function DateOf(I Immunization):
  date from start of I.occurrence.toInterval()

/*
@internal: Date of the latest dose in a list of doses (null when the list is empty)
*/
define function LatestDate(doses List<Immunization>):
  Max(doses D return DateOf(D))

/*
@internal: The dose was recorded as part of the "Dose 0" (birth dose) series
*/
define function IsDose0(I Immunization):
  exists (I.protocolApplied P where P.series = 'Dose 0')

/*
@internal: The dose was given before the client was 6 weeks old, the minimum
age for the first dose of the Uganda infant primary series
*/
define function GivenBefore6Weeks(I Immunization):
  DateOf(I) < "Date of birth" + 6 weeks

/*
@internal: All doses administered to the client up to and including Today
*/
define "Doses":
  IE."Doses Administered to Patient"

/*
@dataElement: BCG doses
*/
define "BCG doses":
  "Doses" D where D.vaccineCode in Concepts."BCG vaccines"

/*
@dataElement: Hepatitis B birth doses
@pseudocode: Hepatitis B-containing vaccine that is not a DTP combination,
recorded as "Dose 0" or given before 6 weeks of age
*/
define "Hepatitis B birth doses":
  "Doses" D
    where D.vaccineCode in Concepts."Hepatitis B-containing vaccines"
      and not (D.vaccineCode in Concepts."Pertussis-containing vaccines")
      and (IsDose0(D) or GivenBefore6Weeks(D))

/*
@dataElement: Oral polio doses
*/
define "OPV doses":
  "Doses" D where D.vaccineCode in Concepts."Oral polio vaccines"

/*
@dataElement: OPV0 doses (birth dose)
@pseudocode: Oral polio vaccine recorded as "Dose 0" or given before 6 weeks of age
*/
define "OPV0 doses":
  "OPV doses" D where IsDose0(D) or GivenBefore6Weeks(D)

/*
@dataElement: OPV primary series doses (OPV1-OPV3)
*/
define "OPV primary doses":
  "OPV doses" D where not (IsDose0(D) or GivenBefore6Weeks(D))

/*
@dataElement: IPV doses
*/
define "IPV doses":
  "Doses" D where D.vaccineCode in Concepts."Inactivated polio vaccines"

/*
@dataElement: Pentavalent (DTP-HepB-Hib) doses
@pseudocode: DTP-containing vaccine that is also pertussis-containing. The
WHO "DTP-containing vaccines" value set also lists Td (J07AM51), which is not
a pentavalent dose.
*/
define "Penta doses":
  "Doses" D
    where D.vaccineCode in Concepts."DTP-containing vaccines"
      and D.vaccineCode in Concepts."Pertussis-containing vaccines"

/*
@dataElement: Pneumococcal conjugate vaccine doses
*/
define "PCV doses":
  "Doses" D where D.vaccineCode in Concepts."Pneumococcal vaccines"

/*
@dataElement: Rotavirus vaccine doses
*/
define "Rotavirus doses":
  "Doses" D where D.vaccineCode in Concepts."Rotavirus vaccines"

/*
@dataElement: Measles-rubella doses counted towards MR1 and MR2
@pseudocode: Measles-containing vaccine given at 9 months of age or later and
not recorded as "Dose 0"
*/
define "MR doses":
  "Doses" D
    where D.vaccineCode in Concepts."Measles-containing vaccines"
      and not IsDose0(D)
      and DateOf(D) >= "Date of birth" + 9 months

/*
@dataElement: Yellow fever doses
*/
define "Yellow fever doses":
  "Doses" D where D.vaccineCode in Concepts."Yellow fever vaccines"

/*
@dataElement: Malaria vaccine doses
*/
define "Malaria doses":
  "Doses" D where D.vaccineCode in Concepts."Malaria vaccines"

/*
@dataElement: HPV doses
*/
define "HPV doses":
  "Doses" D where D.vaccineCode in Concepts."HPV vaccines"

/*
@dataElement: Tetanus-diphtheria (Td) doses for women of child-bearing age
@pseudocode: Tetanus and diphtheria-containing vaccine that is not
pertussis-containing (infant pentavalent doses are not counted)
*/
define "Td doses":
  "Doses" D
    where D.vaccineCode in Concepts."Tetanus and diphtheria-containing vaccines"
      and not (D.vaccineCode in Concepts."Pertussis-containing vaccines")
