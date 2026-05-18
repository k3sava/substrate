---
name: capability-pin
description: Pins each substrate skill to a capability class (e.g. "long-context summarisation at quality X"), not to a model snapshot. Re-baselines quarterly. Survives model swaps without per-skill rewrites.
version: 0.1
amplifies: substrate maintainer, anyone running skills against shifting model frontier
masters: Ethan Mollick (Wharton — pin to capabilities, not models), Cat Wu (Anthropic — capability-class thinking), Sherwin Wu (capability-tier rotation), Boris Cherny (don't box the model in), Simon Willison (eval against capability, swap models)
substrate_layers_required: [strategy]
patterns_grounded: [build-for-next-model, eval-as-data-analysis, agents-mapped-to-jtbd]
preflight_refusal: substrate-gap, missing-eval-rubric
required_reads:
  - knowledge/patterns/build-for-next-model.md
  - skills/eval-rubric/
---

# capability-pin

## Purpose

Workflows hardcoded to a model version inherit the model's failure modes and miss the next leap. Capability-pinned workflows describe what they need ("long-context retrieval at quality X", "structured-output JSON at quality Y") and let the model layer swap underneath.

## Inputs

- `--mode <pin|rebaseline|swap-model>`
- `--skill <skill-name>` (required for pin/swap)
- `--capability-class <class>` (e.g. long-context-summarisation, structured-output, multi-step-tool-use, image-grounding)

## Capability classes (substrate ledger)

- `long-context-summarisation`: read N tokens, produce a summary at quality X.
- `structured-output`: emit JSON or YAML matching schema with quality X.
- `multi-step-tool-use`: chain N tool calls to complete a task with quality X.
- `image-grounding`: identify and describe visual elements with quality X.
- `code-edit-fidelity`: apply changes to a codebase with quality X.
- `voice-mimicry`: produce text in a named voice with quality X.
- (Add as new classes emerge.)

## Substrate reads

- Each skill's `SKILL.md` declares which capability classes it depends on.
- `evals/<skill>/runs/`, the eval history per class.
- The current model registry per class.

## Output contract

- `knowledge/capability-registry.md`, the canonical pin map (skill → capability class → current model → eval baseline).
- A quarterly rebaseline log: when models shift, run evals against the new model for each class; if quality holds or improves, swap; if not, keep the prior model.
- A migration log when a skill's capability class becomes obsolete (e.g. retrieval moves from RAG to long-context).

## Quality criteria

- Refuses to pin a skill to a class without an eval baseline (eval-rubric required first).
- Refuses to swap a model without an eval-against-the-new-model run.
- Flags drift: a skill whose capability class has had no eval run in >90 days.

## Why this matters

Mollick's pattern: model leaps are getting bigger, not smaller. Substrate without a capability-pin layer accumulates per-skill rewrites that should have been free swaps. With this layer, model upgrades are eval reruns, not engineering work.

## See also

- `skills/eval-rubric/`, how each capability class is measured.
- `routines/quarterly-context-audit/`, where rebaselining sits.
- `knowledge/patterns/build-for-next-model.md`.
