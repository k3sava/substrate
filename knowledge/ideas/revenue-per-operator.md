---
title: revenue per operator
status: active
last_updated: 2026-05-04
---

# Revenue per operator

The unit the system optimizes for. Not headcount. Not output volume. Not engagement. Not impressions.

Revenue per operator-hour is the metric. It's the value created divided by the time invested. The framing comes from the **Economic Turing Test** — what would a market-rate contractor charge to produce the equivalent output?

## The math

Per goal:

```
ETT_value = market_rate_cost_of_work × (1 - operator_time_fraction)
```

Where:
- `market_rate_cost_of_work` = what a contractor would charge to produce the equivalent output. Sourced from rate cards, not made up.
- `operator_time_fraction` = the fraction of total time the operator personally spent (vs. the system + context).

Example: a landing page that would cost $3,000 from a copywriter takes 2 hours of operator time (the position decision, the gate approval) and 6 hours of context + skill time. Operator time fraction = 0.25. ETT_value = $3,000 × 0.75 = $2,250 per goal.

Sum ETT_value across all resolved goals in a quarter, divide by operator hours in the quarter, and you have revenue per operator for that quarter.

## Why this and not vanity metrics

Activity metrics (drafts shipped, campaigns launched, content pieces published) reward volume. Volume can move without value moving. A team that ships 100 pieces of content with no resolved goals has a high activity metric and a low revenue per operator.

Engagement metrics (page views, opens, clicks) reward attention. Attention can move without revenue moving. A campaign that gets 10x the page views but doesn't change pipeline is engagement-positive and revenue-neutral.

Revenue per operator forces both: the value created has to map to a market rate someone would actually pay, and the operator time has to be tracked honestly. Neither is easy to fake.

## What this kills

Activity dashboards that look good and move nothing in the business. If the metric on the dashboard isn't revenue per operator, the dashboard is a proxy. Proxies are fine for diagnosis. They're never fine for direction.

## Capacity expansion, not headcount contraction

The framing isn't "do more with fewer people." It's "the same people do materially more." Context compounds. Output per operator-hour rises. Revenue per operator rises. The team gets more capacity, not less of itself.

This is the only honest version of the AI-and-marketing argument. Anything else is a layoff pitch in a system trench coat.

## How it ties to context

The thesis is that context is the multiplier. Revenue per operator is how you measure whether the thesis is true. If context is doing what it claims, revenue per operator rises across quarters as the context layer thickens. If it isn't, the context isn't actually compounding — something else is going on.

The metric is the receipt for the claim.
