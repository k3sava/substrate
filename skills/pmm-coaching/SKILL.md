---
name: pmm-coaching
description: A skill the operator runs on themselves and direct reports. Uses calibration history, retrospective patterns, and a per-level competency framework to surface what to develop next. Treats career growth as a measurement loop.
version: 0.1
amplifies: head of PMM, head of GTM, individual operators self-coaching
masters: Will Larson (Staff Engineer — career-as-loop framing), Camille Fournier (The Manager's Path), Lara Hogan (resilient management), Ashley Herbert Popa (skill frameworks per PMM level), Ashley Bass (intake-interview-as-PMM-craft), Marty Cagan (product-side coaching), David Kennedy (Good Inside — repair, MGI, identity-vs-behavior in leadership)
substrate_layers_required: [strategy, voc]
patterns_grounded: [principal-ic-as-force-multiplier, generalists-with-taste, parenting-meets-leadership, decision-quality-through-process-not-willpower]
contradictions_aware: [criticize-in-public-vs-praise-public-criticize-private, specialist-vs-generalist-hiring, pm-prototype-vs-pm-up-level]
preflight_refusal: substrate-gap, missing-calibration-history
required_reads:
  - clients/{client}/team/competency-framework.md
  - goals/ledger.md
---

# pmm-coaching

## Purpose

Most career conversations are unstructured opinion. This skill makes career growth a measured loop: calibration history per (operator, taste-type), competency-framework gaps, retrospective patterns, next-skill-to-develop. Authority follows accuracy; growth follows targeted reps.

## Inputs

- `--client <client>` (required)
- `--operator <name>` (required)
- `--mode <self-review|peer-coach|level-check|next-skill>`
- `--horizon <quarter|half|year>`

## Substrate reads

- `goals/ledger.md`, the operator's calibration history.
- `team/competency-framework.md`, the per-level competency map.
- `decisions/`, the operator's decision history.
- `voc/processed/`, where the operator's outputs landed in customer reality.

## Output contract

- `team/coaching/<operator>/<date>.md`, the structured review.
- `team/coaching/<operator>/next-quarter.md`, the development goal.
- A row in `goals/ledger.md` with a calibrated prediction on the development goal's impact.

## Conditions awareness

- `criticize-in-public-vs-praise-public-criticize-private`: org maturity decides. Default to praise-public-criticize-private until the team has logged trust capital.
- `specialist-vs-generalist-hiring`: org stage + AI-augmentation level decide which way the next role tilts.
- `pm-prototype-vs-pm-up-level`: the operator's AI-tool fluency decides whether to grow as a prototype-PM or an orchestrator-PM.

## Quality criteria

- Refuses a coaching review without the operator's calibration history readable.
- Refuses to set a next-skill without a measurement contract.
- Flags drift: operators with declining calibration scores who haven't received coaching in 90 days.

## See also

- `skills/score-goal/`, where calibration scores come from.
- `skills/mental-models/`, the decision-quality discipline.
- `knowledge/patterns/principal-ic-as-force-multiplier.md`.
- `knowledge/contradictions/specialist-vs-generalist-hiring.md`.
