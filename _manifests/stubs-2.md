---
title: stubs-2 deepening, manifest
status: shipped
last_updated: 2026-05-08
agent: stubs-2
branch: agent/stubs-2
---

# Stubs-2 deepening — production + measurement category

Substrate's second-wave PMM craft: pricing, launches, campaigns, audience testing, and the two unfilled legs of the AEO triangle (relevance + manual-action propagation). Six skills moved from prompt-emit shells (~50 LOC each) to substantive runtimes (200-1071 LOC). Four new patterns capture the operator convergence each deepened skill rests on. Two new template fixtures.

A landing-page operator can run the pre-publish AEO gate end-to-end (`aeo-relevance --mode score → gap-analysis → content-brief`) on any draft. A pricing operator can run a real van Westendorp PSM analysis with computed OPP / IPP / PMC / PME and a tier-construction proposal grounded in the curve. A PMM running a launch can compose a tiered (T1/T2/T3) launch plan with phase structure, contradiction navigation, and a measurement contract opened at plan time. A demand-gen operator can scaffold a multi-channel campaign with falsifiable predictions, channel KPI separation, and contradiction-aware budget allocation. A content lead can pre-flight-test a copy variant against grounded personas with a directional 7-dim Gartner+Wynter scoring rubric. An AEO operator can monitor third-party mention density across Reddit / Hacker News / G2 / RSS feeds with rolling 30-day medians.

---

## Skills deepened (6)

### Before / after LOC

| Skill | Before | After | Δ | Notes |
|---|---:|---:|---:|---|
| `skills/pricing-strategic/bin/pricing-strategic` | ~50 | **1036** | +986 | Real van Westendorp PSM (curves, intersections, linear interpolation), competitor-pricing.yaml parser, LTV from closed-won-deals.csv, anchor-design tier construction, packaging matrix, price-test design with kill criterion + measurement contract, quarterly review ledger |
| `skills/launch-plan/bin/launch-plan` | ~50 | **883** | +833 | Tier discipline (T1/T2/T3) drives every constraint; phased cohort (preview / beta / frontier / launch / holdout); contradiction navigation (short-feedback-vs-long-term, build-quietly-vs-distribution); per-tier measurement contract; channel coordination; 30/60/90 retrospective; 5 sub-files emitted per plan run |
| `skills/campaign-strategy/bin/campaign-strategy` | ~50 | **844** | +794 | 6-stage spec (thesis → cohort → channels → cadence → measurement → kill); falsifiable-outcome refusal (vanity metrics rejected); 3 contradiction navigations (build-quietly, short-feedback, outbound-inbound); per-channel KPI fit per pat_intent-vs-interest-targeting; goal-ledger contract opened at plan time; measure + retrospective sub-modes |
| `skills/audience-test/bin/synthetic-audience-test` | ~44 | **411** | +367 | Pricing-variant + novel-product-behavior refusals; per-client persona dir resolution; lp-scope reweighting (vertical / horizontal / narrow-product); grounding-quality classification; 7-dim Gartner+Wynter scoring scaffold; delegates to existing run.sh for claude --print panel run |
| `skills/aeo-relevance/bin/aeo-relevance` | 50 | **1071** | +1021 | Markdown passage parser; TL;DR detection; H3 / bullet / question density measurement; schema.org JSON-LD detection; per-claim citation likelihood scoring; positioning alignment via term-overlap; voice-match (kill-list, em-dashes, throat-clearing); 5-component overall score with 0.70 threshold; 3 modes (score / gap-analysis / content-brief) |
| `skills/aeo-manual-action/bin/aeo-manual-action` | 50 | **988** | +938 | Real RSS / Atom parser (XML, no deps); HTTP fetch with User-Agent; mention detection with word-boundary alias matching; 30-day window filter; sentiment scoring (positive/neutral/negative); citation-log cache with rolling 90-day medians; drift watch; 4 modes (measure / monitor / surface-map / action-plan); sources.yaml schema parser |

**Total**: 5,233 LOC across the six skills, up from ~294. All skills carry `produced_by: <skill>` in output frontmatter so Gate 7 (pattern-applied) can verify pattern application at pre-publish time.

### Behavioural details per skill

