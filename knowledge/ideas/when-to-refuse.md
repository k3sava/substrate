---
title: when to refuse
status: active
last_updated: 2026-05-04
---

# When to refuse

A skill should refuse to ship under specific conditions. The refusal pattern is not pessimism; it's the floor that keeps the system honest.

## The five refusal triggers

A skill refuses if any of these is true:

1. **Context is missing.** The skill's required context layers don't exist or are stub-only. The fix is to ground the context first.

2. **Context is past its freshness window.** The required layers have expired. The fix is to refresh the layer or open a goal that explicitly accepts the staleness.

3. **A load-bearing claim has no citation.** The draft makes a specific claim and no context path supports it. The fix is to add a source or remove the claim.

4. **The draft contradicts the canonical position.** The position layer says one thing; the draft says something different. The fix is to either align the draft or open a goal to test the new framing first.

5. **The draft over-claims relative to the source strength.** The citation is `direct` or `indirect` (rungs 1-2) and the claim is framed as if it were `verified` (rung 5). The fix is to soften the framing or upgrade the source.

## What a refusal looks like

The skill emits a gate report with the specific failure listed. Example:

```
SKILL: lp-ship
STATUS: refused
REASON: context-missing
DETAIL: required layer <project>/04-competitive.md does not exist
NEXT: run refresh-knowledge to ground the competitive layer, or open a goal
      that explicitly does not need competitive grounding
```

The operator reads the report and acts on it. The skill doesn't generate a draft.

## Why refusal is a feature

A skill that always produces output is a skill that produces confidently-wrong output when it shouldn't produce anything. The refusal pattern is the system signaling "I don't have what I need to do this well."

Operators learn to read refusals as information. A pattern of refusals on a specific skill points to a context gap. A pattern of refusals on a specific layer points to a freshness problem. The system's noise is signal.

## What refusal is not

Refusal is not a "let me try anyway" prompt. The skill doesn't ask the operator to confirm. It refuses, with a clear reason and a clear next step.

The override path exists (a reviewer can mark a refusal as "ship anyway" with a logged justification), but overrides count against the operator's accuracy score. Repeated overrides on the same gate mean either the gate is broken or the operator is miscalibrated.

## Where it lives in skills

Every skill spec has a `## When to refuse` section. The section lists the specific conditions that trigger a refusal for that skill. The dispatcher (`bin/substrate`) reads the section before running the skill and short-circuits if any condition fires.
