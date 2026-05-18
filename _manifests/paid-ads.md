---
title: paid ads surface, manifest
status: active
last_updated: 2026-05-08
agent: paid-ads
branch: agent/paid-ads
---

# Paid ads surface

Substrate's first end-to-end paid-marketing surface. Six skills that diagnose existing accounts, brief replacement creative, allocate spend with falsifiable predictions, monitor fatigue weekly, gate any claim of channel performance, and design incrementality tests with computed sample-size windows. Two routines, one weekly and one quarterly, that wire the skills into a closed loop with the substrate calibration ledger. Four patterns that ground every refusal trigger and every operational threshold in cited operator practice.

A paid-marketing consultant could run their first engagement using only this surface plus the substrate context layer. CSV in, diagnostic out. Diagnostic in, allocation out. Allocation in, goals open on the ledger. Goals close, calibration history compounds. Every load-bearing number in every output cites either a substrate path or a pattern file.

---

## Files added

### Skills (six)

| Path | Purpose |
|---|---|
| `skills/ad-diagnose/SKILL.md` | Specifies the audit shape: required CSV headers, refusal triggers, output contract for `clients/<client>/ads/diagnostics/<channel>-<YYYY-MM-DD>.md`. |
| `skills/ad-diagnose/bin/ad-diagnose` | Python runtime, 759 LOC. Parses CSV, aggregates per campaign, computes CAC / ROAS / CTR, detects waste / fatigue / ICP-mismatch / positioning-drift, renders structured diagnostic markdown. |
| `skills/ad-creative-design/SKILL.md` | Channel-specific brief shape (Google RSA, Meta image+caption, LinkedIn sponsored, X, TikTok, Reddit), refusal triggers, character-limit constraints. |
| `skills/ad-creative-design/bin/ad-creative-design` | Python runtime, 661 LOC. Reads positioning + competitive + brand-voice + buyer-state cohort, emits a structured brief per channel with anchor terms, kill-list exclusions, and per-channel format constraints. |
| `skills/ad-spend-allocate/SKILL.md` | Allocation shape: 70-20-10 default, predicted CAC / ROAS / kill criterion per slice, measurement-contract emit per channel. |
| `skills/ad-spend-allocate/bin/ad-spend-allocate` | Python runtime, 696 LOC. Reads recent diagnostics, classifies channels into proven / scaling / exploration, allocates per policy, emits one measurement contract per channel into `goals/measurement-contracts/`. |
| `skills/ad-fatigue-monitor/SKILL.md` | Weekly cycle shape: lookback window, persistence detection, recovery detection, brief-queue priming. |
| `skills/ad-fatigue-monitor/bin/ad-fatigue-monitor` | Python runtime, 434 LOC. Reads last N weeks of diagnostics, surfaces new / persistent / recovered fatigue flags, primes refresh briefs. |
| `skills/ad-attribution-honest/SKILL.md` | Defensive gate shape: required model + window + blind-spot proximity, --strict mode, asset-level vs claim-level disclosure thresholds. |
| `skills/ad-attribution-honest/bin/ad-attribution-honest` | Python runtime, 330 LOC. Scans an asset for "channel X drove Y" pattern claims, requires attribution model + window + blind-spot disclosure within proximity, fails the gate when bare claims exceed threshold. |
| `skills/ad-incrementality-test/SKILL.md` | Test design shape: geo-holdout vs psa-control, window calculation inputs, measurement plan, decision rules. |
| `skills/ad-incrementality-test/bin/ad-incrementality-test` | Python runtime, 692 LOC. Computes test window from baseline + MDE + alpha + power + treatment-share via two-proportions z-test (Beasley-Springer-Moro inverse normal, no numpy dep), writes test design + measurement contract. |

### Patterns (four, in `knowledge/patterns/`)

| Path | Purpose |
|---|---|
| `knowledge/patterns/creative-fatigue-window.md` | Convergent claim: paid-social creatives fatigue on a measurable window; refresh cadence is the lever. Operators: Wenograd, Foxwell, Burns, Orendorff. |
| `knowledge/patterns/channel-arbitrage-window.md` | Convergent claim: new channels yield outsize ROI for 6-18 months before saturation; track and rotate. Operators: Chen, Balfour, Rachitsky, Jorgensen. |
| `knowledge/patterns/intent-vs-interest-targeting.md` | Convergent claim: search ads buy intent, paid social buys interest; different funnels, different unit economics. Operators: Aslam, Kaushik, Fishkin. |
| `knowledge/patterns/incrementality-not-attribution.md` | Convergent claim: last-touch attribution overcounts paid; geo holdouts and lift studies measure what is actually incremental. Operators: Kaushik, Wenograd, Orendorff / CTC, Balfour / Reforge. |

