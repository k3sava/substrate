---
title: how confident are we?
status: active
last_updated: 2026-05-04
---

# How confident are we?

Every claim in a draft has a source. The strength of that source determines how confident we are in the claim. Five rungs, weakest at the bottom.

## The five rungs

| Rung | Tag | What it means |
|---|---|---|
| 5 | `verified` | Source-system pull. Direct from analytics, CRM, ad platform, project tracker. The dashboard query, API response, or project record is the citation. |
| 4 | `self-reported` | The operator told us. Interview quote, status update, slide commentary. Real, but unaudited. |
| 3 | `contextual` | Inferred from adjacent data. The customer didn't say it directly; the pattern across customers points to it. |
| 2 | `indirect` | A source we don't fully control says it. Industry analyst note, public review, secondary research. |
| 1 | `direct` | Operator-direct knowledge with no cited source. Use sparingly; demote to a higher rung when a source is identified. |

## How to use it

Every load-bearing claim in a draft carries a tag. The pre-publish-check looks for tags on numbers, percentages, dollar figures, named competitors, named source-systems, customer quotes, and dates.

A draft can mix rungs. A position statement can be `verified` (sourced from won-deal analytics) while a customer quote inside it is `self-reported` (taken from a sales call). The reader sees the mix and weighs accordingly.

## Why five rungs

Two rungs (verified vs. unverified) loses too much information. Ten rungs creates analysis paralysis. Five matches how operators already think about source strength: source-system data, the customer's own words, observed patterns, third-party data, and operator-direct knowledge.

## What this kills

Drafts full of plausible-sounding numbers with no traceable source. If the rung is missing, the claim is `unverified` and stops. The pre-publish-check won't pass it.

## What this protects

The accuracy ledger is only meaningful if the inputs to goals are honest. Tagging the rung makes the input honesty visible. A goal opened on `direct` claims and a goal opened on `verified` claims read very differently in the post-mortem.
