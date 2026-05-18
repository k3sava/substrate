---
title: expansion flywheel, retention to revenue
status: active
last_updated: 2026-05-08
cadence: monthly review with weekly trigger watcher; quarterly playbook resolve
owner: CS lead, with PMM lead approving the playbook spec, AE leads consuming the queue
patterns_grounded: [behavioral-expansion-signals-beat-tenure, retention-cohort-curves-over-blended-rates, churn-prediction-vs-churn-diagnosis, frontline-as-pmm-substrate]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
composes: [expansion-trigger-detect, retention-cohort-analysis, nps-loop-design, outbound-sequence-design, churn-diagnose, frontline-contact, score-goal]
---

# Expansion flywheel

The closed loop that turns retention's read into expansion's revenue. Weekly behavioral-trigger scan. Monthly retention cohort review feeds the trigger queue. NPS closed-loop spec routes detractors and unlocks promoters. Outbound sequence designed for high-intent expansion plays. Quarterly resolve scores the playbook against actual ARR-expansion outcomes.

## Why this exists

Retention and expansion compose. Most teams treat them as separate functions: CS owns retention, sales owns expansion. The handoff is either bureaucratic (a CS-to-AE Slack thread three weeks late) or absent (CS notices expansion intent and sells the upgrade themselves, badly). Either way the signal-to-action latency is too long; behavioral expansion windows close in days, not quarters (per `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md`).

This routine wires the loop. The weekly `routines/expansion-watcher.md` produces the behavioral trigger queue; the monthly `routines/retention-monthly.md` feeds the cohort read into expansion strategy; the NPS loop produces the promoter / detractor routing; the outbound-sequence-design skill produces the per-expansion-trigger play. Together they form the flywheel: every month, the cohort read sharpens the trigger queue; every week, the trigger queue sharpens the expansion plays; every quarter, the play outcomes sharpen the cohort read.

