---
title: bet schema
status: active
last_updated: 2026-04-30
---

# Bet schema

A bet is a falsifiable prediction about an outcome, a cohort, and a time window. It is the unit of strategic intent in substrate.

A bet is not a campaign plan. Not a deliverable request. Not a wish. If the operator cannot name the predicted outcome, the cohort it will land with, and the date it resolves, it is not a bet.

---

## Required fields (bet cannot move to `open` without these)

The four lint-enforced fields named in the Q2 narrative — `owner`, `revenue_lever`, `target_metric`, `data_chain` — are surfaced from the schema below. The linter checks each is present and well-formed before any goal moves to `open`.

```yaml
bet_id: <client-slug>-<descriptor>-<YYYY-MM-DD>
# Example: acme-homepage-differentiation-2026-05-01

client: <client-slug>
# The client this bet belongs to. Never omitted.

opened_at: YYYY-MM-DD
opener: <operator-name>

# `owner` — the human taste-call owner; same field surfaced as taste_owner below
# for code identifier compatibility. The narrative-facing name is `owner`.
taste_owner: <operator-name>
# The person whose calibration is most relevant to this bet.

hypothesis: |
  One paragraph. The specific claim being tested. Grounded in substrate.
  Must name: the mechanism (why this should work), the evidence (what
  substrate supports it), and the counterfactual (what happens if it doesn't).

# `target_metric` — the specific number and the date it must move; encoded as
# predicted_outcome (count/rate metric) plus revenue_lever (dollar projection)
predicted_outcome: |
  A measurable claim in this form: [metric] [direction] [threshold]
  within [window] for [cohort].
  Example: "Homepage trial signup CR increases ≥15% within 21 days
  for visitors entering from organic search."

revenue_lever: |
  REQUIRED. How this goal ladders to revenue, with the calculation explicit.
  Three sub-fields, all populated at goal-open:

    lever_type: <CW-pipeline | retention-MRR | expansion-ARR | acquisition-CPL |
                 conversion-rate-uplift | cycle-time-shorten | deflection-cost-save>
    annual_revenue_impact_usd: <integer | range "X-Y" | null with reason>
    calculation: |
      The math. Inputs (each cited to a source-system path or substrate file),
      assumptions (each named with rationale), and the output dollar number.
      If null: name the data gap that prevents calculating it.

  The `revenue_lever` field is the gate. If the goal cannot name how it moves
  revenue, it is not a marketing goal — it is a craft project. Not all craft
  projects need to be goals.

# `data_chain` — file path, row count, ingestion date, analyst signature for
# every load-bearing claim; encoded as measurement_design plus the citations
# referenced in hypothesis + revenue_lever.calculation
measurement_design: |
  How you will know if the goal resolves YES or NO.
  Must name: (1) the data source, (2) the exact measurement method,
  (3) the join key if comparing two datasets, (4) how to handle ambiguous cases.
  This field is the gate. If it is vague, the goal does not open.

resolution_date: YYYY-MM-DD
# Hard date. The goal resolves on this date, not "when we have enough data."

taste_type: <type>
# One of: positioning, competitive, demand-gen, aeo-seo, sales-enablement,
# creative-production, viral-content, substrate-architect, conversion,
# product-launch, ops-enablement, content
```

## Optional fields

```yaml
predicted_distribution_squiggle: |
  A probability distribution expressed as a mixture, normal, or beta.
  Example: mixture(normal(70, 15), normal(20, 8), [0.6, 0.4])
  Squiggle notation preferred. Used for Brier scoring.

predicted_p_threshold_met: <float>
# P(outcome meets threshold). Used for expected-Brier calculation.

model_assumption: |
  What model-level assumption this bet depends on.
  Example: "Claude Sonnet 4.6 structured-data generation at scale."
  Used to flag bets that need revisiting when model changes.

preflight_required: <gate-name>
# Special gate requirements beyond standard preflight.
# Example: "refusal-pattern" for bets involving persona-voice copy.

synthetic_audience_persona_id: <persona-ids>
# Which personas from the client's ICP layer to score against in preflight.

companion_bets: [<bet-ids>]
# Bets that are designed to be run together (paired ships).

substrate_layers_cited: [<layer-names>]
# Which substrate layers this bet reads from. Used for staleness checks.
```

## Status lifecycle

```yaml
status: proposed | open | active | resolved | abandoned
```

- `proposed` — bet written but not yet reviewed by operator
- `open` — operator approved; all required fields present; measurement_design validated
- `active` — assets generated; bet is running; resolution date not yet reached
- `resolved` — resolution date reached; outcome measured; Brier score assigned
- `abandoned` — bet deprecated before resolution (market changed, wrong premise, duplicate)

