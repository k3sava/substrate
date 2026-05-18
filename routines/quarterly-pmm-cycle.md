---
title: quarterly PMM cycle
status: active
last_updated: 2026-05-08
cadence: quarterly, with mid-quarter checkpoint at week 6
owner: PMM lead, with sales / CS / RevOps as gate participants
patterns_grounded: [narrative-as-strategy, frontline-as-pmm-substrate, measurement-correlated-short-signals, distribution-as-moat, decision-quality-through-process-not-willpower]
contradictions_aware: [build-quietly-vs-distribution-first, short-feedback-vs-long-term-holdouts]
composes: [signal-routine, goal-routine, competitive-scout, narrative-drift-routine, score-goal, refresh-knowledge, mental-models, pmm-coaching]
---

# Quarterly PMM cycle

The PMM function as a closed quarterly loop. Open goals at week 1. Run signal collection and competitive scout continuously. Mid-quarter check at week 6. Resolve and update calibration at week 13. The substrate gets sharper every quarter; the operator's calibration tracks alongside.

## Why this exists

Most PMM teams run quarterly goals as a planning ritual: a doc gets written, OKRs get assigned, and the team scatters into execution. By the time the quarter ends, half the goals were never measurable in the first place and the team's accuracy is a story, not a number.

Substrate's quarterly cycle treats the quarter as an inference loop. Goals open with measurement contracts. Signals flow continuously into the substrate (not just at planning offsites). Competitive intel updates as competitors actually move, not when someone remembers to look. Mid-quarter the cycle checks for keep / kill / pivot; at quarter-end the calibration ledger updates per resolved goal. The PMM function compounds quarter over quarter because the loop closes every time.

The cycle also enforces `decision-quality-through-process-not-willpower`. Pre-mortem at goal open. Independent ratings before the team debrief. Calibration history readable before authority on the next quarter's calls. Process is the lever, not heroic effort.

## Stages

### Week 1, refresh and open

**Run** (in order):

```bash
substrate refresh-knowledge --client <client> --layers all --since-last-quarter
substrate competitive-scout --client <client>
substrate icp-cut --client <client> --mode refresh
substrate open-goal --client <client> --goal-id <slug-1> ...   # repeat for each Q-level goal
```

**What happens.** Refresh-knowledge audits every substrate layer that's past its freshness window. Competitive-scout pulls the quarter's deltas (new entrants, repositioning, pricing changes, narrative shifts). ICP-cut refreshes if signals warrant. Then the team opens 3-5 quarterly goals on `goals/ledger.md`, each with a measurement contract, baseline, target, window, and source-system.

The PMM lead writes a pre-mortem for each goal: "if this fails at week 13, the most likely cause will be...". Pre-mortems are stored alongside the goal and read at the mid-quarter check.

**Artifacts**: refreshed substrate layers, a `clients/<client>/quarterly/Q<n>-plan.md` with the goal list and pre-mortems, 3-5 new rows on `goals/ledger.md`.

**Refusal triggers.** Goals without measurement contracts. Layers past their freshness window not refreshed. Per `PRINCIPLES.md` rule 1 the cycle does not advance with stale context.

### Weeks 2 to 5, signal collection and execution

**Run continuously**:

- `routines/signal-routine.md` (continuous) — VoC, buyer behavior, competitive, market context, sales intel flow into `signals/inbox/`.
- `routines/frontline-contact-routine.md` (continuous) — per-role written cadence enforces fresh customer contact.
- `routines/content-routine.md` (on-demand per active goal) — assets ship through `pre-publish-check`.
- `routines/aeo-publish-cycle.md` (monthly) — if any quarterly goal touches AEO.

**What happens.** The first four weeks are execution-dense. The PMM lead reviews signal inbox proposals every Monday morning; approved patches update substrate layers. Competitive scout runs again at week 4 to catch mid-quarter competitor moves. Active goals generate assets per `goal-routine.md` Stages 4-7.

