---
title: cohort retention table — example output
status: template
last_updated: 2026-05-08
patterns_grounded: [retention-cohort-curves-over-blended-rates, aha-moment-defines-activation]
---

# Cohort retention table — example output

This is the canonical shape of `retention-cohort-analysis` output. The skill writes a markdown summary file in this shape plus a CSV companion (`cohort-retention-<window>-<date>.csv`) for plotting.

Reading order: rows are signup cohorts (week or month), columns are weeks since signup, cell is the percentage of the cohort still active in that week (active = at least one `session_active` event in the rolling 7-day window ending at the cell's week).

## Cohort retention by signup week — `<your-product>` — generated 2026-05-08

Source: `clients/<your-product>/events/exports/2026-04.csv` (rows: 12,438; ingested 2026-05-08)

Active definition: at least one `session_active` event within the 7-day window ending at week N from signup.

Activation event (per `activation-funnel-audit` output): `first_value_event` within 24 hours of signup.

| Cohort (signup week) | n | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W12 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2026-W09 | 312 | 78% | 64% | 56% | 51% | 48% | 46% | 45% | 44% | 41% |
| 2026-W10 | 287 | 76% | 62% | 54% | 49% | 46% | 44% | 43% | 42% | — |
| 2026-W11 | 341 | 80% | 65% | 57% | 52% | 49% | 47% | 46% | — | — |
| 2026-W12 | 298 | 75% | 60% | 51% | 46% | 43% | 41% | — | — | — |
| 2026-W13 | 322 | 71% | 56% | 47% | 41% | 38% | — | — | — | — |
| 2026-W14 | 305 | 69% | 53% | 44% | 38% | — | — | — | — | — |
| 2026-W15 | 318 | 67% | 51% | 41% | — | — | — | — | — | — |
| 2026-W16 | 290 | 65% | 48% | — | — | — | — | — | — | — |

## Headline

W4 retention has decayed from 51% (W09 cohort) to 38% (W13 cohort), a 13-point drop over five weeks of acquisition. The slope-change detector flags W13 onward as the regression cohort.

## Cohort comparison split by activation

Same cohorts, split into "activated within 24h" and "did not activate":

| Cohort | Activated W4 | Not-activated W4 | Activation rate |
|---|---:|---:|---:|
| 2026-W09 | 73% | 18% | 64% |
| 2026-W10 | 71% | 17% | 62% |
| 2026-W11 | 75% | 19% | 60% |
| 2026-W12 | 70% | 16% | 54% |
| 2026-W13 | 68% | 14% | 48% |
| 2026-W14 | — | — | 45% |
| 2026-W15 | — | — | 43% |
| 2026-W16 | — | — | 41% |

The activated population's retention is stable across cohorts (W4: 68-75%). The retention drop is driven by the activation rate falling from 64% (W09) to 41% (W16), 23 points lost. The product is retaining the activated user the same as before; the funnel is failing to activate as many.

## Cohort comparison split by signup source

W4 retention by source for cohort 2026-W12:

| Source | n | W4 retention |
|---|---:|---:|
| referral | 84 | 58% |
| organic | 96 | 47% |
| paid-search | 118 | 33% |

Paid-search is dragging the blended W4 down. The referral cohort retains at near-double the rate of paid-search.

## Slope-change detection (compared to 4-cohort baseline)

The detector compares each cohort's W4 retention to the trailing 4-cohort mean. A drop greater than 1.5 standard deviations triggers a regression flag.

- 2026-W09 to 2026-W12: stable around 49% mean.
- 2026-W13: 38%, 2.1 SD below baseline. Regression flag.
- 2026-W14, W15, W16: continued slide, slope-down trend confirmed.

Probable causes (read from `clients/<your-product>/events/exports/`): paid-search cohort grew from 31% of acquisition (W09) to 47% (W16). The acquisition mix shifted toward the worst-retaining channel.

## Recommended next reads

- `skills/activation-funnel-audit/` to diagnose why activation rate fell from 64% to 41%.
- `skills/churn-diagnose/` against the W13-W16 cohorts to surface the dominant churn driver.
- `clients/<your-product>/icp/icp.md` to verify whether the paid-search expansion is reaching ICP-fit accounts or non-ICP.
- `routines/retention-monthly.md` to schedule the next read.

## Computation notes

- Weeks since signup are computed in 7-day buckets from the signup timestamp, not calendar weeks.
- A user is "active in W_n" if any `session_active` event lies within `[signup_ts + 7*(n-1), signup_ts + 7*n)`.
- Cohort cells with fewer than 30 users are marked early-signal and not used for slope-change detection.
- Trailing baseline is the mean of the four prior cohorts. SD is the population SD across the same window.
