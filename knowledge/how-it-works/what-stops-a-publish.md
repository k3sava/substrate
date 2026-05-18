---
title: what stops a publish
status: active
last_updated: 2026-05-04
---

# What stops a publish

Every external draft passes through a gate before it ships. The gate composes four sub-checks. A draft that fails any one of them doesn't reach a human reviewer.

## The four sub-checks

### 1. Citation gate

Every load-bearing claim in the draft must trace to a context path that exists.

A claim is load-bearing if it carries a number, a percentage, a dollar figure, a named competitor, a named source-system, a named customer, or a date. Generic prose ("our product helps teams ship faster") doesn't need a citation. A specific claim ("teams ship 3.2x faster on average") does.

The check runs as a path resolver: for each citation in the draft, does the file exist at that path? If the answer is no, the draft is rejected with the missing path listed.

### 2. Voice gate

The voice rules from `<project>/07-brand-voice.md` apply. Specifically:

- No kill-list words. Phrases banned in your copy. Each project has its own list.
- No em dashes in body copy. Em dashes are an AI-fingerprint signal.
- No throat-clearing openers. "In today's fast-paced world" / "It's no secret that" / "We all know that" — banned.
- Cadence within range. Sentence-length variance per the project's cadence rule (often Gary Provost-style).

The check runs as a regex sweep plus a sentence-length analyzer.

### 3. Refusal pattern

The draft must not over-claim. If the context is thin on a point — say, you have one customer quote about an outcome and the draft frames it as "many customers find" — the refusal pattern flags it.

The check runs by comparing the strength of each load-bearing claim against the strength of the citation behind it. A weak citation supporting a strong claim is a fail.

### 4. Stand-in audience

A buyer-shaped panel scores the draft on two dimensions: outcomes and differentiation.

The panel is built from the project's ICP, voice of customer, and persona axes. Each persona reads the draft and produces a score from 1 to 5 plus a note. The composite score is the average across personas.

A score below the project's floor (often 4.0 on outcomes and 3.5 on differentiation) is a fail.

## Why these four

Each check guards a distinct failure mode:

- **Citation** guards against fabricated claims.
- **Voice** guards against AI-fingerprint copy and brand drift.
- **Refusal pattern** guards against over-claiming under-supported points.
- **Stand-in audience** guards against drafts the team loves but the buyer wouldn't.

Removing any one of them creates a gap. Adding a fifth has been proposed multiple times and rejected each time — the four cover every failure mode the system has produced in production.

## What happens after the gate

If the draft passes, it goes to a human reviewer with the gate report attached. The reviewer sees the citation list, the voice score, the refusal-pattern note, and the stand-in audience composite. The reviewer is the final gate before publish.

If the draft fails, it returns to the operator with the specific failure listed. The operator either fixes the failure or closes the goal as MISS.

## Override

A reviewer can override a gate failure with a logged justification. Overrides count in the accuracy tracker. Repeated overrides on the same gate mean the gate is broken (recalibrate it) or the operator is miscalibrated (recalibrate them).

Citation override is forbidden. Anti-fabrication is constitutional.
