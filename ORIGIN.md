---
title: Substrate, origin (v0.1 → v1.6)
status: living document
last_updated: 2026-05-18
---

# Origin

The lineage from v0.1 (the context thesis) through v1.5 (16 surfaces with end-to-end orchestrations). Roughly fifteen versions over eight months.

This document profiles what each version got right, what it got wrong, why a rewrite happened mid-stream, why a merge happened after, and what's still ahead.

---

## The lineage in brief

**v0.1, the thesis.** Two operators with the same model and different context produce wildly different work. The move is not "use AI more." It is "make the context sharper." Skills and routines encoded as plain markdown. No measurement yet.

**v0.2, the loop.** A seven-step loop. The goal as a falsifiable prediction. An accuracy ledger schema. The architecture was right from day one. The content was thin because the context to fill it didn't exist yet.

**v0.3, the first ingest.** Playbooks, battle cards, vertical guides, a canonical ICP. Goals got grounded. Personas got first sketches. The closing step (context update on resolution) was named but not built.

**v0.3.5, the operator as context.** Your own work history is context too. The pattern of how you actually work is context the system can read. Not yet wired as an automated input, but the idea was named.

**v0.4, buyer language.** Hundreds of sales calls and best-deal analyses, plus a competitive battle-card for the segment. The position was correct; delivery was the bottleneck. The canonical ICP rebuilt from buyer language, not marketer language.

**v0.5, the runtime.** A working system. The seven-step loop ran end-to-end. The closing step built and smoke-tested on a real artifact. The external metric named: revenue per operator, computed via a market-rate cost framework. The stand-in audience calibrated. Dozens of active goals, several resolved. Per-(operator, taste-type) accuracy recorded. The system became something the operator could name without flinching.

**v0.6, specced, never shipped.** Specced as "more steps and more scanners." Architectural surgery deferred when a client-isolation gap surfaced. The directory structure stayed as reference for v0.7.

**v0.7, clean rewrite.** Built in parallel. Eight layers: context, skills, goals, routines, UX, accuracy, principles, reconciliation. Per-project structure. A 10-layer context model per project. Skill specs with refusal patterns. Personas across multiple axes. Principles codified. Freshness windows on every layer. The always-on reconciliation step (the weekly knowledge check) named. Architecturally complete; runtime not yet wired.

**v0.8, the merge.** v0.5's runtime, the working CLI, the long-running scheduler tasks, the stand-in audience corpus, the goal artifacts, the accuracy history, merged into v0.7's redesign as a single repo. Conflicting v0.5 directories preserved as an archive layer. Pre-merge state archived as a frozen historical snapshot.

**v0.9, runtime wired plus ship layer.** The skills-to-runtime gap closed. The composite gate (citation check, voice, refusal pattern, copy quality) callable from a single dispatcher. The accuracy loop running. The weekly knowledge check on a schedule. The dashboard regenerated from the live ledger.

**v1.0, open-source release (May 2026).** v1.0 is the public cut. The runtime works end-to-end: the accuracy ledger drives routing decisions, every external draft routes through the pre-publish check, every goal carries a measurement contract, the post-ship monitoring loop closes. The OSS release strips every client-specific artifact (positioning, ICP, competitive, voice-of-customer, deliverables, ledger entries) and ships the framework: the loop, the principles, the skills, the gates, the calibration ledger, and the personas-as-fragments architecture. Released MIT.

**v1.1, the codex-grounded knowledge layer (May 2026).** v1.0 had skills and principles. v1.1 wires them to a corpus. 39 cross-source synthesis patterns mirror in from the codex insight library (`knowledge/patterns/`); 11 contradictions move with them (`knowledge/contradictions/`). A new principle (rule 9): every skill grounds in at least one pattern and declares contradiction-awareness where relevant. Twenty-one new skills scaffold to fill operator-grade gaps the codex revealed: frontline-contact, win-loss-interview, tactical-empathy-discovery, narrative-strategy, status-quo-frame, agent-jtbd-map, eval-rubric, pricing-strategic, aeo-relevance, aeo-manual-action, pseo-framework, lp-cro-rubric, mental-models, design-principles, design-thinking-content, help-docs, campaign-strategy, launch-plan, messaging-matrix, pmm-coaching, capability-pin. Total skills: 37 across nine surfaces. The frontline-contact routine joins the loop family.

