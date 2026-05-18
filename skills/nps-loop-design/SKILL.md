---
name: nps-loop-design
description: Design a closed-loop NPS program (survey timing, response routing, score-action mapping) with a measurement contract. Promoters route to references and reviews; passives to product feedback; detractors to save calls or honest fit-close per ICP band.
version: 0.1
amplifies: head of CS, head of lifecycle, head of marketing, RevOps
masters: Frederick Reichheld (NPS originator; loyalty research; closed-loop discipline), Rob Markey (NPS practitioner; closed-loop economics), Patrick Campbell (NPS validity research at scale), Lincoln Murphy (detractor-to-save mapping), Kelly Hall (NPS as program, not metric)
substrate_layers_required: [icp, voc, brand-voice]
patterns_grounded: [churn-prediction-vs-churn-diagnosis, retention-cohort-curves-over-blended-rates]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
preflight_refusal: substrate-gap, missing-icp
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
  - clients/{client}/brand-voice/brand-voice.md
---

# nps-loop-design

## Purpose

Design a closed-loop NPS program: when to survey, how to route responses, what action follows each score band, what measurement contract proves the program works. The skill writes a program spec that lifecycle tooling can implement; it does not send the surveys. Per Reichheld's loyalty-system frame, NPS is a closed-loop *program*, not a single number; the value comes from acting on the response, not collecting the response.

The detractor branch composes with `churn-diagnose` and `win-back-sequence`: detractors get the save-vs-let-go conditioning per ICP-fit band, not a default save call.

## Inputs

- `--client <client>` (required)
- `--survey-cadence <days>` (default: 90, Reichheld's quarterly cadence)
- `--trigger <transactional|relational|both>` (default: `both`), transactional surveys fire after specific events (onboarding completion, support resolution); relational surveys fire on the cadence.
- `--detractor-routing <save-call|honest-close|conditional>` (default: `conditional`, picks per ICP-fit band).
- `--promoter-routing <reference|review-request|case-study|all>` (default: `all`).

## Substrate reads

- `clients/{client}/icp/icp.md`, to read the ICP fit definition (drives detractor routing).
- `clients/{client}/voc/voc.md`, to mirror customer language in survey question.
- `clients/{client}/brand-voice/brand-voice.md`, to enforce voice gate on survey copy.

## Output contract

One artifact under `clients/{client}/retention/`:

`nps-program-spec-<YYYY-MM-DD>.md` with:

1. **Survey design**, single ultimate question, follow-up "what is the primary reason," send timing rules.
2. **Response routing**, score band × action mapping. Detractors route per ICP-fit conditioning (save vs honest close vs conditional triage); passives route to product feedback collection; promoters route to reference / review / case-study tracks.
3. **Voice constraints**, survey copy passes the kill-list / em-dash / throat-clearing gate.
4. **Measurement contract**, predicted close-the-loop rate, predicted promoter response-to-reference rate, predicted detractor reactivation rate. Resolution date.
5. **Cadence calendar**, when relational and transactional surveys fire.
6. **Substrate citations**.

## Quality criteria

- Refuses without ICP layer (detractor routing is conditioned on ICP fit).
- Refuses to design a program that surveys at higher than 90-day cadence per relational track (per Reichheld; survey fatigue compounds and the data quality drops).
- Detractor routing must be ICP-fit-aware. A program that sends every detractor to save call is operating on the orthodoxy that Reichheld himself questioned (per the contradiction file).
- Promoter routing has at least one branch that does NOT ask for a referral. (Reichheld: most NPS programs over-ask promoters and burn the goodwill.)
- Voice gate over all survey copy.
- Measurement contract carries a resolution date and a baseline.

## What this skill does NOT do

- Does not run the survey. Spec only.
- Does not score NPS in a calendar window. That is downstream tooling.
- Does not design the save call. That is `win-back-sequence` for detractors who fall in the save-eligible band.
- Does not analyze NPS trends; that is a `retention-cohort-analysis` cross-cut on NPS as a feature.

## Refusal patterns

- `substrate-gap`: missing ICP, voc, or brand-voice. Refuse hard.
- `cadence-too-frequent`: if `--survey-cadence` < 60 days for relational, refuse with a citation to Reichheld's survey fatigue research.

## Composes with

- Reads from: `clients/<client>/icp/icp.md`, `clients/<client>/voc/voc.md`, `clients/<client>/brand-voice/brand-voice.md`, optionally `clients/<client>/retention/churn-diagnosis-*.json` (to align detractor routing with diagnosis recommendation).
- Writes for: lifecycle tooling, `win-back-sequence` (for detractor save), `narrative-compose` (for promoter reference outreach copy), `retention-monthly` routine.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: predicted promoter-to-reference conversion, detractor-to-reactivation conversion, both verified at 90 days.

## See also

- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md` (detractor diagnosis precedes detractor save).
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md` (detractor routing conditioning).
- `skills/win-back-sequence/SKILL.md` (downstream of detractor route).
- `routines/retention-monthly.md`.
