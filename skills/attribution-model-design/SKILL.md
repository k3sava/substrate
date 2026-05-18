---
name: attribution-model-design
description: Design the attribution model the client uses (last-touch, first-touch, linear, time-decay, position-based, Markov chain, or honest-incrementality). Names each model's blind spots, data requirements, and validity window. Refuses without channel inventory; refuses without measurement contract template; emits the model spec at clients/<client>/analytics/attribution-model.md.
version: 0.1
amplifies: PMM lead, growth lead, head of analytics, RevOps, founder, CMO
masters: Avinash Kaushik (multi-channel attribution literacy), Bob Hoffman (the brand-vs-direct debate), Common Thread Collective (incrementality-not-attribution literature), Rand Schulman (multi-touch attribution research), Pavel Surmenok (Markov-chain attribution math), Andrew Chen + Brian Balfour (channel-fit and attribution-window discipline)
substrate_layers_required: [icp, positioning]
patterns_grounded: [incrementality-not-attribution, goalpost-discipline-vs-metric-drift]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-channel-inventory
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/analytics/sources.yaml
---

# attribution-model-design

## Purpose

Pick the attribution model the client should run, with stated blind spots, data requirements, and validity window. Most teams default to last-touch because that is what the ad-platform UI defaults to; the resulting allocation decisions are systematically biased toward the bottom-of-funnel channel and away from the channels that created the lead. The skill forces an explicit choice: which model, applied to which decisions, with what blind spots, defended by what corroborating signal (incrementality test, brand-search lift, sales-team pipeline survey).

The skill does not generate the data; it specifies the model. Per the `incrementality-not-attribution` pattern, even the best correlation-based model is not the same as causation-based incrementality; the model spec names where each model lies and what to triangulate against.

## Inputs

- `--client <client>` (required)
- `--model <last-touch|first-touch|linear|time-decay|position-based|markov-chain|incrementality-anchored|hybrid>` (default: `hybrid`; the skill also accepts `--all` to emit all 7 models for comparison)
- `--decision-context <budget-allocation|channel-pruning|board-reporting|exec-attribution>` (default: `budget-allocation`; the chosen context conditions which model the skill recommends as primary)
- `--window <YYYY-MM-DD,YYYY-MM-DD>` (default: trailing 90 days; the validity window the model is computed over)

## Substrate reads

- `clients/{client}/analytics/sources.yaml` (channel inventory: which channels run, which platforms report them, which sources flow into the warehouse).
- `clients/{client}/icp/icp.md`, to interpret per-segment touchpoint paths.
- `clients/{client}/positioning/positioning.md`, to cross-check whether positioning relies on channels the model under-credits.
- `clients/{client}/ads/diagnostics/*.md` (when present), to anchor the model's outputs against the ad-diagnose CAC numbers.
- `clients/{client}/analytics/incrementality/*.md` (when present), to incorporate incrementality findings into the model recommendation.

## Output contract

A single artifact at `clients/{client}/analytics/attribution-model.md` with:

- **Recommended model** (one of the 8) and **why** (decision context + data availability + the named alternative the team would otherwise default to).
- **Stated blind spots**, per model: what the model overcredits, what it undercredits, and which decisions it should not be used to inform.
- **Data requirements**: which sources.yaml entries must be wired, which join keys must exist, which time windows must be available.
- **Validity window**: the trailing window the model is recomputed over and the cadence of recomputation.
- **Triangulation plan**: which of (incrementality test, brand-search lift, sales-team survey, geo holdout, churn-cohort proxy) is run quarterly to cross-check the model.
- **Decision rights**: which decisions the model is allowed to drive (budget allocation, channel pruning, exec reporting), and which it is not.
- **Contradiction position**: per `no-decision-vs-named-competitor`, the model spec names whether the channel mix is being optimized against status-quo competition (under-credits brand and content because no-decision wins look like organic) or named competitors (last-touch is more honest because the buyer is comparing).

The skill also emits a **measurement contract** at `goals/measurement-contracts/<client>-attribution-<window>.md` that opens a goal: the model is validated by an incrementality test within 90 days. Per `goalpost-discipline-vs-metric-drift`, the contract is locked at open and any mid-quarter change is logged with attribution.

## Quality criteria

- Refuses without channel inventory in `sources.yaml`. The model is meaningless without a named list of channels.
- Each model named in the output carries: math (the credit allocation formula), data requirement (the source-system join), blind spot (what the model lies about), and triangulation move (the corroborating signal).
- The recommended model is conditioned on decision context: budget-allocation work demands incrementality-anchored or hybrid; board-reporting work tolerates last-touch with a stated caveat; channel-pruning work demands position-based or Markov chain.
- Refuses to recommend any single model as "the truth." Per the pattern, every model has blind spots; the spec names them so the team triangulates.

## What this skill does NOT do

- Does not compute the credit allocation. The skill writes the model spec; computation runs against the warehouse via standard tools (the skill names the tools).
- Does not run the incrementality test. That is `lift-test-design`.
- Does not allocate budget. That is `ad-spend-allocate`.
- Does not invent the channel inventory. Refuses if `sources.yaml` does not list channels.

## Refusal patterns

- `substrate-gap`: missing ICP / positioning / sources.yaml.
- `missing-channel-inventory`: `sources.yaml` empty or has no channels declared.
- `model-context-mismatch` (warning, not refusal): the requested model is poorly suited to the decision context (e.g., `last-touch` for `budget-allocation` work); the skill emits the model with a strong caveat and recommends a hybrid alternative.

## Composes with

- Reads from: `clients/<client>/analytics/sources.yaml`, ICP + positioning, ad-diagnose outputs (when present), incrementality results (when present).
- Writes for: `dashboard-spec` (the model's outputs feed the channel-attribution dashboard), `lift-test-design` (the model's blind spots become hypotheses to test), `ad-spend-allocate` (the model's recommended channel mix is the input).
- Triggered by: quarterly attribution review, channel-mix shift, new channel added, ad-diagnose result that disagrees with platform attribution.

## Calibration

Tracked under taste-type `attribution`. Brier signal: the model's predicted channel-rank should match the post-test incrementality ranking within 1 position; misranks count as Brier losses.

## See also

- `knowledge/patterns/incrementality-not-attribution.md`.
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`.
- `knowledge/contradictions/no-decision-vs-named-competitor.md`.
- `templates/attribution-model-example.md` (canonical artifact shape).
- `skills/lift-test-design/SKILL.md`.
- `skills/ad-spend-allocate/SKILL.md`.
- `skills/dashboard-spec/SKILL.md`.
- `routines/lift-test-rhythm.md`.
