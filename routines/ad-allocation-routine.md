---
title: ad allocation routine
status: active
last_updated: 2026-05-08
cadence: quarterly
skill_chain: [ad-diagnose, ad-spend-allocate, ad-incrementality-test, open-goal, score-goal]
patterns_grounded: [channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution, creative-fatigue-window]
---

# Ad allocation routine

A quarterly review that decides where paid-ads budget goes for the next quarter. The routine binds the per-channel diagnostic data from `ad-diagnose`, the channel-arbitrage and incrementality patterns, and the substrate calibration ledger into one decision artifact. Every channel allocation becomes a falsifiable goal with a measurement contract; the goal resolves at quarter-end and updates the operator's calibration history.

The default policy is the 70 / 20 / 10 split from `pat_channel-arbitrage-window`: 70 percent on proven channels, 20 percent on a maturing channel being scaled, 10 percent on exploration of a new surface. The split is overridable; the rationale is what the routine logs.

---

## Stage 1, Pre-quarter audit

**Cadence**: two weeks before the start of the next quarter.

**Trigger**: paid-marketing lead schedules the audit. Default cadence is mid-March (for Q2 planning), mid-June (for Q3), mid-September (for Q4), mid-December (for Q1 of next year).

**Run** for each active channel:

```bash
substrate ad-diagnose --client <client> \
  --export clients/<client>/ads/exports/<channel>-<quarter-summary>.csv \
  --channel <channel>
```

**What it does**: produces a per-channel diagnostic for the closing quarter. Numbers used downstream: `total_spend_usd`, `observed_cac_usd`, `waste_flag_count`, `fatigue_flag_count`, `positioning_drift_flag_count`. The channel-fit note (intent vs interest) is read into the allocation rationale.

**Output**: `clients/<client>/ads/diagnostics/<channel>-<YYYY-MM-DD>.md` per active channel.

---

## Stage 2, LTV / CAC reconciliation

**Cadence**: same window as Stage 1.

**Trigger**: paid-marketing lead and finance reconcile the LTV input. The substrate goal-router and ad-spend-allocate accept `--ltv` as an operator parameter; this stage is the place to update it before the allocation runs.

**Inputs**:
- Cohort-level LTV from the source-of-truth analytics platform or warehouse (Stripe MRR / ARR cohort report, HubSpot deal value by-cohort, or the equivalent).
- Target LTV / CAC ratio. Default 3.0; operator may override if the business is in a CAC-payback-shortening phase or a margin-pressure phase.

**Output**: `clients/<client>/ads/config/ltv.yaml` and `clients/<client>/ads/config/target-cac.yaml`. These are read by `ad-spend-allocate` and `ad-diagnose` automatically.

**Operator note**: LTV that drifts more than 25 percent quarter-over-quarter without a cohort-shift explanation should trigger a separate retention investigation. Allocation against an LTV that is silently rising is over-allocating; against an LTV that is silently falling is over-spending.

---

## Stage 3, Allocate

**Cadence**: one week before the start of the next quarter.

**Run**:

```bash
substrate ad-spend-allocate --client <client> \
  --budget <usd> --ltv <usd> \
  --target-ltv-cac 3.0 \
  --policy 70-20-10 \
  --quarter <YYYY-Q[1-4]>
```

**What it does**:

