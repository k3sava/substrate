---
name: email-cohort-trigger
description: Design behavioral triggers that segment users into cohorts and route them to lifecycle sequences. Reads the product event taxonomy from clients/<client>/events.yaml, maps events to cohort transitions, and outputs a trigger spec compatible with Customer.io, Iterable, and generic webhook receivers. Refuses without an events.yaml or with stale events.
version: 0.1
amplifies: lifecycle marketer, growth engineer, PMM owning a launch trigger
masters: Bob Moesta (JTBD progress moments as the trigger unit), Val Geisler (trigger-not-cadence design discipline), Brian Kotlyar (segment-or-die operating rule), Andy Crestodina (Orbit Media; behavioral content beats blast), Customer.io and Iterable trigger-design documentation
substrate_layers_required: [icp, conversion-narrative, product-knowledge]
patterns_grounded: [one-segment-one-trigger, engagement-decay-as-relevance-signal]
contradictions_aware: []
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/02-icp.md
  - clients/{client}/05-product-knowledge.md
  - clients/{client}/06-conversion-narrative.md
---

# email-cohort-trigger

## Purpose

Design the upstream half of a lifecycle program: the cohorts users move through and the events that trigger transitions between them. Reads the product's event taxonomy, validates it for completeness and freshness, maps events to cohort transitions (`activated`, `cooling`, `churning`, `power-user-emerging`), and produces a trigger spec the email tool's API can ingest.

This skill replaces "send the nurture to free trial users" with "users in `paid-trial-stuck-on-activation` (entered at `trial.activated.no-teammate-96h`, exits on `team.member.invited` OR `trial.cancelled` OR `cohort.timeout-14d`) get routed to sequence `paid-trial-no-teammate-invite`."

The unit is one cohort × one trigger, per the `one-segment-one-trigger` pattern. The skill refuses to ship a "broadcast trigger" (`always`).

## Inputs

- `--client <client>` (required)
- `--mode <bootstrap|design|spec>` (default `design`)
  - `bootstrap`: write a starter `events.yaml` template to the client folder.
  - `design`: produce cohort definitions + trigger specs. Default mode.
  - `spec`: emit only the API-shaped trigger spec for an existing cohort definition.
- `--cohort <name>` (required for `design` and `spec`)
- `--target-tool <customer-io|iterable|webhook|generic>` (default `generic`)
- `--out <path>` (optional, default: `clients/<client>/email/triggers/<cohort-name>.md`)

## Substrate reads

The skill refuses unless these layers exist for the client:

1. `02-icp.md` — every cohort maps to an ICP cell.
2. `05-product-knowledge.md` — the event taxonomy must reference real product surfaces.
3. `06-conversion-narrative.md` — cohort transitions follow the narrative arc (awareness → consideration → decision → close).
4. `events.yaml` — the canonical event taxonomy. The skill validates it before reading.

## events.yaml contract

The skill reads this file from `clients/<client>/events.yaml`. Expected schema:

```yaml
version: <semver>
last_updated: <YYYY-MM-DD>
freshness_window_days: 30
source_system: <amplitude|segment|posthog|mixpanel|custom>
events:
  - name: <event.name.dotted>
    description: <one-line>
    surface: <product surface>
    properties:
      - <property-name>
    icp_cells: [<cell-id>]
    last_observed: <YYYY-MM-DD>
cohorts:
  - id: <cohort-slug>
    description: <one-line>
    enter_on: <event-name>
    exit_on: [<event-name>, <event-name>]
    timeout_days: <n>
    icp_cell: <cell-id>
```

The skill enforces:

- `last_updated` within `freshness_window_days` (else stale, refusal).
- `source_system` declared (Amplitude / Segment / PostHog / Mixpanel / custom).
- Every event has `last_observed`; events with `last_observed` over 90 days old are flagged "potentially decommissioned" — the skill warns the operator before using one as a trigger.
- Every cohort referenced has at least one ICP cell mapping.

## Process

1. **Preflight**: required-reads check; events.yaml schema check; freshness check.
2. **Cohort lookup**: resolve `--cohort` against `events.yaml`. If missing, refuse and suggest the closest match by Levenshtein distance.
3. **Trigger graph build**: walk `enter_on` → `exit_on` events. Validate each event exists in the events list. Validate `timeout_days` is set (no infinite cohort membership).
4. **Trigger spec emit**: produce a trigger specification in the shape of `--target-tool`:
   - **customer-io**: a campaign trigger spec (event-triggered campaign with segment filter and exit-on conditions)
   - **iterable**: a workflow trigger spec (entry trigger, exit criteria, journey timeout)
   - **webhook**: a generic webhook-driven spec (POST shape, expected event payload, idempotency key)
   - **generic**: vendor-neutral pseudo-spec the operator translates manually
5. **Decay-aware export**: include the cohort's `cohort_exit_conditions` set so downstream sequence skills can wire the kill-switch (per `engagement-decay-as-relevance-signal`, exit-on-conversion is mandatory).
6. **Sequence link**: if a sequence exists at `clients/<client>/email/sequences/<cohort>/`, the trigger spec links to it; if not, a TODO is emitted suggesting `email-sequence-design --cohort <cohort>`.

## Output contract

```
clients/<client>/email/triggers/<cohort-name>.md
```

With sections:
- Cohort definition (one-line + ICP cell)
- Enter event (with sample payload)
- Exit events (list with sample payloads)
- Timeout policy
- Target tool spec block (formatted for the named tool)
- Linked sequence (if exists)
- Substrate citations (events, ICP cells, narrative stage)

In `bootstrap` mode, the skill writes a fully-commented `clients/<client>/events.yaml` template instead.

## Quality criteria

- Every trigger has a defined exit (no infinite cohorts; timeout_days is mandatory).
- Every cohort has an ICP cell mapping (no demographic-only cohorts).
- Every event in the trigger spec exists in the events.yaml AND has `last_observed` within 90 days OR is explicitly tagged `decommissioned: false` with a substrate path explaining why.
- The target-tool spec is syntactically valid for the named tool (the skill emits a smoke-test stub the operator can paste into the tool's API and get a 200).

## What this skill does NOT do

- Does not actually call the email tool's API. The skill produces specs; the operator applies them.
- Does not design the sequence body. Use `email-sequence-design`.
- Does not measure trigger fire-rate. The decay watcher reads metrics post-fire.
- Does not invent events that aren't in events.yaml. If the design needs a new event, the skill emits a substrate proposal pointing to the product engineering team.

## Refusal patterns

- **substrate-gap** — any required layer missing.
- **events-yaml-missing** — bootstrap mode is the remediation; default mode refuses.
- **events-yaml-stale** — last_updated past freshness window.
- **cohort-not-found** — `--cohort` not declared in events.yaml.
- **broadcast-trigger** — `enter_on: always` or no `exit_on` set is refused per `one-segment-one-trigger`.
- **decommissioned-event** — using an event with `last_observed` past 90 days requires explicit `--accept-stale-events` flag and a substrate-cited reason.

## See also

- `email-sequence-design` — produces the sequence the trigger routes to.
- `email-engagement-decay-watcher` — flags decay on sequences that this skill triggered.
- `templates/events-yaml-example.yaml` — starter template.
- `knowledge/patterns/one-segment-one-trigger.md`
- `knowledge/patterns/engagement-decay-as-relevance-signal.md`
