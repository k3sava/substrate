---
name: dashboard-spec
description: Generate a dashboard spec from the goal ledger and metric tree. Outputs YAML / markdown spec exportable to Amplitude, Looker, Metabase, Tableau, or HubSpot reporting. Forces explicit naming of audience, refresh cadence, drill-paths, and drift-watch alerts. Refuses without metric-tree.yaml.
version: 0.1
amplifies: PMM lead, growth lead, head of analytics, RevOps, leadership / RevOps
masters: Avinash Kaushik (10/90 rule, dashboard-as-decision-tool), Cole Nussbaumer Knaflic (Storytelling with Data), Edward Tufte (data-ink ratio), Stephen Few (Information Dashboard Design), Lenny Rachitsky (operator-readable dashboards from named-company growth practices), Reforge (metric-tree-as-dashboard structure)
substrate_layers_required: [icp, positioning]
patterns_grounded: [metric-tree-not-metric-stack, segment-of-one-vs-cohort-aggregate]
preflight_refusal: substrate-gap, missing-metric-tree
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/analytics/metric-tree.yaml
---

# dashboard-spec

## Purpose

Generate a dashboard spec from the metric tree and the goal ledger. Most dashboards fail because they are noun lists ("here are 17 metrics") rather than decision tools ("which subtree is broken this week"). The skill enforces structure: every dashboard has a named audience (exec, growth, lifecycle, sales, support), a primary decision the dashboard supports, a metric subset drawn from the tree, a cadence, and a drill-path that connects aggregate cohort views to segment-of-one user-record views.

Per the `metric-tree-not-metric-stack` pattern, the dashboard reads from the tree, not the noun list. Per the `segment-of-one-vs-cohort-aggregate` pattern, every aggregate panel has a drill-path to a segment-of-one view; teams that build only aggregate panels are shipping incomplete substrate.

The spec is BI-tool-agnostic at the spec level (YAML + markdown) and carries adapter notes for Amplitude, Looker, Metabase, Tableau, and HubSpot reporting. The implementation is the operator's; the spec is the contract.

## Inputs

- `--client <client>` (required)
- `--audience <exec|growth|lifecycle|sales|support|all>` (required)
- `--decision <budget-allocation|retention-watch|funnel-watch|attribution-debate|expansion-pipeline|narrative-drift>` (required; the named decision the dashboard exists to support)
- `--cadence <real-time|daily|weekly|monthly|quarterly>` (default: weekly)
- `--id <slug>` (default: derived from audience + decision; the dashboard slug used for filenames)
- `--export <amplitude|looker|metabase|tableau|hubspot|all>` (default: `all`; the skill includes adapter sections per platform)

## Substrate reads

- `clients/{client}/analytics/metric-tree.yaml`, the canonical metric source. Every panel cites a node from this file.
- `goals/ledger.md` (when present), the open-and-resolved goals; dashboards include a "live goals" panel for the named audience.
- `clients/{client}/icp/icp.md`, to interpret per-segment views.
- `clients/{client}/positioning/positioning.md`, to ensure dashboard headlines reflect positioning.
- `clients/{client}/analytics/sources.yaml`, to source-system every panel.

## Output contract

A single artifact at `clients/{client}/analytics/dashboards/<id>.yaml` plus a human-readable companion at `clients/{client}/analytics/dashboards/<id>.md`:

The YAML carries:
- `dashboard_id`, `audience`, `decision`, `cadence`, `last_updated`, `version`.
- `panels`: list of panel records with `id`, `title`, `metric_id` (cite from tree), `panel_kind` (single-stat | timeseries | funnel | cohort-table | drill-list), `source_system`, `query`, `refresh_cadence`, `drill_path` (segment-of-one link), `alert_rule` (drift threshold).
- `adapters`: per-platform export hints for amplitude / looker / metabase / tableau / hubspot.

The markdown carries:
- **Audience + decision** (named, with substrate citation).
- **Panel layout** (ASCII grid showing the dashboard structure).
- **Per-panel detail**: title, metric_id, query, cadence, drill-path.
- **Drift-watch alerts**: which panels carry alert rules (e.g., "W4 retention drops > 1.5 SD vs trailing-4 cohort baseline").
- **Drill-path manifest**: every aggregate panel has a documented drill-path to a segment-of-one view (session replay, account-level event timeline, support-ticket cluster, customer-interview transcript). Per the segment-of-one-vs-cohort-aggregate pattern.
- **Substrate citations**: every panel cites a tree node; every tree node cites substrate.

## Quality criteria

- Refuses without `metric-tree.yaml`. Dashboards that do not read from the tree are noun lists.
- Refuses without a named audience and decision. Dashboards without a named decision are decoration.
- Per `segment-of-one-vs-cohort-aggregate`, every aggregate panel must declare a drill-path. Aggregate-only dashboards refuse to lock unless `--accept-aggregate-only` is passed and the operator logs the gap.
- Each panel cites a tree node. Panels with metrics not in the tree fail preflight.
- Drift-watch alerts are required for every retention or revenue panel (the panels where silent drift is most expensive).
- The cadence on each panel must be consistent with or more frequent than the dashboard's overall cadence.

## What this skill does NOT do

- Does not implement the dashboard. The output is a spec; implementation is in the BI tool.
- Does not pull data. That is `analytics-pull`.
- Does not invent metrics. Refuses if a panel cites a metric not in the tree.
- Does not pick the audience. Operator names the audience; per Rule 7, dashboards built for an audience that did not pull are dead on arrival.

## Refusal patterns

- `substrate-gap`: missing ICP / positioning / metric-tree.yaml.
- `missing-metric-tree`: tree absent or empty.
- `metric-not-in-tree`: a panel cites a metric not in metric-tree.yaml.
- `audience-decision-missing`: no `--audience` or no `--decision`.
- `aggregate-only-violation` (refusal unless `--accept-aggregate-only`): an aggregate panel has no drill-path.
- `cadence-mismatch`: a panel's cadence is less frequent than the dashboard's overall cadence.

## Composes with

- Reads from: metric-tree.yaml, goal ledger, sources.yaml, ICP, positioning.
- Writes for: BI-tool exporters (Amplitude / Looker / Metabase / Tableau / HubSpot adapter sections in the spec), `analytics-monthly-refresh` routine (validates the dashboard is being read).
- Triggered by: new audience (exec dashboard requested), new decision (attribution debate kicks off), metric tree refresh, quarterly review.

## Calibration

Tracked under taste-types `analytics-data-quality` and `decision-quality`. Brier signal: predicted-decision-influence (the operator predicts whether the dashboard will change the team's behavior on the named decision) vs actual; dashboards that nobody opens fail their goal.

## See also

- `knowledge/patterns/metric-tree-not-metric-stack.md`.
- `knowledge/patterns/segment-of-one-vs-cohort-aggregate.md`.
- `templates/metric-tree-example.md`.
- `skills/metric-tree-design/SKILL.md`.
- `skills/analytics-pull/SKILL.md`.
- `routines/analytics-monthly-refresh.md`.
