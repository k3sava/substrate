---
title: monthly analytics refresh
status: active
last_updated: 2026-05-08
patterns_grounded: [event-taxonomy-as-product-knowledge, metric-tree-not-metric-stack, goalpost-discipline-vs-metric-drift, segment-of-one-vs-cohort-aggregate]
contradictions_aware: []
schedule: monthly, second Tuesday of month
---

# Monthly analytics refresh

The analytics surface is the spine every other surface reads from. Retention, paid-ads, email, ABM, dashboards, lift tests all consume CSVs landed by `analytics-pull` and metrics defined by `metric-tree-design`. If the spine is stale or drifted, every downstream skill operates on stale or drifted substrate. This routine is the cadence that keeps the spine honest.

The routine is a closed loop: pull last month's data from every declared source, audit the event taxonomy against what actually fired, validate the metric tree's leaves still bind to live events, log drift, and resolve last month's prediction calibrations.

## Cadence contract

Monthly, on the second Tuesday. The first Tuesday is reserved for retention review (see `routines/retention-monthly.md`); analytics-monthly-refresh runs the week after, so its outputs feed the *next* retention review. The previous calendar month is fully landable in source systems by then.

## Loop steps

### 1. Verify sources.yaml is fresh

Open `clients/<client>/analytics/sources.yaml`. Check `last_updated`. Each declared source has a `last_audited` field; if any source is over `freshness_window_days` stale, audit it manually first (the API may have changed; the project_id may have rotated) before continuing.

If sources.yaml is missing entirely, the loop refuses. Without sources.yaml, `analytics-pull` cannot run, and every downstream artifact is fabrication.

### 2. Run `analytics-pull` for last month

```
substrate analytics-pull --client <client> --month <YYYY-MM>
```

Pulls every declared source into `clients/<client>/analytics/<source>/<YYYY-MM>.csv` plus a manifest. Per source the manifest captures: row count, distinct ID count, ts range, mode (live / mock-fallback / mock-forced), API key presence, and taxonomy coverage percentage.

Read the manifest's `events_taxonomy.coverage_pct` per source. Coverage below 80% is a warning sign that the taxonomy has drifted from production; coverage above 95% is healthy. Both extremes feed step 3.

If a source falls into mock-fallback because the API key is missing, log the gap. The CSVs produced are realistic in shape but not real data; downstream skills that require live data should wait. The routine continues for sources that succeeded.

### 3. Run `event-taxonomy-audit` against the freshly-pulled stream

```
substrate event-taxonomy-audit --client <client> --month <YYYY-MM>
```

Reads `clients/<client>/events.yaml` and the per-source CSVs from step 2. Produces three artifacts under `clients/<client>/analytics/audits/`:

- `events-taxonomy-audit-<YYYY-MM-DD>.md`, the human audit
- `events-taxonomy-audit-<YYYY-MM-DD>.json`, structured findings
- `events-taxonomy-audit-<YYYY-MM-DD>-remediation.csv`, row-per-finding remediation

Read the coverage summary first. Overlap below 90% means drift is accelerating; overlap above 90% is healthy. Then read the five drift sections in order: declared-but-unfired (decommission candidates), fired-but-undeclared (declare-or-rename candidates), near-duplicate names (merge candidates), missing properties (instrumentation gaps), naming-convention violations (rename candidates).

The remediation list ranks findings by severity. The top 5-10 high-severity items go into the operator's queue for the week.

If remediation moves the taxonomy, re-edit `clients/<client>/events.yaml` (the audit does not edit the file; the operator owns the canonical taxonomy). Bump `last_updated`. Re-run the audit at the end of the month to confirm drift closed.

### 4. Validate `metric-tree.yaml` leaves still bind to live events

Open `clients/<client>/analytics/metric-tree.md` and `metric-tree.yaml`. For every leaf metric whose `source_system` is an event-store (amplitude / posthog / mixpanel / segment / ga4), confirm:

- The named event still fired in the most recent month's CSV.
- The named property still appears in the property column set.

If a leaf's underlying event has decayed (declared-but-unfired in step 3), the leaf is stale. Either re-instrument the event, switch the leaf to a live event, or demote the leaf out of the tree. A tree with stale leaves is worse than a tree with fewer leaves, because the dashboard reading the leaf reports a number that is not signal.

Re-run `metric-tree-design --update` if any leaf changed:

```
substrate metric-tree-design --client <client> --update
```

### 5. Run dashboard sanity check (optional weekly, mandatory monthly)

For each dashboard spec under `clients/<client>/analytics/dashboards/<id>.yaml`:

- Open the corresponding `clients/<client>/analytics/dashboards/<id>.md`.
- Walk the panel list. Each panel cites a metric-tree node ID. Confirm the node still exists in the updated metric tree.
- For panels with `drill_to`, confirm the drill target still resolves.

Panels whose metric-tree node disappeared get re-bound to a live node or the panel is removed. A dashboard with broken drills is a dashboard people stop trusting.

