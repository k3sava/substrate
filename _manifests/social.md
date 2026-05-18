---
asset_type: manifest
manifest: social surface
authored_by: agent/social
authored_date: 2026-05-08
branch: agent/social
---

# Social surface manifest

The social surface adds 5 skills, 3 patterns, 2 routines, and 3 template fixtures to substrate. Every skill grounds in at least one of three social-specific patterns; every customer-facing output composes `voice-enforce`; every skill refuses on a missing canonical positioning. Real text math, real metric math, real CSV parsing. The substrate refuses bad input across organic + creator-led + influencer-collaboration social work, the way the paid-ads surface refuses bad input across paid social.

A B2B social-media operator could run their first weekly cycle using only this surface plus the substrate context layer. Calendar in, drafts out. Drafts out, voice-enforce gate. Metrics CSV in, fatigue flags out. Mentions CSV in, theme clusters out. Roster in, ranked influencer tiers out. Every load-bearing claim cites either a substrate path or a pattern file.

---

## Files added

### Skills (five)

| Path | Purpose |
|---|---|
| `skills/social-content-design/SKILL.md` | Specifies platform-native draft shape per platform: LinkedIn long, LinkedIn text, X thread, X single, TikTok, Instagram caption, YouTube short. Refusal triggers, output contract, voice-gate composition. |
| `skills/social-content-design/bin/social-content-design` | Python runtime, 844 LOC. Reads positioning + ICP + brand voice + buyer-state cohort + optional calendar slot; renders platform-native draft with hook, body, close, format constraints, anchor terms; composes `voice-enforce` on every body. |
| `skills/social-fatigue-monitor/SKILL.md` | Rolling-window decay watcher shape: required CSV headers, decay-shape classification, severity-tiered flags, author-lane comparison, cadence-gap surfacing. |
| `skills/social-fatigue-monitor/bin/social-fatigue-monitor` | Python runtime, 616 LOC. Reads `clients/<client>/social/metrics/<platform>-<YYYY-MM>.csv`, computes 4-week-vs-prior-4-week lift on impressions and engagement rate, classifies decay shape, flags posts beyond one stdev below mean, writes severity-tiered digest. |
| `skills/social-amplification-test/SKILL.md` | A/B test design shape: hook / format / time test types, baseline-engagement input, target-lift, sample-size window calculation, measurement contract emit. |
| `skills/social-amplification-test/bin/social-amplification-test` | Python runtime, 593 LOC. Two-proportions z-test sample-size calculation (no numpy), per-platform engagement baseline, variant scaffold per test type, writes test spec + measurement contract stub. |
| `skills/social-listening-themes/SKILL.md` | Mention-corpus theme analysis shape: source-CSV schema, TF-IDF cluster shape, theme + competitor + viral-hook routing, off-brand flagging. |
| `skills/social-listening-themes/bin/social-listening-themes` | Python runtime, 637 LOC. Reads `clients/<client>/social/mentions/<source>-<YYYY-MM>.csv`, tokenizes, computes TF-IDF-shaped weights against in-corpus baseline, clusters by token similarity, surfaces themes / competitor mentions / viral hooks / off-brand. |
| `skills/influencer-fit-score/SKILL.md` | Influencer-roster scoring shape: five fit dimensions (ICP, audience overlap, voice alignment, topic alignment, prior relationship), hard-disqualification rules, tier bands, output contract. |
| `skills/influencer-fit-score/bin/influencer-fit-score` | Python runtime, 769 LOC. Reads `clients/<client>/social/influencers.yaml`, scores per-dimension against canonical positioning + ICP + brand voice, applies hard rules (anti-ICP, kill-list voice, brand-safety flags, active-competitor collab), assigns tier (1A/1B/2/defer/dq), writes ranked report. |

### Patterns (three, in `knowledge/patterns/`)

