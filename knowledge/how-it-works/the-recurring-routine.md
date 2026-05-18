---
title: the recurring routine
status: active
last_updated: 2026-05-04
---

# The recurring routine

Seven steps. The seventh writes back to the first. That's the loop.

```
1. ingest signals      ← incoming intel from any source
2. ground the context  ← signals propose patches; humans approve
3. open a goal         ← falsifiable prediction with a measurement contract
4. generate a draft    ← skill reads context + goal contract, produces draft
5. checks before publishing  ← citations, voice, refusal pattern, stand-in audience
6. ship                ← publish to channel
7. close the loop      ← measure result, update accuracy, update context
```

## What each step does

### 1. Ingest signals

Anything that bears on what the context says: a new sales call, a competitor's price change, a customer review, a search-trend shift, an analyst report. Signals come in raw. They don't update the context directly.

### 2. Ground the context

The signal-analyst step. Reads the signal. Identifies which context layers it bears on. Proposes a patch — which layer, what to change, why. A human approves before the context updates. This is the gate that keeps the context from drifting on weak signals.

### 3. Open a goal

A goal is a falsifiable prediction. It opens with a measurement contract — baseline, target, window, source. If any of those is missing or vague, the goal doesn't open. The goal also carries a predicted confidence number (0 to 1) so it can be scored at resolution.

### 4. Generate a draft

A skill reads the context and the goal contract and produces a draft. The skill cites its context paths inline. A draft without citations is rejected by the next step.

### 5. Checks before publishing

The pre-publish-check composes four sub-gates:
- Citation gate. Every claim resolves to a context path that exists.
- Voice gate. No kill-list words, no em dashes in body, no throat-clearing openers.
- Refusal pattern. The draft refuses to over-claim if context is thin.
- Stand-in audience. A buyer-shaped panel scores the draft on outcomes and differentiation.

A draft that fails any gate doesn't reach human review.

### 6. Ship

A human approves what the gates passed. The draft goes to its channel.

### 7. Close the loop

After the goal's resolution date, the goal scores. The accuracy ledger updates. The context updates with what the resolution taught — if the goal said "this position works" and the result said "it didn't," the position layer or the brand voice layer gets a patch.

## Why this shape

Earlier versions tried four-step loops and ten-step loops. Four loses the signal-grounding step and lets shaky claims into context. Ten splits things that should be one move (separate "plan" and "campaign" steps create coordination overhead with no resolution gain). Seven holds.

## Failure modes the loop guards against

- **Open-loop goals.** Goals that enter `active` and never reach `resolved` because the measurement contract was vague. The goal linter blocks `open` until the contract is parseable.
- **Stale context on generation.** Drafts generated against context that expired weeks ago. The freshness window flags expired layers; drafts that cite them carry a staleness warning.
- **Reviewer cycles wasted on low-signal drafts.** The pre-publish-check runs before any human reviews. Most weak drafts die there.

## Cadence

Steps 1-2 run continuously as signals arrive. Steps 3-6 run on demand, when the operator opens a goal and runs a skill. Step 7 runs on the goal's resolution date.

The weekly knowledge check (a routine) sweeps every project's context for layers past their freshness window and flags them for refresh. That's the always-on layer that keeps the rest of the loop honest.
