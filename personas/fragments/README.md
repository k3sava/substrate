---
title: persona fragments — reusable trait sets
last_updated: 2026-05-01
consumer: substrate/skills/synth-audience (--tinytroupe-mode)
source_pattern: Microsoft TinyTroupe fragment architecture (v0.4+)
---

# Persona fragments

Reusable cognitive trait sets referenced by persona files. Fragments are merged into the LLM evaluator prompt when `--tinytroupe-mode` is active.

## How to use

In any persona `.md` frontmatter:
```yaml
fragments:
  - price-sensitive
  - integration-dependent
```

When `--tinytroupe-mode` runs, it loads each named fragment and appends its `trait_descriptors`, `decision_heuristics`, and `evaluation_frame_modifier` to the base persona prompt.

## Available fragments

| Slug | Core trait | Decision heuristic |
|---|---|---|
| price-sensitive | cost-first evaluator | anchors objections on per-seat cost and ROI math |
| integration-dependent | integration-gated adopter | gates adoption on depth of CRM/stack integration |
| churn-risk | high-skepticism reader | has been burned by vendor promises; distrusts marketing copy |
| expansion-ready | positive early adopter | internal obstacle is budget approval, not conviction |
| admin-gatekeeper | compliance-oriented | prioritizes SSO, audit logs, admin controls over feature set |
| time-poor | attention-scarce reader | filters everything through "how long will this actually take" |

## Fragment spec format

Each fragment file:
```yaml
slug: <slug>
name: <human name>
trait_descriptors: [list of 3-5 descriptors]
decision_heuristics: [list of 2-3 cognitive shortcuts]
evaluation_frame_modifier: "how this fragment modifies the base evaluation frame"
```
