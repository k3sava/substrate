---
title: frontline contact loop
status: active
last_updated: 2026-05-07
patterns_grounded: [frontline-as-pmm-substrate, rapport-surfaces-what-research-cannot]
---

# Frontline contact loop

The frontline contact loop is continuous and the most underrated substrate routine. The codex pattern is unambiguous: positioning, pricing, content, and product-narrative inputs come from frontline customer contact, not desk research. The substrate is the conversation log; without a written cadence, every downstream decision is a guess.

This routine enforces the cadence, captures the artifacts, and refuses to advance work that isn't sourced from a logged conversation.

## Cadence contract

Per role, a written commitment to weekly frontline contact:

| Role | Minimum weekly contact | Format |
|---|---|---|
| Founder | 3 customer conversations | live call or in-person |
| Head of GTM | 5 customer conversations | live call |
| PMM lead | 5 conversations + 1 win/loss | call or async transcript |
| PMs | 2 customer interviews | live call |
| Pricing lead | 3 pricing conversations | live call |
| Sales reps | All recorded; 5 reviewed | recorded calls |
| CS leads | 3 calls + 5 ticket reviews | call or async |

Tony Hsieh's extension: every new hire, including the CFO, does four weeks on customer phones during onboarding.

## Loop steps

### 1. Book

The `frontline-contact` skill checks the cadence ledger weekly. If a role is below minimum, the skill flags the operator and surfaces booking suggestions (recent CS escalations, recent wins, recent losses, recent product asks).

### 2. Log

Each call is logged to `voc/inbox/` with `{call_id, type, participant, ingested_at, source_artifact, raw_extract}`. No transcript path = no log accepted.

### 3. Process

`signal-routine` processes the inbox into patch proposals against substrate layers (positioning, ICP, pricing, sales-pitch).

### 4. Apply

The human gate in `signal-routine` approves or rejects the proposals. Approved proposals patch the layers.

### 5. Audit

The cadence ledger is reviewed weekly in `substrate-status`. Roles below minimum are surfaced for correction.

## Failure modes the routine prevents

- **Pricing decisions made without weekly customer calls** (Patrick Campbell rule). The pricing-strategic skill refuses to set a price without ≥20 logged data points; this routine ensures the data points exist.
- **Positioning drift detected too late** (Dunford rule). Sales detects positioning failure first; this routine routes that signal into the substrate before the dashboard reflects it.
- **Content briefed from keyword tools, not from sales/success/support** (Hufford 3S rule). Content briefs cite ticket clusters; this routine ensures the tickets are read.
- **Founder isolated from the buyer** (Hsieh / Moesta rule). Founder cadence is enforced even when scaling.

## Substrate reads + writes

- Reads: `voc/cadence-contract.md`, `voc/inbox/`, the role registry.
- Writes: `voc/cadence-ledger.md` (append-only call log), patch proposals to `signal-routine` inbox.

## Quality criteria

- Refuses to mark a week "complete" if any role is below minimum.
- Refuses to log a call without a transcript artifact path.
- Surfaces "stale" cadence: a role that hasn't logged a call in N×minimum-period.

## See also

- `skills/frontline-contact/`, the per-call execution skill.
- `skills/win-loss-interview/`, the structured form for outcome interviews.
- `skills/tactical-empathy-discovery/`, the Voss-pattern interview craft.
- `routines/signal-routine.md`, the downstream processing.
- `knowledge/patterns/frontline-as-pmm-substrate.md`.
