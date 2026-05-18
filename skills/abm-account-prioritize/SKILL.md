---
name: abm-account-prioritize
description: Score and prioritize a target account list against canonical ICP. Outputs ranked list with ICP-fit + intent-strength + trigger-recency + tier (1A / 1B / 2). Real weighted scoring; refuses without ICP layer.
version: 0.1
amplifies: SDR manager, ABM lead, PMM lead, demand-gen
masters: Sangram Vajre (Terminus, GTM Partners), Jon Miller (Marketo, Engagio, Demandbase), Bev Burgess (ITSMA strategic-account-marketing), Maja Voje (GTM Strategist), Mark Roberge (HubSpot CRO, sales engineering frame), Kyle Lacy (challenger outbound)
substrate_layers_required: [icp, positioning, competitive]
patterns_grounded: [account-not-lead-as-unit, trigger-events-beat-cadence-blast]
contradictions_aware: [outbound-vs-inbound-budget, personalization-vs-scale]
preflight_refusal: substrate-gap, missing-icp, missing-target-accounts
required_reads:
  - clients/{client}/icp/00-INDEX.md
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# abm-account-prioritize

## Purpose

Take a flat list of target accounts (CSV) and a canonical ICP definition, produce a ranked list with tier assignment (1A, 1B, 2), explicit scoring rationale per account, and a hand-off-ready CSV for the SDR pool. Without ranking, the account list is a flat-blast list; with ranking, the SDR pool knows where to spend the per-account research time that hand-personalization requires (per `con_personalization-vs-scale`).

## Inputs

- `--client <client>` (required)
- `--accounts <path-to-csv>` (required) — target account list with at minimum: company, industry, size, tech_stack
- `--category-maturity mature|emerging|hybrid` (required) — picks the contradiction position for outbound-vs-inbound budget framing
- `--icp-version <version>` (optional) — pin to a specific ICP cut version
- `--top-n <int>` (optional, default 100) — limit ranked output to top N
- `--output <path>` (optional) — where to write ranked CSV; default `clients/<client>/sales/account-rankings/<date>-ranked.csv`

## Substrate reads

- `clients/<client>/icp/00-INDEX.md` — pinned ICP definition with firmographic + technographic + behavioral cuts
- `clients/<client>/positioning/positioning-canonical-statement.md` — to ground tier-1A "earns hand-personalization" framing
- `clients/<client>/competitive/` — to detect tech-stack signals (account uses competitor X = displacement target)
- `clients/<client>/sales/triggers/<recent>.md` — if present, recent trigger events are weighted into scoring

## Scoring model

Five weighted features (configurable but defaulted):

| Feature | Weight | Source |
|---|---|---|
| ICP fit (firmographic) | 0.35 | industry + size match against ICP cells |
| Tech-stack signal | 0.20 | uses competitor (displacement) or complementary tool (intent) |
| Trigger recency | 0.20 | trigger event detected within 90-day window |
| Engagement depth | 0.15 | prior touches, intent data, content engagement |
| Strategic value | 0.10 | named-account flag, logo value, vertical leadership |

Score range: 0-100. Tier assignment:
- 1A: score ≥ 75 (hand-personalize, AE-led)
- 1B: score 55-74 (hybrid: smart-variable + 1-2 hand sentences)
- 2: score 35-54 (scaled cadence, SDR pool)
- defer: score < 35 (not worth pursuing this cycle)

## Process

1. Preflight: validate ICP + positioning layers exist; refuse if missing.
2. Load target-accounts CSV; validate required columns.
3. Read ICP cells from `clients/<client>/icp/`.
4. For each account: compute ICP-fit (industry × size × geo match), tech-stack signal (string match against competitor + complementary tool registry), trigger-recency (read latest `sales/triggers/<date>.md` if present), engagement-depth (read intent feed if present, default 0), strategic-value (flagged columns).
5. Composite score = weighted sum. Normalize to 0-100 via percentile within batch.
6. Tier assignment per thresholds above.
7. Write ranked CSV with: original columns + scores per feature + composite + tier + rationale.
8. Write summary markdown with tier counts, top-10 accounts per tier, and the contradiction position applied (per `con_outbound-vs-inbound-budget` — the budget recommendation is conditioned on category maturity).

## Output contract

- `clients/<client>/sales/account-rankings/<date>-ranked.csv` — ranked CSV ready for SDR pool ingestion
- `clients/<client>/sales/account-rankings/<date>-summary.md` — tier distribution, top accounts per tier, contradiction-resolution log, weighting choices

## Quality criteria

- Refuses if ICP layer is missing or stale (>90 days since update without explicit `--force`).
- Refuses if target-accounts CSV is missing required columns (company, industry, size).
- Refuses to assign tier 1A to >15% of accounts (forces honest prioritization; 1A is by definition the top of the list, not a label).
- Tier assignments must respect the `con_personalization-vs-scale` contradiction: 1A always earns hand-personalization, 2 always earns scaled cadence; ambiguous accounts go to 1B.
- Every account in the ranked CSV carries a one-line rationale citing which features drove its tier assignment.

## What this skill does NOT do

- Does NOT generate sequences. That's `outbound-sequence-design`.
- Does NOT detect trigger events. That's `sales-trigger-event-watch`.
- Does NOT route intent data into cohorts. That's `intent-data-route`.
- Does NOT modify the ICP. That's `icp-cut`.

## See also

- `skills/icp-cut/`, the ICP layer this skill reads.
- `skills/outbound-sequence-design/`, what consumes this skill's tier assignments.
- `skills/sales-trigger-event-watch/`, what feeds trigger-recency scoring.
- `skills/account-pursuit-rhythm/`, what consumes tier assignments to design pursuit cadence.
- `knowledge/patterns/account-not-lead-as-unit.md`.
- `knowledge/patterns/trigger-events-beat-cadence-blast.md`.
- `knowledge/contradictions/outbound-vs-inbound-budget.md`.
- `knowledge/contradictions/personalization-vs-scale.md`.
