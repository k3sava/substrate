---
name: social-fatigue-monitor
description: Analyse per-platform post-performance over time, detect engagement decay, and flag fatigue candidates. Reads clients/<client>/social/metrics/<channel>-<YYYY-MM>.csv. Real metric math (rolling-window comparison vs prior window) for impressions, engagement rate, follower-growth correlation. Refuses without canonical positioning.
version: 0.1
amplifies: social media lead, growth lead, content marketer
masters: Justin Welsh (cadence and refresh discipline), Sahil Bloom (cohort-level metrics over vanity), Andrew Chen (paid-acquisition ceiling on awareness channels), Jasmin Alic (per-platform reach decay diagnosis)
substrate_layers_required: [positioning, icp]
patterns_grounded: [native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion, creative-fatigue-window]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-positioning, missing-metrics
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
---

# social-fatigue-monitor

## Purpose

Run weekly or biweekly. Read the last N months of per-platform engagement data; compute a 4-week-vs-prior-4-week lift across the three load-bearing metrics (impressions, engagement rate, follower-growth correlation). Surface fatigue candidates per platform per author lane (personal vs corporate). Classify the decay shape (sudden cliff, gradual taper, step-down) and route to the relevant first-hypothesis fix.

The monitor refuses without canonical positioning because the refresh recommendation cannot be grounded otherwise. It refuses without metrics CSVs because there is nothing to measure.

The metric math is real: per-period mean + median, lift percentage, and a simple correlation between posting cadence and follower-growth (when both columns exist). The output is a dated severity-tiered report, not a vibe.

## Inputs

- `--client <client>` (required)
- `--metrics-dir <dir>` (optional, default `clients/<client>/social/metrics/`)
- `--window-weeks <int>` (optional, default `4`) — the "current" window length
- `--decay-threshold-pct <float>` (optional, default `25.0`) — percentage lift below this triggers a flag
- `--platform <platform>` (optional) — restrict to one platform
- `--out <dir>` (optional, default `clients/<client>/social/fatigue-flags/`)

## Substrate reads

- `clients/<client>/01-position.md` — for the refresh-recommendation framing.
- `clients/<client>/02-icp.md` — for cohort-context in flags.
- `clients/<client>/social/metrics/<platform>-<YYYY-MM>.csv` — the metric data.

## Metrics CSV shape

Required headers (case-insensitive): `date`, `post_id`, `impressions`, `engagement_rate`. Recommended: `platform` (if not in filename), `author` (`personal` or `corporate`), `cohort`, `purpose`, `followers_after`, `clicks`, `comments`, `saves`, `shares`.

The skill is forgiving on missing optional columns; it falls back to what is present and logs the missing fields.

## Output contract

Writes `clients/<client>/social/fatigue-flags/<YYYY-MM-DD>.md` with frontmatter:

```yaml
---
flags_id: <client>-social-fatigue-<YYYY-MM-DD>
window_weeks: <int>
metrics_read: [<path>, ...]
substrate_layers_read: [positioning, icp]
patterns_applied: [native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion, creative-fatigue-window]
flag_summary:
  platforms_scanned: <int>
  posts_analysed: <int>
  flags_critical: <int>
  flags_warning: <int>
  flags_advisory: <int>
produced_by: social-fatigue-monitor
---
```

Body sections:

1. **Per-platform decay summary** — current vs prior window means and medians on impressions and engagement rate, with lift percentages.
2. **Flagged posts** — individual posts whose engagement rate is more than 1 standard deviation below the platform's current-window mean. Severity tiered.
3. **Decay shape per platform** — sudden cliff (week-over-week >40% drop), gradual taper (4 consecutive weeks of negative lift), step-down (one week's drop persists), or stable.
4. **Author-lane comparison** — personal vs corporate engagement-rate gap; flags if corporate is being over-funded.
5. **Cadence note** — average posts per week per platform vs typical cadence for the platform.
6. **Recommended next moves** — first-hypothesis routing per decay shape:
   - Sudden cliff → check platform algorithm change, account-level penalty, content-policy hit.
   - Gradual taper → relevance erosion (audience drift); route to `social-listening-themes` and `social-amplification-test`.
   - Step-down → format change or lost-comment-velocity; route to `social-content-design` for native-format refresh.
7. **Cohort metrics reminder** — per `pat_social-as-distribution-not-conversion`, last-click CAC is not the resolution metric.

## Quality criteria

- Every flag cites the source CSV row.
- Decay shapes are computed, not guessed.
- Personal vs corporate comparison is made when both lanes appear in the data.
- No flag is raised when sample size is below the per-platform minimum (4 posts in the window for B2B, 8 posts for consumer-facing platforms).
- The report names the next skill to run for each decay shape; recommendations route, not lecture.

## What this skill does NOT do

- Does not pull metrics from platform APIs. CSV exports come from the operator or the platform.
- Does not generate refreshed content. Use `social-content-design` for that.
- Does not test alternative hooks. Use `social-amplification-test`.
- Does not score influencers. Use `influencer-fit-score`.

## Refusal patterns

- Missing positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Missing metrics dir or empty dir returns `INPUT-GAP — missing-metrics`.
- Sample size below per-platform minimum returns `INPUT-WARN — sample-too-small` per platform; the report continues for other platforms.
- Metrics CSV missing required columns returns `INPUT-GAP — metrics-shape-invalid` with the file name and missing columns.

## See also

- `social-content-design` — produces the drafts whose performance this monitor reads.
- `social-amplification-test` — the experiment loop that the monitor's recommendations route to.
- `social-listening-themes` — the qualitative loop that complements the quantitative monitor.
- `routines/social-fatigue-check.md` — the biweekly cadence wrapper for this skill.
- `knowledge/patterns/native-format-beats-cross-post.md`
- `knowledge/patterns/creator-not-corporate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
- `knowledge/patterns/creative-fatigue-window.md`
