---
id: pat_behavioral-expansion-signals-beat-tenure
title: Behavioral signals beat tenure for expansion timing
captured_date: 2026-05-08
convergence_count: 3
tier: A
domains: [customer-success, sales, pricing, growth]
---

# Behavioral signals beat tenure for expansion timing

## Convergence

Three operators with quota responsibility for expansion revenue converge on the same claim: account tenure is the wrong primitive for upsell timing. The "wait 90 days, then offer the upgrade" cadence works on the median but loses the long tail in both directions. It misses accounts ready to expand at day 21, and wastes a touch on accounts that will never be ready at day 90.

The right primitive is behavioral signal: feature adoption rate, value-event density per active week, seat or workspace growth, and crossing of usage thresholds tied to the next pricing tier. Tenure correlates loosely with these; behavior correlates tightly. Operators who switched their CS / AE expansion motion from tenure-based to behavior-based report higher expansion ARR per touch, fewer wasted offers, and shorter cycle time on the offers that close.

## Operators

- **Bridget Gleason**, Ex-Sumo Logic, Tipalti, multiple SaaS scale-up CRO roles. Quota-carrying CS-led expansion lives or dies on signal quality. Tenure-based expansion playbooks miss the high-intent buyer who is ready at week three, and burn cycles on accounts that hit day 90 having never adopted the feature that justifies the upsell. The behavioral primitive (usage thresholds, multi-team adoption, integration density) is the readable signal of buying intent.
- **Tomasz Tunguz**, Theory Ventures. Net-dollar-retention math and account-expansion analysis published over a decade. Tenure-correlated expansion shows up in vanity reports; the underlying driver is always behavioral (the customer outgrew the plan). Tunguz's posts on expansion mechanics treat tenure as a proxy and behavior as the actual variable.
- **Patrick Campbell**, ProfitWell / Paddle, monetization research at scale. The pricing data show that expansion willingness-to-pay tracks usage curve, not calendar. Customers who triple their seat count in 60 days have a different price elasticity than customers who hold flat at three seats for 18 months, and tenure is the same. Treating tenure as the gate produces wrong-fit offers in both directions.

## Variation

- Gleason frames it through the *CS / AE motion*: which accounts to touch this week, on what trigger.
- Tunguz frames it through *expansion mechanics math*: behavior is the cause, tenure is the visible-but-non-causal correlate.
- Campbell frames it through *willingness-to-pay*: usage curve predicts price acceptance, calendar does not.
- Convergence: trigger expansion plays off behavior, not the calendar.

## Implication

Expansion-trigger detection reads behavioral signals (feature-adoption ratios, value-event density, seat or workspace growth, integration count, threshold-crossing for pricing tiers), maps them to expansion stages, and emits triggers for CS team or in-product nudges. Tenure is allowed as a *secondary* axis (e.g., "ignore behavioral triggers in week one"), but never as the primary gate.

The artifact: a per-account expansion signal score, broken into adoption-breadth, value-event-density, growth-rate, and threshold-proximity, with a published mapping from score-band to recommended action (in-product nudge, CSM check-in, AE expansion conversation, no action). Triggers fire when behavior crosses a threshold, not when the calendar does.

A second-order benefit: behavioral triggers also identify *non*-expansion. An account at day 90 with low adoption breadth and zero growth rate is a churn risk, not an upsell. Tenure-based playbooks treat both as expansion candidates and lose on both.

## Sources

- Bridget Gleason, multiple talks and posts on CS-led expansion (Sumo Logic, Tipalti); Pavilion / RevOps Co-op contributions.
- Tomasz Tunguz, "Why expansion matters more than acquisition for growth-stage SaaS," tomtunguz.com (multiple posts on NDR mechanics and expansion drivers).
- Patrick Campbell, ProfitWell / Paddle research on usage-based pricing and willingness-to-pay (priceintelligently.com / Recur Now).
