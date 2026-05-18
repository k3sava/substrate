---
name: battle-card-driver
description: Given a deal in flight against a named competitor, surface relevant battle-card content from clients/<client>/competitive/battle-cards/ and emit AE-ready talking points. Composes claim-verify on every claim about the competitor.
version: 0.1
amplifies: AE, sales enablement, ABM lead
masters: April Dunford (positioning is comparison-aware; named competitor framing), Bev Burgess (1-to-1 ABM materials per account), Tim Riesterer (Corporate Visions — challenger-style framing in deals), Mark Roberge (sales engineering — battle cards as workflow primitive), Anthony Pierri (5-second alternative-anchored opener)
substrate_layers_required: [competitive, positioning]
patterns_grounded: [status-quo-is-the-real-objection-outbound, differentiation-vs-sameness, copywriting-craft-fundamentals]
contradictions_aware: [no-decision-vs-named-competitor, personalization-vs-scale]
preflight_refusal: substrate-gap, missing-battle-card, missing-positioning
required_reads:
  - clients/{client}/competitive/battle-cards/
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# battle-card-driver

## Purpose

Take a deal-in-flight against a named competitor + a buyer-state + a deal-stage, surface the right battle-card content and emit AE talking points. Battle cards in folders nobody reads is the failure mode this skill addresses (per `pat_status-quo-is-the-real-objection-outbound` and `con_no-decision-vs-named-competitor`). The skill respects that contradiction: in early-stage deals, status-quo framing dominates; in late-stage deals against a named competitor, battle-card content dominates.

## Inputs

- `--client <client>` (required)
- `--competitor <slug>` (required) — the named competitor in the deal
- `--buyer-state <unaware|problem-aware|solution-aware|product-aware|most-aware>` (required)
- `--deal-stage <discovery|qualification|demo|proposal|close|breakup>` (required)
- `--objection <one-line>` (optional) — the specific objection to address
- `--account <name>` (optional) — for naming the talking points
- `--output <path>` — defaults to `clients/<client>/sales/talking-points/<date>-<account>-<competitor>.md`

## Substrate reads

- `clients/<client>/competitive/battle-cards/<competitor>.md` — the battle-card file for the named competitor
- `clients/<client>/positioning/positioning-canonical-statement.md` — to ground talking points in canonical position
- `clients/<client>/competitive/status-quo.md` — to layer status-quo framing alongside competitor framing
- `clients/<client>/voc/processed/` — to surface displacement quotes from customers who switched

## Process

1. Preflight: validate competitor battle-card exists; refuse if missing.
2. Resolve `con_no-decision-vs-named-competitor`: in early stages (discovery, qualification), apply status-quo framing first, competitor framing second. In late stages (demo, proposal, close), apply competitor framing first, status-quo as kicker.
3. Read battle-card; extract: one-line position, when-they-win, when-we-win, honest-losses, talk-track, recent-shifts.
4. Read positioning canonical statement; extract: alternative, unique value.
5. Map (buyer-state, deal-stage, objection) → which battle-card sections to surface:
   - discovery + problem-aware → setup-cost, when-they-win (don't oversell)
   - qualification + solution-aware → when-we-win, talk-track
   - demo + product-aware → talk-track, recent-shifts
   - proposal + most-aware → honest-losses (to qualify in/out), talk-track
   - close + most-aware → talk-track, displacement-quote
   - breakup → honest-losses, "lose-fast" pattern
6. Compose talking points: 3-5 short rep-ready statements with substrate citations.
7. Run claim-verify on every load-bearing claim about the competitor (per `pat_make-implicit-explicit`); flag any claim without substrate backing.
8. Write talking-points file with frontmatter + sections.

## Output contract

```
clients/<client>/sales/talking-points/<date>-<account>-<competitor>.md
```

Sections:
- Frontmatter (deal-stage, buyer-state, objection, contradiction-positions-applied)
- Position summary (one-line)
- Talking points (3-5, rep-ready)
- Honest losses (when to disqualify the deal vs. competitor)
- Displacement quote (if available from VoC)
- Recent shifts to mention or avoid
- Claim-verify status (pass/fail per claim)

## Quality criteria

- Refuses without battle-card file for the competitor.
- Refuses without canonical positioning.
- Every load-bearing competitor claim must run through claim-verify; failed claims are flagged, not silently shipped.
- Talking points respect the buyer-state: don't pitch features at problem-aware buyers; don't run cost-of-inaction at most-aware buyers (they already know).
- "Honest losses" section is mandatory: when not to fight the deal (this is the discipline that prevents the AE from forcing a misfit deal to close-lost-to-X).

## Refusal patterns

- Battle-card for competitor missing → refuse; first action is to run `competitive-scout --competitor <slug>` to fill the gap.
- Battle-card older than 30 days (pricing decay window per competitive-scout default) → soft warn; talking points include "verify pricing before send."
- Buyer-state and deal-stage misalignment (e.g., breakup-stage with unaware buyer) → refuse; the combination is incoherent.

## What this skill does NOT do

- Does NOT update battle cards. That's `competitive-scout` + signal-analyst.
- Does NOT generate the deal motion. That's `outbound-sequence-design` (for outbound) or the AE's own discovery flow.
- Does NOT score the account. That's `abm-account-prioritize`.

## See also

- `skills/competitive-scout/` — keeps battle cards fresh.
- `skills/claim-verify/` — composed on every competitor claim.
- `skills/positioning-forge/` — produces the canonical statement this skill reads.
- `skills/outbound-sequence-design/` — sister skill for outbound; this one is for in-deal AE workflow.
- `templates/battle-card.md` — the battle-card shape this skill expects.
- `knowledge/patterns/status-quo-is-the-real-objection-outbound.md`.
- `knowledge/contradictions/no-decision-vs-named-competitor.md`.