| Path | Purpose |
|---|---|
| `knowledge/patterns/native-format-beats-cross-post.md` | Convergent claim: each platform has native rhythms; cross-posted content underperforms native authoring substantially. Operators: Justin Welsh, Sahil Bloom, Jasmin Alic, Chenell Basilio. |
| `knowledge/patterns/creator-not-corporate.md` | Convergent claim: personal accounts reach further than corporate accounts on most B2B social platforms. Operators: Justin Welsh, Sahil Bloom, Yamini Rangan, Adam Robinson. |
| `knowledge/patterns/social-as-distribution-not-conversion.md` | Convergent claim: social drives top-of-funnel awareness; last-click attribution structurally undercounts its real role. Operators: Andrew Chen, Lenny Rachitsky, Joel Klettke. |

### Routines (two, in `routines/`)

| Path | Purpose |
|---|---|
| `routines/social-content-cycle.md` | Weekly seven-stage cycle: listen, draft, test, watch, influencer-fit-biweekly, ship, goal-close-loop. Pattern grounding: native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion. |
| `routines/social-fatigue-check.md` | Biweekly rolling-window decay watcher cadence. Pattern grounding: native-format-beats-cross-post, social-as-distribution-not-conversion, creative-fatigue-window. |

### Templates / fixtures (three, in `templates/`)

| Path | Purpose |
|---|---|
| `templates/social-calendar-example.yaml` | Worked example weekly calendar with 6 slots across personal + corporate authoring lanes, campaign-window declaration, overrides block. Used for smoke-testing `--calendar-slot` resolution and as a starter shape for operators. |
| `templates/social-mentions-example.csv` | Realistic 25-row LinkedIn / X / TikTok mentions corpus with role signals, competitor mentions, sentiment labels, off-brand trolling rows. Used for smoke-testing `social-listening-themes` and as a schema reference for operator exports. |
| `templates/social-influencers-example.yaml` | 8-influencer roster covering tier-1A primary partners, tier-1B exploratory, anti-ICP audience (auto-disqualified), brand-safety flags (auto-disqualified), active-competitor-collab (auto-disqualified). Used for smoke-testing `influencer-fit-score` and as a schema reference. |

### Manifest

| Path | Purpose |
|---|---|
| `_manifests/social.md` | This file. Inventory + design decisions. |

---

## Design decisions

### 1. Five skills, not four

The brief asked for 4-5 skills. Five landed because each captures a distinct mental model and refusal-pattern shape:

- `social-content-design` is the design operation. Pure synthesis from substrate, platform-shaped output. Composes `voice-enforce` on every body.
- `social-fatigue-monitor` is the watcher operation. Cron-friendly, compares window-over-window per platform, flags posts beyond one stdev below mean. Refuses on missing positioning.
- `social-amplification-test` is the experiment operation. Computes a sample-size window from baseline engagement + target lift + alpha + power. Refuses on missing positioning and missing cohort.
- `social-listening-themes` is the analysis operation. Reads mentions, tokenizes, clusters, surfaces themes + competitor mentions + viral hooks + off-brand. Refuses on missing mentions corpus.
- `influencer-fit-score` is the scoring operation. Reads roster + canonical positioning + ICP + brand voice + (optional) closed-won-overlap CSV; scores five dimensions with hard rules; tiers. Refuses on missing roster.

Collapsing any pair would conflate distinct mental models. The design op refuses without a buyer-state cohort; the watcher refuses without metrics. Same noun, different shape; combining would force one set of refusal triggers onto both.

### 2. Pattern grounding for every skill, with three new social-specific patterns

Every SKILL.md declares `patterns_grounded:`. The three new social-specific patterns ground every skill in this surface, plus the existing patterns for buyer-mindset, copywriting craft, frontline-as-PMM-substrate, distribution-as-moat, creative-fatigue-window, and measurement-correlated-short-signals.

The three new patterns each cite 3-4 named operators with public bodies of work:

