---
title: AEO loop
status: active
last_updated: 2026-04-30
---

# AEO loop

Answer Engine Optimization is not SEO. It operates on a different surface: what LLMs say about a product when buyers ask in ChatGPT, Perplexity, Claude, or any AI-assisted research flow.

This matters because AI-mediated buyers are now a significant share of the B2B research path. When a buyer asks "what's the best sales dialer for a 10-person team," the answer is determined by what's been published about the product on indexed sources, how structured that content is for LLM ingestion, and whether the product appears in the citation sets those models draw from.

The AEO loop runs weekly. It feeds the market-context and competitive substrate layers.

---

## Stage 1 — Citation tracking

**What happens:** pull citation data from the client's tracked AEO tool (Amplitude AI Visibility, Ahrefs AI Overview tracking, or equivalent). Get current state: which prompts mention the client, at what visibility percentage, at what rank.

**Output:** `clients/<slug>/signals/aeo-citation-snapshot-YYYY-MM-DD.json`

**Format:**
```json
{
  "date": "YYYY-MM-DD",
  "source": "amplitude-ai-visibility",
  "total_prompts_tracked": 0,
  "cited_count": 0,
  "cited_pct": 0.0,
  "by_topic": [],
  "zero_vis_prompts": [],
  "anomalies": []
}
```

---

## Stage 2 — Gap analysis

**What happens:** compare this week's snapshot to last week's. Surface three categories:
1. **Greenfield prompts** — zero visibility, active citation by competitors. The client is absent on prompts where buyers are asking and finding alternatives.
2. **Rank drops** — prompts where the client's citation rank fell more than 2 positions.
3. **New citation territory** — prompts where the client appeared for the first time.

**Output:** `clients/<slug>/signals/aeo-gap-analysis-YYYY-MM-DD.md`

**Gate:** operator reviews the gap analysis before content generation. Anomalies that indicate a competitor's major move may trigger a competitive bet rather than an AEO content bet.

---

## Stage 3 — Content generation

**What happens:** for each confirmed greenfield or rank-drop prompt, the copy-generator agent creates AEO content targeting that prompt:

- FAQ entries with FAQPage schema markup
- Listicle entries for "Best [category] software" prompts
- Structured comparison content for head-to-head prompts

Content is generated from substrate. Every factual claim traces to `substrate/product-knowledge.md` or `substrate/competitive.md`. No claims generated without a substrate source path.

**Output:** `clients/<slug>/assets/aeo/YYYY-MM-DD-<descriptor>/` — per-prompt content files with preflight queue marker.

**Preflight requirement:** AEO content passes through the standard synthetic-audience preflight before going to the operator review gate. Score threshold: overall mean ≥3.5, no dimension below 2.5.

---

## Stage 4 — Operator review gate

**What happens:** operator reviews the generated AEO content plus preflight scores. Approves, edits, or kills each piece. No AEO content ships without operator approval.

The operator checks:
1. Are the claims grounded? (Every number traces to substrate.)
2. Is the voice on-brand? (Matches brand-voice layer.)
3. Is the content technically correct? (Product-knowledge layer is current.)
4. Will this be indexed? (Has the correct schema markup and is going to an indexed surface.)

---

## Stage 5 — Ship

**What happens:** approved AEO content ships to the client's indexed surface. This could be:
- A new `/faq/` page on the website
- An update to an existing high-authority page
- A guest placement on a third-party publisher the LLMs already cite
- A structured data addition to an existing product page

**Tracking:** each shipped AEO piece is logged in `clients/<slug>/assets/aeo/SHIPPED.md` with the prompt it targets, the URL it shipped to, and the ship date.

---

## Stage 6 — Measurement

**What happens:** four weeks after shipping, re-pull citation data for the targeted prompts. Compare to the pre-ship baseline.

**Bet structure:** every AEO content batch is a bet. Typical structure:
- predicted_outcome: "X of Y targeted prompts move from <Z% to ≥50% visibility within 90 days"
- measurement_design: "re-pull Amplitude AI Visibility for the targeted prompt set on [date]; compare to baseline snapshot from [date]; join on prompt text"
- resolution_date: 90 days after ship

**Output:** resolution verdict filed to the bet ledger. Brier score computed. Market-context substrate layer updated to reflect what worked.

---

## Stage 7 — Substrate update

**What happens:** the AEO loop's resolution feeds two substrate layers:

1. **market-context.md** — update the "AI landscape" section with what prompt categories the client now appears in. Update citation benchmark numbers.

2. **competitive.md** — update competitive citation patterns. If a competitor gained ground on a category, flag it.

The substrate-curator agent runs after each AEO loop resolution and proposes these patches. Operator approves.

---

## Connection to the Rory Woodbridge operating model

Product credibility with machine-readable differentiation. The AEO loop is the technical implementation:

- Product credibility: every AEO claim traces to substrate (product-knowledge, competitive).
- Machine-readable: FAQ schema, ItemList schema, structured data for LLM ingestion.
- Differentiation: content targets the specific prompts where buyers are comparing alternatives.

An operator running this loop weekly is not doing "SEO + AI." They are systematically ensuring that when an AI-mediated buyer asks a question in the client's category, the client has a credible, grounded, machine-readable answer available. That is what compound trust looks like in the LLM era.

---

## Open question

**What's the right cadence for different prompt types?** Evergreen prompts (category-level: "best <category> tool") have longer-cycle citation patterns than trend prompts ("best <category> tool 2026"). The measurement window may need to vary by prompt type. This is an open research question as of substrate launch.