1. Reads recent `ad-diagnose` outputs across channels.
2. Applies the per-channel CAC / ROAS / waste-flag count to score channels into `proven`, `scaling`, or `exploration` slices.
3. Allocates the budget across slices per the named policy.
4. Emits one **measurement contract** per channel allocation. Each contract carries:
   - `predicted_outcome` (e.g., "Channel CAC <= $X within Q3 for cohort Y").
   - `kill_criterion` (default: CAC > 1.5x target_max_cac for 14 consecutive days).
   - `predicted_p_threshold_met` (operator-set or default by slice: 0.65 proven, 0.50 scaling, 0.35 exploration).
   - `revenue_lever` (the dollar projection if the goal hits, calibrated against the operator's prior accuracy on demand-gen goals).

**Output**: `clients/<client>/ads/allocations/<quarter>-<YYYY-MM-DD>.md` plus one measurement contract per channel under `goals/measurement-contracts/<client>-<channel>-<quarter>.md`.

**Refusal triggers**: missing diagnostic data, missing `--ltv`, missing canonical positioning, predicted CAC for any proven-slice channel exceeding 2x target_max_cac. Fix the substrate gap or move the channel to scaling / exploration with a smaller share.

---

## Stage 4, Open the goals

**Cadence**: same day as Stage 3.

**Trigger**: the operator reviews each measurement contract and decides which to promote from `proposed` to `open` on the goal ledger.

**Run** per accepted contract:

```bash
substrate open-goal goals/measurement-contracts/<client>-<channel>-<quarter>.md
```

**What it does**: validates the contract against the linter (`measurement_design` non-empty, `predicted_outcome` follows the metric / direction / threshold pattern, `revenue_lever` populated, `resolution_date` in the future), then writes a row to `goals/ledger.md`.

**Output**: a goal row per accepted contract, ready to be scored at quarter-end.

**Operator note**: the operator may choose not to open a contract if the channel is now declared exploration (volatile predicted CAC) and the operator wants to run it un-tracked. The cost is no calibration data on that channel for the quarter; the value is faster experimentation. Default: open every contract unless there is a specific reason not to.

---

## Stage 5, Schedule incrementality tests

**Cadence**: within the first two weeks of the quarter, for any channel above 5 percent of total budget.

**Trigger**: the channel-share number from Stage 3's allocation summary. The pattern `pat_incrementality-not-attribution` names the 5-percent threshold as the practical floor for incrementality testing.

**Run** per qualifying channel:

```bash
substrate ad-incrementality-test --client <client> \
  --channel <channel> --mode <geo-holdout|psa-control> \
  --baseline-conversions <int> --baseline-cac <usd> \
  --quarter <YYYY-Q[1-4]> \
  --mde-pct 15.0
```

**What it does**: writes a test design (matched-market selection rules for geo-holdout, platform-managed selection for psa-control), computes the test window from baseline + MDE + alpha + power + treatment-share, and emits a measurement contract for the incremental-lift goal.

**Output**: `clients/<client>/ads/incrementality/<channel>-<mode>-<YYYY-MM-DD>.md` plus a measurement contract at `goals/measurement-contracts/<client>-incr-<channel>-<quarter>.md`.

**Operator note**: not every quarter needs an incrementality test on every channel above 5 percent. The operator may stagger tests across quarters (Meta in Q2, Google Search in Q3) so the team is not running 4 holdouts simultaneously. The minimum bar is one incrementality test per quarter on the highest-spend channel.

---

## Stage 6, Mid-quarter check-in

**Cadence**: 6 weeks into the quarter.

**Trigger**: the kill-criterion logic on each open allocation goal.

**What happens**: the operator pulls a partial diagnostic on each allocation:

```bash
substrate ad-diagnose --client <client> --export <recent-export>.csv --channel <channel>
```

If the kill-criterion has fired (CAC above 1.5x target for 14 consecutive days), the operator either pauses the channel or files an `abandonment_reason` on the goal and re-runs `ad-spend-allocate` with the remaining budget across the remaining quarters.

If the kill-criterion has not fired but performance is materially below the prediction, the operator does not pivot mid-flight (per `PRINCIPLES.md` rule on goals). The goal stays open; the result resolves honestly at quarter-end.

---

## Stage 7, Quarter-end resolution

**Cadence**: within one week of quarter-end.

**Run** per open allocation goal:

```bash
substrate score-goal --goal-id <client>-paid-<channel>-<quarter>
```

**What it does**: pulls the actual quarterly CAC from the source-of-truth analytics, compares to the predicted threshold, computes the resolution verdict (YES / NO / AMBIGUOUS), and computes the Brier score against the operator's `predicted_p_threshold_met`.

**Output**: updates to `goals/ledger.md` plus an entry on the operator's per-(operator, taste-type=demand-gen) Brier history.

**Substrate update**: per `PRINCIPLES.md` rule on the close-loop, the resolution feeds back into the substrate. If a channel's predicted CAC was off by more than 30 percent in the same direction across two consecutive quarters, the prior on that channel for the next allocation is calibrated against the resolved data, not the operator's gut. This is the calibration loop.

---

## Stage 8, Plan next quarter

**Cadence**: same week as Stage 7.

**Trigger**: completion of all goal resolutions for the current quarter.

**What happens**: the operator returns to Stage 1 with the resolved data in hand. Channel slices may shift (a `scaling` channel that resolved YES may move to `proven`; an `exploration` channel that resolved NO may exit the program). The 70 / 20 / 10 default may move to 80 / 15 / 5 if exploration has not produced anything in 4 quarters, or to 60 / 25 / 15 if a channel arbitrage window has just opened (per `pat_channel-arbitrage-window`'s saturation indicators).

The next quarter's allocation is the input. The loop closes.

---

## Pattern grounding

This routine operationalises:

- `pat_channel-arbitrage-window` (4 operator citations: Chen, Balfour, Rachitsky, Jorgensen). The 70 / 20 / 10 default split, the saturation indicators (CPM trajectory, share-of-voice change, competitor entry), and the quarterly cadence are direct implementations of the pattern.
- `pat_intent-vs-interest-targeting` (3 operator citations: Aslam, Kaushik, Fishkin). The slice classification of search-vs-social, the per-channel KPI choice in measurement contracts, and the separate budget treatment for search and social all come from this pattern.
- `pat_incrementality-not-attribution` (4 operator citations: Kaushik, Wenograd, Orendorff / CTC, Balfour / Reforge). Stage 5's 5-percent threshold and the structure of the incrementality test are direct implementations.
- `pat_creative-fatigue-window` (4 operator citations: Wenograd, Foxwell, Burns, Orendorff). Read indirectly: the per-channel CAC is partly a function of fatigue cadence, which is governed by `routines/ad-fatigue-routine.md`.

---

## Common failure modes

1. **Allocation against last-touch attribution**. The platform-reported numbers from Stage 1 overstate paid-social and understate brand / SEO contributions. The fix is Stage 5: run incrementality on any channel above 5 percent. Without it, allocation decisions calibrate against a known-biased number.
2. **Skipping the LTV reconciliation in Stage 2**. Operators routinely allocate against last quarter's LTV when the cohort has shifted; over-spending or under-spending follows. The fix is finance involvement in the routine, not a more aggressive ratio.
3. **Filling exploration with a "safe" channel**. Exploration is exploration: it is supposed to lose money in expectation, in exchange for option value when a saturating channel forces a move. Filling the 10 percent slice with a watered-down version of a proven channel defeats the purpose.
4. **Pivoting goals mid-flight**. `PRINCIPLES.md` rule: pivots are not goals; they are open loops. If the kill-criterion has fired, resolve as MISS or NULL and open a new goal. Do not adjust the threshold to flatter the result.
5. **Skipping the Brier scoring on resolution**. Without the calibration data, the next allocation runs on memory, not on resolved track record. The fix is treating Stage 7 as non-optional.

---

## What this routine is not

- Not a creative refresh routine. That is `routines/ad-fatigue-routine.md` (weekly).
- Not a board / exec slide gate. That is `skills/ad-attribution-honest/` (composed into `pre-publish-check` for any asset that cites channel performance).
- Not a campaign management tool. The platforms execute; this routine produces the artefacts the operator decides on.
- Not a forecasting model. The measurement contracts hold falsifiable predictions; the operator's calibration on demand-gen taste is what the system learns from over time.

---

## See also

- `skills/ad-spend-allocate/SKILL.md`
- `skills/ad-diagnose/SKILL.md`
- `skills/ad-incrementality-test/SKILL.md`
- `skills/ad-attribution-honest/SKILL.md`
- `skills/open-goal/SKILL.md`
- `skills/score-goal/SKILL.md`
- `routines/ad-fatigue-routine.md`
- `knowledge/patterns/channel-arbitrage-window.md`
- `knowledge/patterns/intent-vs-interest-targeting.md`
- `knowledge/patterns/incrementality-not-attribution.md`
- `goals/SCHEMA.md`