**Failure mode to watch.** "Signals build up but never patch the substrate." If the inbox has more than 14 days of unprocessed proposals, the loop is broken. Drop one of the active goals and spend a session draining the inbox; positioning drift surfaces here first.

### Week 6, mid-quarter checkpoint

**Run**:

```bash
substrate mental-models --client <client> --goals <goal-ids> --mode pre-decision
substrate competitive-scout --client <client>
substrate narrative-drift-check  # routines/narrative-drift-routine.md trigger
```

**What happens.** The PMM lead reviews each open goal against three questions:

1. **Is the kill criterion firing?** If yes, kill, don't pivot. Per `PRINCIPLES.md` rule 2.
2. **Has new context invalidated the belief?** If yes, resolve as MISS with note, open a new goal. Not pivot.
3. **Has time elapsed without movement?** If yes, resolve with NULL classification (no data is data) at week 13.

The mental-models skill reads pre-mortems from week 1 and runs the pre-decision audit. Independent ratings (per `decision-quality-through-process-not-willpower`) come from the PMM lead, head of GTM, and a CS or sales rep before the team debrief. The goal lives, dies, or shifts to NULL based on the structured read.

**Artifact**: `clients/<client>/quarterly/Q<n>-mid-quarter-checkpoint.md` with per-goal verdicts.

