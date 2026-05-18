---
title: full-funnel audit
status: active
last_updated: 2026-05-08
cadence: quarterly, week 1 of the quarter (or on-demand when CAC drift triggers it)
owner: PMM lead with paid-marketing, lifecycle, and CS leads as named participants
patterns_grounded: [diagnose-before-execute, measurement-correlated-short-signals, intent-vs-interest-targeting, retention-cohort-curves-over-blended-rates, churn-prediction-vs-churn-diagnosis]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
composes: [ad-diagnose, ad-attribution-honest, email-deliverability-audit, email-engagement-decay-watcher, activation-funnel-audit, retention-cohort-analysis, churn-diagnose, eval-rubric]
---

# Full-funnel audit

A quarterly cross-surface audit that reads the funnel honestly: paid acquisition, lifecycle email, activation, retention, and churn. Five diagnostic skills, one composite report, ranked drivers per stage, and the next quarter's three highest-leverage goals already named.

## Why this exists

Most funnel reviews are charts, not diagnoses. A leadership deck with funnel-stage rates by quarter ("MQL up 8%, conversion flat, churn flat") tells you nothing about what's actually moving the unit economics. Diagnose-before-execute is the principle (per `knowledge/patterns/diagnose-before-execute.md`); the audit is the routine that operationalises it at the funnel level.

The audit composes substrate's per-surface diagnostic skills into a single quarterly read. Each surface (paid, email, activation, retention, churn) has a skill that already runs honest math: source-system-pulled, attribution-aware, cohort-conditioned, blended-only-refused. The audit runs them in sequence, surfaces ranked drivers per surface, and writes the cross-surface report leadership can act on.

The output is not "the funnel looks healthy." The output is: "paid CAC drifted 18% on Meta over the quarter because creative refresh cadence dropped below the threshold; activation rate moved against trailing 4-cohort baseline because the named activation event drifted; W12 retention slope-changed in the SMB cohort because save-vs-let-go was applied undifferentiated. Here are three quarter goals." That's a diagnosis. Charts alone never get there.

## Stages

### Stage 1, paid acquisition diagnosis

**Run** (per active paid channel):

```bash
substrate ad-diagnose --client <client> \
  --export clients/<client>/ads/exports/<channel>-<YYYY-MM>.csv \
  --channel <channel> \
  --target-cac <usd> --ltv <usd>
```

**Then** run the attribution-honest gate on any channel-performance claim:

```bash
substrate ad-attribution-honest --client <client> --channel <channel>
```

**What happens.** Per channel, ad-diagnose audits the export for waste, fatigue, ICP mismatch, positioning drift. The attribution-honest gate refuses any channel-performance claim without a documented attribution model + window + blind-spot disclosure. Cross-channel performance gets read against `intent-vs-interest-targeting`: search intent vs. social interest carry different unit economics; comparing them on shared metrics is a category error.

**Output**: `clients/<client>/ads/diagnostics/<channel>-<YYYY-MM-DD>.md` per channel; the funnel-audit report's paid-acquisition section.

**Refusal triggers.** Missing positioning, missing ICP, missing CSV headers, channel-performance claim without attribution model. Fix the substrate, not the report.

### Stage 2, email deliverability and decay

**Run**:

```bash
substrate email-deliverability-audit --client <client> --domain <domain> --send-log clients/<client>/email/send-log/<YYYY-MM>.csv
substrate email-engagement-decay-watcher --client <client>
```

**What happens.** The deliverability audit checks SPF, DKIM, DMARC posture across the sending domain and known subdomains; cross-references send-log against Gmail Postmaster bounce / complaint thresholds. The decay watcher reads weekly metrics CSVs, computes 4-week-vs-prior-4-week lift on open / click / complaint / bounce rates, classifies decay shape (sudden cliff / gradual taper / step-down) per `knowledge/patterns/engagement-decay-as-relevance-signal.md`.

**Output**: `clients/<client>/email/audits/deliverability-<domain>-<YYYY-MM-DD>.md`, `clients/<client>/email/decay/<YYYY-MM-DD>.md`. The funnel-audit report's lifecycle section.

**Refusal triggers.** No DMARC, lookup overflow on SPF, send-log missing required headers. The fix is DNS-side or send-log-side; the audit doesn't apply lipstick.

### Stage 3, activation funnel

**Run**:

```bash
substrate activation-funnel-audit --client <client> --events clients/<client>/events/exports/<YYYY-MM>.csv
```