The routine also resolves `save-everyone-vs-let-the-wrong-fit-go` at the expansion level. Not every account is an expansion candidate. The save-vs-let-go contradiction conditions per-band: ICP-fit + high behavioral signal = expansion play; ICP-fit + low signal = retention investment; non-fit + any signal = let-go-with-grace path (don't expand a misfit account toward a bigger churn).

## Stages

### Weekly, expansion-trigger watcher

**Run** (per `routines/expansion-watcher.md`):

```bash
substrate expansion-trigger-detect --client <client> --events clients/<client>/events/exports/rolling-30d.csv
```

**What happens.** The expansion-trigger-detect skill scores accounts on adoption breadth × density × growth × threshold-proximity (tenure is not the primary axis; per the load-bearing pattern, behavior is). Accounts band into burning / hot / warm / cold. The CSV gets handed off to CS / AE workflow tools (HubSpot, Salesforce, Outreach).

The hand-off is operator-driven. Burning band gets AE expansion conversation within 24-48 hours. Hot band gets CSM check-in within 7 days. Warm band gets in-product nudge. Cold band gets no action; saves CS hours for hot/burning.

**Output**: weekly trigger queue at `clients/<client>/retention/expansion-triggers-<date>.{md,csv,json}`. Per-band hand-off to downstream tools.

**Refusal triggers.** Events export missing or stale (>7d). Accounts younger than `--min-tenure-days`. Per the watcher's quality criteria, behavioral signal lookback is meaningless on stale data.

### Monthly, retention cohort review feeds the queue

**Run** (per `routines/retention-monthly.md`):

```bash
substrate activation-funnel-audit --client <client> --events <path>
substrate retention-cohort-analysis --client <client> --events <path>
substrate churn-diagnose --client <client> --churned <path>  # if slope-change fired
```

**What happens.** The monthly retention review's outputs feed the expansion flywheel:

- **Activation status** tells the flywheel which cohort to prioritise: accounts that activated 4+ weeks ago and are still on the curve are the primary expansion pool; accounts that didn't activate are retention-investment first, expansion second.
- **Cohort slope flags** identify which cohorts are showing expansion intent (ascending slope post-W4) versus which are decaying (negative slope). Ascending cohorts get the watcher cranked tighter; decaying cohorts get retention investment before any expansion conversation.
- **Churn diagnosis** (when fired) names the addressable drivers; expansion plays designed against accounts that share a driver with churn risk get conditioned: "if X is the churn driver, expansion play addresses X first."

**Output**: monthly retention review at `clients/<client>/retention/monthly-review-<YYYY-MM>.md`. Updated tags on the watcher's account list (activation status, churn-driver flag) so next week's queue reads sharper.

**Refusal triggers.** Per `routines/retention-monthly.md`, the routine refuses to mark complete if exports are missing, slope-change fired without diagnosis, or prior predictions are unresolved.

### Monthly, NPS closed-loop routing

**Run**:

```bash
substrate nps-loop-design --client <client> --mode design --cadence-floor 60d
```

**What happens.** Per `skills/nps-loop-design/SKILL.md`, the closed-loop NPS program has detractor routing conditioned on ICP fit (4 sub-tracks) and a promoter no-ask branch. The design refresh runs monthly:

1. **Detractor routing.** Per ICP-fit + churn-driver + behavioral-band combination, the routing matrix decides: save play, let-go-with-grace path, churn-diagnose deepening, or product-issue escalation. The save-vs-let-go contradiction is conditioned per row.
2. **Promoter routing.** Promoters in the burning / hot expansion bands are the highest-intent expansion candidates the routine surfaces. Promoter expansion plays are categorically different from neutral-cohort expansion plays; the routine pre-stages them for AE pickup.
3. **No-ask branch.** Promoters who are NOT in expansion bands get a different path: case study, referral, advocacy. Not every promoter is an expansion target; expecting them to be erodes the trust that made them promoters.

**Output**: refreshed NPS playbook at `clients/<client>/retention/nps-playbook-<YYYY-MM>.md`. Per-cohort routing matrix.

**Refusal triggers.** NPS data without ICP fit columns. Detractor routing without churn-diagnose dependency met. Promoter expansion plays without behavioral-band qualifier (per the pattern, tenure is not the qualifier).

### As triggers fire, expansion outbound design

**Run** (per burning / hot trigger):

```bash
substrate outbound-sequence-design --client <client> \
  --cohort <expansion-band-id> --tier expansion-1A --trigger <trigger-slug> \
  --frame <expansion-driver-frame> --steps 6
```

**What happens.** The outbound-sequence-design skill produces the multi-touch sequence per expansion trigger, conditioned on the band and the driver. Expansion sequences differ from net-new outbound:

- **Setup phase is shorter** (the customer already knows the product); status-quo framing focuses on the gap between current usage and target outcome, not on the no-decision objection.
- **Proof comes from internal usage data** (the customer's own adoption metrics), not external case studies. Per `make-implicit-explicit`, the data is named and cited; the sequence reads like a usage-pattern review, not a sales pitch.
- **Pricing is the close**, not the lead. Expansion sequences negotiate plan upgrades, seat additions, or feature unlocks; the pricing structure is named in the closing touch, not in the opener.

**Output**: per-trigger sequence under `clients/<client>/retention/expansion-sequences/<date>-<account>-<band>/`. Voice-enforce + claim-verify composed on every touch.

**Refusal triggers.** Expansion sequence without behavioral signal (no burning/hot trigger = no sequence; the trigger is the qualifier). Sequence built on tenure alone (per pattern, refused).

### Quarterly, resolve and recalibrate

**Run**:

```bash
substrate score-goal --goal-id <expansion-prediction-id>  # per active expansion goal
substrate frontline-contact --client <client> --mode quarterly-expansion-review
```

**What happens.** Per quarter, the open expansion goals (predicted hot-band conversion, predicted promoter-expansion close rate, predicted ARR expansion from the playbook) resolve. Brier scores compute. Per-band conversion accuracy lands on the operator's calibration.

The frontline-contact quarterly-expansion review pulls the CS lead's logged calls from the past 90 days, filters to accounts that hit burning / hot bands, and asks: did the customer say something the events data missed? Behavioral-signal triggers catch a lot, but customer voice catches the why; the routine reconciles both.

**Output**: resolved expansion goals on `goals/ledger.md`. Updated calibration on `goals/taste-leaderboard.md`. `clients/<client>/retention/expansion-quarterly-Q<n>.md` debrief with substrate-update proposals.

**Refusal triggers.** Score-goal refuses without source-system citation (CRM expansion-deal close data, billing seat-add data). Quarterly-expansion review without 3+ logged frontline calls per the cadence-contract minimum.

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| Weekly | `expansion-trigger-detect` | `skills/expansion-trigger-detect/SKILL.md` |
| Monthly | `activation-funnel-audit` | `skills/activation-funnel-audit/SKILL.md` |
| Monthly | `retention-cohort-analysis` | `skills/retention-cohort-analysis/SKILL.md` |
| Monthly | `churn-diagnose` (conditional) | `skills/churn-diagnose/SKILL.md` |
| Monthly | `nps-loop-design` (refresh mode) | `skills/nps-loop-design/SKILL.md` |
| Per trigger | `outbound-sequence-design` (expansion mode) | `skills/outbound-sequence-design/SKILL.md` |
| Per trigger | `voice-enforce`, `claim-verify` (composed inside outbound-sequence-design) | per skill |
| Quarterly | `score-goal` (per expansion goal) | `skills/score-goal/SKILL.md` |
| Quarterly | `frontline-contact` (quarterly-expansion-review mode) | `skills/frontline-contact/SKILL.md` |

## Inputs required

- Active client substrate with ICP, positioning, product-knowledge, voc layers populated.
- Events export at `clients/<client>/events/exports/` with rolling 30-day window plus monthly historical exports.
- Churned-accounts CSV at `clients/<client>/retention/churned-accounts-<YYYY-MM>.csv` (when churn-diagnose is required).
- NPS data at `clients/<client>/retention/nps/` with ICP-fit tags per respondent.
- A configured CRM / billing system that records expansion deal closes and seat additions (the source-system the quarterly resolve cites).
- A working `routines/customer-conversation-rhythm.md` so CS frontline calls flow into the quarterly review.

## Outputs produced

- Weekly trigger queues at `clients/<client>/retention/expansion-triggers-<date>.{md,csv,json}`.
- Monthly retention review at `clients/<client>/retention/monthly-review-<YYYY-MM>.md`.
- Monthly NPS playbook at `clients/<client>/retention/nps-playbook-<YYYY-MM>.md`.
- Per-trigger expansion sequences under `clients/<client>/retention/expansion-sequences/`.
- Quarterly debrief at `clients/<client>/retention/expansion-quarterly-Q<n>.md`.
- Resolved goals on `goals/ledger.md` per quarter.
- Substrate-update proposals against retention, voc, product-knowledge layers.

## Failure modes

- **Tenure-based expansion plays.** Per the load-bearing pattern, tenure-based playbooks miss high-intent buyers ready at week 3 and waste cycles on accounts that hit day 90 having never adopted. The routine's expansion-trigger-detect refuses to score on tenure as a primary axis; if a play surfaces tenure as the qualifier, it's wrong by design.
- **Save-vs-let-go applied uniformly.** Most CS programs run a single save program against every churn risk. Per the contradiction, this misallocates CS hours; ICP-fit + high signal warrants save investment, non-fit + any signal warrants let-go-with-grace. The conditioning is not optional.
- **Expansion sequences sent to cold-band accounts.** The watcher's cold band gets no action by design; expansion sequences against cold accounts spam the relationship and cost more in trust than the occasional cold-band close-rate gains.
- **Promoter expansion expected as default.** Per `nps-loop-design`, not every promoter is an expansion target. Expansion plays against promoters who are NOT in expansion bands erode promoter trust; the no-ask branch is non-optional.
- **Weekly watcher run, monthly review skipped.** Triggers without cohort context produce false positives (an account in burning band might be in a decaying cohort the watcher doesn't see). The monthly review tags accounts with cohort context the watcher reads next week.
- **Quarterly resolve skipped.** The Brier score is what calibrates the playbook against reality. Without it, expansion plays compound on whatever the operator's intuition says, not on what's actually working.
- **CS leads' voice never reaches the quarterly review.** The frontline-contact quarterly-expansion review is the read on what events data misses. Skipping it means the why behind the trigger is invisible; expansion plays compound on the what without the why.

## Calibration hooks

- Per-trigger expansion goal: predicted_p (hot-band close rate, burning-band ARR expansion, promoter-expansion conversion). Resolves quarterly.
- Brier scores per band feed the operator's expansion-taste calibration.
- Per-band conversion accuracy compounds quarter over quarter; sustained accuracy on burning band earns AE expansion-prioritisation authority per `PRINCIPLES.md` rule 6.
- The save-vs-let-go contradiction position pick is itself calibrated: the diagnosis says "save" or "let-go" per band; the resolution says whether the call was right. CS lead's contradiction-position accuracy compounds.
- Substrate-update proposals at quarter-end update retention, voc, product-knowledge layers; the next quarter's playbook opens on sharper inputs.

## Composes with

- `routines/expansion-watcher.md`, the weekly behavioral-trigger sub-loop.
- `routines/retention-monthly.md`, the monthly cohort-read sub-loop.
- `routines/customer-conversation-rhythm.md`, the CS frontline-call cadence.
- `routines/quarterly-pmm-cycle.md`, when expansion is one of the quarter's named goals.
- `routines/full-funnel-audit.md`, the cross-surface read where retention + churn diagnosis surfaces the expansion-vs-retention conditioning.

## See also

- `skills/expansion-trigger-detect/SKILL.md`, the load-bearing skill.
- `skills/retention-cohort-analysis/SKILL.md`, the cohort-read skill.
- `skills/churn-diagnose/SKILL.md`, the diagnosis skill.
- `skills/nps-loop-design/SKILL.md`, the closed-loop NPS spec skill.
- `skills/outbound-sequence-design/SKILL.md`, the expansion-sequence skill.
- `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md`, the load-bearing pattern.
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`, the cohort-read pattern.
- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`, the diagnosis-first pattern.
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`, the conditioning contradiction.
- `PRINCIPLES.md` rule 1 (context-first), rule 2 (falsifiability), rule 8 (revenue per operator).
