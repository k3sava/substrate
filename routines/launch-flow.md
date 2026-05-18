---
title: launch flow, end-to-end campaign launch
status: active
last_updated: 2026-05-08
cadence: per-launch (typically 4-12 weeks pre-launch through 90-day post-launch holdout)
owner: PMM lead with demand-gen, brand, and product as named participants
patterns_grounded: [research-preview-and-cadence, narrative-as-strategy, distribution-as-moat, agents-mapped-to-jtbd, measurement-correlated-short-signals]
contradictions_aware: [build-quietly-vs-distribution-first, short-feedback-vs-long-term-holdouts]
composes: [launch-plan, campaign-strategy, narrative-strategy, messaging-matrix, ad-creative-design, email-sequence-design, narrative-compose, lp-ship, pre-publish-check, score-goal]
---

# Launch flow

The end-to-end orchestration that turns a research-preview-and-cadence pattern into a shipped launch with a measurement contract. Plan, brief, generate, gate, ship, hold out, score. The launch is a sequence, not a one-day push.

## Why this exists

Launches that ship as one-day press events underperform because the underlying pattern is wrong. The codex-grounded model (per `knowledge/patterns/research-preview-and-cadence.md`) is a multi-phase sequence: research preview, closed beta, frontier program with named-customer artifacts, launch day, post-launch holdout. Each phase has artifacts, a narrative, and a measurement.

This routine wires the phases. It composes the launch plan with channel-specific creative, gates every asset through `pre-publish-check`, opens a measurement contract with the launch (not after it), and runs a post-launch holdout for falsifiable signal. The Brier score on the launch's calibrated prediction lands in the operator's calibration history; the substrate-update step at resolution feeds the next launch.

The flow also enforces `agents-mapped-to-jtbd` at the launch level. Each named asset (LP variant, ad set, email sequence, sales sequence, social, help doc) maps to a single JTBD with a named human checkpoint. If a launch has eight assets, it has eight JTBDs and eight checkpoints; if it has eight assets and three JTBDs, the launch is doing five things badly instead of three things well. Subtract before adding.

## Stages

### Stage 1, plan (T minus 4 to 12 weeks)

**Run**:

```bash
substrate launch-plan --client <client> --launch <slug> --launch-date <YYYY-MM-DD> --audience <pinned-icp> --mode plan
substrate campaign-strategy --client <client> --cohort <pinned-icp> --outcome <named-outcome> --horizon <weeks> --channels <list> --mode plan
substrate narrative-strategy --client <client> --mode launch-anchor --launch <slug>
```

**What happens.** Launch-plan scaffolds the multi-phase sequence (research preview, closed beta, frontier program, launch day, holdout). Campaign-strategy wraps the launch with the broader GTM motion: cohort, outcome, narrative spine, channels, calibrated prediction, kill criterion. Narrative-strategy produces the canonical spine the launch will defend.

The two contradictions get resolved here:
- `build-quietly-vs-distribution-first` (per `knowledge/contradictions/build-quietly-vs-distribution-first.md`) — pre-PMF / deep-tech launches go build-quietly; post-PMF / category launches go distribution-first. Logged in the plan with the conditioning rationale.
- `short-feedback-vs-long-term-holdouts` — small reversible cohorts get short feedback; large one-way launches get long-term holdouts. Resolved in the measurement contract.

**Artifact**: `clients/<client>/launches/<slug>/plan.md`, `clients/<client>/campaigns/<slug>/plan.md`, `clients/<client>/narrative/launch-<slug>.md`. One row on `goals/ledger.md` with the launch's calibrated outcome prediction.

**Refusal triggers.** Launch without a preview cohort. Campaign without a falsifiable prediction. Channel choice without justification from earned-vs-algorithm framing (per `distribution-as-moat`). Fix and re-run.

### Stage 2, brief and generate (T minus 2 to 6 weeks)

**Run** (per asset, in parallel):

