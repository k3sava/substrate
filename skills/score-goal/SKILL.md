---
name: bet-resolve
description: Close a bet. Compute Brier score against the bet's pre-commitment. Update calibration ledger. Trigger substrate update. Honest losses count as much as wins.
version: 0.1
amplifies: PMM lead, function owner, analyst
masters: Tetlock (Brier scoring), Annie Duke (resulting vs decision quality), Hamel Husain (eval discipline), Charity Majors (postmortem culture), John Allspaw (blameless retro), Karpathy (training-loop hygiene), Anthropic (model evals → operator evals), Tom Tunguz (cohort honesty), Lenny Rachitsky (kill the project), Stripe (SLO-style accountability)
substrate_index_version: 2026-04-30
substrate_layers_required: [6, 9]  # 6=conversion-narrative, 9=roadmap
preflight_refusal: substrate-gap
---

# bet-resolve

## Purpose

Close a bet honestly. The Brier score is the auditable signal; honest losses score as well as wins because both update the calibration ledger.

## Inputs

- `--bet <bet-id>`
- `--actual <value>`: actual metric outcome
- `--source-pull <path>`: where the actual came from (Amplitude query, CSV, screenshot)
- `--note <text>`: what we learned

## Process

1. Read the bet file. Pull baseline, target, window.
2. Compute Brier: `(predicted_probability_of_target - actual_outcome)²`. Bet's predicted probability comes from the bet file's belief confidence. If belief was binary, Brier = 0 if hit, 1 if miss.
3. Classify outcome: HIT / PARTIAL / MISS / KILLED-EARLY / NULL (data unavailable).
4. Append to bet file's `## Resolution log` section: date, actual, source-pull path, Brier, classification, note.
5. Move bet from `_active.md` to `_resolved.md` index.
6. Update `metrics/calibration-ledger.md` row: bet-id, owner, taste-type, Brier, classification, date.
7. Trigger substrate update: if HIT or PARTIAL, what substrate fact was confirmed? If MISS, what substrate assumption was wrong? Write the delta to the relevant substrate layer with attribution `verified`.
8. Log.

## Output

Updated bet file + calibration ledger row + substrate delta. No prose response.

## Gates

- **Substrate-update on close (CONSTITUTION 10):** the loop closes or it does not count. No bet resolution without substrate delta written.
- **Honest-loss discipline:** MISS classifications must include the wrong-assumption note. Pure "didn't work" is rejected.
- **Source-pull traceable:** actual value must reference its source query/file.

## Composes with

Reads from: bet-open output (the contract).
Writes for: calibration-keep (ledger row), substrate-curate (delta), workflow ship→learn.
Triggered by: bet expiration, manual close, kill-criterion fire.

## Refusal patterns

- Actual value with no source-pull → reject.
- MISS with no wrong-assumption note → reject.
- Resolving a bet that has not yet expired AND has no kill-criterion fire → require explicit override.

## Calibration

This skill IS the calibration mechanism. Self-correcting: if Brier scores get worse over time, the system surfaces it.

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

