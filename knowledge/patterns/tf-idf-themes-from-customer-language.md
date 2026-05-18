---
id: pat_tf-idf-themes-from-customer-language
title: Customer-language extraction beats marketer-rewriting
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_crestodina-message-mining, ins_wiebe-customer-language-as-copy, ins_dunford-listen-for-words, ins_eisenberg-voice-of-customer-research, ins_jtbd-interviews-surface-customer-language]
domains: [pmm, marketing, copywriting, research-discovery]
---

# Customer-language extraction beats marketer-rewriting

## Convergence

Four operators across content marketing (Crestodina), conversion copywriting (Wiebe), positioning (Dunford), and conversion-rate optimization (Eisenberg) converge on the same operating thesis: the highest-resonance copy uses the customer's verbatim language, extracted from interview transcripts, support tickets, sales calls, and review corpora, *not* the marketer's polished paraphrase. The discipline is mechanical: collect the corpus, extract the noun-phrases the customer keeps using, weight them by frequency-vs-rarity (TF-IDF or equivalent), and use the high-weight phrases verbatim in copy. Paraphrasing kills resonance; the marketer's rewrite is almost always less specific and less emotionally grounded than the source.

## Operators

- **Andy Crestodina**, `ins_crestodina-message-mining`. Message mining: read the support tickets, sales call transcripts, and Reddit threads where buyers discuss the problem. Extract the verbatim phrases. Use them in headlines, page titles, and meta descriptions. Customer language outperforms marketer language on every conversion test.
- **Joanna Wiebe**, `ins_wiebe-customer-language-as-copy`. Copyhackers' core technique: highlight every phrase a customer used to describe the problem in interview transcripts and review corpora. Sort by frequency. The top phrases become headline candidates. Run them as live A/B tests; the customer-phrase variant beats the marketer-phrase variant in 80%+ of tests.
- **April Dunford**, `ins_dunford-listen-for-words`. Positioning is informed by listening for the actual words customers use to describe the alternative they considered, the value they got, and the friction they felt. The category noun, the value theme, and the alternative are all the customer's words, not the marketer's invention.
- **Bryan Eisenberg**, `ins_eisenberg-voice-of-customer-research`. VoC research as the engine of CRO: every page-element decision (headline, sub-head, button label, form-field copy) traces to a phrase the customer actually used. Pages built without a VoC backbone have no anchor.

## The TF-IDF mechanic

The operating discipline is corpus-mechanical, not impressionistic:

1. **Collect.** Interview transcripts, sales-call recordings, support tickets, G2/review corpora, Reddit threads, churn surveys. Minimum: 50 documents per ICP cohort.
2. **Tokenize into noun-phrases.** Run a noun-phrase chunker over the corpus. Collapse near-duplicates (singular/plural, common synonyms). Strip kill-list and stop-words.
3. **Score.** Compute TF-IDF (term-frequency × inverse-document-frequency) per noun-phrase against the corpus. High-frequency phrases that are also distinctive (low IDF rank) are the load-bearing language.
4. **Cluster into themes.** Group the high-TF-IDF phrases into a small number of themes (jobs, objections, alternatives-considered, words-they-use). The themes are the operating taxonomy.
5. **Use verbatim.** The theme labels and the high-weight phrases go directly into copy, headlines, paid-ad hooks, sales-pitch openers, and landing-page sections. Marketer-paraphrase is forbidden until a verbatim baseline exists.

## Variation

- **Crestodina** owns the *content-marketing surface* (mining for blog headlines, SEO titles).
- **Wiebe** owns the *conversion-copywriting craft* (verbatim copy as A/B-test winner).
- **Dunford** owns the *positioning surface* (verbatim category-noun, alternative, value theme).
- **Eisenberg** owns the *CRO surface* (every page element as VoC trace).
- Convergence: extract verbatim, deploy verbatim, paraphrase last (if at all).

## Implication

For PMMs, content marketers, conversion copywriters, and CRO leads:

1. **Build the customer-language corpus before writing copy.** A 50-document minimum per cohort, refreshed quarterly. The corpus is a first-class substrate artifact.
2. **Run TF-IDF (or noun-phrase frequency) on the corpus monthly.** The high-weight phrases are the operating headline candidates. New phrases entering the top-20 are signals (new pain, new alternative, new framing).
3. **Tag every copy artifact with the source phrase and source document.** This closes the anti-fabrication loop: every claim traces to a real customer utterance.
4. **A/B test customer-phrase against marketer-phrase routinely.** The customer phrase wins 80%+ of the time on conversion. The few exceptions teach you about your specific market.
5. **Build the messaging matrix's "words they use" column from the TF-IDF output.** This is the cell that makes the matrix grounded; without it, the matrix is the marketer's hypothesis, not the customer's reality.

## Counter-evidence

- **Highly regulated language** (medical, legal, financial-disclosure) sometimes requires marketer-paraphrase to comply with disclosure rules; customer-verbatim may include unverified claims that cannot ship.
- **Pre-product-market-fit** corpora may be too small for stable TF-IDF; below 30-50 documents, frequency signal is unreliable. Use the qualitative themes instead.
- **Cross-language deployments** require translation, which inevitably paraphrases. The discipline is to extract verbatim in the source language, then translate with a native speaker who preserves the tonal weight.

## Sources

- ins_crestodina-message-mining, Andy Crestodina, *Content Chemistry* and Orbit Media essays
- ins_wiebe-customer-language-as-copy, Joanna Wiebe, Copyhackers (Conversion Copywriting course)
- ins_dunford-listen-for-words, April Dunford, *Obviously Awesome* and live workshops
- ins_eisenberg-voice-of-customer-research, Bryan Eisenberg, *Call to Action*
- ins_jtbd-interviews-surface-customer-language, Bob Moesta (related)

See also:
- `pat_copywriting-craft-fundamentals` (the broader craft pattern; this one specifies the *substrate*).
- `pat_frontline-as-pmm-substrate` (the upstream rule that the corpus exists in the first place).
- `pat_jtbd-as-buyer-mental-model` (the interview methodology that produces a primary corpus).
