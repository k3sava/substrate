---
id: con_floor-as-draw-vs-floor-as-retainer
title: Floor as outcome-conditioned draw vs floor as standalone retainer
captured_date: 2026-05-18
positions: 2
domains: [consulting-pricing, engagement-shape, anti-fabrication]
related_patterns: [pat_outcomes-tied-pricing, pat_productized-consulting-beats-hourly, pat_brier-priced-engagement]
---

# Floor as draw vs floor as retainer

## The tension

Outcomes-based pricing — Phase 2 in Kesava's published offer — declares a "floor + variable" structure. The floor is the operator's draw against the engagement; the variable is the outcomes-tied component (% of attributable lift, per-unit bonus, or Brier-bonus).

The tension: what the floor IS. Operationally identical to a monthly retainer (recurring fixed payment), conceptually the opposite (conditioned on the measurement contract, not on calendar). A prospect — or a careless future agent — will collapse the distinction. Substrate refuses to.

## Position A — Floor is an outcome-conditioned operator draw (substrate default)

The floor is the operator's draw against the signed measurement contract. It is:

- **Conditioned**: no signed measurement contract → no floor. The floor is contingent on the contract existing.
- **Outcome-anchored**: the contract names the metric, the source-of-truth, the baseline, the window, the verification path. Without these, the floor cannot exist.
- **Operator-time coverage**: covers the operator's time at a steady cadence so the work isn't rationed by hours. It is not paid in exchange for hours; it is paid in exchange for being on the contract.
- **Companion to variable**: the floor exists alongside a variable structure. The full pricing is `floor + variable`. The floor alone is incoherent.

Position A says: substrate enforces the measurement-contract condition. The floor never appears in a proposal without the variable structure and the metric. Substrate refuses Position B framings.

## Position B — Floor is a standalone retainer (rejected)

A prospect reads "floor" and pattern-matches "retainer." A future agent reads the floor amount and ships it as a standalone monthly recurring fee.

Position B says: take the floor, drop the variable, drop the measurement contract, ship the work. This is the contract that lets consultants hide behind calendar without scoring. It's the contract that Jonathan Stark's productized-consulting discipline refuses on grounds of hours-not-outcomes; it's the contract Kesava's published offer refuses on grounds of "Strategic advisor, $X/month, no scoring."

Position B is rejected at preflight by `engagement-shape-pricing`. The skill returns `PURE-RETAINER-REQUESTED` and redirects to Phase 1 measurement-contract scoping.

## Conditioning — when does each position apply

Always Position A. The contradiction is documented because the language collapse is constant ("floor" reads like "retainer" to anyone not inside the substrate); the skill must hold the line even when the prospect uses retainer language and the operator is tempted to translate-for-comfort.

**Trigger checks substrate runs:**

1. Is there a `measurement_contract_path` input to the pricing skill? If no → `MISSING-MEASUREMENT-CONTRACT`, Position B inferred, refuse.
2. Does the proposal include a variable structure (% lift / per-unit / Brier-bonus)? If no → Position B inferred, refuse.
3. Does the floor appear without a contract path AND without a variable? If yes → Position B inferred, refuse with `PURE-RETAINER-REQUESTED`.
4. If all three pass → Position A confirmed, ship the proposal.

## Why the distinction matters

- **For the operator**: a standalone retainer makes the operator's value undemonstrable. The floor + variable structure forces every engagement to declare what it intends to move and prove it moved.
- **For the prospect**: a standalone retainer makes the engagement a calendar bet, not an outcome bet. The prospect can't ratchet variable down on under-delivery because there's no variable.
- **For the substrate**: anti-fabrication. The skill's job is to refuse hidden assumptions. "Retainer" hides the assumption that calendar = value. Substrate names the assumption and refuses it.

## Refusal language (when the prospect asks)

> "The floor exists, but it doesn't exist alone. It's the operator-time draw against a signed measurement contract — what we agreed to move, how we measure it, when we resolve it. Without the contract, there's nothing for the floor to be a floor *of*. If we want to move forward without a measurement contract, the engagement is something different (probably Phase 1 scoping); the pricing is something different (the Phase 1 fixed fee, not the Phase 2 floor)."

## See also

- `pat_outcomes-tied-pricing` — the master pattern for outcomes-based pricing
- `pat_productized-consulting-beats-hourly` — the same anti-hours discipline applied at engagement level
- `pat_brier-priced-engagement` — the variable structure that the floor is a companion to
- `canonical/portfolio-consulting-offer.md` — the canonical source
- `knowledge/contradictions/scope-flex-vs-fixed-fee.md` — the Phase 1 vs Phase 2 scope-discipline contradiction
- `knowledge/contradictions/sprint-vs-retainer-default.md` — the Phase 2 continuation-shape contradiction
