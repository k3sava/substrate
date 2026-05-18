---
title: founding marketer charter, week 1
status: active
last_updated: 2026-05-18
cadence: one-time, day 1 to day 5, run when the founding marketer seat is empty or being filled day-of
owner: lead consultant or in-house operator bridging the seat
patterns_grounded: [diagnose-before-execute, narrative-as-strategy, frontline-as-pmm-substrate, evidence-ladder]
contradictions_aware: [no-decision-vs-named-competitor, founder-voice-vs-team-voice]
composes: [consulting-poc, capability-pin, positioning-forge, status-quo-frame, dunford-value-frame, icp-cut, agent-jtbd-map, messaging-matrix, allowed-claims-register, founder-voice-substrate, narrative-strategy, open-goal, frontline-contact]
sibling_to: new-client-onboarding-week-1
---

# Founding marketer charter, week 1

The five-day sequence that lands when there is zero PMM in seat and the founding marketer is being hired (or just walked in). The terminal artifact is the charter doc the hire reads on day one, plus the substrate that charter authorizes against.

## Why this exists, separate from new-client-onboarding-week-1

`new-client-onboarding-week-1` assumes a PMM is already in seat. Substrate gets installed alongside their work. This routine assumes the seat is empty (or filled day-of) and substrate IS the bridge until the hire scales. Same five days, different terminal artifact: the charter doc, not the diagnostic dossier.

Five top-10 consulting prospects fit this shape verbatim. Five more are structurally adjacent (CMO or VPM hire in 60 to 120 days). It is the highest-frequency single shape in the pipeline.

## Stages

### Day 1, diagnose

**Inputs**: 90-minute founder discovery call plus public-surface bootstrap.

**Run**:

```bash
substrate-bootstrap-prospect <client>
$EDITOR clients/<client>/BRIEF.md
substrate consulting-poc --client <client> --phase 0
substrate capability-pin --client <client> --role founding-marketer
substrate frontline-contact --client <client> --book 3
```

**What happens.** Bootstrap drops the 10-layer scaffold. The operator fills `BRIEF.md` from the founder call. `consulting-poc --phase 0` produces the public-surface audit. `capability-pin` names what the founding marketer role IS and IS NOT, so the charter has explicit anti-scope-creep boundaries on day five. `frontline-contact` books three customer calls for day three or four; the hire inherits the cadence.

**Artifact** committed to git: `clients/<client>/diagnostics/phase-0-audit.md`, `clients/<client>/BRIEF.md`, `clients/<client>/diagnostics/founding-marketer-charter-baseline.md` (what the seat is being hired into, in operator language), `clients/<client>/voc/cadence-ledger.md` with three booked calls.

**Refusal triggers.** No founder call logged. No public-surface audit. Capability-pin without a named role frame. Fix the substrate gap before advancing.

### Day 2, position

**Run**:

```bash
substrate positioning-forge --client <client> --diagnose
substrate dunford-value-frame --client <client>
substrate status-quo-frame --client <client>
```

**What happens.** Positioning-forge runs Dunford's five-step diagnostic against day-one inputs. Status-quo-frame names the no-decision alternative explicitly. Dunford-value-frame layers value pillars on top. The output is the canonical positioning the hire will operate against on day one of their employment.

**Artifact**: `clients/<client>/positioning/positioning-canonical-statement.md`, `clients/<client>/competitive/status-quo.md`.

**Refusal triggers.** Status quo not named. Positioning that competes against features instead of alternatives. Fix and re-run.

### Day 3, segment

**Run**:

```bash
substrate icp-cut --client <client> --mode initial
substrate agent-jtbd-map --client <client>   # if AI-native product
substrate messaging-matrix --client <client> --mode build --audience <pinned-icp>
```

**What happens.** ICP-cut produces two ICP cards: a verified buyer and an adjacent buyer. For AI-native products, agent-jtbd-map adds the agent-buyer-center cut. Messaging-matrix builds the persona by pain by value by proof by call grid. The hire reads these files on day one and runs the next round of customer interviews against them.

