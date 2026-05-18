---
asset_type: email sequence
sequence_id: welcome-onboarding
client: <your-product>
cohort: new-trial-signup
trigger_event: trial.started
purpose: onboarding
steps: 5
target_conversion: trial.activated
authored_date: 2026-05-08
voice_check: pass
---

# welcome-onboarding (example template)

This is a worked example of an onboarding sequence. The cohort is `new-trial-signup`, the entry trigger is `trial.started`, the target conversion is `trial.activated`. Use this directory as a reference for the shape `email-sequence-design` produces.

## Cohort

`new-trial-signup` — every user who fires `trial.started`. Defined in `clients/<your-product>/events.yaml`.

## Trigger

- Enter on: `trial.started`
- Sequence purpose: onboarding

## Kill-switch (cohort-exit conditions)

- On `trial.activated` — sequence ends, conversion logged.
- On unsubscribe — sequence ends.
- On `cohort.exit` — sequence ends.

## Step layout

| Step | Send delay | Stage | Branch |
|---|---|---|---|
| 1 | T+0h | awareness | always |
| 2 | T+24h | awareness | exit-on-trial.activated; else continue |
| 3 | T+72h | consideration | exit-on-trial.activated; else continue |
| 4 | T+5d | decision | exit-on-trial.activated; else continue |
| 5 | T+8d | close | exit-on-trial.activated; else continue |

## Files

- [`step-01.md`](step-01.md)
- [`step-02.md`](step-02.md)
- [`step-03.md`](step-03.md)
- [`step-04.md`](step-04.md)
- [`step-05.md`](step-05.md)

## Substrate citations

- Position: `clients/<your-product>/01-position.md`
- ICP: `clients/<your-product>/02-icp.md`
- Conversion narrative: `clients/<your-product>/06-conversion-narrative.md`
- Brand voice: `clients/<your-product>/07-brand-voice.md`
- Events taxonomy: `clients/<your-product>/events.yaml`

## Patterns grounding this sequence

- knowledge/patterns/one-segment-one-trigger.md
- knowledge/patterns/subject-line-as-experiment-not-art.md
- knowledge/patterns/engagement-decay-as-relevance-signal.md