- `native-format-beats-cross-post`: Welsh, Bloom, Alic, Basilio.
- `creator-not-corporate`: Welsh, Bloom, Rangan, Robinson.
- `social-as-distribution-not-conversion`: Chen, Rachitsky, Klettke.

Where exact quotes were not on hand, the citation paraphrases the operator's known body of work and references the public-position context. No fabricated quotes.

### 3. Voice-enforce composes on every customer-facing body

`social-content-design` calls `voice-enforce` on every draft body before write. Voice failures mark the file `voice_check: fail` and exit non-zero unless `--allow-voice-fail` is set for in-progress drafts. The other four skills (fatigue-monitor, amplification-test, listening-themes, influencer-fit-score) write internal-spec audit files that voice-enforce treats as substrate-internal (the path matches `*/substrate/*` and bypasses the em-dash + kill-list rules), so the voice gate is composed only on the surface that produces customer-facing copy.

This matches the existing surfaces' shape: `email-sequence-design` composes voice-enforce per step file; `lp-ship` composes per landing page section; `narrative-compose` composes per body. The audit-style outputs (`ad-fatigue-monitor`, `social-fatigue-monitor`, `email-engagement-decay-watcher`) skip the body voice gate because they are diagnostic reports, not publication-bound copy.

### 4. Refusal patterns are constitutional, not configurable

Every skill names refusal triggers in the SKILL.md frontmatter (`preflight_refusal:`) and enforces them in the bin runtime. Missing canonical positioning, missing brand voice, missing ICP, missing buyer-state cohort, missing metrics, missing mentions corpus, missing influencer roster, every one returns exit 3 with a structured message. There is no `--force` flag at the substrate gap level.

This follows `PRINCIPLES.md` rule 1 (context-first) literally. Social work is high-volume content with low signal density; running it on stale or absent positioning is precisely the failure mode the substrate is designed to refuse.

### 5. Real metric math, not heuristics

`social-fatigue-monitor` computes 4-week-vs-prior-4-week lift per metric per platform; flags posts more than one standard deviation below the platform's current-window mean; classifies decay shape via window-over-window math (sudden cliff = >40% drop; gradual taper = 4 consecutive weeks negative; step-down = persistent drop). All math is auditable from the digest output.

`social-amplification-test` computes the test-window via a two-proportions z-test using a Beasley-Springer-Moro inverse-normal CDF (no numpy / scipy dependency). The math runs in pure Python and the formula is shown in the test-design output.

`social-listening-themes` computes TF-IDF-shaped weights against an in-corpus token baseline, clusters by token similarity, and identifies themes + competitor mentions + viral hooks via routed weights. Stop-word lists are conservative; competitor slugs come from `clients/<client>/04-competitive.md` not from a fabricated list.

`influencer-fit-score` weights five dimensions (0.30 / 0.25 / 0.20 / 0.15 / 0.10) and applies hard rules before scoring. The audience-overlap dimension scores 0 when no CSV is supplied (so the model does not lie about coverage it does not have).

### 6. Personal-account default, corporate-handle as separate lane

Per `pat_creator-not-corporate`, B2B social ROI compounds on personal accounts. Every skill defaults to `--author personal` where the flag exists. The corporate-handle path is supported but separately framed: announcement copy, not growth copy. `social-fatigue-monitor` reports personal-vs-corporate engagement gap separately and flags if the corporate handle is being over-funded relative to personal accounts.

### 7. Cohort-level metrics, not last-click

Per `pat_social-as-distribution-not-conversion`, social drives top-of-funnel awareness; last-click attribution structurally undercounts. Every skill output names the cohort-level metrics that should be tracked (branded-search lift, audience overlap with closed-won, newsletter or trial signups via UTM, direct-traffic lift) and warns explicitly against allocating budget on last-click CAC. The amplification-test skill defaults alpha to 0.10 because short-signal social tests have lower noise floors than full-funnel paid tests; this is named in the spec.

