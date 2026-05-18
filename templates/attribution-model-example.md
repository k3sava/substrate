---
title: attribution model, Acme (example), 2026-05-08
status: example
last_updated: 2026-05-08
client: acme
recommended_model: hybrid
decision_context: budget-allocation
validity_window: 2026-02-08 to 2026-05-08
patterns_grounded: [incrementality-not-attribution, goalpost-discipline-vs-metric-drift]
contradictions_aware: [no-decision-vs-named-competitor]
contradiction_positions: 'Both positions, condition per cohort'
position_rationale: |
  Channel mix is balanced (4 demand-creation channels vs 4 intent-capture channels).
  Run the multi-touch model + quarterly incrementality tests on top-3 channels by spend;
  the test resolves which position applies to which channel.
produced_by: attribution-model-design
template: true
---

# Attribution model spec, Acme (example), 2026-05-08

> Example output for `skills/attribution-model-design`. Acme is an anonymous mid-market SaaS in the workflow-automation category running a 10-channel mix (4 demand-creation surfaces, 4 intent-capture surfaces, 2 hybrid). Use this as the shape your client's spec will take. Replace every channel, source-system, and decision-rights line with the client's actual ones.

Most teams default to last-touch because that is the platform UI default. Last-touch systematically biases budget-allocation toward the channel that closed and away from the channel that created the lead. This spec names the model the team should run, the model's blind spots, the data the model needs, and the corroborating test that triangulates against correlation bias.

Per the `incrementality-not-attribution` pattern, every correlation-based model is a hypothesis, not a measurement. The triangulation column on each model names the test that turns the hypothesis into a measurement.

## Recommended model

**Model:** `hybrid`
**Decision context:** `budget-allocation`
**Fit rating:** very good (correlation for routine, causation for big bets)

**Math:**

> Use a multi-touch model (position-based or time-decay) for routine reporting + cohort attribution. Calibrate the model's channel ranking with quarterly incrementality tests on the top-3 channels by spend. When the model rank and the incrementality rank disagree by more than 1 position, the test result wins and the model's weights get tuned.

**Data requirement:** all of position-based or time-decay's data + quarterly incrementality test infrastructure (geo holdouts, audience holdouts, or PSA controls per surface).

**Stated blind spots:**

- still inherits position-based or time-decay's blind spots between tests
- calibration cadence (quarterly) means a fresh creative-fatigue shift takes 3 months to surface
- incrementality tests only run on top channels; long-tail channels stay correlation-attributed
- the model treats every closed-won as equally valuable; ARR-weighted attribution requires a parallel pipeline

**Triangulation move:** the incrementality test IS the triangulation. Keep cadence honest per `routines/lift-test-rhythm.md`.

## Contradiction navigation, no-decision vs named-competitor

[contradiction:no-decision-vs-named-competitor] picked Both positions, condition per cohort because:

Channel mix is balanced (4 demand-creation surfaces: organic-search, content, organic-social, referral; 4 intent-capture surfaces: paid-search, paid-social, linkedin-ads, direct). Position A (Dunford status-quo) applies to demand-creation cohorts; the buyer journey there usually starts before any named competitor enters the picture. Position B (Gartner named-competitor) applies to intent-capture cohorts; the buyer is comparing against named competitors at conversion time, and last-touch is closer to the truth for those.

Run the multi-touch model and pair it with quarterly incrementality tests on top-3 channels by spend; the test resolves which position applies to which channel quantitatively.

## All models compared

| Model | Fit for context | Math (1-line) | Triangulation |
|---|---|---|---|
| `hybrid` | very good (correlation for routine, causation for big bets) | multi-touch + quarterly incrementality calibration | the incrementality test IS the triangulation |
| `last-touch` | poor (default for platform UI but biased toward bottom-funnel) | credit = 1 if last_touch == C else 0 | incrementality test on the model's highest-credit channel |
| `first-touch` | poor in isolation (use as a check on last-touch, not primary) | credit = 1 if first_touch == C else 0 | survey 50 closed-won 'how did you first hear about us'; gap = the lie |
| `linear` | fair (better than single-touch, worse than time-decay) | credit = touches_from_C / total_touches | compare with time-decay; difference exposes which channels are middle-of-path |
| `time-decay` | good (recency-weight matches short-cycle reality) | credit ∝ exp(-(time_since_t / half_life)) | vary half-life across {3, 7, 14, 30}; rank stability indicates calibration |
| `position-based` | good (acknowledges both demand-creation and conversion-driving) | 40% first + 40% last + 20% linear-mid | compare against linear and Markov; large mid-channel deltas are signal |
| `markov-chain` | very good when data quality and path completeness are high | Markov-removal-effect across touch sequences | compare Markov removal-effect ranking against incrementality test ranking |
| `incrementality-anchored` | best (causation, not correlation) | quarterly incrementality tests per channel | rotate test types (geo, audience, PSA) to triangulate |

## Channel inventory (read from sources.yaml)

