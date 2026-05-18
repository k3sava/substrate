---
name: founder-voice-substrate
description: Given a founder's public corpus (LinkedIn export, podcast transcripts, byline files), compose the founder-voice substrate file that voice-enforce gates against. Surfaces reusable narrative beats, cadence stats, proof-line library, and a corpus-derived kill-list.
version: 0.1
amplifies: PMM, content lead, founding marketer, AE bench
masters: April Dunford (founder-voice as the canonical thesis), Andy Raskin (narrative beats are reusable structural moves), Anthony Pierri (proof-line catalog beats abstract pillars), Emma Stratton (kill-list as a positive scoring axis, not a refusal-only one), Peep Laja (verbatim voice extraction from public surface)
substrate_layers_required: [brand-voice, voc]
patterns_grounded: [narrative-as-strategy, copywriting-craft-fundamentals, distribution-as-moat]
contradicrions_aware: [founder-voice-vs-team-voice]
preflight_refusal: substrate-gap, missing-corpus, corpus-too-thin
required_reads:
  - clients/{client}/brand-voice/
---

# founder-voice-substrate

## Purpose

`voice-enforce` can refuse a draft for kill-list words and em-dashes. It cannot positively score a draft as "this sounds like the founder." That requires a substrate file calibrated from the founder's public corpus. This skill builds that file. Once it exists, the team can ship four essays in the founder's voice in five days without the founder reviewing each sentence.

Nine of the top-10 consulting prospects need this explicitly or structurally. The modal prospect is a Series A or B AI-native company where the founder is the marketing voice and the team cannot reproduce the cadence.

## Inputs

- `--client <client>` (required)
- `--founder <name>` (required) — the founder whose voice is being captured
- `--corpus-paths <path>` (required, repeatable) — files or globs pointing to LinkedIn export, podcast transcripts, byline markdown
- `--output <path>` (default: `clients/<client>/brand-voice/founder-voice.md`)

## Substrate reads

- `clients/<client>/brand-voice/` for an existing brand-voice file the founder voice supplements
- `clients/<client>/voc/processed/` for buyer-language patterns the coherence section flags against

## Process

1. Resolve every corpus path (file or glob). Refuse if fewer than three files resolve (corpus too thin to extract beats with confidence).
2. Read every corpus file. Concatenate into a single text stream, split into posts on blank-line boundaries.
3. Compute sentence-length distribution stats (mean, median, p25, p75, p95) across all sentences.
4. Compute top-50 most-frequent content words after stopword filter.
5. Extract candidate narrative beats by finding repeated multi-word phrases (5+ word substrings) that appear in 3 or more posts. Keep up to 5.
6. Compose the corpus-derived kill-list: load the stock buzzword list inline; flag every entry that does NOT appear in the corpus.
7. Build the proof-line library: sentences that contain numbers OR named entities AND that recur across two or more posts.
8. Cross-reference against `voc/processed/` if present and flag two-axis alignment (founder language vs buyer language).
9. Emit the founder-voice.md file with frontmatter and the eight-section structure named in the proposal.

## Output contract

```
clients/<client>/brand-voice/founder-voice.md
```

Sections:
- Frontmatter (title, owner, corpus_sources, last_compiled, produced_by)
- The 5 reusable narrative beats
- The kill-list (derived from corpus absence)
- Cadence rules (sentence-length distribution, paragraph rhythm, pivot transitions)
- Proof-line library (recurring stats, customer names, anchors)
- Coherence with buyer voice (alignment + divergence flags, never resolved)
- Surfaces this gates

## Quality criteria

- Refuses on fewer than three resolved corpus files (insufficient sample).
- Refuses if total corpus is shorter than 3000 words (cadence stats are unreliable below that floor).
- Every extracted beat must appear in at least three distinct posts.
- The kill-list is corpus-derived, not stock. A stock buzzword that the founder happens to use repeatedly does NOT enter the kill-list; the file flags it as observed instead.
- Flags coherence drift between founder and buyer voice; never resolves it silently.

## Refusal patterns

- Fewer than three corpus files resolve → refuse; expand corpus-paths first.
- Corpus shorter than 3000 words → refuse; cadence stats unreliable.
- No `voc/processed/` and no `brand-voice/` directory → soft warn; emit file but mark the coherence section as "(no buyer-voice substrate to compare)".

## What this skill does NOT do

- Does NOT replace `voice-enforce` — that gates each draft against the substrate file this skill produces.
- Does NOT replace `narrative-compose` — that composes the draft.
- Does NOT replace `humanizer` — that strips the AI fingerprint.
- This skill produces the input file those three consume.

## See also

- `skills/voice-enforce/` — gates against the file this skill writes.
- `skills/narrative-compose/` — composes drafts using the cadence rules.
- `skills/humanizer/` — strips fingerprint after compose.
- `skills/case-study-compose/` — reads the proof-line library when emitting customer quotes.
- `knowledge/patterns/narrative-as-strategy.md`.
- `knowledge/patterns/copywriting-craft-fundamentals.md`.