**Artifact**: `clients/<client>/icp/00-INDEX.md`, `clients/<client>/messaging/matrix.md`, `clients/<client>/agents/jtbd-map.md` (if applicable).

**Refusal triggers.** Less than two customer calls logged from day-one booking. Messaging cells with zero VoC citation. Fix the substrate (more calls, sharper pillars) and re-run.

### Day 4, claim

**Run**:

```bash
substrate allowed-claims-register --client <client> \
    --surfaces https://<client>.com \
    --surfaces https://<client>.com/pricing \
    --surfaces https://<client>.com/customers
substrate claim-verify clients/<client>/allowed-claims-register.md
```

**What happens.** `allowed-claims-register` scans the live public surface for every numeric or superlative claim, dedupes across surfaces, and emits the procurement-defensible register. Each row defaults to `self-reported` attribution with TBD operational definition. The operator fills the definitions for the load-bearing five to ten claims in the same day, leaving the rest as DRAFT. The procurement-failure section is the strike-list the hire walks in with.

If the founder has a usable public corpus, also run:

```bash
substrate founder-voice-substrate --client <client> \
    --founder "<founder-name>" \
    --corpus-paths "clients/<client>/raw/founder-posts/*.md" \
    --corpus-paths "clients/<client>/raw/podcasts/*.md"
```

**Artifact**: `clients/<client>/allowed-claims-register.md`, optionally `clients/<client>/brand-voice/founder-voice.md`.

**Refusal triggers.** Public surfaces resolve to JS-only render with no extractable text. Register emits with zero claims. Either feed rendered HTML files or expand the surface list before advancing.

### Day 5, charter plus measurement

**Run**:

```bash
substrate narrative-strategy --client <client> --mode draft
substrate open-goal --client <client> --goal-id 90d-bet-1 --measurement-contract <path>
substrate open-goal --client <client> --goal-id 90d-bet-2 --measurement-contract <path>
substrate open-goal --client <client> --goal-id 90d-bet-3 --measurement-contract <path>
$EDITOR clients/<client>/founding-marketer-charter.md
```

**What happens.** Narrative-strategy produces the one canonical thesis the hire inherits. Three calibrated 90-day goals open with measurement contracts. The charter doc itself is composed (see structure below); the operator hand-edits the role-language line and the escalation paths. The result is the artifact the hire reads on day one of their employment.

**Artifact**: `clients/<client>/founding-marketer-charter.md`, `clients/<client>/calibration-baseline.md`, three open rows on `goals/ledger.md`.

**Refusal triggers.** Charter without all substrate paths from days 1 to 4 named. Goals without measurement contracts. Anything that cannot be falsified at day 90 does not ship in the charter.

## The charter doc shape

```
---
title: Founding marketer charter, <client>
client: <client>
owner: <hire-name>
inherits_from: substrate (paths listed below)
review_cadence: weekly with founder, monthly with operator
produced_by: founding-marketer-charter-week-1
asset_type: charter
---

## The job in one sentence
<role's job in operator language, not HR language>

## What you own
<list, with substrate paths per item>

## What you do not own
<explicit anti-scope-creep list>

## The substrate you inherit
- Positioning: clients/<client>/positioning/positioning-canonical-statement.md
- ICPs: clients/<client>/icp/00-INDEX.md
- Allowed claims: clients/<client>/allowed-claims-register.md
- Status quo: clients/<client>/competitive/status-quo.md
- Brand voice: clients/<client>/brand-voice/
- Founder voice: clients/<client>/brand-voice/founder-voice.md
- Messaging matrix: clients/<client>/messaging/matrix.md
- Narrative: clients/<client>/narrative/strategy.md
- VoC cadence: clients/<client>/voc/cadence-ledger.md

## Your first 90 days, three calibrated goals
1. <goal>, contract: <metric>, source: <system>, baseline: <number at date>, predicted: <number with confidence>
2. <goal>, contract: ...
3. <goal>, contract: ...

## Cadences you inherit
- frontline-contact: 3 customer calls per week minimum
- pre-publish-check: gates every external draft
- allowed-claims-register: monthly re-verify, quarterly strike-decayed
- founder-voice-substrate: monthly re-compile while founder is publishing actively

## When to escalate
- Founder: <decision class>
- Operator who built this substrate: <decision class>
- Substrate gate refusal: <process for unstuck>
```

