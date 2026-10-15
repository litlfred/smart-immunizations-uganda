This implementation guide is a **draft adaptation** of the
[WHO SMART Guidelines Immunization implementation guide](https://smart.who.int/immunizations)
to the Uganda routine immunisation schedule of the Uganda National Expanded
Programme on Immunisation (UNEPI). It is prepared for review with UNEPI and is
not an official publication of the Uganda Ministry of Health.

### What this guide adds to the WHO guide

The WHO guide gives generic, Member-State-adaptable content: data elements,
decision logic and scheduling logic for every WHO-recommended vaccine. This
guide keeps all of that and adds the Uganda-specific layer:

* the [Uganda routine immunisation schedule](schedule.html) and
  [catch-up rules](catch-up.html), as published by the Ministry of Health and
  presented by UNEPI;
* [routes and sites of administration](administration.html) used in Uganda;
* a line-by-line [comparison with the WHO recommendations](differences.html);
* computable [scheduling logic](decision-logic.html): the WHO DAK's scheduling
  tables, adapted cell by cell in a copy of the WHO DAK workbook and converted
  with WHO's own toolchain, with two WHO parameters configured for Uganda, and
  [test patients](testing.html) in the WHO test format;
* the [UNEPI user requirements](requirements.html) for an electronic
  immunization registry and the [service delivery and data flow](service-delivery.html)
  context;
* [open questions](open-questions.html) where the Uganda sources are silent or
  ambiguous and a decision by UNEPI is needed.

### Sources

1. Uganda Ministry of Health, *Uganda Routine Immunisation Schedule* (poster),
   attached to [issue #1](https://github.com/litlfred/smart-immunizations-uganda/issues/1).
2. UNEPI, *User requirements – SMART Guidelines* (presentation), attached to
   [issue #1](https://github.com/litlfred/smart-immunizations-uganda/issues/1):
   current immunisation schedule, catch-up schedule, sites of child vaccines,
   service points, client flow, data flow, current challenges and user
   requirements for an electronic immunization registry (EIR).
3. WHO, [Immunization implementation guide](https://smart.who.int/immunizations)
   (`smart.who.int.immunizations`), and WHO recommendations for routine
   immunization – summary tables.

### Status

Draft. Everything marked as an open question needs confirmation by UNEPI
before the logic is used for clinical decision support.
