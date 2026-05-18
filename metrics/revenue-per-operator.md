---
title: revenue per operator
status: active
last_updated: 2026-04-30
---

# Revenue per operator

The north star metric. Source: Benjamin Mann's Economic Turing Test framing (Anthropic, Lenny's Podcast 2026-01-15).

---

## The computation

```
ETT_value_per_bet = market_rate_cost_of_work × (1 - operator_time_fraction)
revenue_per_operator = sum(ETT_value, resolved_bets) / operator_hours_in_period
```

**market_rate_cost_of_work:** what a contractor would charge to produce an equivalent output. Source this from a rate card, not intuition.

Example rate card (generic, verify against market):
- Landing page copy: $1,500 - $4,000
- Email sequence (5 emails): $800 - $2,000
- Battlecard: $500 - $1,500
- One-pager (forwardable): $750 - $2,000
- Competitive analysis: $2,000 - $5,000
- Positioning document: $3,000 - $8,000

**operator_time_fraction:** the fraction of the total time the operator personally spent (vs the substrate + agents). Track this honestly. If the operator spent 2 hours on a piece of work that took 8 hours total (including agent runs), operator_time_fraction = 0.25.

**ETT_value:** `$3,000 × (1 - 0.25) = $2,250` for that bet.

---

## Why this metric and not another

Because it is hard to game. You cannot inflate it by shipping more mediocre assets. A poorly-targeted landing page that nobody clicks has a low market_rate (it is not worth much) and the operator still spent time on it. The ETT_value is low.

You can inflate it by doing high-value work efficiently. A positioning document that the operator could have spent 40 hours on but produced in 8 hours with the substrate — that has a high market_rate and a low operator_time_fraction. The ETT_value is high.

This is what the Rory Woodbridge operating model produces: fewer assets, higher value, more defensible.

---

## How to track it

Per bet, at resolution:

```yaml
ett_value:
  market_rate_estimate: <float, USD>
  market_rate_source: <rate card reference>
  operator_hours_invested: <float>
  agent_hours_estimated: <float>
  operator_time_fraction: <float 0.0-1.0>
  ett_value_usd: <float>
  confidence: HIGH | MEDIUM | LOW
  notes: |
    [Any adjustments or explanations]
```

Aggregate these at the period level (monthly, quarterly) to compute revenue per operator.

---

## The honest read on v0.5

substrate v0.9 computed one ETT number (homepage-wedge bet, ~$11,880) at A-minus confidence. That is one data point. substrate is designed to produce this number on every resolved bet, building a track record that is genuinely computable rather than illustrative.

One number is a demo. Thirty numbers is a trend. Ninety numbers across multiple clients is the multi-client substrate value.

---

## Client-level vs operator-level

The metric is at the operator level, not the client level. It aggregates across all clients. An operator with three engagements should compute their revenue_per_operator across all three — that is the real output of the practice.

Per-client ETT tracking is still useful for client ROI conversations. But the cross-functional GTM operator's north star is their own output rate, not any single client's campaign performance.
