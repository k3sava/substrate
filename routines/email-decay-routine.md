---
title: Email engagement decay watcher
status: active
last_updated: 2026-05-08
schedule: weekly
day_of_week: monday
hour_local: 09
---

# Email engagement decay routine

A weekly watcher that flags lifecycle sequences whose open or click rates declined more than the configured threshold over a rolling 4-week window vs the prior 4-week window. The skill that runs is `email-engagement-decay-watcher`.

## Why this routine exists

Lifecycle programs decay quietly. Open rates fall a few points a week and the dashboard's weekly variance hides the slide for weeks. By the time the operator notices, the fix surface has shifted from "sharpen the cohort and refresh the subject" to "the program has been wrong for a quarter." This routine catches the slide on a 4-week horizon, before the trend becomes a story about deliverability.

Per `knowledge/patterns/engagement-decay-as-relevance-signal.md`, the watcher's first hypothesis on a gradual taper is relevance, not deliverability. The routine is named for what it watches, not for what it fixes.

## Cadence

- **Frequency**: weekly, Monday morning local time.
- **Window**: rolling 4-week current vs 4-week prior. Sequences need at least 8 weeks of CSV data to be analyzed.
- **Scope**: every sequence with metrics under `clients/<client>/email/metrics/`. Use `--sequence <id>` to scope to one.

## Pre-conditions

The routine reads CSVs at `clients/<client>/email/metrics/<sequence-id>-<YYYY-MM>.csv` with schema:

```
date,sequence_id,step,sent,delivered,opened,clicked,unsubscribed,complained,bounced
```

The CSVs are committed weekly by the lifecycle owner. The routine does not pull from ESP APIs; that's a deliberate substrate-first choice (the metrics live in the substrate folder, are versioned, and survive ESP migrations).

## What the routine does

1. Reads every CSV under `clients/<client>/email/metrics/`.
2. Aggregates each sequence's prior 4-week and current 4-week numbers.
3. Computes lift on open rate, click rate, complaint rate, and bounce rate.
4. Classifies decay shape: `sudden-cliff`, `gradual-taper`, `step-down`, `none`.
5. Maps shape + complaint/bounce co-movement to a first hypothesis:
   - sudden cliff + complaint/bounce spike → deliverability event
   - sudden cliff + complaint/bounce flat → upstream blocking event
   - gradual taper → relevance break (most common case)
   - step-down → discrete cohort change
6. Writes a digest to `clients/<client>/email/decay/<YYYY-MM-DD>.md` with per-sequence blocks, severity tier, and the recommended next skill (`email-cohort-trigger` for relevance, `email-deliverability-audit` for deliverability cliffs).

## Output

One digest file per run at `clients/<client>/email/decay/<YYYY-MM-DD>.md`. The file is markdown with frontmatter, suitable for committing to the substrate. Critical alerts cause a non-zero exit code so an operator queue or status bot picks them up.

## Run by hand

```bash
substrate email-engagement-decay-watcher --client <client>
```

Threshold defaults to 25% relative decline; override with `--threshold 30`.

## Run as a cron / LaunchAgent

A typical macOS LaunchAgent fragment:

```xml
<key>Label</key><string>com.substrate.email-decay-watcher</string>
<key>ProgramArguments</key>
<array>
  <string>/Users/<you>/r2d2/substrate/bin/substrate</string>
  <string>email-engagement-decay-watcher</string>
  <string>--client</string><string><client></string>
</array>
<key>StartCalendarInterval</key>
<dict>
  <key>Weekday</key><integer>1</integer>
  <key>Hour</key><integer>9</integer>
  <key>Minute</key><integer>0</integer>
</dict>
```

A typical Linux cron line:

```
0 9 * * 1 /home/<you>/substrate/bin/substrate email-engagement-decay-watcher --client <client>
```

## What this routine does NOT do

- Does not pull metrics from ESP APIs.
- Does not fix the decay; it points at the next skill.
- Does not run a creative test on subject lines.
- Does not run on programs younger than 8 weeks (insufficient signal; the skill exits 0 with a "too young" note in the digest).

## Related routines

- `routines/email-deliverability-monthly.md`, monthly DNS / send-log audit for the sending domain.
- `routines/aeo-routine.md`, same shape, different surface.

## See also

- `skills/email-engagement-decay-watcher/SKILL.md`
- `skills/email-cohort-trigger/SKILL.md`
- `skills/email-sequence-design/SKILL.md`
- `knowledge/patterns/engagement-decay-as-relevance-signal.md`
