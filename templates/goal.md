---
id: G-<function>-<NNN>
function: <content | demand-gen | pmm | lifecycle | brand>
opened_by: <name>
opened_on: <YYYY-MM-DD>
status: proposed | active | resolved
predicted_p: <0.0-1.0>
resolution_date: <YYYY-MM-DD>
---

# G-<function>-<NNN>: <one-line headline>

## Hypothesis

<What you predict will happen.>

## Measurement contract

- **Baseline:** <current metric value> from <source>.
- **Target:** <metric value> by <date>.
- **Window:** <date range>.
- **Source-system:** <Amplitude chart ID / HubSpot dashboard ID / etc>.
- **Resolution method:** <how the goal will be scored — exact query, threshold, kill-criterion>.

## Why this matters

<One paragraph. Why this goal moves revenue per operator. What changes downstream if it resolves yes vs no.>

## Required context

- `<project>/01-position.md` — for <reason>.
- `<project>/<other-layer>.md` — for <reason>.

## Predicted confidence

`<0.0 - 1.0>`. Be honest. The accuracy score punishes overconfidence harder than underconfidence.

## Kill criterion

Resolve early as MISS if:

- <signal 1> by <date>.
- <signal 2> by <date>.

## Owner

<Name>. Calibration on this taste-type: <accuracy score> over <N resolved goals>.
