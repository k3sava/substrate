---
title: customer conversation rhythm, 30 / 60 / 90 cadence
status: active
last_updated: 2026-05-08
cadence: continuous, with role-based weekly minimums and quarterly call-quota review
owner: PMM lead enforces; founder, head of GTM, PMs, pricing lead, sales reps, CS leads all participate
patterns_grounded: [frontline-as-pmm-substrate, rapport-surfaces-what-research-cannot, churn-prediction-vs-churn-diagnosis]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
composes: [frontline-contact, win-loss-interview, tactical-empathy-discovery, churn-diagnose, signal-routine, frontline-contact-routine]
---

# Customer conversation rhythm

The 30 / 60 / 90 cadence that turns customer contact from "we should do more of those" into a contract every role honors. Per-role weekly minimums (`frontline-contact-routine.md`), a 30-day signal-rotation, a 60-day rolled-up substrate-update, a 90-day calibration check on what the conversations actually moved.

## Why this exists

Frontline customer contact is the PMM substrate (per `knowledge/patterns/frontline-as-pmm-substrate.md`). Every credible operator from the codex corpus says the same thing in different words: positioning that drifts from buyer language is positioning that's about to fail; pricing decisions made without weekly customer calls are decisions waiting to be invalidated; content briefed from keyword tools and not from sales / success / support is content that misses the actual pain.

The existing `routines/frontline-contact-routine.md` enforces the per-role weekly minimum. This routine wraps that with a 30 / 60 / 90 rhythm: 30-day call-quota check across roles, 60-day substrate update from rolled-up VoC, 90-day calibration on whether the conversations changed any positioning, pricing, or product call. Without the rhythm, role-level contact happens but doesn't compound; with the rhythm, every quarter the substrate is sharper because the conversations actually flowed through the loop.

The routine also enforces `rapport-surfaces-what-research-cannot`. Voss-pattern interview craft is part of the cadence; not every customer call is a discovery interview, but every quarter has at least one structured tactical-empathy-discovery run per role. Rapport produces signal that keyword research never will.

## Stages

### Continuous, weekly per role (the floor)

**Cadence contract** (per `routines/frontline-contact-routine.md`):

| Role | Minimum weekly contact | Format |
|---|---|---|
| Founder | 3 customer conversations | live call or in-person |
| Head of GTM | 5 customer conversations | live call |
| PMM lead | 5 conversations + 1 win/loss | call or async transcript |
| PMs | 2 customer interviews | live call |
| Pricing lead | 3 pricing conversations | live call |
| Sales reps | All recorded; 5 reviewed | recorded calls |
| CS leads | 3 calls + 5 ticket reviews | call or async |

**Run** (continuous):

```bash
substrate frontline-contact --client <client> --book <count>
substrate frontline-contact --client <client> --log <call-id>
```

Each call lands in `clients/<client>/voc/inbox/` with the full transcript path, the participant role, and the source artifact. No transcript = no log accepted.

**Refusal triggers.** Role below minimum at end-of-week. Logged call without transcript path. Stale role (no logged call in 2× minimum-period), surfaced in `substrate-status`.

### Day 30, call-quota review and signal-rotation

**Run**:

```bash
substrate-status --client <client> --section frontline-cadence
substrate frontline-contact --client <client> --mode 30d-review
```

**What happens.** The 30-day review reads `clients/<client>/voc/cadence-ledger.md` and per-role logs from the prior 4 weeks. Three checks fire:

1. **Quota check.** Did each role hit its weekly minimum × 4? If a role missed two or more weeks, the routine flags the gap to the role owner and the PMM lead. Persistent gaps become an escalation: the role's downstream substrate (positioning if PMM lead, pricing if pricing lead, product narrative if PMs) is tagged stale.
2. **Signal-rotation balance.** Across the 30 days, did the calls cover all five signal types (VoC, buyer-behavior, competitive, market-context, sales-intel)? A month with 80 customer calls and zero competitive-signal calls is biased; the rotation check catches the bias.
3. **Vertical / cohort coverage.** Did the calls span the pinned ICP segments? A month where 90% of calls are mid-market and 10% enterprise on a substrate that pins both is a coverage gap; the next month's bookings should redress it.

