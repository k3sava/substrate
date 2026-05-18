---
name: ad-spend-allocate
description: Allocate paid-ads budget across channels and cohorts with falsifiable predictions. Reads channel-historical CAC and conversion-value from ad-diagnose outputs, applies LTV/CAC targets, and emits one measurement contract per allocation that opens a goal in the substrate ledger. Refuses without diagnostic data or without a target LTV/CAC.
version: 0.1
amplifies: head of growth, paid-marketing lead, founder
masters: Annie Duke (Thinking in Bets — calibrated allocation), Brian Balfour (Reforge channel-product fit), Andrew Chen (channel decay curve), Susan Wenograd (creative-as-targeting allocation), Avinash Kaushik (See/Think/Do/Care budget mapping), Aaron Orendorff (CTC ROAS-vs-incremental-ROAS divergence)
substrate_layers_required: [icp, positioning, competitive, voc]
patterns_grounded: [channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution, creative-fatigue-window]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-diagnostic, missing-ltv-cac-target
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
  - clients/{client}/04-competitive.md
---

# ad-spend-allocate

## Purpose

Take a budget, the recent diagnostic outputs from `ad-diagnose`, and the LTV / CAC targets, and produce an allocation across channels and cohorts. The output is not a strategy document; it is a set of measurement contracts that open goals in the substrate ledger. Every channel allocation has a predicted ROAS, a window, a resolution date, and a kill criterion. Allocations that cannot be expressed as a falsifiable goal do not get budget.

The skill enforces three rules from the patterns:
1. **Channel-arbitrage-window**: hold a fraction of budget for exploration; default 70/20/10 (proven / scaling / exploration).
2. **Intent-vs-interest-targeting**: search ads measured on intent KPIs, paid social measured on interest / demand-gen KPIs.
3. **Incrementality-not-attribution**: any channel above 5% of total budget triggers a quarterly geo-holdout requirement (logged in the routine).

## Inputs

- `--client <client>` (required)
- `--budget <usd>` (required) total quarterly paid-ads budget.
- `--ltv <usd>` (required) target customer LTV.
- `--target-ltv-cac <ratio>` (optional, default `3.0`) target LTV:CAC ratio.
- `--diagnostics <dir>` (optional, default `clients/<client>/ads/diagnostics/`) where to read recent diagnostic outputs.
- `--lookback <days>` (optional, default `60`) how far back to read diagnostics.
- `--policy <70-20-10|60-30-10|90-10-0|custom>` (optional, default `70-20-10`) proven / scaling / exploration split.
- `--exploration-channel <slug>` (optional) which channel gets the exploration slice. If absent, leaves it unallocated and emits a recommendation.
- `--quarter <YYYY-Q[1-4]>` (required) the quarter the allocation covers.
- `--out <dir>` (optional, default `clients/<client>/ads/allocations/`)

## Substrate reads

- `clients/<client>/01-position.md` for the canonical positioning (channel-fit must respect it).
- `clients/<client>/02-icp.md` for ICP signals (channel-fit must reach the right cohorts).
- `clients/<client>/04-competitive.md` for competitive ad-spend signals (informs exploration channel choice).
- `clients/<client>/ads/diagnostics/<channel>-<recent>.md` for per-channel CAC, ROAS, fatigue counts.
- `goals/ledger.md` for the active goals this allocation slot ladders to.

## Output contract

Writes two files:

### 1. Allocation summary
At `clients/<client>/ads/allocations/<quarter>-<YYYY-MM-DD>.md`:

```yaml
---
allocation_id: <client>-ads-allocation-<quarter>-<YYYY-MM-DD>
client: <client>
quarter: <quarter>
budget_total_usd: <integer>
target_ltv_usd: <integer>
target_ltv_cac_ratio: <float>
target_max_cac_usd: <integer>  # = ltv / ltv_cac_ratio
policy: <70-20-10|...>
substrate_layers_read: [icp, positioning, competitive, voc]
patterns_applied: [channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution, creative-fatigue-window]
contradictions_resolved: [no-decision-vs-named-competitor]
---
```

