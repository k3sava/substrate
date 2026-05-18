---
title: accuracy scoring
status: active
last_updated: 2026-05-04
---

# Accuracy scoring

Every goal opens with a confidence number — a probability between 0 and 1 that the goal will resolve as predicted. When the goal resolves, the difference between the prediction and the outcome scores. Over time, the ledger of (operator, taste-type, score) becomes the accuracy record.

The technical name for this scoring method is the **Brier score**. The math is simple; the discipline is hard.

## The math

```
score = (predicted_probability - actual_outcome) ²
```

`actual_outcome` is 1 if the goal resolved as predicted, 0 if not. `predicted_probability` is the number the operator wrote when the goal opened.

Examples:

- Predicted 0.8, resolved as predicted (1). Score = (0.8 - 1)² = 0.04. Good.
- Predicted 0.8, resolved against (0). Score = (0.8 - 0)² = 0.64. Bad.
- Predicted 0.5, resolved either way. Score = 0.25. Honest about uncertainty.
- Predicted 0.95, resolved against (0). Score = 0.9025. Overconfident.

Lower scores are better. A score under 0.25 over many resolved goals means the operator's confidence numbers are well-calibrated.

## Why this and not "win rate"

Win rate doesn't reward honesty about uncertainty. An operator who predicts 0.95 on every goal and wins 90% of them has a great win rate (90%) and a terrible accuracy score (heavily punished by overconfidence on the misses). An operator who predicts 0.6 on goals they're 60% sure about has a worse win rate but a much better accuracy score.

The system rewards calibration, not confidence. People who know what they don't know score better than people who claim to know everything.

## How to use it

When a goal opens, write a number from 0 to 1 for `predicted_p`. Be honest. The accuracy score punishes overconfidence harder than it punishes underconfidence, so when in doubt, write 0.5.

When a goal resolves, the closing step computes the score and updates the ledger.

The ledger groups by (operator, taste-type). After three or more resolved goals in a taste-type, the operator's average score on that taste-type is meaningful. Below that, treat it as early signal.

## Routing decisions follow accuracy

Per the principles, authority on a craft cell goes to the operator with the best accuracy score on that cell, regardless of org chart. The ledger is institutional memory. The accuracy score is the receipt for taste over time.

This is not a political move. It's arithmetic.

## What this kills

The loudest voice in the room setting direction on draft types where they have no tracked record. The ledger replaces "I've been doing this for years" with "you've resolved N goals on this taste-type with score X."
