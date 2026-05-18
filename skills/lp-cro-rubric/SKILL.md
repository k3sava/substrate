---
name: lp-cro-rubric
description: A binary CRO rubric applied to landing pages and high-conversion surfaces. Audits hero, message hierarchy, proof, friction-vs-feature trade, instrumentation. Distinct from lp-ship (production) — this skill grades and proposes test variants.
version: 0.1
amplifies: PMM, growth lead, designer, conversion specialist
masters: Peep Laja (CXL — research-driven CRO discipline), Joanna Wiebe (Copyhackers — message hierarchy + stages of awareness), Jen Havice (deep voice-of-customer), Wynter (B2B message testing on LPs), Andre Morys (CRO scoring), Karl Gilis (above-the-fold rules), Brian Massey (conversion sciences)
substrate_layers_required: [positioning, voc, brand-voice, conversion-narrative]
patterns_grounded: [quality-as-growth-lever, copywriting-craft-fundamentals, specificity-becomes-profitable, buyer-mindset-not-product-features]
contradictions_aware: [quality-as-growth-vs-marginal-user-friction-removal]
preflight_refusal: substrate-gap, missing-target-cohort
required_reads:
  - clients/{client}/voc/processed/
  - clients/{client}/positioning/positioning-canonical-statement.md
  - clients/{client}/brand-voice/voice-guide.md
---

# lp-cro-rubric

## Purpose

CRO without a rubric is hunches. This skill applies a binary research-backed rubric to any LP, scores it, and proposes test variants targeting the lowest-scoring criteria. Rubric outputs are data, not vibes.

## Inputs

- `--client <client>` (required)
- `--lp-url-or-path <target>` (required)
- `--audience <pinned-icp>` (required)
- `--mode <audit|test-design|score-trend>`

## Rubric (binary criteria)

### Hero
- Within 5 seconds, can the buyer name what they get and who it's for?
- Does the hero pass the positioning canonical statement?
- Is the awareness level (Schwartz) matched to the cohort's stage?

### Message hierarchy
- Does the page descend from problem → mechanism → proof → CTA without repetition?
- Is each section necessary? (Subtraction-first.)
- Does each section cite voc/processed/ language?

### Proof
- Does the page show specific proof (named customer, numeric outcome, dated artifact)?
- Is proof close to claim, not in a separate carousel?
- Does proof come from the same ICP as the audience?

### Friction
- Where is intentional friction? (Quality-as-growth pattern.)
- Where is unintentional friction? (Inputs the buyer doesn't have.)
- Does the friction match the cohort's commitment level?

### Instrumentation
- Is there a single named target metric?
- Does the metric fire on the actual conversion event, not a scroll proxy?
- Is the baseline cited from a source-system pull?

## Conditions awareness (quality-as-growth-vs-marginal-user-friction-removal)

Naik says raise quality bar, friction is the feature. Verna says remove friction at the marginal user. The contradiction's conditioning: cohort lifecycle + retention math.

- **Top-of-funnel marketing pages**: Verna's friction-removal lead. Pick lowest-friction CTA.
- **Pre-purchase / pricing pages**: Naik's friction-as-quality. Higher-commitment CTA.
- The chosen position is logged in the audit's frontmatter.

## Output contract

- `lp-audits/<lp-slug>/<date>.md`, the binary rubric grades.
- `lp-audits/<lp-slug>/test-design.md`, proposed variants per low-score criterion.
- A measurement contract for any test that ships.

## Quality criteria

- Refuses to grade without a target cohort pinned.
- Refuses to grade voc citations as "pass" without a real `voc/processed/` path.
- Flags drift: a re-grade that drops vs prior baseline triggers a positioning audit.

## See also

- `skills/lp-ship/`, the production skill.
- `skills/audience-test/`, the buyer-panel side.
- `knowledge/patterns/quality-as-growth-lever.md`.
- `knowledge/contradictions/quality-as-growth-vs-marginal-user-friction-removal.md`.
