---
name: prospect-identification
description: Resolve a placeholder / anonymized prospect from a recruiter post or stealth-mode signal into a verified candidate landscape. HARD-FAILS — refuses to write the dossier finalist — when company cannot be positively identified from public sources (founder name confirmed via LinkedIn, domain confirmed, JD URL accessible). Produces a stub dossier with the candidate landscape, the searches run, the anti-fabrication refusal, and a recommended next-step (typically DM the recruiter).
version: 0.2
status: wired
updated_date: 2026-05-18
amplifies: independent operator triaging an unidentified prospect, recruiter-fed pipeline researcher, anyone working a stealth-mode signal
masters: Lori Lustig (boutique executive recruiter using placeholder names for client confidentiality — taught the canonical stub-vs-pick discipline), Maria Ross (verify-before-naming discipline for early-stage targeting), Patrick Campbell (structured candidate research over vibes), Aatir Abdul Rauf (PMM cheat sheet on prospect-dossiering), Bellingcat (OSINT verify-before-publish posture applied to consulting prospects), April Dunford (three-divergent-paths discovery discipline applied to candidate-landscape ranking)
substrate_layers_required: [prospect-research]
patterns_grounded: [anti-fabrication-on-prospects, candidate-landscape-not-finalist]
contradictions_aware: [hard-fail-vs-soft-fail-on-unidentified]
preflight_refusal: substrate-gap, missing-recruiter-post-text, missing-category-hint, anti-fabrication-tripwire
required_reads:
  - knowledge/patterns/anti-fabrication-on-prospects.md
  - knowledge/patterns/candidate-landscape-not-finalist.md
  - knowledge/contradictions/hard-fail-vs-soft-fail-on-unidentified.md
---

# prospect-identification

## Purpose

`bin/substrate-bootstrap-prospect` assumes the prospect is named. The pipeline has unnamed prospects — recruiter placeholder names ("AI Rocketship" is the canonical example, where the actual client is obscured by design), stealth-mode startups, founder posts that hint without naming. Substrate has no skill for resolving the placeholder before the engagement is possible. This skill builds the candidate landscape and refuses to pick a finalist without harder evidence than candidate-overlap. The output is a stub dossier in the substrate-grade refusal pattern: documents the searches, names the candidates, refuses to fabricate, recommends the next-step.

## When to use

- A recruiter post uses a placeholder company name (the AI Rocketship case).
- A reaction signal names a role but no company.
- A stealth-mode startup is hinted but not named.
- A target-account search returns "company B-XXXXX" via intent data without an open identifier.
- A founder's post hints at hiring without naming the company.

## Inputs

- `--signal-source <recruiter-post|reaction|stealth|intent-data|founder-hint>` (required)
- `--post-url <url>` (required if `signal-source` is recruiter-post or reaction)
- `--post-text <text>` (required) — the literal verifiable text of the signal
- `--role-specifics <yaml>` (required) — extract verifiable facts: title, location, hybrid/remote, comp band if disclosed, hiring person if disclosed
- `--category-hint <slug>` (required) — domain hint from the signal (e.g. `aeo-geo`, `legal-compliance-ai`, `data-observability`)
- `--output <path>` (optional, default `data/research/<slug>-stub.md`)
- `--anti-fabrication-mode <hard-fail|soft-fail>` (optional, default `hard-fail`) — see UPGRADES punt #3

## Substrate reads

- `knowledge/patterns/anti-fabrication-on-prospects.md` — the load-bearing pattern (Lustig precedent, Bellingcat OSINT methodology, Kesava's wiki anti-fabrication rule).
- `knowledge/patterns/candidate-landscape-not-finalist.md` — the rank-don't-pick discipline (Bellingcat, Dunford three-divergent-paths, Kesava's five-tier evidence ladder).
- `knowledge/contradictions/hard-fail-vs-soft-fail-on-unidentified.md` — the conditioning rule. Default is hard-fail per resolution #3 in `UPGRADES-2026-05-18.md` (Kesava 2026-05-18).
- `PRINCIPLES.md` rule 1 — the anti-fabrication rule the skill enforces.
- *(External, operator-specific)* your own `concepts/evidence-ladder.md` — five-tier attribution system (or bring your own).
- *(External, operator-specific)* stub dossiers from your pipeline — canonical hard-fail precedents (kept private to the operator).

## Preflight refusal — the HARD-FAIL gate

Per resolution #3 in `UPGRADES-2026-05-18.md` (Kesava 2026-05-18): **this skill HARD-FAILS — refuses to write the dossier finalist — when company cannot be positively identified from public sources.** Positive identification requires ALL THREE:

