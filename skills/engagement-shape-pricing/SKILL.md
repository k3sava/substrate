---
name: engagement-shape-pricing
description: Price the consulting engagement itself per Kesava's outcomes-based offer (Phase 0 free diagnostic → Phase 1 paid fixed-price scoping → Phase 2 floor + variable outcome contract). Refuses hourly billing. Refuses retainer without a measurement contract. Refuses any engagement priced below $100K annualised to the operator. The canonical pricing source is `portfolio.iamkesava.com` → `consulting-offer`; substrate mirrors it.
version: 0.3
status: wired
updated_date: 2026-05-18
amplifies: independent operator, founding-PMM consultant, AI-native PMM specialist
masters: Kesava Mandiga (portfolio consulting-offer doctrine — outcomes-based, three-phase, Brier-scored)
substrate_layers_required: [calibration-history, engagement-shapes, measurement-contract]
patterns_grounded: [productized-consulting-beats-hourly, outcomes-tied-pricing, brier-priced-engagement, anchor-high-then-decoy, anti-fabrication-on-prospects]
contradictions_aware: [scope-flex-vs-fixed-fee, sprint-vs-retainer-default, floor-as-draw-vs-floor-as-retainer]
preflight_refusal: substrate-gap, hourly-shape-requested, pure-retainer-shape-requested, below-annual-floor, missing-measurement-contract, missing-walk-away-criterion
required_reads:
  - canonical/portfolio-consulting-offer.md
  - goals/ledger.md
  - skills/engagement-shape-pricing/operator-pricing-history.yaml
  - knowledge/patterns/productized-consulting-beats-hourly.md
  - knowledge/patterns/outcomes-tied-pricing.md
  - knowledge/patterns/brier-priced-engagement.md
  - knowledge/contradictions/scope-flex-vs-fixed-fee.md
---

# engagement-shape-pricing

## Purpose

The operator-side pricing skill. `pricing-strategic` prices the **client's product**; this skill prices the **operator's engagement**. The canonical source for the operator's offer is `portfolio.iamkesava.com → consulting-offer` (mirrored in `canonical/portfolio-consulting-offer.md`). Substrate enforces — it does not invent.

The skill exists to refuse the engagement shapes the operator has publicly committed not to do (hourly billing, retainers without a measurement contract, engagements below the annualised floor) and to structure the proposal frame around the three phases the offer publishes.

## When to use

- Drafting a proposal for a new prospect.
- Re-pricing an engagement at renewal.
- Quarterly review of `operator-pricing-history.yaml` against actual closes.
- A prospect is pushing for an hourly rate or a flat retainer and the substrate refusal needs to be on the operator's lips, not the operator's gut.

## Inputs

- `--operator <slug>` (required) — identifies whose calibration history to read. Default: substrate maintainer.
- `--prospect <slug>` (required) — the prospect being priced.
- `--engagement-shape <phase-0|phase-1|phase-2-embedded|phase-2-monthly|phase-2-train-team>` (required) — must be one of the published Phase 2 continuation shapes.
- `--prospect-stage <pre-seed|seed|series-a|series-b-plus|growth|established>` (required) — informs the variable-share band.
- `--annualised-target <usd>` (required) — what this engagement is expected to contract to in total operator revenue over 12 months. Refuses below the configured per-client annual floor.
- `--measurement-contract <path>` (required for Phase 2 shapes) — path to the signed Phase 1 measurement contract. Skill refuses Phase 2 pricing without it.
- `--walk-away-criterion <text>` (required) — what makes the operator decline regardless of price. From `walk_away_criteria` in pricing-history.
- `--output <path>` (optional, default `clients/<prospect>/proposal-pricing.md`)

## Substrate reads

