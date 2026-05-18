---
title: copy rules
status: active
last_updated: 2026-05-04
---

# Copy rules

The lint rules for customer-facing copy. Each rule is a regex or a structural check. The voice gate runs them all.

## Regex rules

| Rule | Pattern | Why |
|---|---|---|
| No em dashes in body | `—` (U+2014) outside headlines | AI-fingerprint signal |
| No double dashes | `--` outside code blocks | Same; often a typed em-dash substitute |
| No "very" | `\bvery\b` | Almost always replaceable with a stronger adjective |
| No "really" | `\breally\b` | Same |
| No throat-clearing | `^(In today's|It's no secret|We all know|Have you ever|Picture this|Imagine a world)` | Banned openers |
| No filler superlatives | `\b(world-class|best-in-class|cutting-edge|next-generation|industry-leading)\b` | Filler; specific claims preferred |
| No vague tech | `\b(AI-powered|AI-driven|AI-native)\b(?!,?\s+with\s+specifics)` | Allowed only when followed by what specifically the AI does |

## Structural checks

### Sentence-length variance

Compute the standard deviation of sentence lengths in the draft. A standard deviation under 4 means the draft is monotonous. Flag for cadence rewrite.

### Average sentence length

Under 12 words across the draft means staccato. Over 22 means dense. The target band is 14-20 average, with deliberate variance inside.

### Outcome-first opener

The first 50 words must contain at least one outcome word: "you'll," "your," "results," "save," "ship," "reach," "hit," "land," or domain-specific outcome words from the project's voice file. If not, flag for outcome-led rewrite.

### Citation density

For drafts that make load-bearing claims (specific numbers, named competitors), the citation density must be at least one citation per three load-bearing claims. Below that, flag for evidence-strengthening.

## Kill-list per project

Each project carries its own kill-list at `<project>/07-brand-voice.md`. Project-specific words and phrases that the project has decided not to use. Examples a project might add:

- A buzzword the team overused last quarter.
- A competitor's brand language the project is moving away from.
- An old position phrase that's been retired.

The voice gate reads the project's kill-list at runtime. The list lives with the project, not the system.

## What the gate produces

A report per draft, with each rule's pass/fail and the specific line/column for fails.

```
voice-check report: <draft path>
  em-dash: PASS (0 found)
  double-dash: PASS
  filler: FAIL (1 found, line 14: "world-class")
  throat-clearing: PASS
  cadence sd: PASS (sd=5.8)
  avg sentence length: PASS (16.3)
  outcome opener: FAIL (no outcome word in first 50 words)
  citation density: PASS (4 citations on 11 load-bearing claims)
  kill-list (<project>): PASS
overall: FAIL (2 of 9 rules)
```

The operator fixes the fails and re-runs.

## Override

A reviewer can override a specific rule failure with a logged justification. The justification goes in the decision log. Repeated overrides on the same rule mean the rule is broken (or the project's voice has shifted; update the rule).
