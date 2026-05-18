---
title: measurement contracts
status: active
last_updated: 2026-05-08
---

# Measurement contracts

A measurement contract is the falsifiable form of a goal that a skill emits. Each contract is a complete goal candidate, ready to be opened via `bin/substrate open-goal`.

Contracts are written here by skills that allocate resource decisions to predicted outcomes:

- **`ad-spend-allocate`** writes one contract per channel allocation (`<client>-<channel>-<quarter>.md`). Each contract carries the channel's predicted CAC, predicted volume, predicted ROAS, and a kill criterion.

The format follows `goals/SCHEMA.md`. The contract has frontmatter with goal_id, client, opened_at, status (`proposed`), resolution_date, predicted_p, and substrate citations. The body has hypothesis, predicted_outcome, revenue_lever (with calculation), measurement_design, kill_criterion, and substrate update.

## Folder layout

- `<client>-<channel>-<quarter>.md` — paid-ads channel-level measurement contracts.
- `<client>-<asset-id>-<date>.md` — asset-level measurement contracts (lp-ship, etc.; future).

Contracts are committed when an operator promotes them from `proposed` to `open` via `bin/substrate open-goal`. Generated contracts in proposed state can stay local; the operator decides which become first-class goals on the ledger.

## What this folder is not

- Not a state store. The canonical state of an open goal is `goals/ledger.md`.
- Not a calibration history. That is `data/calibration-schema.sql`.
- Not the place to author goals from scratch. Use `bin/substrate open-goal` for that.