1. **Founder name confirmed via LinkedIn.** Not "a founder named in the post" — the actual LinkedIn profile, accessible and matching the recruiter's signal.
2. **Domain confirmed.** The company's website URL is accessible, the LP carries the JTBD the post hints at, and the about-page/team-page corroborates the founder name from step 1.
3. **JD URL accessible.** The specific role is posted at the company's career page (Greenhouse / Lever / Ashby / Airtable / company-hosted), with role text that matches the recruiter post.

If ANY of the three fails, the skill ships a stub dossier — never a finalist. There is no soft-version where "it's probably Company X." The stub IS the artifact.

### Stub pattern — the AI-Rocketship-style refusal

Canonical stub pattern: the operator's private stub dossiers (kept in their own pipeline research directory) demonstrate the refusal in practice. Substrate ships the pattern; the operator's dossiers are the evidence.

A stub carries:
- `status: stub` in frontmatter; `candidates_named: false`.
- `name:` field is the placeholder (e.g. "AI Rocketship" or "Stealth-B2B-AI-NYC"), NOT a guess.
- Every unverified field is literally `unverified` (website, linkedin, hq, funding, fte_band, etc.). No defaults; no extrapolation.
- The literal signal text quoted verbatim (no paraphrasing).
- At least 3 ranked candidates with constraint-matches AND eliminators per candidate.
- The searches run (URL + date + outcome per search).
- An explicit refusal rationale citing `PRINCIPLES.md` rule 1 (anti-fabrication).
- A recommended next-step — usually "DM the recruiter directly" or "open the JD form in browser to extract company description."

The stub stays a stub through subsequent revisits. When fresh signal lands (the recruiter discloses, the founder posts, a JD URL appears at a verified domain), the operator re-runs the skill. The skill flips `status: stub → identified` only when the three-gate clears.

## Process

1. Extract verifiable facts from `--post-text`. The skill records the literal quote and only the literal quote in the dossier. No paraphrasing.
2. Build the constraint set from `--role-specifics` and `--category-hint`. Examples:
   - Location: NYC or SF, hybrid/remote
   - Stage: venture-backed, "breakout"
   - Role shape: founding (no existing role-holder)
   - Category: AEO/GEO (inferred from "redefining how brands get discovered")
3. Run candidate-landscape searches across at least 4 surfaces:
   - The category itself (companies in the named category)
   - The recruiter's other recent placements (if a recruiter is named)
   - Career pages of the top 10 fitting candidates (for the actual JD)
   - The signal-source person's LinkedIn (for adjacent context)
4. For each candidate found, record:
   - Company name
   - Constraint-match per constraint
   - Eliminator (if any — e.g. "5 days in office contradicts hybrid/remote tag")
   - JD present at company career page (yes / no / unclear)
   - Evidence-ladder tier (verified / self-reported / contextual / indirect / direct) per the wiki concept
5. Run the three-gate positive-identification check on the top candidate:
   - **Gate 1: Founder name confirmed via LinkedIn?** If no, HARD-FAIL → stub.
   - **Gate 2: Domain confirmed (LP + about-page corroborates)?** If no, HARD-FAIL → stub.
   - **Gate 3: JD URL accessible and matching the recruiter signal?** If no, HARD-FAIL → stub.
6. If multiple candidates fit equally, OR if any of the three gates fail on the top candidate, OR if the top candidate has any constraint-violation, refuse to name. Write the stub dossier with the candidate landscape, the searches run, the refusal rationale, and the recommended next-step.
7. Emit the stub at `data/research/<slug>-stub.md` with `status: stub` in frontmatter. When the three-gate clears, emit at `data/research/<slug>.md` with `status: identified`.

## Output contract

```yaml
---
asset_type: prospect-stub
produced_by: prospect-identification
name: <placeholder-name>  (e.g. "AI Rocketship" or "Stealth-B2B-AI-NYC")
slug: <placeholder-slug>-stub
tier_initial: pending
ai_posture: pending
source_wave: <signal-source>
signal_url: <url>
researched_date: <YYYY-MM-DD>
website: unverified
linkedin: unverified
hq: <location-from-signal>
funding_total: unverified
fte_band: unverified
category: <category-hint>
attribution: unverified
status: stub  # company not positively identified
candidate_count: <int>
candidates_named: false
substrate_cited:
  - knowledge/patterns/anti-fabrication-on-prospects.md
---

# <placeholder-name> — STUB

**Status:** Could not positively identify the unnamed <placeholder> client from <signal-source>. Anti-fabrication rule blocks naming a candidate without harder evidence. This file documents what was searched, the candidate landscape, and the next-step recommendation.

## What the signal says (only verified facts)

<literal quote from --post-text>

<signal-source person + their org if applicable>

## What was searched

1. <search 1> — <URL> — <date> — <outcome>
2. <search 2> — <URL> — <date> — <outcome>
3. <search 3> — <URL> — <date> — <outcome>
4. <search 4+> — ...

## Candidate landscape (N finalists, ranked, not picks)

These all fit <category-hint> + <constraints>. None match all of <constraint list> cleanly.

1. **<Candidate A>** — <stage, location, evidence>. <constraint matches> / <eliminator>.
2. **<Candidate B>** — ...
3. **<Candidate C>** — ...

## Why we're not naming a finalist

Naming any of the <N> without harder evidence violates `PRINCIPLES.md` rule 1 (anti-fabrication). The signal narrows the universe to ~<N> candidates but doesn't pin one.

## Recommended next-step

<concrete action — usually "DM the recruiter" or "DM the founder" with a short script>

Alternative: <secondary path>

## Source citations

- <URL 1>
- <URL 2>
- ...
```

