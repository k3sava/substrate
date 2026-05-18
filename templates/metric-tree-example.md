---
title: metric tree, Acme (example), 2026-05-08
status: example
last_updated: 2026-05-08
client: acme
patterns_grounded: [metric-tree-not-metric-stack, goalpost-discipline-vs-metric-drift]
produced_by: metric-tree-design
template: true
---

# Metric tree, Acme (example), 2026-05-08

> Example output for `skills/metric-tree-design`. Acme is an anonymous mid-market SaaS in the workflow-automation category with a freemium-to-paid funnel, four ICP cells (smb-ops-lead, mid-market-rev-ops, founder-led, ent-ops-pm), and an annual recurring revenue book around $18M. Use this as the shape your client's tree will take. Replace every node with the client's actual cohort definitions and source-system queries; do not copy the numbers.

Per the `metric-tree-not-metric-stack` pattern (Reforge faculty + Casey Winters + Brian Balfour + Rob Sobers), metrics organize as a tree, not a flat stack. The north-star is the root. Two-to-four input metrics are first-level branches (each captures a lever the team can move). Supporting metrics decompose each input. Behavioral leading indicators sit at the leaves.

Per `goalpost-discipline-vs-metric-drift` (Patrick Campbell + Tomasz Tunguz + Reichheld), every node carries a frozen definition and a named source-system query. Mid-quarter changes are logged as overrides with attribution; the audit checklist is regenerated each quarter.

## Tree visualization

```
[ROOT, north-star]  Weekly active paying cohorts (W1-W12 retention curve)  (weekly, source: amplitude + warehouse stitch)
├── [INPUT/acquisition]  Weekly new paying customer cohorts  (weekly, source: stripe + hubspot)
│   ├── [SUPPORTING]  Weekly ICP-fit trial signups  (daily, source: amplitude + hubspot)
│   ├── [SUPPORTING]  Trial-to-paid conversion rate (W4)  (weekly, source: stripe + amplitude)
│   └── [LEAF]  ICP-fit signup rate  (daily, source: hubspot)
├── [INPUT/activation]  Trial activation rate (within 24h window)  (weekly, source: amplitude)
│   ├── [SUPPORTING]  Median time to activation (hours)  (weekly, source: amplitude)
│   ├── [SUPPORTING]  Activation rate by signup source  (weekly, source: amplitude)
│   ├── [LEAF]  First-value event completion rate (D1)  (daily, source: amplitude)
│   └── [LEAF]  Onboarding step-3 dropoff rate  (weekly, source: amplitude)
├── [INPUT/retention]  W4 cohort retention rate  (weekly, source: amplitude (cohort retention))
│   ├── [SUPPORTING]  Net Revenue Retention (NRR)  (monthly, source: stripe)
│   ├── [SUPPORTING]  Gross Revenue Retention (GRR)  (monthly, source: stripe)
│   ├── [SUPPORTING]  Monthly logo churn rate  (monthly, source: stripe)
│   └── [LEAF]  Weekly engagement decay flags  (daily, source: amplitude)
└── [INPUT/monetization]  Monthly average revenue per customer (ARPC)  (monthly, source: stripe)
    ├── [SUPPORTING]  Expansion revenue rate  (monthly, source: stripe)
    ├── [SUPPORTING]  Downgrade revenue rate  (monthly, source: stripe)
    └── [LEAF]  Weekly upgrade event count  (weekly, source: amplitude)
```

Counts: 4 inputs, 5 leaves. Tree fits on one page (per the pattern: a tree the team cannot draw on a whiteboard is a stack pretending to be a tree).

## North-star

