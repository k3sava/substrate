---
name: email-engagement-decay-watcher
description: Weekly routine that flags lifecycle sequences whose open or click rates have declined more than a configured threshold over a rolling 4-week window vs the prior 4-week window. Reads sequence metrics from clients/<client>/email/metrics/<sequence-id>-<YYYY-MM>.csv, computes lift, classifies decay shape (sudden cliff vs gradual taper), and outputs decay alerts with a hypothesis (subject line fatigue, audience drift, deliverability slide).
version: 0.1
amplifies: lifecycle marketer, growth lead, RevOps reviewing the email program
masters: Val Geisler (lifecycle teardowns; decay diagnosis discipline), Brian Kotlyar (segment-or-die; decay = relevance break first), Jen Capstraw (engagement as renewing permission), public mailbox-provider documentation (Gmail Postmaster engagement signals; Microsoft SNDS)
substrate_layers_required: []
patterns_grounded: [engagement-decay-as-relevance-signal, one-segment-one-trigger]
contradictions_aware: []
preflight_refusal: missing-metrics
required_reads: []
---

# email-engagement-decay-watcher

## Purpose

A weekly watcher routine that reads shipped sequence metrics, computes 4-week-vs-prior-4-week lift on open and click rates, flags decay above the configured threshold, classifies the decay shape (sudden cliff vs gradual taper), and emits alerts ranked by severity.

This skill replaces "things feel slow on the lifecycle program" with "sequence `paid-trial-no-teammate-invite` open rate fell from 38.4% (prior 4 weeks) to 25.1% (current 4 weeks), a -34.6% relative decline; the shape is gradual taper across all 5 steps; first hypothesis is audience drift (cohort composition shifted), not deliverability."

Per the `engagement-decay-as-relevance-signal` pattern, the watcher's first hypothesis is always relevance, not deliverability. The output points the operator at `email-cohort-trigger` (sharpen the cohort) or `email-sequence-design` (refresh the bodies) before pointing at `email-deliverability-audit`.

## Inputs

- `--client <client>` (required)
- `--metrics-dir <path>` (optional, default: `clients/<client>/email/metrics/`)
- `--threshold <pct>` (default `25`; relative decline % that triggers an alert)
- `--out <path>` (optional, default: `clients/<client>/email/decay/<YYYY-MM-DD>.md`)
- `--sequence <id>` (optional; if set, watcher runs only on that sequence; default = all sequences with available metrics)

## Substrate reads

The watcher does not require substrate layers (no positioning, ICP, narrative reads). It reads the *metrics* substrate the operator commits weekly. Mailbox-provider documentation is referenced in the hypothesis classifier.

## Metrics CSV contract

The watcher reads CSVs from `--metrics-dir`. Filename pattern: `<sequence-id>-<YYYY-MM>.csv`.

Schema:

```
date,sequence_id,step,sent,delivered,opened,clicked,unsubscribed,complained,bounced
```

The watcher computes:

- `open_rate = opened / delivered`
- `click_rate = clicked / delivered`
- `complaint_rate = complained / delivered`
- `bounce_rate = bounced / sent`

Aggregated at the sequence level over rolling 4-week windows.

## Process

1. **Preflight**: confirm `--metrics-dir` exists and contains at least 8 weeks of CSV data per sequence (else `missing-metrics` refusal for that sequence; warn but continue on others).
2. **Per-sequence aggregation**: read all CSVs in window, compute current 4-week and prior 4-week aggregates.
3. **Lift calculation**: for each metric, compute relative lift `(current - prior) / prior * 100`.
4. **Decay flag**: if `open_rate` lift OR `click_rate` lift falls below `-threshold` (default -25%), emit a decay alert.
5. **Shape classification**: walk the per-week series within the current window. Compute weekly variance and slope.
   - **Sudden cliff**: one-week drop accounting for >70% of the total decline; subsequent weeks are flat-low.
   - **Gradual taper**: monotonic decline across the 4 weeks; no single-week dominates.
   - **Step-down**: discrete level shift in the middle of the window; before-and-after are stable but at different levels.
6. **Hypothesis ranking**: based on shape and complaint/bounce co-movement, rank hypotheses:
   - **Sudden cliff + complaint/bounce spike** → deliverability event (route to `email-deliverability-audit`).
   - **Sudden cliff + complaint/bounce flat** → blocking event upstream (cohort gate change, ESP outage); investigate the trigger.
   - **Gradual taper + complaint/bounce flat** → relevance break / audience drift / subject fatigue (route to `email-cohort-trigger` or `email-sequence-design`).
   - **Step-down** → discrete change (often a cohort definition change, an ICP shift, a major campaign exposure); investigate the cohort.
7. **Severity tiering**: critical (relative decline > 50%); high (25-50%); medium (10-25%, advisory only); low (under 10%, no alert).
8. **Output emit**: `decay/<YYYY-MM-DD>.md` with one block per affected sequence, plus a "no decay detected" summary line for healthy sequences.

## Output contract

```
clients/<client>/email/decay/<YYYY-MM-DD>.md
```

Frontmatter:

```yaml
---
watcher_run_date: <YYYY-MM-DD>
sequences_audited: <n>
decay_alerts: <n>
critical_alerts: <n>
high_alerts: <n>
threshold_pct: <n>
watcher_skill: email-engagement-decay-watcher
watcher_version: 0.1
---
```

Per-sequence block:

```markdown
## <sequence-id>

- Status: critical | high | medium | low | healthy
- Open rate: prior 4w <a%> → current 4w <b%> (<lift>%)
- Click rate: prior 4w <a%> → current 4w <b%> (<lift>%)
- Complaint rate: prior 4w <a> → current 4w <b>
- Bounce rate: prior 4w <a> → current 4w <b>
- Decay shape: sudden cliff | gradual taper | step-down | none
- First hypothesis: <relevance | deliverability | upstream-blocking | cohort-change>
- Recommended skill: <email-cohort-trigger | email-sequence-design | email-deliverability-audit>
- Substrate citations: <metrics paths used>
```

## Quality criteria

- Every alert cites the input CSV paths used to compute the rates.
- No fabricated numbers. If a sequence has fewer than 8 weeks of data, the watcher skips it and says so.
- Hypothesis ranking is deterministic from the shape + complaint/bounce co-movement; same input produces same output.
- Decay shape classification is documented in the bin (rules are auditable).

## What this skill does NOT do

- Does not pull metrics from ESP APIs. Operator commits CSVs weekly.
- Does not fix the decay. It points at the right next skill.
- Does not run a creative test. Subject experiments live in `email-sequence-design`.
- Does not run on programs younger than 8 weeks (insufficient signal; the skill exits 0 with a "too young" note).

## Refusal patterns

- **missing-metrics** — `--metrics-dir` does not exist or has no CSVs.
- **schema-mismatch** — CSVs missing required columns. The watcher refuses for that sequence and warns on others.
- **window-too-short** — fewer than 8 weeks of data; per-sequence skip with a noted reason.

## See also

- `email-cohort-trigger` — first remediation when shape = gradual taper.
- `email-sequence-design` — second remediation when content needs refresh.
- `email-deliverability-audit` — second remediation when shape = sudden cliff with complaint/bounce co-movement.
- `routines/email-decay-routine.md` — the weekly cron description.
- `knowledge/patterns/engagement-decay-as-relevance-signal.md`
- `knowledge/patterns/one-segment-one-trigger.md`
