---
title: Q3 Meta + Google ads diagnostic
asset_type: external-customer
produced_by: ad-diagnose
last_updated: 2026-05-08
substrate_consumed:
  - clients/example/01-position.md
  - clients/example/02-icp.md
  - clients/example/03-voice-of-customer.md
contradiction_positions:
  no-decision-vs-named-competitor: A
position_rationale:
  no-decision-vs-named-competitor: Picked Position A because the loss interviews this quarter return ">40% no-decision" replies (verbatim "we just didn't think the problem was big enough yet"), which conditions toward status-quo framing rather than competitor-displacement copy.
---

# Q3 paid diagnostic — Meta + Google account audit

This diagnostic audits the Q3 Meta + Google spend against the canonical ICP and positioning. Findings drive next-quarter creative production volume and channel allocation. Every claim cites a substrate path.

## Channel separation — different funnels, different unit economics

Search ads buys intent; paid social buys interest. The two are not interchangeable. Holding both channels to the same KPI (single blended CAC) misallocates budget toward the channel with the more legible numbers and starves the channel that produced the harder-to-attribute long-run pipeline. We separate the dashboards by channel and budget per channel.

For Meta: assisted conversions, branded-search lift after each campaign launches, cohort-level CAC over a 60-90 day window. Last-click CAC undercount on Meta is a known bias and is not the primary KPI here.

For Google search: cost per qualified lead, MQL-to-SQL rate, demo-to-close rate. ROAS is reasonable here because the buyer's intent is captured in the query.

The See/Think/Do/Care framing applies. Paid social runs in See / Think (audience awareness + demand generation). Search runs in Do (purchase intent). Mismeasuring across stages is the most common cause of digital-marketing budget misallocation.

## Creative fatigue is the upstream cause of CAC drift

Creatives lose efficiency on a measurable window, commonly weeks 3 through 5 for a single asset against a single audience. Refresh cadence is the lever, not bidding. Trying to fix a fatiguing campaign through bidding or audience expansion treats the symptom.

We audited creative volume against the brief: the team shipped 3 creatives per week against the Meta brief, target was 10+. New-creative volume in May was below the cadence target; CAC drift showed up in the dashboard 14-21 days later. This is the visible symptom; missing creative pipeline is the actual cause.

Fatigue thresholds tripped on three campaigns: CTR decline above 30% over 14 days from peak (camp_meta_q3_a), frequency above 3.0 on Meta (camp_meta_q3_b), CPM rise above 25% (camp_meta_q3_c). These variants are queued for refresh, not bid adjustment. The asset-led structure (hook, story, offer) is the upstream cause; creative refresh cadence is the operating cycle.

## Incrementality, not attribution

Standard attribution models systematically overcount the impact of channels that intercept demand and undercount the impact of channels that create demand. Platform-reported ROAS for Meta diverges from incremental ROAS by 2x to 5x in mature accounts; scaling spend on platform-reported ROAS overshoots the actual demand. The only credible measure here is a designed test (geographic holdout, ghost ads, conversion-lift study).

Recommendation: run a geographic holdout next quarter for Meta (above 5% of marketing budget). Pick matched-market pairs; turn paid spend off in one set, leave it on in the other; measure conversion delta over a 4-6 week window. The delta is the actual incremental impact; the platform-reported number is the upper bound.

We refuse to allocate budget across Meta and Google using each platform's self-reported ROAS, because both platforms double-count the same conversion under different attribution models. The attribution model is named explicitly on every cross-channel claim. Blended CAC is reported only with an attribution-model footnote.

## Buyer mindset, not product features

The ICP we audited covers buyers in three mindset states: implied need, explicit need, and FOMU (fear of missing out). Ad copy that reads as feature-detail lands on the explicit-need mindset only. The implied-need cohort needs Setup-Follow-Through framing rather than feature copy. The FOMU cohort responds to the cost-of-inaction frame.

Loss interviews this quarter showed >40% no-decision losses, verbatim: "we just didn't think the problem was big enough yet." That conditions the next round of creative on status-quo framing rather than competitor-displacement copy. JOLT-style indecision diagnostics apply. Tactical empathy on the discovery touch surfaces the mindset before the pitch.

## Recommendation

Approve creative production scale-up to 10+ per week on Meta. Open a quarterly geo-holdout test on Meta for incrementality measurement. Re-frame ad copy on the implied-need mindset cohort to Setup-Follow-Through. The diagnosis is the deliverable; the next-quarter plan descends from it.
