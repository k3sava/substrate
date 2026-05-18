---
name: ad-fatigue-monitor
description: Weekly routine logic that scans active creatives across recent ad-account exports, flags candidates for refresh against channel-specific thresholds (CTR decline, frequency, CPM rise), and writes a dated fatigue-flags file plus a queue of refresh briefs. Refuses without recent ad-diagnose history.
version: 0.1
amplifies: paid-marketing lead, growth lead
masters: Susan Wenograd (creative-as-targeting + refresh cadence), Andrew Foxwell (creative volume as the lever), Ralph Burns (asset-led structure with deliberate refresh), Aaron Orendorff (the weekly cadence as unit of paid-ads operations)
substrate_layers_required: [icp, positioning]
patterns_grounded: [creative-fatigue-window, intent-vs-interest-targeting]
preflight_refusal: substrate-gap, missing-diagnostic-history
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
---

# ad-fatigue-monitor

## Purpose

Run weekly. Scan the last N weeks of ad-diagnose outputs for each channel. Compare current-week fatigue flags to prior-week flags. Surface:

- New fatigue candidates (creatives that crossed a threshold this week).
- Persistent fatigue candidates (creatives flagged for two or more weeks; refresh is overdue).
- Recovered creatives (creatives previously flagged, now back below thresholds; cohort or audience refresh worked).

The monitor's output is operational: a dated flag file plus a refresh-brief queue that `ad-creative-design` can consume directly.

The monitor refuses without recent diagnostics. It does not run `ad-diagnose` itself. The cadence is:

1. Operator (or scheduler) runs `ad-diagnose --client <client> --export <csv> --channel <channel>` on the latest export.
2. Operator runs `ad-fatigue-monitor --client <client>` weekly.

## Inputs

- `--client <client>` (required)
- `--diagnostics <dir>` (optional, default `clients/<client>/ads/diagnostics/`)
- `--lookback-weeks <int>` (optional, default `4`) how far back to read for persistence detection.
- `--out <dir>` (optional, default `clients/<client>/ads/fatigue-flags/`)
- `--enqueue-briefs` (optional, default off) if set, also write refresh-brief stubs into `clients/<client>/ads/briefs/_queue/`.

## Substrate reads

- `clients/<client>/01-position.md` for canonical positioning (referenced in brief queue).
- `clients/<client>/02-icp.md` for cohort defaults (referenced in brief queue).
- `clients/<client>/ads/diagnostics/*.md` for the per-week fatigue flags this monitor compares.

## Output contract

Writes `clients/<client>/ads/fatigue-flags/<YYYY-MM-DD>.md` with frontmatter:

```yaml
---
flags_id: <client>-fatigue-<YYYY-MM-DD>
lookback_weeks: <int>
diagnostics_read: [<path>, <path>, ...]
substrate_layers_read: [icp, positioning]
patterns_applied: [creative-fatigue-window, intent-vs-interest-targeting]
flag_summary:
  new_count: <int>
  persistent_count: <int>
  recovered_count: <int>
---
```

Body sections:

1. **New flags** creatives that crossed a fatigue threshold this week, by channel.
2. **Persistent flags** creatives flagged in 2+ consecutive weeks. These get a "REFRESH OVERDUE" tag.
3. **Recovered creatives** previously flagged, now below thresholds.
4. **Cadence note** weeks since the last brief was filed against this channel; if above the channel's expected cadence, flag the production gap.
5. **Brief queue** if `--enqueue-briefs` set, the file paths of stub briefs written for `ad-creative-design` to consume.

## Quality criteria

- Every flag cites the diagnostic file it came from.
- Persistent flags name the number of weeks they have been flagged.
- The cadence note is grounded in the per-channel expected cadence (Meta = 2-4 new variants per week, LinkedIn = 1-2, etc.) per `pat_creative-fatigue-window`.
- The brief-queue stubs include the channel, cohort, and frame so `ad-creative-design` can open them directly.

## What this skill does NOT do

- Does not run `ad-diagnose`. Diagnostics must already exist.
- Does not change ad accounts. Operator decides what to refresh and when.
- Does not generate brief content. `ad-creative-design` is the next skill.
- Does not pause campaigns. That stays with the operator.

## Refusal patterns

- No diagnostics in the lookback window returns `INPUT-GAP — missing-diagnostic-history`.
- Diagnostics for fewer than 2 channels returns `INPUT-WARN — single-channel-only` (run, but note the limit).
- Missing canonical positioning returns `SUBSTRATE-GAP — missing-positioning` (the brief queue cannot be primed).

## See also

- `ad-diagnose` — the upstream skill that produces the per-week flags this monitor reads.
- `ad-creative-design` — consumes the brief queue this monitor primes.
- `routines/ad-fatigue-routine.md` — the cron / cadence wrapper for this skill.
- `pat_creative-fatigue-window` — the pattern this skill operationalises.
