---
title: quarterly lift-test rhythm
status: active
last_updated: 2026-05-08
patterns_grounded: [incrementality-not-attribution, goalpost-discipline-vs-metric-drift, metric-tree-not-metric-stack]
contradictions_aware: [short-feedback-vs-long-term-holdouts]
schedule: quarterly, week 2 of each quarter
---

# Quarterly lift-test rhythm

Attribution models are hypotheses; lift tests are measurement. Per the `incrementality-not-attribution` pattern, every channel-credit number from a multi-touch model is a correlation claim until an experiment validates it. The honest growth team runs at least one structured lift test per spend-meaningful surface per quarter and uses the result to calibrate (or invalidate) the attribution model that drives budget allocation.

This routine is the cadence that keeps the calibration honest. It locks the test schedule before the quarter opens (per `goalpost-discipline-vs-metric-drift`), runs the tests through the quarter, and resolves predictions on a fixed close-out date.

## Cadence contract

Quarterly, in week 2 of the calendar quarter (Q1: 2nd Tuesday January; Q2: 2nd Tuesday April; Q3: 2nd Tuesday July; Q4: 2nd Tuesday October). The first week is reserved for quarter planning + goal-setting; the rhythm runs the week after, anchored to the locked plan.

## Scope

The rhythm covers four surfaces, one test minimum per quarter on each spend-meaningful surface:

| Surface | Default mode | When to switch |
|---|---|---|
| paid-ads | geo-holdout (paid-search, paid-social) or PSA control (display, programmatic) | Switch to synthetic-control when the brand has fewer than 8 marketable geos. |
| email | audience-holdout | Switch to switchback when the email is a recurring nurture and the population is large enough to absorb back-and-forth. |
| retention (in-product) | switchback or audience-holdout | Switch to pre-post when the surface is one-shot (a launched onboarding experiment without an obvious holdout). |
| abm | audience-holdout (account-level) or synthetic-control | Switch to synthetic-control when the account count is small (<200) but the historical depth is rich. |

If any surface is below a spend / volume floor (paid-ads under $20K/quarter, email under 5,000 recipients per send, retention under 2,000 users in the cohort, abm under 50 accounts), do not run a lift test on that surface this quarter. Log "below-floor, skipped this quarter" in the rhythm log; the surface gets skipped for one quarter, then re-evaluated.

## Loop steps

### 1. Lock the quarterly slate before the quarter opens

In week 1 of the quarter, write `clients/<client>/analytics/lift-tests/quarterly-slate-<YYYY-Q[1-4]>.md`:

- Surface, mode, metric (cite the metric-tree leaf), MDE target, baseline, treatment-share, predicted-p, resolution date.
- For each test: a one-sentence "if-yes-we-do-X, if-no-we-do-Y" decision rule. The rule lives in the slate; it cannot be added retroactively.
- Per `goalpost-discipline-vs-metric-drift`, the slate locks at week-1-Friday. Mid-quarter changes count as overrides with attribution.

The slate is the contract. The rhythm runs against the slate, not against drift-driven re-prioritization.

### 2. Run `lift-test-design` for each slate row

```
substrate lift-test-design --client <client> --surface <surface> --mode <mode> \
    --metric <metric-id> --baseline <rate> --quarter <YYYY-Q[1-4]> \
    [--mde-pct <float>] [--predicted-p <float>]
```

Per surface, the skill produces:

- `clients/<client>/analytics/lift-tests/<surface>-<metric>-<YYYY-Q[1-4]>.md`, the test spec with sample-size math, MDE, audience-holdout shape, randomization protocol, validity window.
- `goals/measurement-contracts/<client>-lift-<surface>-<metric>-<YYYY-Q[1-4]>.md`, the goal contract that opens the prediction.

The skill picks a contradiction position on `short-feedback-vs-long-term-holdouts` based on the surface and mode; the position is logged in both artifacts.

If the skill refuses (sample size insufficient, baseline too thin, surface below floor), log the refusal in the slate and either:

- expand the audience to clear the floor (extend the test window into the next quarter, with explicit attribution),
- switch to a surrogate metric upstream in the metric tree (e.g., test against engagement instead of conversion if the conversion volume is too thin),
- or accept "no lift test this surface this quarter" and rely on attribution alone for that surface (logged explicitly).

### 3. Run the tests

Per surface, hand the test spec to the operator who owns the surface:

- paid-ads: performance-marketing lead executes geo-holdout / PSA control via ad-platform UI + the substrate's holdout doc.
- email: lifecycle ops lead configures the holdout audience in HubSpot / Iterable / Customer.io.
- retention: PM + analytics engineer configure the in-product switchback via feature flag.
- abm: ABM lead pairs target-account / control-account list, paired by industry + size + ARR band.

The test spec carries the randomization protocol and the validity window. Document any mid-flight changes in the test spec's `## Mid-flight log` section; per `goalpost-discipline-vs-metric-drift`, every change is dated and attributed.

### 4. Mid-quarter pulse, week 6

Six weeks in, read the test spec's "early signal" section (if defined) for each open test:

- For audience-holdout tests on email / retention with weekly cadence, the early signal at week 6 is informative; do not act on it (per `short-feedback-vs-long-term-holdouts` Position B), but log the trajectory.
- For geo-holdout / PSA tests on paid-ads, week 6 is too early to call; log the trajectory and continue.
- For switchback tests, the rotation is producing per-period reads by week 6; aggregate the periods completed so far and log the trajectory.

If a test's early signal is dramatically opposite to the predicted-p, do not stop the test. Per the contradiction-aware position, dramatic early signals are usually noise on the holdout side, not signal. The exception: a test that is causing measurable harm (e.g., a switchback's "off" period is correlating with a churn spike); in that case, kill the test and log the kill with the harm citation.

