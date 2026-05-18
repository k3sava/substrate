---
title: kill-list pattern
status: active
last_updated: 2026-05-04
---

# Kill-list pattern

A list of phrases banned in a project's copy. Every project has one. The list grows when a phrase shows up in a draft and the project decides "no more of that." It rarely shrinks.

## Why kill-lists work

Voice is hard to specify positively. "Write like X" is fuzzy. "Don't use these 23 phrases" is operational.

The kill-list is the negative-space definition of the project's voice. The voice gate enforces it. Operators internalize the list after a few drafts; the gate catches what they miss.

## How a kill-list grows

A teammate finishes a draft. Reviewer reads it. Reviewer flags a phrase that read as off — too generic, too AI-flavored, too marketing-speak, too similar to a competitor. The phrase goes on the list. Next draft, the gate catches the phrase before the reviewer has to.

This is the maintenance pattern. The list reflects what the project actually rejects, not a theoretical voice guide.

## What goes on a kill-list

Three categories.

### 1. Filler superlatives

Adjectives that sound impressive and add no information. "World-class," "best-in-class," "cutting-edge," "next-generation," "industry-leading," "robust," "comprehensive" (when used as filler). The reader's eyes skip them.

### 2. AI-fingerprint phrases

Patterns common in AI-generated copy. "Seamlessly," "orchestrate," "leverage" (as a verb), "transform" (as a generic verb), "unlock" (as a generic verb), "holistic," "synergy."

These aren't bad words. They're tells. A draft full of them reads as machine-output, even if a person wrote it. Especially in 2026.

### 3. Project-specific retired language

Phrases the project used to use and now doesn't. An old position phrase. A competitor's brand language the project is steering away from. A category description that's been replaced.

These vary per project. They're how voice evolves over time without losing institutional memory.

## What's NOT on a kill-list

Customer language. The voice of customer layer captures the actual phrases buyers use. A project's customers might say "leverage your data" — that's their language, and quoting them is fine. The kill-list is for the project's voice in the project's own copy, not for verbatim customer quotes.

The voice gate distinguishes between body copy and quoted material. Quoted material doesn't get scanned for kill-list hits.

## What's NOT on this kill-list (the meta-pattern)

This page is the pattern, not a specific list. The actual phrase set lives at `<project>/07-brand-voice.md` per project. Every project should expect 20-50 phrases on its list within a few months of operation.

## How to maintain

Once a quarter, audit the list:

- Remove phrases that haven't shown up in any draft for two quarters. Either the team internalized them, or the phrase isn't a problem anymore.
- Promote phrases that appear in three or more drafts as fails. They're not just on the list — they're patterns; consider restructuring the prompts the team uses.
- Add the latest fails from the last quarter's drafts.

This is also what keeps the kill-list from sprawling. A list of 200 phrases is unreadable; a list of 30-50 is operational.