```bash
substrate messaging-matrix --client <client> --mode build --audience <pinned-icp>
substrate ad-creative-design --client <client> --channel <channel> --cohort <buyer-state> --frame <status-quo|named-competitor> --variants 4
substrate email-sequence-design --client <client> --cohort <cohort-id> --trigger <trigger> --steps 5
substrate narrative-compose --client <client> --spec messaging/matrix.md --channel <homepage|blog|press|social>
substrate lp-ship --client <client> --asset clients/<client>/assets/lp-launch-<slug>-v1.md
```

**What happens.** Messaging-matrix builds the canonical message grid the launch defends. Per channel, a brief is generated that another skill consumes (`ad-creative-design` for paid, `email-sequence-design` for lifecycle, `narrative-compose` for owned content, `lp-ship` for the launch LP). Each brief cites the canonical narrative spine and the messaging matrix; cross-channel coherence is enforced by the matrix structure.

Per `agents-mapped-to-jtbd`, each asset gets a one-line JTBD declaration in its frontmatter. The named human checkpoint is whoever owns the asset's quality gate.

**Artifacts**: `clients/<client>/messaging/matrix.md`, `clients/<client>/ads/briefs/<channel>-<cohort>-<frame>-<date>.md`, `clients/<client>/email/sequences/<id>/`, `clients/<client>/assets/lp-launch-<slug>-v1.md`, plus narrative-compose output for owned channels.

**Refusal triggers.** Cells in the messaging matrix without VoC citations. Asset briefs that contradict the canonical narrative. Channel choice that wasn't justified at Stage 1. Fix the substrate gap; per `PRINCIPLES.md` rule 1, no asset advances on stale or missing context.

### Stage 3, preflight every asset (T minus 1 to 4 weeks)

**Run** (per asset):

```bash
substrate pre-publish-check clients/<client>/assets/<asset> --client <client>
```

**What happens.** Every customer-facing asset routes through the composite gate: substrate-cite (rule 1), voice (kill-list, em-dash, throat-clearing), claim-verify (every numeric or competitive claim cites a substrate path), audience-test (synthetic-audience panel scored against the pinned cohort), gates 7 and 8 (pattern-applied + contradiction-position-logged per Rule 9a).

Assets carry `produced_by: <skill>` so gates 7 and 8 fire. Voice rules apply across every channel: an LP and an ad and an email and a social post all read against the same brand-voice file. Cross-channel coherence is checked when multiple assets ship together.

**Artifact**: per-asset preflight reports. Pass means ship-eligible. Fail means fix the underlying substrate, not override.

**Refusal triggers.** Composite gate fails. Voice rules flagged. Claim without substrate path. The right move is to fix the upstream layer (positioning, VoC, product-knowledge) and re-run.

### Stage 4, ship in cadence (launch day, plus T plus 1 to 7 weeks)

**Run**:

```bash
# Launch day
# - LP goes live
# - Press release / blog publishes
# - Email sequence kicks off
# - Ad sets activate
# - Social posts publish per messaging-matrix channel adaptations
# - Sales enablement push (battle card update if launch displaces a competitor)

substrate battle-card-driver --client <client> --competitor <slug> --buyer-state <state> --deal-stage <stage>  # if launch is competitive
```

**What happens.** Approved assets ship per channel. The launch sequence honors the research-preview-and-cadence shape: research preview cohort sees it first (T minus N weeks), frontier program lands named customers (case studies, quotes, screenshots), launch day publishes the canonical narrative across owned + earned + paid channels in coordinated cadence, post-launch weeks 1-7 sustain the cadence with iterative content (deep-dives, customer stories, vertical playbooks).

Per `distribution-as-moat`, earned channels (pinned customer posts, frontier-program testimonials, podcasts, third-party teardowns) get prioritised. Algorithm-rented channels (paid social, paid search) are amplifiers, not the spine.

**Artifact**: shipped assets across channels, instrumented per the measurement contract. `clients/<client>/launches/<slug>/SHIPPED.md` indexes URLs and ship dates.

