Comparison of the Uganda routine schedule with the generic WHO scheduling
logic in the [WHO Immunization implementation guide](https://smart.who.int/immunizations)
(libraries `IMMZD18S*Logic`). "Same" means the Uganda rule falls within the
WHO recommendation; the remaining rows are the adaptations this guide makes.

| Vaccine | WHO (generic) | Uganda | Adaptation |
|---|---|---|---|
| BCG | 1 dose at birth | 1 dose at birth | Same |
| Hepatitis B birth dose | At birth; overdue after 24 hours; upper limit left to Member States | At birth, ideally within 24 hours, not after 7 days | Upper limit set to 7 days |
| OPV0 (bOPV birth dose) | At birth; IG expiration 1 week | At birth | WHO 1-week expiration kept ([open question](open-questions.html)) |
| OPV1–3 | 3 bOPV doses from 6 weeks, at least 4 weeks apart | 6, 10, 14 weeks, at least 4 weeks apart | Same, with fixed scheduled ages |
| IPV | IPV1 from 14 weeks, IPV2 at least 4 months later | IPV1 at 6 weeks, IPV2 at 14 weeks, at least 4 weeks apart | Earlier IPV1 and shorter interval |
| DTP-HepB-Hib | 3 primary doses from 6 weeks, at least 4 weeks apart; 3 diphtheria–tetanus boosters (12–23 months, 4–7 years, 9–15 years) and a pertussis booster (1–6 years) | 3 primary doses at 6, 10, 14 weeks; no childhood boosters | Boosters not in the Uganda schedule |
| PCV | 3p+0 or 2p+1 | 3p+0 at 6, 10, 14 weeks | 3p+0 chosen |
| Rotavirus | From 6 weeks, at least 4 weeks apart, number of doses by product; IG expiration 24 months | 3 doses at 6, 10, 14 weeks; not after 2 years | 3-dose product schedule |
| Measles-rubella | MCV1 at 9 months (12 months in low transmission settings); MCV2 from 15 months | MR1 at 9 months, MR2 at 18 months | MR2 at 18 months |
| Yellow fever | 1 dose from 9 months in endemic areas | 1 dose at 9 months, nationwide | Same |
| Malaria | 4 doses, first from 5 months, at least 4 weeks apart; dose 4 about 12–18 months after dose 3 | 6, 7, 8 and 18 months | First dose at 6 months; dose 4 at 18 months of age (about 10 months after dose 3 when on time) |
| HPV | Single dose from 9 years (9–14 primary target; up to 20 years) | 1 dose for girls at 9 years | Scheduled age 9 years (SAMPLE change); WHO upper age kept ([open question](open-questions.html)) |
| Td, women of child-bearing age | Tetanus-diphtheria in pregnancy (IG libraries `IMMZD18SDTPPregnancy*`) and childhood/adolescent boosters | 5 doses for women aged 15–49: first contact, +1 month, +6 months, +12 months, +12 months | Uganda 5-dose schedule for all women of child-bearing age |
{:.grid}

### Data model notes

* The Uganda logic reuses the WHO data elements (`IMMZEncounterElements`) and
  vaccine value sets (`IMMZConcepts`); no new value sets are introduced.
* The WHO value set *DTP-containing vaccines* (IMMZ.Z.DE24) also lists Td
  (ATC J07AM51). The Uganda logic therefore counts a pentavalent dose only when
  the vaccine is also in *Pertussis-containing vaccines* (IMMZ.Z.DE12), and
  counts a Td dose only when it is *not* pertussis-containing. This may be
  worth raising with the WHO guide.
* Birth doses (hepatitis B, OPV0) are recognised either by the WHO "Dose 0"
  series marker or by being given before 6 weeks of age, the minimum age of the
  infant primary series.
