---
title: knowledge freshness
status: active
last_updated: 2026-05-04
---

# Knowledge freshness

Context goes stale. A six-month-old ICP that nobody updated is worse than no ICP — the system runs on it and produces confident wrong answers.

Each context layer carries a **freshness window**. When the window expires, the layer is flagged. Drafts that cite an expired layer carry a staleness warning. The operator has a choice: refresh the layer or suspend the goals that depend on it.

## Default freshness windows

| Layer | Window | Why |
|---|---|---|
| Position | 90 days | Position should be stable. Anything tighter triggers thrash. Anything looser misses category shifts. |
| ICP | 60 days | The buyer base shifts faster than position. Quarterly is too slow; bi-monthly catches drift. |
| Voice of customer | 30 days | The freshest claims age fastest. Last quarter's quotes are not last week's quotes. |
| Competitive | 30 days | Competitors ship. Pricing changes. Tighter window than ICP. |
| Product knowledge | 30 days | Product ships. The marketing team is often the last to know. |
| Conversion narrative | 60 days | Slower than messaging; faster than position. |
| Brand voice | 90 days | Slow layer. Voice rules don't change weekly. |
| Market context | 21 days | Fastest layer. Search trends, AI-citation patterns, and analyst notes all move week-over-week. |
| Roadmap | 14 days | The fastest formal layer. Roadmaps slip. Ship dates shift. |
| Strategy | 90 days | Slowest layer. Quarterly check-in is right. |

These are defaults. Each project can override per-layer based on observed drift.

## How freshness checks run

The weekly knowledge check (a routine) sweeps every project's `00-INDEX.md`, computes age against `last_updated` for each layer, and writes a flag file at `<project>/00-HEALTH.md` listing expired layers.

When a skill reads a layer that's past its window, the skill emits a staleness warning into the draft's gate report. Reviewers see the warning before approving.

## What stale context looks like

- A position statement that doesn't mention the category's new entrant.
- An ICP that still references "small teams in growth mode" when half the won-deal pattern shifted to mid-market over the last quarter.
- Voice of customer that quotes a feature that shipped a year ago.
- Competitive that lists a competitor at a price point they raised three months back.
- Product knowledge that describes a flow the team rebuilt last month.

Every one of these has produced a confident-wrong draft at least once. The freshness window is the cost the system pays to avoid that.

## Refresh, don't extend

When a window expires, the right move is to refresh the layer, not to extend the window. Extending the window is the system pretending the layer is fresher than it is.
