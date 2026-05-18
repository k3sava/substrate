---
name: messaging-matrix
description: Generates a persona × use-case messaging matrix from canonical positioning, ICP, VoC findings, narrative-strategy output, and competitive battle cards. Each cell carries a hook, value claim, proof point (cited substrate path), and CTA. Validates against allowed/banned claims. Outputs md table + yaml structured form.
version: 2.0
amplifies: PMM, sales enablement, content lead, demand-gen
masters: April Dunford (positioning → message hierarchy), Anthony Pierri (homepage to one buyer), Emma Stratton (PMM messaging discipline), Joanna Wiebe (Copyhackers — message hierarchy from customer language), Andy Crestodina (message mining), Bob Moesta (JTBD as the matrix axis), Robert McKee (story-as-strategic-architecture)
substrate_layers_required: [positioning, icp, voc, product-knowledge, brand-voice]
patterns_grounded: [narrative-as-strategy, raskin-narrative-five-act, buyer-mindset-not-product-features, jtbd-as-buyer-mental-model, tf-idf-themes-from-customer-language, copywriting-craft-fundamentals]
preflight_refusal: substrate-gap, missing-icp-pin, missing-voc-data, missing-positioning
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# messaging-matrix

## Purpose

Without a matrix, every channel improvises. With a matrix, every channel reads from one structure: who, hurts how, gets what, proven by, asked to. The matrix is the canonical message. Channel adaptation only changes form, not substance.

This skill builds the matrix from substrate (not from operator hypothesis), validates each cell against allowed-claims and banned-claims when present, and ships md + yaml outputs that downstream skills (narrative-compose, lp-ship, outbound-sequence-design) consume directly.

## Modes

### `--mode build`
Build a fresh matrix for a list of personas and a list of use-cases. Default: pull personas from `icp/icp-cut-*.json` (top 3 segments) and use-cases from `voc/findings/*.json` top JTBD hooks (top 3).

### `--mode audit-channel`
Walk a directory of channel assets (LP, ads, emails) and flag cells where the asset diverges from the canonical claim or proof.

## Inputs

- `--client <client>` (required)
- `--mode <build|audit-channel>` (default build)
- `--personas <comma-list>` (override; default = top-3 from ICP cut)
- `--use-cases <comma-list>` (override; default = top-3 JTBD hooks)
- `--audit-dir <path>` (required for audit-channel mode)

## Substrate reads

- `positioning/positioning-canonical-statement.md`: required; canonical statement.
- `positioning/allowed-claims.md` and `banned-claims.md` (optional): hard validation.
- `icp/icp-cut-*.json` (or `icp/icp.md`): personas.
- `voc/findings/*.json`: use-cases (JTBD), pain language, value-words.
- `product-knowledge/value-pillars.md` and `product-knowledge/`: product capability claims.
- `competitive/status-quo.md` and `competitive/<vendor>.md`: alternative-considered framing per cell.
- `strategy/narrative-*.md`: the new-game framing for the hook line.
- `brand-voice/*.md`: voice guardrails (kill-list, em-dash rule, throat-clearing).

## Output contract

- `clients/<client>/messaging/matrix-<date>.md`: full markdown table per persona × use-case.
- `clients/<client>/messaging/matrix-<date>.yaml`: structured form (one entry per cell).
- `clients/<client>/messaging/drift-log-<date>.md` (audit-channel mode): channel-vs-matrix divergence flags.

## Cell schema (each cell in the matrix)

| Field | Source |
|---|---|
| `persona` | `icp/icp-cut-*.json` (top segments) |
| `use_case` | `voc/findings/*.json` (top JTBD hooks) |
| `pain_verbatim` | `voc/findings/*.json` (objections theme) |
| `trigger` | derived from JTBD hook context |
| `current_path` | `competitive/status-quo.md` |
| `new_game_hook` | `strategy/narrative-*.md` (Act 5) |
| `value_pillars` (max 3) | `product-knowledge/value-pillars.md` |
| `proof_point` | `voc/findings/*.json` (value-words theme) |
| `allowed_claims_check` | regex match against `positioning/allowed-claims.md` |
| `banned_claims_check` | regex match against `positioning/banned-claims.md` |
| `cta` | per channel context (operator-tunable) |

## Quality criteria

- Refuses cells without a real `voc/findings/*.json` citation for `pain_verbatim`.
- Refuses cells with more than 3 value pillars (per `specificity-becomes-profitable`).
- Refuses to ship cells whose claims fail the allowed-claims regex (when the file exists).
- Refuses cells whose copy contains banned-claims terms (when the file exists).
- Voice gate: each cell's hook + proof-point text is checked against the operator-voice rules (no em-dash, no kill-list).

## See also

- `skills/positioning-forge/`: where the canonical statement comes from.
- `skills/narrative-strategy/`: where the new-game framing comes from.
- `skills/narrative-compose/`: where the matrix becomes draft copy.
- `skills/icp-cut/`: where the persona cohort comes from.
- `skills/frontline-contact/`: where the verbatim pain + value language comes from.
- `routines/narrative-drift-routine.md`: monthly check of the matrix against shipped output.
- `knowledge/patterns/jtbd-as-buyer-mental-model.md`.
- `knowledge/patterns/tf-idf-themes-from-customer-language.md`.
