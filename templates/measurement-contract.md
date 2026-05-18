---
goal_id: <client>-<scope>-<window>
client: <client-slug>
opened_at: <YYYY-MM-DD>
opener: <skill-name or operator-name>
taste_owner: <operator-name>
status: proposed
taste_type: <demand-gen | conversion | positioning | competitive | aeo-seo | ...>
resolution_date: <YYYY-MM-DD>
predicted_p_threshold_met: <0.0 - 1.0>
substrate_layers_cited: [<layer-1>, <layer-2>, ...]
patterns_applied: [<pattern-slug>, ...]
---

# <Client> | <scope> | <window>

## Hypothesis

<One paragraph. The specific claim being tested. Names: the mechanism (why this should work), the evidence (what substrate supports it), and the counterfactual (what happens if it doesn't).>

Substrate citations: `<path/to/01-position.md>`, `<path/to/02-icp.md>`, ... .

## Predicted outcome

<Metric direction threshold within window for cohort.>
Example: "channel CAC <= $4,000 within 2026-Q3 for interest-stage cohort."

## Revenue lever

```yaml
lever_type: <CW-pipeline | retention-MRR | expansion-ARR | acquisition-CPL | conversion-rate-uplift | cycle-time-shorten | deflection-cost-save>
annual_revenue_impact_usd: <integer | range "X-Y" | null with reason>
calculation: |
  <The math. Inputs (each cited to a source-system path or substrate file),
  assumptions (each named with rationale), and the output dollar number.>
```

## Measurement design

```
Source: <named source system>.
Method: <exact measurement, including the join key>.
Cohort: <ICP slice>, defined per <substrate path>.
Ambiguous case: <how to handle data-quality failure>.
```

## Kill criterion

<Explicit condition that closes the goal early. Example: "channel CAC > 1.5x target_max_cac for 14 consecutive days.">

## Resolution

Resolves on <YYYY-MM-DD>. Verdict: YES if <metric meets threshold>; NO if not; AMBIGUOUS if data quality fails.

Brier score = (predicted_p_threshold_met - indicator)^2 where indicator is 1 if YES, 0 if NO.

## Substrate update on resolution

- If YES: <what gets confirmed / persisted in the substrate>.
- If NO: <what diagnostic gets opened, what layer gets re-checked>.
- If AMBIGUOUS: <what data gap gets named for the next round>.
