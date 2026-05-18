---
title: anti-fabrication
status: active
last_updated: 2026-05-04
---

# Anti-fabrication

Every load-bearing claim in any draft traces to a context path. If the path doesn't exist, the claim doesn't ship.

## What's load-bearing

Specific numbers. Percentages. Dollar figures. Named competitors. Named source-systems. Customer quotes. Dates. Anything where a reader would expect a source if they paused on the sentence.

Generic prose isn't load-bearing. "Our product helps teams ship faster" doesn't need a citation — it doesn't carry a specific claim. "Teams ship 3.2x faster on average using our product" does — it carries a specific number.

## How citations look in practice

Inline, in the same paragraph as the claim:

> Mid-market sales teams (50-500 reps) are the highest-converting segment in 2026 won-deal data [`02-icp.md`].

Or a Source column in tables:

| Claim | Source |
|---|---|
| Avg deal cycle: 47 days | `08-market-context.md` (Q1 2026 export) |
| Top objection: integration cost | `03-voice-of-customer.md` (last 30 sales calls) |

The citation is a path. The path resolves to a file. The file contains the supporting evidence.

## What this kills

AI-generated drafts full of plausible-sounding numbers with no verification path. Without anti-fabrication, a draft that reads "we've seen 40% lift in trial-to-paid conversion" goes out the door because nobody checked the source. With anti-fabrication, the gate refuses the draft because no path supports the claim.

## Why frontmatter alone isn't enough

A draft can declare in its frontmatter `substrate_consumed: [01-position.md, 02-icp.md, 04-competitive.md]`. That's not a citation. That's a list. A citation is the inline tie between a specific claim and a specific source.

The pre-publish-check looks for inline proximity. Frontmatter declarations are necessary (they let the reviewer know what was consumed), but they're not sufficient. The check rejects drafts where load-bearing claims aren't tied to specific sources within the same paragraph or table row.

## The five-rung evidence ladder

Every citation also carries a rung from `how-confident-are-we.md` — verified, self-reported, contextual, indirect, or direct. The rung tells the reader how strong the source is. A `verified` claim survives more scrutiny than a `direct` claim. The pre-publish-check enforces ladder honesty: claims framed as confident need correspondingly strong sources.

## What this protects

The accuracy ledger. Goals are scored on outcomes; outcomes are only meaningful if the inputs to the goal were honest. Fabricated inputs produce confident wrong predictions, and confident wrong predictions tank the operator's accuracy score.

Anti-fabrication is the principle that keeps the ledger interpretable.
