---
title: the 10 layers
status: active
last_updated: 2026-05-04
---

# The 10 layers

Every project the system runs on has a context layer. The context is broken into ten slow-changing pieces. Each piece answers one question. Together they're the grounding every draft is generated against.

Folder layout per project:

```
<project>/
├── 00-INDEX.md                     # what's here, what's missing, when each was last refreshed
├── 01-position.md                  # the canonical position statement
├── 02-icp.md                       # who buys this and why
├── 03-voice-of-customer.md         # buyer language pulled from real sources
├── 04-competitive.md               # who you're up against and on what axes
├── 05-product-knowledge.md         # what the product actually does, in plain English
├── 06-conversion-narrative.md      # the story you tell on the path to purchase
├── 07-brand-voice.md               # how you write — cadence, kill-list, pet phrases
├── 08-market-context.md            # where the category is going, who else is moving
├── 09-roadmap.md                   # what's shipping and when
└── 10-strategy.md                  # the big picture: what to do, what to skip, why
```

## The ten

1. **Position.** The category sentence. "We're the X for Y who do Z." If a draft contradicts this, the draft is wrong.

2. **ICP.** Who buys this and why. Built from won-deal patterns, not aspirational marketing personas. Includes the disqualifiers — who doesn't buy, and why.

3. **Voice of customer.** The actual words buyers and customers use. Pulled from four sources: case studies, public reviews, sales/CS calls, and market research. Sales/CS calls weigh most because they're the least filtered.

4. **Competitive.** The competitors that come up in deals, what they're stronger at, what they're weaker at, and which axes the buyer cares about. Battle cards live here.

5. **Product knowledge.** What the product actually does. Not the marketing description; the operator's understanding of what works, what doesn't, what's load-bearing, what's a nice-to-have. One file per major capability.

6. **Conversion narrative.** The story across the funnel. Awareness → consideration → decision → close. What changes at each step, what proof shows up where.

7. **Brand voice.** How you write. Cadence rules, kill-list words (phrases banned in your copy), throat-clearing patterns to avoid, pet phrases that are recognizably yours.

8. **Market context.** The category's trajectory. Analyst reports, search trends, AI-mediated buyer behavior. This is the layer that goes stale fastest.

9. **Roadmap.** What's shipping in the next two quarters. Sequenced by date. Each item has a one-line outcome statement.

10. **Strategy.** The big picture. Where to compete, where to ignore, what to double down on, what to retire. The slowest layer to change.

## Index

`00-INDEX.md` is the entry point. It lists every file, when it was last refreshed, and which layers are currently inside their freshness window. The first thing every session reads.

## Why ten

Six is too few; you lose the texture between ICP and voice of customer, between competitive and market context, between product knowledge and roadmap. Fifteen is too many; the operator can't hold them all in mind. Ten is the smallest set where each layer answers a distinct question.

## Where this came from

The set was settled iteratively across the v0.1 to v0.9 build. Earlier versions had six (position, ICP, voice of customer, competitive, product knowledge, brand voice). v0.7 added the four operating layers (conversion narrative, market context, roadmap, strategy) when the gap between "who and why" and "what to do next" kept showing up at the edge of every draft.
