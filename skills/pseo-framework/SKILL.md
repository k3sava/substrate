---
name: pseo-framework
description: Programmatic SEO at scale. Builds and ships large structured page sets (alternative-to-X, integration-X, vertical-Y, use-case-Z) from canonical substrate, gated for quality so the volume doesn't tank the domain.
version: 0.1
amplifies: SEO/AEO operator, PMM, content lead, growth engineer
masters: Eli Schwartz (Product-Led SEO — programmatic at category scale), Bernard Huang (Clearscope intent stack), Aleyda Solis (technical SEO + AEO), Tomas Jurkonis (programmatic SEO patterns), Mike King (entity-first programmatic), Geoff Roberts (Outseta — comparison-page playbook), Webflow / Zapier (canonical pSEO production stacks)
substrate_layers_required: [positioning, product-knowledge, competitive, voc, market-context]
patterns_grounded: [aeo-triangle, distribution-as-moat, specificity-becomes-profitable, market-and-offer-beat-funnel-optimisation]
preflight_refusal: substrate-gap, missing-corpus-data, insufficient-quality-bar
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
  - clients/{client}/competitive/00-INDEX.md
  - clients/{client}/strategy/quality-bar.md
---

# pseo-framework

## Purpose

Programmatic pages multiply distribution surface but tank quality if shipped without a substrate. This skill enforces the substrate gate: every programmatic page is generated from canonical positioning + canonical competitive data + canonical voice; the gate refuses thin or templated content.

## Inputs

- `--client <client>` (required)
- `--page-class <alternative-to|integration|vertical|use-case|comparison>`
- `--source-data <path>` (the structured corpus driving the variants)
- `--mode <plan|generate|gate|publish>`

## Page-class structure

Each class has a template + canonical substrate reads:

- **alternative-to**: positioning, competitor file, status-quo file. Template: hero, head-to-head, switching cost, social proof.
- **integration**: product-knowledge, integration metadata, voc/integration-use-cases. Template: what it does, setup steps, real customer use case.
- **vertical**: ICP/vertical, voc/vertical-pains, competitive/vertical. Template: vertical-specific pain, vertical-tuned narrative, proof.
- **use-case**: jtbd-list, voc/use-case, product-knowledge. Template: trigger, current path, new path, proof.
- **comparison**: competitive/<vendor-A>, <vendor-B>, positioning. Template: feature matrix, differential, recommendation by buyer-type.

## Substrate reads

- `competitive/`, every page in this class.
- `voc/processed/`, customer language used in the variants.
- `strategy/quality-bar.md`, the floor each variant must clear.

## Output contract

- `pseo/<page-class>/<slug>/page.md`, the rendered page.
- `pseo/<page-class>/<slug>/source-citations.md`, the substrate paths cited.
- A pre-publish check on every page (calls `pre-publish-check` skill).
- A measurement contract per class (target ranking + citation density + conversion target).

## Quality criteria

- Refuses to generate any page that doesn't cite a real `voc/processed/` quote.
- Refuses to ship a page-class run without a quality bar audit on a 30-page sample (eval-rubric).
- Flags drift: pages whose source citations have aged past freshness window.

## Anti-patterns this skill prevents

- Templated pages with swapped vendor names and no substrate citations (the AI-slop loop).
- Programmatic pages that contradict canonical positioning.
- Programmatic pages that exceed the corpus (more page variants than there are real use cases).

## See also

- `skills/lp-ship/`, the single-LP counterpart.
- `skills/lp-cro-rubric/`, the conversion gate for high-traffic pSEO pages.
- `skills/pre-publish-check/`, the gate every variant runs.
- `knowledge/patterns/distribution-as-moat.md`.
