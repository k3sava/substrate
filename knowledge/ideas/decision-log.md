---
title: decision log
status: active
last_updated: 2026-05-04
---

# Decision log

Every override, every framing-level call, every exception to a default ships with a logged receipt. The receipt is the operator's note, in their own words, plus a date and a reason.

## When to log

A decision needs a logged receipt when:

- A gate refusal was overridden.
- A default was changed (a freshness window extended, a panel floor lowered, a kill-list term retired).
- A goal's predicted confidence was revised mid-flight.
- A context layer's last-refreshed date was updated without a full layer rewrite.
- A skill was bypassed for a one-off draft.

Routine actions don't need a log. The log is for departures from default.

## What goes in a receipt

```yaml
date: 2026-05-04
operator: <name>
action: override pre-publish-check refusal on <draft path>
reason: |
  The refusal fired on competitive layer freshness (32 days, window is 30).
  The competitor referenced in this draft (Acme) had no material change in
  the last 60 days — verified via their last public release notes
  (acme.com/changelog dated 2026-03-01). Override is safe for this draft;
  the layer is queued for refresh by next Monday.
links:
  - <draft path>
  - acme.com/changelog
```

The receipt lives at `<project>/decision-log/<date>-<short-slug>.md`. Each project has its own log.

## Why receipts matter

Three reasons.

**Auditability.** A reviewer reading the draft a month later can see why the override was safe. The decision isn't lost in a chat thread.

**Pattern detection.** Repeated overrides on the same gate point to a broken gate. The log surfaces the pattern; the operator can recalibrate the gate or the underlying default.

**Accuracy honesty.** If a goal lost in part because of a bypassed gate, the resolution writeup links to the receipt. The accuracy score can be evaluated with the override in mind. The operator's track record stays interpretable.

## What a missing receipt costs

Silent overrides are invisible failure modes. The gate fired; the operator overrode it; nobody recorded why. A month later, the same override happens again, for the same reason, with no institutional memory that the gate was firing for a real reason all along.

The decision log is the institutional memory layer that protects the system from the same lesson getting re-learned every quarter.

## How it ties to accuracy

When a goal resolves, the closing step looks for receipts in the project's decision-log dated within the goal's window. Receipts that touched the goal's path or the gates relevant to its drafts get linked from the resolution writeup. The accuracy score and the override pattern become readable together.
