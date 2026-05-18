---
name: status-quo-frame
description: Frames the no-decision / status-quo alternative as the dominant competitor. Extends competitive-scout from named vendors to the largest competitor most categories miss. Operationalises the codex pattern that the status quo is the real competitor.
version: 0.1
amplifies: PMM, founder, sales lead
masters: April Dunford (status quo is the largest competitor in most categories), Andy Raskin (the old game framing), Anthony Pierri (most homepages compete with the buyer doing nothing), Sam Shankarraman (refuse the playbook ask, start with the buyer's current path)
substrate_layers_required: [competitive, voc, positioning, sales-pitch]
patterns_grounded: [status-quo-is-the-competitor, narrative-as-strategy, differentiation-vs-sameness]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-status-quo-record
required_reads:
  - clients/{client}/competitive/00-INDEX.md
  - clients/{client}/voc/processed/win-loss/
---

# status-quo-frame

## Purpose

`competitive-scout` tracks named vendors. This skill tracks the dominant alternative most teams forget: the buyer's current path, including no-decision, internal build, and "we'll fix this with a spreadsheet." In most B2B categories, no-decision wins more deals than any named competitor.

## Inputs

- `--client <client>` (required)
- `--mode <build|refresh|harvest>`
- `--scope <category|product-line|use-case>`

## What this skill produces

A `competitive/status-quo.md` file with:

1. **The buyer's current path.** What the buyer is doing today instead of buying.
2. **The friction in that path.** The cost-in-time, cost-in-money, cost-in-risk.
3. **The trigger that breaks status quo.** The event that makes the buyer look.
4. **The objection to switching.** The cost of change vs the cost of staying.
5. **Win-loss frequency.** % of recent deals lost to status quo.
6. **Counter-frame.** How to make the cost of staying visible to the buyer.

## Substrate reads

- `voc/processed/win-loss/` for status-quo loss patterns.
- `competitive/<vendor>.md` files to compare named-vendor frequency vs no-decision frequency.
- `positioning/positioning-canonical-statement.md` to wire the counter-frame.

## Output contract

- `competitive/status-quo.md`, structured as above.
- A summary line in the master `competitive/00-INDEX.md` with the no-decision deal % and trend.
- A patch proposal to `sales-pitch/` if the counter-frame conflicts with the current sales narrative.

## Conditions awareness (no-decision-vs-named-competitor)

The codex contradiction `no-decision-vs-named-competitor` says category maturity + buyer urgency decide which framing leads.

- **Mature category, low urgency**: status-quo is the dominant competitor (Dunford). This skill picks status-quo-as-lead.
- **New category, high urgency**: named competitor framing leads. This skill defers to `competitive-scout`.
- The chosen position is logged in the artifact's frontmatter.

## Quality criteria

- Refuses to ship without a numeric % from `voc/processed/win-loss/`.
- Refuses to claim status-quo is the dominant competitor without ≥10 logged outcomes.
- Flags drift if the status-quo file hasn't refreshed in 60 days.

## See also

- `skills/competitive-scout/`, the named-vendor counterpart.
- `skills/dunford-value-frame/`, the alternative-vs-product framing.
- `skills/win-loss-interview/`, where the status-quo signal is generated.
- `knowledge/patterns/status-quo-is-the-competitor.md`.
- `knowledge/contradictions/no-decision-vs-named-competitor.md`.
