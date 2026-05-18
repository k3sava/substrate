---
name: email-sequence-design
description: Design a multi-step lifecycle, nurture, or re-engagement email sequence grounded in canonical positioning, ICP, and a named buyer-state cohort with a behavioral trigger. Output is a directory of per-step markdown files with subject, preview, body, send delay, and branching logic. Composes voice-enforce on every body.
version: 0.1
amplifies: lifecycle marketer, growth lead, PMM owning a launch sequence
masters: Val Geisler (lifecycle teardowns; former Klaviyo Head of Customer Acquisition), Joanna Wiebe (Copyhackers; message mining for subject lines), Bob Moesta (JTBD progress moments as the trigger unit), Brian Kotlyar (segment-or-die operating discipline), Andy Crestodina (Orbit Media; behavioral content beats blast)
substrate_layers_required: [positioning, icp, voc, brand-voice, conversion-narrative]
patterns_grounded: [one-segment-one-trigger, subject-line-as-experiment-not-art, engagement-decay-as-relevance-signal]
contradictions_aware: []
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
  - clients/{client}/06-conversion-narrative.md
  - clients/{client}/07-brand-voice.md
---

# email-sequence-design

## Purpose

Design a multi-step email sequence (lifecycle, nurture, re-engagement, post-purchase, churn-save) where every step is grounded in canonical positioning, scoped to a named cohort, and fired by an observed behavioral trigger. The sequence ships as a structured directory under `clients/<client>/email/sequences/<sequence-id>/` with one markdown file per step. Every body passes `voice-enforce` before write.

This skill replaces "send a 5-email nurture about the new feature" with "design an 8-step sequence that fires when a paid trial user has not invited a teammate within 96 hours, scoped to the activation cohort, with a kill-switch on cohort exit." The unit of design is one cohort × one trigger, per the `one-segment-one-trigger` pattern.

## Inputs

- `--client <client>` (required)
- `--sequence-id <slug>` (required, e.g. `paid-trial-no-teammate-invite`)
- `--cohort <name>` (required, e.g. `paid-trial-stuck-on-activation`)
- `--trigger-event <event>` (required, e.g. `trial.activated.no-teammate-96h`)
- `--purpose <onboarding|nurture|re-engagement|post-purchase|churn-save|launch>` (required)
- `--steps <n>` (default 5, max 12)
- `--target-conversion <event>` (required, the conversion event the sequence drives)

## Substrate reads

The skill refuses unless these layers exist for the client:

1. `01-position.md` — sequences ship the canonical position. Subject lines and bodies must reflect it.
2. `02-icp.md` — the cohort must map to a pinned ICP cell. "Activated paid-trial user from mid-market segment B" is a cell; "free trial user" is not.
3. `06-conversion-narrative.md` — the awareness/consideration/decision/close arc anchors which step targets which buyer state.
4. `07-brand-voice.md` — the voice spec the bodies are gated against. `voice-enforce` is composed.
5. `events.yaml` (when `--trigger-event` is provided) — the trigger event must exist in the product event taxonomy. If the file is missing, the skill refuses and points to `email-cohort-trigger` to design the events first.

## Process

1. Preflight: required-reads check + substrate freshness check (any layer past freshness window is refused).
2. Cohort definition: read `02-icp.md`, find the cell the cohort maps to, write the cell reference into the sequence README.
3. Trigger validation: confirm `--trigger-event` is declared in `clients/<client>/events.yaml` (or refuse).
4. Step count and shape: pick the structure based on `--purpose` (onboarding=5–7, nurture=4–6, re-engagement=3–5, post-purchase=4–6, churn-save=3–4, launch=4–6).
5. Per step: emit a structured stub with frontmatter (step number, send delay, branch conditions, subject hypothesis, preview, target conversion stage, voice-check status). Body is a draft a human refines.
6. Voice gate: every body passes `voice-enforce` before the file is written. Fails block the write; the skill suggests rewrites.
7. README emit: a sequence-level README that names the cohort, trigger, kill-switch (cohort-exit conditions), branching logic, and links every step file.

## Output contract

```
clients/<client>/email/sequences/<sequence-id>/
  README.md              # cohort, trigger, kill-switch, branching, target conversion
  step-01.md             # subject, preview, body, send delay, branch-on-X
  step-02.md
  ...
  step-N.md
```

Each step file frontmatter:

```yaml
---
step: 1
send_delay: T+0h | T+24h | T+72h
branch_on: <event-name | always | exit-on-conversion>
subject: <subject hypothesis>
preview_text: <preview text>
target_conversion_stage: awareness | consideration | decision | close
cohort_exit_conditions: [<event>, <event>]
voice_check: pass | advisory | fail
---
```

## Quality criteria

- Every step has a defined send delay (no calendar-Tuesday programs).
- Every step has a defined branch (always, on-event, exit-on-conversion).
- Every body cites at least one substrate path inline (positioning, conversion-narrative, voc).
- Every subject is a testable hypothesis with a cohort scope (per `subject-line-as-experiment-not-art`).
- Sequence README declares kill-switch conditions; sequences without exit-on-conversion are refused.

## What this skill does NOT do

- Doesn't actually wire the trigger into Customer.io or Iterable. Use `email-cohort-trigger` to produce the trigger spec for the email tool's API.
- Doesn't run an A/B test on subject lines. The skill emits hypotheses; the test infrastructure is downstream.
- Doesn't measure performance. The decay watcher (`email-engagement-decay-watcher`) reads metrics post-ship.
- Doesn't audit deliverability. Use `email-deliverability-audit` and `email-list-hygiene` for that.

## Refusal patterns

- **substrate-gap** — any required layer missing or stale. Fix substrate first.
- **events-yaml-missing** — `clients/<client>/events.yaml` not present. Run `email-cohort-trigger --bootstrap` first.
- **cohort-undefined** — the cohort does not map to an ICP cell. Sharpen the cohort first.
- **trigger-undeclared** — the trigger event is not in the events taxonomy. Add the event or pick a declared one.
- **broadcast-default** — `--trigger-event always` with no cohort exit is a broadcast nurture, not a sequence. Refused per `one-segment-one-trigger`.
- **voice-fail** — any step body fails `voice-enforce` and the operator does not override. Block the write.

## See also

- `email-cohort-trigger` — designs the upstream trigger and events taxonomy.
- `email-engagement-decay-watcher` — flags decay on shipped sequences.
- `voice-enforce` — gates every body.
- `narrative-compose` — the master narrative every sequence descends from.
- `knowledge/patterns/one-segment-one-trigger.md`
- `knowledge/patterns/subject-line-as-experiment-not-art.md`
- `knowledge/patterns/engagement-decay-as-relevance-signal.md`