**Refusal triggers.** A shipped asset diverges from the canonical narrative. Cross-channel coherence breaks (LP says one thing, email says contradicting thing). Per `routines/narrative-drift-routine.md`, drift detection fires on shipped assets that contradict the narrative spine.

### Stage 5, post-launch holdout (T plus 4 to 12 weeks)

**Run**:

```bash
substrate launch-plan --client <client> --launch <slug> --mode holdout
```

**What happens.** The post-launch holdout is the falsifiable signal. Per the contradiction resolved at Stage 1, this is either short-feedback (small reversible cohort, weeks of measurement) or long-term holdout (large one-way launch, 4-12 weeks). The measurement contract opens at Stage 1 and closes here.

Channel-specific measurement runs alongside:
- Paid: incrementality test (`skills/ad-incrementality-test/`) for any channel above 5% of paid budget.
- Email: cohort retention curve (`skills/email-engagement-decay-watcher/` + `skills/retention-cohort-analysis/`).
- Owned content: AEO citation tracking (`routines/aeo-publish-cycle.md` Stage 1).
- LP: lp-cro-rubric drift check at week 4 post-ship.

**Artifact**: `clients/<client>/launches/<slug>/holdout-results-<date>.md`, structured measurement against baseline.

**Refusal triggers.** Holdout window closing without measurement. Measurement against a different cohort than specified at Stage 1 (resolution_date extension requires a new measurement plan, not a swap).

### Stage 6, debrief and Brier score (T plus 12 weeks)

**Run**:

```bash
substrate score-goal --goal-id <launch-slug>
substrate launch-plan --client <client> --launch <slug> --mode retrospective
```

**What happens.** The launch's calibrated prediction (opened at Stage 1 on `goals/ledger.md`) resolves: YES, NO, or AMBIGUOUS. Brier score computed. Calibration history updates per the operator's launch taste-type. The retrospective produces substrate-update proposals: which positioning claim got confirmed, which got invalidated, which voc patterns the launch surfaced.

**Artifact**: resolved goal row, `clients/<client>/launches/<slug>/retrospective.md` with substrate-update proposals.

**Refusal triggers.** Score-goal refuses if the resolution lacks source-system citation. Substrate-update step skipped (closes-the-loop rule).

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| 1 | `launch-plan` | `skills/launch-plan/SKILL.md` |
| 1 | `campaign-strategy` | `skills/campaign-strategy/SKILL.md` |
| 1 | `narrative-strategy` (launch-anchor mode) | `skills/narrative-strategy/SKILL.md` |
| 2 | `messaging-matrix` | `skills/messaging-matrix/SKILL.md` |
| 2 | `ad-creative-design` (per channel) | `skills/ad-creative-design/SKILL.md` |
| 2 | `email-sequence-design` | `skills/email-sequence-design/SKILL.md` |
| 2 | `narrative-compose` | `skills/narrative-compose/SKILL.md` |
| 2 | `lp-ship` | `skills/lp-ship/SKILL.md` |
| 3 | `pre-publish-check` (every asset) | `skills/pre-publish-check/SKILL.md` |
| 3 | `voice-enforce`, `claim-verify`, `audience-test` (composed inside pre-publish-check) | per skill |
| 4 | `battle-card-driver` (when launch is competitive) | `skills/battle-card-driver/SKILL.md` |
| 5 | `ad-incrementality-test` (paid channels) | `skills/ad-incrementality-test/SKILL.md` |
| 5 | `lp-cro-rubric` (LP drift check) | `skills/lp-cro-rubric/SKILL.md` |
| 6 | `score-goal` | `skills/score-goal/SKILL.md` |
| 6 | `launch-plan` (retrospective mode) | `skills/launch-plan/SKILL.md` |

## Inputs required

