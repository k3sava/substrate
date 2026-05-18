---
name: aeo-relevance
description: Score AEO relevance for an asset. Extracts claims from the asset, simulates AI assistant queries against the canonical prompt set, and scores citation likelihood per claim using passage structure (TL;DR up top, structured H3s, bulleted answers, schema.org markup detection). Closes the second leg of the AEO triangle — presence (do you appear) is `aeo-tune`; relevance (are you the right answer) is this skill; manual-action propagation is `aeo-manual-action`.
version: 0.3
amplifies: PMM, content lead, growth lead, SEO/AEO operator
masters: Aleyda Solis (AEO triangle — presence, relevance, business impact), Anthony Pierri (passage extractability), Andy Crestodina (Q&A density correlates with citation lift), Mike King (relevance engineering, passage as IR unit), Eli Schwartz (relevance from buyer-stage match), Bernard Huang (intent-stack content), Nathan Gotch (relevance is exact-match-to-question density), Brendan Hufford (3S source content for relevance)
substrate_layers_required: [positioning, product-knowledge, voc, market-context]
patterns_grounded: [aeo-triangle, passage-as-citation-unit, agents-as-product-users, distribution-as-moat]
preflight_refusal: substrate-gap, missing-target-prompts, missing-asset, asset-not-passage-extractable
required_reads:
  - clients/{client}/aeo/target-prompts.md
---

# aeo-relevance

## Purpose

Presence does not equal relevance. A page can be cited in 70% of LLM answers and still lose because the citation framed the answer wrong, or because a competitor's passage was extracted instead. This skill measures whether an asset is structured so AI assistants can extract its claims (passage extractability per `pat_passage-as-citation-unit`), whether the claims actually answer the buyer's question, and whether the framing reflects canonical positioning. Output is a relevance scorecard with per-claim citation likelihood, structural signals (TL;DR, H3 density, bullet density, schema.org markup), and a per-prompt gap analysis against `clients/<client>/aeo/target-prompts.md`.

## Inputs

- `--client <client>` (required)
- `--asset <path>` (required) — the asset to score (markdown, HTML, or any text file)
- `--mode <score|gap-analysis|content-brief>` (default: `score`)
- `--prompt-set <path>` — override the default `clients/<client>/aeo/target-prompts.md`
- `--engines <claude|openai|perplexity|google|...>` (default: all)
- `--out <dir>` (default: `clients/<client>/aeo/relevance-runs/`)

## Output deliverables (per mode)

**score** — Per-asset relevance scorecard. Computed metrics:
- **Passage count** (target: 8-12 per page).
- **Average passage length** (target: 40-90 words).
- **TL;DR present** (binary; +0.15 score weight if present in first 100 lines).
- **H3 density** (target: 1 H3 per 250 words).
- **Bulleted answer density** (target: ≥30% of passages have a bulleted answer block).
- **Schema.org markup detection** (FAQPage, HowTo, Article — binary per type).
- **Question-explicit signal** (target: ≥50% of passages have a question in the H3 or first sentence).
- **Self-contained signal** (heuristic: passage references "above" / "below" / "as discussed" → score deduction).
- **Per-claim citation likelihood** (heuristic score 0-1 per extracted claim).
- **Voice match** (binary: does the asset use kill-list words, em-dashes in body, etc.).

Output: `aeo/relevance-runs/<asset-stem>-<date>.md` with overall score, per-passage breakdown, per-claim table, structural signal summary.

**gap-analysis** — For each prompt in target-prompts.md, score the asset's likelihood of winning that prompt's citation. Output: `aeo/gap-analysis/<asset-stem>-<date>.md` with prompt × asset matrix and named gaps.

**content-brief** — For an unmet prompt, produce a content brief proposing the passage shape that would correct the framing. Output: `aeo/briefs/<prompt-id>-<date>.md`.

## Substrate reads

- `aeo/target-prompts.md`, the canonical prompt set with intent labels.
- `aeo/citation-log/`, prior citation runs (informational).
- `positioning/`, what a "right" answer must reflect (every claim cited against this).
- `voc/processed/`, the customer language that should appear in cited passages.
- `competitive/`, the displacement context (whose passage is currently cited).

