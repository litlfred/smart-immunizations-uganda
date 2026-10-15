Instance: UGIMMZSchedule
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-recommendationdefinition
Title: "Uganda routine immunisation schedule"
Description: """
Uganda routine immunisation schedule (UNEPI). One action per vaccine; each
action applies when the next dose of that vaccine is due or upcoming and
carries the due date and expiration in its communication text.
"""
Usage: #definition

* insert UGPlanDefMain( UGIMMZSchedule, UGIMMZScheduleLogic, 0.1.0 )

* insert UGScheduleAction([[BCG dose]], [["Provision of the BCG dose at birth"]], [[BCG recommended]], [[BCG message]])

* insert UGScheduleAction([[Hepatitis B birth dose]], [["Provision of the hepatitis B birth dose (not after 7 days of age)"]], [[Hepatitis B birth dose recommended]], [[Hepatitis B birth dose message]])

* insert UGScheduleAction([[OPV0]], [["Provision of the oral polio birth dose"]], [[OPV0 recommended]], [[OPV0 message]])

* insert UGScheduleAction([[OPV dose]], [["Provision of the next oral polio dose (6, 10, 14 weeks)"]], [[OPV recommended]], [[OPV message]])

* insert UGScheduleAction([[IPV dose]], [["Provision of the next inactivated polio dose (6, 14 weeks)"]], [[IPV recommended]], [[IPV message]])

* insert UGScheduleAction([[DTP-HepB-Hib dose]], [["Provision of the next pentavalent dose (6, 10, 14 weeks)"]], [[Penta recommended]], [[Penta message]])

* insert UGScheduleAction([[PCV dose]], [["Provision of the next pneumococcal conjugate dose (6, 10, 14 weeks)"]], [[PCV recommended]], [[PCV message]])

* insert UGScheduleAction([[Rotavirus dose]], [["Provision of the next rotavirus dose (6, 10, 14 weeks; not after 2 years of age)"]], [[Rotavirus recommended]], [[Rotavirus message]])

* insert UGScheduleAction([[Malaria dose]], [["Provision of the next malaria vaccine dose (6, 7, 8, 18 months)"]], [[Malaria recommended]], [[Malaria message]])

* insert UGScheduleAction([[Measles-rubella dose]], [["Provision of the next measles-rubella dose (9, 18 months)"]], [[MR recommended]], [[MR message]])

* insert UGScheduleAction([[Yellow fever dose]], [["Provision of the yellow fever dose (9 months)"]], [[Yellow fever recommended]], [[Yellow fever message]])

* insert UGScheduleAction([[HPV dose]], [["Provision of the single HPV dose for girls at 10 years"]], [[HPV recommended]], [[HPV message]])

* insert UGScheduleAction([[Td dose]], [["Provision of the next Td dose for women of child-bearing age (15 to 49 years)"]], [[Td recommended]], [[Td message]])
