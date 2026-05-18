---
id: pat_passage-as-citation-unit
title: AI assistants cite passages, not pages — structure for passage extractability
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_pierri-passage-extractability, ins_crestodina-question-answer-density, ins_king-relevance-engineering-passage-level, ins_solis-aeo-passage-grain]
domains: [pmm, aeo, content, seo]
---

# AI assistants cite passages, not pages — structure for passage extractability

## Convergence

Four operators across positioning, content engineering, and AEO/GEO research converge on the same operating claim: AI assistants (ChatGPT, Perplexity, Google AI Overviews, Claude with web tools) cite at the passage level, not the page level. A page that ranks well in classical SEO can be invisible in AI search because the page's information is buried in narrative prose; a page with passage-grain structure (TL;DR, structured H3s, bulleted answers, schema.org markup) gets extracted, cited, and propagated. The unit of optimisation has shifted; the content shape that wins is one extractable answer per passage, 40-90 words, self-contained, with the question explicit and the answer specific. Pages are still the unit of indexing; passages are the unit of citation.

## Operators

- **Anthony Pierri**, founder of FletchPMM, positioning practitioner. Pierri's published thesis (LinkedIn essays, FletchPMM teardowns) is that homepage and product-page copy must be passage-extractable: each section answers one explicit buyer question with a structured response. Walls of narrative prose lose to question-answer-shaped sections because AI assistants and human skimmers both read the same way: extract the answer, skip the narrative.
- **Andy Crestodina**, co-founder of Orbit Media, content strategy practitioner. Crestodina's published research on question-and-answer density (analysed across thousands of pages) shows a positive correlation between explicit question-answer structure and ranking + citation lift. The operational discipline: write the question as an H3, answer in 1-2 sentences, then expand with a bulleted breakdown.
- **Mike King**, founder of iPullRank, "relevance engineering" frame. King's published position is that AEO is an information-retrieval engineering discipline, not a content-production discipline; the unit of citation is the passage; the passage must be self-contained because the LLM extracts and quotes without the surrounding page context. King's operational prescription: 8-12 stand-alone passages per page, 40-90 words each, each answering one buyer question.
- **Aleyda Solis**, founder of Orainti, international SEO and AEO practitioner. Solis's published three-layer measurement frame (presence, readiness, business impact) names passage-grain content as the readiness layer's central artifact. Pages that are passage-extractable are AI-ready; pages that are not are AI-invisible regardless of their classical SEO performance.

## Variation

- **Pierri** owns the *positioning instantiation* (homepage and product-page copy as extractable passages).
- **Crestodina** owns the *content discipline* (Q&A density as a measurable craft skill).
- **King** owns the *engineering frame* (relevance engineering, passage as IR unit).
- **Solis** owns the *measurement layer* (passage-grain as the readiness signal in the three-layer dashboard).
- Convergence: the page is no longer the unit of value; the passage is. Optimising at the page level produces classical SEO output that AI assistants cannot extract.

## Implication

For PMM, content, and AEO operators:

1. **Audit pages for passage extractability.** Walk the page; for each section, ask "could an LLM cite this section without the rest of the page?" If the answer is no (because the section assumes context from earlier paragraphs, because the question is implicit, because the answer is a story rather than a structured response), the section is not passage-extractable. Rewrite to passage shape.
2. **Hold every passage to four constraints.** (a) Self-contained: the passage answers the question without the rest of the page. (b) 40-90 words: long enough to be substantive, short enough to be quotable. (c) Question-explicit: the question is in the H3 or the first sentence, not assumed. (d) Answer-specific: the first sentence after the question is a direct answer, not a setup paragraph.
3. **Mark up the passage shape with schema.org.** FAQPage for question-answer pairs; HowTo for step sequences; Article + speakable for op-ed and analysis. Validate against the current schema.org spec; broken markup costs citation eligibility on Google AI Overviews and ChatGPT plugins.
4. **Pair each passage with a YouTube + LinkedIn mirror.** Lily Ray's published research on AI Overview citation sources shows YouTube and LinkedIn long-form posts are highest-cited off-domain surfaces. Each passage on the owned page becomes a 90-second YouTube video script and a LinkedIn long-form post; the same passage appears on three surfaces, increasing extraction probability.
5. **Measure citation rate, not ranking, on AI surfaces.** Classical SEO measures ranking; AEO measures citation. A page can rank #1 and not be cited because the cited passage came from a competitor's page that was passage-extractable. Track per-prompt citation rate as a separate metric from per-keyword ranking.

## Counter-evidence

- **For long-form thought leadership** (founder essays, deep technical analysis), the passage-grain constraint conflicts with the narrative shape that earns the audience in the first place. The pattern still applies; the conclusion is "extract a passage-grain TL;DR at the top; let the body be narrative; the TL;DR is what AI cites."
- **For research papers and academic writing**, the passage-grain frame undersells the structural prose; the abstract is already the passage. The pattern still applies; the abstract is the citable passage.
- **For pages with strong embodied product demonstration** (interactive product tours, video walkthroughs), AI assistants can't extract the demo; they can only extract the surrounding text. The pattern still applies; the implication is "the surrounding text is load-bearing; do not relegate it to alt text."

## Sources

- ins_pierri-passage-extractability, Anthony Pierri (FletchPMM teardowns; LinkedIn essays; positioning-as-extractable-passages canon)
- ins_crestodina-question-answer-density, Andy Crestodina (Orbit Media research on Q&A structure and ranking lift)
- ins_king-relevance-engineering-passage-level, Mike King (iPullRank; relevance engineering frame; passage-as-citation-unit canon)
- ins_solis-aeo-passage-grain, Aleyda Solis (Orainti; three-layer AEO measurement frame; passage-grain as readiness signal)

See also:
- `pat_aeo-triangle`, the parent pattern with presence + relevance + manual-action propagation.
- `pat_distribution-as-moat`, the off-domain mirror discipline.
- `skills/aeo-relevance/`, the operational implementation for relevance scoring.
- `skills/aeo-tune/`, the per-vertical AEO pass that produces passage-grain artifacts.
- `skills/aeo-manual-action/`, the off-domain mention-density skill.
