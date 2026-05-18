---
name: voice-enforce
description: 10-point voice gate. Source of truth is the client's brand-voice substrate, not a hardcoded rule list. Sharper than the prior editor-voice-checker.
version: 0.1
amplifies: editor, copywriter, content reviewer
masters: Ann Handley (voice as discipline), Strunk + White (Elements of Style), William Zinsser (On Writing Well), Ernest Hemingway (iceberg), George Saunders (cut every word that does not earn its place), Mark Twain (specific over abstract), Stephen King (kill the darlings, kill adverbs), Kesava Mandiga (10-point voice spec from Kaleidoscopic), Joanna Wiebe (clarity + conversion), Verlyn Klinkenborg (Several Short Sentences About Writing)
substrate_index_version: 2026-04-30
substrate_layers_required: [7]  # 7=brand-voice
preflight_refusal: substrate-gap
---

# voice-enforce

## Purpose

Block voice failures before they ship. Enforces the client's brand-voice spec — not a generic "good writing" rubric.

## Inputs

- `--client <client>`
- `--text <path or stdin>`
- `--strict | --advisory`

## Process

1. Read `clients/<client>/substrate/brand-voice.md` (the 10-point spec; client-specific).
2. Run each rule as a check (regex + heuristic + LLM-judge for subjective rules):
   - kill-list words (configurable per client via `clients/<client>/brand-voice/kill-list.md`; substrate default lives in `knowledge/voice/how-we-write.md`)
   - em-dash in body (configurable)
   - throat-clearing openers
   - generic-AI cadence (3-clause parallelism abuse)
   - passive voice density > threshold
   - sentence-length variance (Provost cadence)
   - specific-over-abstract ratio
   - first-person consistency
   - no fabricated metrics (cross-check against substrate)
   - voice fingerprint (LLM-judge against pinned voice exemplars)
3. Score: pass / advisory / fail per rule.
4. In `--strict`, any fail blocks the asset. In `--advisory`, output diagnostic only.
5. If fail, write a rewrite suggestion (not a rewrite — operator decides).

## Output

A voice report (pass/advisory/fail per rule + suggestions) at `clients/<client>/logs/voice-<asset-id>-<date>.md`.

## Gates

This skill IS a gate. It is composed into preflight, not gated by it.

## Composes with

Reads from: brand-voice substrate.
Writes for: preflight, every asset workflow.
Triggered by: every shipping path.

## Refusal patterns

- brand-voice.md missing for client → reject; require substrate-curate first.
- Operator override "just ship it" → log override, do not silently allow.

## Calibration

Tracked under taste-type `creative-production`. Brier signal: voice-passed assets win in synth-audience at higher rate.

## Substrate preflight (refusal pattern)

Before executing, this skill verifies its declared layer dependencies are `covered` in `clients/<client>/substrate/00-INDEX-10-layers-2026-04-30.md`. If any required layer is `thin` or `partial`, the skill returns:

```
SUBSTRATE-GAP — cannot execute.
Required layer(s) <list> below threshold.
Refusal-pattern guarantee: no published asset references a layer that wasn't read.

Resolution:
1. Open <layer-source-file> and bring layer to `covered` state, OR
2. Document the gap in a `--with-gap` flag and explicitly accept the risk.
```

This is the constitutional anti-fabrication gate. Skip-flag exists for emergencies; default is refuse.

