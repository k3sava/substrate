---
id: con_hard-fail-vs-soft-fail-on-unidentified
title: Hard-fail (refuse to name) vs soft-fail (ship most-likely-candidate with flag) on unidentified prospects
captured_date: 2026-05-18
---

# Hard-fail vs soft-fail on unidentified prospects

## Position A — hard-fail; refuse to name a finalist on overlap alone; ship a stub dossier
- Operator: Kesava (`ins_kesava-anti-fabrication-rule`), Bellingcat (`ins_bellingcat-rank-dont-pick`), Lori Lustig (`ins_lustig-placeholder-name-discipline`)
- Claim: when the candidate landscape doesn't resolve to a positively-identified company, the substrate-grade output is a stub dossier with the candidate landscape, the searches run, the refusal rationale, and the recommended next-step. Naming a finalist on overlap alone violates anti-fabrication: every outbound touch built on the pick re-cites the fabricated identification, and a wrong-named-company outbound burns both the recruiter relationship and the candidate-company relationship simultaneously. The AI Rocketship (Lustig client) precedent is the canonical case — 4 candidates fit, none cleared all constraints, stub stays a stub.

## Position B — soft-fail; ship the most-likely candidate with a logged risk flag and proceed with outreach
- Operator: pipeline-pressure heuristic (no canonical operator citation — this is the pragmatic counter-position), Mark Roberge (`ins_roberge-sales-as-engineering-discipline` — the volume-over-perfection frame applied to operator pipeline), Becc Holland (`ins_holland-personalization-from-event-not-bio` — the move-fast-on-fresh-trigger frame)
- Claim: in time-critical outreach windows (the role is closing in 48 hours, the trigger window is fresh and decaying, the operator's pipeline is dry), shipping outreach to the most-likely candidate with a logged risk flag may have higher EV than waiting for the recruiter response that confirms identification. The soft-fail logs the risk, names the candidate-pick, and proceeds; if the candidate is wrong, the operator burns one touch instead of forfeiting the window entirely.

## Conditions distinguishing them

- **Pipeline urgency vs naming-burn cost** is the dominant variable. Hot pipeline with a 48-hour window where the operator has no other prospects in shape → soft-fail tempting (Position B). Cold pipeline with a 2-week window and the operator has time to wait on the recruiter response → hard-fail dominant (Position A).
- **Prior burn precedent**: an operator with prior wrong-named-company outbound burns has a high cost on the next mistake; the rule defaults harder to A. An operator with no prior burns may have softer calibration on the cost.
- **Recruiter-side relationship value**: if the recruiter is a load-bearing pipeline source (e.g., Lori Lustig brings 3-5 founding-PMM placements per quarter), a wrong-named outbound that burns the recruiter is catastrophic. Hard-fail dominant. If the recruiter is a one-off signal source, soft-fail risk is lower.
- **Candidate landscape clarity**: if the top candidate clears 4 of 5 constraints with one minor constraint-violation, soft-fail is closer to honest. If the top candidate clears 2 of 5 constraints and three other candidates also clear 2 of 5, soft-fail is fabrication wearing a flag.

## Resolution / synthesis

Kesava's 2026-05-18 resolution: **hard-fail is the substrate default**. The AI Rocketship precedent + the recruiter-relationship value at Lustig-shape pipeline sources + the cost of compounding fabrication outbound = hard-fail is the rational default. The skill refuses to ship a finalist when the company can't be positively identified from public sources (founder name confirmed via LinkedIn, domain confirmed, JD URL accessible).

Soft-fail is an *explicit override*, not a default:

- The override requires a logged rationale (why is the pipeline urgency high enough to override anti-fabrication?).
- The override is recorded on the output artifact (`anti_fabrication_mode: soft-fail`, `pick_rationale: <text>`, `risk_flag: <text>`).
- The override produces a stub dossier *plus* the pick — not a regular dossier. The stub is the rollback path if the pick is wrong.
- The override defaults to hard-fail on the *next* engagement with the same signal source. A burn on soft-fail recalibrates the operator's reservation for the source.

## How substrate uses this contradiction

`prospect-identification` reads this contradiction's `Conditions` section and applies hard-fail by default:

- `--anti-fabrication-mode hard-fail` (default) → Position A. Stub dossier with candidate landscape, refusal rationale, recommended next-step. No outbound drafting permitted against the stub.
- `--anti-fabrication-mode soft-fail` (explicit override) → Position B. Stub dossier *plus* a `picked: <candidate>` block with `pick_rationale` and `risk_flag`. Outbound drafting permitted with the risk flag carried forward to every touch.

`referral-targeting` reads the upstream `prospect-identification` output's `anti_fabrication_mode` field and refuses outreach drafting against a hard-fail stub. Soft-fail picks pass through with the risk flag attached to the touch's frontmatter.

The position is recorded on the output artifact (`contradiction_positions.hard-fail-vs-soft-fail-on-unidentified: <A|B>`).

## The stub-dossier precedents

Both stubs (the operator's private stub dossiers) are load-bearing hard-fail precedents. They demonstrate the substrate-grade refusal pattern. Both stay stubs until positively identified — neither has been overridden to soft-fail. The default hardens with each precedent.
