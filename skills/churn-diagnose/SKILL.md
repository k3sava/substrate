---
name: churn-diagnose
description: Diagnose population-level churn drivers from a churned-accounts CSV plus events history. Surfaces ranked drivers by population coverage × addressability, condition-aware on the save-everyone-vs-let-the-wrong-fit-go contradiction. Refuses without ICP layer.
version: 0.1
amplifies: PMM lead, head of CS, head of lifecycle, RevOps, founder
masters: Tomasz Tunguz (cohort-driver analysis upstream of prediction), Patrick Campbell (retention research at scale; cohort-level driver isolation), Frederick Reichheld (loyalty-system frame; churn as upstream symptom), Bridget Gleason (CS quota-carrying expansion; misfit churn correction), Lincoln Murphy (save-program orthodoxy; counter-position), Nick Mehta (Customer Success Economy), Reforge faculty (cohort-segmented retention)
substrate_layers_required: [icp, voc, positioning, product-knowledge]
patterns_grounded: [churn-prediction-vs-churn-diagnosis, retention-cohort-curves-over-blended-rates]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
preflight_refusal: substrate-gap, missing-churned-accounts, missing-icp
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
  - clients/{client}/positioning/positioning.md
---

# churn-diagnose

## Purpose

Given a list of churned accounts plus the events history that led up to each churn, surface the ranked drivers of churn at the cohort level, score each driver by population coverage and addressability, and condition the recommended response on the save-everyone-vs-let-the-wrong-fit-go contradiction. The skill does not predict which account will churn next; it diagnoses why accounts in the cohort that already churned, churned. Diagnosis precedes prediction. Position the prediction model later if the diagnosis names an addressable driver and prediction would help target intervention.

## Inputs

- `--client <client>` (required)
- `--churned <path>` (required), CSV at `clients/<client>/retention/churned-accounts-<YYYY-MM>.csv`. Required columns: `account_id`, `user_id`, `signup_date`, `churn_date`, `plan_at_churn`, `arr_at_churn`, `icp_fit_score`. Optional: `team_size_at_churn`, `signup_source`, `persona`, `first_value_event_hit`, `days_to_first_value`, `activation_event_hit`, `last_session_date`, `sessions_30d_pre_churn`, `support_tickets_30d_pre_churn`, `nps_score_last`, `churn_reason_self_reported`.
- `--events <path>` (optional), events CSV for usage decay / activation cross-checks.
- `--support-tickets <path>` (optional), support ticket export for cluster analysis. Columns: `ticket_id`, `account_id`, `created_ts`, `category`, `text` (optional).
- `--top-drivers <int>` (default: 5), how many drivers to surface.

## Substrate reads

- `clients/{client}/icp/icp.md`, to read the ICP fit definition and anti-ICP characteristics.
- `clients/{client}/voc/voc.md`, to cross-check churn reasons against documented customer language.
- `clients/{client}/positioning/positioning.md`, to flag drivers that imply positioning drift.
- `clients/{client}/product-knowledge/product-knowledge.md`, to flag drivers tied to specific feature gaps.

## Output contract

Three artifacts under `clients/{client}/retention/`:

1. `churn-diagnosis-<YYYY-MM-DD>.md`, narrative-friendly markdown with:
   - **Cohort summary**: number of churns, total ARR lost, ARR by plan, ARR by ICP-fit band.
   - **Ranked drivers**: each driver scored on (a) population coverage (% of churns it explains) and (b) addressability (1=hard product change, 5=onboarding tweak). Rank score = coverage × addressability.
   - **ICP-fit conditioning**: split the cohort by ICP fit (high-fit / mid-fit / low-fit), and for each split call out which drivers dominate. This is the substrate that `win-back-sequence` reads to pick the contradiction position.
   - **Activation gap**: % of churned accounts that never hit the activation event, segmented by signup source / persona.
   - **Usage decay pattern**: distribution of sessions in the 30 days pre-churn.
   - **Support cluster signals**: ticket categories most prevalent among churned accounts (when support data present).
   - **NPS distribution**: NPS score distribution among churned accounts (when present).
   - **Self-reported reason cluster**: word-stem cluster of operator-coded `churn_reason_self_reported` field.
   - **Save-vs-let-go recommendation per ICP-fit band**: per the conditioning, names which contradiction position to apply (Murphy/Mehta save program for high-fit late-stage; Reichheld correction for low-fit early-stage; mixed for mid-fit).
2. `churn-diagnosis-<YYYY-MM-DD>.json`, structured drivers, scores, ICP-band splits.
3. `churn-diagnosis-<YYYY-MM-DD>-drivers.csv`, driver table for downstream filtering.

## Quality criteria

- Refuses to run without the ICP layer. Per the contradiction conditioning, ICP fit is the gating variable for save-vs-let-go decisions; without ICP, the skill cannot recommend a save program.
- Refuses to print a "top driver" without naming both coverage and addressability. A driver explaining 5% of churn that is highly addressable is interesting; a driver explaining 60% of churn that is unaddressable in 90 days is also interesting; the rank surfaces both axes, not a single conflated number.
- Activation gap is reported only if events data are provided OR the churned-accounts CSV carries the `activation_event_hit` column. If neither, the skill skips that section and notes the data gap.
- Self-reported churn reason clustering uses simple word-stem buckets, not LLM clustering. The output records the bucket map for inspection.

## What this skill does NOT do

- Does not predict future churn. That is a downstream activity; this skill explicitly refuses prediction language. Per `churn-prediction-vs-churn-diagnosis` pattern.
- Does not write save sequences. That is `win-back-sequence`, which reads this output as input.
- Does not interview churned customers. The frontline-contact pattern + win-loss-interview skill does that.
- Does not infer ICP fit. The CSV must carry `icp_fit_score`. If absent, the skill warns and falls back to firmographic proxies but flags the output as `low-confidence`.

## Refusal patterns

- `substrate-gap`: missing ICP layer. Refuse hard.
- `missing-churned-accounts`: CSV not present or missing required columns.
- `low-confidence` (warning, not refusal): if ICP fit score is missing from CSV.

## Composes with

- Reads from: `clients/<client>/retention/churned-accounts-*.csv`, `clients/<client>/icp/icp.md`, `clients/<client>/voc/voc.md`, optional events CSV, optional support tickets CSV.
- Writes for: `win-back-sequence` (which reads ICP-band recommendations + drivers), `retention-monthly` routine (which reviews drivers monthly), `positioning-forge` (when drivers indicate positioning drift), `icp-cut` (when drivers indicate the ICP needs sharpening).
- Triggered by: monthly retention review, ARR loss escalation, large-customer churn.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: drivers named as addressable should produce measurable lift in the next quarter's cohort retention; drivers named as non-addressable should see the same population continue to churn (which is the discipline check on diagnosis honesty).

## See also

- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md` (load-bearing).
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md` (conditioned by ICP fit + time-in-product).
- `templates/churned-accounts-example.csv` (canonical input shape).
- `skills/win-back-sequence/SKILL.md`.
- `skills/icp-cut/SKILL.md`.
- `routines/retention-monthly.md`.
