---
title: substrate health
status: active
last_updated: 2026-04-30
---

# Substrate health

The input quality metric. What fraction of substrate layers are within their decay period and fully populated?

---

## Health score

```
health_score = (current_layers / total_layers) × (populated_layers / current_layers)
```

Where:
- `current_layers` = layers within their decay period (last_updated > today - decay_period)
- `total_layers` = 10 (all defined layers; or 6 if only required layers are counted)
- `populated_layers` = layers that meet their format contract (not stubs)

A score of 1.0 = all layers current and fully populated. A score below 0.70 = the substrate is running hot; assets generated from it carry higher error rates.

---

## Per-client health report format

```
Client: <slug>
As of: YYYY-MM-DD

| Layer | Last Updated | Decay Period | Status | Population |
|---|---|---|---|---|
| positioning | YYYY-MM-DD | 90d | current | full |
| icp | YYYY-MM-DD | 60d | current | stub |
| voc | YYYY-MM-DD | 30d | EXPIRED | - |
| competitive | YYYY-MM-DD | 14d | EXPIRED | - |
| product-knowledge | YYYY-MM-DD | 60d | current | full |
| sales-pitch | YYYY-MM-DD | 30d | current | partial |
| brand-voice | YYYY-MM-DD | 180d | current | full |
| market-context | YYYY-MM-DD | 14d | current | partial |
| roadmap | YYYY-MM-DD | 30d | WARNING (7d) | full |
| strategy | YYYY-MM-DD | 90d | current | full |

Health score: 0.67 (CAUTION — assets from expired layers carry staleness warning)

Expired layers: voc, competitive
Stub layers: icp
Near-expiry (within 7 days): roadmap

Recommended actions:
1. Re-ground voc from last 30 days of reviews + call intel
2. Run competitive scout on primary alternatives
3. Complete icp persona sections
4. Flag active bets citing voc or competitive for operator review
```

---

## Staleness warning on assets

When a generated asset cites a layer that was expired at generation time, the asset carries a staleness warning in its metadata:

```yaml
substrate_staleness_warning: true
stale_layers_cited: [voc, competitive]
operator_acknowledgment_required: true
```

The human review gate requires the operator to explicitly acknowledge the staleness warning before approving the asset. The operator can still ship it, but they know the substrate was stale.

---

## Health check cadence

The substrate-curator agent runs a health check weekly and writes the report to `clients/<slug>/substrate/HEALTH.md`.

The operator reads this before opening new bets for the client. Low health score = fix the substrate before adding more bets, not after.
