---
title: new client onboarding, week 1
status: active
last_updated: 2026-05-08
cadence: one-time, day 1 to day 5 of a paid engagement
owner: lead consultant or in-house PMM running internal POC
patterns_grounded: [diagnose-before-execute, frontline-as-pmm-substrate, narrative-as-strategy, status-quo-is-the-competitor, eval-as-data-analysis]
contradictions_aware: [no-decision-vs-named-competitor, build-quietly-vs-distribution-first]
composes: [consulting-poc, frontline-contact, icp-cut, positioning-forge, status-quo-frame, narrative-strategy, messaging-matrix, lp-ship, narrative-compose, eval-rubric, open-goal]
---

# New client onboarding, week 1

The five-day sequence that turns a freshly bootstrapped `clients/<prospect>/` into a working substrate. Every day ships a load-bearing artifact; every artifact cites context that didn't exist on day zero. The week ends with a 90-day roadmap whose first three goals are already calibrated.

## Why this exists

Most consulting engagements lose week 1 to context-gathering. The team reads decks, runs a kickoff, schedules calls for week 2, and the first tangible artifact lands in week 3. By then the client is already calibrating "is this working?" on momentum, not on output.

Substrate inverts that. The pre-engagement Phase 0 audit (per `skills/consulting-poc/SKILL.md`) means day 1 starts with a public-surface diagnosis already on the table. Week 1 spends every day working through the substrate stack in canonical order: context → positioning → narrative → asset → measurement contract. By Friday the client has the receipts.

The week also operationalises the `diagnose-before-execute` pattern at the engagement level. Day 1 is diagnosis. Days 2-3 are framing. Day 4 is the first artifact. Day 5 is the calibration that says "here's what we expect from these claims, and here's how we'll know if we were wrong." That sequence is the offer; the ritual is what makes substrate consulting different in kind from "we have a system, let's try it."

## Stages

### Day 1, bootstrap and ICP cut

**Run** (in order):

```bash
substrate-bootstrap-prospect <client>
$EDITOR clients/<client>/BRIEF.md
$EDITOR clients/<client>/competitors.yaml
$EDITOR clients/<client>/verticals.yaml
substrate icp-cut --client <client> --mode initial
substrate frontline-contact --client <client> --book 3
```

**What happens.** Bootstrap drops the 10-layer scaffold and pre-seeds `competitors.yaml` + `verticals.yaml` from templates. The operator fills `BRIEF.md` from the Phase 0 audit. `icp-cut` reads public-surface signals (LP, reviews, careers page, support docs) and produces a first-cut ICP at `clients/<client>/icp/00-INDEX.md`. `frontline-contact` books three customer or prospect calls for day 3-4.

**Artifact** committed to git: `clients/<client>/BRIEF.md`, `clients/<client>/icp/00-INDEX.md`, `clients/<client>/diagnostics/phase-0-audit.md` (carried in from the free-call audit), `clients/<client>/voc/cadence-ledger.md` with three booked calls.

**Refusal triggers.** Missing positioning template files, missing competitors / verticals YAMLs, no booked calls. Fix the substrate gap (not the deadline) before advancing.

### Day 2, positioning and the status-quo frame

**Run**:

```bash
substrate positioning-forge --client <client> --diagnose
substrate status-quo-frame --client <client>
substrate dunford-value-frame --client <client>
```

**What happens.** Positioning-forge runs Dunford's 5-step diagnostic against public-surface evidence and the day-1 ICP. Status-quo-frame names the no-decision alternative (usually a spreadsheet, an internal build, or "we'll do nothing"). Dunford-value-frame layers the value pillars on top. The named-vs-status-quo contradiction is resolved per `knowledge/contradictions/no-decision-vs-named-competitor.md` and the picked position is logged in the artifact frontmatter.

**Artifact**: `clients/<client>/positioning/01-canonical.md`, `clients/<client>/positioning/positioning-canonical-statement.md`, `clients/<client>/competitive/status-quo.md`. Each cites Phase 0 audit findings or day-1 ICP cells.

**Refusal triggers.** Status-quo not named. ICP not pinned. Positioning that competes against features instead of alternatives. Fix and re-run.

### Day 3, narrative spine and messaging matrix

**Run**:

