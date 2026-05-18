---
name: social-amplification-test
description: Design A/B tests for social hook variants, format variants, or posting time. Real power calculations on impressions and engagement deltas. Outputs a test spec with measurement contract that the operator wires into the platform. Refuses without canonical positioning and a buyer-state cohort. Composes voice-enforce on the variant copy.
version: 0.1
amplifies: social media lead, growth lead, content marketer
masters: Justin Welsh (hook variant cadence), Joanna Wiebe (Copyhackers hook testing), Andrew Chen (paid-acquisition ceiling and channel discipline), Brian Kotlyar (segment-or-die experiment design), Sahil Bloom (creator A/B intuition for native shapes)
substrate_layers_required: [positioning, icp, voc, brand-voice]
patterns_grounded: [native-format-beats-cross-post, social-as-distribution-not-conversion, copywriting-craft-fundamentals, buyer-mindset-not-product-features, measurement-correlated-short-signals]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-positioning, missing-buyer-state
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
  - clients/{client}/07-brand-voice.md
---

# social-amplification-test

## Purpose

Design an A/B (or multi-variant) test for one of three test types:

- **hook**: vary the opening line of a post; everything else identical.
- **format**: vary the structural shape (long-form vs short, image vs video, single vs thread) within the same idea.
- **time**: vary the posting time; same content, different schedule slots.

The skill computes a real power calculation against a baseline engagement rate and a target lift, prints a measurement contract (sample size, success threshold, kill criterion, time-window), and writes a test spec the operator wires into the platform.

It refuses to design a test without canonical positioning (no anchor for the variants) or without a named buyer-state cohort (no audience to test against). It composes voice-enforce on every variant copy block.

## Inputs

- `--client <client>` (required)
- `--platform <linkedin|x|tiktok|instagram|youtube|threads>` (required)
- `--cohort <buyer-state-slug>` (required)
- `--test-type <hook|format|time>` (required)
- `--baseline-engagement-rate <float>` (required) — the platform's current engagement rate (e.g., 0.025)
- `--target-lift-pct <float>` (default 20.0) — minimum detectable lift, as percent of baseline
- `--variants <int>` (default 2) — number of variants (2 = A/B; up to 4)
- `--alpha <float>` (default 0.10) — Type I error tolerance for short signals (per pat_measurement-correlated-short-signals)
- `--power <float>` (default 0.80) — statistical power
- `--out <dir>` (optional, default `clients/<client>/social/tests/`)

## Substrate reads

- `clients/<client>/01-position.md` — anchor terms and value pillars for variant generation.
- `clients/<client>/02-icp.md` — cohort context for the audience the test runs against.
- `clients/<client>/07-brand-voice.md` — kill-list and voice rules.
- `personas/buyer-state/<cohort>.md` or `clients/<client>/personas/<cohort>.md` — frictions and objections used to seed variant hooks.

## Output contract

Writes a test spec at `clients/<client>/social/tests/<platform>-<test-type>-<cohort>-<YYYY-MM-DD>.md`:

```yaml
---
test_id: <client>-social-test-<platform>-<test-type>-<cohort>-<YYYY-MM-DD>
asset_type: audit
test_type: hook | format | time
platform: <platform>
cohort: <cohort>
variants: <int>
baseline_engagement_rate: <float>
target_lift_pct: <float>
alpha: <float>
power: <float>
required_sample_per_variant: <int>
expected_run_days: <int>
substrate_layers_read: [positioning, icp, voc, brand-voice]
patterns_applied: [native-format-beats-cross-post, social-as-distribution-not-conversion, copywriting-craft-fundamentals, buyer-mindset-not-product-features, measurement-correlated-short-signals]
contradictions_resolved: []
produced_by: social-amplification-test
---
```

Body sections:

1. **Test rationale** — what is being tested, and why this is the highest-leverage variation.
2. **Variant scaffolds** — N variant blocks with hook / format / time spec; native to the platform.
3. **Measurement contract** — baseline, target, MDE, sample size, expected run length, kill criterion.
4. **Power calculation detail** — z-alpha, z-beta, MDE, derived sample size with formula.
5. **Resolution rules** — when does the test conclude PASS, FAIL, or NULL.
6. **Operator wiring** — where to schedule each variant; how to log results.
7. **Distribution-not-conversion reminder** — per pat_social-as-distribution-not-conversion, do not resolve on last-click.

## Statistical method

Two-proportion z-test for engagement-rate (treated as a binomial: engaged-or-not per impression). Sample size per variant computed via:

```
n = (z_alpha + z_beta)^2 * (p1*(1-p1) + p2*(1-p2)) / (p2 - p1)^2
```

Where:
- `p1` = baseline engagement rate
- `p2` = `p1 * (1 + target_lift_pct/100)` (the target rate)
- `z_alpha` = critical value for two-sided alpha
- `z_beta` = critical value for power

For `time` tests, the same math applies; the variants are time slots rather than copy.

## Quality criteria

- Every variant cites the substrate path it drew from.
- Power calculation is real, not a placeholder. Sample size and run-day estimate are honest.
- The kill criterion fires before the test wastes spend.
- Per pat_measurement-correlated-short-signals, alpha defaults to 0.10 because short-signal tests on social use looser thresholds than full-funnel tests; the operator can tighten it.

## What this skill does NOT do

- Does not generate finished variants. Variants are scaffolds for the operator (or a downstream skill) to write.
- Does not run the test. The operator schedules into the platform.
- Does not measure performance. Use `social-fatigue-monitor` post-resolution to check what shifted.
- Does not conclude on a variant's incrementality vs the rest of the program. Use a holdout test for that.

## Refusal patterns

- Missing canonical positioning returns `SUBSTRATE-GAP — missing-positioning`.
- Missing buyer-state cohort returns `SUBSTRATE-GAP — missing-buyer-state`.
- `--variants > 4` returns `INPUT-GAP — too-many-variants` (at 5+ variants per test, multiple-comparison correction overwhelms the lift signal at typical social sample sizes).
- `--baseline-engagement-rate <= 0 or >= 1` returns `INPUT-GAP — baseline-out-of-range`.
- `--target-lift-pct < 5` returns `INPUT-WARN — lift-too-small` (the test will require a sample size larger than typical social windows; the spec proceeds but flags).

## See also

- `social-content-design` — generates the variant copy this test scaffolds.
- `social-fatigue-monitor` — reads post-test performance to decide on rolling out the winner.
- `ad-incrementality-test` — the holdout-test sibling; use when the question is incrementality, not creative A/B.
- `routines/social-content-cycle.md` — the weekly cycle that consumes test results.
- `knowledge/patterns/measurement-correlated-short-signals.md`
- `knowledge/patterns/native-format-beats-cross-post.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