**What happens.** Per `knowledge/patterns/aha-moment-defines-activation.md`, the activation event is named by retention-curve divergence, not by a guessed proxy. The skill reads the events export, tests candidate value events for their power to predict W4+ retention, names the event or refuses with `no-activation-candidate` (which is itself a finding: it surfaces a product-side question to engineering).

**Output**: `clients/<client>/retention/activation-audit-<date>.md` plus JSON sidecar. The funnel-audit report's activation section.

**Refusal triggers.** Events export missing or older than 7 days. Less than 1 month of events history. No event candidate produces retention divergence (means a product conversation, not a marketing one).

### Stage 4, retention cohorts

**Run**:

```bash
substrate retention-cohort-analysis --client <client> --events clients/<client>/events/exports/<YYYY-MM>.csv
```

**What happens.** Computes weekly cohort retention curves with slope-change detection (1.5 SD against trailing 4-cohort baseline). Splits by activation status; the gap between activated and not-activated cohorts is a load-bearing read. Per `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`, blended retention rates are explicitly refused; cohort curves are the read.

**Output**: `clients/<client>/retention/cohort-retention-week-<date>.md` + .csv + .json. The funnel-audit report's retention section.

**Refusal triggers.** Blended-only outputs requested. Activation event not named (Stage 3 must complete first). Cohort sizes below significance threshold.

### Stage 5, churn diagnosis

**Run** (only if Stage 4 fired a slope-change flag, or if churn rate is above the trailing-quarter baseline):

```bash
substrate churn-diagnose --client <client> --churned clients/<client>/retention/churned-accounts-<YYYY-MM>.csv
```

**What happens.** Per `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`, prediction without diagnosis is silent on the lever. Churn-diagnose surfaces ranked drivers from a churned-accounts CSV scored on coverage × addressability. The save-vs-let-go contradiction (per `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`) gets resolved per band, not globally; the diagnosis writes per-band recommendations conditioned on ICP fit.

**Output**: `clients/<client>/retention/churn-diagnosis-<date>.md` plus drivers CSV plus JSON sidecar. The funnel-audit report's churn section.

**Refusal triggers.** Churned-accounts CSV missing required columns. Diagnosis attempted on accounts without enough history (younger than min-tenure-days).

### Stage 6, compose the funnel-health report

**Run**:

```bash
substrate eval-rubric --asset clients/<client>/quarterly/funnel-health-Q<n>.md --judge binary --rubric clients/<client>/quarterly/funnel-rubric.md
```

**What happens.** The cross-surface report composes the per-stage diagnostics into a single quarterly artifact. Structure:

1. **Paid acquisition** — per channel, top 3 waste drivers, fatigue status, attribution caveats.
2. **Lifecycle email** — deliverability posture, decay shapes per sequence, first-hypothesis routing.
3. **Activation** — named event, drift versus prior quarter, refused-with-reason if no event qualifies.
4. **Retention** — cohort curves, slope-change flags, activation gap.
5. **Churn** — ranked drivers, per-band save-vs-let-go decisions, addressability map.
6. **Cross-surface synthesis** — three funnel-shaping bets opened as goals on `goals/ledger.md`, each with a measurement contract.

The eval-rubric runs against the report itself: did it cite source-system data on every claim? Did it refuse blended-only? Did it surface ranked drivers per stage? Pass / fail.

**Output**: `clients/<client>/quarterly/funnel-health-Q<n>.md`. Three opened rows on `goals/ledger.md` with predicted probabilities and measurement contracts.

**Refusal triggers.** Report ships without source-system citation per claim. Report uses blended retention as headline (the rubric refuses). Cross-surface bets opened without measurement contracts.

## Skills it composes

| Stage | Skill | Path |
|---|---|---|
| 1 | `ad-diagnose` (per channel) | `skills/ad-diagnose/SKILL.md` |
| 1 | `ad-attribution-honest` (per channel) | `skills/ad-attribution-honest/SKILL.md` |
| 2 | `email-deliverability-audit` | `skills/email-deliverability-audit/SKILL.md` |
| 2 | `email-engagement-decay-watcher` | `skills/email-engagement-decay-watcher/SKILL.md` |
| 3 | `activation-funnel-audit` | `skills/activation-funnel-audit/SKILL.md` |
| 4 | `retention-cohort-analysis` | `skills/retention-cohort-analysis/SKILL.md` |
| 5 | `churn-diagnose` (conditional) | `skills/churn-diagnose/SKILL.md` |
| 6 | `eval-rubric` (against the report) | `skills/eval-rubric/SKILL.md` |
| 6 | `open-goal` (×3) | `skills/open-goal/SKILL.md` |

