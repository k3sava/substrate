---
name: ad-diagnose
description: Audit an ad-account export (Google Ads, Meta, LinkedIn) for waste, fatigue, ICP mismatch, and positioning drift. Reads CSV exports, computes per-campaign CAC and conversion-value math, flags fatigue candidates and audiences not in the canonical ICP, writes structured findings under clients/<client>/ads/diagnostics/.
version: 0.1
amplifies: paid-marketing lead, growth lead, founder running paid
masters: Susan Wenograd (creative-is-targeting paid-social diagnostic), Andrew Foxwell (cadence and creative-volume diagnostic), Aaron Orendorff (Common Thread Collective performance audits), Avinash Kaushik (See/Think/Do/Care channel-mismatch diagnostic), Kasim Aslam (search vs social KPI separation), April Dunford (positioning audit applied to ad copy)
substrate_layers_required: [icp, positioning, voc, competitive, brand-voice]
patterns_grounded: [creative-fatigue-window, intent-vs-interest-targeting, incrementality-not-attribution, buyer-mindset-not-product-features]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-icp, missing-positioning, missing-export
required_reads:
  - clients/{client}/02-icp.md
  - clients/{client}/01-position.md
  - clients/{client}/04-competitive.md
---

# ad-diagnose

## Purpose

Read an ad-account export and produce a structured diagnostic that names: waste (campaigns burning budget on conversions that do not return value), fatigue (creatives or campaigns whose performance is decaying), ICP mismatch (audiences that do not match the canonical ICP), and positioning drift (ad copy that contradicts the canonical positioning statement). The output is the input for `ad-spend-allocate` and `ad-creative-design`.

The skill refuses to run without the canonical ICP and the canonical positioning statement, because every diagnostic claim depends on them. An audit run without the ICP layer cannot tell ICP mismatch from working prospecting; an audit run without positioning cannot tell creative drift from valid testing.

## Inputs

- `--client <client>` (required)
- `--export <path>` (required) path to a CSV export. Headers required: `campaign`, `impressions`, `clicks`, `spend`, `conversions`, `conv_value`. Optional: `ad_set`, `creative_id`, `date`, `frequency`, `cpm`, `channel`, `match_type`.
- `--channel <google-search|google-pmax|google-display|meta-paid-social|linkedin-sponsored|tiktok|x|reddit>` (required) which channel this export is from.
- `--target-cac <usd>` (optional) target CAC for waste flagging. If not provided, reads from `clients/<client>/ads/config/target-cac.yaml` or falls back to `2x median observed CAC`.
- `--ltv <usd>` (optional) used for ROAS thresholds. Default reads from `clients/<client>/ads/config/ltv.yaml`.
- `--window <days>` (optional, default 30) lookback window for fatigue detection.
- `--out <dir>` (optional, default `clients/<client>/ads/diagnostics/`)

## Substrate reads

- `clients/<client>/02-icp.md` for the canonical ICP fields (verticals, company size, role, decision authority, geo).
- `clients/<client>/01-position.md` for the canonical positioning statement and the message house.
- `clients/<client>/04-competitive.md` for status-quo framing and competitor names.
- `clients/<client>/07-brand-voice.md` for the kill-list and voice rules applied to ad copy.
- `clients/<client>/03-voice-of-customer.md` for the language buyers actually use, used to detect copy that does not match the buyer panel.

## Output contract

Writes a single dated diagnostic file at `clients/<client>/ads/diagnostics/<channel>-<YYYY-MM-DD>.md` with frontmatter:

```yaml
---
diagnostic_id: <client>-ads-<channel>-<YYYY-MM-DD>
channel: <channel>
window: <days>
export_path: <path>
substrate_layers_read: [icp, positioning, voc, competitive, brand-voice]
patterns_applied: [creative-fatigue-window, intent-vs-interest-targeting, incrementality-not-attribution]
contradictions_resolved: [no-decision-vs-named-competitor]
diagnostic_summary:
  total_spend_usd: <integer>
  total_conversions: <integer>
  observed_cac_usd: <integer>
  target_cac_usd: <integer>
  waste_flag_count: <integer>
  fatigue_flag_count: <integer>
  icp_mismatch_flag_count: <integer>
  positioning_drift_flag_count: <integer>
---
```

Body sections:

1. **Executive summary** five lines on the state of the account against the canonical positioning and ICP.
2. **Per-campaign CAC table** sorted by CAC descending, with columns: campaign, spend, conversions, CAC, conv-value, ROAS, status.
3. **Waste candidates** campaigns above target-CAC by more than 50%, or spending without conversions across the window.
4. **Fatigue candidates** campaigns / creatives matching at least one fatigue threshold (CTR decline above 30% over 14 days, frequency above 3.0 on Meta, CPM rise above 25%).
5. **ICP-mismatch flags** audiences whose described targeting (campaign name, ad-set name, or annotated audience signals) does not match the canonical ICP.
6. **Positioning-drift flags** campaigns whose names or annotated copy contradict the canonical positioning (for example, a campaign that promotes a use case the canonical statement explicitly puts behind the bowling-pin).
7. **Channel-fit note** which pattern (`intent-vs-interest-targeting`) applies and whether the KPI being held against this channel is the right one.
8. **Recommended next moves** which campaigns to pause, refresh, or scale, with the substrate citation that justifies each.

The recommendations are advisory; this skill does not change ad accounts. It produces the diagnostic that an operator (or `ad-spend-allocate`) acts on.

## Quality criteria

- Every recommendation cites a substrate path from one of the layers above.
- Fatigue flags name the threshold that tripped, not just "looks tired."
- ICP-mismatch flags name the canonical ICP attribute that is violated.
- Positioning-drift flags quote the canonical positioning passage.

## What this skill does NOT do

- Does not change anything in the ad account. Diagnostic only.
- Does not pull the export from the platform. The operator (or a downstream connector) provides the CSV.
- Does not measure incrementality on its own; that is `ad-incrementality-test`.
- Does not generate replacement creative; that is `ad-creative-design`.

## Refusal patterns

- Missing ICP layer at `clients/<client>/02-icp.md` returns `SUBSTRATE-GAP — missing-icp`.
- Missing positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Missing or empty export returns `INPUT-GAP — export-missing-or-empty`.
- CSV missing required headers returns `INPUT-GAP — required-header-missing: <header>`.
- ICP layer marked stale (past freshness window per `clients/<client>/00-INDEX.md`) returns `SUBSTRATE-STALE — icp-past-window`. Run `refresh-knowledge` first.

## See also

- `ad-spend-allocate` consumes the per-campaign CAC table for budget allocation.
- `ad-creative-design` consumes the positioning-drift flags to brief replacement creative.
- `ad-fatigue-monitor` runs this skill weekly and flags new fatigue candidates.
- `competitive-scout` produces the competitive observations the diagnostic reads.
- `routines/ad-fatigue-routine.md` schedules the recurring fatigue diagnostic.
