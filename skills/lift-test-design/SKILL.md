---
name: lift-test-design
description: Design a holdout, geo, or synthetic-control lift test for any surface (paid ads, email, retention nudge, ABM, content). Computes sample size, MDE, power, audience-holdout shape, randomization protocol, validity window. Outputs test spec with measurement contract under goals/measurement-contracts/. Refuses without baseline + canonical positioning.
version: 0.1
amplifies: PMM lead, growth lead, head of analytics, RevOps, performance manager, lifecycle lead
masters: Annie Duke (decision quality + holdout discipline), Archie Abrams (long-term holdouts find 30-40% evaporation), Elena Verna (pre/post when sample size won't cooperate), Common Thread Collective (incrementality math), Pavel Surmenok (Markov + Bayesian causal inference), Donald Rubin (potential outcomes framework), Pearl (causal DAG), Kohavi + Tang + Xu (Trustworthy Online Controlled Experiments)
substrate_layers_required: [icp, positioning]
patterns_grounded: [incrementality-not-attribution, measurement-correlated-short-signals, goalpost-discipline-vs-metric-drift]
contradictions_aware: [short-feedback-vs-long-term-holdouts]
preflight_refusal: substrate-gap, missing-baseline, missing-positioning
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/analytics/metric-tree.yaml
---

# lift-test-design

## Purpose

Design a falsifiable lift test for any surface where causal lift matters: paid ads (geo holdout), email (subscriber holdout), retention nudge (in-product holdout), ABM (account holdout), content (audience holdout via referrer cohort). The skill is the cross-surface companion to `ad-incrementality-test` (which is paid-ads-specific); it generalizes the math and the protocol so any surface can answer the question "did this actually move the metric, or were we going to get the metric anyway?"

The skill computes sample size, minimum detectable effect (MDE), power, audience-holdout shape, randomization protocol, validity window, and writes a test spec plus a measurement contract that opens a goal in the substrate ledger. Per the `incrementality-not-attribution` pattern, correlation-based attribution is a hypothesis; the lift test is the test.

The skill is honest about cohort math: per the `short-feedback-vs-long-term-holdouts` contradiction, a 30-day holdout that detects MDE is not the same as a 1-year holdout that survives evaporation. The skill names the trade-off and forces an explicit pick.

## Inputs

- `--client <client>` (required)
- `--surface <paid-ads|email|retention|abm|content|onboarding>` (required)
- `--mode <geo-holdout|audience-holdout|psa-control|synthetic-control|switchback|pre-post>` (required)
- `--metric <metric-id-from-tree>` (required; must reference a node in metric-tree.yaml)
- `--baseline <weekly-rate-or-count>` (required; the metric's current weekly value)
- `--mde-pct <float>` (default: 15.0; minimum detectable effect as % of baseline)
- `--alpha <float>` (default: 0.10; two-tailed significance threshold)
- `--power <float>` (default: 0.80)
- `--treatment-share <float>` (default: 0.50)
- `--quarter <YYYY-Q[1-4]>` (required; window the test must close inside)
- `--predicted-p <float>` (operator's prior probability of YES; default derived from heuristics)

## Substrate reads

- `clients/{client}/icp/icp.md`, to define the test cohort.
- `clients/{client}/positioning/positioning.md`, to interpret the metric the test moves.
- `clients/{client}/analytics/metric-tree.yaml`, to validate the metric exists and to identify the parent node.
- `clients/{client}/analytics/attribution-model.md` (when present), to anchor the attribution caveats inside the test design.
- `clients/{client}/ads/diagnostics/*.md` (when surface=paid-ads, when present), to corroborate baseline.

## Output contract

Two artifacts:

1. `clients/{client}/analytics/lift-tests/<surface>-<metric>-<mode>-<YYYY-MM-DD>.md`, the test spec with:
   - **Hypothesis** (the falsifiable claim).
   - **Test design** (treatment-vs-control selection, randomization protocol, intervention).
   - **Sample size + window calculation** (full math, all inputs cited, formula visible).
   - **Measurement plan** (source-system, join key, daily monitoring dashboard, ambiguous-case handling).
   - **Risks and assumptions** (parallel campaigns, seasonality, brand events, spillover, audience size).
   - **Decision rules** (YES action, NO action, AMBIGUOUS action).
   - **Substrate citations** (every claim cites a path).
   - **Contradiction position log** (per `short-feedback-vs-long-term-holdouts`, names whether the test is a fast-loop or a long-window holdout, and why).

2. `goals/measurement-contracts/<client>-lift-<surface>-<metric>-<quarter>.md`, the measurement contract:
   - Frontmatter: goal_id, client, opened_at, status, taste_type, resolution_date, predicted_p_threshold_met, substrate_layers_cited, patterns_applied, contradiction_positions.
   - Body: hypothesis, predicted_outcome, revenue_lever (with $ math), measurement_design, kill_criterion, resolution decision tree.

## Quality criteria

- Refuses without canonical positioning + ICP. The cohort cannot be defined without ICP; the test interpretation cannot land without positioning.
- Refuses without `--baseline > 0`. Every test math depends on the baseline.
- Refuses with MDE < 5% (warns; long windows are vulnerable to confounding and correlated short signals are usually a better strategy per `measurement-correlated-short-signals`).
- Refuses if the named metric is not in `metric-tree.yaml`. Per `metric-tree-not-metric-stack`, untested metrics living outside the tree are signs that the tree is incomplete or the test is wrong.
- The test spec carries the full power math (z-scores, MDE, variance assumption, imbalance factor) so the operator can audit. Tests with hidden math do not pass review.
- Per `goalpost-discipline-vs-metric-drift`, the measurement contract is locked at open. Mid-test changes count as overrides with attribution.

## What this skill does NOT do

- Does not run the test. The skill writes the spec; execution lives in the platform / lifecycle / product tooling.
- Does not analyze the result. That is downstream; the contract specifies the resolution math.
- Does not pick the surface. The operator names the surface; the skill validates against substrate.
- Does not invent the metric. Refuses if the metric is not in the tree.

## Refusal patterns

- `substrate-gap`: missing ICP / positioning / metric-tree.yaml.
- `missing-baseline`: baseline rate or count is zero or negative.
- `metric-not-in-tree`: the named metric does not exist in `metric-tree.yaml`.
- `mde-too-tight` (warning, not refusal): MDE < 5%.
- `window-too-long` (warning): calculated window > 12 weeks; recommend pre/post or correlated short signal.
- `mode-surface-mismatch` (warning): the named mode is poorly suited to the surface (e.g., `geo-holdout` for `email`); the skill emits with a strong caveat.

## Composes with

- Reads from: ICP, positioning, metric-tree.yaml, attribution-model.md (when present), ad diagnostics (when surface=paid-ads).
- Writes for: `score-goal` (resolves the contract this skill emits), `attribution-model-design` (incrementality findings update the model), `analytics-monthly-refresh` routine, `lift-test-rhythm` routine.
- Triggered by: quarterly lift-test rhythm, attribution-model-design recommending corroboration, surface-specific allocation question.

## Calibration

Tracked under taste-types `incrementality` and `decision-quality`. Brier signal: predicted_p_threshold_met scored against the test's actual resolution; calibration improves as more tests resolve.

## See also

- `knowledge/patterns/incrementality-not-attribution.md`.
- `knowledge/patterns/measurement-correlated-short-signals.md`.
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`.
- `knowledge/contradictions/short-feedback-vs-long-term-holdouts.md`.
- `skills/ad-incrementality-test/SKILL.md` (paid-ads specialization).
- `skills/attribution-model-design/SKILL.md`.
- `skills/metric-tree-design/SKILL.md`.
- `routines/lift-test-rhythm.md`.