## Output contract

- `clients/<client>/aeo/relevance-runs/<asset-stem>-<date>.md` (score mode)
- `clients/<client>/aeo/gap-analysis/<asset-stem>-<date>.md` (gap-analysis mode)
- `clients/<client>/aeo/briefs/<prompt-id>-<date>.md` (content-brief mode)

Every artifact carries `produced_by: aeo-relevance` so Gate 7 (pattern-applied) can verify pattern application at pre-publish time.

## Quality criteria

- Refuses to score without `target-prompts.md` (need the prompt set the client is trying to win).
- Refuses to score an asset that has zero H2/H3 structure (not passage-extractable per `pat_passage-as-citation-unit`).
- Refuses to ship a relevance run with N<3 prompts in target-prompts.md (insufficient sample).
- Flags drift: prompts where the relevance score dropped vs the prior run for the same asset.
- Refuses gap-analysis on a single competitor (the analysis is multi-source by definition).

## Scoring rubric

Each citation candidate is scored on:

| Dimension | Weight | What it measures |
|---|---|---|
| Passage extractability | 0.25 | TL;DR + H3 density + average passage length 40-90 words + bulleted answer + question-explicit |
| Self-containment | 0.15 | passage avoids "above" / "below" / "as discussed" references |
| Schema.org markup | 0.10 | FAQPage / HowTo / Article markup present and valid |
| Positioning alignment | 0.15 | claim aligns with canonical positioning (overlap of load-bearing terms) |
| Voice match | 0.10 | no kill-list words, no em-dashes in body, no throat-clearing openers |
| First-600-words groundable info | 0.25 | load-bearing facts placed as discrete, attributable sentences in the first 600 words with provenance signals (author, date, source link, JS-free render) |

Overall score: weighted sum, 0-1. Threshold for "passage-ready": ≥0.70.

## First-600-words + provenance gate (v0.3, added per Indig Bing-grounding shift)

Microsoft Bing's grounding architecture inverted the AI retrieval contract: the index no longer retrieves *best documents*, it fetches *best facts*. The unit of value is "groundable information" — discrete facts with clear provenance that models can cite. Pages that rank well but wrap their load-bearing claims in narrative paragraphs, second-half placement, or JS-rendered text are invisible to grounding.

This skill enforces a three-step audit on every asset, before any other scoring dimension fires:

### Step 1, identify load-bearing facts

The asset must declare its load-bearing claims explicitly. The skill reads frontmatter `groundable_facts: [...]` if present, or extracts the 5 to 10 highest-weight claims from the asset body (numeric claims, category-definition claims, primary differentiated capability claims).

### Step 2, audit placement and format

For each load-bearing fact, the skill checks:

- Does it appear as a discrete, attributable sentence (not embedded mid-paragraph)?
- Does it appear within the first 600 words of the page?
- Is it accompanied by a source link, author byline, or publish/update date adjacent to the claim?
- Is the fact in plain HTML text, not a JS-populated div? (Static-render check via the asset path.)

### Step 3, restructure recommendation

For each failed fact, the skill emits a restructuring hint:

- Surface the claim as a standalone sentence in the intro or a visible callout.
- Add author byline plus publish/update date adjacent to the claim.
- Move the fact above the 600-word boundary.
- Replace JS-rendered surface with plain-HTML render.

Refusal pattern: any asset with `produced_by: aeo-relevance` AND zero load-bearing facts in the first 600 words AND zero provenance signals fails this gate. Soft-fail by default; hard-fail when the asset frontmatter carries `enforce_groundable: true`.

This gate fires before the legacy passage-extractability scoring. An asset can score 0.95 on passage extractability and 0.0 on groundable-info; the composite blocks ship.

## See also

- `skills/aeo-tune/`, the presence side (per-vertical AEO pass).
- `skills/aeo-manual-action/`, the propagation side (third-party mention density).
- `skills/passage-as-citation-unit`, the underlying pattern.
- `routines/aeo-routine.md`, the cadence.
- `knowledge/patterns/aeo-triangle.md`.
- `knowledge/patterns/passage-as-citation-unit.md`.
- `templates/target-prompts-example.md` — a sample prompt set with intent labels.