**v1.2, portability and behavioral grounding (May 2026).** Two structural moves. The first is portability: the FLYWHEEL_ROOT environment variable renames to SUBSTRATE_ROOT (with a deprecation alias that stays valid for one release cycle); client-specific hardcodes get stripped from skill runtimes; the per-client `competitors.yaml` and `verticals.yaml` configuration replaces inline competitor lists; `bin/substrate-bootstrap-prospect` pre-seeds both files from templates so a freshly bootstrapped client can run gated skills immediately. Substrate becomes runnable against any client, not just the maintainer's last engagement. The second is behavioral grounding: rule 9a adds gates 9 and 10 to the pre-publish-check composite gate. Gate 9 verifies that an asset's body actually evidences the patterns its producing skill declared (hand-tuned regex / phrase signatures per pattern, soft-fail by default, hard-fail under `STRICT_PATTERN_CHECK=1`). Gate 10 verifies that contradiction-aware skills name the picked position AND tie the pick to a conditioning fact; hard-fail. The asset's frontmatter `produced_by: <skill>` is what fires both gates. Declaration is the floor; behavior is the bar. Auto-skill-proposal lands in the digest-ingest routine: when a codex digest surfaces a new pattern with no substrate hook, the runner files a skill proposal alongside the knowledge addition.

**v1.3, sprint 1 surfaces (May 2026).** Five new surfaces: consulting-engagement orchestration, paid-ads / performance, email / lifecycle, retention / customer-success, ABM / sales-engagement. Twenty-four new skills (consulting-poc, six paid-ads, five email, six retention, six ABM); twelve new patterns (creative-fatigue-window, channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution, engagement-decay-as-relevance-signal, sender-reputation-is-a-domain-asset, one-segment-one-trigger, subject-line-as-experiment-not-art, aha-moment-defines-activation, retention-cohort-curves-over-blended-rates, behavioral-expansion-signals-beat-tenure, churn-prediction-vs-churn-diagnosis, plus the four ABM patterns: trigger-events-beat-cadence-blast, account-not-lead-as-unit, rhythm-beats-blast, status-quo-is-the-real-objection-outbound). Three new contradictions (save-everyone-vs-let-the-wrong-fit-go, personalization-vs-scale, outbound-vs-inbound-budget). Six new single-purpose routines (ad-fatigue-routine, ad-allocation-routine, email-decay-routine, email-deliverability-monthly, retention-monthly, expansion-watcher, sales-trigger-routine, account-tier-review). Total skills: 61 across fifteen surfaces. The consulting-poc skill is the load-bearing entry point for new client engagements; it composes positioning-forge, status-quo-frame, narrative-strategy, lp-ship, and eval-rubric into a 5-day fixed-price POC.

**v1.4, end-to-end orchestrations (May 2026).** Substrate had 13 single-purpose routines and 61 skills, but no named PMM / GTM cycles that composed them. v1.4 adds 8 end-to-end orchestrations: new-client-onboarding-week-1, quarterly-pmm-cycle, launch-flow, full-funnel-audit, customer-conversation-rhythm, aeo-publish-cycle, competitor-watch-cycle, expansion-flywheel. Each orchestration composes 4-12 skills into a working operator cycle, names cadence and owner, declares failure modes, and wires calibration hooks. Without orchestrations, substrate was a pile of skills; with them, it's an operating system. The README opens differently in v1.4: less of the "GTM problem" prose, more of the "two ways to use substrate" wedge. Either a single skill against a single artifact, or an end-to-end orchestration against a quarter's worth of work.

