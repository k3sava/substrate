---
id: pat_anti-fabrication-on-prospects
title: Anti-fabrication on prospects — refuse to name a finalist when the candidate landscape doesn't resolve to one
captured_date: 2026-05-18
convergence_count: 3
tier: A
uses_cards: [ins_lustig-placeholder-name-discipline, ins_bellingcat-verify-before-publish, ins_kesava-anti-fabrication-rule]
domains: [career-ops, prospect-research, osint, anti-fabrication]
---

# Anti-fabrication on prospects

## Convergence

Three credible operators across recruiting, open-source intelligence, and career-ops convergence on the same discipline: a prospect signal that doesn't resolve to a single positively-identified company is a stub, not a pick. Refusing to name a finalist on candidate-overlap alone is the load-bearing rule. The verify-before-name posture protects both the operator's credibility (a wrong-named-company outbound burns the recruiter relationship and the candidate-company relationship simultaneously) and the substrate's evidence ladder (every named company is a verified-tier claim or it isn't).

## Operators

- Lori Lustig (boutique executive search, lorilustig.com), `ins_lustig-placeholder-name-discipline`. Lustig publicly uses placeholder names ("AI Rocketship", company-specific hashtags substituted with category-descriptive labels) to protect client confidentiality on LinkedIn. The placeholder is *deliberately* unidentifiable from the post text; identification requires direct contact with the recruiter. The discipline maps cleanly onto the operator-side rule: if the signal-source uses a placeholder, the operator's substrate must record the placeholder, not a guess.
- Bellingcat (open-source intelligence collective, bellingcat.com), `ins_bellingcat-verify-before-publish`. The Bellingcat methodology for OSINT publishing: every named entity must clear a verifiability bar (multiple independent sources, geolocation, temporal consistency, official record cross-check). Unverified candidates are named as candidates, not finalists. The publish-rule: rank, don't pick, when the evidence stops short of certainty.
- Kesava (career-ops anti-fabrication rule, `PRINCIPLES.md` rule 1 (anti-fabrication)), `ins_kesava-anti-fabrication-rule`. Every factual claim on a wiki page, portfolio page, CV, DM, or pitch must trace to a verifiable source. If you cannot cite the source, write "unknown" or "unverified" and stop. No invented metrics. No aggressive rounding. No guessed dates. No composite quotes.

## Variation

- Lustig provides the *signal-side discipline* — the recruiter intentionally obscures; the operator respects the obscuring.
- Bellingcat provides the *publishing-side discipline* — name what you can verify; rank candidates when you can't.
- Kesava provides the *operator-side discipline* — anti-fabrication applies to outbound substrate, not just published artifacts.
- Convergence: a candidate landscape with N candidates where none is positively identified is a *stub artifact*. Naming one of the N as the finalist on overlap alone violates the rule across all three sources.

## Implication

For prospect identification and substrate-grade research:

1. **Record the literal signal text.** No paraphrasing of the recruiter post, the founder hint, the stealth-mode description. The verifiable layer is the quote.
2. **Build the candidate landscape.** Across at least 4 search surfaces (the category, the recruiter's other placements, candidate career pages, signal-source LinkedIn). Record each candidate with constraint-match per constraint and eliminator (if any).
3. **Refuse to name a finalist on overlap alone.** If multiple candidates fit the constraint set equally, or if the top candidate has any constraint-violation, ship the stub dossier with the candidate landscape, the searches run, the refusal rationale, and the recommended next-step.
4. **Recommend the next-step explicitly.** Usually: DM the recruiter directly (Lustig's placeholders are designed to *require* this step). Alternative: open the LinkedIn post in a browser to read the actual content, check for investor logos in comments, etc.
5. **Re-run the searches on a cadence.** A stub from 2026-05-08 may resolve by 2026-05-22 if a candidate posts the actual JD. Document the date of the search; revisit the stub when fresh signal lands.

## Counter-evidence

- For **named prospects with a verified JD URL** (the standard substrate-bootstrap case), this pattern doesn't apply — `bin/substrate-bootstrap-prospect` handles identified prospects directly. The pattern fires only on *placeholder, stealth, or anonymized* signal.
- For **time-critical outreach** (the pipeline is hot, the role is closing in 48 hours), an operator may choose to ship outreach to the most-likely candidate with a logged risk flag (the soft-fail mode). The rule's default remains hard-fail; the soft-fail is an explicit override per `con_hard-fail-vs-soft-fail-on-unidentified`. Kesava's resolution on 2026-05-18: hard-fail is the default; AI-Rocketship-style stubs stay stubs until positively identified.
- For **public-sector or regulated procurement** where the prospect is required by law to disclose identity (RFPs, government contracts), the placeholder discipline doesn't apply — the public record is the verifiable substrate.

## The canonical stub case

The canonical precedent: a recruiter post uses a placeholder company name for client confidentiality. Four candidate companies fit the constraint set; none clears all constraints. The dossier ships as a stub with `status: stub` and `candidates_named: false`. The recommended next-step is "DM the recruiter directly." The stub stays a stub until the recruiter discloses the company name.

A second precedent: multiple companies share the same name / ticker, no positively-identified company from the job listing alone. The dossier ships as a stub; the recommended next-step is "open the application form to extract the company description and founder name."

Both stubs demonstrate the substrate-grade refusal pattern: rank candidates, document the searches, refuse to pick, recommend the next-step.

## Sources

- ins_lustig-placeholder-name-discipline, Lori Lustig (boutique executive search; lorilustig.com — public use of placeholder names for client confidentiality documented across LinkedIn posts)
- ins_bellingcat-verify-before-publish, Bellingcat (bellingcat.com OSINT methodology + *We Are Bellingcat* by Eliot Higgins)
- ins_kesava-anti-fabrication-rule, substrate `PRINCIPLES.md` rule 1 (anti-fabrication)

## Related substrate

- `skills/prospect-identification/SKILL.md` — composes this pattern as the load-bearing refusal rule
- `skills/referral-targeting/SKILL.md` — refuses to outreach against a stub dossier per this pattern
- `knowledge/contradictions/hard-fail-vs-soft-fail-on-unidentified.md` — the hard-fail-vs-soft-fail switch
