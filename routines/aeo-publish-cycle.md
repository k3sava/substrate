---
title: AEO publish cycle, monthly working cadence
status: active
last_updated: 2026-05-08
cadence: monthly, with a weekly citation snapshot sub-loop
owner: SEO / AEO lead, PMM lead approves the publish queue
patterns_grounded: [aeo-triangle, distribution-as-moat, agents-as-product-users, make-implicit-explicit]
contradictions_aware: []
composes: [aeo-tune, aeo-relevance, aeo-manual-action, content-routine, claim-verify, pre-publish-check, help-docs, pseo-framework]
---

# AEO publish cycle

The monthly cadence that runs the AEO triangle (presence, relevance, manual-action) as a closed working loop. The weekly `routines/aeo-routine.md` produces the citation snapshot and gap analysis; this monthly cycle is where snapshots roll up into a publish queue, content ships, and the post-publish citation re-pull lands at month +1.

## Why this exists

The AEO triangle has three layers (per `knowledge/patterns/aeo-triangle.md`): presence (do you appear in the citation set), relevance (right framing for the prompt the buyer asked), manual-action (off-domain mention density that tells the model your claim is corroborated). All three operate together; optimising one without the others is partial coverage.

The weekly aeo-routine pulls the citation data and surfaces gaps. But weekly cadence on publish-and-measure is wrong. Content takes a month to compound (LLM crawl windows, citation propagation, seasonal AEO trend cycles). Monthly is the right cadence for the publish queue + measurement loop; weekly is the right cadence for the snapshot + queue refresh.

This routine binds the two. Week 1: snapshot + queue refresh. Weeks 2-3: publish from the queue, gated. Week 4: ship through claim-verify and pre-publish-check. Month +1: re-pull citation data on the targeted prompts, score the bet, update the substrate. The AEO triangle compounds because the loop closes every month.

## Stages

### Week 1, citation snapshot and queue refresh

**Run** (per `routines/aeo-routine.md` Stages 1-2):

```bash
# Stage 1, citation tracking
# Stage 2, gap analysis
substrate aeo-tune --client <client> --mode snapshot
substrate aeo-relevance --client <client> --mode gap-analysis
```

**What happens.** The weekly aeo-routine's first two stages pull current citation data from the client's tracked AEO tool (Amplitude AI Visibility, Ahrefs AI Overview tracking, equivalent), compute gaps versus the prior snapshot, and classify into greenfield / rank-drops / new-territory.

The monthly publish cycle reads the four most recent weekly snapshots (or however many landed in the month) and rolls them up into a publish queue: which prompts are highest-leverage, which are persistent gaps, which moved against baseline.

**Output**: `clients/<client>/aeo/monthly-queue-<YYYY-MM>.md`. Persistent gap report.

**Refusal triggers.** No baseline snapshot from prior cycle (this is the first month; build the baseline). Citation tool data missing or stale. Fix the data input, not the queue.

### Weeks 2 to 3, generate AEO content per prompt

**Run** (per queue entry):

```bash
substrate aeo-relevance --client <client> --prompt <prompt-id> --mode generate
substrate help-docs --client <client> --topic <prompt-topic>  # for help-doc surfaces
substrate pseo-framework --client <client> --vertical <vertical> --variants <count>  # for programmatic surfaces
```

**What happens.** Per queue entry, the aeo-relevance skill generates content targeting that prompt: FAQ entries with FAQPage schema markup, listicle entries for "Best [category] software" prompts, structured comparison content for head-to-head prompts. Help-docs handles help-article surfaces (which carry AEO-grade citation surface even when serving customers). PSEO-framework handles programmatic vertical pages where the prompt lattice covers many cells.

Every factual claim cites a substrate path (`product-knowledge/`, `competitive/`, `voc/processed/`); no claims generated without a substrate source.

Per `agents-as-product-users`, the content is dual-audience: human readers (clarity, structure, voice) and machine readers (FAQPage schema, ItemList, JSON-LD product markup, well-known endpoints, llms.txt entry). Both passes are non-optional; either one's absence is a gap.

**Output**: per-prompt content files at `clients/<client>/assets/aeo/<YYYY-MM>-<prompt-slug>/`. Each carries `produced_by: <skill>` so gates 7 and 8 fire on pre-publish-check.

