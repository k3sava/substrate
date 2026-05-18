---
name: claim-verify
description: Substrate-truth check beyond citation existence. For every claim that has a nearby substrate cite (per substrate-cite-check), confirm the claimed value actually appears in the cited substrate file. Closes the audit's deeper concern: PASS at Gate 6 means CITED, not VERIFIED-TRUE.
version: 0.1
status: wired
absorbed_from: substrate-fidelity audit pattern (Gate 6 + Gate 7 = layered defense)
absorption_date: 2026-05-01
amplifies: every operator who externalizes a claim
masters: anti-fabrication ladder; evidence-ladder (5-tier verified | self-reported | contextual | indirect | direct); Wikipedia AI Cleanup field guide; Hamel + Shreya on per-claim factuality eval
substrate_layers_required: []
preflight_refusal: none (this IS the deeper refusal layer)
composes_with: [substrate-cite-check, preflight, voice-enforce-vale, humanizer]
---

# claim-verify

## Purpose

Gate 6 (substrate-cite-check) catches: claim with no cite. Gate 7 (claim-verify) catches: claim cited to a path that doesn't actually contain the claimed value. The two gates together close the audit's substrate-fidelity concern.

## How it works

1. Parse asset for (claim, nearest-substrate-path) pairs — same logic as substrate-cite-check.
2. For each pair, open the substrate file at the cited path.
3. Check if the claim's specific value (number, dollar, percentage, date, source-system ID) appears in the substrate file.
4. If the value appears → verified. If not → flag as **CITE-VALUE-MISMATCH**.

This is a narrow truth-check — does the substrate actually support what the asset claims? — not a full fact-checking pipeline.

## Inputs

- `<asset-path>` (positional)
- `--strict` — fail on any cite-value-mismatch
- `--threshold N` — fail if more than N mismatches (default 0; this gate has zero tolerance because mismatches are substrate-fidelity failures)
- `--json` — emit JSON report

## What counts as "value appears in substrate"

For a claim like `$1,047`, the substrate must contain a string matching one of:
- The exact value: `$1,047` or `$1047` or `1,047` (numeric formats)
- The value within a 5% tolerance for percentages and qty-units (allows minor rounding)
- The value's source-system ID verbatim (e.g., `HubSpot dashboard 138849319` must appear in the cited substrate file)

For dates and named entities, exact match required.

## What does NOT count

- A claim cited to a substrate file that doesn't contain the specific value, even if it's plausible.
- A claim citing a path that doesn't exist (substrate-cite-check catches this earlier).
- A claim whose value contradicts the substrate (e.g., asset says "65%" but substrate says "65.1%" — within 5% tolerance, accepted; "70%" — outside tolerance, flagged).

## Outputs

- **stderr** — per-mismatch table: line, claim, cited path, what substrate actually says
- **stdout** — `PASS / FAIL` summary

## Exit codes

- 0 — all cited claims verify against substrate
- 1 — cite-value mismatches detected
- 2 — file not found / config error

## Composes with

- preflight composite gate: NOT YET WIRED as a hard gate. The proximity-heuristic that maps claim → cite is rough; it picks the nearest path, which may not be the semantic match. False-positive rate is non-trivial. Run as advisory pre-ship; treat findings as candidate gaps to verify, not automatic fails.
- substrate-cite-check + claim-verify together = "the claim is cited AND the cite is plausibly true"
- humanizer / voice-enforce-vale: orthogonal; voice + truth are independent gates

## Recommended use

Until the proximity-heuristic improves, run claim-verify explicitly on high-stakes assets before send:

```
substrate/skills/claim-verify/bin/claim-verify <asset> --json | python3 -m json.tool
```

Treat each mismatch as a "verify or rephrase" item. For the May 4 brief specifically, every CFO/CMO/CEO question bank should be claim-verified before any answer is quoted in the room.

## Refusal patterns

Internal-spec assets bypass automatically (same as substrate-cite-check + voice-enforce-vale).

## Calibration

Tracked under taste-type `substrate-fidelity-truth`. Brier signal: post-publish corrections needed where the substrate didn't support the claim. The canonical failure mode this gate catches: a draft asserts "Competitor X has no Y" while the cited substrate file actually says "Competitor X has limited Y, post-call only" — the claim is too strong for the source. Without claim-verify, the mismatch lands in published copy and gets corrected after the fact. With claim-verify, the draft refuses at the gate.

## What this gate catches

A canonical-statement draft can cite a battle card path as the source for a claim about a competitor (e.g. "Competitor X, no voice agent"). claim-verify will:
- Open the cited battle card under `clients/<client>/competitive/battle-cards/<competitor>.md`
- Search for the load-bearing phrase
- Flag CITE-VALUE-MISMATCH when the cited substrate doesn't actually support the claimed value

This is the failure mode the gate exists to prevent: cite present (Gate 6 passes), value not actually in the substrate (Gate 7 catches it).

Gate 7 closes the truth-layer the audit named. Gate 6 says "you cited"; Gate 7 says "your cite supports your claim."