**Refusal triggers.** Mid-quarter check skipped (cycle owner records the skip and counts it against the next quarter's calibration). Pivots declared without resolving the prior goal first (open-loop).

### Weeks 7 to 12, sharpened execution

**Run continuously** (same as weeks 2-5, but with revised goal set from the mid-quarter checkpoint).

The substrate at this point is sharper than it was at week 1: at least four cycles of signal-routine processing, one full competitive-scout refresh, the narrative-drift check, and active VoC patching. Asset quality climbs because the input quality climbed.

### Week 13, resolve and calibrate

**Run**:

```bash
substrate score-goal --goal-id <slug-1>   # repeat per goal
substrate refresh-leaderboard
substrate pmm-coaching --client <client> --quarterly --mode debrief
```

**What happens.** Each open goal resolves: YES, NO, or AMBIGUOUS. Brier score computed per the predicted_p in the goal frontmatter. Calibration ledger updates. The taste-leaderboard recomputes (per-operator, per-taste-type accuracy).

The pmm-coaching skill runs a quarterly debrief: which taste types did the operator improve on? Which were honest losses? What's the substrate update each resolution implies?

**Artifact**: resolved goals on `goals/ledger.md`, updated `goals/taste-leaderboard.md`, `clients/<client>/quarterly/Q<n>-debrief.md` with per-goal substrate-update proposals.

**Refusal triggers.** Goals resolving without source-system citation. Brier scores skipped because results "weren't in yet" (extension requires a new resolution date and a documented reason). Substrate updates not proposed for resolved goals (closes-the-loop rule).

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| Week 1 | `refresh-knowledge` | `skills/refresh-knowledge/SKILL.md` |
| Week 1 | `competitive-scout` | `skills/competitive-scout/SKILL.md` |
| Week 1 | `icp-cut` (refresh mode) | `skills/icp-cut/SKILL.md` |
| Week 1 | `open-goal` (×3-5) | `skills/open-goal/SKILL.md` |
| Continuous | `frontline-contact` | `skills/frontline-contact/SKILL.md` |
| Continuous | `voice-enforce` (every shipped asset) | `skills/voice-enforce/SKILL.md` |
| Continuous | `claim-verify` (every shipped asset) | `skills/claim-verify/SKILL.md` |
| Week 6 | `mental-models` | `skills/mental-models/SKILL.md` |
| Week 6 | `competitive-scout` | `skills/competitive-scout/SKILL.md` |
| Week 13 | `score-goal` (per goal) | `skills/score-goal/SKILL.md` |
| Week 13 | `pmm-coaching` (debrief mode) | `skills/pmm-coaching/SKILL.md` |

The cycle wraps four routines as sub-loops: `signal-routine`, `frontline-contact-routine`, `narrative-drift-routine`, `aeo-publish-cycle` (when relevant).

## Inputs required

- An active client substrate (run `routines/new-client-onboarding-week-1.md` first if this is engagement quarter 1).
- Last quarter's `goals/ledger.md` rows resolved (open-loop quarters compound; close before opening new).
- A current `clients/<client>/competitors.yaml` and `verticals.yaml` (run `substrate-bootstrap-prospect` if missing).
- The PMM lead's calibration history readable from `goals/taste-leaderboard.md` (the leaderboard exists from quarter 2 onward; quarter 1 opens with a "no history yet" caveat).

## Outputs produced

- `clients/<client>/quarterly/Q<n>-plan.md` (week 1)
- `clients/<client>/quarterly/Q<n>-mid-quarter-checkpoint.md` (week 6)
- `clients/<client>/quarterly/Q<n>-debrief.md` (week 13)
- 3-5 resolved rows on `goals/ledger.md`
- Updated `goals/taste-leaderboard.md`
- Substrate-layer patches accumulated through `signal-routine`
- Brier scores for the operator's calibration history per taste type

## Failure modes

- **Goals open without measurement contracts** because the team is in planning-doc mode rather than substrate mode. Open-goal refuses; fix the contract before advancing.
- **Mid-quarter checkpoint skipped.** The week-6 read is the only structural intervention against sunk-cost-fallacy on a goal that's already failed but the team isn't ready to admit it. Skipping costs calibration accuracy and team morale (failed goals quietly extending until quarter-end is the worst signal).
- **Pivots declared without resolving the original goal.** This is the open-loop pattern Rule 2 forbids. Resolve as MISS, document the reason, open a new goal. Don't pivot.
- **Calibration debrief skipped at week 13** because the team is already planning Q+1. The substrate-update proposal step is where the loop closes; without it, the next quarter opens on context that isn't sharper than this quarter's was.
- **Quarter goals all hit YES.** This sounds like a win but is usually a sign the targets were under-set. The calibration check at week 13 should flag this; recurring quarters of 100% hit-rate on a taste type means the operator is sandbagging predictions, not nailing them. Tighten the targets next quarter.

## Calibration hooks

- Per-goal Brier scores update `goals/taste-leaderboard.md` at week 13.
- Per-(operator, taste-type) accuracy compounds quarter over quarter.
- Sustained accuracy (3+ quarters with positive Brier-relative-to-baseline) earns the operator decision authority on that taste type per `PRINCIPLES.md` rule 6.
- Pre-mortem reads at mid-quarter measure decision-quality on goal selection (did we pick the right goals?), not just goal execution.
- The pmm-coaching skill reads the operator's quarterly trend at debrief; flat or declining accuracy on a taste type triggers a skill-redesign conversation, not a personal-performance conversation.

## Composes with

- `routines/signal-routine.md`, the continuous substrate-feed loop.
- `routines/frontline-contact-routine.md`, per-role weekly customer contact.
- `routines/competitor-watch-cycle.md`, the weekly competitive surveillance loop.
- `routines/narrative-drift-routine.md`, the post-ship reality check.
- `routines/aeo-publish-cycle.md`, when AEO is a quarterly goal.
- `routines/launch-flow.md`, when a launch lands inside the quarter.
- `routines/full-funnel-audit.md`, run at the start of any quarter where multi-channel performance is in scope.

## See also

- `skills/open-goal/SKILL.md`, the goal-open contract.
- `skills/score-goal/SKILL.md`, the resolve-and-Brier-score contract.
- `skills/mental-models/SKILL.md`, the pre-decision audit framework.
- `routines/goal-routine.md`, the per-goal Stages 1-9 spec the cycle wraps around.
- `PRINCIPLES.md` rule 2 (falsifiability), rule 6 (authority follows accuracy), rule 8 (revenue per operator).
