---
name: aeo-manual-action
description: Track off-domain mentions of the client across G2 / Trustpilot / Reddit / Hacker News / X-Twitter / blog mentions / YouTube / podcasts. Real RSS / search-query parsing. Reads `clients/<client>/aeo/sources.yaml` for the named monitor list. Outputs a density + sentiment report and a propagation plan. Closes the third leg of the AEO triangle — propagation. AEO is decided off your domain.
version: 0.3
amplifies: PMM, growth lead, content lead, founder, AEO operator
masters: Brendan Hufford (AEO is decided off your domain; third-party mention density is the missing surface), Aleyda Solis (manual-action propagation as the third leg), Lily Ray (citation rotation makes snapshots noisy; persistent off-domain presence holds), Amanda Natividad (zero-click + earned channels), Eli Schwartz (community-built relevance signal), Glenn Gabe (manual actions propagate), Kevin Indig (citation-vs-mention gap)
substrate_layers_required: [positioning, voc, market-context, distribution]
patterns_grounded: [aeo-triangle, distribution-as-moat, agents-as-product-users, passage-as-citation-unit]
preflight_refusal: substrate-gap, missing-monitoring-sources, missing-target-prompts
required_reads:
  - clients/{client}/aeo/sources.yaml
  - clients/{client}/aeo/target-prompts.md
---

# aeo-manual-action

## Purpose

LLMs pull from a narrow set of surfaces: Reddit threads, GitHub READMEs, expert blogs, podcasts, YouTube descriptions, niche forums, G2 reviews, Trustpilot, Hacker News. Owned-domain SEO does not reach them. This skill plans, tracks, and measures off-domain mention density per target prompt, with a real RSS / Atom / search-query monitor that reads `clients/<client>/aeo/sources.yaml` and produces a density + sentiment report on a rolling 30-day window. Refuses without monitoring sources because point-in-time guesses produce noise; rolling medians produce signal.

## Inputs

- `--client <client>` (required)
- `--mode <surface-map|action-plan|measure|monitor>` (default: `measure`)
- `--prompt-id <id>` (the target prompt this action serves; required for `action-plan` mode)
- `--window-days <N>` (default: 30) — rolling window for density measurement
- `--lookback-cache <path>` (default: `clients/<client>/aeo/citation-log/`) — prior runs for delta comparison
- `--out <dir>` (default: `clients/<client>/aeo/density-reports/`)

## Output deliverables (per mode)

**surface-map** — For each target prompt, identify the 5-10 surfaces an LLM would actually cite. Output: `aeo/surfaces/<prompt-id>-surface-map.md` with:
- Named surface (Reddit subreddit, GitHub repo, expert blog, podcast feed, YouTube channel).
- Current presence on each (mentions, sentiment, source-of-truth from real RSS / search).
- Per-surface propagation play (write / pitch / comment / interview / sponsor / case-study).
- Expected propagation lag (Reddit: days; expert blog: weeks; podcast: months).

**action-plan** — A propagation plan keyed to a single prompt or theme. Output: `aeo/action-plans/<prompt-id>-<date>.md` with:
- Target surface, action type, responsible operator, deadline.
- Falsifiable measure: mention count delta on the surface, citation delta in `aeo-relevance`.
- Linked goal in `goals/measurement-contracts/`.

**measure** — Pull current density across all configured sources; compute rolling 30-day medians; flag drift. Output: `aeo/density-reports/<date>.md` with per-surface mention count, sentiment breakdown, and trend vs prior runs.

**monitor** — Headless mode for routine cron / LaunchAgent runs. Same as `measure` but with structured cache writes and no narrative output.

## Substrate reads

- `aeo/sources.yaml`, the canonical monitor list (RSS feeds, search queries per platform).
- `aeo/target-prompts.md`, the prompts that surfaces should answer.
- `aeo/citation-log/`, prior density measurements (rolling baselines).
- `voc/processed/`, customer language to match in mentions.
- `competitive/`, competitor names to exclude / compare.

## Output contract

- `clients/<client>/aeo/density-reports/<date>.md` (measure / monitor mode)
- `clients/<client>/aeo/surfaces/<prompt-id>-surface-map.md` (surface-map mode)
- `clients/<client>/aeo/action-plans/<prompt-id>-<date>.md` (action-plan mode)
- `clients/<client>/aeo/citation-log/<date>.json` (rolling cache, written on every run)

Every artifact carries `produced_by: aeo-manual-action` so Gate 7 (pattern-applied) can verify pattern application at pre-publish time.

## sources.yaml schema