### Routines (two, in `routines/`)

| Path | Purpose |
|---|---|
| `routines/ad-fatigue-routine.md` | Weekly five-stage cycle: pull export, diagnose per channel, monitor for persistent fatigue, brief refreshes, ship. Pattern grounding: creative-fatigue-window, intent-vs-interest-targeting. |
| `routines/ad-allocation-routine.md` | Quarterly eight-stage cycle: pre-quarter audit, LTV reconciliation, allocate via 70-20-10, open one goal per channel, schedule incrementality tests above 5% threshold, mid-quarter check-in, quarter-end resolution, plan next quarter. Pattern grounding: channel-arbitrage-window, intent-vs-interest-targeting, incrementality-not-attribution, creative-fatigue-window. |

### Templates (three, in `templates/`)

| Path | Purpose |
|---|---|
| `templates/ads-export-google-example.csv` | Realistic Google Ads CSV export. Columns: campaign, ad_group, date, impressions, clicks, spend, conversions, conv_value, channel, match_type. Five campaigns across brand / non-brand / competitor / broad / generic, weekly cadence over April 2026. |
| `templates/ads-export-meta-example.csv` | Realistic Meta Ads CSV export. Columns: campaign, ad_set, creative_id, date, impressions, clicks, spend, conversions, conv_value, frequency, cpm, channel. Three campaigns (prospecting, retargeting, brand-display) with multiple creatives showing fatigue patterns. |
| `templates/competitors-ads-spend-example.yaml` | Schema for competitor paid-ads tracking. Spend per channel with confidence tier, GTM signals (status-quo target, named competitor targets), notable creatives with funnel stage, propagation targets. |

### Manifests + READMEs

| Path | Purpose |
|---|---|
| `_manifests/paid-ads.md` | This file. Inventory + design decisions. |
| `skills/README.md` (modified) | New table section: paid-ads / performance, with one-line entries for each of the six skills. |
| `routines/README.md` (modified) | Two new entries under "Concept routines (the loops)": ad-fatigue-routine.md (weekly) and ad-allocation-routine.md (quarterly). |
| `knowledge/patterns/INDEX.md` (modified) | New section "Paid-ads / performance patterns (4)" listing the four patterns with substrate hooks. Coverage table updated to show 4 paid-ads patterns. |

---

## Design decisions

### 1. Six skills, not four. Layered diagnostic / brief / allocate / monitor / gate / test

The brief asked for 4-6 skills. Six landed because each captures a distinct mental model and refusal-pattern shape:

- `ad-diagnose` is the read operation. Pure parser, no recommendation it does not cite.
- `ad-creative-design` is the brief operation. Pure synthesis from substrate, channel-shaped output.
- `ad-spend-allocate` is the decision operation. Reads diagnostics, applies LTV / CAC, emits measurement contracts.
- `ad-fatigue-monitor` is the routine operation. Cron-friendly, compares week-over-week, primes the brief queue.
- `ad-attribution-honest` is the gate operation. Defensive, asset-agnostic, composes with `pre-publish-check`.
- `ad-incrementality-test` is the experiment operation. Computes a sample-size window from baseline, emits a goal contract.

Collapsing any pair would conflate distinct mental models. The diagnostic refuses without ICP; the gate refuses without an attribution model named near the claim. Same noun, different shape; combining would force one set of refusal triggers onto both.

### 2. Refusal patterns are constitutional, not configurable

Every skill names refusal triggers in the SKILL.md frontmatter (`preflight_refusal:`) and enforces them in the bin runtime. Missing canonical positioning, missing canonical ICP, missing recent diagnostic, missing baseline conversions, every one returns exit 3 with a structured message. There is no `--force` flag. The substrate gap is fixed before the skill runs, or the skill does not run.

This follows `PRINCIPLES.md` rule 1 (context-first) literally. Paid-ads decisions are among the highest-stakes calls in marketing; running them on stale or absent context is precisely the failure mode the substrate is designed to refuse.

### 3. Statistical depth in `ad-incrementality-test`

The test-window calculator uses a two-proportions z-test with a Poisson-approximation variance and a Beasley-Springer-Moro inverse-normal CDF. No numpy / scipy dependency. The math runs in pure Python and the formula is shown in the test-design output, so the operator can audit every input that drove the window number.

Tradeoffs:
- The Poisson approximation is conservative for small N (variance is overstated, so the window is longer than a tighter-fit method would compute). Acceptable: longer windows are safer than too-short windows.
- The two-proportions z-test does not model treatment-control matching variance directly. A future version could integrate Synthetic Control Method or CausalImpact for tighter market-pair matching. The current shape gates the right decision (run a real test) without overcomplicating the first cut.
- Treatment-share imbalance is modeled as `1 / (4 * p * (1-p))`, which is exact for binomial variance scaling. Simple and correct.

