---
name: churn-signal-from-support
description: Extract churn leading indicators from a support tickets export. Computes per-account ticket-volume spikes, response-time elevation, sentiment-proxy keyword density (refund/cancel/disappointed/regret), unresolved-escalation count, and silence-after-engagement. Outputs a flagged-account list with severity bands and feeds churn-diagnose. Reads tickets export plus optional accounts CSV. Refuses without ICP layer.
version: 0.1
amplifies: head of CS, head of support, RevOps, head of lifecycle, account-management leads
masters: Lincoln Murphy (every account interaction is a leading indicator), Nick Mehta (account-health-score architecture), Patrick Campbell (silence-after-engagement finding; volume-elevation finding), Tomasz Tunguz (read the support corpus before training a model)
substrate_layers_required: [icp, voc, brand-voice]
patterns_grounded: [support-as-churn-leading-indicator, churn-prediction-vs-churn-diagnosis]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-tickets, missing-icp
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
---

# churn-signal-from-support

## Purpose

Read a support tickets export and surface the leading indicators of churn that the support data carries. Per the `support-as-churn-leading-indicator` pattern, support volume and sentiment lead churn by 30 to 90 days; this skill operationalises the pattern as a structured weekly read with five concrete features.

The output is a per-account "support churn score" with severity bands, plus a flagged-account list ranked by composite score. The list feeds `churn-diagnose` (which conditions on this list when computing the cohort-level driver split) and the CS workflow (which prioritises the burning-band accounts for proactive outreach).

The skill diagnoses; it does not predict at the model level. Per `churn-prediction-vs-churn-diagnosis`, prediction is downstream of diagnosis. This skill produces the structured read that diagnosis depends on.

## Inputs

- `--client <client>` (required)
- `--tickets <path>` (required), tickets CSV (canonical shape: `templates/support-tickets-example.csv`).
- `--accounts <path>` (optional), accounts CSV with columns `account_id`, `arr`, `plan`, `signup_date`, optional `icp_fit_score`, `tenure_days`, `last_login_date`. When present the output stratifies and weights by ARR.
- `--current-window-days <int>` (default: 30, the recent window to compare against the trailing baseline).
- `--baseline-window-days <int>` (default: 90, the trailing baseline window).
- `--min-tickets-for-account <int>` (default: 2, the minimum tickets an account must have in either window to score; below this the account is too quiet to score on volume).
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/icp/icp.md`, drives the ICP-fit weighting (used when accounts CSV is present).
- `clients/{client}/voc/voc.md`, validates that sentiment-proxy keywords match documented customer language.

## Tickets CSV contract

Required columns: `ticket_id`, `account_id`, `opened_at`, `category`, `subject`, `body`. Optional but valued: `resolution_time_hours`, `csat`, `priority`, `first_response_minutes`, `escalated`, `resolved`. The `account_id` column is required (not optional, despite being optional in `ticket-cluster-analysis`); the per-account roll-up cannot run without it.

## Process

1. **Preflight**. Verify substrate layers, the tickets path, and the required columns. Refuse with `missing-icp`, `missing-tickets`, `schema-mismatch`, `account-id-missing` as appropriate.
2. **Time window split**. Bucket each ticket into current (within `--current-window-days` of latest ticket in the corpus) or baseline (within `--baseline-window-days` before the current window). Tickets older than baseline are dropped from the read.
3. **Per-account aggregation**. For each account, compute the five leading-indicator features:
   - **volume_spike**: current-window ticket count vs trailing-baseline ticket count, normalized to per-day rates. A 2x or greater spike fires.
   - **response_time_elevation**: median resolution-time-hours in current window vs baseline. A 50% or greater rise fires.
   - **sentiment_proxy_density**: density of refund / cancel / disappointed / regret / "moving back" / "considering switching" / "unacceptable" keywords across all tickets from the account. A density above 0.20 (>20% of tickets contain a sentiment-proxy keyword) fires.
   - **unresolved_escalation_count**: count of tickets where `escalated == true` AND `resolved == false`, in the current window.
   - **silence_after_engagement**: previously-engaged accounts (>= 3 tickets in baseline window) that have zero tickets in current window. A binary signal.
4. **Severity band**. Compose a composite score per account (weighted sum of the five features, normalised). Bands:
   - `burning`: 3+ features fire OR composite ≥ 0.70.
   - `hot`: 2 features fire OR composite ≥ 0.50.
   - `warm`: 1 feature fires OR composite ≥ 0.30.
   - `cool`: composite < 0.30.
5. **Optional ARR weighting**. When accounts CSV is present, weight the burning and hot bands by ARR; the highest-ARR burning account is the priority outreach.
6. **Output**. Write three artifacts: markdown report, JSON sidecar, flagged-accounts CSV.

## Output contract

Three artifacts under `clients/{client}/support/`:

1. `churn-signal-from-support-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Window summary (current window dates, baseline window dates, accounts seen).
   - Severity band counts (burning / hot / warm / cool).
   - Per-feature trigger counts (which leading indicator is firing on which population share).
   - Top 20 flagged accounts (account_id, ARR if present, severity, feature triggers, sample ticket excerpts in customer language).
   - Anti-pattern note (the false-positive rate is non-zero; the operator review pass is required, not optional).
   - Substrate citations.