Body sections:
1. **Per-channel allocation table** with predicted ROAS, predicted CAC, predicted volume, window, resolution date.
2. **Proven / scaling / exploration breakdown** with rationale for which channels sit where.
3. **Intent vs interest split** which channels are buying which kind of demand.
4. **Incrementality plan** which channels above 5% spend share require a quarterly geo holdout.
5. **Open questions and risks** what we don't know that could invalidate the allocation.
6. **Rollback / kill criteria** for the quarter.

### 2. Measurement contracts (one per channel allocation)
At `goals/measurement-contracts/<client>-<channel>-<quarter>.md`. Each contract is structured as a substrate goal:

```yaml
---
goal_id: <client>-paid-<channel>-<quarter>
client: <client>
opened_at: <YYYY-MM-DD>
status: proposed
hypothesis: |
  Allocation of <usd> to <channel> over <quarter> produces a CAC at or below
  <target_max_cac_usd> for cohort <cohort>, with predicted ROAS <roas> against
  the <ltv_cac_ratio> target. Citation: clients/<client>/ads/allocations/<...>.md.
predicted_outcome: |
  Channel CAC <= <target_max_cac_usd> within <window> for <cohort>.
revenue_lever: |
  lever_type: acquisition-CPL
  annual_revenue_impact_usd: <integer>
  calculation: |
    <usd budget> -> <predicted conversions @ predicted CAC> -> <conv * ltv> annual revenue.
    Inputs: budget=<usd>, predicted_cac=<usd>, ltv=<usd> (cited).
measurement_design: |
  Source: <Google Ads API | Meta Marketing API | LinkedIn Campaign Manager API | platform-export>.
  Method: total spend / converted leads in <quarter>; conversion definition <event-name>.
  Cohort: <cohort> from clients/<client>/02-icp.md.
  Ambiguous case: if the channel is paused mid-quarter for any reason other than
    'CAC above kill threshold,' resolve as AMBIGUOUS and re-allocate.
resolution_date: <quarter-end>
predicted_p_threshold_met: <float, default 0.55>
kill_criterion: <CAC > 1.5x target_max_cac_usd for 14 consecutive days>
substrate_layers_cited: [icp, positioning, competitive]
patterns_applied: [channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution]
---
```

The skill prints a summary to stderr and the path to the allocation summary to stdout.

## Quality criteria

- Every channel allocation has a predicted CAC, predicted volume, and resolution date.
- Sum of allocations equals the total budget within ±2%.
- Every channel above 5% spend share has an incrementality test scheduled in the routine.
- The exploration slice is named (channel + rationale) or marked unallocated.
- Each measurement contract is a complete goal candidate (ready for `open-goal`).

## What this skill does NOT do

- Does not pull historical data from ad platforms; reads from `ad-diagnose` outputs.
- Does not change anything in the platforms.
- Does not calibrate the LTV; the operator passes `--ltv` and is responsible for the source.
- Does not pick the proven / scaling / exploration policy; the operator passes `--policy`.
- Does not run the geo holdouts; that is `ad-incrementality-test`.

## Refusal patterns

- Missing diagnostics directory or no recent diagnostic files returns `INPUT-GAP — missing-diagnostic`.
- Missing `--ltv` returns `INPUT-GAP — missing-ltv`.
- Missing canonical positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Predicted CAC for any channel exceeds `target_max_cac_usd * 2` and the channel is in the proven slice returns `ALLOCATION-INVALID — proven-channel-above-2x-target`. Move to scaling or exploration with a smaller share.
- Total allocations do not equal budget within ±2% returns `ALLOCATION-INVALID — sum-mismatch`.

## See also

- `ad-diagnose` — produces the per-channel CAC and conv-value the allocation reads.
- `open-goal` — the next step after this skill (the measurement contract becomes a goal).
- `ad-incrementality-test` — runs the geo holdout for any channel above 5%.
- `routines/ad-allocation-routine.md` — quarterly cadence for this skill.
