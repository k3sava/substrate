---
name: mental-models
description: Decision-quality skill. Applies a curated mental-models library to a strategic call (open a goal, ship a campaign, change pricing, hire) with explicit pre-mortem and post-mortem. Beats willpower with process.
version: 0.1
amplifies: founder, head of GTM, head of product, PMM lead
masters: Charlie Munger (latticework of mental models, inversion, circle of competence), Daniel Kahneman (System 1/2, anchoring, prospect theory), Annie Duke (Thinking in Bets — separate decision quality from outcome quality), Nassim Taleb (antifragile, barbell allocation, skin in the game), Shane Parrish (Farnam Street — actionable models), Phil Tetlock (superforecasting, calibration)
substrate_layers_required: [strategy]
patterns_grounded: [decision-quality-through-process-not-willpower, diagnose-before-execute, eval-as-data-analysis]
contradictions_aware: [circle-of-competence-vs-iterative-deployment, concentrate-vs-barbell-allocation]
preflight_refusal: substrate-gap, missing-decision-statement
required_reads:
  - knowledge/patterns/decision-quality-through-process-not-willpower.md
  - knowledge/contradictions/circle-of-competence-vs-iterative-deployment.md
  - knowledge/contradictions/concentrate-vs-barbell-allocation.md
---

# mental-models

## Purpose

Most strategic decisions are post-rationalised. This skill enforces process. Before a strategic decision (open a goal, change pricing, ship a launch, hire a role), it applies a structured mental-model audit, surfaces inversions, requires a calibrated probability, and books a post-mortem.

## Inputs

- `--client <client>`
- `--decision <one-line statement>` (required)
- `--reversibility <one-way|reversible>` (required)
- `--horizon <weeks>` (required)
- `--mode <pre-decision|premortem|postmortem>`

## Pre-decision audit (the skill enforces these)

1. **What's the inversion?** What does failure look like? (Munger.)
2. **What does System 2 say?** Walk away, sleep on it, return. (Kahneman.)
3. **What's the calibrated probability?** "I'm 70% it works." Logged for later scoring. (Tetlock.)
4. **Circle of competence?** Are you the right operator to make this call? (Munger.)
5. **What's the anchor?** What number set the range, and was it set by us or by them? (Kahneman.)
6. **Is this concentrate or barbell?** Big single bet or distributed? (Munger vs Taleb — see contradiction.)

## Conditions awareness

`circle-of-competence-vs-iterative-deployment`: reversibility decides. One-way doors get circle-of-competence discipline (Buffett); reversible doors get iterative deployment (Bezos).

`concentrate-vs-barbell-allocation`: volatility regime decides. Stable tail-bounded categories favor concentration (Munger); fat-tailed categories favor barbell (Taleb).

## Substrate reads

- `strategy/decision-log.md`, prior decisions and their resolutions.
- `goals/ledger.md`, calibration history per operator.

## Output contract

- `decisions/<id>/pre-decision.md` with the audit answers + calibrated probability.
- `decisions/<id>/premortem.md` with imagined-failure scenarios.
- `decisions/<id>/postmortem.md` after horizon, with realised vs predicted analysis.
- A row in `goals/ledger.md` with Brier-scorable prediction.

## Quality criteria

- Refuses to advance without a calibrated probability.
- Refuses to call a decision "reversible" without naming the reversal cost.
- Flags repeated decision-failure clusters across postmortems.

## See also

- `skills/open-goal/`, where the decision becomes a goal.
- `skills/score-goal/`, where the calibrated probability gets resolved.
- `knowledge/patterns/decision-quality-through-process-not-willpower.md`.
