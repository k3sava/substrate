---
name: launch-plan
description: Coordinates a product or feature launch as a research-preview-and-cadence sequence with a tier decision (T1/T2/T3), narrative spine, phased cohort, and post-launch measurement contract. Composes positioning + narrative + messaging + content briefs into a single ledger. Refuses without canonical positioning.
version: 0.2
amplifies: PMM, founder, head of product, demand-gen
masters: Andy Raskin (narrative-spine launches), April Dunford (positioning-grounded launch), Lenny Rachitsky (30/60/90 launch sequence), Adam Stinson + Coinbase / Stripe / Shopify launch retro literature (T1/T2/T3 tier discipline), Cat Wu (research preview + frontier programs), Sangeeta Chennapragada / Aparna Chennapragada (Anthropic / Google launch cadence), Yamini Rangan (launch-as-flywheel-event), Mary Sheehan (Adobe launch cycle), Lauren Vaccarello (multi-asset launch ops), Asha Sharma (seasons not roadmaps)
substrate_layers_required: [positioning, product-knowledge, voc, sales-pitch, brand-voice, competitive]
patterns_grounded: [launch-as-coordinated-distribution, research-preview-and-cadence, narrative-as-strategy, distribution-as-moat, agents-mapped-to-jtbd]
contradictions_aware: [short-feedback-vs-long-term-holdouts, build-quietly-vs-distribution-first]
preflight_refusal: substrate-gap, missing-product-knowledge, missing-positioning
required_reads:
  - clients/{client}/positioning/
  - clients/{client}/product-knowledge/
---

# launch-plan

## Purpose

A launch that ships as a single-day press push underperforms a launch that ships as a coordinated multi-channel sequence with a phased cohort, a narrative spine, and a measurement contract. Per `pat_launch-as-coordinated-distribution` (Raskin + Dunford + Rachitsky + Stinson) and `pat_research-preview-and-cadence` (Cat Wu + Aparna Chennapragada + Asha Sharma): the launch is not a moment; it is a campaign with stages.

## Inputs

- `--client <client>` (required)
- `--launch <feature-or-product-id>` (required) — a slug like `voice-ai-agent-2026-q3`
- `--launch-date <YYYY-MM-DD>` (required) — the public-launch day
- `--audience <pinned-icp>` (required) — the primary audience cohort
- `--tier <T1|T2|T3>` (required for `--mode plan`) — drives every other constraint
- `--mode <plan|preview|ship|holdout|retrospective>` (default: `plan`)

## Phase structure

1. **Research preview** (T-N weeks, N varies by tier): invite N pinned customers / experts; collect VoC artifacts; iterate narrative + product. T1: 5-15 buyers. T2: 3-5. T3: 0-2.
2. **Closed beta** (T-week, applies for T1 and T2): expand to a wider pinned cohort; instrumentation lit; signal cadence open.
3. **Frontier program** (T-day, applies for T1): named-customer artifacts (case studies, quotes, screenshots) committed; the launch-day proof set.
4. **Launch day**: narrative spine published; channel adaptations live; pSEO variants up; press / community simultaneously hit.
5. **Post-launch holdout** (T+N weeks, N varies by tier and reversibility per `short-feedback-vs-long-term-holdouts`): measurement holdout for falsifiable signal; iterate.

## Tier discipline (per `pat_launch-as-coordinated-distribution`)

| Tier | Cohort scope | Channel mix | Measurement window | Cost discipline |
|---|---|---|---|---|
| **T1** | Research preview 5-15 + frontier program 3-5 named customers | Multi-channel (press, social, ads, email, community, partners) | 90-day primary + 6-month NRR | Budgeted cohort; founder time; named launch lead |
| **T2** | Research preview 3-5 | Single hero asset + email + 1-2 ads | 30-day | Single launch lead |
| **T3** | None or 1-2 | Changelog + in-app announcement + feature-flag rollout | 14-day | Single PR + product owner |

## Conditions awareness

- **`short-feedback-vs-long-term-holdouts`**: post-launch measurement shape. Reversible features with small cohorts use short feedback (1-2 weeks). One-way category-defining launches use long-term holdouts (90 days primary + 6-month retention).
- **`build-quietly-vs-distribution-first`**: pre-PMF / deep-tech contexts trigger build-quietly (research preview is the entire motion; no public launch yet). Post-PMF contexts trigger distribution-first (the coordinated sequence above). The skill names which position the plan picks, with the conditioning evidence.

## Substrate reads

- `positioning/`, the canonical statement (load-bearing — every asset cites it).
- `product-knowledge/launch-features.md` (or the product-knowledge dir), what's actually shipping.
- `voc/processed/`, customer language for the launch story.
- `competitive/`, the alternatives the launch displaces.
- `messaging/matrix.md`, channel adaptations from `messaging-matrix`.

## Output contract

Per launch, the skill writes to `clients/<client>/launches/<launch>/`:

- `plan.md` — top-level launch plan (narrative spine, tier, cohort, channels, measurement)
- `preview-cohort.md` — preview cohort scope + invitations + collected feedback
- `frontier-artifacts/` — named-customer artifacts (only for T1)
- `measurement-contract.md` — falsifiable predictions per metric
- `30-60-90.md` — 30-day, 60-day, 90-day milestone plan
- `retrospective.md` — written at T+90 (or T+30 for T2, T+14 for T3); resolution of the measurement contract

Every artifact carries `produced_by: launch-plan` in frontmatter so Gate 7 (pattern-applied) can verify pattern application.

## Quality criteria

- Refuses a launch with no canonical positioning (positioning-forge prerequisite).
- Refuses a T1 launch with no preview cohort named.
- Refuses any launch with no calibrated prediction in the measurement contract.
- Refuses a launch-day asset that doesn't cite at least one frontier-program customer artifact (T1 only).
- Flags drift: launch-day claims that exceed product-knowledge.

## See also

- `skills/campaign-strategy/`, the wider go-to-market wrapper (for ongoing demand-gen post-launch).
- `skills/narrative-strategy/`, the spine.
- `skills/messaging-matrix/`, channel adaptations.
- `knowledge/patterns/launch-as-coordinated-distribution.md`.
- `knowledge/patterns/research-preview-and-cadence.md`.
- `templates/launch-plan-example.md` — a fixture launch plan to read against.
