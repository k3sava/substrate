---
name: deflection-experiment-design
description: Design a real ticket-deflection experiment (variants, holdout, measurement contract) for the highest-volume support clusters. Variants tier through chatbot suggest, article surface, community route, and human escalation in the right-routing ladder. Refuses without ticket clusters input or with a deflection-rate-only measurement (the pattern: deflection is a side effect of right-routing, not the goal).
version: 0.1
amplifies: head of support, head of CS, head of growth, RevOps, head of product
masters: Frederick Reichheld (effort score; loyalty math on channel-forcing), Bain CX research (channel-forcing harms), Tien Tzuo (subscription-renewal math; every contact is a renewal moment), Lincoln Murphy (deflection-removes-leading-indicator frame), Christensen (jobs-to-be-done; the customer is hiring the support contact for an outcome)
substrate_layers_required: [icp, voc, product-knowledge, brand-voice]
patterns_grounded: [deflection-is-not-the-goal, tickets-are-product-feedback-channel]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-clusters, deflection-only-measurement
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/icp/icp.md
  - clients/{client}/voc/voc.md
  - clients/{client}/product-knowledge/product-knowledge.md
  - clients/{client}/brand-voice/brand-voice.md
---

# deflection-experiment-design

## Purpose

Design a real ticket-deflection experiment that the support and growth teams can run. The variants tier through the right-routing ladder: chatbot suggest, surfaced article, community route, human escalation. The control is the current routing flow. The measurement contract requires both a deflection metric and a customer-effort or CSAT metric; per the `deflection-is-not-the-goal` pattern, an experiment that measures deflection only is rejected. The skill refuses with `deflection-only-measurement`.

The skill picks the cluster to test from the cluster JSON output of `ticket-cluster-analysis`. The largest, lowest-CSAT, frequently-recurring clusters are the priority candidates; the operator can override with `--cluster <id>`.

## Inputs

- `--client <client>` (required)
- `--clusters <path>` (required), JSON output from `ticket-cluster-analysis`.
- `--cluster <cluster_id>` (optional), specific cluster to test; default picks the highest-priority cluster from the input.
- `--variant-mode <ladder|article-only|chatbot-only|community-only>` (default: `ladder`, runs the full right-routing ladder).
- `--holdout-share <float>` (default: 0.30, fraction of eligible tickets routed to the control flow).
- `--duration-days <int>` (default: 28, the experiment runs at minimum a 4-week window for statistical reads).
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/icp/icp.md`, to identify ICP-fit bands so the experiment can stratify.
- `clients/{client}/voc/voc.md`, to mirror customer language in any deflection copy.
- `clients/{client}/product-knowledge/product-knowledge.md`, to ground article suggestions in real product behavior.
- `clients/{client}/brand-voice/brand-voice.md`, to enforce the voice gate on chatbot / article / community copy.

## Process

1. **Preflight**. Verify substrate layers, the clusters JSON, and the cluster the operator picked exists. Refuse with `substrate-gap`, `missing-clusters`, or `cluster-not-found`.
2. **Pick the cluster**. If `--cluster` is set, use it. Else pick the highest-priority cluster from the input (size × CSAT-deficit). Refuse if the cluster is too small (under 50 instances in the corpus) with `insufficient-volume`.
3. **Compose variants**. For `--variant-mode ladder`:
   - Variant A: control (current routing).
   - Variant B: chatbot-suggest (the bot proposes an answer; user can accept or escalate).
   - Variant C: article-surface (link to the relevant help article surfaced inline; user can read and resolve, or escalate).
   - Variant D: community-route (route to the community thread on the topic; user can read peers' answers, or escalate).
   - Variant E: human-direct (escalate immediately to a human, no automation; this is the right-routing arm for high-effort intents).
4. **Compose measurement contract**. Two required metrics: (a) deflection-or-resolution rate (proportion of tickets resolved in the variant arm without escalation), and (b) effort-or-CSAT score (post-interaction Likert from the interaction). Both must be present; the skill refuses with `deflection-only-measurement` if the operator overrides to deflection-only.
5. **Compose stratification**. Stratify by ICP-fit band when ICP data is present in the clusters JSON.
6. **Compose duration and sample-size note**. The duration is at least 28 days. The sample-size note describes the minimum tickets-per-arm required for the chosen lift detection (provided as a heuristic; operators run a power calculation before launch).
7. **Voice gate**. Run the voice gate on all customer-facing copy across variants. Refuse with `voice-gate-failed`.
8. **Output**. Write the experiment spec markdown plus a JSON sidecar.

## Output contract

Two artifacts under `clients/{client}/support/`:

1. `deflection-experiment-{cluster_id}-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Cluster context (which cluster, why it was picked, size, current CSAT).
   - Variants table (control + automation variants in the right-routing ladder).
   - Measurement contract (deflection-or-resolution rate AND effort-or-CSAT; baseline; predicted lift; resolution date).
   - Stratification plan (ICP-fit band).
   - Sample-size and duration note.
   - Voice gate result.
   - Failure modes the experiment should guard against.
   - Substrate citations.
2. `deflection-experiment-{cluster_id}-{YYYY-MM-DD}.json`, structured spec.

## Quality criteria

- Refuses without a clusters JSON.
- Refuses with `deflection-only-measurement` if the operator attempts to drop the effort/CSAT metric. Per the pattern, a deflection-only metric is the failure mode this skill exists to prevent.
- Refuses if the named cluster has under 50 tickets in the corpus (`insufficient-volume`).
- Refuses with `holdout-too-small` if `--holdout-share` is below 0.10. A test without a meaningful holdout has no read.
- Refuses with `duration-too-short` if `--duration-days` is below 14.
- Voice gate runs on all customer-facing copy; refuses on failure.
- Records the cluster_id, the chosen variants, the holdout, and the predicted lift in the output.

## What this skill does NOT do

- Does not run the experiment. Spec only; the operator wires it into the support tooling.
- Does not write the chatbot rules. That is downstream tooling.
- Does not write the help article. That is `help-docs`.
- Does not score CSAT trends post-experiment. That is downstream analysis.

## Refusal patterns

- `substrate-gap`: missing icp / voc / product-knowledge / brand-voice.
- `missing-clusters`: clusters JSON path not present.
- `cluster-not-found`: the named cluster_id is not in the input.
- `insufficient-volume`: the cluster has fewer than 50 tickets.
- `deflection-only-measurement`: the operator dropped the CSAT/effort metric; refuses.
- `holdout-too-small`: holdout below 10%.
- `duration-too-short`: duration below 14 days.
- `voice-gate-failed`: copy contains kill-list words, em-dashes in body, or throat-clearing openers.

## Composes with

- Reads from: clusters JSON (from `ticket-cluster-analysis`), substrate layers, optionally help-docs catalog (when chosen variants reference articles).
- Writes for: support / growth / product teams to wire into tooling; the post-experiment read feeds back into `ticket-cluster-analysis` (to see whether the cluster shrank) and `csat-loop-design` (to see whether CSAT held).
- Triggered by: monthly support cluster routine, AEO content roadmap, growth-experiment queue.

## Calibration

Tracked under taste-types `retention` and `narrative`. Brier signal: predicted deflection-or-resolution lift, predicted effort-or-CSAT change, both verified at experiment close (resolution date in the contract).

## See also

- `knowledge/patterns/deflection-is-not-the-goal.md`
- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `skills/ticket-cluster-analysis/SKILL.md`
- `skills/help-content-gap-detect/SKILL.md`
- `skills/csat-loop-design/SKILL.md`
- `routines/support-cluster-monthly.md`
