---
name: expansion-trigger-detect
description: Identify accounts ready for expansion from behavioral signals (feature adoption, seat growth, value-event density, threshold-crossing for pricing tiers), not tenure. Outputs scored trigger list for CS / AE workflows or in-product nudges.
version: 0.1
amplifies: head of CS, head of sales, RevOps, head of lifecycle
masters: Bridget Gleason (CS-led expansion off behavioral signals), Tomasz Tunguz (NDR mechanics; behavior is the cause, tenure the correlate), Patrick Campbell (willingness-to-pay tracks usage curve), Lincoln Murphy (account-success trigger frameworks), May Habib (account scoring), Lenny Rachitsky (expansion-trigger essays), Wes Bush (PLG expansion mechanics)
substrate_layers_required: [icp, positioning, product-knowledge]
patterns_grounded: [behavioral-expansion-signals-beat-tenure, retention-cohort-curves-over-blended-rates]
preflight_refusal: substrate-gap, missing-events-export
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/product-knowledge/product-knowledge.md
---

# expansion-trigger-detect

## Purpose

Read usage signals (feature adoption breadth, value-event density per active week, seat or workspace growth, integration count, threshold proximity for the next pricing tier), score each account on adoption-breadth × density × growth-rate × threshold-proximity, and emit an expansion trigger list for CS / AE motion or in-product nudges. Tenure is allowed as a secondary axis; never as the primary gate. Per the `behavioral-expansion-signals-beat-tenure` pattern.

## Inputs

- `--client <client>` (required)
- `--events <path>` (required), events CSV. Same schema as `activation-funnel-audit`. Required: `user_id`, `event_name`, `ts`. Optional: `property_team_size`, `property_plan`, `property_workspace_id`.
- `--score-band-thresholds <ranges>` (optional, default: `cold:0-30,warm:30-60,hot:60-80,burning:80-100`), score band boundaries (0-100).
- `--min-tenure-days <int>` (default: 7), accounts younger than this are excluded; behavioral signals before this are unreliable.
- `--lookback-days <int>` (default: 30), window for value-event density and growth-rate computation.

## Substrate reads

- `clients/{client}/icp/icp.md`, to identify which accounts match the high-fit profile (highest expansion potential).
- `clients/{client}/product-knowledge/product-knowledge.md`, to read the value-event taxonomy and the pricing tier thresholds.
- `clients/{client}/positioning/positioning.md`, to read the pricing tier promise and frame the trigger language.

## Output contract

Three artifacts under `clients/{client}/retention/`:

1. `expansion-triggers-<YYYY-MM-DD>.md`, narrative-friendly markdown with:
   - **Score distribution** by band.
   - **Trigger queue**, top 20 accounts by score, with band, rationale, recommended action.
   - **Cohort triggers**, accounts where multiple workspaces / seats grew in the lookback window.
   - **Threshold-proximity flags**, accounts within 10% of a published pricing tier threshold (e.g., 10/12 seat plan).
   - **Substrate citations**.
2. `expansion-triggers-<YYYY-MM-DD>.json`, structured per-account scoring.
3. `expansion-triggers-<YYYY-MM-DD>.csv`, per-account row table for CS workflow tools.

## Quality criteria

- Refuses to score on tenure alone. The behavioral signals (adoption-breadth, density, growth, threshold-proximity) must be in the score; tenure may modify it as a tie-breaker.
- Refuses to score accounts younger than `--min-tenure-days`. Behavioral signal in the first week is unreliable.
- Score components are weighted explicitly and recorded in the JSON output. Default weights (sum to 1.0): adoption-breadth 0.30, value-event density 0.30, growth-rate 0.25, threshold-proximity 0.15. Operators can override at output review; do not override silently.
- Threshold-proximity is computed against named pricing tiers if `product-knowledge` declares them; otherwise the skill warns and skips this component.

## What this skill does NOT do

- Does not write the expansion email or the AE talk track. That is `narrative-compose` or `lp-ship` downstream, with this output as input.
- Does not gate the CS quota. The trigger list is a recommendation; humans pick which to action.
- Does not predict expansion willingness-to-pay. The score is intent-proxy, not price.
- Does not infer from tenure. Tenure is a tie-breaker, not a primary axis.

## Refusal patterns

- `substrate-gap`: missing ICP or product-knowledge. The high-fit identification depends on ICP; the value-event taxonomy and tier thresholds depend on product-knowledge.
- `missing-events-export`: CSV not present or missing `user_id` / `event_name` / `ts`.

## Composes with

- Reads from: `clients/<client>/events/exports/`, `clients/<client>/icp/icp.md`, `clients/<client>/product-knowledge/`.
- Writes for: CS / AE workflow tools (CSV ingest), `narrative-compose` (for in-product nudges), `retention-monthly` routine.
- Triggered by: weekly expansion-watcher routine, post-launch expansion check, pricing tier change.

## Calibration

Tracked under taste-types `expansion` and `growth`. Brier signal: triggers in the `hot` and `burning` bands are predicted to convert at higher rate than `cold` and `warm`; verified at next-month read.

## See also

- `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md` (load-bearing).
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`.
- `routines/expansion-watcher.md`.
- `skills/retention-cohort-analysis/SKILL.md`.
