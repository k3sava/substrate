---
layer: 3 (voice-of-customer)
client: <project-slug>
last_updated: <YYYY-MM-DD>
freshness_window_days: 30
attribution: self-reported | verified
---

# Voice of customer

The four VoC inputs: case studies + public reviews + sales/CS calls + market research. Sales/CS calls weigh most.

## A. Customer interview summaries

- [`extraction-corpus/<file>.md`](extraction-corpus/) — <description>

## B. Published case studies

- [`<file>`](<path>) — <description>

## C. Public review analysis

- [`g2/`](g2/) — G2 corpus by theme, persona, refusal pattern, displacement.

## D. Win-loss / churn / objection corpora

- [`../04-competitive/loss-corpus.md`](../04-competitive/loss-corpus.md) — recent lost deals.
- [`churn-themes.md`](churn-themes.md) — churn signal feed.
- [`product-feedback.md`](product-feedback.md) — feature requests by category.

## E. Sales + CS call analysis

- [`call-intelligence-debriefs/`](call-intelligence-debriefs/) — per-cycle call-intel summaries.

## F. Buyer personas

- [`../personas/`](../personas/) — system-shared persona axes.
- [`../02-icp.md`](../02-icp.md) — ICP from closed-won.

## G. Vertical-specific VoC

- [`by-vertical/<vertical>.md`](by-vertical/) — vertical pain corpora.

## Key gaps + recommendations

- <gap 1> — recommend <action>.
- <gap 2> — recommend <action>.
