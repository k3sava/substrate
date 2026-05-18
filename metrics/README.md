---
title: metrics
status: active
---

# Metrics

substrate has three load-bearing metrics. They compose into one picture.

## Revenue per operator

The north star. How much economic value does the operator produce per hour spent?

Computed from ETT (Economic Turing Test) values across resolved bets divided by operator hours in the period.

Full spec: `revenue-per-operator.md`

## Calibration score (Brier)

The accuracy of the operator's predictions. Per taste-type. Computable after each resolution.

Full spec: `calibration-score.md`

## Substrate health

What fraction of substrate layers are within their decay period and fully populated. The input quality metric.

Full spec: `substrate-health.md`

---

## What is not a metric in substrate

- Assets shipped per week (volume, not quality)
- Bets opened per month (activity, not outcomes)
- Preflight pass rate (a diagnostic, not a north star)
- Campaign impressions, CTR without conversion (proxies without substrate linkage)

These can be computed and are useful for diagnosis. They are not in the metrics directory because they are not the north star and treating them as such produces the wrong behavior.
