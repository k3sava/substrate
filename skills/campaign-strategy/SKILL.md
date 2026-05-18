---
name: campaign-strategy
description: Multi-channel campaign sequencing logic. Stages: thesis (the bet) → audience (cohort + size) → channel mix (paid / email / social / content / sales) → cadence → measurement. Outputs a campaign spec with a falsifiable measurement contract opened at the same time as the plan. Refuses without canonical positioning and a goal-ledger entry.
version: 0.2
amplifies: PMM, demand-gen, brand lead, founder, growth lead
masters: April Dunford (campaign-as-positioning-instantiation), Andy Raskin (story-as-the-spine), Brian Balfour (channel cycles + product-channel-fit), Elena Verna (earned channels over algorithm channels), Anthony Pierri (campaign maps to one cohort + one outcome), Lenny Rachitsky (campaign-as-multi-channel-cadence), Brendan Hufford (3S content from sales/success/support), Andy Crestodina (Q&A density + content as direct response)
substrate_layers_required: [positioning, icp, voc, market-context, sales-pitch, conversion-narrative, competitive]
patterns_grounded: [launch-as-coordinated-distribution, narrative-as-strategy, distribution-as-moat, agents-mapped-to-jtbd, measurement-correlated-short-signals, trigger-events-beat-cadence-blast, channel-arbitrage-window, intent-vs-interest-targeting]
contradictions_aware: [build-quietly-vs-distribution-first, short-feedback-vs-long-term-holdouts, outbound-vs-inbound-budget]
preflight_refusal: substrate-gap, missing-target-cohort, missing-falsifiable-prediction, missing-positioning
required_reads:
  - clients/{client}/positioning/
  - clients/{client}/icp/
---

# campaign-strategy

## Purpose

A campaign without a falsifiable prediction is performance theater. This skill scaffolds a campaign with a named cohort, a measurement contract, a canonical narrative, channel adaptations, a calibration prediction, and a kill criterion. The narrative is canonical; channels are adaptations; the measurement contract opens with the campaign, not after it.

## Inputs

- `--client <client>` (required)
- `--campaign <slug>` (required) — `q3-2026-financial-services-displacement` or similar
- `--cohort <pinned-icp>` (required) — the audience the campaign reaches
- `--outcome <named-business-outcome>` (required) — must map to revenue per operator
- `--horizon <weeks>` (required) — campaign window
- `--channels <comma-sep>` (required) — must justify each per `intent-vs-interest-targeting` and `channel-arbitrage-window`
- `--mode <plan|brief|measure|retrospective>` (default: `plan`)

## Output deliverables (per mode)

**plan** — `clients/<client>/campaigns/<slug>/spec.md` with:
1. **Thesis (the bet).** What changes if this campaign wins. The narrative spine.
2. **Cohort.** Who, in customer language, with VoC citations.
3. **Outcome.** The business move, falsifiable, source-system instrumented.
4. **Channels + adaptations.** Each channel justifies why it's chosen vs alternatives.
5. **Cadence.** Timeline of asset launches, in what sequence, with what dependency.
6. **Calibrated prediction.** Operator predicts probability of hitting the outcome.
7. **Kill criterion.** What signal would cause early termination.

Plus sub-files:
- `clients/<client>/campaigns/<slug>/measurement-contract.md` — a goal-ledger contract opened at plan time.
- `clients/<client>/campaigns/<slug>/cadence.md` — week-by-week launch sequence.
- `clients/<client>/campaigns/<slug>/briefs/<asset>.md` — one brief per asset (LP, ad, email, sequence, post).

**brief** — Per-asset brief that another skill (`lp-ship`, `narrative-compose`, `outbound-sequence-design`) consumes.

**measure** — Mid-campaign measurement read against the prediction. Routes to kill, continue, or amplify.

**retrospective** — Resolution of the measurement contract. Brier score on the calibrated prediction.

## Conditions awareness

- **`build-quietly-vs-distribution-first`**: pre-PMF / deep-tech contexts pick build-quietly (campaign deferred until distribution motion is right). Post-PMF picks distribution-first (the coordinated sequence below).
- **`short-feedback-vs-long-term-holdouts`**: cohort size + reversibility decide the measurement window.
- **`outbound-vs-inbound-budget`**: budget allocation between outbound and inbound channels depends on PMF stage and channel maturity.

## Substrate reads

- `positioning/`, the canonical statement (load-bearing).
- `messaging/matrix.md`, channel adaptations.
- `market-context/`, channel cycles + competitor signals.
- `goals/ledger.md`, prior calibration history.

## Output contract

- `clients/<client>/campaigns/<slug>/spec.md`
- `clients/<client>/campaigns/<slug>/measurement-contract.md`
- `clients/<client>/campaigns/<slug>/cadence.md`
- `clients/<client>/campaigns/<slug>/briefs/<asset>.md` per asset
- A row in `goals/ledger.md` with the campaign's calibrated prediction.

Every artifact carries `produced_by: campaign-strategy` for Gate 7 (pattern-applied) verification.

## Quality criteria

- Refuses a campaign without canonical positioning.
- Refuses a campaign without a calibrated prediction (P, threshold, window, source-system).
- Refuses a channel without justification from intent-vs-interest framing + channel-arbitrage-window logic.
- Refuses an outcome that is not falsifiable (vanity metrics, "engagement," "brand awareness without measurement contract").
- Flags drift: shipped assets that contradict the plan's narrative spine.

## See also

- `skills/launch-plan/`, the launch counterpart for a product or feature.
- `skills/narrative-strategy/`, the spine.
- `skills/messaging-matrix/`, the canonical messages.
- `knowledge/patterns/launch-as-coordinated-distribution.md`.
- `knowledge/patterns/distribution-as-moat.md`.
- `knowledge/patterns/channel-arbitrage-window.md`.
- `knowledge/patterns/intent-vs-interest-targeting.md`.