```yaml
client: <slug>
last_updated: YYYY-MM-DD
brand_aliases:
  - <primary-brand-name>
  - <alias-1>
  - <alias-2>

sources:
  reddit:
    - subreddit: <name>
      rss: https://www.reddit.com/r/<name>/.rss
      search_query: <optional search url>
      tier: T1 | T2 | T3
  hackernews:
    - feed: https://hnrss.org/newest?q=<brand>
      tier: T1
  rss_feeds:
    - name: <feed-name>
      url: <url>
      tier: T1
  search_queries:
    google_news:
      - "\"<brand>\" review"
      - "\"<brand>\" alternative"
    duckduckgo:
      - <query>
  g2:
    profile_url: https://www.g2.com/products/<slug>
    reviews_rss: <url>
  youtube:
    channel_search:
      - <brand-name>
  podcasts:
    listen_notes_query:
      - <brand-name>

decay:
  measurement_decay_days: 30
  surface_decay_days: 90
```

## Quality criteria

- Refuses to measure without `aeo/sources.yaml` (point-in-time snapshots without configured sources are unreliable).
- Refuses to plan without `target-prompts.md` (action-plans need a prompt anchor).
- Refuses to claim "AEO complete" without measurable mention-density change vs prior runs.
- Refuses to cite a single-day mention count as a result; per Lily Ray, 74% of LLM-cited sources rotate weekly. Skill measures rolling 30-day medians, not single-day counts.
- Flags decay: surfaces where mentions dropped vs prior measure beyond a threshold.
- Refuses without explicit sentiment analysis structure (positive / neutral / negative) per mention.

## GEO-risk pre-investment gate (v0.3, added per Ray cascade research)

Lily Ray's March 2026 essay plus the May 13 Hudgens podcast established the cascade mechanism: AI systems retrieve content via RAG, which means they must first find it in Google's index. A Google penalty does not just hurt rankings; it removes the page from the source pool ChatGPT, Perplexity, and Copilot draw from. One enforcement action propagates across every AI surface.

Before any GEO investment is approved, this skill runs the pre-investment risk audit. Each failed red-flag check pauses GEO spend until the issue is resolved.

### Red flags (fail = pause GEO investment)

| # | Check | Why it matters |
|---|---|---|
| 1 | Does any brand-owned content rank its own products as #1 without third-party corroboration? | Google January 2026 enforcement; Ray's audit documented 49% visibility loss. |
| 2 | Is AI content being published at volume without a per-piece human quality gate? | 54% of AI-scaled sites in Ray's 220-site study lost 30%+ peak organic traffic after Jan 2026 update. |
| 3 | Are page timestamps being updated without substantive content changes? | "Artificial freshness manipulation"; active spam signal since 2024. |
| 4 | Does any on-site widget prompt users to "summarize this with AI"? | Microsoft named this "AI Recommendation Poisoning" in February 2026 guide; gets flagged. |
| 5 | Are there more than 15 self-published competitor comparison pages? | Ray's audit identified one site with 51 comparison articles; flagged as comparison-page abuse. |

### Foundation checks (pass required before any GEO spend)

| # | Check | What passing looks like |
|---|---|---|
| 6 | Does the target page rank in Google organically, independent of AI search? | If it does not rank, it will not be cited. SEO is a prerequisite for AEO. |
| 7 | Do third parties mention or link to this content without being prompted? | Earned citations, not engineered ones. |
| 8 | Is the content answering a question or resolving buyer uncertainty, not just promoting a product? | Aleyda Solis: AI cites pages that resolve buyer uncertainty across the funnel. |

### How this gate fires

The skill runs the eight checks against the client's surface inventory when invoked with `--mode risk-gate`. Output: `clients/<client>/aeo/risk-gate/<date>.md` with per-check pass/fail status and remediation hints.

Refusal: any red-flag failing means the skill refuses to advance an `action-plan` mode run for the same target prompt until the operator either documents the remediation OR explicitly accepts the risk in `clients/<client>/aeo/risk-gate/risk-acceptance.md`.

This gate is the bridge between off-domain propagation tactics and the upstream SEO integrity those tactics depend on. AEO investment without the gate is investment against a Google enforcement action that could land mid-quarter.

## Citation churn caveat

Lily Ray's published research: 74% of LLM-cited sources rotate weekly. Point-in-time snapshots are noisy. This skill measures rolling 30-day medians, not single-day counts. The cache (`aeo/citation-log/<date>.json`) preserves point-in-time pulls so the rolling median can be computed across runs.

## See also

- `skills/aeo-tune/`, the presence side (owned-domain).
- `skills/aeo-relevance/`, the framing side.
- `routines/aeo-routine.md`, the cadence.
- `knowledge/patterns/aeo-triangle.md`.
- `knowledge/patterns/distribution-as-moat.md`.
- `knowledge/patterns/passage-as-citation-unit.md`.
- `templates/aeo-sources-example.yaml` — the schema fixture.
