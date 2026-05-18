---
title: social fatigue check
status: active
last_updated: 2026-05-08
cadence: biweekly
day_of_week: monday
hour_local: 09
skill_chain: [social-fatigue-monitor, social-listening-themes, social-amplification-test, social-content-design]
patterns_grounded: [native-format-beats-cross-post, social-as-distribution-not-conversion, creative-fatigue-window]
---

# Social fatigue check

A biweekly fatigue scan that watches per-platform engagement decay across rolling 4-week windows. The skill that runs is `social-fatigue-monitor`; the routine names the cadence, the data contract, and the routing rules that turn flags into the next-cycle work.

## Why this routine exists

Social programs decay quietly. Engagement rates fall a few points a week and the dashboard's per-week variance hides the slide for months. By the time the program is visibly underperforming, the fix surface has shifted from "refresh hooks and re-segment cohorts" to "the program has been wrong for a quarter and the audience has aged out." This routine catches the slide on a 4-week-vs-prior-4-week horizon, before the trend becomes a story about strategy or budget.

Per `knowledge/patterns/native-format-beats-cross-post.md`, the watcher's first hypothesis on a per-platform gradual taper is platform-native format drift, not generic content quality. Per `knowledge/patterns/social-as-distribution-not-conversion.md`, the watcher reads cohort-level metrics (engagement rate, follower growth, audience overlap), not last-click CAC. The routine is named for what it watches; the fix surface depends on the decay shape.

## Cadence

- **Frequency**: biweekly, alternating Mondays at 09:00 local time.
- **Window**: rolling 4-week current vs 4-week prior. Programs need at least 8 weeks of CSV data to be analysed.
- **Scope**: every platform with metrics under `clients/<client>/social/metrics/`. Use `--platform <platform>` to scope.

## Pre-conditions

The routine reads CSVs at `clients/<client>/social/metrics/<platform>-<YYYY-MM>.csv` with schema:

```
date,post_id,impressions,engagement_rate
```

Recommended optional headers: `platform` (if not in filename), `author` (`personal` or `corporate`), `cohort`, `purpose`, `followers_after`, `clicks`, `comments`, `saves`, `shares`.

The CSVs are committed weekly by the social-media owner. The routine does not pull from platform APIs; that's a deliberate substrate-first choice (the metrics live in the substrate folder, are versioned, and survive platform-API access changes).

## What the routine does

1. Reads every CSV under `clients/<client>/social/metrics/`.
2. Aggregates each platform's prior 4-week and current 4-week impressions, engagement rate, and follower-growth correlation (when a `followers_after` column is present).
3. Computes lift on the three metrics; flags posts more than one standard deviation below the platform's current-window mean.
4. Classifies decay shape per platform:
   - `sudden-cliff`, week-over-week drop above 40% on impressions or engagement rate.
   - `gradual-taper`, four consecutive weeks of negative lift on engagement rate.
   - `step-down`, one week's drop persists across the next three weeks.
   - `stable`, none of the above.
5. Compares author lanes: personal-account engagement rate vs corporate-handle engagement rate. Surfaces the gap and (per `pat_creator-not-corporate`) flags if the corporate handle is being over-funded relative to personal accounts.
6. Names the per-platform cadence gap. If the weekly post count for a platform is below the expected cadence (LinkedIn 3-5 personal-account posts per week, X 5-10, TikTok 2-3, etc.), the gap is flagged as a leading indicator of audience erosion.
7. Writes a digest to `clients/<client>/social/fatigue-flags/<YYYY-MM-DD>.md` with per-platform blocks, severity tier, and the recommended next skill.

## Decay-shape routing

| Shape | First hypothesis | Routes to |
|---|---|---|
| `sudden-cliff` | Platform algorithm change, account-level penalty, content-policy hit | Manual investigation; pause cadence on affected platform until the cause is named |
| `gradual-taper` | Relevance erosion (audience drift) | `social-listening-themes` (next theme cycle) + `social-amplification-test` (hook variants) |
| `step-down` | Format change or lost-comment-velocity | `social-content-design` (native-format refresh) |
| `stable` | None | No action; continue current cadence |

