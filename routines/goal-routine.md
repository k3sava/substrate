---
title: bet loop
status: active
last_updated: 2026-04-30
---

# Bet loop

The bet loop is event-driven. It opens when the operator proposes a bet and closes when the bet resolves and the substrate updates. Each pass through the loop produces calibration data.

---

## Stage 1 — Propose

Operator writes a bet file in `clients/<slug>/bets/`. Status: `proposed`.

The bet may be rough at this stage. The hypothesis can be directional. But the operator must have a real measurement question in mind — even if the measurement_design is not yet fully specified.

The bet linter runs immediately on save. It flags missing required fields and explains what each failure means.

**Operator task:** write the bet. Review linter output. Iterate on measurement_design until the linter passes.

---

## Stage 2 — Open

Once the linter passes (all required fields present, measurement_design non-empty and parseable), the operator moves the bet to `open`.

The bet-reviewer agent validates:
1. All required fields present
2. `measurement_design` contains: data source, method, cohort definition, ambiguous-case handling
3. `resolution_date` is in the future
4. All `substrate_layers_cited` exist in the client's substrate directory
5. Each cited substrate layer is within its decay period (if any are expired, the agent flags and the operator decides whether to proceed)

**Operator task:** review the bet-reviewer's validation report. Fix any failures. Mark bet `open`.

---

## Stage 3 — Contract

Before any asset generation, the bet contract is written. One contract per bet. The contract has five fields:

1. **Belief** — the single thing this bet asserts is true about the buyer
2. **Action** — what asset or change tests the belief
3. **Audience** — the specific buyer cohort (must map to a persona from icp.md)
4. **Proof** — the claim that will land if the belief is correct (must trace to substrate)
5. **Differentiation hook** — why this is true for this client and not for alternatives

The contract is the brief for asset generation. No contract, no assets.

**Operator task:** write the contract (or review the agent-proposed draft). Mark contract `approved` when ready.

---

## Stage 4 — Generate

The copy-generator agent reads the bet contract plus the relevant substrate layers. It generates assets per the bet's taste_type and channel specifications:

- Positioning bet → landing page brief, homepage copy variant
- Sales enablement bet → one-pager, battlecard update, objection playbook entry
- AEO bet → FAQ entries, structured content blocks
- Demand gen bet → email sequence, ad creative brief, SDR script

Every generated asset:
- Cites substrate paths for each factual claim
- Carries a `[VERIFY]` flag on any numeric claim the operator needs to confirm against primary source
- Is scoped to the client (no cross-client data)

**Agent task:** generate assets per contract. Queue for preflight. Log to `clients/<slug>/logs/`.

---

## Stage 5 — Preflight

The preflight-gate agent scores each generated asset against the bet's `synthetic_audience_persona_id` plus the client's full ICP persona panel.

Scoring dimensions:
1. Clarity (does the buyer understand the claim)
2. Relevance (does this connect to the buyer's pain)
3. Differentiation (does this give a reason to prefer this product)
4. Proof density (are claims supported by evidence the buyer would find credible)
5. Voice match (is this on-brand per the brand-voice layer)
6. Persona appropriateness (does this speak to the right buyer, not the wrong one)
7. Operator-voice check (no kill-list words, no throat-clearing openers)

**Score threshold:** mean ≥3.5 across all dimensions, no dimension below 2.5. Assets below threshold are killed. Assets that narrowly miss get a revision suggestion.

**Gate output:** preflight report attached to each asset. `PASSED` or `FAILED` + score breakdown.

---

## Stage 6 — Human review gate

Only assets that passed preflight reach a human reviewer.

The human reviewer checks:
1. Are the claims true? (Verify `[VERIFY]` flags against primary sources)
2. Is the differentiation real? (Does it hold up against the competitive layer)
3. Is the voice right? (Intuition check beyond what the agent scored)
4. Is the bet contract honored? (Does the asset deliver the belief, action, audience, proof, differentiation hook)

**Gate output:** `approved` or `requires revision` with specific notes.

---

## Stage 7 — Ship

Approved assets ship to channel. Channel depends on asset type:
- Landing page → Vercel deploy
- Email → ESP
- Sales asset → Slack to sales channel owner
- AEO content → website publish
- Battlecard → sales enablement library

Bet status moves to `active`. The measurement window begins.

---

## Stage 8 — Resolve

On the resolution_date, the operator (with bet-reviewer agent support) measures the actual outcome per the measurement_design.

**Measurement discipline:**
- Do not start measuring early
- Do not extend the window because the results "aren't in yet" (extension requires a new resolution_date and a reason)
- Do not average over a different cohort than specified

The verdict is: YES, NO, or AMBIGUOUS.

**YES:** the predicted outcome was met. Brier score computed from predicted_p.
**NO:** the predicted outcome was not met. Brier score computed.
**AMBIGUOUS:** the measurement could not be completed as designed (data corruption, cohort was too small, external confound changed the baseline). Log the reason. Do not score Brier. Extend with a new measurement plan.

Bet status moves to `resolved`.

---

## Stage 9 — Substrate update

Every resolved bet produces a substrate patch proposal.

YES resolution: what did this confirm that the substrate should record as evidence?
NO resolution: what did this invalidate that the substrate needs to unlearn?
AMBIGUOUS: what would need to be true to get a clean signal next time?

The bet-reviewer agent proposes the patches. The operator approves. The substrate updates.

**This is not optional.** A bet that resolves without a substrate_update decision has not closed the loop.

Bet status stays `resolved`. Calibration ledger updates with Brier score. Substrate health record updates.
