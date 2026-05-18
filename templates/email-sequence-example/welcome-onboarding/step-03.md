---
asset_type: email step
sequence_id: welcome-onboarding
step: 3
total_steps: 5
send_delay: T+72h
branch_on: exit-on-trial.activated; else continue
subject: "What three customers built in their first week"
preview_text: "Use cases your trial probably overlaps with."
target_conversion_stage: consideration
cohort_exit_conditions: [trial.activated, unsubscribe, cohort.exit]
voice_check: pass
client: <your-product>
authored_date: 2026-05-08
---

# Step 3, consideration stage, T+72h

## Subject hypothesis

"What three customers built in their first week"

Customer-language hook mined from case-study substrate. The buyer at this stage is asking "what is this for me, specifically." Per knowledge/patterns/subject-line-as-experiment-not-art.md, this is a hypothesis to test against feature-led variants.

## Preview text

"Use cases your trial probably overlaps with."

## Body

The trial gets clearer when you see how three customers used the same surface in their first week:

1. First customer use case, with the action they took on day one.
2. Second customer use case, with the action they took on day two.
3. Third customer use case, with the action they took on day five.

Each one cites the source in `clients/<your-product>/03-voice-of-customer.md` and the product surface in `clients/<your-product>/05-product-knowledge.md`.

The position the trial is grounded in is in `clients/<your-product>/01-position.md`. The conversion narrative for the consideration stage is in `clients/<your-product>/06-conversion-narrative.md`.

CTA at the consideration stage maps to `trial.activated`.

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