**Output**: `clients/<client>/voc/30d-review-<YYYY-MM-DD>.md`. Updated booking suggestions for the next 30 days.

### Day 60, substrate update from rolled-up VoC

**Run**:

```bash
substrate signal-routine  # the continuous loop already processes; here we batch-resolve at 60 days
substrate refresh-knowledge --client <client> --layers voc,positioning,competitive,sales-pitch
```

**What happens.** The 60-day mark is the substrate-update checkpoint. The signal-analyst proposals that accumulated in `clients/<client>/signals/proposals/` get reviewed in batch (per `routines/signal-routine.md` Human approval gate). Approved patches update the relevant substrate layers. Rejected ones get logged with reason. Deferred ones either get corroborated or expire.

The refresh-knowledge skill audits the affected layers for freshness; layers patched in the prior 60 days reset their `last_updated`, layers that didn't get patches surface as candidates for next month's call-rotation focus.

**Output**: substrate-layer patches applied. `clients/<client>/voc/60d-rollup-<YYYY-MM-DD>.md` summarising the substrate updates.

**Refusal triggers.** Signal proposals older than 14 days unprocessed. Patches that contradict canonical positioning without corroboration from at least two independent signals (per `routines/signal-routine.md` corroboration requirement).

### Day 90, calibration check and quarterly tactical-empathy run

**Run**:

```bash
substrate win-loss-interview --client <client> --mode quarterly-batch
substrate tactical-empathy-discovery --client <client> --mode quarterly-pass
substrate score-goal --goal-id <prior-quarter-positioning-goal>  # if applicable
```

**What happens.** The 90-day check runs the structured discovery skills that don't fit the weekly cadence: a batch of 3-5 win/loss interviews against the past quarter's closed deals, and a Voss-pattern tactical-empathy discovery pass on a high-stakes account or cohort. Both produce structured artifacts (coded objections, decision drivers, alternatives considered, mirrors, labels, accusation audit results).

Then the loop closes. If a positioning, pricing, or messaging goal opened the prior quarter and depended on customer-language signal, the 90-day check is when it resolves. The Brier score lands on the operator's calibration history per `PRINCIPLES.md` rule 6.

**Output**: `clients/<client>/voc/quarterly-win-loss-Q<n>.md`, `clients/<client>/voc/quarterly-tactical-empathy-Q<n>.md`, resolved goals on `goals/ledger.md`.

