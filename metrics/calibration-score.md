---
title: calibration score (Brier)
status: active
last_updated: 2026-04-30
---

# Calibration score

Brier score per operator per taste-type. Measures the accuracy of probabilistic predictions.

---

## Formula

```
Brier_score = (predicted_p - indicator)^2
```

Where:
- `predicted_p` = the operator's stated probability that the predicted_outcome would be met (from the bet's `predicted_p_threshold_met` field)
- `indicator` = 1 if the outcome was met (YES), 0 if not (NO)

Lower is better. 0.0 is perfect calibration. 1.0 is maximally wrong.

**Example:** operator predicted 0.65 probability of YES. Outcome was YES. Brier = (0.65 - 1)^2 = 0.1225. Good.

**Example:** operator predicted 0.65 probability of YES. Outcome was NO. Brier = (0.65 - 0)^2 = 0.4225. Poor.

---

## What good calibration looks like

A well-calibrated operator, when they say something has a 70% chance of happening, should be right about 70% of the time. Not 90%. Not 50%. 70%.

Brier score below 0.25 averaged across 10+ bets = well-calibrated on that taste-type.

Brier score above 0.33 = systematic miscalibration. The operator is either overconfident or underconfident. Worth examining which direction.

---

## Per taste-type

Calibration is not operator-wide. It is per taste-type. An operator may be well-calibrated on competitive-intel bets (Brier 0.12) and poorly calibrated on demand-gen bets (Brier 0.41). This is routing data, not a performance review.

Routing implication: competitive-intel bets get opened and closed on the well-calibrated operator's judgment. Demand-gen bets get higher-scrutiny preflight and a conservative predicted_p until calibration improves.

---

## The Brier table

Per client and globally:

| operator | taste_type | n_bets | mean_brier | last_10_brier | trend |
|---|---|---|---|---|---|
| (empty) | | | | | |

Trend is UP (getting worse), DOWN (improving), or FLAT.

---

## What Brier scoring does NOT do

- Penalize an operator for uncertain predictions. If the true probability is 0.5, the optimal prediction is 0.5. The system rewards honest uncertainty over false confidence.
- Measure impact (a well-calibrated bet that resolved YES may have had small impact; a poorly-calibrated bet that resolved NO may have been a high-impact swing). Calibration and impact are separate questions.
- Replace judgment. The Brier score is a trend signal over many bets. It does not tell you what to do on the next bet.
