---
asset_type: outbound-sequence-manifest
client: <your-product>
persona: vp-revenue-ops-mid-market
tier: 1A
category_maturity: mature
trigger: funding
date: 2026-05-08
touches: 12
char_limit_failures: 0
voice_enforce_failures: 0
---

# Outbound sequence — VP RevOps mid-market — tier 1A

**Client:** <your-product>
**Persona:** VP Revenue Operations, mid-market (200-2000 employees)
**Tier:** 1A — Holland/Nelson position; hand-personalize every touch, multithread 3-5 buyers from day 1
**Category maturity:** mature — Reed/Klettke/Gerhardt position; outbound supplements inbound
**Trigger:** funding round (Series B announced 14 days ago)

## Setup → Follow-Through architecture

Per `pat_status-quo-is-the-real-objection-outbound`, touches 1-4 run Setup phase — alternative-anchored opener, cost-of-inaction, world-shift framing. Pitch ("want a demo") only enters at touches 5+.

## Cadence

| # | Channel | Gate | Path | Char-limit | Voice |
|---|---|---|---|---|---|
| 01 | email_intro | setup-alternative | `01-email-intro-setup-alternative.md` | pass | pass |
| 02 | linkedin_connect | setup-context | `02-linkedin-connect-setup-context.md` | pass | pass |
| 03 | voicemail | setup-cost | `03-voicemail-setup-cost.md` | pass | pass |
| 04 | email_proof | proof-voc | `04-email-proof-proof-voc.md` | pass | pass |
| 05 | email_proof | proof-differentiator | `05-email-proof-proof-differentiator.md` | pass | pass |
| 06 | linkedin_message | follow-through-reframe | `06-linkedin-message-follow-through-reframe.md` | pass | pass |
| 07 | video | follow-through-personal | `07-video-follow-through-personal.md` | pass | pass |
| 08 | email_objection | follow-through-objection | `08-email-objection-follow-through-objection.md` | pass | pass |
| 09 | voicemail | follow-through-ask | `09-voicemail-follow-through-ask.md` | pass | pass |
| 10 | email_curiosity | reopen-curiosity | `10-email-curiosity-reopen-curiosity.md` | pass | pass |
| 11 | linkedin_message | reopen-share | `11-linkedin-message-reopen-share.md` | pass | pass |
| 12 | email_breakup | breakup-final | `12-email-breakup-breakup-final.md` | pass | pass |

## Contradiction-resolution log

- `con_personalization-vs-scale`: Holland/Nelson position — hand-personalize every touch, event-anchored
- `con_outbound-vs-inbound-budget`: Reed/Klettke/Gerhardt — outbound supplements inbound; tighter cadence
- `con_no-decision-vs-named-competitor`: Setup phase frames status-quo as the dominant alternative; named competitor framing held for breakup-final + objection touches

## Substrate cited

- `clients/<your-product>/positioning/positioning-canonical-statement.md` (positioning canonical statement)
- `clients/<your-product>/personas/vp-revenue-ops-mid-market.md` (persona)
- `clients/<your-product>/competitive/status-quo.md` (status-quo frame)
- `clients/<your-product>/voc/processed/displacement-quotes.md` (VoC quote)

## Patterns grounded

- `knowledge/patterns/status-quo-is-the-real-objection-outbound.md`
- `knowledge/patterns/rhythm-beats-blast.md`
- `knowledge/patterns/trigger-events-beat-cadence-blast.md`
- `knowledge/patterns/copywriting-craft-fundamentals.md`

## Hand-off to SDR / AE

1. Review each touch for company-specific tokens ({company}, {first_name}, {rep_name}, {rep_phone}).
2. Verify load-bearing trigger detail (date, source URL) before send.
3. Load into Outreach / Salesloft / Apollo / Smartlead with this cadence map.
4. Tier 1A: AE owns the multi-thread strategy. Tier 1B: SDR-AE pair. Tier 2: SDR pool.

## Refuses to ship if

- Any touch fails voice-enforce (0 did)
- Any touch breaches character limits without operator override (0 did)
- Setup phase is missing (touch 1 is a pitch)