**v1.5, doctrine integration and sprint 2 surfaces (May 2026).** Substrate gets a layer above [PRINCIPLES.md](PRINCIPLES.md): [DOCTRINE.md](DOCTRINE.md) names the posture a team takes when running substrate. Five rules govern operating posture (context first, fewer assets higher ground, buyer as audience, authority follows accuracy, the loop closes). Sprint 2 lands alongside the doctrine: 17 new skills (analytics x 6, social x 5, support x 6) bringing total to 72; 17 new patterns (each with hand-tuned behavioral signatures); 12 of the existing 22 50-LOC stubs deepened to substantive runtimes (3,893 LOC for stubs-1 batch, 5,233 LOC for stubs-2 batch); 16 sprint-1 patterns gain hand-tuned signatures so Gate 9 enforces sharpness on every pattern.

**Forward roadmap (not yet shipped).** Per-org accuracy ledgers that compose across multiple installations. Browser-based UX for non-CLI users. Per-skill bin/ implementations for the v1.1 skills that still ship with rich SKILL.md but stub bin/. Surfaces still unaddressed: PR / earned media, brand, partnerships / community, recruiting / employer brand. The orchestration catalog will deepen as those land.

---

## What v0.5 got right

**The loop shape.** Seven steps. The closing step writes back to the first. Correct. Unchanged in v0.7+.

**The goal primitive.** A goal is a falsifiable prediction with an accuracy score. The right unit of strategic intent. Unchanged.

**The stand-in audience gate.** Scoring drafts against vertical and role-shaped buyer panels before any human reviews them. Collapses most reviewer cycles. Unchanged.

**Revenue per operator as the metric.** Computed via a market-rate cost framework. The right metric. Unchanged.

**The accuracy leaderboard.** Per-(operator, taste-type) record. Routing decisions follow the ledger, not the org chart. Unchanged.

**Voice of customer as four inputs.** Case studies, public reviews, sales/CS calls, market research. Any chain citing voice of customer must reach across all four. Unchanged.

---

## What v0.5 got wrong

**Project specificity at the context level.** v0.5 was one client all the way down. Personas referenced that client's competitors. Goals cited that client's metrics. Skills had that client's examples baked in. The loop was theoretically portable but practically locked. v0.7 enforces the separation at the directory level.

**Measurement contracts were not a gate.** Goals could open without a clear resolution method. The field existed but was checked informally. v0.7 made it a hard gate: the goal linter blocks `open` state if `measurement_contract` is empty.

**No freshness system on context.** v0.5 context accumulated. Layers from earlier versions still got cited without a freshness check. v0.7 added a freshness window per layer type and a staleness flag system.

**Signals were flat files.** Intel and research lived as unstructured markdown. There was no signal-analyst step; raw intel went straight into context or into goal packets. v0.7 gives signals their own architecture: typed ingest, proposal queue, human approval before context updates.

**Logs accumulated without retention.** Hundreds of draft generation and pre-publish-check logs. Useful for debugging; noise for operations. v0.7 keeps logs per-project and per-run, retains only the scoring log for accuracy.

**Wave-based generation wasn't operator-controlled.** Drafts ran across all goals at once. Some goals were exploratory; some were ready to ship. v0.7 generates per-goal on demand.

---

## Why v0.5 → v0.6 didn't happen

v0.6 was specced as "more pipeline plus more automation." That compounds the complexity of a system that already has a project-specificity problem.

Adding automation to a system that's locked to one project at the data layer doesn't produce a general tool. It produces a faster locked tool.

The multi-project context thesis requires a portable context layer that doesn't carry one project's data into another. That means architectural surgery, not a feature addition. v0.6 would have been a fifth coat of paint on a house with a bad foundation. v0.7 is the rebuild.

## Why the merge happened

The clean-rewrite argument said don't carry v0.5's project-specific data forward. That argument was correct for the context schema and the project boundary. It was wrong for the runtime.

v0.5 had: a working CLI, a wired scheduler, a stand-in audience corpus calibrated through use, a months-deep accuracy history, a dashboard generator already running on a real ledger. Rebuilding any of this from scratch would have cost weeks to recreate functionality that already worked.

v0.7 had: the right architecture (eight layers, per-project structure, refusal-pattern gates, freshness windows, the 10-layer context index), a clean context for one project, personas across categorical axes, the principles codified.

