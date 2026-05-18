---
id: pat_metric-tree-not-metric-stack
title: Metrics organize as a tree, not a flat list; the north-star is the root, supporting metrics are branches, behavioral leading indicators are leaves
captured_date: 2026-05-08
convergence_count: 4
tier: A
domains: [analytics-attribution, growth, pmm, product]
---

# Metric tree, not metric stack

## Convergence

Four operators with growth-and-analytics track records converge on the same complaint about how teams treat metrics: a flat list of "the metrics we track" produces no signal because every metric looks equally important and no metric explains the others. The fix is structural, not analytical. Organize metrics as a tree. The north-star metric is the root. Two to four input metrics are the first-level branches; each captures a lever the team can move (acquisition, activation, retention, monetization, referral). Each input metric decomposes into supporting metrics that operationalize it. At the leaves sit behavioral leading indicators that fire days or weeks before the upstream branches respond.

The shape repeats: tree-not-stack, root-decomposes-to-branches, branches-decompose-to-leaves, leaves-are-fast-signal. Operators differ on the exact taxonomy (some use AARRR, some use input/output, some use pirate metrics) but converge on the structure. A team that cannot draw the tree on a whiteboard is operating on metric-stack substrate; the tree is what makes prioritization tractable.

## Operators

- **Reforge faculty** (Casey Winters, Brian Balfour, Andrew Chen across the Reforge growth program). The "growth model" curriculum centers on building a metric tree from the north-star metric down through input metrics and behavioral drivers. Reforge teaches that the tree IS the strategy: every experiment, every roadmap item, every channel decision is a bet on a specific node in the tree. A flat dashboard tells you what happened; a tree tells you which lever to pull.
- **Casey Winters**, ex-Pinterest, ex-Eventbrite, Reforge. Winters has written that retention is the compounding base of every metric tree; teams that put acquisition at the root mistake the leaves for the trunk. The tree forces explicit conversation about which subtree is broken.
- **Brian Balfour**, ex-HubSpot, Reforge founder. Balfour's "growth loops" framework rests on the metric tree: each loop is a self-reinforcing path from one branch (e.g., new-user acquisition) to a leaf (e.g., invitations sent) and back. The tree is the structural diagram of the business; the loops are how the tree compounds.
- **Rob Sobers**, ex-Varonis, Pacific Lake. Sobers' marketing-attribution and metric-design writing argues that "marketing dashboards with twelve KPIs are noise dashboards." The cure is the same tree-not-stack discipline: pick one north-star, force every other metric to justify itself as a node beneath it.

## Variation

- Reforge frames the tree as a *growth-model curriculum* (north-star + input metrics + behavioral drivers).
- Winters frames it through the *retention-as-trunk* claim (mis-rooting the tree mis-allocates work).
- Balfour frames it through the *growth-loops overlay* (loops are the diagram of compounding).
- Sobers frames it through *attribution-readability* (one north-star prevents the twelve-KPI noise dashboard).
- Convergence: a flat metric stack is a dashboard, not a strategy; the tree is the strategy.

## Implication

A team with a flat metric list is operating on stack substrate. The fix is to draw the tree explicitly, in a single artifact, that every function reads. The tree carries: (1) the north-star metric at the root, with the cadence and source-system; (2) input metrics as first-level branches, each named with the lever it represents; (3) supporting metrics one level down that decompose each input; (4) behavioral leading indicators at the leaves that fire fast.

Skills that touch metrics must declare which node of the tree they operate on. A retention skill operates on the retention branch. A paid-ads skill operates on the acquisition branch. A pricing skill operates on the monetization branch. The skill's measurement contract names the node, the parent, and the cadence. Skills that touch metrics without naming the node are operating on flat-stack substrate.

When a metric drifts, the tree tells you which branch to investigate first. When a goal opens, the tree tells you which subtree the goal lives in. When two functions argue about priorities, the tree resolves the argument: each function's request maps to a node, and the team picks based on which subtree the company most needs to move this quarter.

## Sources

- Reforge "Growth Series" curriculum, growth model module (multiple cohorts, public lessons available), reforge.com.
- Casey Winters, "Why retention is the single most important growth metric," reforge.com / caseyaccidental.com.
- Brian Balfour, "The four fits for $100M+ growth," brianbalfour.com (the four-fits framework rests on the metric tree).
- Rob Sobers, marketing-and-metrics writing, robsobers.com (multiple posts on simplifying marketing dashboards via north-star + tree).
