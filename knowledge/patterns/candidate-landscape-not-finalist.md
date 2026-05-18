---
id: pat_candidate-landscape-not-finalist
title: Rank candidates, don't pick a finalist, when evidence stops short of positive identification
captured_date: 2026-05-18
convergence_count: 3
tier: A
uses_cards: [ins_bellingcat-rank-dont-pick, ins_dunford-three-divergent-paths, ins_kesava-five-tier-evidence-ladder]
domains: [prospect-research, osint, evidence-discipline]
---

# Rank candidates, don't pick a finalist

## Convergence

Three operators converge on the same publishing-rule for partially-resolved signals: when evidence narrows the universe to N candidates but doesn't pin one, the correct output is a *ranked candidate landscape*, not a finalist pick. The discipline is structural — picking the most-likely candidate on overlap alone introduces fabrication risk that compounds downstream (every outbound touch built on the pick re-cites the fabricated identification). Ranking with named eliminators and constraint-matches preserves the evidence ladder.

## Operators

- Bellingcat (open-source intelligence), `ins_bellingcat-rank-dont-pick`. The OSINT methodology: when entity-resolution stops short of certainty, publish the candidate set with confidence levels. Bellingcat's investigations frequently end with "this is one of three units" rather than "this is the unit." The credibility of the publication compounds from the discipline of not over-claiming.
- April Dunford (positioning methodology), `ins_dunford-three-divergent-paths`. Dunford's discovery work surfaces *three divergent paths* when interviewing customers — three distinct framings of the buyer's worldview — before any positioning pick. The discipline is the same: name the possible positions before committing to one. Multiple-candidates-named-then-narrowed is the rigorous shape.
- Kesava (five-tier evidence ladder, substrate `PRINCIPLES.md` five-tier evidence ladder), `ins_kesava-five-tier-evidence-ladder`. Every metric, claim, or attribution tags as one of: verified (public record), self-reported (operator's word), contextual (role implies), indirect (someone else built, operator influenced), direct (operator built end-to-end). A finalist pick on candidate-overlap alone defaults to contextual at best; rigour requires verified.

## Variation

- Bellingcat operationalises it for *OSINT publishing* — public-facing investigations.
- Dunford operationalises it for *positioning discovery* — internal-facing customer research.
- Kesava operationalises it for *career-ops research* — substrate-internal prospect research.
- Convergence: name the candidates, rank them, document the constraints, refuse to collapse to one without verified-tier evidence.

## Implication

For substrate-grade prospect research:

1. **Build at least 3 candidates.** A "candidate landscape" with one option is a pick, not a landscape. A landscape with two is a binary not a rank. Three is the minimum that demonstrates the operator considered alternatives.
2. **Tag each candidate with constraint-matches and eliminators.** Per constraint: does this candidate match? If they have an eliminator (e.g., "5 days in office contradicts hybrid/remote tag"), name it explicitly. Eliminators are the discipline — they show the rank isn't arbitrary.
3. **Cite the evidence tier per candidate.** A candidate whose JD URL is verified and whose role-holder absence is confirmed clears verified-tier. A candidate inferred from category-overlap alone clears contextual-tier at best. Name the tier in the dossier.
4. **Document the searches run.** Each search with a URL, a date, and an outcome. The searches are the audit trail for the refusal.
5. **Recommend the next-step that would resolve the landscape.** Usually: a direct contact (DM the recruiter, ghost_read the application form, open the LinkedIn post in browser). The next-step closes the evidence gap; without it, the stub is stuck.

## Counter-evidence

- For **single-candidate domains** (a stealth-mode startup whose category, location, and founder are all verifiable from public sources, just not the company name), the landscape may legitimately be N=1. The pattern still applies — record the one candidate, mark constraint-match, but cite the missing piece (the company-name itself).
- For **time-critical pipeline shipping** where the operator has already chosen to ship outreach to the most-likely candidate (soft-fail mode), the candidate-landscape document remains the audit trail. The pick is logged with a risk flag; the landscape is the rollback path if the pick is wrong.

## Sources

- ins_bellingcat-rank-dont-pick, Bellingcat OSINT methodology (bellingcat.com guides + *We Are Bellingcat*)
- ins_dunford-three-divergent-paths, April Dunford (*Obviously Awesome* positioning interview methodology)
- ins_kesava-five-tier-evidence-ladder, Kesava Mandiga (substrate `PRINCIPLES.md` five-tier evidence ladder)

## Related substrate

- `skills/prospect-identification/SKILL.md` — composes this pattern as the load-bearing ranking discipline
- `knowledge/patterns/anti-fabrication-on-prospects.md` — companion pattern for the refusal layer
- `knowledge/contradictions/hard-fail-vs-soft-fail-on-unidentified.md` — the conditioning on hard-fail-vs-soft-fail
- *External:* substrate `PRINCIPLES.md` five-tier evidence ladder — the wiki-level evidence tier rule
