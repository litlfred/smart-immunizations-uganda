The Uganda schedule is encoded in two CQL libraries:

* [UGIMMZElements](Library-UGIMMZElements.html): the doses administered to the
  client, grouped the way the Uganda schedule counts them, built on the WHO
  `IMMZEncounterElements` data elements and `IMMZConcepts` value sets;
* [UGIMMZScheduleLogic](Library-UGIMMZScheduleLogic.html): for each vaccine,
  the next dose, its due date, its expiration and its status.

The PlanDefinition [UGIMMZSchedule](PlanDefinition-UGIMMZSchedule.html) has one
action per vaccine. An action applies (`<vaccine> recommended`) when the next
dose exists and has not expired; it produces a CommunicationRequest (WHO
ActivityDefinition `IMMZD2DTCR`) whose text gives the dose, due date and
expiration.

### Outputs of UGIMMZScheduleLogic

| Expression | Meaning |
|---|---|
| `Recommendations` | One entry per vaccine with a dose still to give, in schedule order |
| `Doses due` | Entries whose due date is today or earlier |
| `Upcoming doses` | Entries whose due date is in the future |
| `<vaccine> recommendation` | The entry for one vaccine (null when the series is complete or not applicable) |
| `<vaccine> recommended` | The entry exists and has not expired |
| `<vaccine> message` | Text for the health worker |
{:.grid}

Each entry is a tuple

    { vaccine, doseNumber, seriesLength, dueDate, expiration, status, guidance }

with `status` one of `due`, `upcoming` or `expired`.

### Due date rule

Let *b* be the date of birth, *a<sub>n</sub>* the scheduled age of dose *n*,
*d<sub>n−1</sub>* the date of the previous dose of the same vaccine and
*i<sub>n</sub>* the minimum interval before dose *n*. Then

  due(1) = *b* + *a<sub>1</sub>*,
  due(*n*) = max( *b* + *a<sub>n</sub>*, *d<sub>n−1</sub>* + *i<sub>n</sub>* ) for *n* > 1.

| Vaccine | *a<sub>n</sub>* | *i<sub>n</sub>* | Expiration |
|---|---|---|---|
| BCG | birth | – | none |
| Hepatitis B birth dose | birth | – | *b* + 7 days |
| OPV0 | birth | – | *b* + 1 week |
| OPV1–3, DTP-HepB-Hib 1–3, PCV1–3 | 6, 10, 14 weeks | 4 weeks | none |
| Rotavirus 1–3 | 6, 10, 14 weeks | 4 weeks | *b* + 2 years − 1 day |
| IPV1–2 | 6, 14 weeks | 4 weeks | none |
| Malaria 1–4 | 6, 7, 8, 18 months | 4 weeks | none |
| MR1–2 | 9, 18 months | 4 weeks | none |
| Yellow fever | 9 months | – | none |
| HPV (girls) | 10 years | – | *b* + 21 years − 1 day |
| Td1–5 (women 15–49) | Td1: 15 years (first contact); then fixed intervals | Td2 1 month, Td3 6 months, Td4 12 months, Td5 12 months after the previous Td | none |
{:.grid}

The childhood schedule (all vaccines except HPV and Td) is offered while the
client is younger than the parameter `Childhood schedule upper age in years`
(default 5, pending UNEPI confirmation).

### Not yet encoded

Contraindications and precautions (the WHO `IMMZD5DT*` decision tables apply
unchanged), live-vaccine spacing, vitamin A and deworming, invalid (too early)
doses, and outbreak or campaign doses. See [open questions](open-questions.html).
