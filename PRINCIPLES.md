---
title: Substrate, operating principles
status: active
last_updated: 2026-05-04
version: 0.9
---

# Principles

The operating rules that compound across sessions. Principles are the slowest layer to change. Routines move faster. Skills move fastest. Context moves at the rate of reality.

## Intent

**Make every operator more effective, more efficient, and more accountable. The system is the floor. People set the ceiling. The job is to enable both.**

This is the thesis. Every rule below derives from it.

The thesis serves a doctrine one layer above. [`DOCTRINE.md`](DOCTRINE.md) names the posture a team takes when running substrate: context first, fewer assets higher ground, buyer as audience, authority follows accuracy, the loop closes. Doctrine governs posture. The principles below govern skill behavior.

- **The system is the floor.** A baseline of effectiveness, efficiency, and accountability the system enforces structurally, citation gates, accuracy trackers, checks before publishing, single-verb commands. Nobody drops below the floor because the floor is structural, not personal.
- **People set the ceiling.** Taste, judgment, customer empathy, the moment a strategy actually clicks. These are human capabilities. The ceiling rises with the operator's skill, not with the system's.
- **Enablement is the bridge.** Skills, context, single-verb commands, accuracy data, these give every operator what they need to clear the floor without effort and reach for the ceiling without process drag.
- **Self-accountability first.** The same standard applies to the system's author. The point of the floor is that nobody, including the author, gets to skip it. The point of the ceiling is that everyone, including the author, has a path to keep improving.

## The nine rules (in order)

### 1. Context-first, always

Before any skill runs, any draft ships, any goal opens, the context that informs it must exist, be inside its freshness window, and be cited.

- If context is missing, run `refresh-knowledge` first.
- If context is past its freshness window, refresh it. Don't reuse.
- If a claim has no context path, mark it `unverified` and stop. Per the anti-fabrication rule.

The quality of input decides the quality of output. Goals opened on thin context produce thin work at every downstream skill.

This is the rule that beats "ship something now."

### 2. Falsifiability over plausibility

Every goal, every draft, every claim must be falsifiable. "Sounds right" is the enemy of "we can tell if we were wrong."

- A goal opens with a measurement contract, baseline, target, window, source, or it doesn't open.
- Draft claims trace to context or get cut.
- Predictions get an accuracy score on resolve. Honest losses count as much as wins; both update the tracker.

**Citation hierarchy** (source-system first, always):

1. **Source-system pull.** Direct from analytics, CRM, ad platform, project tracker. The canonical artifact is the dashboard query, API response, or project record. Cite chart ID, event name, query filter, timestamp.
2. **Operator-compiled workbook.** Acceptable when it aggregates source-system exports. Cite the compile step.
3. **Operator-reported claim** (status update, slide commentary, chat quote). Fallback only when source-system data isn't immediately accessible. Mark `attribution: self-reported, pending source-system verification` and schedule the verification.
4. **Inferred or paraphrased.** Never. If we can't trace it, mark `unverified` and stop.

This is the rule that beats "let's see how it lands."

### 3. The buyer is the audience, not the marketer

Drafts are tested against pinned buyer panels, not against the marketing team's taste. Internal applause is not signal.

- The stand-in audience runs against vertical, buyer-state, and role panels, buyer perspectives, not peer reviews.
- Voice of customer composes from four inputs: case studies, public reviews, sales/CS calls, and market research. Sales/CS calls weigh most.
- "The team thinks this is great" is not a green light. The stand-in audience score on outcomes and differentiation is the floor.

This is the rule that beats "the team loves this draft."

### 4. Outcomes, not features

People hire products for outcomes; features are the receipt. Every draft, every help doc, every goal leads with the outcome.

- Landing page hero is an outcome statement. Feature list goes below the fold.
- Help doc opens with "what you'll achieve." Steps follow.
- Goal headline is the outcome metric, not the feature shipped.
- Pricing pages lead with outcome value, not feature parity.

This is the rule that beats "the new feature deserves its own page."

### 5. One canonical narrative; reframe for audience, never split

One canonical position, one canonical narrative. Audience-specific entry doors are allowed; multiple positions is positioning failure.

