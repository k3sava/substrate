---
name: synthetic-audience-test
description: Pre-flight test of positioning / LP / ad-copy / outbound-opener variants against grounded personas before live calibration. Returns a structured read (clarity, objections, comprehension gaps, predicted intent delta) plus a synth-audience-score artifact written to shared/synthetic-audience/reads/. DIRECTIONAL-ONLY (per iter-3 debrief 2026-04-26 — rank-inverts on narrow high-intent product LPs at N=3); not a gate verdict. Use BEFORE filing a gate packet on the variant. Refuses on pricing variants (synthetic panels can't predict elasticity) and on novel product behavior (hallucination risk).
version: 0.2
status: active
phase: 2
output_mode: directional-only
substrate_layers_required: [positioning, voc, icp, brand-voice]
patterns_grounded: [synthetic-audience-as-pre-publish-floor, eval-as-data-analysis, quality-as-growth-lever, buyer-mindset-not-product-features]
preflight_refusal: substrate-gap, missing-personas, pricing-variant, novel-product-behavior
required_reads:
  - personas/
inputs:
  - shared/synthetic-audience/personas/*.md
  - shared/canonical/Allowed-Claims.md
  - shared/canonical/Banned-Words.md
  - shared/canonical/Copy-Spec.md
  - shared/canonical/Differentiation-Axis.md
gates:
  - none directly; this skill RUNS BEFORE a gate packet is opened
  - downstream consumers MUST NOT tag output as a gate verdict without explicit override flag
last_updated: 2026-05-08
iter_3_debrief_applied: true
gartner_g00823537_aligned: true  # Market Guide for B2B Message Testing — 6-dim schema + buyer-content-preferences applied 2026-04-28
---

# synthetic-audience-test

Phase 1 stub. Run a copy variant past the 3 grounded personas under `shared/synthetic-audience/personas/` and return the structured read pasted into the calling bet's `## Synthetic audience read` section.

## Trigger phrases

"synthetic test", "audience test", "panel read", "pre-flight this copy", "what would the panel say", "test this LP H1 against the panel".

## When to use

- Positioning claim before opening a `positioning-update` gate.
- LP H1 / hero variant before opening `experiment-launch`.
- Ad copy before opening `content-publish`.
- Cold-outbound opener / cancellation-save framing before sending.

## When NOT to use

- Pricing variants (synthetic panels can't predict elasticity).
- Novel product behavior with no analog (hallucination risk).
- Anything where measured behavior is cheap and fast to get directly.

## Inputs

1. The variant under test (one block of copy, or N variants for comparison).
2. Optional: a target persona slice (default: all personas).
3. Optional: a comparison anchor (the current live copy or a competitor's claim) — improves the read.

## Output schema (Gartner + Wynter aligned, 2026-04-28)

Combined 7-dimension scoring rubric. Wynter B2B Message Layers (Clarity / Relevance / Value / Differentiation + Friction inverse) ∪ Gartner G00823537 dims (Clarity / Credibility / Urgency / Uniqueness / Value / Relevance):

```yaml
variant_id: <stable id>
tested_at: YYYY-MM-DD
scope: pmm | demand-gen | viral-content | aeo-seo | sales-enablement | substrate-architect
buyer_state: cold | researching | shortlisting | comparing | objecting | renewing
panel:
  - persona: <persona-id>
    # WYNTER ORDER MATTERS (don't score later layers if earlier layers fail)
    clarity_1to5: <int>            # I get it (Wynter + Gartner)
    relevance_1to5: <int>          # It's for me (Wynter + Gartner)
    value_1to5: <int>              # I want the promises (Wynter + Gartner)
    differentiation_1to5: <int>    # I get how this is different (Wynter "Differentiation" / Gartner "Uniqueness")
    credibility_1to5: <int>        # I believe the claims (Gartner — backed by data, not salesy)
    urgency_1to5: <int>            # I should act now (Gartner)
    friction_1to5: <int>           # Resistance / doubts / anxieties (Wynter, INVERSE — lower is better)
    one_read_takeaway: <verbatim quote — what the buyer thinks this is saying>
    objections: [<verbatim list of buyer objections>]
    comprehension_gaps: [<bullet list>]
    irrelevant_message_avoidance: <true|false>  # Per Gartner 73% finding — would buyer avoid the vendor on this message?
    intent_lift_vs_anchor: <-2|-1|0|+1|+2>
    confidence: <0.0-1.0>
    [VERIFY]_flags: [<dims where score derived from <50% literal-overlap with variant>]
predicted_winner: <variant_id>
forecast_recorded: false
notes:
  - <anything the panel surfaced that isn't covered>
```

**Wynter order rule:** if `clarity_1to5 < 3`, do NOT score relevance/value/differentiation — they're moot. Buyer never reaches them. Same cascade applies down the chain.

## Phase 1 invocation

Manual. Collaborator invokes this skill from inside a bet's working session, pastes the output into `## Synthetic audience read` in the bet file, then opens the gate packet.

The body of each persona file is prepended as system prompt; the variant is the user message; the model is asked to respond AS that persona using only language and reasoning patterns supported by the canonical files in the persona's `grounded_in:` list. Refusal-to-answer is preferred over hallucination — if the canonical doesn't ground a dimension, the response says so.

## Persona-grounding rule (NN/g 2025 + Stanford-Google 2024 derived, 2026-04-28)

NN/g's 2025 review of digital-twin studies + Stanford-Google's 1,052-person generative-agent study + Synthetic Users' 85% organic parity benchmark establish a single rule:

**Interview-grounded personas outperform demographic-only or persona-description-only seeding.** Stanford-Google built twins from two-hour AI-led interviews and hit 85% accuracy vs interviewees' actual GSS responses. NN/g notes interview-based digital twins reach r=0.98 on missing-data prediction; persona-only twins capture trends but miss magnitude.

For our buyer-personas: every persona body must include verbatim language from at least 3 source slices:
1. **G2 reviews** matching the persona profile (segment-keyed slice).
2. **the operator's call-intel corpus** matching the persona profile (best-deal-analysis subset preferred — these are buyers who actually closed).
3. **Gartner Voice-of-the-Customer / Magic Quadrant** buyer language matching the persona's incumbent + category.

If any slice is missing, the persona is marked `grounded_in_quality: low` and its outputs carry a `[GROUNDING-LOW]` flag in every dimension.

## Saturation principle (Wynter 2026 + Synthetic Users)

**12-13 well-grounded personas reach saturation** — surveying 13 vs 130 produces the same number of insights/themes (peer-reviewed range: 9-17 for homogenous populations). For our buyer-side panel, **don't aim for 100 personas; aim for 12-13 that span the load-bearing combinations (vertical × incumbent × ICP-tier × buyer-state).** Quality over breadth.

## Phase 2 — forecast scoring

When `bet-resolve` lands in `gate_events`, a nightly job compares the panel's `predicted_winner` to the actual winner and scores the panel. Persona accuracy feeds the taste ledger as forecast-authority. See `substrate/SYNTHESIS.md` → "How it earns its keep".

## Phase 3 — mandatory pre-gate

Auto-runs on bet file save for `positioning-update`, `experiment-launch` (LP-hero variants), and `content-publish` (ad-copy) gate classes. Result is required in the gate packet's notes.

## How to invoke

```sh
# variant from file
./skills/synthetic-audience-test/run.sh path/to/variant.txt

# variant from stdin
echo "<copy variant here>" | ./skills/synthetic-audience-test/run.sh -

# multiple variants
./skills/synthetic-audience-test/run.sh v1.txt v2.txt v3.txt

# narrow personas (slugs match basename fragments under personas/)
./skills/synthetic-audience-test/run.sh v.txt --personas <slug-a>,<slug-b>

# with anchor (current live copy or competitor claim)
./skills/synthetic-audience-test/run.sh v.txt --anchor current-live.txt

# NEW (per iter-3 debrief): scope-aware persona reweighting
./skills/synthetic-audience-test/run.sh v.txt --lp-scope vertical
./skills/synthetic-audience-test/run.sh v.txt --lp-scope horizontal
./skills/synthetic-audience-test/run.sh v.txt --lp-scope narrow-product
```

## --lp-scope flag (added per iter-3 debrief 2026-04-26)

Reweights the panel based on the LP's audience scope. Mitigates the rank-inversion observed on `/product/international-numbers` (narrow high-intent product LP) where horizontal-weighted personas produce a misleading rank.

| `--lp-scope` value | Behavior |
|---|---|
| `vertical` (default) | Down-weight personas not in the named vertical. Best for vertical LPs (per the slugs in `clients/<client>/verticals.yaml`). |
| `horizontal` | Equal weights across all personas. Best for platform/category pages (homepage, `/pricing/`). |
| `narrow-product` | Up-weight the 1-2 personas matching the product's primary use case; suppress others. **Required for product-feature LPs.** |

If `--lp-scope` not given, defaults to `vertical` (legacy behavior preserved).

## [VERIFY] flag in output (added per iter-3 debrief)

When the persona scoring relies on pattern-knowledge (synthesizing from canonical + persona file rather than literal HTML/screen reads), each affected dimension surfaces with a `[VERIFY]` prefix in the output. Forces consumers to know what kind of score they're reading.

Triggers `[VERIFY]` when:
- LP HTML hasn't been fetched (no `--lp-html-source` provided)
- Canonical file referenced in persona's `grounded_in:` doesn't exist
- Score derived from <50% literal-overlap with the variant text

## Per iter-3 debrief — calibration data points (2026-04-26)

Treat the Skill as **directional-only** (not a gate verdict) until N ≥ 6 LPs land in `substrate_lp_performance` (gated on Drive OAuth k-010). Calibration data so far:

| Persona-aggregate (synthetic) | Live CVR (shipped) | LP |
|---:|---:|---|
| 3.78 | 14.49% | `/pricing` |
| 3.55 | 11.15% | `/solution/business-phone-system` |
| 3.58 | 22.06% | `/product/international-numbers` (RANK-INVERSION) |

Brier scoring becomes tractable once N ≥ 6. Track via `metrics/baseline-canonical-2026-04-26.md` "synthetic-audience aggregate" column (TODO: r2d2 lane to add column once iter-4 reruns TICK 3).

## value-prop fit dimension split (deferred)

iter-3 debrief flagged splitting `value-prop fit` into `claim-strength + claim-believability` (averaged) to mitigate the 0.20 per-dimension drift surfaced in `instrument-stability.md`. **Deferred until iter-4 close** confirms the wobble is structural — premature split risks adding noise, not signal.

Output: structured YAML written to `shared/synthetic-audience/reads/<variant-id>-YYYY-MM-DD.yaml` and printed to stdout for piping into a bet's `## Synthetic audience read` block.

## Status

- [x] Phase 1 personas drafted (5/5 grounded in Drive canonical)
- [x] Phase 2 invocation script (run.sh) — claude --print harness, multi-variant, anchor-aware
- [ ] Phase 2 forecast-scoring job — not yet written (fires on bet-resolve event)
- [ ] Phase 3 auto-fire on bet save — not yet wired
- [ ] **Buyer-side reframe** — personas are buyer personas (per `feedback_synthetic_audience_buyer_side.md`); current Drive-canonical personas need re-validation against the buyer-not-marketer rule
- [ ] **7-dim Gartner+Wynter schema** — applied 2026-04-28; existing personas need a re-grounding pass to score on credibility + urgency (Gartner adds) and friction (Wynter inverse)
- [ ] **Interview-grounded persona bodies** — current personas seeded from Drive canonical only; need cross-source agreement (G2 + best-deal + Gartner VoC) per NN/g 2025 + Stanford-Google 2024 evidence
- [ ] **Trusted-5 calibration partners per taste-type** — not yet identified (Cat Wu Lenny pod #12)
- [ ] **Retroactive backfill on 39-deal best-deal-analysis** — never run; the single fastest calibration test
- [ ] **In-market loop** — premarket-only today; pair with calibration ledger (Brier on bet-resolve) to close the loop per Gartner Tribyl/Troupe pattern

## Multi-axis panel selection (added 2026-04-29 per b3 batch reviews)

Adds panel-selection rules grounded in 12-bet review corpus (`shared/synthetic-audience/reads/bet-batch-review-2026-04-29.md` + round 2). The rule is: select panel by what the variant's CLAIM spans, not by what its content is about.

```
default: pmm-peer panel (substrate quality, mechanism credibility)

+ buyer-state panel
  trigger: claim implies funnel-stage targeting (curious / comparing /
    demo-ready / objecting / renewing)

+ displacement panel (per-client named rivals, sourced from
    clients/<client>/competitors.yaml + competitor personas)
  trigger: claim implies competitor-axis or category-axis targeting
    (named-rival LPs, alternative pages, comparison content, renewal-
    window retargeting, switching workflows)

+ vertical panel (per-vertical persona)
  trigger: claim implies vertical-axis targeting (vertical LP, vertical
    cohort scale, vertical-specific outcome metric)

+ internal-org panel
  trigger: claim implies internal-buyer reading (sales-leader-buyer,
    ae-buyer, eng-leader-internal, pm-internal)

GUARD: skip extra panels if pinned persona covers the axis cleanly AND
  the claim doesn't span a funnel-stage / competitor-axis / vertical-axis.
  Compound-axis review is not free; it costs a synthetic-audience cycle.
  Validated against compliance-hub-citation-lift bet (msg 353): well-pinned,
  axis-bounded; displacement-axis review yielded no additional signal.

METHOD-MATCH: bet packets default to PMM-peer review (mechanism); shipped
  assets default to buyer-state review (conversion). Funnel-stage and
  competitor-axis reviews are additive on either side per the triggers above.
```

## Pre-flight refusal-pattern filter (added 2026-04-29)

A cheap filter that runs BEFORE persona scoring. Source: `shared/synthetic-audience/cross-vertical-refusal-patterns-<date>.md` — synthesis across the client's vertical sidecars.

**Universal refusals (refused across every vertical in the client's `verticals.yaml`):**
1. Generic feature-as-hero framing that ignores the buyer's job-to-be-done.
2. Multi-vertical hero ("we work with X and Y") that dilutes vertical fit.
3. Generic integration claims ("integrates with [CRM]") with no named depth.
4. Cold-call / single-rep / SDR-floor framing on a buyer that operates differently.

(Each client's exact universal-refusal list lives in their substrate. The skill loads it; do not hardcode.)

**Near-universal refusals (3/4):**
5. AI as standalone marketing surface (must pair with specific job)
6. Vendor-blog "industry stat" without customer name + recency

**Filter rule:**
```
for each draft variant:
  if draft contains a universal-refusal trigger:
    flag-and-block. Variant cannot pass any vertical persona.
    Save the persona-scoring cycle.
  if draft contains a near-universal-refusal trigger:
    flag-and-warn. Likely 3/4 vertical refusal; review before scoring.
```

This saves model-scoring cycles on variants that the buyer body would refuse on its face. Validated in `reads/solution-outbound-speed-vertical-panel-2026-04-29.md` — the predictive-dialer-led feature-1 bullet would have been caught at filter-time.

## External substrate informing this spec (ingested 2026-04-28)

- `(operator-internal path)` (G00823537) — 6-dim Gartner schema + buyer-content-preferences + 73% irrelevant-message-avoidance + Tribyl/Troupe in-market vendors named.
- `(operator-internal path)` — 2,120 verified peer reviews across 12 CCaaS incumbents = primary buyer-persona seed corpus.
- Wynter B2B Message Layers framework (in commons: (team-knowledge — see commons); ingested via Curiosity bookmark `ddc2b8bb`).
- Wynter "definitive guide to message testing" (Curiosity bookmark `9d45d99d`) — saturation principle (12-13 responses), open-ended question templates, A/B-vs-message-testing distinction.
- Wynter B2B Audiences (Curiosity bookmark `b2f4bc30`) — proves the 80,000-panel + manual-vetting + verified-LinkedIn model works at commercial scale; we replicate substrate-side via [VoC lead] corpus + G2 + Gartner VoC.
- NN/g "Evaluating AI-Simulated Behavior" (Curiosity bookmark `7eac8690`) — 3 studies; interview-grounded twins reach r=0.98 on missing-data, 78% individual prediction; persona-only twins miss magnitude.
- Stanford-Google "Generative Agent Simulations of 1,000 People" (via Synthetic Users summary, Curiosity bookmark `2201999c`) — 85% organic parity from 2-hour AI-led interview transcripts.
- PyMC Labs "Synthetic Consumers practical guide" (Curiosity bookmark `d4db931a`) — 5-component method (Data Foundation → Persona Generation → Simulation Layer → Validation → Iteration); 90% alignment / 85% distributional similarity benchmarks; FMCG/retail/tech adoption growth.
- `team-brain/knowledge/skills/customer-research-for-ads.md` — Barnes/Levinger/Kramer/Laja methodology stack (qualitative interview → creative-with-brand-DNA-filter → message testing validation).