- **`canonical/portfolio-consulting-offer.md`** — the load-bearing read. Mirrors `portfolio.iamkesava.com/consulting-offer`. If the published offer changes, this file is the diff target; the skill refuses to drift from it.
- `skills/engagement-shape-pricing/operator-pricing-history.yaml` — operator's structured pricing ledger. Carries `annual_floor_per_client`, `phase_1_fixed_fee`, `walk_away_criteria`, and `engagements` history.
- `goals/ledger.md` — operator's Brier-scored bets. Cross-referenced for calibration-trust signals.
- `clients/<prospect>/diagnostics/phase-0-audit.md` — required reading for Phase 1 pricing (the diagnostic findings shape the Phase 1 scope).
- `clients/<prospect>/measurement-contract.md` — required reading for Phase 2 pricing.
- `knowledge/patterns/productized-consulting-beats-hourly.md` — the fixed-fee discipline.
- `knowledge/patterns/outcomes-tied-pricing.md` — the operator's published doctrine: outcomes are now measurable, so they are the unit of pricing.
- `knowledge/patterns/brier-priced-engagement.md` — calibrated probability of metric-hit determines variable.
- `knowledge/contradictions/scope-flex-vs-fixed-fee.md` — fixed-fee default for Phase 1, scope-flex for Phase 2.
- `knowledge/contradictions/sprint-vs-retainer-default.md` — picks between Phase 2 embedded (sprint) vs Phase 2 monthly (sustained), per prospect stage.
- `knowledge/contradictions/floor-as-draw-vs-floor-as-retainer.md` — the operator's floor in Phase 2 is an outcome-independent **draw**, not a retainer; the skill enforces the distinction.

## The three phases (mirrored from portfolio)

### Phase 0 — Free AI-native diagnostic (60–90 minutes)

Free. No invoice. Bootstraps a `clients/<prospect>/` from public surfaces (LP, blog, pricing, careers, reviews, AEO citations). Substrate runs four audits (positioning, AEO triangle, status-quo competitor map, Tier-A pattern coverage). Output: a diagnostic the prospect can choose to act on or walk away from.

The skill emits a Phase 0 calendar invite + diagnostic deliverable plan. No price.

### Phase 1 — Scoping engagement (paid, fixed, 5 working days)

Paid. Fixed-price. Bounded. Produces three artifacts:

1. **Populated `clients/<prospect>/` substrate** — 10-layer context model, cited, freshness-windowed.
2. **Measurement contract** — what metric we move, source system, baseline, predicted lift, window, verification path. The contract is the deliverable; Phase 2 does not start until it's signed.
3. **90-day skill roadmap** — which of substrate's 37 skills to add, ranked by leverage, each with a Brier-scorable impact prediction.

The Phase 1 fee is fixed and lives in `operator-pricing-history.yaml::phase_1_fixed_fee`. The skill refuses to ship a Phase 1 proposal where the fee is below the recorded floor.

### Phase 2 — Outcome contract (floor + variable)

The variable is the headline. Three structures (one is picked per engagement, agreed inside Phase 1):

- **% of attributable lift** — most common. % of incremental revenue / conversions / pipeline / retention attributable to the engagement, measured against the cited baseline at the cited window. If the lift doesn't materialise, neither does the variable.
- **Per-unit bonus** — discrete outcomes (per logo retained above churn baseline, per deal won at competitive displacement, per new prompt won in AEO citation). Bounded ceiling.
- **Brier-bonus** — operator opens the engagement with a calibrated probability that the metric hits target. Full bonus on a correct high-confidence call; floor only on a wrong call.

The **floor** in Phase 2 is an outcome-independent operator draw — not a retainer. It covers operator time at a steady cadence; it is **conditioned** on the signed measurement contract. No measurement contract → no floor → no Phase 2. The skill enforces the conditioning (see `con_floor-as-draw-vs-floor-as-retainer`).

