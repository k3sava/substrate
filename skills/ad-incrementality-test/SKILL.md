---
name: ad-incrementality-test
description: Design a geographic holdout or PSA-control test for measuring incremental lift on a paid channel. Outputs a complete test design (matched markets, treatment / control, MDE calculation, window, resolution date) plus the measurement contract that opens the goal in the substrate ledger. Refuses without canonical positioning, without baseline conversion data, and without a stated minimum-detectable-effect.
version: 0.1
amplifies: head of growth, paid-marketing lead, RevOps
masters: Avinash Kaushik (incrementality vs attribution), Brian Balfour (Reforge incrementality discipline), Susan Wenograd (platform self-attribution incentives), Aaron Orendorff (CTC ROAS-vs-incremental divergence), Annie Duke (sample size as decision quality)
substrate_layers_required: [icp, positioning, voc]
patterns_grounded: [incrementality-not-attribution, intent-vs-interest-targeting]
preflight_refusal: substrate-gap, missing-baseline, missing-mde
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
---

# ad-incrementality-test

## Purpose

Run a designed test that measures the *incremental* impact of a paid channel against a baseline. Two modes:

- **`geo-holdout`** turn paid spend off in a set of matched-market geos (treatment), leave it on in a matched control set, measure the conversion delta over the window.
- **`psa-control`** ghost-ad / public-service-announcement variant where the treatment group sees a non-promotional version of the ad and the control group sees the actual ad (Google's lift-study mode, Facebook's Test and Learn). Used when geo holdout is not feasible (e.g., national brand campaign).

The output is a complete test design plus a measurement contract that opens a goal in the substrate ledger. The test executes in the ad platform; this skill produces the spec.

## Inputs

- `--client <client>` (required)
- `--channel <channel>` (required) which channel to test (`meta-paid-social`, `google-search`, etc.).
- `--mode <geo-holdout|psa-control>` (required)
- `--baseline-conversions <int>` (required) baseline weekly conversions for the channel under test. Used to compute MDE and window.
- `--baseline-cac <usd>` (required)
- `--mde-pct <float>` (optional, default `15.0`) minimum detectable effect as a percent change in conversions. Smaller MDE = longer window or larger sample.
- `--alpha <float>` (optional, default `0.10`) acceptable false-positive rate.
- `--power <float>` (optional, default `0.80`) acceptable true-positive rate.
- `--treatment-share <float>` (optional, default `0.50`) fraction of geos / users in treatment.
- `--quarter <YYYY-Q[1-4]>` (required) the quarter the test resolves in.
- `--out <dir>` (optional)

## Substrate reads

- `clients/<client>/01-position.md` for the channel-fit context (does the channel match the canonical ICP?).
- `clients/<client>/02-icp.md` for cohort signals.
- `clients/<client>/ads/diagnostics/<channel>-*.md` for recent observed CAC.

## Output contract

Writes two files:

### 1. Test design
At `clients/<client>/ads/incrementality/<channel>-<mode>-<YYYY-MM-DD>.md`:

```yaml
---
test_id: <client>-incr-<channel>-<mode>-<YYYY-MM-DD>
client: <client>
channel: <channel>
mode: geo-holdout | psa-control
quarter: <quarter>
baseline:
  weekly_conversions: <int>
  cac_usd: <usd>
  source: <substrate path>
test_parameters:
  mde_pct: <float>
  alpha: <float>
  power: <float>
  treatment_share: <float>
calculated_window:
  weeks: <int>
  end_date: <YYYY-MM-DD>
substrate_layers_read: [icp, positioning, voc]
patterns_applied: [incrementality-not-attribution, intent-vs-interest-targeting]
---
```

Body sections:
1. **Hypothesis** what we believe the platform-reported number overstates / understates by, with the prior.
2. **Test design** matched markets (or PSA/lift-study setup), treatment vs control, what changes per group.
3. **Sample size + window calculation** computed from baseline + MDE + alpha / power.
4. **Measurement plan** which conversion event, which join key, which dashboard / API.
5. **Risks and assumptions** what could invalidate the test (seasonality, parallel campaigns, brand events).
6. **Decision rules** what we do at YES, NO, AMBIGUOUS.

### 2. Measurement contract
At `goals/measurement-contracts/<client>-incr-<channel>-<quarter>.md`. Same shape as the contracts emitted by `ad-spend-allocate`, but the metric is incremental lift (not raw CAC).

## Quality criteria

- Window calculation shows the formula and the inputs (baseline, MDE, alpha, power, treatment share).
- MDE is named explicitly and tied to a business decision (e.g., "we will scale the channel if incremental ROAS is at least 1.5x platform-reported ROAS").
- Treatment / control selection logic is named (matched-market criteria, randomization seed, or platform-managed for PSA-control).
- Risks section names at least three confounders (parallel campaigns, seasonality, brand events).

## What this skill does NOT do

- Does not run the test in the platform. The operator (or platform-managed lift study) does that.
- Does not analyze the result. A separate `ad-incrementality-resolve` skill (future) does that, or the operator runs `score-goal` against the contract.
- Does not pick the channel to test. The operator picks; the skill validates that the channel meets the 5%-budget threshold.
- Does not compute MMM (marketing mix modeling); that is a different scale of effort.

## Refusal patterns

- Missing canonical positioning returns `SUBSTRATE-GAP — missing-positioning`.
- Missing canonical ICP returns `SUBSTRATE-GAP — missing-icp`.
- Missing or zero baseline conversions returns `INPUT-GAP — missing-baseline`.
- MDE below 5% returns `INPUT-WARN — mde-too-tight` (warn, run, but flag the long window).
- Calculated window above 12 weeks returns `INPUT-WARN — window-too-long` (warn; check whether the MDE or baseline is wrong).
- Channel below 5% of recent ad-diagnose total spend returns `SCOPE-WARN — channel-below-incrementality-threshold` (run, but note the pattern's threshold says incrementality is for channels above 5%).

## See also

- `ad-spend-allocate` — surfaces channels above 5% budget share that need testing.
- `pat_incrementality-not-attribution` — the pattern this skill operationalises.
- `routines/ad-allocation-routine.md` — the quarterly cadence; this test schedules per quarter.
- `score-goal` — resolves the contract this skill emits.