| Channel | Platform | Source-systems | Notes |
|---|---|---|---|
| paid-search | google-ads | ga4, hubspot | Google Ads campaigns. UTM-tagged. Referenced in HubSpot first-touch source. |
| paid-social | meta-ads | ga4, hubspot | Meta paid campaigns. UTM-tagged. Pixel-tracked. |
| linkedin-ads | linkedin | linkedin-ads-api, hubspot | B2B paid campaigns. Conversion lift studies run quarterly. |
| direct | typed-url | ga4 | Direct visits. Mostly returning users + brand-search. |
| organic-search | google-organic | ga4 | Organic-search referrals. AEO + SEO surface. |
| organic-social | linkedin-twitter-organic | ga4 | Organic posts on linkedin / twitter. Tracked via UTM tags + referrer. |
| content | organic-blog-and-newsletter | ga4, hubspot | Blog + newsletter referrals. Content-marketing surface. |
| referral | word-of-mouth | ga4, hubspot | Referral landings. Hard to attribute precisely; credit by self-report at signup. |
| email | hubspot-marketing-email | hubspot, segment | Lifecycle + nurture email. |
| outbound | outreach-or-equivalent | hubspot | SDR outbound sequences. Touchpoint logged in HubSpot. |

## Source-system inventory (read from sources.yaml)

| Source | Role | Refresh cadence | API key env |
|---|---|---|---|
| amplitude | primary-product-analytics | daily | `AMPLITUDE_API_KEY` |
| posthog | secondary-event-store | daily | `POSTHOG_API_KEY` |
| hubspot | crm-and-marketing-events | hourly | `HUBSPOT_API_KEY` |
| stripe | revenue-and-subscription | hourly | `STRIPE_API_KEY` |
| segment | cdp-fan-out | daily | `SEGMENT_API_KEY` |
| ga4 | marketing-site-attribution | daily | `GA4_API_KEY` |

## Validity window

The model is computed against the trailing window 2026-02-08 to 2026-05-08. Recompute cadence: monthly. Per `goalpost-discipline-vs-metric-drift`, the definition is locked at this open; mid-quarter changes count as overrides with attribution.

The validity window matches the standard SaaS sales cycle (60-90 days for mid-market). For longer-cycle B2B (180+ days), extend the window to 6 months and document the extension in the spec.

## Triangulation plan

Per the `incrementality-not-attribution` pattern, the model is a hypothesis. The plan:

1. **Quarterly incrementality test on top-3 channels by spend.** Geo holdout for paid-search and paid-social; PSA control for platform-managed campaigns; audience holdout for lifecycle email. See `skills/lift-test-design` and `routines/lift-test-rhythm.md`.

2. **Closed-won win-source survey, every quarter.** Survey every closed-won deal: "how did you first hear about us." Compare with first-touch model attribution for the same accounts. Gap is the lie the model tells.

3. **Brand-search lift watch, monthly.** Monitor branded-search query volume monthly. Surges that lead conversions by 30 days are demand-creation-channel signal the multi-touch model often under-weights.

4. **Sales-team pipeline survey, every quarter.** AEs name the deal-source channel for every closed deal. Compare with last-touch and first-touch model attribution.

Recent incrementality result: `clients/acme/analytics/incrementality/paid-search-2026-Q1-result.md`. Use as anchor for next-quarter calibration.

## Decision rights

This model is allowed to drive:

- Quarterly budget allocation across channels (with caveats per blind-spot list).
- Within-channel campaign weight shifts (where the multi-touch attribution + within-quarter trends both agree).

This model is NOT allowed to drive:

- Single-quarter individual-rep credit (rep-level incentive math is a different problem; use opportunity-source-tagged pipeline rules).
- Cross-channel cannibalization analysis (that needs a structural causal model, not attribution).
- Pricing / packaging decisions (that needs WTP research, not attribution).
- Vertical-specific budget shifts (that needs vertical-conditioned attribution; this model aggregates across verticals).

## Override log

| Date | Override | Attributor | Reason | Resolution |
|---|---|---|---|---|
| 2026-04-15 | Reduced LinkedIn-ads time-decay half-life from 14 to 7 days | growth lead | LinkedIn campaign refresh shifted creative; incrementality Q1 result confirmed shorter-decay channel behavior | Locked for Q2; re-evaluate at quarter close. |

(Per `goalpost-discipline-vs-metric-drift`, every override is logged with attribution. Repeated overrides on the same channel mean the model is mis-specified; switch model.)

## Substrate citations

- Channel inventory: `clients/acme/analytics/sources.yaml`
- Source-systems: `clients/acme/analytics/sources.yaml` (sources block)
- ICP: `clients/acme/icp/icp.md`
- Positioning: `clients/acme/positioning/positioning.md`
- Recent incrementality result: `clients/acme/analytics/incrementality/paid-search-2026-Q1-result.md`
- Pattern: `knowledge/patterns/incrementality-not-attribution.md`
- Pattern: `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`
- Contradiction: `knowledge/contradictions/no-decision-vs-named-competitor.md`

## Next reads

- `skills/lift-test-design --client acme --surface paid-ads --mode geo-holdout` for top-channel validation.
- `skills/dashboard-spec --client acme --audience growth --decision attribution-debate` to expose the model in a dashboard.
- `routines/lift-test-rhythm.md` to schedule the next quarter's tests.
- `routines/analytics-monthly-refresh.md` for the pull cadence that keeps this spec's data fresh.
