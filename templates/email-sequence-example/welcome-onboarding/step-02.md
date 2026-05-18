---
asset_type: email step
sequence_id: welcome-onboarding
step: 2
total_steps: 5
send_delay: T+24h
branch_on: exit-on-trial.activated; else continue
subject: "Stuck on the first action? Three reasons people get blocked"
preview_text: "Each one has a one-line fix. None require a call."
target_conversion_stage: awareness
cohort_exit_conditions: [trial.activated, unsubscribe, cohort.exit]
voice_check: pass
client: <your-product>
authored_date: 2026-05-08
---

# Step 2, awareness stage, T+24h

## Subject hypothesis

"Stuck on the first action? Three reasons people get blocked"

Mined from support tickets in `clients/<your-product>/03-voice-of-customer.md`. The three failure modes show up across the corpus.

## Preview text

"Each one has a one-line fix. None require a call."

## Body

If you opened the trial yesterday and didn't get past the first action, you're in good company. The three reasons that come up most often in support:

1. The first failure mode and its one-line fix. (Cite `clients/<your-product>/03-voice-of-customer.md` ticket cluster.)
2. The second failure mode and its one-line fix.
3. The third failure mode and its one-line fix.

The position is in `clients/<your-product>/01-position.md`. If none of those three get you unstuck, reply to this email and a real person on the team will read it.

CTA at the awareness stage maps to `trial.activated`.

## Branch logic

`exit-on-trial.activated; else continue` — if the subscriber fired `trial.activated` between step 1 and step 2, this step does not fire and the sequence ends. Other exit conditions follow the kill-switch in the README.

## Voice-check

Run `voice-enforce` on this body before commit.

## Substrate citations

- `clients/<your-product>/01-position.md`
- `clients/<your-product>/03-voice-of-customer.md` (failure-mode corpus)
- `clients/<your-product>/05-product-knowledge.md`
- `clients/<your-product>/06-conversion-narrative.md`
- `clients/<your-product>/07-brand-voice.md`
