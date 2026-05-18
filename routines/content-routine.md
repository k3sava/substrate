---
title: content loop
status: active
last_updated: 2026-04-30
---

# Content loop

The content loop is on-demand. It runs when a bet has been approved and is ready for asset generation. It produces customer-facing content from the bet contract, runs it through preflight, gates it with a human, and ships it.

The content loop is documented here at the loop level. The detailed per-stage mechanics are in `routines/goal-routine.md` (Stages 4-7).

---

## What the content loop optimizes for

Quality per operator-hour, not volume. The substrate is the multiplier. The operator's time goes into:
1. Writing and approving the bet contract (judgment call)
2. Reviewing preflight-passed assets (taste call)
3. Verifying [VERIFY] flags in generated content (fact check)

The operator's time does not go into:
- Writing first drafts
- Formatting assets
- Producing multiple channel variants from a single brief

The copy-generator agent handles those. The preflight-gate agent filters before human eyes touch it.

---

## The iterate vs abandon decision

After the first content generation pass, the operator has three options:

**Ship:** preflight passed, operator approved. The asset goes.

**Iterate:** preflight passed but the operator wants a change. Feed the revision note back to the copy-generator. Re-run preflight on the revised version. The iteration loop has a maximum of 3 passes. After 3 passes without approval, the operator reviews the bet contract — the asset problem is usually a contract problem.

**Abandon this variant:** preflight failed or the operator does not approve any variant after 3 passes. Options: (a) revise the bet contract and restart, (b) mark the bet `open` (not yet active) and park asset generation, (c) abandon the bet.

**What the abandon pattern reveals:** when content loops consistently fail to produce approvable assets, the substrate layer being cited is usually the problem. The operator investigates: is the positioning clear enough to write to? Is the ICP specific enough to generate for? Is the brand voice defined enough to check against? Substrate gaps surface as content failures.

---

## Cross-channel coherence

When a bet generates assets for multiple channels (landing page + email + SDR script + battlecard), all assets must honor the bet contract. The same belief, action, audience, proof, and differentiation hook appear across all channels — adapted for format and tone, not contradicting each other.

The preflight-gate agent checks for cross-channel coherence when multiple assets are submitted together. A landing page that says one thing and an email that says a contradictory thing fails the coherence check.

---

## The content loop is not the AEO loop

The content loop generates assets for specific bets with specific business outcomes (conversion, enablement, expansion). The AEO loop generates content specifically for LLM citation with citation measurement as the outcome. They share the copy-generator agent and the preflight-gate agent but have different triggers, cadences, and measurement designs.