2. `churn-signal-from-support-{YYYY-MM-DD}.json`, structured per-account scores for downstream skills.
3. `churn-signal-from-support-flagged-{YYYY-MM-DD}.csv`, flagged-account queue ranked by composite × ARR.

## Quality criteria

- Refuses without ICP (the burning-band weighting depends on it for ARR scoring even when accounts CSV is absent).
- Refuses without `account_id` column in the tickets CSV; the per-account roll-up cannot run.
- Records the window dates explicitly. The same data run on a different window produces different signals; the window is part of the artifact.
- Sample ticket excerpts in the report quote ticket bodies verbatim. The skill never paraphrases.
- Anti-pattern note is included verbatim in every output: signals are noisy at the individual-account level, the output is a *triage queue*, not an alert system, and the operator review is required.
- The signal is one-sided: a burning band does not equal "this account will churn." Per the pattern, the signal leads churn by 30-90 days, with non-trivial false-positive rate; conservative thresholding plus operator review is the discipline.

## What this skill does NOT do

- Does not predict churn at the model level. That is downstream; per the pattern, diagnosis-and-signal-extraction precedes prediction.
- Does not write save sequences. That is `win-back-sequence`, which can read this output to prioritise.
- Does not classify ICP fit. The ICP layer must be present; the skill reads it but does not infer it.
- Does not deduplicate tickets across accounts (e.g., a known issue affecting many accounts). When a sudden volume spike is correlated across many accounts, the operator must investigate whether the spike is a product issue (correlated cause) vs an aggregation of independent at-risk accounts.

## Refusal patterns

- `substrate-gap`: missing ICP or VoC layer.
- `missing-icp`: ICP layer absent (drives the band weighting).
- `missing-tickets`: tickets CSV not present.
- `schema-mismatch`: required columns missing, including `account_id`.
- `window-too-short`: combined corpus does not span at least `current_window + baseline_window` days. The skill cannot compute the spike read without that span.

## Composes with

- Reads from: tickets CSV, accounts CSV (optional), substrate layers.
- Writes for: `churn-diagnose` (which can read the flagged-account JSON to weight cohort drivers), `win-back-sequence` (which can prioritise burning accounts for save calls), `csat-loop-design` (which can suppress relational surveys for burning accounts to avoid contamination).
- Triggered by: weekly support churn watcher routine, monthly retention review, ARR loss escalation.

## Calibration

Tracked under taste-types `retention`. Brier signal: burning-band accounts followed at 90 days; the operator records whether the prediction was right. Honest losses count.

## See also

- `knowledge/patterns/support-as-churn-leading-indicator.md`
- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`
- `templates/support-tickets-example.csv`
- `skills/churn-diagnose/SKILL.md`
- `skills/win-back-sequence/SKILL.md`
- `routines/support-churn-watcher.md`