The recommendations route, not lecture. The operator's judgement still owns the decision; the routine names the most-likely fix surface so the next cycle has a clear next-skill.

## Output

One digest file per run at `clients/<client>/social/fatigue-flags/<YYYY-MM-DD>.md`. The file is markdown with frontmatter, suitable for committing to the substrate. Critical alerts (sudden-cliff at the platform level) cause a non-zero exit code so an operator queue or status bot picks them up.

## Run by hand

```bash
substrate social-fatigue-monitor --client <client>
```

Threshold defaults to a 25% relative decline on engagement rate; override with `--decay-threshold-pct 30`. Window defaults to 4 weeks; override with `--window-weeks 6`.

## Run as a cron / LaunchAgent

A typical macOS LaunchAgent fragment for biweekly Monday-09:00 runs:

```xml
<key>Label</key><string>com.substrate.social-fatigue-check</string>
<key>ProgramArguments</key>
<array>
  <string>/Users/<you>/r2d2/substrate/bin/substrate</string>
  <string>social-fatigue-monitor</string>
  <string>--client</string><string><client></string>
</array>
<key>StartCalendarInterval</key>
<dict>
  <key>Weekday</key><integer>1</integer>
  <key>Hour</key><integer>9</integer>
  <key>Minute</key><integer>0</integer>
</dict>
```

(For biweekly cadence, add a date-modulo check inside the wrapper or run weekly and gate downstream actions on the digest output.)

A typical Linux cron line (weekly; the operator gates on the digest):

```
0 9 * * 1 /home/<you>/substrate/bin/substrate social-fatigue-monitor --client <client>
```

## What this routine does NOT do

- Does not pull metrics from platform APIs.
- Does not fix the decay; it points at the next skill.
- Does not run a creative test on hooks. That's `social-amplification-test`.
- Does not run on programs younger than 8 weeks (insufficient signal; the digest exits 0 with a "too young" note).
- Does not cover paid social. Paid social belongs to `routines/ad-fatigue-routine.md`.

## Common failure modes

1. **Operator misses two weeks of metric commits.** The current-window data is incomplete; lift signals are noisy. Fix: commit weekly even when the data is small. The routine handles partial weeks; it cannot handle missing weeks.
2. **Operator runs the monitor without committing the new mentions / themes from the last cycle.** Decay-shape routing recommends `social-listening-themes`, but the themes file is stale. Fix: run `social-listening-themes` weekly per `routines/social-content-cycle.md`; this routine reads the themes outputs as input.
3. **Operator overrides the decay threshold downward to suppress flags.** Hides a real signal. Fix: tune the threshold once, document the choice, and trust the gate.
4. **Operator funds the corporate handle on the personal-account engagement metric.** Per `pat_creator-not-corporate`, this is a structural mismatch. The corporate handle is announcement surface; measure it on share-of-voice, brand-mention volume, and announcement reach, not on engagement rate.

## Related routines

- `routines/social-content-cycle.md`, the weekly five-stage cycle that this fatigue check feeds.
- `routines/ad-fatigue-routine.md`, the paid-social analogue; same shape, different surface.
- `routines/aeo-routine.md`, same shape (rolling-window watcher), different surface.

## See also

- `skills/social-fatigue-monitor/SKILL.md`
- `skills/social-content-design/SKILL.md`
- `skills/social-amplification-test/SKILL.md`
- `skills/social-listening-themes/SKILL.md`
- `knowledge/patterns/native-format-beats-cross-post.md`
- `knowledge/patterns/creator-not-corporate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
- `knowledge/patterns/creative-fatigue-window.md`
- `templates/social-calendar-example.yaml`