When the skill *does* identify the candidate (rare but possible), the output is a full dossier per the substrate prospect dossier template (not a stub). Frontmatter flips: `status: identified`, `candidates_named: true`, the named company in `name:`.

## Quality criteria

- HARD-FAIL by default. Refuses to name a finalist when ANY of the three positive-identification gates fails (founder name via LinkedIn, domain confirmation, JD URL accessibility). The skill ships a stub, never a guess. Resolution #3 in `UPGRADES-2026-05-18.md` (Kesava 2026-05-18): "Skill HARD-FAILS — refuses to write the dossier finalist — when company can't be positively identified."
- Refuses to name a finalist on candidate-overlap alone. Multiple candidates fitting equally = stub, not pick.
- Refuses to paraphrase the signal text. Literal quote only.
- Refuses to fabricate any field. `unverified` is the default for every field without first-hand evidence.
- Refuses to declare "JD posted" without a verified URL.
- Refuses to declare "role-holder absent" without a company-page cross-check.
- Soft-fail is an explicit override per `con_hard-fail-vs-soft-fail-on-unidentified`, not a default. Requires logged rationale, risk flag carried forward to every downstream touch, and recalibrates to hard-fail on the next engagement with the same signal source if a burn occurs.

## Contradictions awareness

- `hard-fail-vs-soft-fail-on-unidentified` — the skill defaults Position A (hard-fail, stub-only). Soft-fail (Position B) ships the most-likely candidate with a flag. The conditioning evidence: when the pipeline is hot and the operator needs to ship outreach within a tight window, soft-fail may be acceptable — but the stub-first pattern argues otherwise (named-without-evidence burns both the recruiter relationship and the candidate-company relationship simultaneously). Default A; override with logged rationale.

## Refusal patterns

- `SUBSTRATE-GAP — no post-text` → cannot identify without the literal signal. Refuse.
- `SUBSTRATE-GAP — no category hint` → without a domain, the candidate landscape is too wide. Refuse.
- `ANTI-FABRICATION-TRIPWIRE — multiple candidates fit equally` → ship stub, refuse to pick.
- `ANTI-FABRICATION-TRIPWIRE — top candidate has a constraint violation` → ship stub, refuse to pick. Even one violation matters (e.g. a remote-mandate candidate eliminated by an "in-office" requirement).

## What this skill does NOT do

- Does not DM the recruiter. The skill recommends the DM; the operator sends it. (Composes with `referral-targeting` for the actual DM draft.)
- Does not pick a finalist on weak evidence. Anti-fabrication is the load-bearing rule.
- Does not generalize to identified prospects — for those, run `bin/substrate-bootstrap-prospect` directly.
- Does not run continuous monitoring of the recruiter / signal-source for new posts. (That's a separate watcher routine, deferred.)

## See also

- `bin/substrate-bootstrap-prospect` — the named-prospect entry point.
- `skills/referral-targeting/` — the next-step DM (usually to the recruiter). Reads this skill's output's `anti_fabrication_mode` field and refuses outreach drafting against a hard-fail stub.
- `knowledge/patterns/anti-fabrication-on-prospects.md` — the load-bearing pattern.
- `knowledge/patterns/candidate-landscape-not-finalist.md` — the rank-don't-pick companion.
- `knowledge/contradictions/hard-fail-vs-soft-fail-on-unidentified.md` — the default-rule resolution (Kesava 2026-05-18: hard-fail by default).
- `PRINCIPLES.md` rule 1 — anti-fabrication rule.
- *(External, operator-specific)* stub dossiers from your own pipeline — the canonical hard-fail precedents (private to the operator).
- `UPGRADES-2026-05-18.md` — gap analysis that derived this skill (Resolution #3 inline).

## Future work (deferred to substrate v1.7 back-half)

- Wire to `referral-targeting` so a hard-fail stub dossier blocks outreach drafting at the framework level (today it's a manual preflight check).
- `--continuous-monitor` mode that re-runs the searches on a 7-day cadence and pings the operator if the candidate landscape changes (e.g. one of the candidates posts the actual JD).
- `--browser-extract` mode that drives a browser automation tool to open a LinkedIn post that Exa hasn't indexed yet, extract the actual post content, and re-run the candidate-landscape search with the surfaced detail.