**Refusal triggers.** Substrate gap (positioning, product-knowledge, voc not populated). Prompt without a target substrate path. Generated content without schema markup.

### Week 4, gate the queue and ship

**Run** (per asset):

```bash
substrate pre-publish-check clients/<client>/assets/aeo/<asset> --client <client>
substrate claim-verify clients/<client>/assets/aeo/<asset> --client <client>  # composed inside pre-publish-check
substrate aeo-manual-action --client <client> --asset <asset> --mode propagate
```

**What happens.** Every asset routes through pre-publish-check. The composite gate runs: substrate-cite, voice, claim-verify, audience-test, gates 7 + 8 (pattern-applied + contradiction-position-logged). AEO content carries higher claim-density than narrative content; the claim-verify gate is the primary friction and should not be relaxed.

Approved assets ship to the indexed surface (the client's website, a third-party publisher the LLMs already cite, a structured-data addition to an existing product page). The aeo-manual-action skill schedules the off-domain propagation: which third-party citations to seek, which podcasts / Q&A surfaces / community sites the asset should land on within 30 days post-ship to corroborate the claim. The triangle's third leg.

**Output**: shipped assets logged in `clients/<client>/assets/aeo/SHIPPED.md`. Off-domain propagation queue at `clients/<client>/aeo/manual-action/<YYYY-MM>.md`.

**Refusal triggers.** Composite gate fails. Voice flagged (AEO content is still customer-facing copy). Claim-verify fails. Schema markup missing or invalid. Off-domain propagation not scheduled (the third leg is not optional).

### Month +1, re-pull citation data and score

**Run**:

```bash
substrate aeo-tune --client <client> --mode re-measure --since <YYYY-MM-DD>
substrate score-goal --goal-id <aeo-batch-prediction>
```

**What happens.** Per `routines/aeo-routine.md` Stage 6 measurement contract, four weeks after ship, the targeted prompts get re-pulled and compared to baseline. The bet structure: "X of Y targeted prompts move from <Z% to ≥50% visibility within 90 days" (or the per-batch contract).

The Brier score updates the operator's calibration on AEO taste-type. The market-context layer updates: which prompt categories the client now appears in, which competitor citations have moved, which off-domain mentions actually compounded.

**Output**: `clients/<client>/aeo/measurement-<YYYY-MM>.md`, resolved goal on `goals/ledger.md`, updated market-context substrate.

**Refusal triggers.** Re-measurement attempted before the 4-week minimum. Comparison done against a different prompt set than the original bet (per `PRINCIPLES.md` rule 2, no cohort-swap mid-bet).

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| Week 1 | `aeo-tune` (snapshot mode) | `skills/aeo-tune/SKILL.md` |
| Week 1 | `aeo-relevance` (gap analysis mode) | `skills/aeo-relevance/SKILL.md` |
| Weeks 2-3 | `aeo-relevance` (generate mode) | `skills/aeo-relevance/SKILL.md` |
| Weeks 2-3 | `help-docs` | `skills/help-docs/SKILL.md` |
| Weeks 2-3 | `pseo-framework` | `skills/pseo-framework/SKILL.md` |
| Week 4 | `pre-publish-check` (composite gate) | `skills/pre-publish-check/SKILL.md` |
| Week 4 | `claim-verify`, `voice-enforce` (composed inside pre-publish-check) | per skill |
| Week 4 | `aeo-manual-action` | `skills/aeo-manual-action/SKILL.md` |
| Month +1 | `aeo-tune` (re-measure mode) | `skills/aeo-tune/SKILL.md` |
| Month +1 | `score-goal` | `skills/score-goal/SKILL.md` |

## Inputs required

- Active client substrate with positioning, product-knowledge, competitive, voc layers populated.
- A tracked AEO tool with API access (Amplitude AI Visibility, Ahrefs AI Overview tracking, or equivalent) producing the weekly citation data the snapshot reads.
- A pinned prompt set: which buyer-asked prompts the client targets. Generated from positioning + competitive + voc; refreshed quarterly.
- An indexed publish surface: the client's website, a third-party publisher list, a structured-data lattice. AEO content can't land on a surface LLMs don't crawl.
- An approved measurement contract per batch (predicted_p, target visibility shift, resolution date).

## Outputs produced

- `clients/<client>/aeo/monthly-queue-<YYYY-MM>.md` (week 1 of each month).
- Per-prompt content drafts under `clients/<client>/assets/aeo/<YYYY-MM>-<prompt-slug>/` (weeks 2-3).
- Per-asset preflight reports (week 4).
- Shipped assets logged in `clients/<client>/assets/aeo/SHIPPED.md`.
- Off-domain propagation queue at `clients/<client>/aeo/manual-action/<YYYY-MM>.md`.
- `clients/<client>/aeo/measurement-<YYYY-MM>.md` (month +1).
- Resolved goals on `goals/ledger.md` per AEO batch.
- Updated market-context substrate layer.

## Failure modes

- **The weekly snapshot doesn't roll up.** Snapshots accumulate but never get composed into a monthly queue. The monthly queue refresh at week 1 is non-optional; without it, the AEO triangle becomes "we ship some FAQs occasionally" rather than a compounding loop.
- **Content shipped without manual-action propagation.** Per the triangle pattern, all three legs operate together. Owned-domain assets without off-domain corroboration land but don't compound; LLMs cite them at lower confidence because no third-party sources confirm. Schedule the propagation at ship time, not as an afterthought.
- **Claims that don't trace to substrate.** AEO content is claim-dense; the claim-verify gate is the highest-friction gate in the cycle. Failures here are usually substrate gaps (product-knowledge stale, competitive data older than the freshness window). Fix the substrate.
- **Re-measurement done at week 2 because "let's see if it worked."** The 4-week minimum exists because LLM crawl windows haven't closed before then. Premature measurement biases the bet; per Rule 2, the resolution date is the resolution date.
- **Schema markup missing on shipped content.** Half the AEO triangle is machine-readability (per `agents-as-product-users`). Content without schema is invisible to half the audience. The pre-publish gate should flag this; if it doesn't, the gate needs a tightening, not the content needs a pass.
- **Vague prompts in the queue.** "Best sales dialer software" is not a prompt; "best sales dialer for a 10-person team" is. Vague prompts can't be measured against because they're ambiguous in the citation tool's matching logic. Tighten the prompt list at the quarterly refresh.

## Calibration hooks

- Each AEO batch (week 4 ship) opens a goal on `goals/ledger.md` with predicted_p and a measurement contract.
- Month +1 resolution adds to the operator's AEO-taste calibration history.
- Sustained accuracy (3+ months of correct visibility predictions) earns the operator decision authority on next-quarter prompt prioritisation per `PRINCIPLES.md` rule 6.
- The triangle's three legs each carry their own calibration: presence taste (aeo-tune), relevance taste (aeo-relevance), manual-action taste (aeo-manual-action). An operator can be calibrated on one leg and not the others; the leaderboard surfaces the per-leg distribution.
- Substrate-update proposals from month +1 measurement update market-context, competitive, and product-knowledge layers; the next month's queue opens on sharper inputs.

## Composes with

- `routines/aeo-routine.md`, the weekly citation snapshot sub-loop the monthly cycle reads from.
- `routines/content-routine.md`, the on-demand asset generation skill chain that AEO-relevance triggers.
- `routines/quarterly-pmm-cycle.md`, when AEO is one of the quarter's named goals.
- `routines/competitor-watch-cycle.md`, when competitor citation moves trigger the AEO queue refresh.
- `routines/launch-flow.md`, when a launch's owned content needs AEO compounding.

## See also

- `skills/aeo-tune/SKILL.md`, the presence-layer skill.
- `skills/aeo-relevance/SKILL.md`, the relevance-layer skill.
- `skills/aeo-manual-action/SKILL.md`, the propagation-layer skill.
- `routines/aeo-routine.md`, the weekly sub-loop's full spec.
- `knowledge/patterns/aeo-triangle.md`, the load-bearing pattern.
- `knowledge/patterns/agents-as-product-users.md`, the dual-audience justification.
- `knowledge/patterns/distribution-as-moat.md`, the off-domain-propagation pattern.
- `PRINCIPLES.md` rule 1 (context-first), rule 2 (falsifiability), rule 4 (outcomes not features).