**Metric:** Weekly active paying cohorts (W1-W12 retention curve)
**ID:** `weekly-active-revenue-cohorts`
**Definition:** Cohorts of paying users still active in week N (counted only if they fired `session_active` in the named week), computed weekly. The retention curve, not a single point, is the north-star.
**Source system:** amplitude (cohort retention chart) + warehouse stitch on `paid` flag from stripe
**Source query:**
```sql
-- Weekly active paying cohorts, retention curve view
WITH paid_cohorts AS (
  SELECT user_id, DATE_TRUNC('week', first_paid_ts) AS cohort_week
  FROM warehouse.subscriptions
  WHERE status = 'active' AND tier IN ('starter','growth','scale','enterprise')
)
SELECT cohort_week, week_offset, COUNT(DISTINCT user_id) AS active_users
FROM paid_cohorts
JOIN warehouse.events USING (user_id)
WHERE event_name = 'session_active'
GROUP BY cohort_week, week_offset
```
**Cadence:** weekly (Tuesday morning, prior-week close)
**Rationale:** Per Casey Winters: retention is the trunk. A weekly active paying cohort number is the truest read of whether the product is worth what people pay. ARR is the lagging report of this; the curve is the leading read.
**Validity window:** quarterly (the cohort definition is locked at quarter open).
**ICP cells served:** all (the north-star aggregates across cells; the dashboard panel splits by cell).

## Input metrics (branches)

Each input metric represents a lever. Per the pattern, a tree with more than 4 inputs is a sign the team has not picked.

### Input: Weekly new paying customer cohorts (`acquisition`)

- **ID:** `weekly-new-customer-cohorts`
- **Definition:** Distinct paying customers who started their first paid subscription in the named week (no double-count for re-conversion).
- **Source system:** stripe (subscription_created event) + hubspot (firmographic enrichment)
- **Cadence:** weekly
- **Parent:** `weekly-active-revenue-cohorts`
- **Owner:** growth lead
- **Refresh cadence freshness window:** 7 days

**Supporting metrics:**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `weekly-icp-fit-trial-signups` | Weekly ICP-fit trial signups | Trial signups whose firmographic match the ICP definition; signal of acquisition quality, not volume. | daily | amplitude + hubspot |
| `trial-to-paid-conversion-rate` | Trial-to-paid conversion rate (W4) | Of weekly ICP-fit trial cohort, share that converted to paid by week 4. | weekly | stripe + amplitude |

**Behavioral leaves (leading indicators):**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `icp-fit-signup-rate` | ICP-fit signup rate | Share of all signups whose firmographic data matches the ICP definition. Fires daily; leads weekly-icp-fit-trial-signups by ~7 days. | daily | hubspot |

### Input: Trial activation rate within 24h window (`activation`)

- **ID:** `trial-activation-rate`
- **Definition:** Share of weekly trial cohort that fired the activation event (`trial.activated` per `events.yaml`) within 24 hours of `trial.started`.
- **Source system:** amplitude (cohort builder)
- **Cadence:** weekly
- **Parent:** `weekly-active-revenue-cohorts`
- **Owner:** lifecycle lead
- **Activation event source:** named by `skills/activation-funnel-audit` quarterly; locked at quarter open per `goalpost-discipline-vs-metric-drift`.

**Supporting metrics:**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `time-to-activation-median` | Median time to activation (hours) | Median hours from `trial.started` to `trial.activated` for the cohort that activated. | weekly | amplitude |
| `activation-by-signup-source` | Activation rate by signup source | Activation rate split by `property_signup_source`. Identifies channels delivering qualified vs unqualified signups. | weekly | amplitude |

**Behavioral leaves (leading indicators):**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `first-value-event-completion` | First-value event completion rate (D1) | Share of new signups that complete the named `first_value_event` within 24 hours. Leads `trial-activation-rate` by ~3 days. | daily | amplitude |
| `onboarding-step-3-dropoff` | Onboarding step-3 dropoff rate | Per-step dropoff at onboarding step 3 (workspace-creation); the highest-friction step in the current funnel. | weekly | amplitude |

### Input: W4 cohort retention rate (`retention`)

- **ID:** `w4-retention-rate`
- **Definition:** Share of activated paying users in cohort C still firing `session_active` in week 4 from cohort start.
- **Source system:** amplitude (cohort retention chart, conditioned on `trial.activated`)
- **Cadence:** weekly
- **Parent:** `weekly-active-revenue-cohorts`
- **Owner:** PM-retention + analytics engineering
- **Cohort definition source:** `clients/acme/icp/icp.md`

