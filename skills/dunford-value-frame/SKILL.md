---
name: dunford-value-frame
description: Value-frame rewrite per April Dunford. Reads current hero + ICP doc + 3 competitor pages and returns a feature→value rewrite scored against Dunford's rubric. PMM holds the value-claim-as-headline call.
version: 0.1
lifted_from: 2026-05-01 digest "April Dunford published a sharp B2B-tech positioning piece" (1-day spike scope)
substrate_layers_required: [1, 4, 5]  # 1=positioning, 4=competitive, 5=product-knowledge
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/substrate/positioning-canonical-statement-*.md
  - clients/{client}/substrate/competitive-cross-cut-matrix-*.md
masters: April Dunford ("Obviously Awesome", value-frame for B2B tech)
---

# dunford-value-frame

## Purpose

Stop selling features, sell value. Most B2B copy explains how a thing works; Dunford's frame demands the value the buyer gets, in 1 sentence, scored on 5 axes:

1. **Specific** — names the buyer outcome, not the feature.
2. **Differentiated** — distinguishes from the alternative, not the abstract space.
3. **Defensible** — backed by substrate (proof, data, capability).
4. **Concrete** — measurable or observable, not aspirational.
5. **Voice-clean** — no kill-list words, no em-dash, no throat-clearing.

## Inputs

- `--hero <path-or-string>` — current hero copy.
- `--icp <icp-id>` — canonical ICP anchor.
- `--competitors <c1,c2,c3>` — 3 competitor pages from competitive-data-bank.

## Process

1. Read positioning, ICP card, 3 competitor pages.
2. Extract feature claims from current hero.
3. For each feature, draft 3 value rewrites (focusing on different ICP outcomes).
4. Score each rewrite against the 5-axis rubric (1–5 per axis, 25 max).
5. Output top 3 by score with rubric breakdown.

## Output

`value-frame-rewrites.md` with:
- Original hero (annotated by feature claim)
- 3 winning value rewrites (ranked, scored)
- Per-axis score table
- 1-paragraph reasoning per rewrite

## Gates

- **3 competitor pages** required (refuses with <3 — Dunford: differentiation requires concrete alternatives).
- **Voice-enforce**: rewrites obey brand-voice.
- **Substrate-cited**: each "defensible" axis citation must trace to a substrate path.
- **No fabricated metrics**: refuses if rewrite includes a number not in substrate.

## Human-in-the-loop checkpoint

- **PMM**: picks which value-claim becomes the headline. Dunford-explicit: "the value-frame is the operator's call, the rubric just narrows the field."

## Refusal patterns

- Refuses without ≥3 competitor refs.
- Refuses without ICP anchor.
- Refuses if substrate has no positioning canonical doc.

## Composes with

- `fletch-homepage-rewrite` (run dunford first to anchor differentiated-value before fletch's hero variants).
- `voice-enforce` (hard gate on rewrites).
- `lp-cro` (rewrite candidates feed CRO test queue).
