---
title: weekly support churn watcher
status: active
last_updated: 2026-05-08
patterns_grounded: [support-as-churn-leading-indicator, churn-prediction-vs-churn-diagnosis]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
schedule: weekly, Tuesday morning
---

# Weekly support churn watcher

Support volume and sentiment lead churn by 30 to 90 days. Per `knowledge/patterns/support-as-churn-leading-indicator.md`, the signal is in the support data; teams that read it weekly catch the churn before the customer announces it. This routine is that read, on a fixed cadence, with a documented triage handoff.

The routine is short and focused: extract the leading-indicator signal, triage the burning band with operator review, hand off the high-fit burning accounts to CS for proactive save outreach, and resolve last week's burning-band predictions.

## Cadence contract

Weekly, Tuesday morning. The 30-day current window and 90-day baseline window are fully populated by then on a rolling basis; signals shift week-over-week, and a weekly read catches the spike pattern faster than a monthly cycle.

## Loop steps

### 1. Pull the rolling tickets export

Engineering / RevOps lands the rolling 120-day tickets export at `clients/<client>/support/tickets-rolling.csv`. The full export is required (not a delta); the skill computes the current-vs-baseline split internally.

If the export is stale by more than 7 days, the routine refuses to run. The signal decays with the read cadence; a stale corpus produces noise.

### 2. Run `churn-signal-from-support`

```
substrate churn-signal-from-support --client <client> \
  --tickets clients/<client>/support/tickets-rolling.csv \
  --accounts clients/<client>/support/accounts.csv
```

The accounts CSV is optional but valued. When present, the burning-band accounts are weighted by ARR for the priority outreach queue.

The skill produces three artifacts: the markdown report (operator-readable), the JSON sidecar (downstream-readable), the flagged-accounts CSV (CS workflow input).

Look at:
- The severity band counts. Burning + hot is the proactive-outreach queue. Warm is the watch list. Cool is the steady state.
- The per-feature firing counts. If volume-spike fires on more than 30% of accounts, the spike is product-cause (a single bug producing tickets), not account-cause; investigate before treating as churn risk.
- The top 20 flagged accounts. These are the operator's review list.

### 3. Triage the burning band with operator review

The pattern says the signal is real and the calibration matters. The skill produces the queue; the operator confirms or rejects each burning account. The triage criteria:

- **Confirm**: account is high-fit, at least one of the five features fires on a real (not artifact) signal, the verbatim sample excerpts read like genuine concern. Route to the high-fit save flow.
- **Reject**: the spike is product-cause (a bug spike) or test traffic, the sentiment hits are quoting instead of expressing, or the account is low-fit and the volume reflects expected onboarding friction. Suppress the alert.
- **Watch**: ambiguous. Add to next week's review without action.

The triage is a 15-minute pass per the operator. A weekly cadence makes the triage tractable; a monthly cadence makes it a multi-hour audit and the signal has decayed by then.

### 4. Cross-reference with the latest churn-diagnose

If a `churn-diagnose` artifact exists at `clients/<client>/retention/churn-diagnosis-*.json`, cross-reference the burning-band accounts against the diagnosis cohort drivers. An account whose features map to a diagnosis driver (e.g., support-volume-spike + champion-departure noted in diagnosis) is a stronger save candidate than an account firing on volume alone.

### 5. Hand off the high-fit burning accounts to CS

For each confirmed high-fit burning account:

- Pull the latest customer activity, the last 5 tickets verbatim, and the last NPS / CSAT signal if any.
- Compose an outreach note (the account team can use `narrative-compose` or write directly). Outreach reads as: "we noticed [specific signal in their language], and we want to make sure we're getting the next step right." Per `tickets-are-product-feedback-channel`, the outreach quotes the customer's language verbatim where possible.
- Schedule the save call within the response-time SLA (high-fit late-stage gets within 48 hours; high-fit early-stage gets within 5 business days, paired with an activation-fix loop).

For low-fit burning accounts (per the conditioning in `save-everyone-vs-let-the-wrong-fit-go`), do not run the full save playbook. Per Reichheld and Elliott-McCrea, the save attempts produce a treadmill that misallocates CS hours. Send the honest-close composed by `csat-loop-design` instead.

