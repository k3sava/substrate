---
title: routines
status: active
last_updated: 2026-05-08
---

# Routines

Recurring workflows that fire on a schedule and produce the data the dashboard reads. Routines never render the dashboard themselves; `dashboard/generate.mjs` does that.

The catalog splits two ways. **End-to-end orchestrations** compose multiple skills into a named PMM / GTM cycle (a quarter, a launch, a client engagement, a funnel audit). **Single-purpose routines** are the recurring sub-loops the orchestrations wrap: a weekly competitive scout, a daily trigger watcher, a monthly retention review.

## End-to-end orchestrations

Each orchestration composes 4-12 skills into a named operator cycle. They are how a PMM lead actually uses substrate: pick the cycle that matches the work, run the skills in sequence, score the calibration at the end.

| Routine | Cadence | Composes |
|---|---|---|
| `new-client-onboarding-week-1.md` | One-time, day 1 to day 5 of a paid engagement | `consulting-poc` wrapping `icp-cut`, `frontline-contact`, `positioning-forge`, `status-quo-frame`, `dunford-value-frame`, `narrative-strategy`, `messaging-matrix`, `lp-ship` or `narrative-compose`, `eval-rubric`, `open-goal` |
| `quarterly-pmm-cycle.md` | Quarterly, with mid-quarter checkpoint at week 6 | `refresh-knowledge`, `competitive-scout`, `icp-cut`, `open-goal`, `mental-models`, `score-goal`, `pmm-coaching`; wraps `signal-routine`, `frontline-contact-routine`, `narrative-drift-routine`, `aeo-publish-cycle` |
| `launch-flow.md` | Per-launch, T-12w through T+12w holdout | `launch-plan`, `campaign-strategy`, `narrative-strategy`, `messaging-matrix`, `ad-creative-design`, `email-sequence-design`, `narrative-compose`, `lp-ship`, `pre-publish-check`, `score-goal` |
| `full-funnel-audit.md` | Quarterly, week 1 of the quarter | `ad-diagnose`, `ad-attribution-honest`, `email-deliverability-audit`, `email-engagement-decay-watcher`, `activation-funnel-audit`, `retention-cohort-analysis`, `churn-diagnose`, `eval-rubric`, `open-goal` |
| `customer-conversation-rhythm.md` | Continuous, with 30 / 60 / 90 cadence | `frontline-contact`, `win-loss-interview`, `tactical-empathy-discovery`, `signal-routine`, `refresh-knowledge`, `score-goal` |
| `aeo-publish-cycle.md` | Monthly, with weekly snapshot sub-loop | `aeo-tune`, `aeo-relevance`, `aeo-manual-action`, `help-docs`, `pseo-framework`, `pre-publish-check`, `score-goal` |
| `competitor-watch-cycle.md` | Weekly, with quarterly re-baseline | `competitive-scout`, `battle-card-driver`, `status-quo-frame`, `claim-verify`, `positioning-forge` |
| `expansion-flywheel.md` | Monthly review with weekly trigger watcher | `expansion-trigger-detect`, `retention-cohort-analysis`, `nps-loop-design`, `outbound-sequence-design`, `churn-diagnose`, `frontline-contact`, `score-goal` |

## Single-purpose routines (the loops)

These markdown specs describe how each loop runs. They are operating descriptions, not executed code, with one exception: the digest-ingest routine has a runner shipped under `bin/substrate-ingest-digests`.

- **frontline-contact-routine.md** — Continuous. Enforces written customer-contact cadence per role. Without a logged conversation, no downstream skill runs. Operationalises the `frontline-as-pmm-substrate` Tier A pattern.
- **signal-routine.md** — Continuous. Five signal types (VoC, buyer behavior, competitive, market context, sales intel) flow into the inbox. Substrate patches queue for human approval.
- **goal-routine.md** — Event-driven. Opens when an operator proposes a goal. Closes when the goal resolves and Stage 7 updates the context. Output: calibration data.
- **content-routine.md** — On-demand. Triggered by an active goal. Generates assets, preflights, gates, ships, measures.
- **aeo-routine.md** — Weekly. Citation tracking, gap analysis, AEO content gen across the triangle (presence, relevance, manual-action). The `aeo-publish-cycle` orchestration wraps this on a monthly publish-and-measure rhythm.
- **narrative-drift-routine.md** — Weekly. Detects when narrative claims drift from context.
- **digest-ingest.md** — Daily. Reads codex digests, auto-merges low-risk pattern updates, files proposals for skill or principle changes.
- **ad-fatigue-routine.md** — Weekly. Pulls fresh ad-account exports, runs `ad-diagnose` per channel, runs `ad-fatigue-monitor` to surface persistent / new / recovered creatives, primes refresh briefs via `ad-creative-design`.
- **ad-allocation-routine.md** — Quarterly. Pre-quarter audit, LTV / CAC reconciliation, channel allocation via `ad-spend-allocate`, opens one goal per channel, schedules incrementality tests for any channel above 5 percent of budget, resolves at quarter-end.
- **email-decay-routine.md** — Weekly. Reads `clients/<client>/email/metrics/`, computes 4-week-vs-prior-4-week lift on engagement, classifies decay shape, points at the next skill (`email-cohort-trigger` for relevance, `email-deliverability-audit` for deliverability cliffs).
- **email-deliverability-monthly.md** — Monthly. SPF, DKIM, DMARC posture audit across the sending domain and known subdomains; cross-references send-log against Gmail Postmaster thresholds.
- **retention-monthly.md** — Monthly. Cohort retention curve read, activation event re-name, churn diagnosis when slope-change fires, win-back sequences per band, expansion-trigger queue refresh, prior-month prediction resolve.
- **expansion-watcher.md** — Weekly. Behavioral-trigger scan, per-band hand-off (burning / hot / warm / cold), prior-week resolve, drift watch.
- **sales-trigger-routine.md** — Daily. Scans target-account list for trigger events (funding, exec hires, product launches, layoffs, acquisitions, tech changes). Operationalises `pat_trigger-events-beat-cadence-blast`.
- **account-tier-review.md** — Quarterly. Reprioritises target-account list against refreshed ICP. Logs tier-prediction-accuracy as calibration signal.

