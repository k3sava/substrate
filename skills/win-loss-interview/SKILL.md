---
name: win-loss-interview
description: Generates a structured win/loss interview script grounded in the canonical positioning and ICP cohort, captures the response template, scores each interview against an objective rubric, and aggregates across interviews into deal-pattern drivers ranked by frequency × loss-amount. Writes per-deal artefact and quarter aggregate.
version: 2.0
amplifies: PMM, sales lead, RevOps, founder
masters: Carl Schmidt (win-loss as a discipline, not a debrief), Ryan Sorley (Klue win-loss patterns), Anova / Frost & Sullivan (third-party win-loss methodology), April Dunford (alternatives = real competitors, including no-decision), Patrick Campbell (price + alternative are both signals), Bob Moesta (forces of progress, forces of resistance), Matt Dixon (FOMU vs FOMO mindset diagnosis)
substrate_layers_required: [voc, competitive, positioning, sales-pitch]
patterns_grounded: [frontline-as-pmm-substrate, status-quo-is-the-competitor, diagnose-before-execute, jtbd-as-buyer-mental-model]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-deal-record, missing-positioning
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# win-loss-interview

## Purpose

Win/loss isn't a debrief slide. It is structured customer research that surfaces the alternative the buyer chose (including no-decision, which is the largest alternative in most B2B categories), the decision drivers in their own words, the moment positioning failed, and the status-quo friction. This skill standardises the interview, scores each one against an objective rubric, and aggregates the corpus into ranked drivers per quarter.

## Modes

### `--mode script`
Generate an interview script tailored to the deal: positioning-aware questions, alternatives-considered prompts, JTBD switch-interview probes, contradiction-aware no-decision branches.

### `--mode capture`
Capture an interview against a structured template. Writes to `clients/<client>/win-loss/<deal-id>.md` with required frontmatter + sections.

### `--mode score`
Score a captured interview against the objective rubric (decision-driver clarity, alternatives surfaced, status-quo signal, quote-pulls verbatim, FOMU/FOMO diagnosis).

### `--mode aggregate`
Walk every per-deal artefact for the trailing quarter and produce ranked deal-pattern drivers, weighted by frequency × loss-amount.

## Inputs

- `--client <client>` (required)
- `--mode <script|capture|score|aggregate>` (required)
- `--deal-id <crm-id>` (required for script/capture/score)
- `--outcome <won|lost|no-decision|stalled>` (required for capture)
- `--alternative-considered <slug>` (e.g., `competitor:carrier-connect`, `status-quo`, `internal-build`, `no-decision`)
- `--participant <buyer-name>`
- `--transcript <path>` (required for score; the captured interview file)
- `--loss-amount <usd>` (required for capture if outcome ≠ won)
- `--quarter <YYYY-Qn>` (optional for aggregate; default = current quarter)

## Substrate reads

- `positioning/positioning-canonical-statement.md`: the canonical statement the script tests against.
- `competitive/<vendor>.md`: the head-to-head ledger, updated by capture.
- `competitive/status-quo.md`: dedicated file for no-decision losses.
- `voc/cadence-contract.md`: the cadence this skill respects.
- `clients/<client>/win-loss/`: per-deal coded interviews and quarter aggregates.

## Output contract

- `clients/<client>/win-loss/<deal-id>.md`: coded interview with frontmatter `{deal_id, outcome, alternative, decision_drivers, status_quo_factor, pricing_reaction, quote_pulls, score, mindset_diagnosis}`.
- `clients/<client>/win-loss/aggregate-<YYYY-Qn>.md`: quarter aggregate with ranked deal-pattern drivers + ranked alternatives + status-quo share + average loss amount.
- `clients/<client>/win-loss/<deal-id>.json`: machine-readable structured form.
- Optional patch proposals to `competitive/`, `positioning/`, `sales-pitch/` queued for `signal-routine`.

## Quality criteria

- Refuses without `--deal-id` (anti-fab: every claim cites a system of record).
- Refuses without canonical positioning statement (no positioning, no positioning-failure detection).
- Refuses to score without a transcript path.
- Refuses to aggregate with fewer than 5 captured interviews per quarter (cohort too small for honest pattern detection).
- Flags pattern emergence at N≥5 deals against the same alternative or with the same objection.

## Contradiction handling: no-decision-vs-named-competitor

The skill picks per-deal between Position A (no-decision is the real competitor) and Position B (named competitor is the real competitor) based on the captured alternative. The pick is logged on each artefact with conditioning rationale. Per `knowledge/contradictions/no-decision-vs-named-competitor.md`. The skill does not pick a global default.

## See also

- `skills/frontline-contact/`, the wider customer-contact cadence.
- `skills/tactical-empathy-discovery/`, the interview craft for the live conversation.
- `skills/status-quo-frame/`, what to do once status-quo emerges as the dominant alternative.
- `knowledge/patterns/status-quo-is-the-competitor.md`.
- `knowledge/patterns/jtbd-as-buyer-mental-model.md`.