**Transition rules:**

- `proposed` → `open`: requires all required fields present AND measurement_design non-empty AND resolution_date set. Enforced by bet-reviewer agent.
- `open` → `active`: requires at least one asset generated and shipped.
- `active` → `resolved`: requires operator to file the resolution verdict and the actual outcome measurement.
- Any state → `abandoned`: operator marks with `abandonment_reason`.

---

## Resolution verdict (required at resolve)

```yaml
resolution_verdict: YES | NO | AMBIGUOUS
resolution_actual_outcome: |
  What actually happened. Specific. Cite the data source.
  
resolution_measurement_source: <path or URL>
# Where the measurement data lives.

brier_score: <float 0.0 to 1.0>
# Calculated from predicted_p_threshold_met vs resolution_verdict.
# Formula: (predicted_p - indicator)^2
# Where indicator = 1 if YES, 0 if NO.

substrate_update_proposed: YES | NO | DEFERRED
# Did this resolution produce a substrate patch proposal?

substrate_patch_path: <path>
# If YES: where is the proposed patch?
```

---

## The substrate_update field

When a bet resolves, the operator (with help from bet-reviewer) must answer: what did this outcome tell us that the substrate does not yet know?

If the bet resolved YES: the mechanism worked. Does any substrate layer need to reflect this as confirmed evidence?
If the bet resolved NO: the mechanism failed. Does any substrate layer need to update to reflect that this approach did not work in this context?
If AMBIGUOUS: what would need to be true to get a clean signal?

This is not optional. It is Stage 7 of the loop. A bet that resolves without a substrate_update decision has not closed the loop.

---

## What a complete bet looks like

```yaml
---
bet_id: acme-homepage-wedge-2026-05-15
client: acme
opened_at: 2026-05-01
opener: kesava
status: active

hypothesis: |
  Acme's homepage does not surface competitive differentiation in the
  hero section. Buyers in the comparing state (actively evaluating
  alternatives) cannot find why Acme beats HubSpot. The VoC layer
  shows three cross-source complaints about "hard to understand what
  makes Acme different." Adding a second-fold "Switching from HubSpot?"
  section with one-line differentiators will increase comparing-state
  click-through to the /vs/hubspot page and downstream trial conversions.

predicted_outcome: |
  Comparing-state visitor CTR to /vs/hubspot increases ≥40%
  within 21 days of the second-fold section going live.

measurement_design: |
  Data source: Amplitude events on homepage → /vs/hubspot click path.
  Method: compare 21-day CTR pre-launch vs 21-day CTR post-launch.
  Cohort: visitors who arrived at homepage via organic search (channel=organic
  in Amplitude session properties) AND did NOT already have a paid account.
  Join key: session_id for path analysis.
  Ambiguous case: if organic traffic volume drops >20% due to external cause
  (algorithm update, competitor campaign), mark as AMBIGUOUS and extend window.

resolution_date: 2026-06-05
taste_type: positioning
taste_owner: kesava

predicted_p_threshold_met: 0.65
substrate_layers_cited: [positioning, competitive, voc, icp]
synthetic_audience_persona_id: buyer-state-comparing
---
```

---

## What a stub bet looks like (not ready to open)

```yaml
---
bet_id: acme-email-nurture-2026-05-15
client: acme
opened_at: 2026-05-01
opener: kesava
status: proposed

hypothesis: |
  Email nurture for trial users who go dark after day 3 can be improved.

predicted_outcome: |
  Better activation rates somehow.

measurement_design: |
  Check email metrics.

resolution_date: 2026-07-01
taste_type: demand-gen
---
```

This bet would fail the linter. `hypothesis` names no mechanism. `predicted_outcome` has no metric, direction, or threshold. `measurement_design` names no data source, method, or cohort. The bet stays `proposed` until the operator fixes all three.

---

## What the linter checks

The bet-reviewer agent runs a linter on every proposed-to-open transition:

1. `measurement_design` is present and contains at least: a data source name, a method description, a cohort definition.
2. `predicted_outcome` follows the pattern: `[metric] [direction] [threshold] within [window] for [cohort]`.
3. `revenue_lever` is present with `lever_type` set, `annual_revenue_impact_usd` either populated or explicitly null-with-reason, and `calculation` showing the math + cited inputs.
4. `resolution_date` is in the future at open time.
5. `taste_type` is one of the valid values.
6. `substrate_layers_cited` lists at least one layer; each named layer exists in the client's substrate directory.

If any check fails, the goal stays `proposed`. The linter outputs the specific failures.
