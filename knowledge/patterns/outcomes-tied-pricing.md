---
id: pat_outcomes-tied-pricing
title: Outcomes-tied pricing — the operator charges for the move, not the time
captured_date: 2026-05-18
convergence_count: 3
tier: A
uses_cards: [ins_kesava-portfolio-consulting-offer, ins_alan-weiss-value-based-fees, ins_economic-turing-test-rev-per-employee]
domains: [consulting-pricing, ai-native-services, engagement-shape]
---

# Outcomes-tied pricing

## Convergence

Three sources converge on the operator-side pricing rule: the operator charges for the move that produces the lift, with skin in whether it produced the lift. Time is not the unit. Calendar is not the unit. The outcome is the unit. Convergence holds across the AI-native operator's own published doctrine, the classical value-based-fees consulting literature, and the synthesised "input layer is where value lives" framing from the agent-first GTM corpus.

## Operators

- **Kesava Mandiga**, `canonical/portfolio-consulting-offer.md` (mirrored from `portfolio.iamkesava.com/consulting-offer`). The operator's published doctrine: "I'm not selling you my time. I'm selling you the move that produces the lift, with skin in whether it produced the lift." Three published structures (% of attributable lift / per-unit bonus / Brier-bonus). Floor exists only as outcome-conditioned draw alongside the variable; never as standalone retainer. Hourly billing and pure retainer are listed under "What I won't do." `ins_kesava-portfolio-consulting-offer`.
- **Alan Weiss**, *Million-Dollar Consulting* (2nd ed., McGraw-Hill, 2009; *Value-Based Fees*, 3rd ed., 2017). Long-standing consulting-pricing doctrine: fees are derived from the value the consultant delivers to the client, measured by outcomes (revenue, savings, retention, decision-quality), not the hours expended. The operator who prices by hour is selling a commodity; the operator who prices by outcome is selling judgment. `ins_alan-weiss-value-based-fees`.
- **Economic Turing Test, revenue per employee framing**, `pat_economic-turing-test-rev-per-employee` (Mann, Taylor, Cherny, Sherwin Wu — AI-native operating model). As execution becomes cheap, the price of an output collapses toward zero, and residual value lives in the input layer (which angle to test, which buyer signal to amplify, which narrative to commit to). Outcomes pricing is how the operator charges for the input layer in a world where AI has commoditised the output layer. `ins_economic-turing-test-rev-per-employee`.

## Variation

- Kesava provides the *operationalised version*: three named variable structures, an annual per-client floor, a refusal list, a measurement contract that gates the variable.
- Weiss provides the *historical lineage*: value-based fees as the consulting discipline before AI made outputs cheap. The doctrine predates the AI shift; the AI shift sharpens it.
- The Turing-test framing provides the *why-now*: the structural reason hourly pricing is failing fast in 2026. AI commoditised the output layer; the operator who still prices by hour is pricing a commodity in a market that just stopped paying for commodities.

## Implication

The operator's engagement-pricing skill must:

1. **Refuse hourly billing.** No "let's start at $X/hr." The unit of pricing is the outcome.
2. **Refuse pure retainers.** A retainer without a measurement contract is calendar without scoring. The contract that lets consultants hide.
3. **Default to Phase-based structure.** Phase 0 free diagnostic, Phase 1 paid fixed-fee scoping that produces the measurement contract, Phase 2 outcome contract (floor + variable).
4. **Tie the variable to a verifiable metric.** Source-of-truth system named in the contract; window named; verification path named. Without this, the contract can't resolve.
5. **Enforce a per-client annual floor.** The operator's calibration of "minimum engagement worth taking" — $100K annualised in Kesava's case, derived from operator history, not from market benchmarks.

## What this pattern is NOT

- **Not no-floor.** The operator's floor exists. It's just conditioned on the measurement contract. See `con_floor-as-draw-vs-floor-as-retainer`.
- **Not no-anchor.** Outcomes-based pricing still uses anchor/target/decoy structure (`pat_anchor-high-then-decoy`). The anchor multiplies the floor; the variable multiplies the lift.
- **Not no-hourly-rate-internally.** The operator may track their own hourly cost basis internally (for forecasting, for goals/ledger calibration). The prospect never sees an hourly rate.
- **Not commission-only.** Pure commission removes the floor; outcomes-tied pricing keeps the floor as the operator-time draw. Commission-only engagements are too easy to walk away from on both sides.

## Stops applying when

- The prospect's industry/market structurally cannot measure outcomes (rare; usually a signal to refuse the engagement, not to fall back to hourly).
- The operator doesn't have calibration history to set a confident variable share (first-engagement-of-year exception per the published doctrine: internal rate while Brier history opens).
- The engagement is Phase 1 itself (Phase 1 is fixed-fee, not outcomes-tied; Phase 1's product IS the measurement contract for Phase 2).

## See also

- `canonical/portfolio-consulting-offer.md` — the canonical source
- `pat_productized-consulting-beats-hourly` — the anti-hours discipline at the engagement-shape level
- `pat_brier-priced-engagement` — the calibration discipline applied to the variable
- `pat_anchor-high-then-decoy` — the anchor structure still applies under outcomes pricing
- `pat_economic-turing-test-rev-per-employee` — the AI-era structural reason
- `con_floor-as-draw-vs-floor-as-retainer` — the floor's status under outcomes pricing
- `con_scope-flex-vs-fixed-fee` — the Phase 1 vs Phase 2 scope-discipline contradiction
