---
title: ad fatigue routine
status: active
last_updated: 2026-05-08
cadence: weekly
skill_chain: [ad-diagnose, ad-fatigue-monitor, ad-creative-design]
patterns_grounded: [creative-fatigue-window, intent-vs-interest-targeting]
---

# Ad fatigue routine

A weekly cycle that catches creative decay before it bends CAC. The routine consumes ad-account exports, scores per-channel fatigue against the thresholds in `pat_creative-fatigue-window`, surfaces refresh candidates, and primes briefs for the operator to act on.

The pattern in plain terms: paid-social creatives lose 30 to 50 percent of their efficiency between weeks 3 and 5 against a single audience. Refresh cadence is the lever, not bidding. A program without a refresh cadence is allocating budget to fatiguing assets and wondering why CAC keeps drifting up. This routine is the operating loop that closes that gap.

The work is operator-fired (CSV exports come from the platform, not from automation) and runs every Monday at the start of the marketing standup.

---

## Stage 1, Diagnose

**Cadence**: every Monday, before standup.

**Trigger**: paid-marketing lead pulls a fresh CSV export per active channel from the platform (Google Ads → Reports → Custom; Meta Ads Manager → Export; LinkedIn Campaign Manager → Export). The export covers the last 30 days at the daily-grain level for each channel.

**Required headers** (per `ad-diagnose` SKILL.md):

```
campaign, impressions, clicks, spend, conversions, conv_value
```

Recommended optional headers: `ad_set`, `creative_id`, `date`, `frequency`, `cpm`, `match_type`.

**Run**:

```bash
substrate ad-diagnose --client <client> \
  --export clients/<client>/ads/exports/<channel>-<YYYY-MM>.csv \
  --channel <channel> \
  --target-cac <usd> --ltv <usd>
```

**Output**: `clients/<client>/ads/diagnostics/<channel>-<YYYY-MM-DD>.md` per channel.

**Refusal triggers**: missing `clients/<client>/01-position.md` (positioning), missing `clients/<client>/02-icp.md`, missing or empty CSV, CSV missing required headers. Operator fixes the substrate gap or the export, then re-runs.

---

## Stage 2, Monitor

**Cadence**: every Monday, after Stage 1 completes for all active channels.

**Run**:

```bash
substrate ad-fatigue-monitor --client <client> --enqueue-briefs
```

**What it does**: reads the last `--lookback-weeks` (default 4) of diagnostic outputs across channels. Compares this week's fatigue flags to prior weeks. Surfaces three categories:

- **New flags**: creatives that crossed a fatigue threshold this week.
- **Persistent flags**: creatives flagged in 2 or more consecutive weeks. Tagged "REFRESH OVERDUE."
- **Recovered creatives**: previously flagged, now back below thresholds. Useful as positive signal in the weekly review.

The monitor also names the per-channel cadence gap. If the weekly new-creative count for a channel is below the expected cadence (Meta = 2-4 per week, LinkedIn = 1-2 per week, etc.), the gap is flagged as a leading indicator of CAC drift 14-21 days out.

**Output**: `clients/<client>/ads/fatigue-flags/<YYYY-MM-DD>.md`. With `--enqueue-briefs`, also writes brief stubs to `clients/<client>/ads/briefs/_queue/`.

**Refusal triggers**: no diagnostic history (Stage 1 was not run), missing positioning. Fix and re-run.

---

## Stage 3, Brief

**Cadence**: every Monday, after Stage 2.

**Trigger**: persistent flags from Stage 2 plus any new creative-test slots the operator wants to open.

**Run** per persistent / overdue creative:

```bash
substrate ad-creative-design --client <client> \
  --channel <channel> --cohort <buyer-state-cohort> \
  --frame <status-quo|named-competitor> \
  --variants 4
```

**What it does**: emits a structured brief grounded in the canonical positioning, the chosen frame (status-quo as Position A from `no-decision-vs-named-competitor`, or a named-competitor battle card as Position B), and the buyer-state cohort. The brief includes channel-specific format constraints (RSA character limits for Google, primary-text caps for Meta, LinkedIn intro caps, etc.) and substrate citations for every load-bearing claim.

**Output**: `clients/<client>/ads/briefs/<channel>-<cohort>-<frame>-<YYYY-MM-DD>.md`.

**Refusal triggers**: missing canonical positioning, missing buyer-state cohort, named-competitor frame without a `--competitor` argument. Fix and re-run.

---

## Stage 4, Operator review and ship

**Cadence**: every Monday, in the standup.

**Trigger**: the brief queue from Stage 3.

**What happens**: paid-marketing lead and the copy / creative resource walk the brief queue, decide which briefs go into production this week, and assign each to a creator. This stage is human-judgement work; the briefs are inputs, not finished assets.

**Cadence target**: ship 2-4 new variants per week per active Meta campaign, 1-2 per week for LinkedIn, etc. Use the per-channel cadence note from Stage 2 to calibrate. Falling below the cadence target for three consecutive weeks is a separate signal (production gap) that may need a creative-resource conversation, not a creative-output conversation.

**Output**: shipped variants in the platform, plus updates to `clients/<client>/ads/exports/` by Stage 1 of the next cycle.

---

## Stage 5, Goal close-loop

**Cadence**: when a refreshed creative resolves against its prior baseline (typically 14-28 days post-ship).

**Trigger**: prior creative was a tracked goal (an entry on `goals/ledger.md`) with a refresh-prediction.

**Run**:

```bash
substrate score-goal --goal-id <goal-id>
```

The Brier score updates the operator's calibration on the `creative-production` taste type. Repeated wins on a hook pattern, channel, or cohort feed back into the brief queue priority for the next cycle.

---

## Pattern grounding

This routine operationalises:

- `knowledge/patterns/creative-fatigue-window.md` (4 operator citations: Wenograd, Foxwell, Burns, Orendorff). The fatigue thresholds, the cadence target, and the Stage 2 / Stage 3 chain follow the pattern's implication section directly.
- `knowledge/patterns/intent-vs-interest-targeting.md` (3 operator citations: Aslam, Kaushik, Fishkin). Stage 1's per-channel KPI selection, and the channel-specific thresholds in `ad-diagnose`, follow this pattern's distinction.

---

## Common failure modes

1. **Operator runs Stage 2 without Stage 1**. The monitor refuses (no diagnostic history). Fix: run `ad-diagnose` for each active channel first.
2. **Operator runs Stage 3 without a frame**. The brief defaults toward an unfocused variant. Fix: pass `--frame status-quo` or `--frame named-competitor` per the operator's read of where the pipeline is leaking (no-decision losses vs competitive losses).
3. **Cadence target missed but no flag fires**. The monitor names the production gap as a leading indicator; treat it as such, not as failure. The fix is creative-resource scope, not bidding.
4. **CTR decline above threshold but conversion-volume holding**. The fatigue threshold is a leading indicator; the conversion lag is normal. Brief the refresh anyway; do not wait for CAC to drift.

---

## What this routine is not

- Not an attribution audit. That is `ad-attribution-honest` (composes with `pre-publish-check` for any asset that cites channel performance).
- Not an allocation review. That is `routines/ad-allocation-routine.md` (quarterly).
- Not an incrementality test. That is `ad-incrementality-test`, scheduled per quarter for any channel above 5% of paid budget.

---

## See also

- `skills/ad-diagnose/SKILL.md`
- `skills/ad-fatigue-monitor/SKILL.md`
- `skills/ad-creative-design/SKILL.md`
- `routines/ad-allocation-routine.md`
- `knowledge/patterns/creative-fatigue-window.md`
- `knowledge/patterns/intent-vs-interest-targeting.md`
