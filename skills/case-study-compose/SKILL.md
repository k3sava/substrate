---
name: case-study-compose
description: Given customer interview transcripts + a named outcome + operational definition, compose a procurement-defensible case study with attribution-tagged claims, narrative arc, and a verbatim pinned quote. Composes claim-verify, voice-enforce, and pre-publish-check.
version: 0.1
amplifies: PMM, content lead, founding marketer, AE bench
masters: April Dunford (positioning is comparison-aware; case studies cite the alternative), Andy Raskin (narrative arc — problem, diagnosis, intervention, outcome), Joel Klettke (case study as outcome-led artifact, not feature-led), Emma Stratton (one-line title that names the customer change), Anthony Pierri (operational definition over claim grandeur), Peep Laja (verbatim quote pinned to a logged date)
substrate_layers_required: [voc, brand-voice, positioning]
patterns_grounded: [frontline-as-pmm-substrate, evidence-ladder, narrative-as-strategy]
contradictions_aware: [self-reported-vs-verified, founder-quote-vs-customer-quote]
preflight_refusal: substrate-gap, missing-transcript, missing-outcome, missing-positioning
required_reads:
  - clients/{client}/voc/processed/
  - clients/{client}/brand-voice/
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# case-study-compose

## Purpose

Take one or more customer transcripts plus a named outcome and produce the case-study file buyers read. The artifact follows the narrative arc (what changed, why it stuck, what was shipped, what it produced, the customer's words, caveats) and carries attribution tags on every metric. The pinned quote is verbatim, not paraphrased. The file passes `pre-publish-check` because the gates run on compose, not after.

Five top-10 consulting prospects asked for this shape verbatim. Without the skill, every case study round re-derives the narrative arc and re-litigates the operational definition. With it, the arc is the contract and the definition is the input.

## Inputs

- `--client <client>` (required)
- `--customer <customer-slug>` (required)
- `--transcript <path>` (required, repeatable) — interview, support thread, public testimonial markdown or text file
- `--outcome <metric>` (required) — the named outcome to lead with (e.g. "18% AHT reduction", "$42M revenue", "2000 hours displaced")
- `--shape <flagship|peer|short>` (default: peer) — flagship 800-1200 words for marquee, peer 400-600 words for the /customers index, short 150 words for an LP card
- `--operational-definition <text>` (optional) — overrides the default placeholder; how the metric is measured and which system is source-of-truth
- `--attribution <verified|self-reported|contextual|indirect|direct>` (default: self-reported)
- `--output <path>` (default: `clients/<client>/case-studies/<customer-slug>.md`)

## Substrate reads

- `clients/<client>/voc/processed/` for customer-language patterns the quote should resonate with
- `clients/<client>/brand-voice/` for voice rules the artifact gates against
- `clients/<client>/brand-voice/founder-voice.md` (if present) for the founder-voice substrate
- `clients/<client>/positioning/positioning-canonical-statement.md` for thesis alignment
- `clients/<client>/allowed-claims-register.md` (if present) for the operational definition the metric should reference

## Process

1. Preflight: validate the client root, the positioning file, and every named transcript path. Refuse on the first miss.
2. Read every transcript. Concatenate the text into a single corpus for quote extraction.
3. Extract the verbatim pinned quote: longest first-person sentence (heuristic: contains "I", "we", or "our") that mentions the outcome keyword OR sits within a 200-character window of a numeric claim that matches the outcome.
4. Compose the markdown using the shape's word budget: flagship 800-1200, peer 400-600, short 150.
5. Render the structure: `## What changed`, `## Why it stuck`, `## What we shipped`, `## What it produced`, `## The customer's words`, `## Caveats`. Each section seeded from transcript content; placeholders flagged with `_(stub: requires interview pass)_` when content is thin.
6. Run `voice-enforce` on the composed draft if the binary exists.
7. Run `claim-verify` on the composed draft if the binary exists. Flag fail in output, do not silently strip.
8. Write the file with full frontmatter; print the path.

## Output contract

```
---
title: <one-line outcome-led title, customer-led not feature-led>
customer: <customer-slug>
attribution: <tier>
outcome: <metric>
operational_definition: <how the metric is measured plus source-of-truth system>
produced_by: case-study-compose
contradiction_positions: [self-reported-vs-verified: position-A — self-reported tier disclosed in frontmatter]
position_rationale: <text>
---

## What changed
<one paragraph, the problem the customer was solving>

## Why it stuck
<two paragraphs, the diagnosis the operator and customer landed on together>

## What we shipped
<two paragraphs, the actual intervention — specific, no abstractions>

## What it produced
<the operational outcome with its named definition; cite the source-of-truth pull>

## The customer's words
<verbatim quote pinned to a logged date; not paraphrased>

## Caveats
<what cannot be proven; what the comparison anchor was; what the window was>
```

## Quality criteria

- Refuses without a positioning canonical statement (case study has no thesis to align against).
- Refuses without at least one transcript path that resolves to a readable file.
- Refuses when the outcome string has no numeric or named-anchor token (no "lift", "better", "improved" without a number).
- Voice gate fails are flagged in output, not silently stripped.
- Claim-verify fails are flagged in output with the failed-claim list appended.
- Every case study carries an attribution tier in frontmatter; the default is `self-reported` and must be raised explicitly to `verified`.

## Refusal patterns

- No transcript file resolves → refuse; first action is to log a customer call via `frontline-contact`.
- No positioning canonical statement → refuse; run `positioning-forge --client <client>` first.
- Outcome string is qualitative only (e.g., "better support") → refuse; operational definitions need numeric or named anchors.
- Voice file references a kill-list word in the composed draft → flag, do not strip; operator decides whether to rewrite.

## What this skill does NOT do

- Does NOT replace `frontline-contact` — that books and logs the call.
- Does NOT replace `win-loss-interview` — that scripts the conversation.
- Does NOT replace `claim-verify` — that gates each metric one at a time.
- Does NOT replace `pre-publish-check` — that gates the final asset.
- This skill takes the outputs of those four and produces the case-study artifact shape.

## See also

- `skills/frontline-contact/` — books the call this skill reads from.
- `skills/win-loss-interview/` — scripts the conversation.
- `skills/claim-verify/` — per-claim gate composed on the output.
- `skills/voice-enforce/` — voice gate composed on the output.
- `skills/allowed-claims-register/` — produces the operational definition this skill references.
- `skills/pre-publish-check/` — composite gate the case study must pass before ship.
- `knowledge/patterns/frontline-as-pmm-substrate.md`.
- `knowledge/patterns/evidence-ladder.md`.
