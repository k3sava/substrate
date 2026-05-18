---
title: GTM intelligence
status: active
last_updated: 2026-05-04
---

# GTM intelligence

What signals feed the system, where they come from, and how they get processed without overwhelming the context layer.

## The five sources

### 1. Voice of customer

Buyer interviews, recorded sales/CS calls, public reviews, support tickets. The closer to the buyer's actual words, the higher the signal.

Sales/CS calls weigh most. They're the least filtered. Public reviews and case studies have already been edited; the calls haven't.

### 2. Buyer behavior

Session data, conversion events, search behavior, page-level engagement. Where buyers click, what they skip, what they re-read. The product-side equivalent of voice of customer.

### 3. Competitive intelligence

Competitor pricing pages, product changes, ad spend signals, hiring patterns, public reviews of their product. What's changing on the other side of the deal.

### 4. Market context

Search trends, AI-citation patterns (which products LLMs cite when buyers ask), analyst reports, category-level shifts. Slower than competitive but with bigger consequence when it moves.

### 5. Sales intelligence

Win/loss analysis, deal velocity by segment, top objections by call, pipeline conversion patterns, account scoring. The internal data that says what's actually working at the deal level.

## How signals enter the system

Every signal source has an inbox under `<project>/signals/inbox/<source>/`. New signals land there as raw artifacts: a transcript file, an exported CSV, a screenshot of a competitor's pricing page.

The signal-analyst step reads new signals, identifies which context layer they bear on, and proposes a patch. A human approves before the context updates.

Signals never write to context directly. The proposal queue is the only path.

## What separates a signal from noise

A signal changes a load-bearing claim in a context layer. Noise doesn't.

Examples of signal:

- A competitor raised their price 25%. (Updates competitive + market context.)
- Three of the last ten sales calls had the same new objection. (Updates voice of customer + ICP if it points to a segment.)
- A search-trend tool shows the category's primary query lost 40% of volume to a related query. (Updates market context.)

Examples of noise:

- A teammate liked a tweet about the category. (No layer changes.)
- A single review came in. (Below the threshold for proposing a patch unless it lands in a brand-new theme.)
- A competitor announced something at a conference but nothing shipped. (Watch, don't write.)

The signal-analyst step is the filter. It keeps the context layer thick with real shifts and thin on noise.

## Where the system leans

The default is to under-update the context, not over-update. A context layer that gets patched every week starts to look like the daily news; an operator can't ground a decision on a layer that won't sit still. A layer that gets patched every month or two, when real shifts surface, stays useful.

The freshness window catches the other failure mode — context that goes too long without an update. The two together produce a context that's stable enough to ground decisions and live enough to track reality.
