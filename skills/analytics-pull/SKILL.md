---
name: analytics-pull
description: Pull analytics data from named source systems (Amplitude, PostHog, Mixpanel, HubSpot, Stripe, Segment, GA4) into per-client substrate as schema-mapped CSVs. Refuses without sources.yaml. Honors per-source schemas; mocks when API keys are absent so the pipeline runs end-to-end before live credentials land.
version: 0.1
amplifies: PMM lead, growth lead, head of analytics, RevOps, founder
masters: Amplitude (event-property model), PostHog (event-and-session model), Mixpanel (event taxonomy + cohort export), HubSpot (CRM-and-marketing-events model), Stripe (subscription-and-revenue events), Segment (CDP source-and-destination model), GA4 (events + property scopes), Iris Vaknin + Mike Kitchen + Yali Sassoon on tracking-plan discipline
substrate_layers_required: [icp, positioning]
patterns_grounded: [event-taxonomy-as-product-knowledge, metric-tree-not-metric-stack]
preflight_refusal: substrate-gap, missing-sources-yaml, missing-events-yaml
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
---

# analytics-pull

## Purpose

Pull data from the source systems an organization actually uses, normalize it to the substrate's CSV shape, and land it under `clients/<client>/analytics/<source>/<YYYY-MM>.csv`. The skill is the entry point for every downstream analytics surface: retention, attribution, dashboards, lift tests, all read from the per-source CSVs this skill produces. Without it, every downstream skill is forced to invent its own ingest, and the substrate fragments.

The skill treats event taxonomy as product knowledge per the `event-taxonomy-as-product-knowledge` pattern: it reads `clients/<client>/events.yaml` (when present), maps source-system event names to the canonical taxonomy, and refuses if the taxonomy is missing for sources that emit events. For sources that emit revenue or CRM data (Stripe, HubSpot), the taxonomy gate softens to a warning.

## Inputs

- `--client <client>` (required)
- `--source <amplitude|posthog|mixpanel|hubspot|stripe|segment|ga4|all>` (default: `all`, runs every source declared in sources.yaml)
- `--month <YYYY-MM>` (default: previous calendar month)
- `--mock` (force mock-mode even when API keys are present; produces realistic CSVs from seed data for pipeline testing)
- `--dry-run` (print intent + manifest, write nothing)

## Substrate reads

- `clients/{client}/analytics/sources.yaml`, the per-client source-system inventory (which platforms are connected, which API base URLs, which property scopes). Refuses without this file.
- `clients/{client}/events.yaml` (when present), the canonical event taxonomy. Used to map source event names to the taxonomy and to warn on drift (events fired in production but undeclared).
- `clients/{client}/icp/icp.md`, to interpret per-segment data.
- `clients/{client}/positioning/positioning.md`, to cross-check whether the source-system event names align with positioning language.

## Output contract

Per source, one CSV per month, plus a manifest:

- `clients/{client}/analytics/<source>/<YYYY-MM>.csv` (e.g., `analytics/amplitude/2026-04.csv`)
- `clients/{client}/analytics/<source>/<YYYY-MM>.manifest.json` (row count, column list, source query, fetched_at, mock-mode flag, taxonomy-coverage stat)
- `clients/{client}/analytics/_log/<YYYY-MM-DD>-pull.md` (run log: which sources ran, row counts, drift warnings, refusal reasons)

Schemas, by source:

| Source | Columns | Notes |
|---|---|---|
| amplitude | event_id, user_id, event_name, ts, session_id, country, device_type, property_* | Amplitude events table shape. Property columns prefixed `property_`. |
| posthog | event_id, distinct_id, event_name, ts, session_id, person_id, property_* | PostHog event table shape. distinct_id is per-device. |
| mixpanel | event_id, distinct_id, event_name, ts, session_id, property_* | Mixpanel events. distinct_id semantics same as PostHog. |
| hubspot | object_id, object_type, event_type, ts, owner_id, property_* | HubSpot CRM + marketing events. object_type ∈ {contact, deal, company, ticket}. |
| stripe | event_id, customer_id, event_type, ts, currency, amount_cents, plan_id, status | Stripe subscription + invoice + charge events. |
| segment | event_id, user_id, anonymous_id, event_name, ts, source, property_* | Segment unified CDP event shape. |
| ga4 | event_id, client_id, event_name, ts, session_id, property_* | GA4 standard event shape; properties via `event_params`. |

Every column maps cleanly to the taxonomy in `events.yaml` for sources that emit events.

## Quality criteria

- Refuses without `clients/<client>/analytics/sources.yaml`. The schema for sources.yaml is defined in `templates/analytics-sources-example.yaml`.
- Warns when a source emits events that are not declared in `events.yaml`; the warning lists the undeclared events and counts. Per the event-taxonomy-as-product-knowledge pattern, undeclared events in production are drift, not noise.
- Each CSV has a `manifest.json` with: row count, distinct user count, ts range, source query, fetched_at, mock-mode flag, and taxonomy coverage (% of rows whose event is declared in events.yaml).
- Mock-mode produces realistic data shapes (per-source seed generators) so downstream skills can be smoke-tested before live credentials land. The manifest flags `mock_mode: true` and the CSVs carry `__mock__` in the user_id namespace.
- API rate-limit handling: each source has a per-minute budget; the skill backs off and retries on 429. The log captures every retry.

## What this skill does NOT do

- Does not write strategy. The output is structured data + a manifest.
- Does not transform events into the taxonomy. Mapping is declarative (sources.yaml carries the field map). Transform is downstream of pull.
- Does not unify identities across sources. That is identity resolution and lives downstream.
- Does not exfiltrate data. CSVs land on local disk under the client substrate; nothing leaves the machine.

## Refusal patterns

- `substrate-gap`: missing ICP layer.
- `missing-sources-yaml`: `clients/<client>/analytics/sources.yaml` not present or empty.
- `missing-events-yaml` (warning, not refusal, when source emits events): `events.yaml` missing.
- `api-credential-missing` (warning, not refusal): API key env var missing for a declared source; skill falls back to mock mode for that source and logs the fallback.

## Composes with

- Reads from: `clients/<client>/analytics/sources.yaml`, `clients/<client>/events.yaml`, ICP + positioning.
- Writes for: `retention-cohort-analysis`, `activation-funnel-audit`, `churn-diagnose`, `expansion-trigger-detect` (events sources); `attribution-model-design`, `metric-tree-design`, `dashboard-spec` (all sources); `lift-test-design` (baseline conversions).
- Triggered by: monthly schedule (`routines/analytics-monthly-refresh.md`), ad-hoc request, source-system event-schema change.

## Calibration

Tracked under taste-type `analytics-data-quality`. Brier signal: the manifest's taxonomy-coverage stat compared against the event-taxonomy-audit's drift count; high-coverage manifests should produce low drift counts at audit.

## See also

- `templates/analytics-sources-example.yaml` (canonical sources.yaml shape).
- `templates/events-yaml-example.yaml` (canonical events taxonomy).
- `knowledge/patterns/event-taxonomy-as-product-knowledge.md`.
- `knowledge/patterns/metric-tree-not-metric-stack.md`.
- `skills/event-taxonomy-audit/SKILL.md`.
- `routines/analytics-monthly-refresh.md`.
