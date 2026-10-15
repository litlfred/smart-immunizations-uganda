UNEPI's catch-up schedule is summarised as *"It is better to vaccinate late
than never!"*.

| Dose | When to give | When not to give |
|---|---|---|
| Hepatitis B birth dose | As soon as possible after birth, ideally within 24 hours and up to 7 days | Not after 7 days |
| BCG | As soon as possible after birth | – |
| 6-week doses: OPV1, PCV1, DTP1, RV1, IPV1 | At 6 weeks, or as soon as possible thereafter | RV1: not after 2 years of age |
| 10-week doses: OPV2, PCV2, DTP2, RV2 | At 10 weeks, or as soon as possible thereafter, and at least 4 weeks after dose 1 | Not before 4 weeks have passed since the previous dose. RV2: not after 2 years of age |
| 14-week doses: OPV3, PCV3, DTP3, RV3, IPV2 | At 14 weeks, or as soon as possible thereafter, and at least 4 weeks after dose 2 | Not before 4 weeks have passed since the previous dose. RV3: not after 2 years of age |
| 9-month doses: MR1, YF | At 9 months, or as soon as possible thereafter | Not before 9 months of age (except where indicated) |
| MR2 | At 18 months, or as soon as possible thereafter, and at least 4 weeks after the previous dose | Not before 4 weeks have passed since MR1 |
{:.grid}

General rules:

* Even if a long time has passed between doses, there is no need to restart
  the series from the beginning.
* There is no upper age limit for most vaccines, except rotavirus (under 2
  years) and the hepatitis B birth dose (under 7 days).

### How the logic encodes the catch-up rules

For a dose *n* > 1 with scheduled age *a<sub>n</sub>* and minimum interval
*i* = 4 weeks, the due date is

  due(*n*) = max( date of birth + *a<sub>n</sub>*, date of dose *n*−1 + *i* ).

A dose is *due* when its due date is on or before today, *upcoming* when it is
in the future, and *expired* when today is after its expiration (the last date
on which the dose may be given). Expirations:

* hepatitis B birth dose: date of birth + 7 days;
* OPV0: date of birth + 1 week (WHO value; Uganda does not state one, see [open questions](open-questions.html));
* rotavirus: the day before the 2nd birthday;
* HPV: the day before the 21st birthday (WHO single-dose age range; Uganda does not state one).

The UNEPI catch-up chart lists "IPV1" at both 6 and 14 weeks; this guide
reads the 14-week dose as IPV2, consistent with the routine schedule.