### 8. Native-format authoring per platform, no cross-post default

Per `pat_native-format-beats-cross-post`, each platform has its own native rhythms. `social-content-design` has seven distinct platform renderers (LinkedIn long, LinkedIn text, X thread, X single, TikTok, Instagram caption, YouTube short) with per-platform format constraints baked into the runtime. The `--platform x-single --purpose teardown` mismatch case surfaces an `INPUT-WARN` because the structural fit is poor. `social-fatigue-monitor` reads metrics per platform; aggregate dashboards are explicitly not the unit.

### 9. Influencer-fit hard rules disqualify before scoring

`influencer-fit-score` applies hard rules before per-dimension scoring:

- Anti-ICP industry in influencer's audience → disqualified.
- Anti-ICP role in audience → disqualified.
- Kill-list voice overlap >2 hits → disqualified.
- Active-competitor exclusivity (competitor slug in `clients/<client>/04-competitive.md`) → disqualified.
- Brand-safety flags non-empty → disqualified.

Hard rules cite the rule that fired in the disqualification block. Soft rules contribute to the composite. This matches the `abm-account-prioritize` shape (anti-ICP industry → score 0, no recovery) and the `email-list-hygiene` shape (hard-bounce → suppress, no recovery).

### 10. Tier 1A is rare by design

The composite-to-tier bands are 75-100 (1A), 55-74 (1B), 35-54 (2), 0-34 (defer). Tier 1A is narrow because partnership effort compounds when concentrated; spreading tier-1A across many influencers dilutes the relationship investment. The audience-overlap dimension scoring 0 when no CSV is supplied keeps tier 1A genuinely scarce; supplying the closed-won-overlap CSV is what enables the model to confidently surface a tier-1A candidate.

### 11. `SUBSTRATE_ROOT` precedence and worktree-friendly path resolution

Every new bin runtime sets the root via `SUBSTRATE_ROOT` env var first, falls back to `FLYWHEEL_ROOT` (legacy), and finally walks the directory tree if neither is set. The `find_substrate_root()` helper walks parents looking for `skills/` and `knowledge/` siblings. This means the runtime works in worktrees and in non-standard checkout locations.

The `bin/lib/skill-preflight.sh` and `bin/lib/skill-pattern-check.sh` libraries were not modified.

### 12. Pattern-check signatures fall back gracefully

The three new patterns (`creator-not-corporate`, `native-format-beats-cross-post`, `social-as-distribution-not-conversion`) have heuristic signatures derived from `_pattern_fallback_signature()` because hand-tuning lives in `bin/lib/skill-pattern-check.sh` (out of scope for this surface). The signatures still hit reliably because the new patterns' titles contain load-bearing tokens that appear in the runtimes' rendered bodies (e.g., "personal accounts," "native rhythms," "social drives," "last-click attribution"). Verified end-to-end: every skill's output evidences every pattern in its `patterns_grounded` list under `pattern_check_all`.

---

## Verification log

Tested end-to-end with a synthetic client at `clients/test-social/` plus the example template files:

- `social-content-design --client test-social --platform linkedin-long --cohort solution-aware-head-of-sales --purpose thought-leadership`: draft written, voice-enforce PASS, all 5 declared patterns evidenced.
- `social-fatigue-monitor --client test-social`: 14 posts analysed across 1 platform, decay shape `step-down` detected, 3 flags raised, all 4 declared patterns evidenced.
- `social-amplification-test --client test-social --platform linkedin --cohort solution-aware-head-of-sales --test-type hook --baseline-engagement-rate 0.05`: sample-size window computed (6,427 per variant, 2 days estimated), test spec written, all 5 declared patterns evidenced.
- `social-listening-themes --client test-social --source linkedin`: 25 comments scanned, themes extracted, all 4 declared patterns evidenced.
- `influencer-fit-score --client test-social --influencers templates/social-influencers-example.yaml --audience-overlap-csv /tmp/test-overlap.csv`: 8 influencers in roster, 7 scored, 1 disqualified on brand-safety flag, all 5 declared patterns evidenced.

