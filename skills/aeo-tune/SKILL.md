---
name: aeo-relevance-engineering
description: Per-vertical AEO/GEO pass — turn one substrate doc (vertical playbook, battle card, pricing page, integration page, help doc) into the four convergent AEO artifacts (structured passages, schema-typed entities, YouTube/LinkedIn mirror plan, three-layer scorecard).
version: 0.2
substrate_layers_required: [positioning, competitive, product-knowledge, brand-voice, icp]
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/substrate/positioning-canonical-statement-*.md
masters: Mike King (iPullRank, "relevance engineering" frame), Aleyda Solis (per-vertical/per-country shape; three-layer measurement), Lily Ray (YouTube + LinkedIn = highest-cited AI Overview sources), Amanda Natividad (precision over breadth)
---

# aeo-relevance-engineering

## Purpose

Treat AEO/GEO as an information-retrieval engineering discipline, not content production. The unit of citation is the passage, not the page. Each pass emits four artifacts side-by-side so the doc ships AI-ready, not just human-ready.

## Inputs

- `--target <path>` — one client artifact (vertical playbook / battle card / pricing page / integration page / help doc).
- `--vertical <slug>` — must match a slug or alias from `clients/<client>/verticals.yaml`, or the special slug `horizontal` for non-vertical content. Schema in `templates/verticals-example.yaml`.
- `--icp-anchor <id>` — short ICP name from the client's canonical ICP doc.
- `--client <slug>` — explicit client; defaults to `$SUBSTRATE_CLIENT` or the slug parsed from the asset path.

## Process

1. **Read substrate**: positioning, ICP-anchor card, brand-voice, product-knowledge for any product entities in the target.
2. **Extract canonical entities** from the target doc (product names, integrations, competitors, ICP role titles, pricing tiers, capability claims). Output `entities.json` with type tags compatible with schema.org Product/Service/Organization.
3. **Produce 8–12 stand-alone passages** (40–90 words each) that answer one buyer question each. Each passage is self-contained (LLMs cite passages, not pages). Mike King frame: a passage is the unit of citation.
4. **Generate FAQPage + HowTo schema blocks** for the passages where the question/answer shape fits. Validate against current schema.org spec.
5. **Map each passage to a YouTube + LinkedIn long-form mirror** (Lily Ray: highest-cited AI Overview sources). Output `mirror-plan.md` with title, opening hook, source passage.
6. **Score on Aleyda's three layers** → `aeo-scorecard.md`:
   - **Presence**: 10–15 buyer-prompt coverage list, recommendation rate target, citation rate target.
   - **Readiness**: 10-trait checklist (accessible, transactable, navigable, factual, …) with current state per trait.
   - **Business Impact**: keep 3 confidence layers separate (observed referrals / modeled lift / attributed deals). Never combine.

## Outputs

- `entities.json`
- `passages.md` (8–12 cite-ready passages)
- `schema.json` (FAQPage + HowTo)
- `mirror-plan.md`
- `aeo-scorecard.md`

## Gates

- **Substrate-cited**: every entity + claim cites a substrate path.
- **Passage discipline**: 40–90 words, self-contained, single buyer question per passage.
- **Schema validity**: schema.json must validate against schema.org current spec (offline validator OK).
- **Voice-enforce**: passages obey brand-voice rules.
- **No fabricated entities**: refuses if entity not present in product-knowledge or competitive-data-bank.
- **Vertical declared**: refuses if `--vertical` is missing, or if the slug is not present in `clients/<client>/verticals.yaml` (or the special `horizontal` slug). Per Aleyda: per-vertical shape varies; one motion does not fit all.

## Human-in-the-loop checkpoints

- **canonical-entity owner**: signs off on which entities/capability claims are canonical enough to expose to LLM crawlers.
- **content + distribution owner**: approves YouTube/LinkedIn mirror plan; decides which docs cross over to long-form.
- **positioning + measurement owner**: sets Presence prompt set per vertical; decides which Business Impact layer rolls into growth narrative. Aleyda's failure-mode warning: bleeding modeled into observed.

## Refusal patterns

- Refuses if BRIEF.md missing or stale (>14d) per dispatcher gate.
- Refuses if target doc has no frontmatter or no substrate cite.
- Refuses if vertical missing.

## Composes with

- `lp-ship` (passages can populate per-passage LP variants).
- `competitive-displace` (battle-card mirror plan reuses passage shape).
- `claim-verify` (every passage gets cite-and-claim verified before mirror plan).
