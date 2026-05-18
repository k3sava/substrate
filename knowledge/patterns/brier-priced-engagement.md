---
id: pat_brier-priced-engagement
title: Brier-priced engagement — the operator opens with a calibrated probability and prices the bet
captured_date: 2026-05-18
convergence_count: 3
tier: A
uses_cards: [ins_kesava-brier-bonus-structure, ins_tetlock-superforecasting, ins_substrate-calibration-doctrine]
domains: [consulting-pricing, calibration, forecasting, anti-fabrication]
---

# Brier-priced engagement

## Convergence

Three sources converge on a specific pricing structure for outcomes-based engagements: the operator opens the engagement by stating their calibrated probability that the metric hits target. The variable component of the fee is paid against the accuracy of that calibration, not just the metric outcome. A correct high-confidence prediction pays full bonus. A wrong call pays zero variable (the floor is the floor). A correct low-confidence prediction pays partial. The unit of operator credibility is the Brier history, not the resume.

## Operators

- **Kesava Mandiga**, `canonical/portfolio-consulting-offer.md`. Phase 2 published structure includes the Brier-bonus as one of three variable options. "I open the engagement with a calibrated probability that the metric hits target. If I'm right with high confidence, full bonus. If I'm wrong, the floor is the floor. Same primitive substrate uses to score every operator." First engagement runs at internal rate while the public Brier history opens; the published track record begins at first engagement closure. `ins_kesava-brier-bonus-structure`.
- **Philip Tetlock**, *Superforecasting: The Art and Science of Prediction* (Crown, 2015) and the Good Judgment Project. Decade-long empirical study: forecaster accuracy is dramatically improvable through calibrated probability training; the Brier score is the gold-standard metric for accuracy (combining calibration and discrimination); top forecasters consistently outperform domain experts by maintaining honest uncertainty and updating on evidence. The operator-as-forecaster framing is direct: a consulting engagement is a prediction about an intervention's effect on a metric, scored at a window. `ins_tetlock-superforecasting`.
- **Substrate calibration doctrine**, `~/r2d2/substrate/PRINCIPLES.md` and `goals/ledger.md`. Every substrate goal opens with a measurement contract: metric, source, baseline, window, predicted confidence; closes with a Brier score. This is the calibration substrate the engagement-pricing skill inherits. The operator's own ledger is the input to the variable structure. `ins_substrate-calibration-doctrine`.

## Variation

- Kesava provides the *engagement-pricing version*: the calibration is priced. The variable amount paid depends on (a) whether the metric hit and (b) how confident the operator was about it.
- Tetlock provides the *empirical basis*: calibration is measurable, trainable, and predictive. Brier-trained forecasters beat domain experts; the Brier score discriminates honest probability from confident-sounding noise.
- Substrate's own doctrine provides the *operational substrate*: every goal carries a Brier-scorable prediction; the operator's history is a public record; calibration is the unit of trust.

## Implication

A Brier-priced engagement requires:

1. **An opening prediction.** Stated before the engagement starts: "I am 70% confident this intervention moves [metric] from [baseline] to [target] by [window]." Recorded in `clients/<prospect>/measurement-contract.md` and `goals/ledger.md`.
2. **A measurement contract.** Per `pat_outcomes-tied-pricing`: metric named, source-of-truth named, baseline timestamp recorded, window agreed, verification path agreed.
3. **A scoring rule.** Brier score = (probability_predicted − outcome_actual)². Lower = better. The variable payout function is a step or sigmoid against the Brier score; encoded in the engagement contract.
4. **A public track record.** After the first engagement closure, the operator's Brier history is published. Prospects can audit the operator's calibration. Hidden track records are refused under `pat_anti-fabrication-on-prospects`-style discipline (the operator's calibration is the operator's claim about themselves; unverifiable claims aren't shipped).
5. **First-engagement exception.** Before the public Brier history opens, the operator runs at internal rate; the variable pays floor only. This is the calibration-bootstrapping period. Specified explicitly in the operator's offer.

## What this pattern is NOT

- **Not "consultant guarantees outcomes."** The operator does not guarantee the metric hits. The operator commits to being calibrated about it. A 70% prediction that doesn't hit isn't a failure of the consultant — it's a 30% outcome materialising. The variable structure rewards calibration, not just outcome.
- **Not commission-only.** The floor remains (per `con_floor-as-draw-vs-floor-as-retainer`). The Brier-bonus is the variable component, not the entire fee.
- **Not for every engagement.** Brier-bonus is one of three variable structures. % of attributable lift and per-unit bonus are the alternatives. The right structure depends on the metric, the window, and the operator-prospect trust history.
- **Not the operator betting against the client.** Both parties want the metric to hit. The Brier-bonus aligns the operator's confidence honesty with the client's outcome interest.

## Stops applying when

- The metric has no clean source-of-truth pull at the window (the Brier score can't be computed; fall back to per-unit bonus).
- The operator's confidence is genuinely 50/50 (the Brier-bonus structure punishes mid-confidence; pick % of attributable lift or per-unit instead).
- The prospect demands a hidden Brier history (refuse the engagement; hidden track records violate the substrate's anti-fabrication rule).

## See also

- `canonical/portfolio-consulting-offer.md` — the canonical source
- `pat_outcomes-tied-pricing` — the parent pattern
- `goals/ledger.md` — the substrate's Brier history (operator's own track record)
- `~/r2d2/substrate/PRINCIPLES.md` — the calibration doctrine substrate operates under
- `con_floor-as-draw-vs-floor-as-retainer` — the floor's status alongside the Brier-bonus
- `pat_anti-fabrication-on-prospects` — sibling discipline; hidden tracks are refused both ways