## Code routines (scripts that fire on cron)

| Folder | What it does | Cadence |
|---|---|---|
| `bet-resolution/` | Resolves goals with named outcomes; computes Brier scores | Nightly 02:30 IST |
| `brief-freshness/` | Audits per-client `BRIEF.md` for stale citations + drift | Daily |
| `quarterly-context-audit/` | Layer 8 reconciliation: orphan / contradiction / freshness sweep | Weekly Mon 9 AM IST |
| `competitive-scout/` | Pulls competitor signals into `signals/inbox/` | Manual + occasional cron |

Operator-fired CLIs live in `../bin/` (not cron):
- `bet` — Slack bot's CLI shell
- `heartbeat-tick` — per-minute presence + commons-inbox drain
- `refresh-leaderboard` — calibration leaderboard rollup
- `score-calibration` — per-operator Brier history

## Calibration data store

The dashboard renders fine from `goals/ledger.md` directly; none of the scripts below are required for the operator + hello views to work. They produce the calibration leaderboard.

All three calibration scripts now run on **SQLite** (`data/calibration.sqlite`, gitignored). No Postgres required.

| Script | Role |
|---|---|
| `../bin/refresh-leaderboard` | Exports the `taste_leaderboard` view → `goals/taste-leaderboard.md` |
| `../bin/score-calibration` | Computes brier + log_score + peer_score for unscored `gate_events` rows |
| `bet-resolution/resolve.py` | Promotes `goals/<bet-id>/resolution.json` sidecars (written by `/bet resolve`) into `gate_events` |

Bootstrap the SQLite DB on a fresh checkout:

```bash
bin/init-calibration-db          # creates data/calibration.sqlite from schema
bin/refresh-leaderboard          # produces goals/taste-leaderboard.md (empty until resolutions land)
```

Schema lives at `data/calibration-schema.sql`. SQLite has no `MATERIALIZED VIEW` so the leaderboard is a regular `VIEW` computed on read; fine for the calibration data volume.

**Scope cut** in the SQLite migration: the v1 Postgres `bet-resolve` had per-source dispatch (HubSpot deal-tag count, Amplitude funnel CR, Slack mention count). That dispatch was multi-week build; the SQLite version takes the simpler shape; operator runs `/bet resolve <id> <outcome>` (Slack), which writes a sidecar; `bet-resolve.py` cron promotes sidecars into the calibration DB. Auto-resolution from data sources is reproducible later behind the same `/bet resolve` interface.

## LaunchAgent wiring

Sample for `bet-resolution`:

```xml
<key>ProgramArguments</key>
<array>
  <string>/usr/bin/python3</string>
  <string>/Users/USER/r2d2/.substrate/routines/bet-resolution/resolve.py</string>
  <string>--v2-ledger</string>
  <string>goals/ledger.md</string>
</array>
<key>WorkingDirectory</key>
<string>/Users/USER/r2d2/.substrate</string>
```

See `~/Library/LaunchAgents/com.substrate.*.plist` on the r2d2 host for the canonical wiring.

## Why routines split into orchestrations and loops

Skills are reusable specs that operators (human or LLM) invoke against a specific task. Single-purpose routines are scheduled workflows that run unattended and produce data. End-to-end orchestrations compose multiple skills (and often multiple sub-routines) into a named operator cycle.

A skill might call into a routine; a routine never calls a skill back. An orchestration calls skills and reads the data routines produce; orchestrations are how an operator turns "I have a substrate" into "I have a quarter's worth of work mapped end-to-end."

Without orchestrations, substrate is a pile of skills. With them, it's an operating system.
