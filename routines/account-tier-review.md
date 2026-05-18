---
title: account-tier review routine
status: active
last_updated: 2026-05-08
schedule: quarterly — first Monday of each quarter
owner: ABM lead + RevOps
---

# account-tier review routine

A quarterly reprioritization of the target-account list. Tier assignments drift as accounts engage, triggers fire, intent shifts, and ICP evolves. The review keeps the tier list honest.

## Cadence

- Once per quarter. First Monday of the quarter, before the SDR / AE quarter-planning offsite.

## Steps

1. **Refresh ICP** — confirm `clients/<client>/icp/00-INDEX.md` is current. If material change since last quarter, run `icp-cut` first.
2. **Re-run prioritization** — `substrate abm-account-prioritize --client <client> --accounts <new-or-existing>.csv --category-maturity <maturity>`.
3. **Compare to previous tier** — diff the new ranked CSV against the previous quarter's ranked CSV.
   - Promotions (2 → 1B, 1B → 1A): accounts whose intent + trigger + engagement moved up. AE picks up.
   - Demotions (1A → 1B, 1B → 2, any → defer): accounts that didn't engage in 90 days. Drop to nurture.
   - New entries: accounts added to the watchlist mid-quarter (acquisitions, exec hires, market entries).
   - Departures: accounts removed (acquired by anti-ICP parent, vertical pivot, no longer in scope).
4. **Score accuracy of last quarter's tier** — for accounts that converted: were they tier-1A predicted? For accounts that bounced: were they tier-2 or below? Track the prediction-accuracy by tier as a calibration metric.
5. **Decide intensity** — for the new tier 1A list, run `account-pursuit-rhythm --tier 1A --horizon 90` to refresh the cadence contract.
6. **Hand off** — share the new ranked CSV + tier diffs with SDR manager + AE leads. Quarter-planning offsite uses the ranked list as input.

## Quality criteria

- The fraction of accounts in tier 1A stays ≤15% (per `abm-account-prioritize` cap). If the ICP cut produces more, tighten the ICP.
- Every promotion has a documented reason (intent, trigger, behavioral signal).
- Every demotion has a documented reason (no engagement, anti-ICP shift, etc.).
- The prediction-accuracy score is logged into the calibration ledger (per PRINCIPLES.md rule 6).
- The previous quarter's ranked CSV is archived (not overwritten) at `clients/<client>/sales/account-rankings/_archive/`.

## Anti-patterns

- Promoting accounts to 1A based on AE preference rather than scoring (this is "favorite-account drift" and erodes the calibration signal).
- Refusing to demote accounts with sunk-cost relationships (the SDR has been "working" the account for a year; demote and let it nurture).
- Running the tier review without first refreshing the ICP (tier ranks against ICP; a stale ICP produces stale ranks).
- Mid-quarter tier changes outside this routine (the routine is the gate; mid-quarter changes are signal, not action — log them and apply at the next review).

## Composes with

- `skills/icp-cut/` — refresh the ICP layer before re-ranking.
- `skills/abm-account-prioritize/` — produces the new ranked list.
- `skills/account-pursuit-rhythm/` — refreshes cadence per tier.
- `skills/intent-data-route/` — quarterly action-distribution audit.
- `routines/sales-trigger-routine.md` — the daily watcher whose 90-day output feeds this review.

## Patterns grounded

- `knowledge/patterns/account-not-lead-as-unit.md` — the account remains the unit through the review.
- `knowledge/patterns/rhythm-beats-blast.md` — the new cadence is rhythm, not burst.

## Calibration signal

Tier prediction accuracy is the recurring calibration metric this routine logs:
- `tier_1a_conversion_rate` over the previous 90 days
- `tier_1a_meeting_rate` over the previous 90 days
- `tier_2_disqualify_accuracy` (did the deferred accounts actually fail to engage?)

Sustained accuracy across 3 quarters earns the ABM lead authority on the tier-cap and weighting choices (per PRINCIPLES.md rule 6: authority follows accuracy).

## Failure modes to watch

- **Tier inflation drift**: 1A grows to 25% of accounts over 4 quarters because the team likes the "1A" label. Tighten the cap and re-train.
- **Frozen tier list**: 0 promotions and 0 demotions across a full quarter. Either the world stopped (unlikely), or the routine isn't actually being run.
- **List churn without rationale**: large number of new entries / departures with no documented source. ABM lead must own the source-of-truth for the watchlist.