## Inputs required

- Active client substrate with ICP, positioning, product-knowledge layers populated.
- Quarterly paid-channel exports at `clients/<client>/ads/exports/`.
- Sending-domain DNS access (audit reads via `dig`).
- Optional but valued: 30-day send-log CSV at `clients/<client>/email/send-log/`.
- Weekly email metrics CSVs at `clients/<client>/email/metrics/` (8+ weeks of history).
- Monthly events export at `clients/<client>/events/exports/`.
- Churned-accounts CSV at `clients/<client>/retention/churned-accounts-<YYYY-MM>.csv` (when Stage 5 fires).

## Outputs produced

- Per-stage diagnostics across `clients/<client>/ads/diagnostics/`, `clients/<client>/email/audits/`, `clients/<client>/email/decay/`, `clients/<client>/retention/`.
- The composite `clients/<client>/quarterly/funnel-health-Q<n>.md` report.
- Three opened goals on `goals/ledger.md` with measurement contracts (the next quarter's three funnel-shaping bets).
- Updated calibration baseline for the operator's "funnel diagnosis" taste type.

## Failure modes

- **The audit becomes a slide deck.** Leadership wants the chart; the diagnosis is the lever. Resist. The report's rubric refuses anything that isn't ranked drivers + addressability + measurement contract.
- **Blended retention as the headline.** Per the cohort-curves pattern, blended retention is the reported number; cohort curves are the read. The Stage 4 skill refuses blended-only outputs, and the Stage 6 rubric refuses any report that uses blended as the headline.
- **Channel performance claimed without attribution.** The attribution-honest gate refuses; the fix is to disclose the attribution model + window + blind spots, not to drop the gate.
- **Audit run with stale data.** Events export older than 7 days, ad exports older than the diagnosis window, send-log older than 30 days. Per Rule 1, no audit on stale context. Pull fresh exports first.
- **Three bets opened without measurement contracts.** The audit's value is the falsifiable next-quarter plan. Bets that can't be scored at resolution don't ship in the report.
- **Stage 5 skipped when slope-change fired.** The per-stage diagnostic chain is the audit's discipline; skipping the churn diagnosis when retention slope-changed means the report names a problem and skips the diagnosis.
- **Cross-functional teams disagree on what the report says.** Read it together. The substrate is the same for everyone; if PMM and CS disagree, one of them is reading a different layer. Reconcile to the substrate, not to the louder voice.

## Calibration hooks

- Each of the three opened goals (Stage 6) carries a calibrated predicted probability.
- Resolutions land per the goal's window (typically the next quarter); Brier scores update the operator's calibration on funnel-shaping taste types (paid CAC, lifecycle relevance, activation, retention, save-vs-let-go).
- The report itself is a deliverable that passes through `eval-rubric`. Repeated passes feed the operator's "funnel diagnosis" calibration record.
- Per `PRINCIPLES.md` rule 6, sustained accuracy on funnel diagnosis (3+ quarters) earns the operator decision authority on next-quarter funnel sequencing.

## Composes with

- `routines/quarterly-pmm-cycle.md`, the wrapping cycle that opens at the start of each quarter.
- `routines/ad-fatigue-routine.md`, the weekly sub-loop that catches paid creative decay between quarterly audits.
- `routines/email-decay-routine.md`, the weekly sub-loop that catches lifecycle decay between quarterly audits.
- `routines/retention-monthly.md`, the monthly sub-loop that catches retention drift between quarterly audits.
- `routines/expansion-watcher.md`, the weekly companion to retention-monthly (expansion is retention's flip side).

## See also

- `skills/ad-diagnose/SKILL.md`, `skills/ad-attribution-honest/SKILL.md`.
- `skills/email-deliverability-audit/SKILL.md`, `skills/email-engagement-decay-watcher/SKILL.md`.
- `skills/activation-funnel-audit/SKILL.md`, `skills/retention-cohort-analysis/SKILL.md`, `skills/churn-diagnose/SKILL.md`.
- `knowledge/patterns/diagnose-before-execute.md`, the load-bearing pattern.
- `knowledge/patterns/intent-vs-interest-targeting.md`, the cross-channel comparison rule.
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`, the blended-rate refusal.
- `PRINCIPLES.md` rule 1 (context-first), rule 2 (falsifiability), rule 8 (revenue per operator).
