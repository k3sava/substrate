---
name: context-curate
description: Ingest a raw VoC source (interview, call, review, doc, ticket) and distill it into the correct context layer with frontmatter, decay, and evidence ladder. The librarian skill — every other skill reads what this writes.
version: 0.1
amplifies: PMM lead, analyst, CS researcher
masters: Karpathy (LLM-wiki frame), Cedric Chin (Commonplace book), Tiago Forte (PARA + progressive summarization), Niklas Luhmann (Zettelkasten), Maggie Appleton (digital gardens), Andy Matuschak (evergreen notes), April Dunford (positioning evidence trail), Rob Fitzpatrick (Mom Test → quote extraction), Christensen JTBD (forces-of-progress framing), Anthropic Claude (anti-fabrication discipline)
context_index_version: 2026-04-30
context_layers_required: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  # 1=positioning, 2=icp, 3=voc, 4=competitive, 5=product-knowledge, 6=conversion-narrative, 7=brand-voice, 8=market-context, 9=roadmap, 10=strategy
preflight_refusal: context-gap
---

# context-curate

## Purpose

Take a raw source and write it into the right context layer. Every other skill in substrate reads what curate writes — if curation is sloppy, every downstream output is sloppy.

## Inputs

- `--source <path|url>`: file path, URL, or pasted text
- `--client <client>`: target client folder (e.g. acme-corp, sample-client)
- `--layer <layer>`: positioning | icp | voc | competitive | product-knowledge | conversion-narrative | brand-voice | market-context | roadmap | strategy. Optional — skill auto-classifies if omitted.
- `--attribution <tier>`: verified | self-reported | contextual | indirect | direct. Required.

## Process

1. **Read raw** — full ingest, no skim. Quote extraction is verbatim only.
2. **Classify layer** — match content to layer schema (context/schema.md). Reject if it doesn't fit.
3. **Distill** — progressive summarization: (a) verbatim quotes worth preserving, (b) themed extraction, (c) one-line synthesis. Three layers, not one.
4. **Tag attribution** — every claim gets one of 5 tiers. Untraceable claims are marked `unverified` and stopped, not published.
5. **Frontmatter** — layer, client, last_updated, decay_period_days, expires_on, attribution, source path, owner.
6. **Cross-link** — `related: [other-files.md]` where the context references prior context.
7. **Write** to `clients/<client>/context/<layer>.md` (append or create section, never overwrite without diff review).
8. **Log** to `clients/<client>/logs/context-curate-<date>.md`: source, layer, lines added, attribution mix.

## Output

A context file change + a one-line log entry. No prose response to the operator beyond the diff.

## Gates

- **Anti-fabrication:** every claim traces to source path or is marked unverified.
- **Decay:** layer's decay period is honored; expired layers trigger refresh, not silent reuse.
- **Voice:** context prose passes voice-enforce on `brand-voice` layer; raw quotes are exempt.
- **Cross-client isolation:** never reads or writes outside the named client folder.

## Composes with

Reads from: nothing (entry point).
Writes for: every other skill. Most read context-curate's output via `clients/<client>/context/`.
Triggered by: voc-loop, signal→bet workflow, manual operator invocation.

## Refusal patterns

- Source has no traceable origin → reject; do not invent a citation.
- Layer ambiguous → ask once, then reject if still unclear.
- Quote ambiguous (cleaned-up vs verbatim) → preserve verbatim, flag the cleanup.

## Calibration

- Tracked in calibration-keep under taste-type `context-architect`.
- Brier signal: does this context file get cited in shipped assets within 60 days? Cited = correct curation. Uncited = either bad source pick or bad classification.

## Context preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/context/00-INDEX-10-layers-2026-04-30.md`. If any required layer is `thin` or `partial`, the skill returns:

```
CONTEXT-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.