### 6. Update goal ledger calibrations

Open `goals/ledger.md`. For every goal whose `taste_type` is `attribution` or `analytics-data-quality` or `metric-tree`, check:

- Did the goal's resolution date pass this month? If yes, run `bin/substrate-goal-resolve` and record the verdict (YES / NO / AMBIGUOUS) with the source-system citation.
- For goals still open: did any of the audit findings invalidate the goal's measurement contract? If yes, log an override (per `goalpost-discipline-vs-metric-drift`) with attribution.

The override gets counted in the operator's calibration history. Repeated overrides on the same goal mean either the goal was poorly written or the source system is unstable; both are recoverable, neither is silent.

### 7. Spot-check segment-of-one views (per `segment-of-one-vs-cohort-aggregate`)

For one ICP cell this month: pick three users and walk their event timelines through the freshly-pulled CSVs. The cohort aggregates produced by retention / activation / lift skills tell you the curve; the per-user walk tells you the mechanism.

Note any mechanism findings the cohort aggregates missed. Add to `clients/<client>/voc/` if the finding is voice-of-customer-shaped (e.g., a specific UX friction the cohort can't see). Add to `clients/<client>/analytics/audits/` if the finding is taxonomy-shaped (e.g., a property missing from real users that the cohort summary masked).

### 8. Write the monthly summary

Compose a one-page summary at `clients/<client>/analytics/monthly-refresh-<YYYY-MM>.md`:

- Per-source pull status (mode, row count, taxonomy coverage).
- Audit headline: overlap %, drift count by category, top 5 high-severity items.
- Metric-tree leaf health: how many leaves stale, how many dashboards rebound.
- Goal ledger updates: resolutions filed, overrides logged.
- Segment-of-one finding for the month, if novel.
- Open issues for next month.

Keep it short. The skill outputs are dense; the monthly summary is the operator-readable index.

## Failure modes the routine prevents

- **Stale CSVs powering live dashboards.** Per `event-taxonomy-as-product-knowledge`, an undeclared event firing in production is drift; an unfired declared event is decay. The routine surfaces both monthly so neither becomes the default state.
- **Metric-tree leaves with no live event under them.** Per `metric-tree-not-metric-stack`, the tree is the strategy; leaves that no longer bind to live signal silently de-strategize the team. Step 4 catches this monthly.
- **Goal definitions drifting mid-quarter.** Per `goalpost-discipline-vs-metric-drift`, the contract locks at open. Step 6 surfaces drift and forces an explicit override (or a re-open) instead of a silent rewrite.
- **Cohort numbers without mechanism.** Per `segment-of-one-vs-cohort-aggregate`, the aggregate is the shape; the user-record path is the mechanism. Step 7 forces both views every month.
- **Mock-mode masquerading as real data.** Step 2's manifest captures the mode per source. The routine surfaces mock-fallback sources explicitly so downstream goal-resolution does not rely on them.

## Substrate reads + writes

- Reads: `clients/<client>/analytics/sources.yaml`, `events.yaml`, `analytics/<source>/<YYYY-MM>.csv` (post-pull), ICP, positioning, `analytics/metric-tree.yaml`, `analytics/dashboards/`, `goals/ledger.md`.
- Writes: `clients/<client>/analytics/<source>/<YYYY-MM>.csv` + manifest, `analytics/audits/events-taxonomy-audit-*`, `analytics/monthly-refresh-<YYYY-MM>.md`, optional updates to `events.yaml` (operator-owned), `metric-tree.yaml` (via `metric-tree-design --update`), `goals/ledger.md`.

## Quality criteria

- Refuses to mark the month complete if `sources.yaml` is missing or older than `freshness_window_days`.
- Refuses to mark the month complete if any source's manifest reports `mode: mock-fallback` for a source whose role is `primary-product-analytics` or `revenue-and-subscription` (these must be live; mock-mode does not count as a refresh for revenue-load-bearing sources).
- Refuses to mark the month complete if `event-taxonomy-audit` reported high-severity findings that were not triaged into the remediation queue.
- Refuses to mark the month complete if any prior-month goal in `taste_type: attribution|analytics-data-quality|metric-tree` is past its `resolution_date` and unresolved.

## See also

- `skills/analytics-pull/SKILL.md`
- `skills/event-taxonomy-audit/SKILL.md`
- `skills/metric-tree-design/SKILL.md`
- `skills/dashboard-spec/SKILL.md`
- `skills/attribution-model-design/SKILL.md`
- `routines/retention-monthly.md` (the prior-Tuesday companion)
- `routines/lift-test-rhythm.md` (quarterly companion)
- `knowledge/patterns/event-taxonomy-as-product-knowledge.md`
- `knowledge/patterns/metric-tree-not-metric-stack.md`
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`
- `knowledge/patterns/segment-of-one-vs-cohort-aggregate.md`
- `templates/analytics-sources-example.yaml`
