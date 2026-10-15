
Instance: IMMZD18SDTPOnTimeStart
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-recommendationdefinition
Title: "IMMZ.D18.S.DTP.On-time start schedule"
Description: """
IMMZ.D18.S.DTP.On-time start schedule
Diphtheria–tetanus–pertussis (DTP) vaccination schedule, on-time start (at ≤ 12 months of age)
"""
Usage: #definition

* insert PlanDefMain( IMMZD18SDTPOnTimeStart, 0.1.0 )

* insert PlanDefCommunicationRequestAction([[DTP dose 1]], [["""
Provision of DTP dose 1
Trigger event: Child's birth
Trigger date: "Date of birth"
Create condition: DTP dose 1 should be provided if the client is older than 6 weeks of age.
"""]], [[DTP dose 1]], [[DTP dose 1 Create]])

* insert PlanDefCommunicationRequestAction([[DTP dose 2]], [["""
Provision of DTP dose 2
Trigger event: First DTP dose from the primary series was administered 
Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series") = 1
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines")
Create condition: DTP dose 2 should be provided if the client was given the previous DTP dose more than 4 weeks ago.
"""]], [[DTP dose 2]], [[DTP dose 2 Create]])

* insert PlanDefCommunicationRequestAction([[DTP dose 3]], [["""
Provision of DTP dose 3
Trigger event: Second DTP dose from the primary series was administered 
Count of vaccines administered (where "Vaccine type" = "DTP-containing vaccines" and "Type of dose" = "Primary series" ) = 2
Trigger date: Latest "Date and time of vaccination" (where "Vaccine type" = "DTP-containing vaccines")
Create condition: DTP dose 3 should be provided if the client received the previous dose more than 4 weeks ago.
"""]], [[DTP dose 3]], [[DTP dose 3 Create]])
