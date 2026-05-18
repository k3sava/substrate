---
name: event-taxonomy-audit
description: Audit the client's events.yaml against production event stream. Surfaces drift (events fired but undeclared, events declared but unfired), duplicates (near-identical names), missing properties on declared events, naming-convention violations, and freshness decay. Outputs remediation list. Refuses without events.yaml.
version: 0.1
amplifies: PMM lead, head of analytics, analytics engineer, RevOps, founder
masters: Iris Vaknin (tracking-plan-as-deliverable), Yali Sassoon (events-as-rich-data), Mike Kitchen (analytics-engineer-owns-the-taxonomy), Avo / Iteratively schema-registry literature, Reforge analytics curriculum, Reforge faculty (taxonomy as substrate)
substrate_layers_required: [icp, positioning]
patterns_grounded: [event-taxonomy-as-product-knowledge, goalpost-discipline-vs-metric-drift]
preflight_refusal: substrate-gap, missing-events-yaml
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/events.yaml
---

# event-taxonomy-audit

## Purpose

Audit the client's `events.yaml` taxonomy against the production event stream. Per the `event-taxonomy-as-product-knowledge` pattern, the taxonomy is a contract; the audit is what enforces the contract. Without periodic auditing, the taxonomy drifts within a quarter: events get added by whoever needs a number, near-duplicate names appear, properties go missing, and the analytics warehouse becomes uninterpretable. The audit surfaces drift in five categories and produces a remediation list ranked by urgency.

The skill reads the production event stream from CSVs landed by `analytics-pull` (per source) and the declared taxonomy from `events.yaml`, then runs five checks: (1) declared-but-unfired (taxonomy contains events that have not fired in N days), (2) fired-but-undeclared (production events missing from taxonomy), (3) near-duplicate-names (events whose names share >0.7 token overlap; usually rename-without-deprecation drift), (4) missing-properties (declared events whose property list is incomplete vs production), (5) naming-convention violations (events not in object_action snake_case form, mixed-case events, verb-less events).

## Inputs

- `--client <client>` (required)
- `--source <amplitude|posthog|mixpanel|hubspot|stripe|segment|ga4|all>` (default: `all`; sources to audit)
- `--month <YYYY-MM>` (default: previous calendar month; the audit window for production events)
- `--decay-days <int>` (default: 30; an event declared but unfired for more than N days is flagged decommissioned-candidate)
- `--strict-naming` (treat naming-convention violations as refusals, not warnings)

## Substrate reads

- `clients/{client}/events.yaml`, the canonical taxonomy. Refuses without it.
- `clients/{client}/analytics/<source>/<YYYY-MM>.csv`, the production event stream landed by `analytics-pull`. Refuses if no CSVs are present (must run `analytics-pull` first).
- `clients/{client}/icp/icp.md`, to interpret which events serve which ICP cells.
- `clients/{client}/positioning/positioning.md`, to flag events whose names contradict positioning vocabulary.

## Output contract

Three artifacts under `clients/{client}/analytics/audits/`:

1. `events-taxonomy-audit-<YYYY-MM-DD>.md`, the human-readable audit:
   - **Coverage summary**: declared events, fired events, % overlap, drift count by category.
   - **Declared-but-unfired list**: events in taxonomy with no production fires in N days; per-event recommendation (decommission / investigate / re-instrument).
   - **Fired-but-undeclared list**: production events missing from taxonomy; per-event recommendation (declare / rename to existing / decommission at source).
   - **Near-duplicate-names list**: events whose names share >0.7 token overlap; per-pair recommendation (merge / rename / clarify).
   - **Missing-properties list**: declared events whose property list is incomplete; per-event missing-property table.
   - **Naming-convention violations**: events not in object_action snake_case form; per-event proposed rename.
   - **ICP-cell drift**: events declared with `icp_cells` that no longer match positioning; flagged for review.
   - **Remediation list**: ranked by urgency, with operator action per item.

2. `events-taxonomy-audit-<YYYY-MM-DD>.json`, structured audit:
   - `coverage_summary`: `{declared_n, fired_n, overlap_pct, drift_count_by_category}`.
   - `findings`: list of finding records with `category`, `event_name`, `severity`, `recommendation`.

3. `events-taxonomy-audit-<YYYY-MM-DD>-remediation.csv`, a row-per-finding remediation table for downstream issue tracker import.

## Quality criteria

- Refuses without `events.yaml`. Per the pattern, undeclared events in production are drift; an audit that does not gate against the taxonomy file is a noun list.
- Refuses without at least one production CSV from `analytics-pull`. The audit needs a stream to compare against.
- Naming-convention check uses object_action snake_case (the convention named in the pattern). Strict-naming mode treats violations as refusals; default treats them as warnings ranked by frequency.
- Near-duplicate detection uses 1-gram token overlap with stop-word filtering. Pairs with >0.7 overlap are flagged.
- Missing-properties detection compares the declared property list to the production property column set; properties missing from declaration are flagged.
- Coverage summary includes the % overlap, which becomes a calibration signal: high overlap = healthy taxonomy; low overlap = drift accelerating.

## What this skill does NOT do

- Does not edit `events.yaml`. The skill produces a remediation list; the operator (or a downstream skill) edits the file.
- Does not delete events from production. Only the analytics engineer at the source can do that.
- Does not invent the taxonomy. Refuses if the file does not exist.
- Does not fire alerts to chat. The output is local artifacts; integration with alerting is operator-driven.

## Refusal patterns

- `substrate-gap`: missing ICP / positioning / events.yaml.
- `missing-events-yaml`: `events.yaml` not present or empty.
- `missing-production-stream`: no CSVs found under `analytics/<source>/`. Run `analytics-pull` first.
- `strict-naming-violation` (when `--strict-naming` set): naming-convention violations treated as refusals.

## Composes with

- Reads from: `events.yaml`, `analytics/<source>/<YYYY-MM>.csv` per source, ICP + positioning.
- Writes for: `analytics-pull` (the audit's coverage stat tunes the pull's drift warning threshold), `metric-tree-design` (the audit's drift findings can demote a leaf metric), `analytics-monthly-refresh` routine (the audit is a monthly checklist item).
- Triggered by: monthly schedule (`routines/analytics-monthly-refresh.md`), product release (new events added), suspected schema drift, dashboard panel showing nulls.

## Calibration

Tracked under taste-type `analytics-data-quality`. Brier signal: drift findings flagged "high severity" should produce visible improvement in the next month's audit; drift findings repeated across audits are a sign the remediation step is not being honored, and the operator's calibration on remediation quality logs.

## See also

- `knowledge/patterns/event-taxonomy-as-product-knowledge.md` (load-bearing).
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`.
- `templates/events-yaml-example.yaml` (canonical taxonomy shape).
- `skills/analytics-pull/SKILL.md`.
- `skills/metric-tree-design/SKILL.md`.
- `routines/analytics-monthly-refresh.md`.
