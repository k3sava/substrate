---
name: lp-ship
description: Landing page master. Composes copywrite + design-craft + ux-dev + voice-enforce + synth-audience into a ship-ready LP with measurement instrumentation. Optimized for conversion, not feature parity. Inherits Shirley's CRO canon as ground truth.
version: 0.1
amplifies: PMM, growth lead, designer + dev shipping LPs together
masters: Joanna Wiebe (Copyhackers — message hierarchy and the "stages of awareness" page model), April Dunford (positioning → LP layout), Wynter (B2B message testing applied to LP variants), ConversionXL / CXL Institute (research-backed CRO methodology), Jen Havice (deep voice-of-customer LP method), Peep Laja (CXL test discipline), Brad Frost (atomic design for LP composition), Refactoring UI (visual restraint), Linear/Vercel/Stripe LPs (form as content), Wes Bush (PLG-style LP for self-serve), Anthropic + Stripe + Vercel + Linear shipped LP examples (the operator's own CRO canon, when present, supersedes generic patterns)
substrate_index_version: 2026-05-08
substrate_layers_required: [positioning, product-knowledge, conversion-narrative, brand-voice]
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md          # mandatory first read — positioning, allowed claims, the 3-question positioning rubric, kill list
  - clients/{client}/substrate/positioning-canonical-statement-*.md  # most-recent canonical statement; hero must pass the positioning rubric
---

# lp-ship

## Purpose

Land a single LP that converts the named ICP cohort against a measurable metric. The whole LP — copy, design, code, instrumentation, preflight — passes through this skill. Output is a deployed page with Brier-trackable measurement.

## Inputs

- `--client <client>`
- `--lp-purpose <hero-product|vertical|comparison|integration|launch|pricing|alt-to-X>`
- `--audience <icp-id>` (must be pinned in `personas/`)
- `--awareness-level <unaware|problem|solution|product|most>` (Schwartz frame)
- `--target-metric <conversion-event>` (Amplitude event name; required)
- `--baseline-cvr <value or "new">` (CRO baseline; pulled from Shirley's substrate if exists)
- `--target-cvr <value>` (committed lift target)
- `--reference-figma-file <key>` (when LP descends from a brand-refresh / homepage 2026 / LP 2026 Figma file)

## Process

1. **Read substrate**: `positioning.md`, `narrative.md`, `icp.md`, `voc.md` (verbatim quote bank), `competitive.md` (if comparison/displacement LP), `brand-voice.md`, `design-system-*.md`, `conversion-narrative.md` (Shirley's CRO canonical surface). If Figma reference provided, pull tokens + components via figma MCP.
2. **Choose LP archetype**:
   - **Hero-product**: 1 hero outcome + 3 differentiators + social proof + 1 case study + dual-CTA (trial + demo)
   - **Vertical**: industry hook + outcome-led pillar (use vertical-specific voc) + integration card + case study + vertical CTA
   - **Comparison/Alt-to-X**: pain-of-current-tool hook + side-by-side claim table (every claim cited) + switch narrative + migration path + dual-CTA
   - **Integration**: integration outcome statement + setup-time proof + workflow diagram + use cases + bidirectional CTA (install + demo)
   - **Launch**: announcement hook + 3-feature explainer + early-customer quote + waitlist or live CTA
   - **Pricing**: tiered grid + plan-recommendation logic + objection-handler accordion + dual-CTA
3. **Compose master narrative**: pillar 1 / pillar 2 / pillar 3 from `narrative.md`. Pick 3 pillars that fit the awareness level. Per Wiebe + Dunford.
4. **Run copywrite** for each surface section: hero headline (≤10 words), subheadline (≤25 words), pillar copy, social proof, CTA microcopy. 3 frames per surface; pick best after preflight.
5. **Run design-craft** for the layout: rationale + spec.
6. **Run ux-dev** for code: ship to staging deployment.
7. **Wire instrumentation**: target metric event + cohort filter. Per `amplitude-taxonomy-*.md` chart-build cheat sheet — no inventing event names. Pull canonical event names from substrate.
8. **Run synth-audience**: pinned-persona panel. Asset blocks ship if synth scores < 4 on outcomes + differentiation.
9. **Run preflight composition**: voice-enforce + refusal-pattern + substrate-cited + persona-appropriate gates. All must pass.
10. **Ship to staging**, generate preview URL.
11. **Open bet record**: bet-open with measurement contract (event source + baseline + target + window). LP doesn't go to prod without a bet against it.

## Output

Deployed LP (staging URL) + bet record + instrumentation manifest.

## Gates

- **CRO canon:** if Shirley's substrate has a baseline for this LP shape, the bet target is anchored against it. Don't invent baselines.
- **Bet-open precondition:** LP cannot ship to prod without an open bet citing it.
- **Total CR vs Unique CR:** never quote total CR (per memory feedback_lp_performance_shirley_canonical.md — additive double-counts trial+demo overlap). Use UNIQUE CR or split TRIAL CVR + DEMO FF CVR.
- **Synth-audience gate:** ≥ 4 outcomes-language, ≥ 4 differentiation, ≥ 3 persona-fit.
- **Voice + refusal-pattern + substrate-cited gates** via preflight.
- **Mobile-first:** core-web-vitals on mobile must pass before desktop polish.

## Composes with

Reads from: positioning, narrative, icp, voc, competitive, brand-voice, design-system, conversion-narrative substrate; Shirley's CRO canon; figma MCP (LP 2026 / homepage 2026 / brand refresh files).
Writes for: ad-ship (LPs are landing destinations for ads), email-ship (LPs land email clicks), bet-open (every LP opens a bet), calibration-keep (CRO outcomes feed taste-type ledger).
Triggered by: launch, vertical entry, comparison need, pricing change, AEO-derived content gap.

## Refusal patterns

- Audience not pinned in `personas/` → reject; run icp-cut + persona-pinning first.
- Target metric is "bounce rate" / "engagement" / "scroll depth" (vanity) → reject; require conversion-event metric.
- Baseline = "we'll see" → reject; pull from Shirley's substrate or run baseline-window first.
- Comparison LP without verbatim-cited rival claims → reject; run competitive-displace first.
- Total CR cited → reject; use unique or split.

## Calibration

Tracked under taste-types `narrative` + `creative-production` + `demand-capture`. Brier signal: target-metric resolution at window close. Calibration ledger: per-operator LP-shipping-quality compounds across resolved bets.

## Reference patterns (LP archetypes done well)

- Linear's product page (form as content; minimal hero; embedded interactions)
- Stripe's pricing page (clarity over choice-noise; tier-grid + objection-handler)
- Vercel's product LPs (perf-as-product; compound features into one outcome statement)
- Anthropic's API page (technical buyer; trust signals from real customer logos)
- Wes Bush PLG examples (self-serve hero with one-action CTA)
- Wynter test-validated LP shapes for B2B SaaS (5+ proof types, ICP language verbatim, social proof clusters)

## Per-client notes

- The client's design-system file (e.g. `clients/<client>/brand-voice/design-system-*.md`) is the token source. New homepage / LP / product screen Figma files become preferred reference (when URLs provided) — pull via figma MCP and override generic patterns.
- The client's CR baseline data (analytics export under `clients/<client>/metrics/`) is the ground truth for measurement contracts.
- Displacement LPs (per-competitor) follow the comparison archetype, anchored on `clients/<client>/competitive/` + `clients/<client>/competitors.yaml` aliases.
- Integration LPs follow the integration archetype.

## Substrate preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/substrate/00-INDEX-10-layers-2026-04-30.md`. If any required layer is `thin` or `partial`, the skill returns:

```
SUBSTRATE-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.


## Procedural fix — substrate-cite (added 2026-05-01)

This skill produces externalizable content. Per the substrate-fidelity audit (`knowledge/intel/session-substrate-fidelity-audit-*.md`) and PRINCIPLES anti-pattern "don't author from session memory":

- Every load-bearing claim (number, dollar, percentage, named competitor, named source-system, date) in the produced asset must trace to a substrate file path within the same paragraph OR in a Source column / Source-line annotation OR in an inline source-system ID (HubSpot dashboard NNN, Amplitude project NNN, Asana NNN, Jira KEY-NNN).
- The asset must pass `skills/substrate-cite-check/bin/substrate-cite-check` (preflight Gate 6) before commit.
- Authoring is a substrate-read-and-cite operation, not a session-memory synthesis. If a claim cannot be traced, rephrase it as "unverified" or remove it.

Composes with: `substrate-cite-check` (mandatory final gate); `voice-enforce-vale`; `humanizer`; `lp-cro` (for LP-shaped output); `narrative-check` (for leadership-facing output); `positioning-forge --check` (verifies asset reflects canonical statement).