The contradiction position is logged on each outreach disposition. The artifact at week's end records: account_id, band, fit_score, action_taken, contradiction_position_picked, rationale.

### 6. Resolve last week's burning-band predictions

Open last week's `churn-signal-from-support-flagged-*.csv`. For each account flagged burning:

- Did they churn this week? (cancellation event in source system)
- Did they pick up the save call? (CS activity log)
- Did they re-engage? (next-ticket activity)

Record the outcome. The Brier score on burning-band predictions is the calibration signal on the watcher itself; if the false-positive rate is above 50% on burning, the thresholds need recalibration. The skill defaults are conservative; the team can raise or lower them in the runtime args.

### 7. Compose the weekly digest

Append a row to `clients/<client>/support/churn-watcher-weekly.md`:

- Date.
- Burning + hot + warm counts.
- Top 5 confirmed burning accounts (account_id, ARR, fit-score, named feature triggers, action taken).
- Last week's burning-band Brier score.
- Calibration note (was the threshold the right setting?).

Keep the digest short. The full per-account artifact is in the JSON sidecar; the digest is the at-a-glance read for the head of CS.

## Failure modes the routine prevents

- **Renewal-only frame.** Per the pattern, the most common failure is the team being surprised at renewal because the support signal that fired 60 days earlier was visible but unread. The routine forces the read.
- **Auto-alerts without operator review.** Per the pattern's calibration note, the signal is noisy at the individual-account level. The routine builds the operator review into the workflow; no save outreach fires without confirmation.
- **Save-everyone on the burning band.** Per the contradiction, low-fit burning accounts get the honest close, not the save call. The routine logs the position picked and the rationale.
- **Volume-spike treated as account-cause when it is product-cause.** A correlated spike across many accounts is usually a bug. The routine names this anti-pattern and asks the operator to investigate before treating the signal as account-level risk.
- **Watcher uncalibrated.** Per the pattern, the calibration matters. The routine resolves last week's burning-band predictions every week so the false-positive rate stays observable; thresholds adjust quarterly based on the calibration.

## Substrate reads + writes

- Reads: `clients/<client>/support/tickets-rolling.csv`, `clients/<client>/support/accounts.csv`, `clients/<client>/icp/`, `clients/<client>/voc/`, `clients/<client>/retention/churn-diagnosis-*.json`.
- Writes: `clients/<client>/support/churn-signal-from-support-*`, `clients/<client>/support/churn-watcher-weekly.md`.

## Quality criteria

- Refuses to run if the tickets-rolling export is more than 7 days stale.
- Refuses to mark the week complete if last week's burning-band predictions are unresolved.
- Refuses to escalate burning-band accounts to CS without operator confirmation; auto-routing is the failure mode this routine exists to prevent.
- Reports the false-positive rate on the burning band each quarter; thresholds adjust if the rate exceeds 50%.

## Calibration cadence

The watcher's thresholds (volume-ratio floor, response-time-rise floor, sentiment-density floor, unresolved-escalation floor) ship at conservative defaults. Quarterly, the operator pulls the resolved burning-band predictions for the past 13 weeks and computes the false-positive rate. If above 50% on burning, raise the thresholds. If below 20% on burning AND the warm band is producing meaningful churn (more than 10% of warm-band accounts churn within 90 days), lower the thresholds to bring more warm accounts into the burning band.

The calibration changes are logged on the routine, not on the skill. The skill defaults are the conservative starting point; the team-specific calibration is in the runtime args used in this routine.

## See also

- `skills/churn-signal-from-support/SKILL.md`
- `skills/churn-diagnose/SKILL.md`
- `skills/win-back-sequence/SKILL.md`
- `skills/csat-loop-design/SKILL.md`
- `routines/support-cluster-monthly.md` (monthly companion that reads the cluster shape)
- `routines/retention-monthly.md` (monthly retention review that consumes this output)
- `knowledge/patterns/support-as-churn-leading-indicator.md`
- `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md`
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`
