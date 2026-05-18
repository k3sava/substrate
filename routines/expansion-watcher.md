---
title: weekly expansion-trigger scan
status: active
last_updated: 2026-05-08
patterns_grounded: [behavioral-expansion-signals-beat-tenure, retention-cohort-curves-over-blended-rates]
schedule: weekly, Tuesday morning
---

# Weekly expansion-trigger scan

The expansion surface is where retention cashes out. Per `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md`, account tenure is the wrong primitive for upsell timing; behavior is the primitive. The right cadence is weekly, not quarterly: a behavior threshold can cross between Monday and Wednesday, and a tenure-based motion will miss it.

This routine runs weekly, produces a freshly scored trigger queue, and hands it off to CS / AE workflow tools.

## Cadence contract

Every Tuesday morning. The events export from the prior week is fresh (most analytics platforms close the week's data by Monday end-of-day).

## Loop steps

### 1. Pull the events export (rolling 30 days)

The exporter writes a 30-day rolling window export to `clients/<client>/events/exports/rolling-30d.csv`. The lookback in `expansion-trigger-detect` defaults to 30 days, matching this export.

If the export is missing or older than 7 days, the routine refuses to run. The behavioral-signal lookback is meaningless if the data is stale.

### 2. Run `expansion-trigger-detect`

```
substrate expansion-trigger-detect --client <client> --events clients/<client>/events/exports/rolling-30d.csv
```

Produces:
- `clients/<client>/retention/expansion-triggers-<date>.md`, the operator review document.
- `clients/<client>/retention/expansion-triggers-<date>.csv`, the row table for CS / AE tools.
- `clients/<client>/retention/expansion-triggers-<date>.json`, structured signals for downstream skills.

### 3. Hand off the queue

The CSV is the hand-off artifact. CS / AE workflow tools (HubSpot, Salesforce, Outreach, Apollo) ingest the rows. The bands map to motions:

- **burning** (composite >= 80, threshold-proximity in evidence): AE expansion conversation within 24-48 hours.
- **hot** (60-80): CSM check-in within 7 days; surface tier comparison + outcomes proof.
- **warm** (30-60): in-product nudge for adjacent value event; CSM low-touch monitoring.
- **cold** (<30): no action; revisit next routine.

Hand-off is operator-driven. The skill produces a queue; humans pick which to action.

### 4. Resolve prior week's burning + hot triggers

Open last week's `expansion-triggers-*.json`. For each account in the burning + hot bands, look up the outcome in CRM:
- Did an expansion conversation happen?
- Did the account upgrade or add seats in the past 7 days?
- Was the trigger correctly surfaced (no false positives)?

Record outcomes in `goals/ledger.md` if the trigger was tied to an open goal. Brier-score the prediction (predicted hot-band conversion vs measured).

### 5. Drift watch

Compare this week's band counts to the prior 4 weeks:
- If the burning band shrunk versus baseline, the upsell window may be closing (tenure-confounded?). Investigate.
- If the burning band grew versus baseline, expansion intent is rising. Coordinate with sales capacity.
- If the cold-band share grew, retention may be decaying upstream. Refer to `routines/retention-monthly.md`.

## Failure modes the routine prevents

- **Tenure-based expansion.** Per the load-bearing pattern, tenure-based playbooks miss high-intent buyers ready at week 3 and waste cycles on accounts that hit day 90 having never adopted. Weekly behavioral scan catches both.
- **Wasted AE cycles.** The routine surfaces the *highest-signal* accounts; AE motion is gated on signal, not on a quota of touches.
- **Stale signal.** Behavior compounds fast. A weekly cadence catches it; a quarterly cadence loses it.
- **Cold-band action.** Cold-band accounts get no action; saving CS time for hot/burning.

## Substrate reads + writes

- Reads: `clients/<client>/events/exports/rolling-30d.csv`, `clients/<client>/icp/`, `clients/<client>/product-knowledge/`.
- Writes: `clients/<client>/retention/expansion-triggers-*.md|csv|json`.

## Quality criteria

- Refuses to run on a stale export (>7 days old).
- Refuses to score accounts younger than `--min-tenure-days` (default: 7).
- Tenure is a tie-breaker only; the score does not contain a tenure component.

## See also

- `skills/expansion-trigger-detect/SKILL.md`
- `routines/retention-monthly.md` (monthly companion)
- `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md`
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`
