---
title: sales-trigger routine
status: active
last_updated: 2026-05-08
schedule: daily — 06:30 IST (01:00 UTC)
owner: SDR manager + ABM lead
---

# sales-trigger routine

A daily scan for trigger events on the active target-account list. Triggers are the highest-leverage moment for outbound; the routine ensures the team never misses a 60-90 day pursuit window.

## Cadence

- **Daily:** 06:30 IST. Light pass over RSS + Google News per active account.
- **Weekly:** Mondays 08:00 IST. Deeper pass: company-page changelogs, BuiltWith / job-post changes, manual review of misses.

## Steps

1. Confirm `clients/<client>/sales/target-accounts.csv` is current. If a tier review modified it last week, refresh.
2. Run `substrate sales-trigger-event-watch --client <client> --lookback-days 7`.
3. Review the output `clients/<client>/sales/triggers/<YYYY-MM-DD>.md`:
   - High-significance entries → flag for SDR / AE within 4 working hours.
   - Medium entries → batch into the SDR queue.
   - Low entries → archive (not deleted; old triggers feed quarterly account-tier review).
4. For each high-significance trigger:
   - Cross-reference latest `account-rankings/<latest>-ranked.csv`. If account is tier 1A/1B, page the AE.
   - Inject a trigger-anchored touch into the account's active sequence (per `pat_trigger-events-beat-cadence-blast`).
   - Update intent feed if the trigger correlates with a behavioral signal (G2 review on competitor, doc visit, etc.).
5. Append the routine run to `clients/<client>/sales/triggers/INDEX.md` (the watcher does this automatically).

## Quality criteria

- No daily run produces more than 50 high-significance triggers (suggests over-broad keyword detection — re-tune).
- Every high-significance trigger is verified by the SDR (visiting the source URL) before any outbound goes out.
- High-significance triggers older than 7 days are downgraded; they're no longer "fresh" enough to anchor outreach.

## Anti-patterns

- Running a 30-day lookback in daily mode (introduces stale events; daily mode is for fresh-only).
- Acting on a trigger without an account-tier check (a fresh trigger on a tier-2 account warrants different treatment than the same trigger on a tier-1A account).
- Skipping verification: every cited trigger needs a verified source URL or it's not citation-grade.

## Composes with

- `skills/sales-trigger-event-watch/` — the runtime this routine schedules.
- `skills/abm-account-prioritize/` — provides tier lookup that conditions response.
- `skills/outbound-sequence-design/` — consumes triggers to anchor Setup-phase content.
- `skills/intent-data-route/` — cross-references trigger feed with intent feed for fast-track candidates.

## Patterns grounded

- `knowledge/patterns/trigger-events-beat-cadence-blast.md`.
- `knowledge/patterns/account-not-lead-as-unit.md`.

## Failure modes to watch

- Feed silence: 3 days with zero new triggers across 100+ accounts → feeds.yaml is broken or accounts list is wrong. Investigate before assuming "quiet week."
- Same source repeats: if 80%+ of triggers come from one feed, the others are likely silently failing. Diversify or fix.
- Account list drift: if the trigger feed surfaces an account no longer in target-accounts.csv, escalate to ABM lead — usually a sales-ops / list-cleanliness issue.