All refusal paths tested:
- `social-content-design` without `01-position.md`: REFUSED missing-positioning.
- `social-content-design` without persona file: REFUSED missing-buyer-state.
- `social-fatigue-monitor` without metrics dir: REFUSED missing-metrics.
- `social-listening-themes` with mentions CSV missing required columns: skips file with warn; no usable rows -> REFUSED missing-mentions.
- `influencer-fit-score` without roster: REFUSED missing-influencers.
- `influencer-fit-score` without brand voice: REFUSED missing-brand-voice.

`pattern_check_all` verified for every (skill, output) pair: rc=0 across all 5 skills.

`voice-enforce` verified PASS on every new SKILL.md, every routine, every pattern, every template.

---

## Lines of code

| Skill | LOC |
|---|---|
| social-content-design | 844 |
| influencer-fit-score | 769 |
| social-listening-themes | 637 |
| social-fatigue-monitor | 616 |
| social-amplification-test | 593 |
| **Total runtime** | **3,459** |

The depth bar named in the brief (≥150 LOC per bin runtime) is met by every skill, with the smallest at 593 and the largest at 844.

---

## Substrate flywheel integration

The surface ties to the existing substrate machinery in three places:

1. **Goals layer**: `social-amplification-test` writes a measurement-contract stub at `goals/measurement-contracts/<test-id>.md`. Each contract is a complete goal candidate, ready for `bin/substrate open-goal`.
2. **Calibration**: tested variants resolve via `score-goal`; the operator's per-(operator, social-distribution) Brier history compounds. Per `pat_social-as-distribution-not-conversion`, the predicted resolution metric is cohort-level (branded-search lift, audience overlap), not last-click.
3. **Pre-publish gate**: `social-content-design` composes `voice-enforce` directly. Any draft that fails voice gate exits non-zero unless `--allow-voice-fail` is set. The other social skills produce internal-spec audit files that compose into `pre-publish-check` via the `produced_by` frontmatter and the `patterns_applied` declaration; gates 7 and 8 (pattern-applied + contradiction-position-logged) verify behaviorally.

The result: a B2B social-media operator running this surface for a quarter produces calibrated outputs that feed the same calibration ledger as a PMM running narrative-strategy or a paid-marketing operator running ad-spend-allocate. Authority follows accuracy, not function. (`PRINCIPLES.md` rule 6.)

---

## What this surface intentionally does NOT do

- **Does not pull data from social platforms.** The operator (or a downstream connector) provides the CSV exports. Substrate's job is to refuse bad input, not to be a data pipeline.
- **Does not auto-publish.** Every skill is read-only; drafts are written, the operator schedules through the platform of choice.
- **Does not generate finished video, audio, or image assets.** `social-content-design` produces scripts and outlines; a downstream creative resource (or LLM call) generates the final media.
- **Does not run the A/B test.** `social-amplification-test` produces the design + measurement contract; the platform (or operator) executes; `score-goal` resolves the contract.
- **Does not contact influencers.** `influencer-fit-score` ranks fit; the operator runs outreach.
- **Does not modify other surfaces.** Email, retention, ABM, paid-ads, and the bin/lib libraries were left untouched per scope.

---

## See also

- `skills/README.md` for the registered skills (operator-curated, separate task)
- `routines/README.md` for the registered routines (operator-curated, separate task)
- `knowledge/patterns/INDEX.md` for the registered patterns (operator-curated, separate task)
- `goals/SCHEMA.md` for the measurement contract shape
- `PRINCIPLES.md` for the rules every skill follows
- `_manifests/paid-ads.md` for the closely-related paid-social surface
- `_manifests/email.md` for the closely-related lifecycle / nurture surface
