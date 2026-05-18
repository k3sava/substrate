---
name: help-docs
description: Produces help documentation as a content strategy surface, not a docs afterthought. Help articles are AEO-grade citation surfaces, support-deflection levers, and onboarding-activation drivers in one.
version: 0.1
amplifies: customer success, support lead, PMM, content lead
masters: Tom Johnson (I'd Rather Be Writing — docs as a discipline), Ryan Burgess (Netflix doc systems), Stripe Docs team (the canonical SaaS docs bar), Vercel docs (developer-first patterns), Brendan Hufford (3S — support is content), Yamini Rangan (start with support for fastest AI ROI)
substrate_layers_required: [product-knowledge, voc, brand-voice]
patterns_grounded: [distribution-as-moat, agents-as-product-users, frontline-as-pmm-substrate, copywriting-craft-fundamentals]
preflight_refusal: substrate-gap, missing-product-knowledge, missing-tickets-corpus
required_reads:
  - clients/{client}/product-knowledge/feature-manifest.md
  - clients/{client}/voc/processed/support-tickets/
---

# help-docs

## Purpose

Help docs are simultaneously: the highest-trust AEO surface (LLMs cite docs heavily), the support-deflection lever, and the onboarding-activation channel. Treating them as an afterthought wastes the leverage. This skill makes docs a content surface that reads from the same canonical substrate.

## Inputs

- `--client <client>` (required)
- `--mode <gap-analysis|article|update|aeo-tune>`
- `--topic <topic-id>` (required for article mode)
- `--source-tickets <path>` (when generating from real ticket clusters)

## Substrate reads

- `product-knowledge/feature-manifest.md`, what the feature actually does.
- `voc/processed/support-tickets/`, the questions buyers actually ask.
- `brand-voice/voice-guide.md`, how docs sound.
- `aeo/target-prompts.md`, prompts the article should answer.

## Article structure (the skill enforces)

1. **Question (in customer language).** Pulled from clustered tickets, not invented.
2. **Answer in 3 sentences max.** AEO-citation friendly.
3. **Step-by-step.** Numbered, copy-pasteable.
4. **Edge cases.** Real ticket-derived, not theoretical.
5. **Related articles.** Wikilink-style, builds the doc graph.
6. **When this doesn't work.** Honest failure modes; the support escape hatch.

## Output contract

- `help/<topic-slug>/article.md`, the published article.
- `help/<topic-slug>/source-tickets.md`, the cluster the article serves.
- `help/<topic-slug>/aeo-citations.md`, the prompts this article answers.
- A row in the ticket-deflection ledger (does this article reduce the ticket cluster?).

## Quality criteria

- Refuses to publish an article without ≥5 source tickets backing the question.
- Refuses to claim a behavior the product doesn't have (anti-fab).
- Flags drift: articles whose source tickets have evolved (different questions, different cluster).
- Flags AEO miss: articles cited <X% by target engines on the prompt set after 30 days.

## See also

- `skills/aeo-relevance/`, scores how well docs are getting cited.
- `skills/aeo-manual-action/`, the off-domain propagation side.
- `routines/signal-routine.md`, where ticket clusters become substrate.
- `knowledge/patterns/agents-as-product-users.md`.
