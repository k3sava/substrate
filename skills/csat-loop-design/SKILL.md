---
name: csat-loop-design
description: Design a closed-loop CSAT program (per-ticket survey timing, response routing, score-action mapping, voice gate, measurement contract). Promoter routing has a no-ask branch; detractor routing conditions on ICP fit per the save-everyone-vs-let-the-wrong-fit-go contradiction. Refuses without ICP layer or brand-voice layer.
version: 0.1
amplifies: head of CS, head of support, head of lifecycle, RevOps
masters: Frederick Reichheld (loyalty research; closed-loop discipline), Bain CX research (customer effort score; channel-forcing harms), Tien Tzuo (subscription-renewal math; every contact is a renewal moment), Lincoln Murphy (detractor routing; save-program orthodoxy and counter-position), Rob Markey (loyalty-system practitioner)
substrate_layers_required: [icp, voc, brand-voice]
patterns_grounded: [deflection-is-not-the-goal, tickets-are-product-feedback-channel]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
preflight_refusal: substrate-gap, missing-icp, missing-brand-voice
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
  - clients/{client}/brand-voice/brand-voice.md
---

# csat-loop-design

## Purpose

Design a closed-loop CSAT program. Per-ticket survey, single Likert question, single open-text follow-up, and a routing system that turns the response into action: promoters to references or reviews (with a no-ask branch required), passives to product feedback collection, detractors to save calls or honest closes per ICP-fit conditioning.

Per the `deflection-is-not-the-goal` pattern, the CSAT loop is part of the right-routing system; the metric is "customer got the right answer," not "tickets deflected." Per `tickets-are-product-feedback-channel`, the open-text survey response is product feedback substrate that flows back into the cluster analysis and the help-content gap queue.

The detractor branch composes with `churn-diagnose` and `win-back-sequence`: detractors route per ICP-fit band, not a default save call.

## Inputs

- `--client <client>` (required)
- `--cadence-floor-days <int>` (default: 14, the minimum days between surveys to the same account; lower values fail with `cadence-too-frequent`).
- `--detractor-routing <save-call|honest-close|conditional>` (default: `conditional`, picks per ICP-fit band).
- `--promoter-routing <reference|review-request|case-study|all>` (default: `all`; the no-ask branch is required regardless).
- `--no-ask-share <float>` (default: 0.30, fraction of promoters routed to the no-ask thank-you branch each cycle).
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/icp/icp.md`, drives detractor routing band selection.
- `clients/{client}/voc/voc.md`, mirrors customer language in the question wording.
- `clients/{client}/brand-voice/brand-voice.md`, drives the voice gate on copy.
- Optionally `clients/{client}/retention/churn-diagnosis-*.json`, aligns detractor routing with the latest diagnosis.

## Process

1. **Preflight**. Verify ICP, VoC, and brand-voice layers exist; refuse on gap. Verify `--cadence-floor-days >= 14` for per-ticket; refuse with `cadence-too-frequent` otherwise. (Per-interaction CSAT is tighter cadence than relational NPS, but a floor exists to prevent survey fatigue.)
2. **Read substrate**. Pull customer-language phrasing from VoC. Pull ICP fit definition from ICP layer. Pull brand-voice rules (kill-list, em-dash policy, throat-clearing rule) from brand-voice.
3. **Design survey copy**. Compose the single Likert question and the single follow-up open-text question, in the brand voice. Run the voice gate (kill-list, em-dash, throat-clearing). Refuse if the copy fails the gate.
4. **Compose routing logic**. For each band (promoter / passive / detractor), pick the route per the inputs and the contradiction conditioning. The detractor routing logic reads ICP fit if `--detractor-routing conditional`. The promoter routing must include the no-ask branch.
5. **Compose measurement contract**. Predicted close-the-loop rate, predicted promoter-to-reference rate, predicted detractor reactivation rate, baseline window, resolution date.
6. **Output**. Write the program spec markdown plus a structured JSON sidecar that lifecycle tooling can read.

## Output contract

Two artifacts under `clients/{client}/support/`:

1. `csat-program-spec-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Survey design (single Likert + single open-text follow-up; copy drafted in client brand voice).
   - Send timing rules (per-ticket-resolution; cadence floor; reopened-ticket exclusion).
   - Response routing (promoter / passive / detractor; per-band actions; ICP-fit conditioning logged with rationale).
   - No-ask branch (required; named with the percentage of promoters routed to it).
   - Voice gate result (passed; with the gate report inline).
   - Measurement contract (baseline window; predicted lift; resolution date).
   - Substrate citations.
2. `csat-program-spec-{YYYY-MM-DD}.json`, structured spec for lifecycle tooling.

## Quality criteria

- Refuses without ICP layer (detractor routing is conditioned on ICP fit).
- Refuses without brand-voice layer (voice gate cannot run without it).
- Refuses with `cadence-too-frequent` if cadence floor is below 14 days; per-interaction CSAT cadence floor is 14 days by default.
- Promoter routing must include a no-ask branch with at least 20% of promoters routed there. Fails the gate otherwise. Reichheld: most NPS / CSAT programs over-ask promoters and burn the goodwill.
- Voice gate: kill-list (12 words), em-dash, throat-clearing checks; refuses to write copy that fails.
- Detractor routing logs the conditioning that picked the position (ICP fit band, time-in-product, expansion potential).
- Measurement contract carries a baseline window and a resolution date.

## What this skill does NOT do

- Does not run the survey. Spec only; lifecycle tooling implements.
- Does not design the save call agenda. That is `win-back-sequence`.
- Does not score CSAT trends. Trend analysis is downstream tooling.
- Does not design relational NPS. That is `nps-loop-design` (separate program; do not blend per-interaction CSAT and per-relationship NPS).

## Refusal patterns

- `substrate-gap`: missing ICP, voc, or brand-voice. Refuse hard.
- `missing-icp`: ICP layer absent (detractor routing requires it).
- `missing-brand-voice`: brand-voice layer absent (voice gate requires it).
- `cadence-too-frequent`: cadence floor below 14 days. Per-interaction CSAT fatigue compounds quickly.
- `voice-gate-failed`: copy contains kill-list words, em-dashes in body, or throat-clearing openers. Refuse.

## Composes with

- Reads from: ICP, VoC, brand-voice; optional latest churn-diagnosis JSON.
- Writes for: lifecycle tooling, `win-back-sequence` (for save-eligible detractors), `narrative-compose` (for promoter reference outreach copy), `ticket-cluster-analysis` (open-text responses feed back into the next cluster run).
- Triggered by: program launch, monthly support cluster routine, customer-loop quarterly review.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: predicted close-the-loop rate (90 days), predicted promoter-to-reference conversion (90 days), predicted detractor reactivation (90 days). Honest losses count.

## See also

- `knowledge/patterns/deflection-is-not-the-goal.md`
- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`
- `templates/csat-survey-example.md`
- `skills/nps-loop-design/SKILL.md`
- `skills/win-back-sequence/SKILL.md`
- `routines/support-cluster-monthly.md`