Three Phase 2 continuation shapes (operator's published continuation menu):

| Shape | Cadence | Best when | Pricing |
|---|---|---|---|
| **Embedded operator** | 4–8 weeks, daily standup, weekly review | Specific high-leverage move (re-positioning, launch, replatform) | Floor + variable on engagement metric |
| **Monthly retainer** *(measurement-tied)* | 3-month minimum, one strategic skill per month + measurement loop | Sustained substrate operation, team learns alongside | Monthly floor + per-skill variable |
| **Train-the-team** | 2-week sprint, certify the team's first calibration cycle | Team will run substrate; operator sets calibration baseline | Fixed scoping fee + variable bonus on team's first 90-day Brier score |

Note: "monthly retainer" here is the continuation-shape label from the published offer. Internally substrate treats it as a measurement-tied draw, not a retainer in the conventional sense — see `con_floor-as-draw-vs-floor-as-retainer`. Pure retainers (no measurement) are refused at preflight.

## Annual per-client floor (the hard refusal line)

Recorded in `operator-pricing-history.yaml::annual_floor_per_client`. Current value: **$100,000 USD annualised**.

The floor is the total operator-side revenue contracted (Phase 1 fee + Phase 2 floor + expected Phase 2 variable at the operator's own Brier-scored confidence) projected to 12 months. If an engagement is shorter than 12 months, the floor is pro-rated upward: 6-month engagement floors at $50K; 90-day engagement floors at $25K.

The skill refuses with `BELOW-ANNUAL-FLOOR` if the proposal's expected total falls below this. Override permitted only with logged rationale in `engagements[].override_reason`.

The floor is a **calibration hook**, not a static rule. As `engagements` accrue, it tightens upward (real closes set the new floor). It does not loosen without explicit operator decision.

## What this skill refuses to produce

Encoded at preflight; not negotiable inside the skill:

- **Hourly pricing.** `HOURLY-SHAPE-REQUESTED`. The operator does not sell time. Per portfolio "What I won't do" → published refusal.
- **Pure retainer (no measurement contract).** `PURE-RETAINER-REQUESTED`. The operator does not sell calendar without a metric. Per portfolio "What I won't do" → published refusal.
- **Engagement below annualised $100K floor.** `BELOW-ANNUAL-FLOOR`. The operator's stated revenue minimum per client.
- **Phase 2 proposal without a signed measurement contract.** `MISSING-MEASUREMENT-CONTRACT`. Phase 1 produces the contract; Phase 2 does not start until it's signed.
- **Engagement without a verification path.** `MISSING-VERIFICATION-PATH`. The metric must be pullable from a source-of-truth system at the window. If it can't, the contract can't be written.
- **Multi-rep engagements.** `MULTI-REP-REQUESTED`. The operator is the operator; substrate refuses to price a subcontracted version of the work.

## Process

1. Preflight: read `canonical/portfolio-consulting-offer.md`. Refuse with `SUBSTRATE-GAP` if missing or out-of-sync with the live portfolio (sync check via `bin/substrate-status` or manual diff).
2. Read `operator-pricing-history.yaml`. Confirm `annual_floor_per_client`, `phase_1_fixed_fee`, `walk_away_criteria` are populated. Refuse with `SUBSTRATE-GAP` if any are missing.
3. Branch on `--engagement-shape`:
   - **Phase 0**: emit a free-diagnostic plan (no price). Output is a calendar invite + diagnostic-deliverable spec.
   - **Phase 1**: read the recorded fixed fee. Compose the Phase 1 proposal-pricing card around it.
   - **Phase 2 (any continuation shape)**: refuse without the signed Phase 1 measurement contract path. Compute the floor (operator draw) and propose the variable structure (% lift / per-unit / Brier).
4. Annual-floor check: project the engagement's total operator revenue at 12 months. Refuse with `BELOW-ANNUAL-FLOOR` if below `annual_floor_per_client` (pro-rated for shorter engagements).
5. Read `knowledge/contradictions/scope-flex-vs-fixed-fee.md`. Pick Position A (fixed-fee) for Phase 1; Position B (scope-flex) for Phase 2.
6. Read `knowledge/contradictions/sprint-vs-retainer-default.md`. Pick the right Phase 2 continuation shape for the prospect's stage.
7. Read `knowledge/contradictions/floor-as-draw-vs-floor-as-retainer.md`. Lock the floor as a draw (measurement-conditioned), not a retainer.
8. Emit the pricing card. Voice-enforce on the prose (operator-voice, no kill-list words, no "transformation"/"strategic"/"leverage"/"unlock").
9. Write the kill-criterion section: composed from `walk_away_criteria` plus the published "What I won't do" list.
10. Output goes to `clients/<prospect>/proposal-pricing.md`. The annual-floor projection is marked `private: true` in frontmatter; the proposal-export filter strips it before the proposal goes to the prospect.

## Output contract

```yaml
---
asset_type: engagement-pricing-card
produced_by: engagement-shape-pricing
operator: <slug>
prospect: <slug>
engagement_shape: <phase-0|phase-1|phase-2-embedded|phase-2-monthly|phase-2-train-team>
prospect_stage: <stage>
annual_floor_check:
  annualised_total_usd: <number>
  floor_usd: 100000
  passes: <true|false>
  private: true
phase_1_fee_usd: <number, present only for phase-1 shapes>
phase_2_floor_usd: <number, present only for phase-2 shapes>
phase_2_variable_structure: <pct-lift|per-unit|brier-bonus, present only for phase-2 shapes>
measurement_contract_path: <path, required for phase-2>
walk_away_criterion: <text>
substrate_cited:
  - canonical/portfolio-consulting-offer.md
  - operator-pricing-history.yaml
contradiction_positions:
  - scope-flex-vs-fixed-fee: <A|B>
  - sprint-vs-retainer-default: <A|B>
  - floor-as-draw-vs-floor-as-retainer: <A>
position_rationale: <one sentence per contradiction>
---

# Engagement pricing — <prospect>

## Phase shape
<which phase; what it covers>

## What's included
<scope per the published continuation table>

## How it's priced
<phase-specific block — fixed fee for Phase 1; floor + variable structure for Phase 2>

## How it's measured
<reference to the signed measurement contract; window; verification path>

## What I won't do for this engagement
<composed from walk_away_criteria + published "What I won't do" list>
```

The annual-floor projection and the operator's reservation logic are marked `private: true` in frontmatter; the proposal-export filter strips them before the proposal goes to the prospect.

## Quality criteria

- Refuses any request for hourly pricing. No exceptions.
- Refuses any retainer without a signed measurement contract.
- Refuses any engagement projected below $100K annualised. Override is logged, not silent.
- Refuses any Phase 2 proposal without a Phase 1 measurement contract path.
- Refuses any engagement without a verification path on the metric.
- Voice-enforce: operator-voice on the prose, no kill-list words, no sales-pitch register.
- Calibration-band tightening: as `engagements` accrue, the floor moves upward against real closes.

## Contradictions awareness

- `scope-flex-vs-fixed-fee` — Position A (fixed-fee) for Phase 1 (bounded, contract-producing). Position B (scope-flex) for Phase 2 (compounding, renegotiation gate quarterly).
- `sprint-vs-retainer-default` — Position A (sprint = Phase 2 embedded) default at pre-seed / seed / Series A. Position B (sustained = Phase 2 monthly) default at Series B+ where calibration history compounds.
- `floor-as-draw-vs-floor-as-retainer` — Position A only. The floor is a draw, conditioned on the measurement contract. The skill refuses Position B (pure retainer).

## Refusal patterns

- `SUBSTRATE-GAP` → `canonical/portfolio-consulting-offer.md` missing or out-of-sync, or `operator-pricing-history.yaml` missing the required keys.
- `HOURLY-SHAPE-REQUESTED` → prospect asked for hourly. Skill refuses; suggests Phase 0 instead.
- `PURE-RETAINER-REQUESTED` → prospect asked for monthly retainer without measurement. Skill refuses; redirects to Phase 1 measurement-contract scoping.
- `BELOW-ANNUAL-FLOOR` → projected annualised total below $100K. Skill refuses without operator override.
- `MISSING-MEASUREMENT-CONTRACT` → Phase 2 requested without a signed Phase 1 measurement contract path.
- `MISSING-VERIFICATION-PATH` → metric is not pullable from a source-of-truth system at resolution.
- `MULTI-REP-REQUESTED` → engagement asked the operator to subcontract.

## What this skill does NOT do

- Does not negotiate with the prospect. The proposal goes; the back-and-forth is the operator's.
- Does not price the client's product. That's `pricing-strategic`.
- Does not invent the annual floor or the Phase 1 fixed fee. The operator records them in `operator-pricing-history.yaml`; the skill enforces them.
- Does not produce Phase 2 pricing without a Phase 1 measurement contract path. Phase 1 is the gate.

## See also

- `canonical/portfolio-consulting-offer.md` — the canonical source.
- `portfolio.iamkesava.com/consulting-offer` — the live published offer.
- `skills/consulting-poc/` — Phase 0 / Phase 1 / Phase 2 engagement skill (composes this skill).
- `skills/pricing-strategic/` — parallel skill for the client's product.
- `skills/engagement-shape-pricing/operator-pricing-history.yaml` — the structured pricing ledger.
- `goals/ledger.md` — the operator's Brier-scored bets.
- `knowledge/patterns/productized-consulting-beats-hourly.md`
- `knowledge/patterns/outcomes-tied-pricing.md`
- `knowledge/patterns/brier-priced-engagement.md`
- `knowledge/contradictions/scope-flex-vs-fixed-fee.md`
- `knowledge/contradictions/sprint-vs-retainer-default.md`
- `knowledge/contradictions/floor-as-draw-vs-floor-as-retainer.md`
- `UPGRADES-2026-05-18.md` — gap analysis that derived this skill, Resolution #2 updated with the corrected pricing model.