The merge wired v0.5's runtime to v0.7's architecture. Conflicting v0.5 directories preserved as an archive so v0.7's canonical content stayed clean while v0.5 history stayed accessible. The non-conflicting runtime kept its top-level paths so the scheduler tasks kept resolving without changes.

The decision was: take the runtime, keep the architecture, ship the wired result.

---

## Why the rewrite is clean, not incremental

Three things justified a clean rewrite over an incremental port:

1. **The project boundary is a structural constraint.** You cannot add project isolation to a single-project system without touching every file. A clean start with a per-project namespace is less work than migrating.

2. **The freshness system changes the context schema.** Adding freshness windows to existing layers requires schema migration on every layer file. A new schema is cleaner.

3. **The signal architecture is a new layer.** It doesn't map onto any existing directory in v0.5. Adding it incrementally would produce a hybrid with two competing models for how intelligence enters the context.

v0.5 ran in parallel with v0.7 for several days. v0.8 merged them into a single repo. Same principles. Same data layer. Different release-track than v1.0.

---

## What v1.2 changed

**Portability.** v1.0 and v1.1 were portable in theory; in practice the substrate codebase carried client-shaped artifacts inside skill runtimes. The competitive-scout skill knew one client's competitor matrix; the AEO skill knew that client's vertical taxonomy; the dispatcher named that client in default fallbacks. Each of those was a soft-fail when running against a different client. v1.2 stripped them: per-client `competitors.yaml` and `verticals.yaml` replaced inline lists; templates pre-seeded both files at bootstrap; the FLYWHEEL_ROOT environment variable renamed to SUBSTRATE_ROOT (with a deprecation alias that stays valid for one release cycle); LaunchAgent comments and dashboard URLs got generic. The result: a substrate clone runs against `clients/<any-prospect>/` without code changes. The portability work shipped on its own branch (`agent/portability`) so the diff was readable.

**Behavioral grounding (Rule 9a).** Rule 9 said every skill grounds in patterns and declares contradiction-awareness; the runtime validated that the named pattern files existed and fed their bodies to the model. But the runtime never re-read the *output* to confirm the model used what it was given. A skill could pass with a frontmatter list of patterns and produce an asset that ignored every one of them. Rule 9a closes that gap. Two new gates compose into pre-publish-check:

- Gate 9 (pattern-applied) scans the asset body for a behavioral signature drawn from the pattern's `## Implication` and `## Convergence` sections. The signatures are hand-tuned per pattern in `bin/lib/skill-pattern-check.sh::pattern_signature_for()`. Soft-fail by default to preserve momentum; hard-fail under `STRICT_PATTERN_CHECK=1` or when the named skill's `SKILL.md` carries `enforce_patterns: true`.
- Gate 10 (contradiction-position-logged) requires the asset to (a) name the picked position (A, B, C, ...) AND (b) cite the conditioning evidence that justified the pick. Acceptable forms include frontmatter `contradiction_positions:` + `position_rationale:`, an inline `[contradiction:<slug>] picked Position A because <conditioning>`, or a `## Contradiction navigation` section that names the slug, position, and rationale. A bare "Position A" without rationale fails. Hard-fail.

The gates fire only when an asset's frontmatter has `produced_by: <skill>`. Substrate's own structural docs (PRINCIPLES.md, README.md, ORIGIN.md) don't carry that frontmatter, so they pass through unchecked; customer-facing assets do, so they get gated. Declaration is the floor; behavior is the bar.

**Auto-skill-proposal.** The digest-ingest routine got a new check: when a codex digest surfaces a pattern that lands at `knowledge/patterns/<slug>.md` and zero existing skills declare `patterns_grounded: <slug>`, the runner files a skill proposal alongside the knowledge addition. Rule 9 from the other side: every pattern has a skill or a proposal for one.

## What v1.3 changed

