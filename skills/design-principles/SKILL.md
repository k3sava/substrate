---
name: design-principles
description: Audits and proposes design choices against a written principles ledger. Treats design as a discipline that runs through the substrate (typography, spacing, color, motion, interaction) the same way voice runs through copy.
version: 0.1
amplifies: PMM, designer, founder, product lead
masters: Dieter Rams (10 principles of good design), Jony Ive (intent-first design), Brad Frost (atomic design), Refactoring UI (Adam Wathan + Steve Schoger — visual restraint), Linear / Vercel / Stripe (canonical design systems), Figma design system team
substrate_layers_required: [brand-voice, product-knowledge]
patterns_grounded: [copywriting-craft-fundamentals, make-implicit-explicit, specificity-becomes-profitable]
preflight_refusal: substrate-gap, missing-design-tokens
required_reads:
  - clients/{client}/brand-voice/design-tokens.md
  - clients/{client}/brand-voice/visual-principles.md
---

# design-principles

## Purpose

Design without principles is taste-by-committee. With principles, every choice has a reason that traces. This skill maintains the principles ledger, audits surfaces against it, and proposes design changes that pass the principle test.

## Inputs

- `--client <client>` (required)
- `--mode <build-principles|audit-surface|propose-change>`
- `--surface <path-or-url>` (required for audit/propose)

## Principles ledger structure

Each principle has:
- **Statement** (one sentence).
- **Why** (the problem it solves).
- **How to apply** (concrete tests).
- **What it costs** (what this principle says no to).

Examples (Rams + Refactoring UI patterns):
- "Restraint over decoration. Every visual element earns its presence."
- "Hierarchy by spacing, not by border."
- "One accent color carries the brand. Neutral surfaces let it work."
- "Motion is functional or absent."

## Audit output

For a surface, the skill grades each principle pass/fail with a one-line reason and a proposed fix.

## Substrate reads

- `brand-voice/design-tokens.md`, the canonical tokens.
- `brand-voice/visual-principles.md`, the principles ledger.
- `product-knowledge/`, what the surface needs to communicate.

## Output contract

- `brand-voice/visual-principles.md`, append-only history of principle changes.
- `design-audits/<surface>/<date>.md`, the binary audit grades.
- A patch proposal when the audit reveals a principle gap.

## Quality criteria

- Refuses a principle without a "what this says no to" line.
- Refuses an audit without a one-line reason per pass/fail.
- Flags drift: when shipped surfaces start failing the same principle repeatedly.

## See also

- `skills/design-thinking-content/`, design-led content generation.
- `skills/lp-cro-rubric/`, the conversion-side audit.
- `knowledge/patterns/copywriting-craft-fundamentals.md`.