### 4. Measurement contracts are first-class

Two skills (`ad-spend-allocate` and `ad-incrementality-test`) emit measurement contracts directly into `goals/measurement-contracts/`. The contract is shaped to be ready for `bin/substrate open-goal`, with all required fields populated:

- `goal_id`, `client`, `opened_at`, `status: proposed`
- `hypothesis` with mechanism + evidence + counterfactual
- `predicted_outcome` in metric / direction / threshold / window / cohort form
- `revenue_lever` with `lever_type`, `annual_revenue_impact_usd`, and the explicit calculation
- `measurement_design` with source / method / cohort / join key / ambiguous case
- `resolution_date`, `predicted_p_threshold_met`, `kill_criterion`
- `substrate_layers_cited`, `patterns_applied`

This means a paid-marketing consultant runs `ad-spend-allocate` once per quarter and gets a stack of falsifiable goals ready to score at quarter-end. The calibration ledger compounds over time. The system gets sharper as the operator gets sharper.

### 5. Pattern grounding for every skill

Every SKILL.md declares `patterns_grounded:` with at least one of the four new paid-ads patterns. `ad-attribution-honest` and `ad-incrementality-test` ground in `incrementality-not-attribution`. `ad-fatigue-monitor` and `ad-creative-design` ground in `creative-fatigue-window`. `ad-spend-allocate` grounds in all four. `ad-diagnose` grounds in three.

