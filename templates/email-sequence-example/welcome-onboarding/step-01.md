---
asset_type: email step
sequence_id: welcome-onboarding
step: 1
total_steps: 5
send_delay: T+0h
branch_on: always
subject: "Your trial is live. The next 60 seconds are the ones that matter."
preview_text: "One action gets you to the part of the product the team built for."
target_conversion_stage: awareness
cohort_exit_conditions: [trial.activated, unsubscribe, cohort.exit]
voice_check: pass
client: <your-product>
authored_date: 2026-05-08
---

# Step 1, awareness stage, T+0h

## Subject hypothesis

"Your trial is live. The next 60 seconds are the ones that matter."

The hypothesis is mined from `clients/<your-product>/03-voice-of-customer.md`. Buyers in this cohort describe the first session as the moment they decide whether the product is worth the effort. Per knowledge/patterns/subject-line-as-experiment-not-art.md, this is a testable hypothesis, not a craft choice.

## Preview text

"One action gets you to the part of the product the team built for."

## Body

Welcome. Your account at `<your-product>` is ready.

The team that built this thinks the next 60 seconds matter more than the rest of the trial. Here is what gets you to the moment the product earns its place:

1. Open the app from this link: `<one-action CTA>`.
2. Take the one action the activation milestone tracks.
3. Tell us what got in your way if anything did.

That is it. The activation milestone is in `clients/<your-product>/05-product-knowledge.md`. The conversion narrative for this stage is in `clients/<your-product>/06-conversion-narrative.md`.

CTA at the awareness stage maps to `trial.activated`.

## Branch logic

`always` — this is the entry step. Every subscriber in the cohort gets it.

## Voice-check

Run `voice-enforce` on this body before commit. If fail, the step does not ship.

## Substrate citations

- `clients/<your-product>/01-position.md` (position)
- `clients/<your-product>/02-icp.md` (cohort to ICP cell mapping)
- `clients/<your-product>/03-voice-of-customer.md` (subject + preview hypothesis source)
- `clients/<your-product>/06-conversion-narrative.md` (stage)
- `clients/<your-product>/07-brand-voice.md` (voice gate)
