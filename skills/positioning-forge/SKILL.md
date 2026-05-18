---
name: positioning-forge
description: Forge positioning from substrate. VPC + JTBD + category design + value-of-X-vs-Y synthesis. Outputs the message house that every asset descends from.
version: 0.1
amplifies: PMM lead, founder, head of marketing
masters: April Dunford (Obviously Awesome, context-of-use positioning), Geoffrey Moore (Crossing the Chasm, bowling pin), Al Ries + Jack Trout (category design), Andy Raskin (strategic narrative), Christensen (JTBD, forces-of-progress), Tony Ulwick (outcome-driven innovation), Strategyzer (Value Proposition Canvas), Bob Moesta (push/pull/anxiety/habit), Eddie Yoon (category creation)
substrate_index_version: 2026-05-08
substrate_layers_required: [positioning, icp, voc, competitive, product-knowledge, market-context]
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md          # mandatory first read — product + ICP + allowed-claims + competitor one-liners
  - clients/{client}/substrate/positioning-canonical-statement-*.md  # most-recent canonical statement (if forged previously)
  - clients/{client}/substrate/competitive-cross-cut-matrix-*.md     # most-recent competitive matrix
---

# positioning-forge

## Purpose

Take substrate (icp + voc + competitive + product-knowledge) and forge a single positioning statement + message house. Not multiple positions for multiple audiences — one canonical position with audience-specific reframing.

## Inputs

- `--client <client>`
- `--scope <whole-product|product-line|feature|segment>`
- `--audience <icp-id>` (optional — defaults to primary ICP)

## Process

1. Read substrate: positioning.md (current state), icp.md, voc.md, competitive.md, product-knowledge.md.
2. Run Dunford 5-step: (a) competitive alternatives, (b) unique attributes, (c) value themes, (d) target market characteristics, (e) market category.
3. Run JTBD overlay: forces of progress (push, pull, anxiety, habit) per audience segment.
4. Run Strategyzer VPC: jobs / pains / gains × pain relievers / gain creators / products.
5. Run Raskin strategic narrative: old game / new game / promised land / obstacles / proof.
6. Synthesize: one positioning statement + 3-pillar message house + per-pillar headline/support/evidence.
7. Diff against current positioning.md. If material change, flag for human review before write.
8. Write to `clients/<client>/substrate/positioning.md`. Update decay.

## Output

A new positioning.md (with diff) + a positioning brief at `clients/<client>/personas/positioning-brief-<date>.md` for downstream skills to consume.

## Gates

- **Substrate-grounded:** every positioning claim cites a substrate path.
- **Falsifiable:** value themes must be testable (synth-audience can score them).
- **One canonical position:** multiple positions = positioning failure. Audience reframing is allowed; multiple positions is not.

## Composes with

Reads from: substrate-curate's output.
Writes for: narrative-compose, copywrite, lp-ship, ad-ship, all asset skills.
Triggered by: substrate change in icp/voc/competitive, quarterly refresh, signal→bet workflow.

## Refusal patterns

- Substrate has gaps (icp empty, voc thin) → run substrate-curate first; reject positioning forge.
- Operator wants 3 different positioning statements for 3 audiences → reject; one canonical position with reframing.

## Calibration

Tracked under taste-type `narrative`. Brier signal: positioning brief feeds N assets within 90 days; assets that win in synth-audience + ship + measure resolve toward positioning quality.

## Substrate preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/substrate/00-INDEX-10-layers-2026-04-30.md`. If any required layer is `thin` or `partial`, the skill returns:

```
SUBSTRATE-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.

