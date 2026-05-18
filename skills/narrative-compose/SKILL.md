---
name: narrative-compose
description: Compose the master narrative — message house, pillar copy, master story arc. Every asset descends from this. Format-agnostic; the source of truth for every channel.
version: 0.1
amplifies: PMM lead, narrative owner, content lead
masters: Andy Raskin (strategic narrative, old game/new game/promised land), April Dunford (positioning to narrative bridge), Joseph Campbell (hero's journey adapted to B2B buyer), Robert McKee (story structure), Ann Handley (content with voice), Aatir Abdul Rauf (PMM narrative posts), Anu Atluru (essay arcs), Donald Miller (StoryBrand 7-part), Lenny Rachitsky (long-arc product narrative), Joanna Wiebe (message hierarchy)
substrate_index_version: 2026-04-30
substrate_layers_required: [1, 3, 7, 9]  # 1=positioning, 3=voc, 7=brand-voice, 9=roadmap
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md          # mandatory first read — canonical position, Q2 narrative wins, brand voice cadence rules
---

# narrative-compose

## Purpose

Take positioning + ICP + VoC and compose the master narrative every asset references. The message house is canonical — if a downstream asset's claim isn't here, the asset is rejected.

## Inputs

- `--client <client>`
- `--scope <whole-product|product-line|launch|campaign>`
- `--audience <icp-id>` (default: primary ICP)

## Process

1. Read substrate: positioning.md, icp.md, voc.md, competitive.md, brand-voice.md.
2. Compose the strategic narrative (Raskin frame): change in the world → new game rules → promised land → obstacles → resolution.
3. Compose the message house: 1 positioning statement + 3 pillars × (headline / support / evidence / proof point).
4. Compose audience-specific reframings (1 per major ICP cell, max 3) — same canonical position, different entry door.
5. Compose master CTA system: 3 CTAs across awareness / consideration / decision.
6. Compose objection-handling section: top 5 buyer objections × narrative answer.
7. Write to `clients/<client>/substrate/narrative.md` (or under brand-voice/strategy if no narrative layer exists yet — flag schema friction).
8. Generate a one-page master narrative brief at `clients/<client>/personas/master-narrative-<date>.md`.

## Output

master narrative file + brief.

## Gates

- **One canonical message house:** drift = failure.
- **Substrate-cited:** every pillar evidence cites substrate.
- **Voice-enforced:** passes voice-enforce gate.
- **Synth-audience-tested:** runs through synth-audience against pinned personas before being declared canonical.

## Composes with

Reads from: positioning-forge, icp-cut, voc substrate, competitive-displace.
Writes for: copywrite, content-ship, lp-ship, ad-ship, email-ship, video-ship, help-write — every asset skill.
Triggered by: positioning change, launch open, quarterly refresh.

## Refusal patterns

- Pillar without evidence path → reject.
- More than 3 audience reframings → reject; cut.
- Master CTA conflicts with positioning → reject.

## Calibration

Tracked under taste-type `narrative`. Brier signal: assets descended from this narrative win in synth-audience + ship within 60 days.

## Substrate preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/00-INDEX.md`. If any required layer is `thin` or `partial`, the skill returns:

```
SUBSTRATE-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.

