---
loop_id: call-intel-narrative-drift
purpose: post-LP-ship monitoring — does what reps say match what the LP claims?
status: spec (not yet built)
cadence: weekly
owner: PMM lead + sales enablement lead
consumed_by: sales-enablement, narrative-compose (re-anchor signal)
sources:
  - call-intel cohort data (Gong / Chorus / call-recording integration of choice)
  - clients/<client>/assets/draft/lp-*.md (deployed LPs)
  - clients/<client>/substrate/battle-card-*.md (4-rung ladders)
attribution: synthesis (loop spec)
---

# Loop spec — call-intel-narrative-drift

## Purpose

After an LP ships and a battle card is rolled out to sales, monitor whether reps actually use the framing on real calls. Drift between LP claim and rep talk-track is a leading indicator of:
- Inadequate sales enablement (need a refresh)
- LP claim is unrealistic for sales context (rewrite the LP)
- Battle card 4-rung ladder doesn't match how reps actually open / qualify / close

This is **post-rollout monitoring**, not a pre-ship gate. It surfaces drift; humans decide what to do about it.

## Why this matters

Sales-narrative cross-check is not a sales-enablement pre-ship blocker. It runs on call intel after enablement rollout. The lead's ear-to-the-ground is the audit signal, not the gate.

This loop replaces "the sales enablement lead listens to N calls a week and flags drift" with "loop reads N calls a week and flags drift; sales enablement reviews flags weekly".

## Architecture

```
weekly cron
  ↓
call-intel pull (Gong / Chorus / call-recording integration)
  ↓
per-call: extract rep talk-track segments by stage (open / discovery / qualify / handle-objection / close)
  ↓
per-LP/battle-card: load claim list (LP hero + section headers + battle-card 4-rung)
  ↓
for each (call × LP-or-battle-card):
  - compute claim-match score (does rep mention the LP's positioning?)
  - flag drift when match score < threshold
  - flag overreach when rep says something the LP doesn't claim
  ↓
weekly digest:
  - per-LP: % of calls aligned vs % of calls drifting
  - per-rep: alignment trend (improving / drifting)
  - per-claim: which LP claims are landing vs being ignored
  ↓
post to Slack #sales-enablement-drift
post to knowledge/intel/narrative-drift-<client>-<week>.md
```

## Inputs

- **Call intel data:** transcripts + per-call metadata (rep, stage, outcome) from the team's call-recording vendor.
- **Active LPs:** `clients/<client>/assets/draft/lp-*.md` once promoted to `staging/` or `prod/`. Frontmatter contains the claim list (hero + section headers).
- **Battle cards:** `clients/<client>/substrate/battle-card-*.md` 4-rung ladders + anti-patterns.

## Outputs

1. **Weekly digest:** `knowledge/intel/narrative-drift-<client>-<YYYY-WW>.md` — per-LP and per-rep alignment metrics + flagged drifts
2. **Slack alert:** `#sales-enablement-drift` (when % drift exceeds threshold per LP)
3. **Substrate update signal:** if the same LP claim is consistently NOT mentioned by reps, flag for narrative-compose re-anchor

## Threshold defaults (configurable)

- Per-LP claim-match: 60%+ of relevant calls mention the claim → aligned
- Per-LP overreach: any call where rep says X and LP doesn't claim X → flagged for review
- Per-rep alignment: 70%+ of calls aligned with assigned LPs → green; below → coaching candidate

## Build sequence (when scheduled)

1. **Phase 1 (manual):** read raw call intel JSON files; extract per-stage rep quotes; produce alignment report against LP claims as a one-shot manual run.
2. **Phase 2 (cron):** schedule as a LaunchAgent (e.g. `com.substrate.narrative-drift`) weekly.
3. **Phase 3 (Slack post):** wire Slack alert.
4. **Phase 4 (substrate hook):** when drift → narrative-compose re-anchor signal, automatically open a substrate-update goal.

## Dependencies

- Call-intel pipeline producing per-call JSON + stage scoring.
- LPs deployed under `clients/<client>/assets/draft/`.
- Battle cards with 4-rung ladders under `clients/<client>/substrate/`.
- Slack webhook for the drift channel.

## Why not a pre-ship gate

Sales talk-tracks lag LP claims by 4-12 weeks (rep training cadence). A pre-ship gate would block all LPs because no rep has yet been trained on a not-yet-shipped LP. The right design is to ship the LP, train sales, monitor drift, refresh.

This is **always-on monitoring** for Layer 8 reconciliation: does reality (rep behavior) match the substrate (LP claims + battle cards)?

## Related loops

- `routines/goal-routine.md` — goal open/resolve cadence
- `routines/signal-routine.md` — substrate signal collection
- `routines/content-routine.md` — content production cadence
- `routines/aeo-routine.md` — AI-engine optimization

`call-intel-narrative-drift` joins these as the **5th substrate loop** — post-ship reality check.

## Decay

This spec stays active as long as the client's LPs change quarterly or more often. If the LPs go stable (>6 months unchanged), the loop becomes lower-cadence (monthly) instead of weekly.
