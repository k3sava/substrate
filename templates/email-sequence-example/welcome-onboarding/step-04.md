---
asset_type: email step
sequence_id: welcome-onboarding
step: 4
total_steps: 5
send_delay: T+5d
branch_on: exit-on-trial.activated; else continue
subject: "A 5-minute walkthrough of the part of the product the team built for"
preview_text: "If the trial hasn't earned its place yet, this is the surface that does."
target_conversion_stage: decision
cohort_exit_conditions: [trial.activated, unsubscribe, cohort.exit]
voice_check: pass
client: <your-product>
authored_date: 2026-05-08
---

# Step 4, decision stage, T+5d

## Subject hypothesis

"A 5-minute walkthrough of the part of the product the team built for"

Plain framing, no jargon. The buyer at the decision stage is asking "is this worth my next 5 minutes." The subject answers directly.

## Preview text

"If the trial hasn't earned its place yet, this is the surface that does."

## Body

Five days into the trial. If you haven't found the surface that earned the team's effort, here it is in a 5-minute walkthrough.

Three things you'll see:

1. The first surface that ships the differentiated value, per `clients/<your-product>/01-position.md`.
2. The second surface buyers most often cite as the reason they converted, per `clients/<your-product>/03-voice-of-customer.md`.
3. The third surface that compounds with the first two, per `clients/<your-product>/05-product-knowledge.md`.

Walkthrough link: `<5-minute-walkthrough-CTA>`.

If you watch and the answer is still no, reply with what would have changed your mind. The team reads every reply.

CTA at the decision stage maps to `trial.activated`.

## Branch logic

`exit-on-trial.activated; else continue`

## Voice-check

Run `voice-enforce` on this body before commit.

## Substrate citations

- `clients/<your-product>/01-position.md`
- `clients/<your-product>/03-voice-of-customer.md`
- `clients/<your-product>/05-product-knowledge.md`
- `clients/<your-product>/06-conversion-narrative.md`
- `clients/<your-product>/07-brand-voice.md`