- Three audience reframings, max. Different doors, same room.
- If a fourth is wanted, cut, don't add.
- A per-vertical playbook is an entry door, not a different position.
- The master narrative is the source of truth. If a downstream draft's claim isn't there, the draft is rejected.

This is the rule that beats "different segments need different stories."

### 6. Authority follows accuracy, not title

Whoever has the best accuracy on a craft cell calls the shot on that cell, regardless of org chart.

- The accuracy tracker is institutional memory.
- Decision authority on a craft is the top operator on that cell, with at least three resolved goals on it.
- Newer operators have their early cells flagged "early signal." They earn accuracy through honest plays.
- This is structure-agnostic. It works under any org shape leadership picks.

This is the rule that beats "the head of X said do it this way."

### 7. Pull, never push

Adoption is a signal of value. Push is noise. Adoption-by-mandate dies in 90 days; pull compounds.

- Skills only ship for operators who pulled them.
- Context layers get prioritized when downstream skills cite them.
- Cross-functional value happens through outcomes other teams can see, not through onboarding mandates.

This is the rule that beats "we should make X mandatory."

### 8. Revenue per operator is the only north star

Not headcount. Not output volume. Not engagement. Not impressions. Revenue per operator-hour is the unit.

- Every goal, every routine, every skill maps to revenue per operator. No vanity metrics.
- Capacity expansion (people do materially more) is the framing, never headcount contraction.
- The growth math: context compounds, output per operator-hour rises, revenue per operator rises, system flywheels.

This is the rule that beats every other metric debate.

### 9. Every skill grounds in patterns and knows the contradictions

A skill that runs without grounding in a convergent operator pattern is unrooted. A skill that runs across a contradiction without naming it picks one position by accident. Every `SKILL.md` declares both, the same way it declares `substrate_layers_required`.

**Patterns** are codex's distilled output: claims with 3+ operator citations.
- A skill cites at least one Tier A or Tier B pattern under `patterns_grounded`.
- A pattern with zero substrate hooks is observational; either build a skill, or move the pattern to `knowledge/learnings/`.
- New patterns enter substrate through `digest-ingest`, not through ad-hoc edits.

**Contradictions** are codex's record of where credible operators disagree on a substantive question.
- A skill that touches a contradicted area declares `contradictions_aware: [<slug>...]`.
- The skill's preflight reads the contradiction's conditioning variables and picks the position whose conditions match the client context.
- The output artifact records which position was applied and why.
- Substrate refuses to pick a global default for an open contradiction. The skill picks locally, with citation.

This is the rule that beats "let's add a skill that feels right." If three operators haven't converged on the underlying claim, the skill isn't ready. If two operators disagree and the skill silently picked one, the skill isn't honest.

#### 9a. Patterns and contradictions are behaviorally enforced, not just declared

Declaration is the floor; behavior is the bar. The preflight library validates that every named pattern + contradiction file exists, and the prompt emitter feeds their bodies to the model. But the runtime never re-reads the *output* to confirm the model used what it was given. A skill can pass with a frontmatter list of patterns and produce an asset that ignores every one of them. That gap closes here.

**Output assets carry `produced_by: <skill>` in frontmatter.** When the asset reaches `pre-publish-check`, two new gates run:

- **Gate 9 — pattern-applied** (`bin/lib/skill-pattern-check.sh`). For each pattern in the skill's `patterns_grounded`, scan the asset body for a behavioral signature — a regex or structural element drawn from the pattern's `## Implication` and `## Convergence` sections. The signatures live in `pattern_signature_for()`, hand-tuned per pattern (calibrated against the language operators actually use when applying the pattern). For `diagnose-before-execute`, the structural signal is also accepted: a Diagnosis/Audit/Understand section before any Plan/Recommendation section. Soft-fail by default (warn + log); hard-fail when `STRICT_PATTERN_CHECK=1` is set, or when the named skill's `SKILL.md` has `enforce_patterns: true`.

- **Gate 10 — contradiction-position-logged** (`bin/lib/skill-contradiction-check.sh`). For each entry in the skill's `contradictions_aware`, the asset must (a) name the picked position (A, B, C, …) AND (b) cite the conditioning evidence that justified the pick. Acceptable forms include frontmatter `contradiction_positions:` + `position_rationale:`, an inline `[contradiction:<slug>] picked Position A because <conditioning>`, or a `## Contradiction navigation` section that names the slug, the position, and the rationale. A bare "Position A" with no rationale fails — picking is conditioning-aware selection, not coin-flip. Hard-fail.

