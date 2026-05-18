---
id: con_scope-flex-vs-fixed-fee
title: Scope-flex retainers vs fixed-fee productized engagements
captured_date: 2026-05-18
---

# Scope-flex retainers vs fixed-fee productized engagements

## Position A — fixed-fee productized engagements; scope is the contract, not a variable
- Operator: Jonathan Stark (`ins_stark-hourly-billing-is-nuts`), Blair Enns (`ins_enns-value-priced-engagements`), David C. Baker (`ins_baker-positioning-sets-price-floor`)
- Claim: scope-flex is the consulting trap. The operator who lets scope expand inside a "retainer" or "embedded" engagement subsidises client requests at zero marginal price; the client learns that every ask is free. Fixed-fee with named scope, named deliverables, named refusal-criteria is the operator-side discipline. If the scope needs to change, the engagement re-prices, doesn't dilute. Stark's rule: "scope creep is a pricing-model failure, not a client failure."

## Position B — scope-flex is honest for long-window engagements where the early picture is incomplete
- Operator: Alan Weiss (*Million-Dollar Consulting*; `ins_weiss-value-based-fees`), Tim Williams (*Positioning for Professionals*; `ins_williams-positioning-led-pricing`), McKinsey-style consulting practice (the "scope evolves as we learn" frame)
- Claim: at engagement shapes longer than 8 weeks, the operator's initial scope picture is necessarily incomplete — the customer-call data isn't in, the positioning canon hasn't been audited, the calibration ledger has zero entries on this client. A fixed-fee on a six-month retainer freezes scope based on a snapshot that was wrong by week 4. Honest pricing for long-window engagements is *value-priced with scope-flex* — the fee is tied to the *value created*, not the *artifacts delivered*, and scope evolves as the substrate matures. Weiss's value-based fees explicitly accept scope-flex on long engagements.

## Conditions distinguishing them

- **Engagement window length** is the dominant variable. Fixed-fee dominates engagements ≤8 weeks (5-day POC, 4-8-week embedded, 2-week train-team) — the scope picture stabilises before week 4. Scope-flex dominates engagements ≥12 weeks (3-month retainer, 6-month embedded) — the substrate matures past week 8 and the original scope is genuinely stale.
- **Substrate maturity at engagement start**: if the client arrives with a working positioning canon, an ICP, and a calibration ledger, the operator's scope picture stabilises early — fixed-fee works. If the client arrives empty (founding-PMM case, no substrate at all), the scope picture matures over the engagement — scope-flex is more honest.
- **Operator's calibration history with this client shape**: an operator with 5+ scored engagements at this shape has a tight scope picture from day 1 — fixed-fee works even on long engagements. An operator with no prior engagement at this shape is bidding on assumptions — scope-flex is the rational option for both sides.
- **Renegotiation gate cadence**: scope-flex requires a quarterly renegotiation gate to prevent indefinite scope expansion. Fixed-fee doesn't need a renegotiation gate inside the contract window — the scope is the contract.

## Resolution / synthesis

Not orthogonal at the strategic level; both can be true at different engagement shapes inside the same operator's pricing menu. The genuine contradiction is in *default pricing model*:

- Engagements ≤8 weeks: fixed-fee default (Position A). Productize the scope; price the productization.
- Engagements 8-12 weeks: hybrid — fixed-fee on the first 8 weeks (productized phase-1), scope-flex on the back half if a phase-2 extension fires. Each phase re-prices.
- Engagements ≥12 weeks: scope-flex default (Position B) with a quarterly renegotiation gate that re-prices the next quarter against the substrate matured to date.

## How substrate uses this contradiction

`engagement-shape-pricing` reads this contradiction's `Conditions` section and picks the default based on the engagement-shape input:

- `--engagement-shape phase-0` or `5day-poc` or `4-8w-embedded` or `2w-train-team` → fixed-fee default (Position A)
- `--engagement-shape 3m-retainer` or `6m-embedded` or longer → scope-flex default (Position B) with explicit quarterly renegotiation gate in the proposal frontmatter
- `--engagement-shape custom` → operator must explicitly declare position; refuse to default

The position is recorded on the output artifact (`clients/<prospect>/proposal-pricing.md` frontmatter: `contradiction_positions.scope-flex-vs-fixed-fee: <A|B>`). A pricing artifact that runs Position A logic on a Position B engagement freezes scope on assumptions; a pricing artifact that runs Position B logic on a Position A engagement invites scope creep on a productized offer.
