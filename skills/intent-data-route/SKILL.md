---
name: intent-data-route
description: Route intent signals (G2 visits, review reads, doc visits, ad clicks) to ICP cohort + recommended next-action (nurture, outbound-now, fast-track, disqualify). Reads intent feed CSV, maps to cohort, decides cadence.
version: 0.1
amplifies: SDR manager, ABM lead, demand-gen, RevOps
masters: Latane Conant (6sense intent doctrine), Jon Miller (Demandbase, account-engagement), Sangram Vajre (TEAM model), Maja Voje (cohort scoring weight), Mark Roberge (sales engineering — intent as routing signal)
substrate_layers_required: [icp]
patterns_grounded: [account-not-lead-as-unit, trigger-events-beat-cadence-blast]
contradictions_aware: [personalization-vs-scale]
preflight_refusal: substrate-gap, missing-intent-feed, missing-icp
required_reads:
  - clients/{client}/icp/00-INDEX.md
  - clients/{client}/sales/intent-feed/latest.csv
---

# intent-data-route

## Purpose

Take an intent feed (G2 / Bombora / generic) and produce a routed action list per account. Intent without routing is noise; the value comes from mapping the signal to the right ICP cohort and the right next action. The routing decision is conditioned on `con_personalization-vs-scale` — high-intent + tier-1A goes to AE for hand-personalized outreach; low-intent + tier-2 goes to nurture; mid-intent goes through the SDR pool with smart-variable cadence.

## Inputs

- `--client <client>` (required)
- `--feed <path>` (optional) — defaults to `clients/<client>/sales/intent-feed/latest.csv`
- `--rankings <path>` (optional) — most recent ranked CSV from abm-account-prioritize for tier lookup
- `--threshold-high <int>` (default 75) — intent score above this triggers fast-track
- `--threshold-mid <int>` (default 40) — intent score between mid and high triggers outbound-now
- `--threshold-low <int>` (default 15) — intent score below low triggers disqualify-or-nurture-decay
- `--output <path>` — defaults to `clients/<client>/sales/intent-routing/<date>-routed.csv`

## Intent feed format expected

CSV columns (case-insensitive):
- `company` (required) — account name
- `domain` (optional) — for matching
- `signal_type` (optional) — g2-visit | g2-comparison | doc-visit | review-read | pricing-page | ad-click | webinar | other
- `signal_topic` (optional) — what they're looking at (e.g., "competitor-X comparison", "API docs")
- `total_score` or `score` (required) — 0-100 intent score
- `signal_count` (optional) — number of touches in feed window
- `surge` (optional) — boolean / 1-0 marking a recent surge

## Routing decisions

| Score | Tier (from rankings) | Recent trigger | Action | Owner |
|---|---|---|---|---|
| ≥75 | 1A or 1B | yes | fast-track: AE meeting in 48h | AE |
| ≥75 | 1A or 1B | no | fast-track: AE meeting in 5 days | AE |
| ≥75 | 2 | any | outbound-now: SDR sprint cadence | SDR |
| 40-74 | 1A or 1B | any | outbound-now: hybrid cadence | SDR-AE |
| 40-74 | 2 | any | nurture: scaled cadence, monthly | SDR pool |
| 15-39 | 1A or 1B | yes | nurture-with-trigger-anchor: light outbound | SDR |
| 15-39 | any | no | nurture: content-only, quarterly | marketing |
| <15 | any | any | disqualify-this-cycle: flag, revisit 90d | — |

If `--rankings` is not provided, tier defaults to 1B (mid-priority assumption).

## Substrate reads

- `clients/<client>/icp/00-INDEX.md` — anti-ICP filter (account in anti-ICP industry → disqualify regardless of intent)
- `clients/<client>/sales/account-rankings/<latest>-ranked.csv` — for tier lookup
- `clients/<client>/sales/triggers/<recent>.md` — for trigger-recency cross-reference

## Process

1. Preflight: validate ICP layer + intent feed exist.
2. Load feed; validate required columns; lowercase keys.
3. Load rankings (if available) for tier lookup; build company → tier map.
4. Load most-recent triggers file (if available) for trigger-recency cross-ref.
5. For each row in feed:
   a. Drop if company in anti-ICP industry (per ICP).
   b. Look up tier from rankings (default 1B).
   c. Look up trigger-recency (yes if any trigger in last 60d).
   d. Apply routing matrix → action + owner.
   e. Generate one-line rationale.
6. Write routed CSV with: original feed columns + tier + has_recent_trigger + action + owner + rationale.
7. Write summary markdown with action distribution and contradiction-resolution log.

## Output contract

- `clients/<client>/sales/intent-routing/<date>-routed.csv`
- `clients/<client>/sales/intent-routing/<date>-summary.md`

## Quality criteria

- Refuses without intent feed.
- Refuses without ICP layer (anti-ICP filter is non-negotiable).
- Each routed account carries a one-line rationale: which thresholds triggered the decision.
- Anti-ICP accounts are dropped from outbound regardless of intent score (intent without fit is noise).
- Fast-track accounts (high intent + 1A) are flagged for SLA tracking — AE must reach within 48h.

## Refusal patterns

- Intent feed missing → refuse.
- Intent feed has no `score` column → refuse (the routing math is unconditional on score).
- ICP layer missing → refuse (anti-ICP filter is required).
- More than 50% of feed rows route to "fast-track" without explicit `--force` → refuse (suggests threshold mis-calibration; fast-track is by definition the top of the intent list).

## What this skill does NOT do

- Does NOT generate copy. The routing produces an action; outbound-sequence-design produces the touches.
- Does NOT update the ICP. That's icp-cut.
- Does NOT change tier assignments. That's abm-account-prioritize.
- Does NOT detect intent (this assumes a feed). The feed comes from G2 / Bombora / 6sense / Demandbase or an internal aggregator.

## See also

- `skills/abm-account-prioritize/` — produces the rankings this skill reads for tier.
- `skills/sales-trigger-event-watch/` — produces the trigger files this skill cross-references.
- `skills/outbound-sequence-design/` — consumes the action assignments for fast-track and outbound-now buckets.
- `knowledge/patterns/account-not-lead-as-unit.md`.
- `knowledge/patterns/trigger-events-beat-cadence-blast.md`.
- `knowledge/contradictions/personalization-vs-scale.md`.
