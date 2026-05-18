---
name: activation-funnel-audit
description: Diagnose the path from signup → first-value-event → retained-week-2. Outputs structured funnel with conversion at each step, drop-off cohorts, and time-to-aha statistics. Names the activation event, refuses if substrate cannot back the candidate.
version: 0.1
amplifies: PMM lead, growth lead, head of CS, head of lifecycle, founder
masters: Casey Winters (retention-curve segmentation as the activation procedure), Lenny Rachitsky (named-company aha moments), Andrew Chen (retention curve as the only honest test), Brian Balfour (habit-cadence test for activation events), Sean Ellis (PMF leading-indicator architecture), Kieran Flanagan (funnel-as-substrate, not narrative), Wes Bush (PLG product-led growth onboarding), Reforge faculty (cohort-segmented activation)
substrate_layers_required: [icp, voc, product-knowledge]
patterns_grounded: [aha-moment-defines-activation, retention-cohort-curves-over-blended-rates]
preflight_refusal: substrate-gap, missing-events-export, no-activation-candidate
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/product-knowledge/product-knowledge.md
---

# activation-funnel-audit

## Purpose

Diagnose the activation funnel from a real events export. The skill does not invent activation; it tests candidate value events against retention curve divergence and names the event that produces the steepest separation. It writes a structured funnel artifact with per-step conversion, drop-off cohort segments, and time-to-aha statistics. Skills downstream (retention-cohort-analysis, churn-diagnose, win-back-sequence) read its output as the canonical activation definition for the client.

## Inputs

- `--client <client>` (required)
- `--events <path>` (required), CSV at `clients/<client>/events/exports/<YYYY-MM>.csv` with columns: `user_id, event_name, ts, property_*`. The skill auto-detects optional columns (signup source, persona, plan, team_size).
- `--candidate-events <event1,event2,...>` (optional), events to test as activation. Default: read from `clients/<client>/product-knowledge/value-events.md` if present; else use any non-onboarding event with at least 200 occurrences.
- `--window-hours <int>` (optional, default 24), the activation window after signup in which the candidate event must fire.
- `--retention-week <int>` (optional, default 2), the week-N retention used to score candidate events.

## Substrate reads

- `clients/{client}/icp/icp.md`, to segment results by persona axis.
- `clients/{client}/product-knowledge/product-knowledge.md`, to enumerate candidate value events and confirm event taxonomy.
- `clients/{client}/voc/voc.md` (when present), to cross-reference the operator-named activation against what customers say is the moment they got value.

## Output contract

The skill writes a markdown summary to `clients/{client}/retention/activation-audit-<YYYY-MM-DD>.md` with these sections, in order:

1. **Activation candidate test results**, table: candidate event × cohort split (activated within window vs not) × week-N retention. The candidate with the steepest retention-curve divergence is named the activation event.
2. **Funnel conversion**, table: signup → onboarding-started → onboarding-completed → first-value-event → activation-event → week-1 active → week-N retained. Per-step conversion and absolute counts.
3. **Drop-off cohorts**, segments most affected at the largest drop, broken by signup source × persona × plan when those columns are present.
4. **Time-to-aha statistics**, distribution (median, p75, p90) of time from signup to the named activation event for users who ever activate.
5. **Substrate citations**, every claim cites a path; the activation choice cites the candidate-test table row that named it.
6. **Refusal log**, any candidates that did not produce statistically meaningful divergence (cohort < 30 or curve gap < 5 points), with the reason.

The skill also writes a JSON sidecar `activation-audit-<YYYY-MM-DD>.json` with structured numbers for downstream skills to consume without re-parsing markdown.

## Quality criteria

- Refuses to name an activation event if no candidate produces a divergence ≥ 10 points at the chosen retention week and the activated cohort has at least 30 users (per Reforge minimum-cohort guidance and the aha-moment pattern).
- Refuses to run if the events CSV does not contain at least `signup` and one non-onboarding event in every cohort being tested.
- Refuses to substitute a UX milestone (onboarding-completed) for the activation event when a behavioral event tests stronger.
- All outputs cite the events CSV path with a row count and ingestion date.

## What this skill does NOT do

- Does not invent activation. If candidates fail the divergence test, the skill refuses and surfaces "no defensible activation candidate" with the recommended next steps (run more candidates, check event taxonomy, talk to CS about value moments).
- Does not write narrative. The output is structured data + a one-paragraph headline. Narrative work belongs to `narrative-compose`.
- Does not score retention curves end-to-end. That is `retention-cohort-analysis`.
- Does not segment by ICP fit score (that runs through `churn-diagnose` against churned cohorts).

## Refusal patterns

- Substrate gap (no ICP, no product-knowledge): refuse with `substrate-gap`. Cannot test candidate events without knowing which events the product treats as value events.
- Events export missing: refuse with `missing-events-export`. Skill cannot diagnose a funnel from desk research.
- No candidate produces meaningful divergence: refuse with `no-activation-candidate`. Surface candidates and divergence numbers; the next step is more candidates or a product-level investigation.

## Composes with

- Reads from: `clients/<client>/events/exports/`, `clients/<client>/icp/icp.md`, `clients/<client>/product-knowledge/`.
- Writes for: `retention-cohort-analysis` (which reads activation event from this output), `churn-diagnose` (which uses the activation event as a baseline driver), `win-back-sequence` (which composes saves around the activation event).
- Triggered by: monthly retention review, new-cohort drift detection, product-launch retention check, ICP redefinition.

## Calibration

Tracked under taste-types `retention` and `growth`. Brier signal: the named activation event's predicted retention lift (e.g., "users who hit X retain at 50%+ at W4") is verified against the next 4 cohorts.

## See also

- `knowledge/patterns/aha-moment-defines-activation.md` (load-bearing).
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`.
- `skills/retention-cohort-analysis/SKILL.md`.
- `skills/churn-diagnose/SKILL.md`.
- `routines/retention-monthly.md`.
