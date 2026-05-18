---
name: account-pursuit-rhythm
description: Design a 30/60/90-day pursuit rhythm for an account tier. Outputs cadence spec — touches per week, channel rotation, content gates, hand-off rules from SDR to AE to CS. Cites the rhythm-beats-blast pattern.
version: 0.1
amplifies: SDR manager, ABM lead, AE, CS lead
masters: Jeb Blount (30-day cadence discipline), John Barrows (multichannel touch design), Trish Bertuzzi (pursuit-not-chase), Bev Burgess (tiered ABM 1-to-1, 1-to-few, 1-to-many), Sam Nelson (multithread on trigger), Becc Holland (content gate progression)
substrate_layers_required: [icp, positioning]
patterns_grounded: [rhythm-beats-blast, account-not-lead-as-unit, trigger-events-beat-cadence-blast]
contradictions_aware: [personalization-vs-scale]
preflight_refusal: substrate-gap, missing-tier
required_reads:
  - clients/{client}/icp/00-INDEX.md
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# account-pursuit-rhythm

## Purpose

Produce a 30/60/90-day pursuit rhythm spec for a given tier (1A, 1B, 2). The rhythm spec is the org-level cadence contract: touches per week, channel rotation, content gates, hand-off events from SDR to AE to CS, and review checkpoints. Without an org-level rhythm contract, individual reps drift to burst-and-quiet patterns (per `pat_rhythm-beats-blast`); with the contract, the org runs at consistent tempo.

## Inputs

- `--client <client>` (required)
- `--tier 1A|1B|2` (required) — picks position from `con_personalization-vs-scale`
- `--horizon 30|60|90` (optional, default 90)
- `--mode design|audit <existing-rhythm>` (default `design`)
- `--output <path>` — defaults to `clients/<client>/sales/pursuit-rhythms/<date>-tier-<tier>-rhythm.md`

## Substrate reads

- `clients/<client>/icp/00-INDEX.md` — to ground rhythm against ICP cell complexity
- `clients/<client>/positioning/positioning-canonical-statement.md` — to anchor content gate progression
- `knowledge/patterns/rhythm-beats-blast.md` — the pattern this skill operationalizes

## Process

1. Preflight: validate ICP + positioning + tier.
2. Resolve `con_personalization-vs-scale` per tier.
3. Build cadence skeleton:
   - Tier 1A: 12 touches in 30d (Setup-heavy first 4), then 6 touches in days 31-60, then 4 touches in days 61-90. Multi-thread to 3-5 buyers from day 1.
   - Tier 1B: 10 touches in 30d, 4 in days 31-60, 3 in days 61-90. Multi-thread to 2-3 buyers from day 1.
   - Tier 2: 8 touches in 30d, 2 in days 31-60, 1 in days 61-90 (then drop to nurture). Single-thread to primary buyer.
4. Channel rotation rule: no two consecutive touches use the same channel; email and LinkedIn alternate; voice-mail every 4-5 touches at tier 1A; SMS reserved for tier 1A with permission.
5. Content gate progression: Setup-alternative → Setup-cost → Proof-VoC → Proof-differentiator → Objection → Reframe → Curiosity → Breakup. No two consecutive touches on the same gate.
6. Hand-off rules:
   - SDR → AE: when prospect replies, books meeting, or hits a high-intent surge. AE owns the meeting; SDR remains threaded.
   - AE → CS: at contract signature; SDR drops out. CS reads positioning + ICP + status-quo to maintain consistency with what was sold.
7. Review checkpoints: end of day 30, day 60, day 90. Each checkpoint asks: did the account engage? Move? If neither, demote tier or drop.
8. Output rhythm spec md: cadence schedule + channel + gate + owner + review-checkpoint + hand-off rules.

## Output contract

```
clients/<client>/sales/pursuit-rhythms/<date>-tier-<tier>-rhythm.md
```

Spec contains:
- Frontmatter: tier, horizon, contradiction position applied
- Day-by-day cadence schedule (table)
- Channel rotation rules
- Content gate progression
- Multi-thread spec (which roles get touched, by whom)
- Hand-off events and protocols
- Review checkpoints
- Demote / drop criteria
- Substrate citations

## Quality criteria

- Refuses without canonical positioning (Setup-Follow-Through requires it).
- Refuses if any two consecutive touches are on the same channel + gate combo.
- Refuses if tier 1A rhythm has fewer than 12 touches in first 30 days (under-pursuit at the highest tier).
- Refuses if tier 2 rhythm has more than 10 touches in first 30 days (over-pursuit at the lowest tier — uneconomic).
- Every hand-off rule must specify the trigger event (reply / meeting-booked / surge / contract / etc.) and the owner change.

## Refusal patterns

- Tier missing → refuse (must pick `con_personalization-vs-scale` position).
- Audit mode without `<existing-rhythm>` argument → refuse.
- Audit mode finds rhythm violates rhythm-beats-blast (consecutive same-channel touches OR gap >7 days at tier 1A) → flag, propose fix.

## What this skill does NOT do

- Does NOT compose the touches themselves. That's `outbound-sequence-design`.
- Does NOT score the account. That's `abm-account-prioritize`.
- Does NOT detect signals. That's `sales-trigger-event-watch`.

## See also

- `skills/outbound-sequence-design/` — consumes the cadence schedule from this skill.
- `skills/abm-account-prioritize/` — produces the tier this skill expects.
- `skills/sales-trigger-event-watch/` — produces triggers that intensify rhythm intensity.
- `routines/account-tier-review.md` — quarterly check that consumes day-90 review outputs.
- `knowledge/patterns/rhythm-beats-blast.md`.
- `knowledge/patterns/account-not-lead-as-unit.md`.