- Active client substrate with positioning, ICP, VoC, product-knowledge, brand-voice, market-context layers populated.
- A named launch artifact: feature, product, repositioning, vertical entry, or pricing change. Vague "we're going to talk more about X" doesn't qualify.
- The launch date and the cohort the launch targets.
- Engineering / product confirmation that the named feature ships within the launch window (per `launch-plan`'s refuse-on-missing-product-knowledge rule).
- A measurement contract scope: which source-system, which baseline, which target.

## Outputs produced

- `clients/<client>/launches/<slug>/plan.md` (Stage 1)
- `clients/<client>/launches/<slug>/preview-cohort.md` (Stage 2)
- `clients/<client>/launches/<slug>/frontier-artifacts/` (Stage 2)
- `clients/<client>/launches/<slug>/measurement-contract.md` (Stage 1)
- One row on `goals/ledger.md` (Stage 1, resolves at Stage 6)
- Per-channel briefs and assets (Stage 2)
- Per-asset preflight reports (Stage 3)
- `clients/<client>/launches/<slug>/SHIPPED.md` (Stage 4)
- `clients/<client>/launches/<slug>/holdout-results-<date>.md` (Stage 5)
- `clients/<client>/launches/<slug>/retrospective.md` with substrate-update proposals (Stage 6)
- Updated calibration on `goals/taste-leaderboard.md`

## Failure modes

- **The launch plan ships without a calibrated prediction.** Stage 1 refuses if open-goal can't write a measurement contract; the cause is usually that the team is treating the launch as a feature push rather than a falsifiable bet. Tighten the prediction or don't open the launch.
- **Frontier program has no named customers.** Per `launch-plan` rule, refuses launch-day asset that doesn't cite a frontier-program customer artifact. The fix is upstream: book the case study calls earlier, or shift the launch date.
- **Cross-channel drift mid-cadence.** An LP says X, an email two weeks later says Y. Stage 4's narrative-drift trigger catches it; the fix is the messaging-matrix not the channel asset.
- **Holdout extended because "results aren't in."** Per `PRINCIPLES.md` rule 2, extension requires a new resolution date and a documented reason. Quietly stretching the window is the worst calibration failure; future launches calibrated against this one will be biased.
- **Retrospective skipped because Q+1 is starting.** The substrate-update step is where the loop closes. Without it, the next launch opens on context that's no sharper than this one's was. Block 90 minutes for the retrospective; treat it as the most leveraged hour of the next quarter.
- **Launch ships with eight assets and three JTBDs.** Per `agents-mapped-to-jtbd`, this is overproduction. Subtract assets until each maps 1:1 to a JTBD; quality compounds, volume doesn't.

## Calibration hooks

- The launch's predicted_p (Stage 1) gets Brier-scored at Stage 6. Adds to the operator's launch-taste-type calibration.
- Per-asset preflight scores feed cross-channel quality benchmarks (which channel does this operator's launch craft work best on?).
- Sustained accuracy on launch-taste over 3+ launches earns decision authority on launch sequencing per `PRINCIPLES.md` rule 6.
- Substrate-update proposals at Stage 6 update the next launch's input context. Loop closes by definition.

## Composes with

- `routines/quarterly-pmm-cycle.md`, when the launch is one of a quarter's named goals.
- `routines/aeo-publish-cycle.md`, when the launch's owned content needs AEO compounding.
- `routines/competitor-watch-cycle.md`, when the launch is competitive and battle-card updates are required.
- `routines/narrative-drift-routine.md`, the post-ship reality check that catches drift in shipped assets.
- `routines/customer-conversation-rhythm.md`, the cadence that produces the frontier-program named-customer artifacts.

## See also

- `skills/launch-plan/SKILL.md`, the load-bearing skill.
- `skills/campaign-strategy/SKILL.md`, the GTM wrapper.
- `knowledge/patterns/research-preview-and-cadence.md`, the underlying pattern.
- `knowledge/contradictions/short-feedback-vs-long-term-holdouts.md`, the measurement-shape contradiction.
- `knowledge/contradictions/build-quietly-vs-distribution-first.md`, the pre-launch posture contradiction.
- `PRINCIPLES.md` rule 2 (falsifiability), rule 5 (one canonical narrative), rule 9a (behavioral grounding).
