---
title: triggers
status: active
last_updated: 2026-05-04
---

# Triggers

When the recurring routine fires. Not every step runs every day. Each step has a trigger that says "fire now" — a calendar trigger, a state trigger, or an event trigger.

## Trigger types

### Calendar triggers

Fire on a schedule. Time-based.

- Weekly knowledge check: every Monday at 9 AM project time.
- Monthly accuracy review: first Monday of each month.
- Quarterly principles review: first week of each quarter.

### State triggers

Fire when an object hits a state.

- Goal opens → goal linter runs (validates measurement contract).
- Goal hits resolution date → resolution skill fires (computes accuracy score, updates ledger).
- Context layer past freshness window → flag for refresh.
- Draft generated → pre-publish-check runs.

### Event triggers

Fire on an external event.

- New signal lands in inbox → signal-analyst step queues a patch proposal.
- A competitor's tracked surface (pricing page, changelog) changes → competitive layer flagged for review.
- AI-citation rank for a tracked prompt drops below a threshold → AEO routine fires.
- A specific source-system metric crosses a threshold → goal that depends on it gets flagged.

## What each trigger looks like in practice

A goal opens with a resolution date in 60 days. The state trigger fires the day the date hits. No human has to remember.

The freshness window for the competitive layer is 30 days. The calendar-driven weekly knowledge check sweeps every project's `00-INDEX.md` and writes a flag for any layer past 30 days. The flag stays until the layer is refreshed.

A new sales call transcript lands in `<project>/signals/inbox/sales-calls/`. The event trigger queues the signal-analyst step. The next human-approval pass picks up the queued proposals.

## Why explicit triggers matter

Implicit "I'll get to it" routines don't run. The operator means well; the routine sits in their head; the routine doesn't fire.

Explicit triggers push the routine onto the system. The operator's job is to handle the queue when it surfaces, not to remember when the routine should run.

This is also what makes the system audit-able. A goal that didn't get scored on its resolution date is a real failure mode the system can detect (the trigger should have fired; the audit log shows whether it did). An implicit routine that didn't run is invisible.

## Where triggers are configured

Each routine spec in `routines/` has a `## Trigger` section that names the trigger type and the specific firing condition. The dispatcher reads the section to decide when to call the routine.

For calendar triggers on a workstation, this is a scheduler entry. For state and event triggers, it's a watcher process or a hook into the state-changing operation.

The simplest setup uses a single daily scheduler entry that runs all the calendar triggers and sweeps for any state-trigger conditions that have hit. More sophisticated setups split state triggers onto event-driven hooks.