**Refusal triggers.** Win-loss interviews skipped because "we've been busy"; the substrate gap compounds. Tactical-empathy pass attempted without preflight reading of `knowledge/patterns/rapport-surfaces-what-research-cannot.md`. Goals resolving without source-system citation.

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| Continuous | `frontline-contact` | `skills/frontline-contact/SKILL.md` |
| Day 30 | `frontline-contact` (30d-review mode) | `skills/frontline-contact/SKILL.md` |
| Day 60 | `signal-routine` (batch) | `routines/signal-routine.md` |
| Day 60 | `refresh-knowledge` | `skills/refresh-knowledge/SKILL.md` |
| Day 90 | `win-loss-interview` | `skills/win-loss-interview/SKILL.md` |
| Day 90 | `tactical-empathy-discovery` | `skills/tactical-empathy-discovery/SKILL.md` |
| Day 90 | `churn-diagnose` (when CS leads' calls surface a churn pattern) | `skills/churn-diagnose/SKILL.md` |
| Day 90 | `score-goal` (per resolved goal) | `skills/score-goal/SKILL.md` |

## Inputs required

- Active client substrate with `clients/<client>/voc/cadence-contract.md` (the role-by-role weekly minimums).
- A role registry naming the people in each role (the founder, head of GTM, PMM lead, etc.) so the cadence audit can attribute gaps.
- Customer-call recording infrastructure that produces transcripts (Gong / Chorus / equivalent for sales; PMs use any call platform with transcript export).
- A pinned ICP at `clients/<client>/icp/00-INDEX.md` so the 30d coverage check has a target distribution.

## Outputs produced

- Per-call logs in `clients/<client>/voc/inbox/` (continuous).
- `clients/<client>/voc/cadence-ledger.md` (append-only call log).
- `clients/<client>/voc/30d-review-<YYYY-MM-DD>.md` (every 30 days).
- `clients/<client>/voc/60d-rollup-<YYYY-MM-DD>.md` (every 60 days).
- `clients/<client>/voc/quarterly-win-loss-Q<n>.md`, `quarterly-tactical-empathy-Q<n>.md` (every 90 days).
- Substrate-layer patches accumulating through the signal-routine batch resolutions at day 60.
- Resolved goals on `goals/ledger.md` for any prior-quarter goal that depended on customer-language signal.

## Failure modes

- **A role hits the floor for one week, drops below for the next.** The most common failure mode. Surfaces in the 30-day review. The fix is to make the role-owner the call-booker (per the founder rule: "if you can't do three a week, fly to a customer this week"), not to drop the floor.
- **Calls happen but transcripts don't get logged.** Transcripts not logged = calls didn't happen, for substrate purposes. The skill refuses logs without transcript paths; the cadence-ledger surfaces the gap.
- **The 30-day rotation is biased.** Eight calls all on the same vertical, all with mid-market accounts. The rotation check catches this; next month's bookings should redress, not compound.
- **The 60-day substrate update never lands.** Signal proposals build up in the inbox, the operator stays "busy with execution," the substrate goes stale. By day 90 the team is making positioning calls on data that's 3 months old. Block 90 minutes at day 60. It's the most leveraged hour in the cycle.
- **Win-loss interviews skipped at day 90.** The most common skip because nobody owns the calendar block. PMM lead owns it; the skip is a calibration signal in itself (which goal opened on customer-language and didn't resolve because we never collected the language).
- **Save-vs-let-go applied uniformly across CS calls.** Per the contradiction, save-everyone wastes CS hours on misfit accounts that should let-go. The CS lead's 90-day calls should be conditioned: ICP-fit accounts get the save program; non-fit accounts get the let-go-with-grace path. Mixed application defeats the contradiction's value.

## Calibration hooks

- Per-role cadence accuracy: did the role hit its weekly minimum × 4 / 8 / 12 weeks? Compounds into a calibration-tier per role.
- Per-90-day, the resolved goals depending on customer-language signal score against the operator's positioning, pricing, or messaging taste types.
- Sustained role-level cadence accuracy + sustained goal accuracy together build the case for `PRINCIPLES.md` rule 6 authority: the role-owner with 3 quarters of full cadence and resolved goals on customer-language has earned decision authority on the next quarter's positioning calls.
- The pmm-coaching skill reads cadence + calibration together at quarterly review; a role that's calibrated but not contacting customers regularly is a structural risk; a role that's contacting customers regularly but isn't calibrated is a substrate gap (the calls aren't producing usable signal).

## Composes with

- `routines/frontline-contact-routine.md`, the per-week role-level enforcement.
- `routines/signal-routine.md`, the continuous signal processing loop the 60-day check batches.
- `routines/quarterly-pmm-cycle.md`, the wrapping cadence the 90-day check resolves into.
- `routines/full-funnel-audit.md`, where churn-diagnose pulls from the CS lead's logged calls.
- `routines/expansion-watcher.md`, where CS lead's calls surface expansion-trigger candidates that won't show in events alone.

## See also

- `skills/frontline-contact/SKILL.md`, the per-call execution skill.
- `skills/win-loss-interview/SKILL.md`, the structured outcome interview.
- `skills/tactical-empathy-discovery/SKILL.md`, the Voss-pattern interview craft.
- `knowledge/patterns/frontline-as-pmm-substrate.md`, the load-bearing pattern.
- `knowledge/patterns/rapport-surfaces-what-research-cannot.md`, the Voss-pattern justification.
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`, the CS conditioning contradiction.
- `PRINCIPLES.md` rule 1 (context-first), rule 3 (buyer is the audience), rule 6 (authority follows accuracy).