The pattern files themselves are written with real operator citations (Wenograd's published positions on creative-as-targeting, Aslam's Solutions 8 / Perpetual Traffic body of work on Google-vs-Meta, Chen's *Law of Shitty Clickthroughs*, Balfour's Reforge curriculum on incrementality and channel-product-fit, Kaushik's *Web Analytics 2.0* and the See / Think / Do / Care framework). No fabricated quotes. Where a specific quote was not on hand, the citation paraphrases the operator's known body of work and references the source.

### 6. `SUBSTRATE_ROOT` not `FLYWHEEL_ROOT`

Per the brief: every new bin runtime sets the root via `SUBSTRATE_ROOT` env var first, falls back to `FLYWHEEL_ROOT` (legacy) if `SUBSTRATE_ROOT` is not set, and finally walks the directory tree if neither is set. This is forward-compatible with the rename Agent A is doing.

The `bin/lib/skill-preflight.sh` shared library (which other agents are extending) was not modified.

### 7. ICP-mismatch and positioning-drift detection are heuristic, by design

`ad-diagnose` flags audiences not in ICP and ad copy that contradicts canonical positioning, but does so via name-token heuristics (campaign name contains "consumer" when ICP is B2B, campaign name contains a vertical not in the canonical ICP list). The skill does not parse ad creative directly; it parses campaign / ad-set names that the operator named with intent.

The flags are deliberately conservative. The operator confirms before any pause. This avoids the false-positive failure mode where the skill yells about every campaign with a fashionable adjective in its name. The right shape is "human + skill," not "skill replaces human."

### 8. Channel KPI separation is enforced in `ad-diagnose`'s output

The channel-fit note in `ad-diagnose` names which pattern (`intent-vs-interest-targeting`) applies to the channel and which KPI is the right fit. Holding paid-search to brand KPIs is named as a category mistake; holding paid-social to last-click CAC is named as a known undercount. This is read directly from the pattern; the skill does not decide; it surfaces.

### 9. The fatigue thresholds vary per channel

`ad-diagnose` carries a `FATIGUE_THRESHOLDS` map that varies CTR-decline %, frequency ceiling, and CPM-rise % by channel. Meta is 30 / 3.0 / 25; LinkedIn is 25 / 5.0 / 20; TikTok is 35 / 2.5 / 30. Google Search is 40 / null / 35 because search creative does not fatigue on the same curve (the buyer triggers the impression).

These numbers come from the implication section of `creative-fatigue-window.md`, which itself summarises Wenograd / Foxwell / Burns / Orendorff defaults. Concrete enough to act on, soft enough that the operator can override per channel-specific knowledge.

### 10. The 5% incrementality threshold is hard-named in `ad-incrementality-test`

`pat_incrementality-not-attribution` names a 5%-of-budget threshold above which incrementality testing is required. `ad-incrementality-test` reads recent diagnostics, computes the channel's share of the last-90-days total spend, and emits a `SCOPE-WARN` when the channel sits below 5%. The test still runs (the warning is informational), so a small-budget operator can run a test for learning purposes; but the artifact records the warning so the calibration history reflects which channel-shares the test was actually informative against.

This is one place where the pattern's threshold is named as a number in the artifact, not just in prose, so the system can compound on it.

---

## What this surface intentionally does NOT do

- **Does not pull data from ad platforms.** The operator (or a downstream connector) provides the CSV. Substrate's job is to refuse bad input, not to be a data pipeline.
- **Does not change anything in ad accounts.** Every skill is read-only on the platforms. Recommendations are advisory; the operator decides.
- **Does not run the incrementality test.** `ad-incrementality-test` produces the design + the measurement contract. The platform (or operator) executes; `score-goal` resolves the contract.
- **Does not generate finished creative.** `ad-creative-design` produces structured briefs. A downstream LLM call (or human writer) generates the variants. The brief is the input to the generator, not the generator.
- **Does not modify other surfaces.** Email, retention, ABM, FLYWHEEL_ROOT renaming, gate-library extensions, README.md, goals/ledger.md were all left untouched per scope.

---

## Verification log

Tested end-to-end with a synthetic client at `/tmp/substrate-incr-test/` plus the example CSV templates:

- `ad-diagnose` against `templates/ads-export-meta-example.csv`: 3 campaigns parsed, 2 waste flags, 6 fatigue flags, 0 ICP-mismatch, 3 positioning-drift. Diagnostic written.
- `ad-diagnose` against `templates/ads-export-google-example.csv`: 6 campaigns parsed, 5 waste flags, 0 fatigue (search does not exhibit the same fatigue curve), 6 positioning-drift. Diagnostic written.
- `ad-spend-allocate --client demo --budget 30000 --ltv 2400 --quarter 2026-Q3`: 2 measurement contracts emitted, allocation summary written.
- `ad-fatigue-monitor --client demo`: 6 fatigue flags surfaced across 2 channels, persistent vs new tracking working.
- `ad-attribution-honest <bare-claim-asset>`: gate fails with 2 bare claims, exits 1, prints structured "how to fix" guidance.
- `ad-attribution-honest <grounded-claim-asset>`: gate passes, exits 0.
- `ad-incrementality-test --client demo --channel meta-paid-social --mode geo-holdout --baseline-conversions 200 --baseline-cac 75 --quarter 2026-Q3`: 2-week window computed, design + contract written. With baseline 50 / MDE 10%: 13-week window, INPUT-WARN window-too-long fires correctly. With MDE 3%: INPUT-WARN mde-too-tight fires correctly.

All refusal paths tested:
- `ad-diagnose` without `01-position.md`: REFUSED missing-positioning.
- `ad-incrementality-test` without baseline: REFUSED missing-baseline.

---

## Lines of code

| Skill | LOC |
|---|---|
| ad-diagnose | 759 |
| ad-spend-allocate | 696 |
| ad-incrementality-test | 692 |
| ad-creative-design | 661 |
| ad-fatigue-monitor | 434 |
| ad-attribution-honest | 330 |
| **Total runtime** | **3,572** |

Plus the SKILL.md frontmatter and bodies, the routine specifications, and the four pattern files (which were already authored when this agent started, by an earlier session in the same branch). The depth bar named in the brief (≥150 LOC per bin runtime) is met by every skill, with the smallest at 330 and the largest at 759.

---

## Substrate flywheel integration

The surface ties to the existing substrate machinery in three places:

1. **Goals layer**: `ad-spend-allocate` and `ad-incrementality-test` write directly to `goals/measurement-contracts/`. Each contract is a complete goal candidate, ready for `bin/substrate open-goal`.
2. **Calibration**: every measurement contract names `predicted_p_threshold_met` and `taste_type: demand-gen`. When goals resolve via `score-goal`, the operator's per-(operator, demand-gen) Brier history compounds.
3. **Pre-publish gate**: `ad-attribution-honest` is shaped to compose into `pre-publish-check`. Any asset that mentions "Meta drove X" or similar phrasing gets gated at publish time, regardless of which surface generated the asset (LP, blog, deck, board update, exec slide).

The result: a paid-ads operator running this surface for a quarter produces calibrated outputs that feed the same calibration ledger as a PMM running narrative-strategy or a CRO running lp-ship. Authority follows accuracy, not function. (`PRINCIPLES.md` rule 6.)

---

## See also

- `skills/README.md` for the registered skills
- `routines/README.md` for the registered routines
- `knowledge/patterns/INDEX.md` for the registered patterns
- `goals/SCHEMA.md` for the measurement contract shape
- `PRINCIPLES.md` for the rules every skill follows
