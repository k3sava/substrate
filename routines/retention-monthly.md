---
title: monthly retention review
status: active
last_updated: 2026-05-08
patterns_grounded: [retention-cohort-curves-over-blended-rates, aha-moment-defines-activation, churn-prediction-vs-churn-diagnosis]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
schedule: monthly, first Tuesday of month
---

# Monthly retention review

The retention surface is the most underrated revenue lever and the one most teams underread. Per `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`, blended retention hides the truth; cohort curves expose it. This routine is the cohort read, run on a fixed cadence, with the same artifacts produced every month so trend-drift becomes visible.

The routine is a closed loop: read the cohort table, diagnose any regressions, design responses where the diagnosis names addressable drivers, and resolve the prior month's predictions before opening new ones.

## Cadence contract

Monthly, on the first Tuesday. The previous month's cohort retention is fully observable by then (4 weeks of W1-W4 retention closed; W8 partially closed for the cohort that signed up at the start of the month).

## Loop steps

### 1. Pull the events export

Engineering or RevOps lands the prior month's events export at `clients/<client>/events/exports/<YYYY-MM>.csv`. Required columns: `user_id`, `event_name`, `ts`. Optional but valued: `property_signup_source`, `property_persona`, `property_plan`, `property_team_size`, `property_workspace_id`.

If the export is missing, the routine refuses to start. Without events data, every retention conversation is a guess.

### 2. Run `activation-funnel-audit`

```
substrate activation-funnel-audit --client <client> --events <path-to-csv>
```

Produces `clients/<client>/retention/activation-audit-<date>.md` plus JSON sidecar. Names (or refuses to name) the activation event for the month. If the named activation event differs from last month's, that is a finding, not noise. Track whether the activation rate moved.

If the skill refuses with `no-activation-candidate`, that is a *product* finding. Surface to the product team. Do not work around the refusal.

### 3. Run `retention-cohort-analysis`

```
substrate retention-cohort-analysis --client <client> --events <path-to-csv>
```

Produces `clients/<client>/retention/cohort-retention-week-<date>.md` + .csv + .json. Reads the activation event from step 2 (auto-resolved from the JSON sidecar).

Look at:
- The cohort retention table. Has W4 retention drifted versus the trailing 4-cohort baseline?
- The activation-conditioned table. Is the gap between activated and not-activated retention widening, narrowing, or stable?
- Slope-change flags. Each flag deserves a one-sentence explanation in the monthly report.

### 4. If slope-change flags fire, run `churn-diagnose`

Get the churned-accounts CSV for the same period from RevOps / data team:

```
substrate churn-diagnose --client <client> --churned <path-to-churned.csv>
```

Optionally pass `--events` and `--support-tickets` for activation gap and support cluster analysis.

The diagnosis produces ranked drivers and per-band save-vs-let-go recommendations. Read both. The driver list is the "what to fix" list; the band recommendations are the "what to do per cohort" list.

### 5. If the diagnosis names addressable drivers, design the response

Per the contradiction conditioning, design responses *per band*:

```
substrate win-back-sequence --client <client> --diagnosis <path-to-diagnosis-json>
```

The skill picks the contradiction position per band from the diagnosis. Do not override unless you have evidence the diagnosis is wrong; if you do, log the override.

For drivers that are addressable in product (e.g., activation-gap dominant), file a product ticket with the diagnosis link.

### 6. Run `expansion-trigger-detect`

```
substrate expansion-trigger-detect --client <client> --events <path-to-csv>
```

Produces the expansion trigger queue for the next month. Hand-off the CSV to CS / AE workflow tools. The hot and burning bands are the priority queue; the warm band is the in-product nudge target; the cold band is no-action.

### 7. Resolve prior month's predictions

Open the prior month's `win-back-sequence-*.md` and `expansion-triggers-*.md`. For each prediction (predicted reactivation rate, predicted hot-band conversion), look up the actual outcome in lifecycle tooling / CRM. Record the resolution in `goals/ledger.md`. Brier-score it.

Honest losses count. Per PRINCIPLES.md rule 2, predictions get an accuracy score on resolve, regardless of direction.

### 8. Write the monthly report

Compose a one-page summary at `clients/<client>/retention/monthly-review-<YYYY-MM>.md`:

- Headline retention number (cohort-conditioned, with the cohort label and window).
- Activation event status (named, drifted, or refused).
- Slope-change flags (if any), with one-sentence explanation each.
- Top 3 churn drivers (if diagnosis ran), with per-band action.
- Expansion queue size by band.
- Prior month's predictions resolved (with Brier scores).
- Open questions for next month.

Keep it short. The artifact density of the underlying skill outputs is high; the monthly report is the operator-readable index.

## Failure modes the routine prevents

- **Blended retention as the headline.** Per the cohort-curves pattern, blended retention is the reported number; cohort curves are the read. The routine forces the cohort read every month.
- **Saving everyone equally.** Per the save-vs-let-go contradiction, undifferentiated save programs misallocate CS hours. The routine forces per-band conditioning every month.
- **Predicting before diagnosing.** Per the churn-prediction-vs-diagnosis pattern, prediction without diagnosis is silent on the lever. The routine forces diagnosis first.
- **Activation drift unnoticed.** The named activation event can drift over time as product changes; the routine recomputes monthly so drift is caught early.
- **Prior predictions never resolved.** Per PRINCIPLES rule 2, predictions get scored at resolution. The routine includes the resolve step explicitly.

## Substrate reads + writes

- Reads: `clients/<client>/events/exports/`, `clients/<client>/retention/churned-accounts-*.csv`, `clients/<client>/icp/`, `clients/<client>/positioning/`, `clients/<client>/voc/`.
- Writes: `clients/<client>/retention/activation-audit-*`, `cohort-retention-*`, `churn-diagnosis-*`, `win-back-sequence-*`, `expansion-triggers-*`, `monthly-review-<YYYY-MM>.md`.

## Quality criteria

- Refuses to mark the month complete if the events export is missing.
- Refuses to mark the month complete if a slope-change flag fired and the diagnosis was not run.
- Refuses to mark the month complete if prior-month predictions are unresolved.

## See also

- `skills/activation-funnel-audit/SKILL.md`
- `skills/retention-cohort-analysis/SKILL.md`
- `skills/churn-diagnose/SKILL.md`
- `skills/expansion-trigger-detect/SKILL.md`
- `skills/win-back-sequence/SKILL.md`
- `skills/nps-loop-design/SKILL.md`
- `routines/expansion-watcher.md` (weekly companion)
- `knowledge/patterns/retention-cohort-curves-over-blended-rates.md`
- `knowledge/patterns/aha-moment-defines-activation.md`
- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`