```bash
substrate narrative-strategy --client <client> --mode draft
substrate messaging-matrix --client <client> --mode build --audience <pinned-icp>
```

**What happens.** Narrative-strategy produces the Raskin-frame spine: name the change, the stakes, the new game, the proof. Messaging-matrix builds the persona × pain × value × proof × call grid, reading from positioning + ICP + day-3 customer calls (which by now are logged in `voc/inbox/`). The matrix is the canonical message; every downstream channel reads from it.

**Artifact**: `clients/<client>/narrative/strategy.md`, `clients/<client>/messaging/matrix.md`. Matrix cells cite at least one VoC quote per row.

**Refusal triggers.** Less than two customer calls logged. Messaging cells with no VoC citation for "pain." Value pillars exceeding three (per `specificity-becomes-profitable`). Fix the substrate (more calls, sharper pillars) and re-run.

### Day 4, the first load-bearing artifact

**Run** (one of, depending on engagement priority):

```bash
# Path A: landing-page revision
substrate lp-ship --client <client> --asset clients/<client>/assets/lp-hero-v1.md

# Path B: narrative artifact (homepage rewrite, email sequence anchor, sales enablement one-pager)
substrate narrative-compose --client <client> --spec messaging/matrix.md --channel <channel>

# Path C: structured customer interview, when the engagement is discovery-led
substrate win-loss-interview --client <client> --interview <subject> --mode prep
```

**What happens.** Day 4 ships one finished artifact, end-to-end gated. The composite gate (citation, voice, claim-verify, audience-test, gates 7 + 8 for pattern + contradiction-position) runs against the deliverable. The artifact is the visible win the client takes back to their stakeholders.

**Artifact**: a customer-facing draft committed under `clients/<client>/assets/`. The draft carries `produced_by: <skill>` so gates 7 and 8 fire on `pre-publish-check`. Both pass. The artifact is preflight-clean and ready to ship.

**Refusal triggers.** Pre-publish-check fails. Voice gate flags. Claim-verify fails on a load-bearing claim. The right move is to fix the underlying substrate (positioning, VoC, claim source), not to override the gate.

### Day 5, diagnostic report, 90-day roadmap, and three calibrated goals

**Run**:

```bash
substrate eval-rubric --client <client> --asset clients/<client>/assets/<day-4-artifact> --judge binary
substrate open-goal --client <client> --goal-id <slug-1> --measurement-contract <path>
substrate open-goal --client <client> --goal-id <slug-2> --measurement-contract <path>
substrate open-goal --client <client> --goal-id <slug-3> --measurement-contract <path>
```

**What happens.** Eval-rubric closes the loop on day 4's artifact: a binary judge with explicit pass/fail criteria scored against a stand-in audience panel. The three goals are the prioritised next moves the 90-day roadmap will execute: one positioning bet, one narrative bet, one channel or asset bet. Each opens with a measurement contract: baseline, target, window, source-system. Each carries a calibrated probability the operator commits to in writing.