**Five new surfaces.** v1.1 ended with nine surfaces (discovery, strategy, agents, content production, evaluation, goals, AEO triangle, competitive, hygiene). v1.3 adds five: consulting-engagement, paid-ads / performance, email / lifecycle, retention / customer-success, ABM / sales-engagement. Twenty-four new skills, twelve new patterns, three new contradictions. The skills are real runtimes (3,690 LOC for the retention surface alone, 3,626 for the ABM surface), not stubbed prompt-emitters; they read CSVs, run cohort math, parse RSS feeds, audit DNS records, score accounts on weighted features. End-to-end validation against synthetic test clients confirmed every refusal path before merge.

**Consulting-poc as the engagement entry point.** The consulting-poc skill orchestrates a 5-day fixed-price POC: Phase 0 (free public-surface audit), Phase 1 (5-day fixed-price engagement that ships positioning, status-quo, narrative, messaging matrix, one customer-facing artifact, and a 90-day calibrated roadmap), Phase 2 (optional retainer / embedded / train-the-team continuation). The skill grounds in seven patterns including `diagnose-before-execute`. The Phase 0 audit is the consulting offer; without it, Phase 1 refuses.

**Six new patterns ABM-side.** Trigger events beat cadence-blast, account-not-lead-as-unit, rhythm-beats-blast, status-quo-is-the-real-objection-outbound. Each pattern carries 3+ operator citations (Aaron Ross, Jeb Blount, Sam Nelson, Becc Holland, Sangram Vajre, Jon Miller, Bev Burgess, Maja Voje, Trish Bertuzzi, John Barrows, April Dunford, Anthony Pierri, Jessica Fain). The contradictions add personalization-vs-scale and outbound-vs-inbound-budget. Skills declare both in `contradictions_aware`; runtimes condition on per-client context.

## What v1.4 changed

**End-to-end orchestrations.** v1.3 had 13 single-purpose routines and 61 skills. The gap was named PMM / GTM cycles that composed them into operator-readable workflows. A new operator opening substrate in v1.3 saw a registry of skills and a registry of single-purpose routines and had to assemble the cycle themselves. v1.4 closes the gap with 8 orchestrations:

- **`new-client-onboarding-week-1`** — Day-by-day Week 1 sequence for a paid engagement. Day 1 bootstrap + ICP cut. Day 2 positioning + status-quo. Day 3 narrative + messaging matrix. Day 4 first customer-facing artifact. Day 5 diagnostic report + 90-day roadmap with three calibrated goals. Composes consulting-poc.
- **`quarterly-pmm-cycle`** — The PMM function as a closed quarterly loop. Refresh + open at week 1; signal + competitive continuous; mid-quarter checkpoint at week 6; resolve + calibrate at week 13.
- **`launch-flow`** — End-to-end launch as research-preview-and-cadence: plan, brief and generate, preflight every asset, ship in cadence, post-launch holdout, debrief and Brier score.
- **`full-funnel-audit`** — Quarterly cross-surface diagnostic: paid + email + activation + retention + churn, with ranked drivers per surface and three opened goals naming the next quarter's funnel-shaping bets.
- **`customer-conversation-rhythm`** — 30 / 60 / 90 cadence on top of the per-role weekly minimums. 30-day quota review, 60-day substrate update from rolled-up VoC, 90-day calibration and quarterly tactical-empathy run.
- **`aeo-publish-cycle`** — Monthly publish-and-measure rhythm wrapping the weekly aeo-routine. Week 1 queue refresh, weeks 2-3 generate, week 4 ship through composite gate, month +1 re-pull and Brier score.
- **`competitor-watch-cycle`** — Weekly surveillance with quarterly re-baseline. Monday scout pull, Tue-Wed battle-card audit, Thursday status-quo refresh, Friday narrative-drift, quarterly comprehensive teardown.
- **`expansion-flywheel`** — Closed loop from retention's cohort read to expansion's revenue: weekly trigger watcher, monthly retention review feeds the queue, monthly NPS routing, per-trigger expansion outbound design, quarterly resolve.