Why both gates: a skill that grounds in a pattern but produces output that ignores it is performing the ritual, not the work. A skill that's contradictions-aware but picks silently picks the wrong position 50% of the time on average; making the pick visible makes the calibration visible.

This is the rule that beats "we listed it in frontmatter, so we're grounded."

## Two more rules that apply across all eight

### Client data never crosses client boundaries

The system is architecture. The data is per-project. A position layer for Project A is not visible when working on Project B. Personas, voice-of-customer signals, competitive intelligence, and product knowledge are isolated per project directory. Only the framework layer (schemas, templates, routine logic, skill specs) is shared.

This is the trust contract. It is not a configuration option.

### The loop closes or it doesn't count

The closing step, context update on resolution, is not optional. When a goal resolves, the context updates to reflect what the resolution taught. If the goal said "this position works" and the resolution said "it didn't," the competitive layer and brand voice layer update accordingly.

A loop that doesn't close is a read operation, not a learning operation. The value is in the learning.

## Decision routing for common inflection points

### Should we open this goal?

1. Context cited? (Rule 1)
2. Measurement contract set? (Rule 2)
3. Buyer-tested or testable? (Rule 3)
4. Outcome metric, not feature metric? (Rule 4)
5. Canonical narrative consistent? (Rule 5)

If any answer is no, close the loop before opening.

### Should we ship this draft?

1. Citation gate (Rule 1).
2. Voice and refusal-pattern gates (Rule 5, single canonical narrative).
3. Stand-in audience score on outcomes and differentiation above the floor (Rule 3).
4. Outcome-led copy (Rule 4).
5. Pattern-applied + contradiction-position-logged (Rule 9a; the asset evidences the patterns the producing skill listed and names the conditioned position on each contradiction).
6. Pre-publish check composes all five. Pass means ship.

### Should we add this skill or routine?

1. Does an operator pull it? (Rule 7) If no operator pulls, defer.
2. Does it amplify a human craft, or replace one? Replace means redesign.
3. Does it raise revenue per operator? (Rule 8) Vanity skills get cut.

### Should we say yes to this segment or vertical?

1. Does context exist or can it be built within the contract window? (Rule 1)
2. Is the goal structure measurable? (Rule 2)
3. Does the buyer profile match a pinned persona axis we can stand-in-audience against? (Rule 3)
4. Will revenue per operator improve? (Rule 8)

### Should we override a gate?

1. Override is logged, attributed, with operator-justification.
2. Override counts in accuracy. Repeated overrides on the same gate mean the gate is broken or the operator is miscalibrated.
3. Citation override is forbidden. Anti-fabrication is constitutional.

### Should we keep, kill, or pivot this goal mid-flight?

1. Did the kill criterion fire? Kill, don't pivot. (Rule 2.)
2. Does new context invalidate the belief? Resolve as MISS with a note, open a new goal. Not pivot. Pivot is open-loop.
3. Has time elapsed without movement? Resolve with NULL classification. No data is data.

## Anti-patterns

- Don't soften the revenue-per-operator framing.
- Don't lead with headcount or org-shape.
- Don't push adoption.
- Don't fabricate quotes, metrics, or dates.
- Don't ship without the pre-publish check.
- Don't open goals without measurement contracts.
- Don't override gates silently.
- Don't pivot goals mid-flight; resolve and reopen.
- Don't measure things you can't act on.
- **Don't author from session memory.** Author from context. Every load-bearing claim, number, dollar, percentage, named competitor, named source-system, date, must trace to a context file path within the same paragraph or in a Source column. A frontmatter list of consumed context files is necessary but not sufficient. The citation gate looks for inline proximity. Trust the gate, not the author.

## Revision rules

Principles changes are durable. Add a new rule only if:

1. It survives at least three inflection points where existing rules didn't resolve cleanly.
2. It's logged with date, originator, and the inflection point that surfaced the gap.
3. It doesn't contradict an existing rule without an explicit deprecation note.

Principles is the slowest layer. The recurring routine moves faster. Skills move fastest. Context moves at the rate of reality.
