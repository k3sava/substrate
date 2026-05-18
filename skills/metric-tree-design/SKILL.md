---
name: metric-tree-design
description: Design the client's north-star + supporting metric tree per the Reforge metric-tree pattern. Outputs a tree (markdown + yaml) where each metric carries source-system, definition, refresh cadence, and parent node. Refuses without ICP. Forces explicit conversation about which subtree is broken.
version: 0.1
amplifies: PMM lead, growth lead, head of analytics, RevOps, founder, CEO
masters: Reforge faculty (Casey Winters, Brian Balfour, Andrew Chen on growth-model curriculum), Casey Winters (retention as the trunk), Brian Balfour (growth loops as the diagram of compounding), Rob Sobers (one north-star prevents twelve-KPI noise), Sean Ellis (north-star metric origin), Lenny Rachitsky (named-company metric trees), Reichheld (loyalty as compounding metric)
substrate_layers_required: [icp, positioning, product-knowledge]
patterns_grounded: [metric-tree-not-metric-stack, goalpost-discipline-vs-metric-drift]
preflight_refusal: substrate-gap, missing-icp
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/positioning/positioning.md
  - clients/{client}/product-knowledge/product-knowledge.md
---

# metric-tree-design

## Purpose

Build the metric tree the client uses for prioritization, reporting, and goal-opening. Per the `metric-tree-not-metric-stack` pattern, a flat list of "the metrics we track" produces no signal because every metric looks equally important. The tree organizes metrics structurally: a north-star metric at the root, two-to-four input metrics as branches, supporting metrics decomposing each branch, and behavioral leading indicators at the leaves. Once drawn, the tree IS the strategy: every experiment, every roadmap item, every channel decision is a bet on a specific node.

The skill produces both a human-readable tree (markdown with ASCII / unicode tree art) and a machine-readable tree (YAML with parent / cadence / source-system per node). Downstream skills (`dashboard-spec`, `lift-test-design`) read the YAML and gate against it: a goal that does not map to a node fails preflight.

## Inputs

- `--client <client>` (required)
- `--north-star <metric-name>` (optional; if omitted the skill proposes 2-3 candidates from the substrate and refuses to lock without operator pick)
- `--input-axes <acquisition,activation,retention,monetization,referral>` (default: AARRR; alternate frames: input/output, JTBD-segments, business-line)
- `--depth <int>` (default: 3; tree depth from north-star to deepest leaf)
- `--update` (refresh an existing tree by reading the prior YAML and surfacing drift)

## Substrate reads

- `clients/{client}/icp/icp.md`, to align north-star wording with the buyer's outcome (per Rule 4: outcomes, not features).
- `clients/{client}/positioning/positioning.md`, to ensure the north-star reflects positioning, not feature inventory.
- `clients/{client}/product-knowledge/product-knowledge.md`, to anchor activation and retention nodes in real product behavior.
- `clients/{client}/analytics/sources.yaml` (when present), to source-system every node (Amplitude / HubSpot / Stripe / etc.).
- `clients/{client}/analytics/events.yaml` (when present), to map behavioral-leaf metrics to declared events.

## Output contract

Two artifacts at `clients/{client}/analytics/`:

1. `metric-tree.md`, the human-readable artifact:
   - **Tree visualization** (ASCII / unicode tree art with each node + cadence + source-system).
   - **Per-node detail** sections for every metric: name, definition (one sentence), source-system query (chart ID or SQL fragment), refresh cadence, parent node, owner, freshness window.
   - **Substrate citations**: each node cites the substrate path that justifies its inclusion.
   - **Open questions**: nodes the skill proposed but the operator must lock; gaps in source-system data.
   - **Drift log** (when `--update`): nodes added, renamed, deleted, with attribution.

2. `metric-tree.yaml`, the machine-readable artifact:
   - Top-level: `north_star`, `last_updated`, `version`, `freshness_window_days`.
   - `nodes`: list of metric records, each with `id`, `name`, `parent_id`, `definition`, `source_system`, `query`, `cadence`, `owner`, `freshness_window_days`, `node_kind` (north-star | input | supporting | leaf).

The skill also emits an **audit checklist** at `clients/{client}/analytics/metric-tree-audit-checklist.md`: per-node checklist for the next quarterly review (was the cadence honored, did the source-system query change, did the owner change, did the definition drift).

## Quality criteria

- Refuses without ICP. The north-star metric must reflect the buyer's outcome; without ICP, the metric is a guess about what the team thinks matters.
- Refuses to lock a tree with more than 4 input metrics under the north-star. Per the pattern, more than 4 inputs is a sign the team has not picked.
- Refuses to lock a tree with more than 12 leaves (tree fits on one page; if it does not, the team has not pruned).
- Every node carries a source-system. Nodes without a source-system are flagged "data-gap" and the tree refuses to lock until the gap is named (or accepted with `--accept-gaps`).
- Every node carries a refresh cadence. Real-time, daily, weekly, monthly, quarterly. Nodes without a cadence are flagged.
- Per `goalpost-discipline-vs-metric-drift`, the YAML carries `version` and `last_updated`; the audit checklist forces a per-quarter review of definition drift.

## What this skill does NOT do

- Does not pull data. That is `analytics-pull`.
- Does not generate dashboards. That is `dashboard-spec` (which reads this tree's YAML).
- Does not pick the north-star automatically. The skill proposes candidates from substrate; the operator picks. Per Rule 7 (pull, never push): the team that picks the north-star owns it.
- Does not invent definitions. Each node's definition must trace to substrate (positioning, product-knowledge, ICP) or be marked `pending` and refused on lock.

## Refusal patterns

- `substrate-gap`: missing ICP / positioning / product-knowledge.
- `missing-icp`: ICP not present; the tree cannot align to buyer outcome.
- `too-many-inputs`: more than 4 input metrics under the north-star.
- `too-many-leaves`: more than 12 leaves (tree must fit on one page).
- `data-gap`: a node has no source-system; refuses to lock unless `--accept-gaps`.
- `cadence-missing`: a node has no refresh cadence.

## Composes with

- Reads from: ICP, positioning, product-knowledge, sources.yaml, events.yaml.
- Writes for: `dashboard-spec` (reads the YAML to generate dashboards), `lift-test-design` (reads the tree to know which node a test affects), `open-goal` (reads the tree to validate goal-to-node mapping), `analytics-monthly-refresh` routine (reads the tree to validate cadence honoring).
- Triggered by: quarterly metric review, north-star debate, new product line, ICP redefinition, metric drift surfaced by `event-taxonomy-audit`.

## Calibration

Tracked under taste-types `analytics-strategy` and `narrative` (because the north-star is fundamentally a narrative claim about what the business is for). Brier signal: nodes that the team predicted would move with a given intervention should move within the predicted window; off-tree movement is a tree-design failure.

## See also

- `knowledge/patterns/metric-tree-not-metric-stack.md` (load-bearing).
- `knowledge/patterns/goalpost-discipline-vs-metric-drift.md`.
- `templates/metric-tree-example.md` (canonical artifact shape).
- `skills/dashboard-spec/SKILL.md`.
- `skills/lift-test-design/SKILL.md`.
- `routines/analytics-monthly-refresh.md`.
