---
name: preflight
description: The single ship gate. Composes voice-enforce + substrate-cited + refusal-pattern + synth-audience + persona-appropriate. Returns pass/fail with diagnostic. Nothing ships without it.
version: 0.1
amplifies: every shipping operator
masters: Charity Majors (testing in production with safety nets), John Allspaw (preflight checks in ops), NASA flight readiness review, Atul Gawande (Checklist Manifesto), Hamel + Shreya (eval-as-gate), Anthropic safety evaluations, Linear release-readiness, Vercel preview-as-gate, Stripe API stability checks
substrate_index_version: 2026-05-08
substrate_layers_required: [positioning, icp, voc, competitive, product-knowledge, conversion-narrative, brand-voice, market-context, roadmap, strategy]
preflight_refusal: substrate-gap
---

# preflight

## Purpose

The composition that decides whether an asset can ship. One verb, multiple gates, single answer.

## Inputs

- `--client <client>`
- `--asset <path>`
- `--bet <bet-id>` (optional — links preflight to a bet contract)
- `--strict | --advisory`

## Process

1. Run **voice-enforce** (strict).
2. Run **refusal-pattern check** (kill-list, em-dash, throat-clearing, generic-AI cadence).
3. Run **substrate-cited check** (every specific claim cites a substrate path; if asset is under a bet, bet's substrate-cited list is the floor).
4. Run **synth-audience** against pinned personas (default rubric: outcomes, differentiation, voice, persona-fit).
5. Run **persona-appropriate** check (does the asset's voice match the audience persona's communication norm).
6. Aggregate: pass / advisory / fail per gate.
7. Compute overall: ALL gates pass → ship. ANY gate fail in strict → block. Mixed advisory → operator decision logged.
8. Write preflight log to `clients/<client>/logs/preflight-<asset-id>-<date>.log`.

## Output

A pass/fail ruling + per-gate diagnostic + log row.

## Gates

This is the gate composition itself.

## Composes with

Reads from: every other gate skill.
Writes for: every shipping workflow.
Triggered by: every asset workflow before ship.

## Refusal patterns

- Asset not yet voice-checked AND operator requesting ship → reject; run gates first.
- Operator override → permitted but logged with override-reason; counts in calibration.
- Asset under a bet but bet's substrate-cited is empty → reject; the bet failed bet-open's gate retroactively.

## Calibration

Tracked across taste-types (every shipped asset's preflight result feeds calibration). The ship→learn workflow uses preflight history to identify systematic blind spots.

## Substrate preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/substrate/00-INDEX-10-layers-2026-04-30.md`. If any required layer is `thin` or `partial`, the skill returns:

```
SUBSTRATE-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.

