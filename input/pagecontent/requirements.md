Requirements from the UNEPI presentation *User requirements – SMART
Guidelines*. They are recorded here as stated, so they can later be mapped to
the WHO guide's functional and non-functional requirements.

### Programme

* **Vision:** a Ugandan population free of vaccine-preventable diseases.
* **Mission:** to ensure that every child and high-risk group is fully
  vaccinated with high-quality and effective vaccines against the target
  diseases according to recommended strategies.
* **Goal:** to contribute to the overall objective of the Health Sector
  Development Plan in reducing morbidity, mortality and disability due to
  vaccine-preventable diseases, so that they are no longer of public health
  importance.
* **Objectives:** increase access and demand for immunization services; ensure
  availability of potent and effective vaccines; build EPI management capacity
  at all levels; monitor disease trends and programme performance; formulate
  policy, standards and guidelines.

### Current challenges (paper-based system)

High printing costs; delays in service delivery (time consuming); less
accurate data; false zero-dose children (ZDC) and immunization under-coverage
(IUC); no flexibility; no real-time processes; vaccine accountability.

### Expected benefits of digitization

Improved data quality; reminders; savings on printing; support for follow-up;
identification of real defaulters; improved data use; improved visibility.

### Functional requirements for an electronic immunization registry (EIR)

| Id | Requirement | Detail |
|---|---|---|
| UG-FR-01 | User authentication and access control | Username/password, biometric authentication |
| UG-FR-02 | Patient record management | Personal information, vaccination history and demographic data |
| UG-FR-03 | Vaccine inventory management | Batch numbers, expiration dates and current stock |
| UG-FR-04 | Vaccination scheduling and reminders | Scheduling of vaccination appointments and reminders to patients or guardians |
| UG-FR-05 | Immunization reporting and analytics | Reports such as immunization coverage rates, vaccine wastage and adverse event tracking |
| UG-FR-06 | Adverse event reporting | Report and document adverse events following immunization (AEFI) |
| UG-FR-07 | Integration with health records | Integrate with existing electronic health record systems for comprehensive patient health information |
{:.grid}

UG-FR-04 is supported directly by the [scheduling logic](decision-logic.html)
of this guide.

### Non-functional requirements

| Id | Requirement | Detail |
|---|---|---|
| UG-NFR-01 | Interoperability | Data exchange |
| UG-NFR-02 | Security and privacy | Adhere to data security standards, encrypt sensitive data, secure data transmission |
| UG-NFR-03 | Performance and scalability | Scalable to accommodate future increases in usage |
| UG-NFR-04 | Usability and user experience | Easy to use for various users |
| UG-NFR-05 | Compliance and regulation | Adhere to relevant regulations and standards |
| UG-NFR-06 | Training and support | Training resources and support to users for effective adoption and usage |
| UG-NFR-07 | Reliability and availability | Access when needed |
{:.grid}

### Other system features

Offline mode; parent or guardian portal; multilingual support; vaccine
information and education; data migration and legacy system integration; data
auditing and logging; mobile application; data quality checks; data sharing
permissions; automated reporting to the National Drug Authority (NDA) and the
Uganda Virus Research Institute (UVRI).

### Proposed EIR architecture

Child identification through integration with the birth registration system of
the National Identification and Registration Authority (NIRA / vital
registration system), feeding an EIR with a vaccine record module, scheduling
and reminders, and data analytics and reporting. Users: health care providers,
patients (via app or portal), and district and Ministry of Health staff.
