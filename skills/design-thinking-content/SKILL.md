---
name: design-thinking-content
description: Applies design-thinking method (empathise, define, ideate, prototype, test) to content generation. Designs the artifact for the buyer's actual situation, not for SEO targets or template completion.
version: 0.1
amplifies: content lead, PMM, designer-writer
masters: Tim Brown (IDEO — design thinking), Brendan Hufford (3S — start with the buyer's actual moment), Joanna Wiebe (stages of awareness as design constraint), Bob Moesta (JTBD as design input), Anne Handley (Everybody Writes — buyer-empathy as the lead)
substrate_layers_required: [voc, icp, brand-voice, product-knowledge]
patterns_grounded: [buyer-mindset-not-product-features, copywriting-craft-fundamentals, frontline-as-pmm-substrate]
preflight_refusal: substrate-gap, missing-buyer-moment
required_reads:
  - clients/{client}/voc/processed/
  - clients/{client}/icp/00-INDEX.md
---

# design-thinking-content

## Purpose

Most content starts from "what should we publish?" Design-thinking content starts from "what is the buyer experiencing right now, and what artifact would they actually use?" The artifact is the answer to a real moment, not an entry in a content calendar.

## Inputs

- `--client <client>` (required)
- `--moment <buyer-moment-id>` (required, must be a logged moment in voc)
- `--mode <empathise|define|ideate|prototype|test>`
- `--persona <pinned-icp>`

## Five-stage flow

1. **Empathise.** Pull voc/processed/ entries for this moment. Read 10. Don't paraphrase, transcribe.
2. **Define.** Write the buyer's question in their words. Define the artifact's success in their terms.
3. **Ideate.** Generate 5–10 artifact concepts (article, calculator, doc, video, script, comparison, walkthrough, template).
4. **Prototype.** Pick 2 concepts. Draft thin versions.
5. **Test.** Run `audience-test` on the prototypes against the pinned cohort. Pick the winner.

## Substrate reads

- `voc/processed/`, the buyer's actual words for this moment.
- `icp/<persona>.md`, who the buyer is.
- `brand-voice/voice-guide.md`, how the artifact should sound.
- `product-knowledge/`, what we can claim.

## Output contract

- `content/moments/<moment-id>/research.md`, the empathise + define output.
- `content/moments/<moment-id>/concepts.md`, the ideate output.
- `content/moments/<moment-id>/prototypes/<concept>.md`, the prototype drafts.
- `content/moments/<moment-id>/test-results.md`, the audience-test output.
- A measurement contract on the winning artifact.

## Quality criteria

- Refuses to advance past empathise without 10 voc entries cited.
- Refuses to define success in marketer-language ("brand awareness"); demands buyer-language ("understand whether X applies to me").
- Refuses to skip the prototype stage and ship one concept.
- Flags drift: published artifacts whose performance contradicts the test result.

## See also

- `skills/audience-test/`, the test stage.
- `skills/help-docs/`, when the artifact is documentation.
- `skills/lp-ship/`, when the artifact is a landing page.
- `knowledge/patterns/buyer-mindset-not-product-features.md`.