### 5. Run the tests through their validity windows

Each test runs to its declared `validity_window` end date. Do not stop early because the result looks promising. Do not extend because the result looks unclear. Per `goalpost-discipline-vs-metric-drift`, the window is the contract.

If a parallel campaign or seasonality contaminates the test, the spec's "ambiguous resolution" path triggers: resolve AMBIGUOUS, document the contamination, and re-run next quarter.

### 6. Resolve every measurement contract on its declared date

Per the slate, each contract has a `resolution_date`. On that date, run `bin/substrate-goal-resolve <goal-id>` (or its equivalent) against the source-system query. Record verdict (YES / NO / AMBIGUOUS) with the source-system citation. Compute the Brier score against the locked `predicted_p_threshold_met`.

Honest losses count as much as honest wins. A quarter where every prediction resolved YES is a quarter where the predictions were not falsifiable; calibrate accordingly.

### 7. Update the attribution model

Open `clients/<client>/analytics/attribution-model.md`. For each surface that ran a lift test this quarter, compare:

- The attribution model's channel-credit rank (or surface-level lift attribution).
- The lift-test result.

If the model's rank matches the test's rank within 1 position, the model is calibrated; lock for next quarter. If the rank-shift is greater than 1, the model is mis-calibrated; either:

- switch the model (per `attribution-model-design --decision-context exec-attribution`, the candidate is `incrementality-anchored` if the team is willing to commit to quarterly tests),
- audit the data wiring (sources.yaml channel inventory, source-system mapping),
- or accept a higher uncertainty band on the model's outputs and note the rank-shift in next quarter's slate.

The update happens in week 12 of the quarter, before the next quarter's slate is written.

### 8. Write the quarterly summary

Compose a one-page summary at `clients/<client>/analytics/lift-tests/quarterly-summary-<YYYY-Q[1-4]>.md`:

- Slate planned vs slate run (any tests skipped, with reason).
- Per-test result: surface, mode, predicted-p, actual outcome, Brier score.
- Attribution-model calibration status: rank-shift on each tested surface.
- Decisions opened by the test outcomes (the if-yes-we-do-X / if-no-we-do-Y rules from step 1, applied).
- Open questions for next quarter's slate.

The summary feeds the next quarter's planning week. The slate inherits from the summary's open questions.

## Contradiction navigation, short-feedback-vs-long-term-holdouts

The rhythm carries both positions, conditioned per surface:

- **Short-feedback (Position A)** for switchback tests on retention surfaces and switchback paid-ads where the platform allows fast rotation. The rapid loop catches creative fatigue and degraded signal early.
- **Long-window holdout (Position B)** for audience-holdout tests on email lifecycle, paid-ads geo-holdout, and abm. The longer window absorbs noise; short-cycle reads on these surfaces are usually noise on the holdout side.
- **Both, deliberate switch** when a surface has both high-frequency and lifetime-value-shaped metrics (e.g., paid-ads where short-term CTR matters and long-term LTV matters). Run the short-feedback test on the short metric and a long-window holdout on the long metric in parallel; reconcile at quarter close.

The position picked is logged per test in the test spec's frontmatter (`contradiction_positions:`). Pick rationale is logged inline (`position_rationale:`).

## Failure modes the routine prevents

- **Attribution as the only number.** Per `incrementality-not-attribution`, attribution alone is correlation. The rhythm forces measurement quarterly so the correlation gets validated or invalidated.
- **The "we'll test it next quarter" perpetual deferral.** The slate locks before the quarter opens; deferrals are visible.
- **Mid-quarter goalpost drift.** Per `goalpost-discipline-vs-metric-drift`, locking precedes opening. Mid-flight changes are overrides with attribution.
- **Stopping early because the result is encouraging.** The validity window is the contract; the early-stop bias gets a structural fix.
- **Stopping late because the result is disappointing.** The window is also the contract from the other side; sunk-cost bias also gets a structural fix.
- **Tests run without a decision rule.** The if-yes-we-do-X / if-no-we-do-Y rule lives in the slate, before the test runs. Tests without decision rules become entertainment.

## Substrate reads + writes

- Reads: `clients/<client>/analytics/sources.yaml` (channel inventory), `events.yaml` (metric-tree binding), `analytics/metric-tree.yaml` (the leaves the tests measure), `analytics/attribution-model.md` (the model the tests calibrate), prior-quarter `lift-tests/` directory.
- Writes: `clients/<client>/analytics/lift-tests/quarterly-slate-<YYYY-Q[1-4]>.md`, per-test `<surface>-<metric>-<YYYY-Q[1-4]>.md`, `quarterly-summary-<YYYY-Q[1-4]>.md`. `goals/measurement-contracts/<client>-lift-*` (one per test). `goals/ledger.md` updates on resolution.

## Quality criteria

- Refuses to open the quarter without a locked slate.
- Refuses to run a test without a measurement contract under `goals/measurement-contracts/`.
- Refuses to extend a validity window without an explicit override (logged with attribution).
- Refuses to mark the quarter complete if any test's resolution date passed and the contract is unresolved.
- Refuses to mark the quarter complete without an attribution-model calibration step (step 7).

## See also

- `skills/lift-test-design/SKILL.md`
- `skills/attribution-model-design/SKILL.md`
- `skills/metric-tree-design/SKILL.md`
- `skills/ad-incrementality-test/SKILL.md` (sprint-1 reference)
- `routines/analytics-monthly-refresh.md` (monthly companion; feeds the slate's data freshness)
- `routines/retention-monthly.md` (monthly retention companion; one of the surfaces tested)
- `knowledge/patterns/incrementality-not-attribution.md`
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`
- `knowledge/contradictions/short-feedback-vs-long-term-holdouts.md`
- `templates/analytics-sources-example.yaml`
