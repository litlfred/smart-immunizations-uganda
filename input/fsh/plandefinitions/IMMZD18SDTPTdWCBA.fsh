
Instance: IMMZD18SDTPTdWCBA
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-recommendationdefinition
Title: "UG.IMMZ.D18.S.DTP.Td women of childbearing age schedule"
Description: """
UG.IMMZ.D18.S.DTP.Td women of childbearing age schedule
Tetanus and diphtheria (Td) vaccination schedule for women of childbearing age (15-49 years), Uganda
"""
Usage: #definition

* insert PlanDefMain( IMMZD18SDTPTdWCBA, 0.1.0 )

* insert PlanDefCommunicationRequestAction([[Td dose 1]], [["""
Provision of Td dose 1 for a woman of childbearing age
Trigger event: Client is female, aged 15-49 years, and no Td dose was administered
Trigger date: "Contact date"
Create condition: At first contact.
"""]], [[Td dose 1]], [[Td dose 1 Create]])

* insert PlanDefCommunicationRequestAction([[Td dose 2]], [["""
Provision of Td dose 2 for a woman of childbearing age
Trigger event: First Td dose was administered
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
Create condition: 1 month after dose 1.
"""]], [[Td dose 2]], [[Td dose 2 Create]])

* insert PlanDefCommunicationRequestAction([[Td dose 3]], [["""
Provision of Td dose 3 for a woman of childbearing age
Trigger event: Second Td dose was administered
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
Create condition: 6 months after dose 2.
"""]], [[Td dose 3]], [[Td dose 3 Create]])

* insert PlanDefCommunicationRequestAction([[Td dose 4]], [["""
Provision of Td dose 4 for a woman of childbearing age
Trigger event: Third Td dose was administered
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
Create condition: 12 months after dose 3.
"""]], [[Td dose 4]], [[Td dose 4 Create]])

* insert PlanDefCommunicationRequestAction([[Td dose 5]], [["""
Provision of Td dose 5 for a woman of childbearing age
Trigger event: Fourth Td dose was administered
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "Tetanus and diphtheria-containing vaccines")
Create condition: 12 months after dose 4.
"""]], [[Td dose 5]], [[Td dose 5 Create]])
