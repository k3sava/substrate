---
name: support-quality-score
description: Score the support team across the four dimensions that compound on retention (response time, first-contact resolution, CSAT correlation, agent consistency). Outputs a team scorecard plus a per-agent breakdown when the tickets export carries an `agent_id` column. Refuses without ICP or with a tickets corpus where CSAT is absent on more than half the rows; the CSAT-correlation dimension is load-bearing.
version: 0.1
amplifies: head of support, head of CS, RevOps, head of operations
masters: Frederick Reichheld (loyalty math; CSAT-to-retention correlation as the load-bearing axis), Bain CX research (first-contact resolution as the strongest CES driver), Tien Tzuo (every contact is a renewal moment; consistency at the agent level), Lincoln Murphy (support-as-leading-indicator; team-scorecard discipline), Patrick Campbell (cohort-level agent variance is the most actionable team improvement lever)
substrate_layers_required: [icp, voc]
patterns_grounded: [tickets-are-product-feedback-channel, support-as-churn-leading-indicator, deflection-is-not-the-goal]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-tickets, missing-csat-coverage
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
---

# support-quality-score

## Purpose

Score the support team's quality across four dimensions that compound on retention. The four dimensions are:

1. **Response time**, median time-to-first-response and median time-to-resolution against operator-set targets. Slower than target costs CSAT and feeds the burning band of `churn-signal-from-support`.
2. **First-contact resolution rate**, share of tickets resolved without escalation. Per Bain CES research, FCR is the strongest single predictor of effort-driven loyalty.
3. **CSAT correlation**, the simple correlation between CSAT score and downstream retention behaviour. Per Reichheld's loyalty math, CSAT scores that don't correlate with retention are a measurement instrument problem, not a customer problem; the correlation itself is a quality signal.
4. **Agent consistency**, variance in CSAT and resolution-time across agents. Per Campbell's retention research, the most actionable team improvement is reducing the variance between top and bottom quartile agents, not raising the average.

The output is a team scorecard plus a per-agent breakdown when the export carries `agent_id`. Per the `tickets-are-product-feedback-channel` pattern, the scorecard reads against the same corpus that feeds `ticket-cluster-analysis`. Per the `deflection-is-not-the-goal` pattern, the scorecard does not reward deflection metrics; right-routing accuracy and CSAT-correlated outcomes are the load-bearing measures.

## Inputs

- `--client <client>` (required)
- `--tickets <path>` (required), tickets CSV (canonical shape: `templates/support-tickets-example.csv`).
- `--target-first-response-min <int>` (default: 30), median first-response target in minutes.
- `--target-resolution-hours <int>` (default: 4), median resolution-time target in hours.
- `--target-fcr-rate <float>` (default: 0.70), first-contact resolution target rate.
- `--target-csat-mean <float>` (default: 4.2), team CSAT target on the 1-5 scale.
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/icp/icp.md`, surfaces ICP-fit-banded reads (a high-fit account whose CSAT trends low is a different signal than a low-fit account whose CSAT trends low).
- `clients/{client}/voc/voc.md`, validates the verbatim language patterns the scorecard pulls from low-CSAT tickets.

## Tickets CSV contract

Required columns: `ticket_id`, `opened_at`, `category`, `subject`, `body`. Optional but valued (load-bearing for several dimensions): `csat`, `resolution_time_hours`, `first_response_minutes`, `escalated`, `resolved`, `agent_id`. When `csat` is missing on more than 50% of rows, the skill refuses with `missing-csat-coverage` because the CSAT-correlation dimension cannot be computed against thin signal.

## Process

1. **Preflight**. Verify ICP layer, tickets path, required columns, and CSAT coverage above 50%. Refuse with structured codes.
2. **Team scorecard composition**. For each dimension, compute the raw metric, the target, the gap, and the dimension grade (A through F mapped from the gap to target). The four-dimension composite is a weighted average; the report shows both the composite and the per-dimension breakdown.
3. **Per-agent breakdown**. When `agent_id` is present, repeat the four-dimension computation per agent. Compute variance and inter-quartile range across agents per dimension. Surface the top quartile and bottom quartile by composite. Flag agents whose composite falls more than 1 SD below the team mean as the targeted-coaching list.
4. **CSAT-correlation read**. The simple correlation between CSAT score and: resolution time (negative correlation expected), escalation flag (negative correlation expected), priority level (no expected direction; a strong correlation here surfaces a routing or expectations problem). The correlations are reported alongside the scorecard.
5. **Bottom-quartile sample**. Pull 5 verbatim ticket excerpts from the lowest-CSAT bin to surface the team-level themes. The excerpts feed back into `ticket-cluster-analysis` for the next monthly run and are tagged for `help-content-gap-detect` consideration.
6. **Output**. Write three artifacts: markdown scorecard, JSON sidecar, per-agent CSV.

## Output contract

Three artifacts under `clients/{client}/support/`:

1. `support-quality-score-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Composite team score + per-dimension grades.
   - Targets vs actuals table.
   - CSAT correlation table (CSAT vs resolution-time, CSAT vs escalation, CSAT vs priority).
   - Per-agent quartile read (top quartile, bottom quartile, named coaching list).
   - Bottom-quartile sample excerpts (verbatim).
   - Team-improvement recommendations (specific, dimension-pinned).
   - Substrate citations.
