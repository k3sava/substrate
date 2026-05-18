---
id: pat_churn-prediction-vs-churn-diagnosis
title: Diagnose churn before predicting it
captured_date: 2026-05-08
convergence_count: 3
tier: A
domains: [customer-success, retention, product, data-science]
---

# Diagnose churn before predicting it

## Convergence

Three operators with very different vantage points (academic loyalty research, SaaS pricing data at scale, B2B SaaS analytics commentary) converge on the same operating order: a model that predicts which account will churn is much less actionable than a diagnosis of WHY accounts in a cohort churn. Diagnose first, predict second. Many teams reverse the order, build a churn-prediction model, and then act on individual accounts without understanding the population-level driver, which produces save-call programs that fight symptoms while the underlying cause keeps generating churn at the same rate.

The convergence is about *order* and *unit of action*. Diagnosis operates on cohorts (what is the dominant driver across this group), is addressable with product, pricing, ICP, or onboarding changes, and reduces churn at the source. Prediction operates on accounts (which one is leaving), is addressable with intervention (save calls, discounts), and at best slows the leak without fixing the hole. A well-functioning retention program does both; teams that do only prediction operate on guess-substrate.

## Operators

- **Tomasz Tunguz**, Theory Ventures. Posts on cohort retention and SaaS unit economics consistently treat churn-driver diagnosis (acquisition channel quality, ICP fit score, feature adoption, onboarding completion) as the upstream variable, with churn-prediction models as a downstream-only signal that is silent on what to fix. The prediction model tells you a customer is leaving; the diagnosis tells you why customers like that one keep being acquired and keep leaving.
- **Patrick Campbell**, ProfitWell / Paddle. The retention research, conducted across thousands of SaaS companies, isolates churn drivers (price sensitivity, value-realization gap, ICP misfit, onboarding incompleteness) at the cohort level. Campbell's argument: churn prediction tools were oversold in 2018-2022 because they were marketed as the solution; the actual lift came from the analytics work that exposed *why* a population was churning, which then informed product, pricing, and ICP changes. Once those changed, prediction was fine but secondary.
- **Frederick Reichheld**, Bain & Company, NPS originator. The Loyalty Effect (1996) and subsequent NPS research argue that churn is a symptom of an upstream loyalty deficit, and that the work to address loyalty is structural (product, brand, customer-experience design), not interventional (save calls). Reichheld's frame predates SaaS but the through-line is identical: addressing why customers leave at the population level produces durable lift; addressing one departing customer at a time produces a treadmill.

## Variation

- Tunguz frames it through *SaaS analytics math*: prediction without diagnosis is silent on the lever.
- Campbell frames it through *empirical retention research*: the cohort-level driver is where the lift comes from.
- Reichheld frames it through *loyalty theory*: churn is a symptom of an upstream loyalty system.
- Convergence: the unit of action for retention work is the cohort and its driver, not the individual account.

## Implication

Build the diagnosis before the prediction. The diagnosis artifact ranks drivers of churn across a churned-accounts population by *coverage* (what fraction of churns this driver explains) times *addressability* (whether product / pricing / ICP / onboarding can move it). The output is a ranked list of drivers with proposed interventions per driver, not a list of accounts at risk.

A churn-prediction model is acceptable as a *secondary* tool, scoped to deciding which accounts get a high-touch save call versus a low-cost in-product save attempt. It is unacceptable as a *primary* retention investment, because the dollars spent on the model do not address the underlying driver, and the same population continues to churn at the same rate after every model retrain.

Retention skills that touch churn must declare which they are: diagnosis or prediction. A skill that mixes both must run diagnosis first and condition prediction on the cohort the diagnosis names.

## Sources

- Tomasz Tunguz, "The five most important questions in SaaS analytics" and follow-up posts on cohort-based churn driver analysis, tomtunguz.com.
- Patrick Campbell, ProfitWell research on retention drivers (priceintelligently.com / Paddle / Recur Now), 2018-2024 multi-year studies.
- Frederick Reichheld, "The Loyalty Effect" (Harvard Business School Press, 1996); "The Ultimate Question 2.0" (NPS / loyalty-system research).
