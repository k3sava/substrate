---
name: win-back-sequence
description: Design a win-back sequence per ICP-fit band, composing positioning + churn-diagnose findings + sender voice. Refuses without a churn-diagnose output for the cohort. Per-cohort sequence picks the save-vs-let-go contradiction position from the diagnosis recommendation.
version: 0.1
amplifies: head of CS, head of lifecycle, PMM lead, head of demand
masters: April Dunford (positioning grounds the value frame), Lincoln Murphy (Position A, full save program for high-fit late-stage), Frederick Reichheld (Position B, let wrong-fit go), Andy Raskin (narrative for the comeback frame), Joanna Wiebe (copywriting craft for emotional reactivation), Patrick Campbell (price-elasticity-aware sequencing), Lenny Rachitsky (cohort-specific sequence design)
substrate_layers_required: [positioning, voc, brand-voice, icp]
patterns_grounded: [churn-prediction-vs-churn-diagnosis, behavioral-expansion-signals-beat-tenure]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
preflight_refusal: substrate-gap, missing-diagnosis, missing-positioning, missing-voice
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/brand-voice/brand-voice.md
  - clients/{client}/voc/voc.md
---

# win-back-sequence

## Purpose

Compose a win-back email + in-product sequence per ICP-fit band, reading the churn-diagnose output to pick the save-vs-let-go contradiction position locally. The output is a sequence spec (per band: subject lines, body skeletons, send delays, channel mix) that downstream lifecycle tooling sends. The skill refuses without a churn-diagnose output for the named cohort, because per the contradiction, the right sequence shape depends on which position applies, which depends on the diagnosis.

This is sequence *design*, not sequence *send*. Sending happens in lifecycle tooling.

## Inputs

- `--client <client>` (required)
- `--diagnosis <path>` (required), path to the `churn-diagnosis-*.json` produced by `churn-diagnose`. The skill reads `band_recommendations` to pick contradiction position per band.
- `--cohort <high-fit|mid-fit|low-fit|all>` (default: `all`), which ICP-fit band(s) to design sequences for.
- `--channel <email|in-product|both>` (default: `both`)
- `--max-touches <int>` (default: 4), sequence length cap.
- `--days-since-churn-min <int>` (default: 14), earliest send window (don't send too soon).
- `--days-since-churn-max <int>` (default: 90), latest send window.

## Substrate reads

- `clients/{client}/positioning/positioning.md`, to read the canonical statement that anchors the value frame in every touch.
- `clients/{client}/brand-voice/brand-voice.md`, to enforce voice constraints (no kill-list words, no em-dashes, no throat-clearing openers).
- `clients/{client}/voc/voc.md`, to mirror customer language back in the touches.
- `clients/{client}/icp/icp.md`, to confirm the band definition.
- `<diagnosis>` JSON, for drivers, band recommendations, and reason buckets.

## Output contract

One artifact under `clients/{client}/retention/` per run:

`win-back-sequence-<cohort>-<YYYY-MM-DD>.md` with these sections:

1. **Cohort summary**, pulled from diagnosis: cohort size, dominant drivers, ICP fit median, time-in-product median.
2. **Contradiction position picked**, names which position applies (Murphy save / Reichheld let-go / mixed) per the diagnosis recommendation, cites the conditioning, logs the choice.
3. **Sequence spec**, a table of touches with: order, channel, send delay (days since churn), subject line, body skeleton, CTA, refusal-pattern flag (e.g., "no fake-urgency", "no discount-as-default").
4. **Voice constraints applied**, kill-list words excluded; em-dash absent; throat-clearing openers excluded.
5. **Refusal patterns**, what the sequence does NOT do (e.g., for low-fit: no full save call, no executive escalation, no discount).
6. **Substrate citations**, every line of body skeleton cites a substrate path.
7. **Measurement contract**, predicted reactivation rate per band; baseline; resolution date.

## Quality criteria

- Refuses without a churn-diagnose JSON output for the named cohort. Without the diagnosis, the skill cannot pick the contradiction position; without the position, the sequence shape is a guess.
- Refuses to default to a discount-led sequence. Discount-as-default is a price-bandage; the diagnosis must support it (price-sensitivity driver in top 3 for the band) before discount appears in the sequence.
- Voice gate: all subject lines and body skeletons pass the kill-list, em-dash, and throat-clearing-opener checks. Skill writes the assumed voice constraints into the artifact.
- Measurement contract: every sequence carries a predicted reactivation rate with a resolution date.
- Per-band sequences differ. If the diagnosis says "Position A" for high-fit and "Position B" for low-fit, the high-fit sequence carries CSM/AE outreach and the low-fit sequence is a single low-cost in-product touch with an honest "may not be the right fit" close. If sequences are identical across bands, the skill warns.

## What this skill does NOT do

- Does not send the sequence. Hand-off to lifecycle tooling.
- Does not write the actual email body. Body skeletons + subject lines + tone constraints are the artifact; the human or downstream `narrative-compose` polish step renders the final copy.
- Does not invent the diagnosis. Refuses without the named JSON file.
- Does not override the contradiction position. The diagnosis named one; the skill applies it. If the operator wants a different position, they edit the diagnosis (or override with `--force-position` and accept the logged-override penalty).

## Refusal patterns

- `missing-diagnosis`: refuse hard. Cannot design a save sequence for a cohort that hasn't been diagnosed.
- `substrate-gap`: missing positioning or brand-voice. Refuse hard. The sequence must read from a canonical message house and a brand-voice file.
- `discount-without-evidence`: if the operator passes `--include-discount` but the diagnosis names no price-sensitivity driver in the top 3, refuse with `discount-without-evidence`.

## Composes with

- Reads from: `clients/<client>/retention/churn-diagnosis-*.json`, `clients/<client>/positioning/positioning.md`, `clients/<client>/brand-voice/brand-voice.md`, `clients/<client>/voc/voc.md`.
- Writes for: lifecycle tooling (Customer.io, Iterable, HubSpot, Pendo). The artifact is sequence *spec*, not sequence *send*.
- Triggered by: monthly retention review (after `churn-diagnose`), large-cohort churn event, ICP redefinition.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: predicted per-band reactivation rate vs measured reactivation 60 days after sequence ships.

## See also

- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`.
- `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md` (informs which churned accounts had latent expansion intent).
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md` (load-bearing).
- `skills/churn-diagnose/SKILL.md` (input).
- `routines/retention-monthly.md`.