**Supporting metrics:**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `monthly-net-revenue-retention` | Net Revenue Retention (NRR) | Trailing 12-month NRR: (start ARR - churn ARR + expansion ARR) / start ARR. | monthly | stripe |
| `monthly-gross-revenue-retention` | Gross Revenue Retention (GRR) | Trailing 12-month GRR: (start ARR - churn ARR) / start ARR. | monthly | stripe |
| `monthly-churn-rate` | Monthly logo churn rate | Distinct churned customers in month / start-of-month customer count. | monthly | stripe |

**Behavioral leaves (leading indicators):**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `weekly-engagement-decay` | Weekly engagement decay flags | Active customers whose `session_active` count in trailing 7 days is more than 1.5 SD below their trailing-30 baseline; leads `w4-retention-rate` by ~14 days. | daily | amplitude |

### Input: Monthly average revenue per customer (`monetization`)

- **ID:** `monthly-revenue-per-customer`
- **Definition:** Sum of monthly subscription revenue / distinct paying customers; tracks pricing power and tier-mix.
- **Source system:** stripe (charge.succeeded sum / distinct customer_id)
- **Cadence:** monthly
- **Parent:** `weekly-active-revenue-cohorts`
- **Owner:** RevOps + pricing PM

**Supporting metrics:**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `expansion-revenue-rate` | Expansion revenue rate | Trailing-quarter expansion ARR (upsell, seat-add, tier-up) / start-of-quarter ARR. | monthly | stripe |
| `downgrade-revenue-rate` | Downgrade revenue rate | Trailing-quarter downgrade ARR (tier-down, seat-removal) / start-of-quarter ARR. | monthly | stripe |

**Behavioral leaves (leading indicators):**

| ID | Metric | Definition | Cadence | Source |
|---|---|---|---|---|
| `weekly-upgrade-events` | Weekly upgrade event count | Count of `paid_started` or `upgrade_initiated` events in the week. Leads `expansion-revenue-rate` by ~30 days. | weekly | amplitude |

## Validation summary

- Inputs: 4 / 4 max (per pattern: more than 4 means the team has not picked)
- Leaves: 5 / 12 max (per pattern: more than 12 means the tree fragmented)
- Every node names a source-system query (the dashboard-spec preflight refuses on unbound nodes)
- Every node names a cadence (panels read the cadence to decide rolling-window vs snapshot)
- Locked-at-quarter-open: yes, per `goalpost-discipline-vs-metric-drift`

## Substrate citations

- ICP: `clients/acme/icp/icp.md`
- Positioning: `clients/acme/positioning/positioning.md`
- Sources: `clients/acme/analytics/sources.yaml`
- Events taxonomy: `clients/acme/events.yaml`
- Pattern: `knowledge/patterns/metric-tree-not-metric-stack.md`
- Pattern: `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`

## How dashboards read this tree

`skills/dashboard-spec` reads the YAML companion (`metric-tree.yaml`) and emits dashboard panels that cite tree node IDs. A panel referencing a metric not in this tree fails preflight. A goal opening against a metric not in this tree fails preflight. The tree IS the contract.

Per `segment-of-one-vs-cohort-aggregate`, every aggregate panel declares a drill-path to a segment-of-one view (e.g., `w4-retention-rate` drills into per-account weekly engagement timelines). Both views are required; the tree describes the aggregate layer.

## Quarterly audit cadence

This tree is regenerated and re-validated quarterly per `routines/analytics-monthly-refresh.md` step 4. Mid-quarter changes count as overrides per `goalpost-discipline-vs-metric-drift`. The override list lives in the tree's frontmatter under `overrides:`.

## Next reads

- `skills/dashboard-spec --client acme --audience exec --decision narrative-drift`
- `skills/lift-test-design --client acme --metric <id-from-tree>`
- `routines/analytics-monthly-refresh.md`
- `routines/lift-test-rhythm.md`
