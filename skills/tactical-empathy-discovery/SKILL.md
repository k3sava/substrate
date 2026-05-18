---
name: tactical-empathy-discovery
description: Runs Voss-pattern discovery calls with mirrors, labels, and accusation audits. Surfaces the buyer's actual situation, not their pitch script reaction. Operationalises rapport-as-research-multiplier.
version: 0.1
amplifies: PMM, founder, sales engineer, AE
masters: Chris Voss (Never Split the Difference, tactical empathy, mirrors, labels, accusation audit, calibrated questions), Bob Moesta (JTBD switch interview), Stuart Diamond (Getting More, perception-driven negotiation)
substrate_layers_required: [voc, icp, positioning]
patterns_grounded: [rapport-surfaces-what-research-cannot, frontline-as-pmm-substrate, diagnose-before-execute]
preflight_refusal: substrate-gap, missing-icp-pin
required_reads:
  - clients/{client}/icp/00-INDEX.md
  - clients/{client}/voc/cadence-contract.md
---

# tactical-empathy-discovery

## Purpose

Most discovery calls ask buyers to react to a pitch. Voss-pattern discovery asks buyers to describe their world, then mirrors and labels until the buyer corrects the seller into the truth. The artifact is the corrected truth, not the buyer's first answer.

## Inputs

- `--client <client>` (required)
- `--icp-id <pinned-icp>` (required)
- `--call-purpose <discovery|user-interview|win-interview|loss-interview|expansion>`
- `--transcript-path <path>` (required for processing)

## Interview craft (the skill enforces these)

1. **Open with a label, not a question.** "It seems like the team has been weighing this for a while." Lets the buyer correct or extend.
2. **Mirror the last 3 words.** Repeat back; let silence pull more.
3. **Calibrated how/what questions.** "How does this end up on someone's desk this quarter?" Never "why" — it triggers defense.
4. **Accusation audit.** Pre-empt the negative. "You're going to feel like I'm just trying to sell you. I'm not. I want to know if there's a real fit."
5. **Get to "that's right" not "you're right."** "You're right" is dismissal. "That's right" is conviction.
6. **Late-stage anchor.** "It seems like the only way this works is if X." Forces the buyer to commit or correct the X.

## Substrate reads

- `icp/<pinned-icp>.md`, the persona being interviewed.
- `voc/cadence-contract.md`, the cadence the call belongs to.

## Output contract

- Coded interview at `voc/processed/tactical-discovery/<call-id>.md` with sections `{labels_used, accusation_audit_pulled, that_s_rights, calibrated_questions_log, corrected_truths}`.
- A `corrected-truth` ledger entry per persona, tracking how the truth shifts between calls.
- Optional patch proposals to ICP, positioning, sales-pitch.

## Quality criteria

- Refuses to ship without `that_s_rights` field populated. If the buyer never said "that's right," the interview missed conviction.
- Flags interviews where the seller did >60% of the talking. Voss craft is buyer-talk-time.
- Surfaces drift: when corrected-truths across N≥3 interviews diverge from the substrate ICP, files a positioning patch.

## See also

- `skills/frontline-contact/`, schedules the calls.
- `skills/win-loss-interview/`, the structured form for outcome interviews.
- `knowledge/patterns/rapport-surfaces-what-research-cannot.md`.