2. `support-quality-score-{YYYY-MM-DD}.json`, structured per-dimension and per-agent payload.
3. `support-quality-score-agents-{YYYY-MM-DD}.csv`, per-agent scorecard for the team-lead's review.

## Quality criteria

- Refuses with `missing-csat-coverage` when CSAT is on under 50% of rows. Without coverage, the CSAT-correlation dimension cannot run and the scorecard misleads.
- Does not score a single agent if their ticket count is below 10 in the corpus; underpowered, the variance estimate is noise. Such agents appear in the report as `under-powered` with their counts.
- The scorecard separates the team composite from per-agent composites. A team passing on average can carry a long tail of bottom-quartile agents; the agent breakdown surfaces that drift.
- The targets are operator-set; the report records the targets used at the top of every artifact. A scorecard re-run with different targets is a different scorecard; the targets are part of the audit trail.
- Bottom-quartile excerpts are verbatim; the skill never paraphrases customer language.

## What this skill does NOT do

- Does not compose agent-level coaching plans. The targeted-coaching list is the input to coaching, not the coaching itself.
- Does not predict CSAT trajectory. The scorecard is a snapshot read.
- Does not run an experiment. Variant testing is `deflection-experiment-design`.
- Does not write performance reviews. The artifact is a quality scorecard, not an HR record; the operator decides how to use it.
- Does not invent target values; the operator must set them.

## Refusal patterns

- `substrate-gap`: missing ICP or VoC layer.
- `missing-tickets`: tickets path not present.
- `schema-mismatch`: required columns absent.
- `missing-csat-coverage`: CSAT present on under 50% of rows; the CSAT-correlation dimension cannot run.
- `too-few-tickets`: the corpus has under 50 tickets; the team-level read produces noise.
- `under-powered-agents`: a warning (not refusal) when more than 30% of agents have under 10 tickets.

## Composes with

- Reads from: tickets CSV, ICP layer, VoC layer.
- Writes for: `ticket-cluster-analysis` (low-CSAT excerpts feed the next cluster run), `csat-loop-design` (the CSAT-correlation read informs the CSAT program design), `churn-signal-from-support` (response-time elevation findings cross-reference the per-account spike read), `help-content-gap-detect` (bottom-quartile clusters surface gap candidates).
- Triggered by: monthly support cluster routine, quarterly support team review, post-experiment debrief.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: predicted improvement on the bottom-quartile composite at 90 days; the team lead picks the targeted agent list and the operator records whether the prediction held.

## See also

- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `knowledge/patterns/support-as-churn-leading-indicator.md`
- `knowledge/patterns/deflection-is-not-the-goal.md`
- `templates/support-tickets-example.csv`
- `skills/ticket-cluster-analysis/SKILL.md`
- `skills/churn-signal-from-support/SKILL.md`
- `routines/support-cluster-monthly.md`