- **`pricing-strategic`** — full van Westendorp PSM: cumulative curves over respondent prices, linear-interpolated intersection finding, four canonical points (OPP / IPP / PMC / PME) with named meaning per the 1976 ESOMAR paper. LTV computed from `closed-won-deals.csv` when present (ARR median × inverse-annual-churn). Tier construction logic from `pat_behavioral-pricing-architecture` (anchor at PME × 1.1 for arbitrary coherence; target at OPP for rejection-minimum; starter between PMC and OPP). Refuses on N<20 buyer responses (Mickos/Campbell floor). Anchor-design refuses without `competitive/competitor-pricing.yaml`.
- **`launch-plan`** — tier discipline maps to (preview cohort size, preview window, beta window, frontier-artifacts minimum, channel mix, primary measurement window, retention measurement window, feedback shape). Reversibility heuristic (launch ids containing 'pricing', 'positioning', 'rebrand', 'category', 'platform-shift', 'permanent' = one-way). PMF stage detected from BRIEF.md / strategy/pmf-stage.md / 00-INDEX.md. T1 launches automatically create `frontier-artifacts/` directory. Contradiction positions logged in frontmatter (`contradiction_positions: short-feedback-vs-long-term-holdouts: ...`).
- **`campaign-strategy`** — `is_falsifiable_outcome()` rejects vanity-metric outcomes ("engagement", "impressions", "reach", "brand awareness") unless paired with a measurement contract reference. Channel classification map (intent / interest / earned / inbound / outbound / algorithm-rented). Outbound-vs-inbound budget contradiction picks position from channel mix ratio (>60% outbound = Position B; >60% inbound = Position A; balanced = Position C). 3 sub-files emitted per plan: spec, measurement contract, cadence. One brief per channel in `briefs/`.
- **`audience-test`** — pricing-variant refusal (synthetic panels can't predict elasticity). Novel-product-behavior refusal (hallucination risk). Persona slice + lp-scope filtering. Grounding quality classification (high/medium/low based on attribution + grounded_in + verbatim quote count). Score scaffolding with TBD-marked persona-by-persona reactions; delegates to existing `run.sh` for the claude --print panel run when not in `--score-only` mode.
- **`aeo-relevance`** — markdown passage parser splits on H2/H3 boundaries; per-passage word count, bullet detection, question-explicit detection, external-section-reference detection. TL;DR detected via H1/H2/H3 with "TL;DR" / "Summary" / "Key Takeaways" / "At a Glance" in first 200 lines. Schema.org JSON-LD parsing for FAQPage / HowTo / Article / Product. Per-claim citation likelihood with 5 components (question-explicit, self-contained, word-count fit, has-bullets, positioning-alignment). Overall score with 5-component weighted sum (passage extractability 0.30, self-containment 0.20, schema 0.15, positioning alignment 0.20, voice 0.15); 0.70 threshold. Per-prompt scoring via term-overlap × per-claim citation likelihood.
- **`aeo-manual-action`** — `fetch_url()` with User-Agent + 15s timeout. RSS 2.0 + Atom parsing in pure ElementTree (no feedparser dep). RFC 822 + ISO 8601 pubDate parser. `detect_mentions()` runs word-boundary regex match on brand_aliases, attaches sentiment via positive/negative word counts. Cache snapshot at `clients/<client>/aeo/citation-log/<date>.json`. Rolling median computed across last 90 days of cached snapshots. Drift flag at 50% below rolling median. Surface map enumerates configured sources + flags missing expected surfaces. Action plan generates per-surface action specs with deadlines + falsifiable measures. `--no-fetch` mode skips live HTTP for cron testing.

---

## Patterns (4 new)

| Pattern | Convergence | Operators (≥3) | Tier |
|---|---|---|---|
| `knowledge/patterns/launch-as-coordinated-distribution.md` | A launch is a coordinated multi-channel sequence with phased cohort + narrative spine + measurement contract, not a single-day press push | Andy Raskin (Strategic Narrative), April Dunford (positioning-grounded launch), Lenny Rachitsky (multi-channel cadence), Adam Stinson + Coinbase / Stripe / Shopify launch retro literature (T1/T2/T3 tier discipline) | A |
| `knowledge/patterns/van-westendorp-over-vibes-pricing.md` | Structured price-sensitivity research (van Westendorp PSM, Gabor-Granger) on ≥20 in-ICP buyer responses beats opinion pricing or competitor copying | Hermann Simon (pricing function discipline), Patrick Campbell (ProfitWell research cadence), Mårten Mickos (startup pricing from research, 20-response floor), Peter van Westendorp (1976 PSM method) | A |
| `knowledge/patterns/synthetic-audience-as-pre-publish-floor.md` | Synthetic-audience scoring is a cheap pre-publish floor for filtering obvious failures, not a substitute for real-buyer panels for magnitude prediction | Anthropic Research / LLM-as-judge calibration literature, Jordan Boyd-Graber + NN/g 2025 + Park et al. Stanford-Google 2024, Reforge faculty (Balfour / Chen / Bush), Joel Park (1052-person twin study) | B |
| `knowledge/patterns/passage-as-citation-unit.md` | AI assistants cite passages, not pages; structure for passage extractability (40-90 words, self-contained, question-explicit, schema.org markup) | Anthony Pierri (FletchPMM), Andy Crestodina (Orbit Media Q&A density research), Mike King (iPullRank relevance engineering), Aleyda Solis (Orainti three-layer AEO frame) | A |

Each pattern: full schema (id, title, captured_date, convergence_count, tier, uses_cards, domains), `## Convergence` section with the operating claim, `## Operators` section with named operators and their canonical positions, `## Variation` showing what each operator owns, `## Implication` with concrete operator instructions, `## Counter-evidence` naming when the pattern fails, `## Sources` list with insight-card slugs.

---

## Templates (2 new)

| Path | Purpose |
|---|---|
| `templates/competitor-pricing-example.yaml` | Schema fixture for `clients/<client>/competitive/competitor-pricing.yaml`; 3 example competitors with starter / growth / enterprise tiers, contact-sales handling, last_verified dates |
| `templates/wtp-csv-example.csv` | Schema fixture for the WTP survey CSV; 25 example responses across 2 segments (smb-services, mid-market) with the four van Westendorp columns |
| `templates/aeo-sources-example.yaml` | Schema fixture for `clients/<client>/aeo/sources.yaml`; reddit / hackernews / rss_feeds / search_queries (Google News + DDG) / G2 / YouTube / podcasts |
| `templates/target-prompts-example.md` | Schema fixture for `clients/<client>/aeo/target-prompts.md`; 5 example prompts with intent labels and source paths |

---

## Composition graph

```
voc/processed/pricing/  +  competitive/competitor-pricing.yaml  +  closed-won-deals.csv
              ↓
              pricing-strategic --mode wtp-survey
              ↓
              pricing/wtp-curves/<segment>-<date>.md  (OPP, IPP, PMC, PME)
              ↓
              pricing-strategic --mode anchor-design
              ↓
              pricing/packaging/<package>.md  (3-tier package with switching features)
              ↓
              pricing-strategic --mode price-test
              ↓
              pricing/tests/<test-id>.md  +  goals/measurement-contracts/<test-id>.md

positioning/  +  product-knowledge/  +  voc/  +  competitive/  +  messaging/
              ↓
              launch-plan --mode plan
              ↓
              launches/<launch>/{plan, preview-cohort, measurement-contract, 30-60-90}.md
              + launches/<launch>/frontier-artifacts/  (T1 only)

positioning/  +  icp/  +  voc/  +  market-context/  +  conversion-narrative/
              ↓
              campaign-strategy --mode plan
              ↓
              campaigns/<campaign>/{spec, measurement-contract, cadence}.md
              + campaigns/<campaign>/briefs/<channel>.md  per channel

variant.md  +  personas/<axis>-<slug>.md
              ↓
              audience-test (pre-publish floor)
              ↓
              shared/synthetic-audience/scores/<variant-stem>-<date>.md  (DIRECTIONAL-ONLY)

asset.md  +  aeo/target-prompts.md  +  positioning/
              ↓
              aeo-relevance --mode score → gap-analysis → content-brief
              ↓
              aeo/relevance-runs/<asset>-<date>.md (passage scorecard)
              + aeo/gap-analysis/<asset>-<date>.md (prompt × asset matrix)
              + aeo/briefs/<prompt-id>-<date>.md (passage shape proposal)

aeo/sources.yaml  +  aeo/target-prompts.md
              ↓
              aeo-manual-action --mode measure → surface-map → action-plan
              ↓
              aeo/density-reports/<date>.md  (rolling-median sentiment + drift)
              + aeo/surfaces/<prompt-id>-surface-map.md
              + aeo/action-plans/<prompt-id>-<date>.md
              + aeo/citation-log/<date>.json  (cache, used by next run)
```

The pricing → launch → campaign chain composes one customer-shipping motion. The audience-test + AEO chain composes the pre-publish quality discipline. Together: a complete pre-publish gate ladder for any second-wave PMM artifact (LP, ad, email, sequence, post, brief, plan).

---

## Pattern grounding (declared in SKILL.md, behaviorally enforced via Gate 7)

- `pricing-strategic` grounds in `pricing-as-the-most-leveraged-org-failure`, `behavioral-pricing-architecture`, `van-westendorp-over-vibes-pricing`, `frontline-as-pmm-substrate`, `economic-turing-test-rev-per-employee`.
- `launch-plan` grounds in `launch-as-coordinated-distribution`, `research-preview-and-cadence`, `narrative-as-strategy`, `distribution-as-moat`, `agents-mapped-to-jtbd`. Contradictions-aware on `short-feedback-vs-long-term-holdouts`, `build-quietly-vs-distribution-first`.
- `campaign-strategy` grounds in `launch-as-coordinated-distribution`, `narrative-as-strategy`, `distribution-as-moat`, `agents-mapped-to-jtbd`, `measurement-correlated-short-signals`, `trigger-events-beat-cadence-blast`, `channel-arbitrage-window`, `intent-vs-interest-targeting`. Contradictions-aware on `build-quietly-vs-distribution-first`, `short-feedback-vs-long-term-holdouts`, `outbound-vs-inbound-budget`.
- `audience-test` grounds in `synthetic-audience-as-pre-publish-floor`, `eval-as-data-analysis`, `quality-as-growth-lever`, `buyer-mindset-not-product-features`.
- `aeo-relevance` grounds in `aeo-triangle`, `passage-as-citation-unit`, `agents-as-product-users`, `distribution-as-moat`.
- `aeo-manual-action` grounds in `aeo-triangle`, `distribution-as-moat`, `agents-as-product-users`, `passage-as-citation-unit`.

Each output asset carries `produced_by: <skill>` in frontmatter and lists `patterns_applied: [...]`. The `pre-publish-check` Gate 7 (skill-pattern-check.sh) reads these and verifies the pattern's behavioral signature appears in the body.

---

## Refusal patterns (per-skill summary)

- `pricing-strategic`: refuses without canonical positioning, without `competitive/competitor-pricing.yaml` (anchor-design only), with WTP CSV N<20 per segment, without `--ltv` for price-test mode.
- `launch-plan`: refuses without canonical positioning, without `--launch` + `--launch-date` + `--audience` + `--tier` for plan mode, on T1 launch with no preview cohort named.
- `campaign-strategy`: refuses without canonical positioning, without `--campaign` + `--cohort` + `--outcome` + `--horizon` + `--channels` for plan mode, with vanity-metric outcomes (engagement / impressions / reach / brand awareness without a measurement contract).
- `audience-test`: refuses on pricing variants (elasticity), on novel product behavior (hallucination), with no personas dir.
- `aeo-relevance`: refuses without `target-prompts.md`, without `--asset`, on asset with zero H2/H3 structure (not passage-extractable), with N<3 prompts in target-prompts.md.
- `aeo-manual-action`: refuses without `aeo/sources.yaml`, without `target-prompts.md` for surface-map / action-plan modes, without `--prompt-id` for surface-map / action-plan modes.

---

## Test runs (verified end-to-end)

- `aeo-relevance --mode score` on a hand-built test LP: parsed 4 passages, extracted 10 claims, detected TL;DR, scored 0.70 (PASS).
- `aeo-relevance --mode gap-analysis` on the same LP against 3 prompts: 2 won (0.85 / 0.60), 1 unmet (0.0).
- `aeo-relevance --mode content-brief` on the unmet prompt: produced a passage-shape brief with the four passage-extractability constraints + JSON-LD FAQPage block.
- `aeo-manual-action --mode measure --no-fetch`: cached an empty snapshot, computed rolling median (1 prior).
- `aeo-manual-action --mode surface-map / action-plan`: rendered surface enumeration + per-surface action specs with deadlines + falsifiable measures.
- `aeo-manual-action` live RSS parser: tested against `news.ycombinator.com/rss`; parsed 30 items correctly.
- `pricing-strategic --mode wtp-survey` on the example CSV: computed OPP=$22, IPP=$50, PMC=$10, PME=$65 from 22 in-segment responses. Defensible price band rendered.
- `launch-plan --mode plan` for a T2 launch: emitted plan + preview-cohort + measurement-contract + 30-60-90 (4 sub-files).
- `campaign-strategy --mode plan` for a 12-week campaign with 3 channels: emitted spec + measurement-contract + cadence + 3 channel briefs.

---

## Scope adherence

- Touched: 6 skills (their `SKILL.md` + `bin/<skill>` files), 4 new patterns under `knowledge/patterns/`, 2 new templates under `templates/`.
- Did not touch: README.md, ORIGIN.md, INDEX.md files, skills/README.md, routines/README.md, VERSION, bin/lib/*, other skills.
- Frontmatter preserved on every SKILL.md; version bumped (0.1 → 0.2 where applicable); preflight_refusal expanded; output contracts updated.
