---
title: competitor watch cycle, weekly surveillance
status: active
last_updated: 2026-05-08
cadence: weekly, with quarterly re-baseline
owner: PMM lead, with sales enablement and competitive-intel as named participants
patterns_grounded: [status-quo-is-the-competitor, narrative-as-strategy, status-quo-is-the-real-objection-outbound, differentiation-vs-sameness, monopoly-economics-differentiation-beats-competition]
contradictions_aware: [no-decision-vs-named-competitor]
composes: [competitive-scout, battle-card-driver, signal-routine, narrative-drift-routine, status-quo-frame, claim-verify]
---

# Competitor watch cycle

The weekly cadence that turns competitive intel from "we should keep an eye on X" into a substrate-grounded surveillance loop. Pull the competitor signal feed Monday. Refresh battle cards mid-week. Run narrative-drift Friday. Quarterly re-baseline against the full named-competitor + status-quo set.

## Why this exists

Competitive intelligence rots faster than any other substrate layer (per `knowledge/patterns/status-quo-is-the-competitor.md` and `routines/signal-routine.md`'s 14-day decay window). Competitor pricing changes get noticed weeks late. Competitor narrative shifts surface in shipped sales decks before they surface in PMM substrate. Battle cards rot in folders nobody reads, and AEs end up improvising on calls.

This routine wires the surveillance into a weekly rhythm. The pattern is unambiguous: competitive intel must update at the rate competitors actually move, which is weeks, not quarters. Weekly is the floor; the quarterly re-baseline is when the full named-competitor + status-quo set gets a comprehensive read.

The routine also resolves the load-bearing contradiction: `no-decision-vs-named-competitor` (per `knowledge/contradictions/no-decision-vs-named-competitor.md`). Most deals don't lose to a named competitor; they lose to no-decision, the spreadsheet, or the internal build. The watch cycle treats both as competitors. The status-quo-frame skill produces the "we win against doing-nothing" narrative; the battle-card-driver produces the "we win against named-competitor X" narrative; the routine cycles both.

## Stages

### Monday, competitive scout pull

**Run**:

```bash
substrate competitive-scout --client <client>
```

**What happens.** Competitive-scout reads `clients/<client>/competitors.yaml` (the per-client named-competitor list with tiers) and pulls signals across the configured surfaces: competitor LP changes, pricing-page diffs, new ad creatives detected on Meta / LinkedIn / Google, new content (blog posts, ebooks, webinars) landing in the past week, exec hire announcements, funding events, product launches.

The pull writes per-competitor diffs to `clients/<client>/competitive/scout-<YYYY-MM-DD>/<competitor-slug>.md`. New signals route through `routines/signal-routine.md` as proposals against the competitive substrate layer.

**Output**: per-competitor weekly diff. New entries on the signal proposal queue.

**Refusal triggers.** `competitors.yaml` missing or empty (run `substrate-bootstrap-prospect` first). Tracked competitor with no sources configured (no LP URL, no public pricing page, no public RSS / blog).

### Tuesday to Wednesday, battle card freshness pass

**Run** (per active deal-stage competitor):

```bash
substrate battle-card-driver --client <client> --competitor <slug> --buyer-state <state> --deal-stage <stage> --mode audit
```

**What happens.** The battle-card-driver runs in audit mode against the existing battle cards. It checks:

1. **Recency.** Battle cards older than 30 days get flagged for refresh (the freshness window for pricing and feature claims).
2. **Drift versus the Monday pull.** If the Monday scout surfaced a competitor pricing change, narrative shift, or product launch, the battle card flags as out-of-date until updated.
3. **Honest losses.** Per `skills/battle-card-driver/SKILL.md`, the honest-losses section is mandatory. Cards without it get flagged.
4. **Claim integrity.** Every load-bearing claim about the competitor goes through `claim-verify` (per `make-implicit-explicit`). Claims without substrate paths get flagged for tightening.

For each flagged card, the operator either updates the card from Monday's scout signals, or files a competitive-scout deepening pass for next week.

**Output**: refreshed battle cards under `clients/<client>/competitive/battle-cards/`. Audit report at `clients/<client>/competitive/battle-card-audit-<YYYY-MM-DD>.md`.

**Refusal triggers.** Battle card without `competitive/battle-cards/<competitor>.md` exists (the deal needs a card; run competitive-scout deepening first). Card claims that fail claim-verify (substrate-gap; fix the underlying competitive layer).

### Thursday, status-quo refresh

**Run**:

```bash
substrate status-quo-frame --client <client> --mode refresh
```

**What happens.** The status-quo frame is the other half of the contradiction. Per the codex pattern, no-decision is the dominant alternative in most B2B deals; the status-quo frame names the "we win against doing-nothing" narrative.

The Thursday refresh checks the status-quo competitor map: which alternative the client's recent reviews / sales calls / lost deals mention most. If the dominant alternative shifted (e.g., last quarter the no-decision pattern was "we'll build it internally"; this quarter it's "we'll just keep the spreadsheet"), the status-quo frame narrative updates. The PMM lead reads the refreshed map; downstream skills (positioning-forge, narrative-strategy, narrative-compose, outbound-sequence-design) pick up the new framing on the next run.

**Output**: refreshed `clients/<client>/competitive/status-quo.md`. Audit log at `clients/<client>/competitive/status-quo-audit-<YYYY-MM-DD>.md`.

**Refusal triggers.** Status-quo refresh without recent VoC or sales-intel signals (per `routines/customer-conversation-rhythm.md`, the conversations have to be flowing for the status-quo signal to be current). Fix the conversation rhythm first.

### Friday, narrative-drift check

**Run**:

```bash
# routines/narrative-drift-routine.md trigger
```

**What happens.** Per `routines/narrative-drift-routine.md`, the narrative-drift loop reads call-intel cohort data and compares rep talk-tracks to the canonical LP / battle-card claim set. If reps are saying things the substrate doesn't claim, or skipping things the substrate does claim, drift is logged.

In the competitor watch context, narrative-drift surfaces two specific failures:
1. Reps citing competitor weaknesses the battle card doesn't validate.
2. Reps not citing battle-card framing on competitive deals.

Both are signals: the first is overreach (sales saying things PMM hasn't backed), the second is enablement gap (battle card not landing). Both feed back into next Monday's competitive-scout cycle.

**Output**: narrative-drift digest. Weekly competitive-watch summary at `clients/<client>/competitive/weekly-summary-<YYYY-WW>.md`.

**Refusal triggers.** Narrative-drift loop not running (no call-intel pipeline configured). Operator decides whether the drift signal is worth wiring; some clients run the watch cycle without the Friday step.

### Quarterly, re-baseline

**Run** (in week 1 of the quarter, alongside `routines/quarterly-pmm-cycle.md`):

```bash
substrate competitive-scout --client <client> --mode quarterly-deep
substrate positioning-forge --client <client> --mode competitive-refresh
```

**What happens.** The quarterly re-baseline runs competitive-scout in deep mode (full LP teardown per competitor, full pricing matrix audit, full ad-library snapshot, full content-archive read). Positioning-forge re-runs the differentiation-vs-sameness check against the refreshed competitor set; if a competitor moved into the client's positioning territory, the gap surfaces.

The re-baseline also catches the "long-tail" competitor: a vendor that didn't appear in the named-competitor list last quarter but is now showing up in lost-deal reviews. New entrants get added to `competitors.yaml`; vendors that haven't surfaced in 4 quarters get archived (per `competitive-scout` decay rules).

**Output**: comprehensive quarterly competitive teardown. Updated `clients/<client>/competitors.yaml`. Refreshed `clients/<client>/positioning/positioning-canonical-statement.md` if the competitive shift warrants.

**Refusal triggers.** Re-baseline attempted without VoC + sales-intel signals from the prior quarter (the long-tail surfacing depends on conversations, not just public-surface scrapes). Fix the conversation rhythm first.

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| Monday | `competitive-scout` | `skills/competitive-scout/SKILL.md` |
| Mon-Wed | `signal-routine` (processes new signals) | `routines/signal-routine.md` |
| Tue-Wed | `battle-card-driver` (audit mode) | `skills/battle-card-driver/SKILL.md` |
| Tue-Wed | `claim-verify` (composed inside battle-card-driver) | `skills/claim-verify/SKILL.md` |
| Thursday | `status-quo-frame` (refresh mode) | `skills/status-quo-frame/SKILL.md` |
| Friday | `narrative-drift-routine` | `routines/narrative-drift-routine.md` |
| Quarterly | `competitive-scout` (quarterly-deep mode) | `skills/competitive-scout/SKILL.md` |
| Quarterly | `positioning-forge` (competitive-refresh mode) | `skills/positioning-forge/SKILL.md` |

## Inputs required

- Active client substrate with `clients/<client>/competitors.yaml` listing named competitors with tiers and surface URLs.
- A working `routines/customer-conversation-rhythm.md` so VoC and sales-intel signals flow into the status-quo refresh and the quarterly re-baseline.
- Per-competitor battle cards at `clients/<client>/competitive/battle-cards/<slug>.md`. New competitors that appear in scout signals without a battle card surface as a deepening request, not a card-driver refusal.
- A configured call-intel pipeline (Gong / Chorus / equivalent) for the Friday narrative-drift step. Optional; the rest of the cycle runs without it.
- A pinned positioning canonical statement at `clients/<client>/positioning/positioning-canonical-statement.md`.

## Outputs produced

- `clients/<client>/competitive/scout-<YYYY-MM-DD>/<competitor-slug>.md` per Monday pull.
- Refreshed battle cards in `clients/<client>/competitive/battle-cards/`.
- `clients/<client>/competitive/battle-card-audit-<YYYY-MM-DD>.md` per Tue/Wed audit.
- `clients/<client>/competitive/status-quo.md` (Thursday refresh).
- `clients/<client>/competitive/weekly-summary-<YYYY-WW>.md` (Friday).
- Quarterly competitive teardown at `clients/<client>/competitive/quarterly-Q<n>-baseline.md`.
- Updated `clients/<client>/competitors.yaml` and (when warranted) refreshed positioning statement.
- Substrate-layer patches accumulating through `signal-routine` against the competitive layer.

## Failure modes

- **Monday scout pull skipped because "the week is busy."** The watch cycle's Monday slot is non-optional; the cost of a single skipped week compounds (a competitor pricing change missed for 7 days becomes a competitor pricing change missed for 14, then 30). Block 30 minutes Monday morning. The cost of catching one shift early covers 6 months of cycle time.
- **Battle cards updated reactively, not proactively.** Cards refreshed only when a deal blows up means PMM is always behind sales. The Tue-Wed cadence is preemptive; cards refresh before the deal needs them.
- **Status-quo frame ignored because "we don't lose to no-decision."** Most teams do; they just don't track it. If lost-deal reviews show >40% no-decision, the status-quo frame is the highest-leverage move, not battle cards. Run the Thursday refresh and the data will show.
- **Quarterly re-baseline skipped.** Most common failure. Quarterly cadence falls off because there's always something more urgent. Without the re-baseline, the competitive layer stays calibrated to last quarter's competitors; new entrants (the highest-risk class) stay invisible. Block half a day in week 1 of each quarter; treat it as the most leveraged half-day in the cycle.
- **Battle cards include claims without substrate paths.** Per `make-implicit-explicit`, every load-bearing claim about a competitor must trace. The claim-verify gate inside battle-card-driver catches this; ignoring the gate produces sales-enablement copy that's wrong on calls and erodes AE confidence in the next card.
- **Watch cycle runs but signal-routine doesn't process.** Competitive scout pulls signals but the proposals never resolve into substrate patches. Same as the customer-conversation-rhythm 60-day failure: signals build up and never compound. The Monday cadence includes a 15-minute proposal-drain.

## Calibration hooks

- Per-competitor battle-card accuracy: did the deal that cited the card win or lose? Logged per resolved deal per competitor; the AE / sales enablement lead's calibration on competitor framing accumulates over quarters.
- Status-quo frame accuracy: did the no-decision deals close after the status-quo narrative shipped? The lost-deal review at quarter-end scores this against the predicted close rate.
- Per `PRINCIPLES.md` rule 6, sustained accuracy on competitor-framing earns the operator decision authority on next-quarter battle-card prioritisation.
- Quarterly re-baseline produces a substrate-update proposal per competitor; the proposals' acceptance rate (substrate-curator approves vs rejects) is itself a calibration signal on the operator's competitive-read accuracy.

## Composes with

- `routines/quarterly-pmm-cycle.md`, the wrapping cycle the quarterly re-baseline lives inside.
- `routines/customer-conversation-rhythm.md`, the conversation cadence that produces VoC + sales-intel signals.
- `routines/signal-routine.md`, the processing loop the Monday scout pulls feed into.
- `routines/narrative-drift-routine.md`, the Friday post-ship drift check.
- `routines/launch-flow.md`, when a launch is competitive and the watch cycle is the prerequisite.
- `routines/customer-conversation-rhythm.md` and `routines/expansion-watcher.md`, the lost-deal and account-disengagement signals that feed status-quo refresh.

## See also

- `skills/competitive-scout/SKILL.md`, the load-bearing skill.
- `skills/battle-card-driver/SKILL.md`, the per-deal AE workflow.
- `skills/status-quo-frame/SKILL.md`, the no-decision framing skill.
- `skills/positioning-forge/SKILL.md`, the quarterly-refresh skill.
- `knowledge/patterns/status-quo-is-the-competitor.md`, the load-bearing pattern.
- `knowledge/patterns/status-quo-is-the-real-objection-outbound.md`, the outbound-side variant.
- `knowledge/patterns/differentiation-vs-sameness.md`, the quarterly re-baseline read.
- `knowledge/contradictions/no-decision-vs-named-competitor.md`, the load-bearing contradiction.
- `PRINCIPLES.md` rule 1 (context-first), rule 5 (one canonical narrative), rule 6 (authority follows accuracy).
