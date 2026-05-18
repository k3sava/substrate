---
name: sales-trigger-event-watch
description: Monitor target accounts for trigger events (funding, exec hires, product launches, layoffs, acquisitions, tech-stack shifts). Reads RSS / news feeds / company pages, writes daily triggers file with account + event + recommended action.
version: 0.1
amplifies: SDR manager, ABM lead, AE, demand-gen
masters: Aaron Ross (Predictable Revenue, "Cold Calling 2.0"), Jeb Blount (relevance window), Becc Holland (event-based personalization), Sam Nelson (multithread on trigger), Sangram Vajre (account-as-unit)
substrate_layers_required: [icp]
patterns_grounded: [trigger-events-beat-cadence-blast, account-not-lead-as-unit]
contradictions_aware: [outbound-vs-inbound-budget]
preflight_refusal: substrate-gap, missing-target-accounts
required_reads:
  - clients/{client}/sales/target-accounts.csv
---

# sales-trigger-event-watch

## Purpose

Detect trigger events for a watched account list. Each event creates a recommended action and a 60-90 day pursuit window. The output triggers file is consumed by `abm-account-prioritize` (recency feature) and `outbound-sequence-design` (Setup phase content).

## Inputs

- `--client <client>` (required)
- `--accounts <path>` (optional) — defaults to `clients/<client>/sales/target-accounts.csv`
- `--mode rss|news-api|company-pages|all` (optional, default `all`)
- `--feeds <path>` (optional) — path to feeds.yaml; defaults to `clients/<client>/sales/feeds.yaml`
- `--lookback-days <int>` (optional, default 30)
- `--dry-run` — print findings, don't write triggers file
- `--output <path>` — override default output

## Trigger types detected

| Type | Window | Source signal | Recommended action |
|---|---|---|---|
| funding | 60d | press release / Crunchbase / domain RSS / news | Multithread CFO + COO + relevant exec |
| exec-hire | 90d | LinkedIn news / press release / company news | Reach the new exec in week 2-4 |
| product-launch | 30d | company blog / changelog / press | Reach with a "stack-fit" angle |
| layoff | 60d | press / WARN-act listings / Layoffs.fyi | Reach lightly; sensitivity required |
| acquisition | 120d | press / Crunchbase / news | Reach about consolidation, integration |
| tech-change | 60d | BuiltWith / job post / signal feed | Reach on stack rationalization |

## Substrate reads

- `clients/<client>/sales/target-accounts.csv` — account watchlist (must include `company` and ideally `domain` columns)
- `clients/<client>/sales/feeds.yaml` — RSS / news API endpoints to watch (optional)
- `clients/<client>/icp/00-INDEX.md` — to filter "interesting" triggers vs noise

## Process

1. Preflight: validate target accounts list exists.
2. For each account: check configured feeds for matches in lookback window.
3. Classify each finding by trigger type using keyword + URL pattern detection.
4. Score significance: high (multi-source confirmation, primary source) | medium (single source) | low (noise).
5. Write daily triggers file at `clients/<client>/sales/triggers/<date>.md`.
6. Each trigger entry: `account | event | date | summary | source-url | significance | recommended-action`.
7. Append rolling index at `clients/<client>/sales/triggers/INDEX.md`.

## Output contract

```
clients/<client>/sales/triggers/<YYYY-MM-DD>.md
```

Format (one trigger per line, pipe-delimited for easy parsing):

```markdown
---
asset_type: trigger-events-feed
client: <client>
date: <YYYY-MM-DD>
lookback_days: 30
total_triggers: <count>
high_significance: <count>
---

# Trigger events — <YYYY-MM-DD>

## Summary

<count high>, <count medium>, <count low>. Top accounts in window: <list>.

## Triggers

- account: <Company> | event: <type> | date: <YYYY-MM-DD> | source: <url> | significance: <level> | summary: <one-line> | action: <recommended>
- account: <Company> | event: <type> | date: <YYYY-MM-DD> | source: <url> | significance: <level> | summary: <one-line> | action: <recommended>
...

## Per-account breakdown

### <Company>
- <date>: <event-type> — <summary> [source]
- <date>: <event-type> — <summary> [source]
```

## Quality criteria

- Refuses without target accounts list.
- Each trigger entry must include source URL (for SDR verification before send).
- Triggers older than 90 days are flagged as "stale" and demoted to significance: low.
- High-significance requires either: (a) primary source (company press release, official blog) OR (b) two independent secondary-source confirmations.
- A trigger without an account match in the watchlist is dropped (not appended to "watch later" — keeps file small).

## Refusal patterns

- Target accounts CSV missing → refuse, no triggers file written.
- Feeds.yaml missing → soft warn, run with default heuristic feeds (Google News for company name).
- Account list >5000 → refuse without `--force`; the watch architecture is for tiered ABM, not blanket monitoring.

## What this skill does NOT do

- Does NOT execute outreach. The trigger feeds the cadence; the SDR sends the touches.
- Does NOT score account fit. That's `abm-account-prioritize`.
- Does NOT compose copy. That's `outbound-sequence-design`.

## See also

- `skills/abm-account-prioritize/` — reads triggers file for recency feature.
- `skills/outbound-sequence-design/` — reads triggers for Setup phase anchoring.
- `skills/account-pursuit-rhythm/` — uses trigger windows to time cadence intensity.
- `skills/competitive-scout/` — sister skill for competitor (not target account) monitoring.
- `routines/sales-trigger-routine.md` — daily scheduler for this skill.
- `knowledge/patterns/trigger-events-beat-cadence-blast.md`.
