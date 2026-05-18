---
title: adoption patterns
status: active
last_updated: 2026-05-04
---

# Adoption patterns

How the system spreads inside a team without being mandated. Adopt-by-mandate dies in 90 days; pull compounds.

## The pull pattern

Operators adopt a skill, a routine, or a context layer when adopting it makes their next ship faster, sharper, or more honest. Three conditions need to be true:

1. **The artifact saves time on something they're already doing.** Not "this would help if you started doing X." It's "this saves you 20 minutes the next time you ship a landing page."

2. **The cost of adoption is bounded.** The operator can read the SKILL.md or the layer in one sitting, run it once, and decide. If adoption requires a full week of training, it won't pull.

3. **The first ship using it is visibly better.** If the first draft after adoption is the same quality as the last draft before adoption, the operator won't keep using it. The first run has to land a visible win.

When all three are true, the operator adopts. They tell one teammate. The teammate adopts because their next ship is now harder than their colleague's. Pull spreads laterally, faster than top-down rollout.

## What kills pull

- **Mandates.** "Everyone must use the pre-publish check by Friday." The mandate triggers compliance theater. Operators run the gate, ignore the report, ship the draft. The mandate is checked off; nothing changes.
- **Training-heavy adoption.** A skill that requires a 90-minute onboarding video is pulled by zero people. A skill that runs from a single command and produces useful output on first run is pulled by everyone who tries it.
- **Hidden value.** A routine that runs in the background and produces a weekly report nobody sees is invisible to adoption. The value has to be visible at the operator's daily ship surface.
- **Vanity metrics.** "Adoption rate" measured as "people who ran the command once" is a vanity metric. Real adoption is measured by repeat use across two-week windows.

## What grows pull

- **Single-verb commands.** `substrate ship <draft>` instead of `substrate preflight --client X --strict --no-skip-voice <draft>`. The shorter the verb, the higher the adoption.
- **Default-on for risky paths.** The pre-publish-check runs automatically when the operator runs `ship`. The operator doesn't have to remember to gate; the gate runs by default.
- **Visible saves.** When the gate refuses a draft, the report names a specific failure with a specific fix. The operator saves time twice: once in not shipping the bad draft, once in fixing it from the named failure.
- **Calibration receipts.** Operators with good accuracy scores on a taste-type get visible recognition. Their colleagues see the receipts and want to build the same kind of track record.

## The lateral spread pattern

Adoption inside a team usually goes:

```
operator A pulls skill (saves time visibly)
   → operator A's next ship is sharper
   → operator B notices A's draft and asks
   → operator B pulls skill
   → ... and so on
```

This is faster than a rollout plan. It's the only pattern that has produced durable adoption inside teams in any version of this system.

## What's in scope for pull

Skills, routines, templates, layer freshness routines, dashboards. Anything operator-facing.

What's out of scope: principles. Principles are constitutional. They don't pull; they apply. Operators don't get to opt out of "every claim cites a source." They get to opt in to which skills they use.