Each orchestration declares cadence, owner, skills composed, inputs required, outputs produced, failure modes, calibration hooks. The routines/README.md catalog now splits orchestrations from single-purpose loops; orchestrations are the named entry points an operator picks; loops are the recurring sub-cadences they wrap.

**README rewedge.** The v1.0 opening was five paragraphs of GTM-problem prose. The v1.4 opening leads with the wedge in two paragraphs and adds a "Two ways to use substrate" section near the top: a single skill against a single artifact (existing), or an end-to-end orchestration against a quarter's worth of work (new). Without that pivot, a new operator reading the README couldn't tell whether substrate is a CLI or an operating system. With it, they can.

---

## What hasn't changed across versions

The underlying thesis hasn't changed across any version:

> AI is not the multiplier. The context AI reads is. Two operators with the same model and different context produce wildly different work. The move is not "use AI more." The move is "make the context sharper."

v0.1 had this right. Every version confirmed it. v0.9 confirmed it again. v1.0 confirmed it once more, with operating authority and full data access behind it. v1.4 confirms it at scale: 61 skills, 55 patterns, 14 contradictions, 8 orchestrations, 15 surfaces, all reading the same context layer, all gated by the same checks, all producing calibration data that compounds. The architecture exists to enforce this thesis, not to contradict it.

---

## What v1.6 changed

Three new skills, one new orchestration, two digest-derived AEO upgrades. The consulting pipeline gap analysis surfaced four artifacts buyers ask for that substrate had no skill for. v1.6 closes the gap.

- `case-study-compose` takes customer transcripts plus a named outcome and emits the case-study artifact with the procurement-defensible narrative arc (what changed, why it stuck, what we shipped, what it produced, the customer's words, caveats). Composes claim-verify and voice-enforce on the output. Frontmatter carries attribution tier, operational definition, and produced_by so pre-publish-check gates fire. Five top-10 consulting prospects asked for this shape verbatim.
- `founder-voice-substrate` reads a founder's public corpus and composes the voice substrate file at `clients/<client>/brand-voice/founder-voice.md`. Computes cadence stats, extracts up to 5 reusable narrative beats by n-gram recurrence, derives the kill-list from corpus absence, and catalogs the proof-line library. voice-enforce reads this file to positively score "this sounds like the founder." Four top-10 prospects asked directly; five more imply it structurally.
- `allowed-claims-register` scans the client's public surfaces for numeric and superlative claims and emits the procurement-defensible register with nine columns (claim, attribution, source-of-truth, operational definition, time period, comparison anchor, audit trail, allowed surfaces, status) plus the procurement-failure section that flags claims that will not survive vendor security review. Four top-10 prospects asked for it directly.
- `founding-marketer-charter-week-1` is the new orchestration. Sibling to `new-client-onboarding-week-1`. Same five days, different terminal artifact: the charter doc the founding-marketer hire reads on day one, plus the substrate the charter authorizes against. Five top-10 prospects fit this shape; five more are structurally adjacent. Highest-frequency single shape in the pipeline.
- `aeo-relevance` v0.3 adds the first-600-words plus provenance gate per Kevin Indig's reporting on the Microsoft Bing grounding-architecture inversion. The unit of value moved from documents to discrete groundable facts. Pages that rank but bury their load-bearing claims past the 600-word boundary are invisible to grounding. The skill enforces a three-step audit before any other scoring dimension fires.
- `aeo-manual-action` v0.3 adds the GEO-risk pre-investment gate per Lily Ray's cascade research. AI systems retrieve via RAG from Google's index; a Google penalty propagates across every AI surface. The gate runs eight checks (5 red flags plus 3 foundation checks) before any GEO investment is approved.
- Two new skill proposals filed: `aeo-per-engine-gap` per Indig's 2.37% cross-engine overlap finding, and the structural pattern of per-surface (not aggregate) AEO measurement.

The v1.6 cut: substrate now ships 75 wired skills, 9 end-to-end orchestrations, and 2 v0.3 AEO upgrades sourced directly from the miniu daily digest pipeline. The self-evolution loop closes: research surfaces a pattern, the loop files an upgrade or a proposal, the operator reviews, the skill ships.
