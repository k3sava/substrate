---
name: retention-cohort-analysis
description: Compute weekly cohort retention curves from a real events export. Detect slope changes, surface improving / stable / decaying cohorts, identify elevated-churn cohorts by signup source / persona / first-week action. Refuses on missing events export or substrate gap.
version: 0.1
amplifies: PMM lead, growth lead, head of CS, head of lifecycle, RevOps
masters: Casey Winters (retention curve as the test of product retention), Reforge faculty (cohort segmentation as load-bearing analysis), Tomasz Tunguz (cohort decomposition for SaaS), Mike Maples Jr. (cohort divergence as truth-telling), Lenny Rachitsky (named-company retention examples), Wes Bush (PLG cohort segmentation), Kyle Poyar (PLG benchmarks against cohort tables)
substrate_layers_required: [icp, positioning]
patterns_grounded: [retention-cohort-curves-over-blended-rates, aha-moment-defines-activation]
preflight_refusal: substrate-gap, missing-events-export
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
---

# retention-cohort-analysis

## Purpose

Take a real events export and produce the floor artifact for retention work: a cohort retention table with rows = cohorts (signup week or month) and columns = weeks since signup, plus a slope-change detector, plus segment splits by signup source / persona / first-week action. The skill refuses to report blended retention without cohort decomposition behind it. Outputs feed `churn-diagnose`, `expansion-trigger-detect`, and `retention-monthly` routine.

## Inputs

- `--client <client>` (required)
- `--events <path>` (required), events CSV at `clients/<client>/events/exports/<YYYY-MM>.csv`. Required columns: `user_id`, `event_name`, `ts`. Optional: `property_signup_source`, `property_persona`, `property_plan`, `property_team_size`.
- `--cohort-grain <week|month>` (default: `week`)
- `--max-week <int>` (default: 12), maximum retention week to compute (truncates table at this column)
- `--activation-event <name>` (optional), if not given, defaults to value-event present in `clients/<client>/retention/activation-audit-<latest>.json`. If absent, falls back to `first_value_event`.
- `--min-cohort-size <int>` (default: 30), cohorts smaller than this are tagged early-signal and excluded from slope-change detection.

## Substrate reads

- `clients/{client}/icp/icp.md`, to interpret per-segment retention.
- `clients/{client}/positioning/positioning.md`, to cross-check whether the lowest-retention segment matches the documented anti-ICP.
- `clients/{client}/retention/activation-audit-*.json` (when present), to read the canonical activation event.

## Output contract

Three artifacts under `clients/{client}/retention/`:

1. `cohort-retention-<grain>-<YYYY-MM-DD>.md`, narrative-friendly markdown table with cohort retention (W1, W2, ..., W_max), slope-change detection, segment splits by source / persona / first-week-activation.
2. `cohort-retention-<grain>-<YYYY-MM-DD>.csv`, machine-readable cohort table (rows = cohort, columns = w1..wN, plus n).
3. `cohort-retention-<grain>-<YYYY-MM-DD>.json`, structured data with cohort_table, splits, and slope_change_flags for downstream skills.

Each markdown output includes:
- Cohort retention table (rows = cohort label, columns = w1..wN, plus n).
- Activation-conditioned table (same cohorts split into "activated within window" vs "did not activate").
- Source / persona splits at week-N retention for the most recent eligible cohort.
- Slope-change flags (cohorts where retention bent down or up versus a 4-cohort trailing baseline).
- Substrate citations.

## Quality criteria

- Refuses to print a blended retention number without the cohort table behind it. Per the cohort-curves-over-blended-rates pattern.
- Cohorts smaller than `--min-cohort-size` are flagged early-signal and excluded from slope-change detection (Reforge minimum-cohort guidance).
- Retention is computed off `session_active` events within 7-day windows, not "logged in this calendar week."
- Slope-change detector compares each cohort's W4 retention to the trailing 4-cohort mean. Flag fires at greater than 1.5 standard deviations, citing the math.

## What this skill does NOT do

- Does not invent the activation event. Defers to `activation-funnel-audit` output.
- Does not run churn diagnosis. That is `churn-diagnose`.
- Does not write strategy. The output is structured data + a one-paragraph headline.
- Does not predict future retention. Predictive modeling is downstream and conditioned on the cohort decomposition this skill produces.

## Refusal patterns

- `substrate-gap`: refuses if ICP layer missing. Cannot interpret per-segment retention without an ICP definition.
- `missing-events-export`: refuses if CSV not present or missing required columns.
- `early-signal-only`: if every cohort in the export is below min-cohort-size, the skill writes a stub artifact tagged early-signal and exits non-zero (3).

## Composes with

- Reads from: `clients/<client>/events/exports/`, `clients/<client>/icp/icp.md`, `clients/<client>/retention/activation-audit-*.json`.
- Writes for: `churn-diagnose` (which reads cohort table + slope flags), `expansion-trigger-detect` (which reads per-cohort retention to size expansion-eligible accounts), `retention-monthly` routine (which uses the artifact as the working document).
- Triggered by: monthly retention review, slope-change alarm from prior month, post-launch retention check, ICP redefinition.

## Calibration

Tracked under taste-types `retention` and `growth`. Brier signal: slope-change flags filed against cohorts predicted to recover or persist; verified at next month's read.

## See also

- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md` (load-bearing).
- `knowledge/patterns/aha-moment-defines-activation.md` (activation-conditioned splits).
- `templates/cohort-table-example.md` (canonical output shape).
- `skills/activation-funnel-audit/SKILL.md`.
- `routines/retention-monthly.md`.