## Inputs required

- Bootstrapped `clients/<client>/` (run `substrate-bootstrap-prospect <slug>` before day 1).
- Phase 0 audit committed to git as `clients/<client>/diagnostics/phase-0-audit.md`.
- A 90-minute founder discovery call logged on day 1.
- Three booked customer calls by end of day 1.
- A signed engagement letter naming the day-5 deliverable as the charter doc, not the diagnostic dossier.

## Outputs produced

By Friday end of day, `clients/<client>/` contains:

- `BRIEF.md` (filled, current)
- `diagnostics/phase-0-audit.md`
- `diagnostics/founding-marketer-charter-baseline.md`
- `positioning/positioning-canonical-statement.md`
- `competitive/status-quo.md`
- `icp/00-INDEX.md`
- `messaging/matrix.md`
- `agents/jtbd-map.md` (if AI-native product)
- `allowed-claims-register.md`
- `brand-voice/founder-voice.md` (if founder has a usable public corpus)
- `narrative/strategy.md`
- `founding-marketer-charter.md` (the terminal artifact)
- `calibration-baseline.md`
- Three open rows on `goals/ledger.md`

The hire reads the charter on day one and can run any substrate skill against the named files.

## Failure modes

- **Day 1 ships without capability-pin.** The charter on day 5 has no anti-scope-creep frame, so the hire walks into "marketing owns everything" by default. Re-run capability-pin even at the cost of dropping a day-3 task.
- **Day 4 register emits zero claims.** Usually the public surface is JS-rendered. Pull rendered HTML files or screenshot-text instead of the live URL; do not advance to day 5 without the register, since the charter cites the file path.
- **Day 5 charter has goals without measurement contracts.** Open-goal will refuse. The fix is to write contracts that name source-system, baseline, target, and window. "We will know it when we see it" does not ship in a charter.
- **The hire is unknown at day 1.** The charter on day 5 has no addressee. Either the founder names the hire by Wednesday, or the charter ships as "founding marketer (TBN)" with the founder addressed as proxy in the first paragraph.

## Calibration hooks

- Three goals opened on day 5 carry predicted probabilities; they resolve at days 30, 60, and 90.
- Each resolution scores the operator who built the substrate AND the hire who inherited it, on the same metric.
- If the hire's calibration after 90 days diverges sharply from the operator's, the charter goes back to the substrate for a re-baseline (positioning, ICP, claims may have drifted).

## How Phase 2 differs from new-client-onboarding-week-1's Phase 2

`new-client-onboarding-week-1` typically continues into an embedded operator engagement. This routine typically continues into a train-the-team engagement, because the hire is now in seat. The operator's role shifts from running the cadence to coaching the cadence; the substrate stays the same.

## Composes with

- `routines/customer-conversation-rhythm.md`, the cadence that keeps `voc/` fresh after day-1 calls run out.
- `routines/quarterly-pmm-cycle.md`, the recurring routine the hire picks up at 90 days.
- `routines/competitor-watch-cycle.md`, the weekly competitive surveillance.
- `routines/aeo-publish-cycle.md`, when the 90-day plan includes an AEO bet.

## See also

- `skills/consulting-poc/SKILL.md`, the orchestrator skill for Phase 0 and Phase 1.
- `skills/allowed-claims-register/SKILL.md`, the day-4 procurement-defense artifact.
- `skills/founder-voice-substrate/SKILL.md`, the day-4 founder-voice file.
- `skills/case-study-compose/SKILL.md`, used in Phase 2 once the hire books their first reference call.
- `routines/new-client-onboarding-week-1.md`, the sibling routine for PMM-in-seat engagements.
- `PRINCIPLES.md` rule 1 (context-first), rule 2 (falsifiability), rule 9a (behavioral grounding).