**Artifact**: `clients/<client>/diagnostics/phase-1-report.md` (the week's diagnostic), `clients/<client>/roadmap-90d.md` (prioritized substrate-skill plan), `clients/<client>/calibration-baseline.md` (Brier-scorable predictions on the three goals). Three rows on `goals/ledger.md` open and dated.

**Refusal triggers.** Roadmap without measurement contracts. Goals without source-system citations. Predictions without confidence numbers. Anything that can't be falsified at resolution doesn't ship in the report.

## Skills it composes

| Day | Skill | Path |
|---|---|---|
| 1 | `icp-cut` | `skills/icp-cut/SKILL.md` |
| 1 | `frontline-contact` | `skills/frontline-contact/SKILL.md` |
| 1 | `context-curate` | `skills/context-curate/SKILL.md` |
| 2 | `positioning-forge` | `skills/positioning-forge/SKILL.md` |
| 2 | `status-quo-frame` | `skills/status-quo-frame/SKILL.md` |
| 2 | `dunford-value-frame` | `skills/dunford-value-frame/SKILL.md` |
| 3 | `narrative-strategy` | `skills/narrative-strategy/SKILL.md` |
| 3 | `messaging-matrix` | `skills/messaging-matrix/SKILL.md` |
| 4 | `lp-ship` or `narrative-compose` or `win-loss-interview` | per engagement |
| 4 | `pre-publish-check` (composite gate, runs on every artifact) | `skills/pre-publish-check/SKILL.md` |
| 5 | `eval-rubric` | `skills/eval-rubric/SKILL.md` |
| 5 | `open-goal` (×3) | `skills/open-goal/SKILL.md` |

The whole week is wrapped by `skills/consulting-poc/SKILL.md`, which orchestrates the day-by-day flow and produces the handover doc the client keeps.

## Inputs required

- A bootstrapped `clients/<prospect>/` (run `substrate-bootstrap-prospect <slug>` before day 1).
- Phase 0 audit committed to git as `clients/<prospect>/diagnostics/phase-0-audit.md` (skill `consulting-poc` refuses Phase 1 without it).
- Public sources config (URLs for LP, blog, pricing, careers, reviews) at `clients/<prospect>/.public-sources.yaml`.
- Three booked customer calls by end of day 1 (frontline-contact rule).
- A signed engagement letter naming the day-5 deliverable.

## Outputs produced

By Friday end-of-day, `clients/<prospect>/` contains:

- `BRIEF.md` (filled, current)
- `00-INDEX.md` (canonical layer index)
- `icp/00-INDEX.md`
- `positioning/positioning-canonical-statement.md`
- `competitive/status-quo.md`
- `narrative/strategy.md`
- `messaging/matrix.md`
- One customer-facing artifact in `assets/` (preflight-clean)
- `diagnostics/phase-1-report.md`
- `roadmap-90d.md`
- `calibration-baseline.md`
- `voc/cadence-ledger.md` with at least three logged calls
- Three open rows on `goals/ledger.md`

The client can run `substrate <any-skill> --client <prospect>` after the engagement and the substrate gates work because the layers are populated.

## Failure modes

- **Day 1 ships without an ICP or BRIEF.** The whole week is downstream of these. If day 1 doesn't close, day 2 can't open. Drop a day and add it to day 5 instead of running positioning on a thin ICP.
- **Day 3 messaging matrix has no VoC citations.** The cause is usually that day-1 calls didn't happen or didn't land. Fix the call cadence first; messaging-matrix refuses on missing VoC anyway.
- **Day 4 artifact fails pre-publish-check three times in a row.** The artifact problem is usually a substrate problem. Re-read positioning. Sharpen the status-quo frame. Don't override the gate.
- **Day 5 roadmap has goals without measurement contracts.** Open-goal will refuse. The fix is to write measurement contracts that name source-system, baseline, target, and window. "We'll know it when we see it" doesn't ship.
- **The week ends without a calibration baseline.** Means the operator skipped the predictions step. Without calibrated predictions the 90-day roadmap is a wishlist; with them, it's a falsifiable plan and the client gets to score the operator's accuracy at day 90. Don't skip.

## Calibration hooks

- Day 5's three opened goals all carry predicted probabilities on `goals/ledger.md`. They resolve at days 30, 60, and 90 per the roadmap.
- Each resolution updates the operator's calibration on the relevant taste-type (positioning, narrative, channel-asset).
- `pmm-coaching` reads the operator's calibration history at the next quarterly review; sustained accuracy on a taste type unlocks decision authority on that cell per PRINCIPLES.md rule 6.
- The client's own calibration loop opens here too: every goal they take ownership of carries a Brier score they can score against their internal team's track record at the same craft.

## Composes with

- `routines/quarterly-pmm-cycle.md`, the recurring routine the client picks up after week 1 closes.
- `routines/customer-conversation-rhythm.md`, the cadence that keeps `voc/` fresh after the week's three booked calls run out.
- `routines/launch-flow.md`, when day 4's artifact is part of a larger launch.
- `routines/aeo-publish-cycle.md`, when the engagement's first 90-day goal is an AEO move.

## See also

- `skills/consulting-poc/SKILL.md`, the orchestrator skill.
- `templates/consulting-proposal.md`, the proposal the Phase 0 call ends with.
- `bin/substrate-bootstrap-prospect`, the public-surface bootstrap helper.
- `knowledge/patterns/diagnose-before-execute.md`, the load-bearing pattern.
- `PRINCIPLES.md` rule 1 (context-first), rule 2 (falsifiability), rule 9a (behavioral grounding).
