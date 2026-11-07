// The UNEPI user requirements as DAK component 8 logical-model instances (smart-base
// FunctionalRequirement / NonFunctionalRequirement), one per row of requirements.md.
// Authored, not extracted: WHO's req_extractor.py reads a workbook whose functional rows
// need "As a" and "So that", which the deck does not state. So no actor and no benefit
// are recorded (both optional in the model) and nothing is supplied that the deck does not say.
// The SGRequirements (R5 Requirements) form is not written: this IG is R4.

Instance: UG-FR-01
InstanceOf: FunctionalRequirement
Title: "UG-FR-01 User authentication and access control"
Description: "Functional requirement UG-FR-01 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-01"
* activity = "User authentication and access control"
* capabilityString = "Username/password, biometric authentication"

Instance: UG-FR-02
InstanceOf: FunctionalRequirement
Title: "UG-FR-02 Patient record management"
Description: "Functional requirement UG-FR-02 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-02"
* activity = "Patient record management"
* capabilityString = "Personal information, vaccination history and demographic data"

Instance: UG-FR-03
InstanceOf: FunctionalRequirement
Title: "UG-FR-03 Vaccine inventory management"
Description: "Functional requirement UG-FR-03 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-03"
* activity = "Vaccine inventory management"
* capabilityString = "Batch numbers, expiration dates and current stock"

Instance: UG-FR-04
InstanceOf: FunctionalRequirement
Title: "UG-FR-04 Vaccination scheduling and reminders"
Description: "Functional requirement UG-FR-04 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines). Supported by this guide's scheduling logic (the IMMZD18S PlanDefinitions)."
Usage: #definition
* id = "UG-FR-04"
* activity = "Vaccination scheduling and reminders"
* capabilityString = "Scheduling of vaccination appointments and reminders to patients or guardians"

Instance: UG-FR-05
InstanceOf: FunctionalRequirement
Title: "UG-FR-05 Immunization reporting and analytics"
Description: "Functional requirement UG-FR-05 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-05"
* activity = "Immunization reporting and analytics"
* capabilityString = "Reports such as immunization coverage rates, vaccine wastage and adverse event tracking"

Instance: UG-FR-06
InstanceOf: FunctionalRequirement
Title: "UG-FR-06 Adverse event reporting"
Description: "Functional requirement UG-FR-06 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-06"
* activity = "Adverse event reporting"
* capabilityString = "Report and document adverse events following immunization (AEFI)"

Instance: UG-FR-07
InstanceOf: FunctionalRequirement
Title: "UG-FR-07 Integration with health records"
Description: "Functional requirement UG-FR-07 for an electronic immunization registry, as stated on slide 17 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-FR-07"
* activity = "Integration with health records"
* capabilityString = "Integrate with existing electronic health record systems for comprehensive patient health information"

Instance: UG-NFR-01
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-01 Interoperability"
Description: "Non-functional requirement UG-NFR-01 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-01"
* requirement = "Interoperability: Data exchange"

Instance: UG-NFR-02
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-02 Security and privacy"
Description: "Non-functional requirement UG-NFR-02 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-02"
* requirement = "Security and privacy: Adhere to data security standards, encrypt sensitive data, secure data transmission"

Instance: UG-NFR-03
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-03 Performance and scalability"
Description: "Non-functional requirement UG-NFR-03 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-03"
* requirement = "Performance and scalability: Scalable to accommodate future increases in usage"

Instance: UG-NFR-04
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-04 Usability and user experience"
Description: "Non-functional requirement UG-NFR-04 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-04"
* requirement = "Usability and user experience: Easy to use for various users"

Instance: UG-NFR-05
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-05 Compliance and regulation"
Description: "Non-functional requirement UG-NFR-05 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-05"
* requirement = "Compliance and regulation: Adhere to relevant regulations and standards"

Instance: UG-NFR-06
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-06 Training and support"
Description: "Non-functional requirement UG-NFR-06 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-06"
* requirement = "Training and support: Training resources and support to users for effective adoption and usage"

Instance: UG-NFR-07
InstanceOf: NonFunctionalRequirement
Title: "UG-NFR-07 Reliability and availability"
Description: "Non-functional requirement UG-NFR-07 for an electronic immunization registry, as stated on slide 18 of UNEPI, \"User requirements for SMART Guidelines\" (library/unepi-user-requirements-smart-guidelines)."
Usage: #definition
* id = "UG-NFR-07"
* requirement = "Reliability and availability: Access when needed"
