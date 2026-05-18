---
asset_type: email step
sequence_id: welcome-onboarding
step: 5
total_steps: 5
send_delay: T+8d
branch_on: exit-on-trial.activated; else continue
subject: "Last note before the trial ends. What worked, what didn't, what we'd fix"
preview_text: "Reply with one line. We read everything."
target_conversion_stage: close
cohort_exit_conditions: [trial.activated, unsubscribe, cohort.exit]
voice_check: pass
client: <your-product>
authored_date: 2026-05-08
---

# Step 5, close stage, T+8d

## Subject hypothesis

"Last note before the trial ends. What worked, what didn't, what we'd fix"

Honest framing at the close stage. Buyers describe the close-stage email as the one they actually read because it acknowledges the trial may not have worked. Per knowledge/patterns/subject-line-as-experiment-not-art.md.

## Preview text

"Reply with one line. We read everything."

## Body

This is the last note before the trial ends.

Three options. Pick whichever fits.

1. The trial worked. Convert here: `<conversion CTA>`. Maps to `trial.activated` and the close-stage narrative in `clients/<your-product>/06-conversion-narrative.md`.
2. The trial didn't quite work but the surface is interesting. Reply with the one thing that would have changed your mind. The team reads every reply.
3. The trial isn't the right fit. We'll close it gracefully. Reply with "not a fit" and we won't email again on this thread.

The position is in `clients/<your-product>/01-position.md`. The team's read on what makes the difference at this stage is in `clients/<your-product>/06-conversion-narrative.md`.

CTA at the close stage maps to `trial.activated`.

## Branch logic

`exit-on-trial.activated; else continue` — if the subscriber converted between step 4 and now, this step does not fire. After this step, the sequence ends regardless of conversion (the cohort timeout is at 14 days; this is the last touchpoint).

## Voice-check

Run `voice-enforce` on this body before commit.

## Substrate citations

- `clients/<your-product>/01-position.md`
- `clients/<your-product>/03-voice-of-customer.md`
- `clients/<your-product>/06-conversion-narrative.md`
- `clients/<your-product>/07-brand-voice.md`
