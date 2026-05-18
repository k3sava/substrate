---
name: bet-open
description: Open a measurement-first bet. Rejects vague bets at intake. No bet ships without owner, revenue_lever, target_metric, data_chain, decision criteria, and resolution date.
version: 0.1
amplifies: PMM lead, growth lead, function owner
masters: Annie Duke (Thinking in Bets — calibrated probability), Philip Tetlock (Superforecasting — falsifiability), Daniel Kahneman (premortem), Sean Ellis (ICE → measurement), Lenny Rachitsky (bet-sized roadmaps), April Dunford (positioning hypothesis as bet), Hamel Husain + Shreya Shankar (LLM eval rigor → measurement design), Ravi Mehta (decision journals), Nassim Taleb (skin in the game / kill criterion), Will Larson (eng-eng-style RFC structure)
substrate_index_version: 2026-04-30
substrate_layers_required: [9, 10]  # 9=roadmap, 10=strategy
preflight_refusal: substrate-gap
---

# bet-open

## Purpose

Force every initiative to declare its bet shape before work begins. Vague initiatives are rejected at intake — the cost of saying no early is small, the cost of running an unfalsifiable bet is large.

## Inputs

- `--client <client>`
- `--title <one line>`: the bet headline
- `--owner <name>`: single human accountable. Not a team.
- `--lever <revenue_lever>`: what dollar this moves
- `--metric <target_metric>`: number + date + Amplitude event source (or other named source)
- `--baseline <value>`: current state with timestamp
- `--target <value>`: where we want to land
- `--window <days>`: time-to-resolution
- `--belief <one sentence>`: what we believe, falsifiable
- `--data-chain <path>`: file/query/dashboard that produces the metric. Required.
- `--kill-criterion <condition>`: when we close the bet early
- `--substrate-cited <list>`: substrate files that informed this bet

## Process

1. Validate: every required field present. If any missing, **reject** — don't auto-fill.
2. Validate metric: target_metric must include unit + window + source. "Lift conversion" is rejected; "homepage trial-signup CR from 2.3% to 3.2% within 21 days, source: Amplitude `trial_signup_completed` event filtered to homepage referrer" is accepted.
3. Validate substrate-cited: each path must exist in `clients/<client>/substrate/`. Bets without substrate reference are rejected.
4. Generate bet ID: `B-NNN-<slug>` (next sequential).
5. Write to `clients/<client>/bets/<bet-id>.md` with full frontmatter + sections: belief, why now, prior art, plan, kill criterion, resolution log (empty).
6. Append to `clients/<client>/bets/_active.md` index.
7. Schedule resolution check: bet's expires_on = today + window.
8. Log: bet opened, owner, target, window.

## Output

A bet file. No prose response. Operator reviews the file and approves or revises.

## Gates

- **Measurement-design rejection (CONSTITUTION 1):** no bet opens without measurement design.
- **Substrate-cited:** at least one substrate file referenced.
- **Single owner:** no shared ownership.
- **Kill criterion:** explicit, not implicit.

## Composes with

Reads from: substrate-curate's output.
Writes for: bet-resolve (uses the bet's measurement contract on close), calibration-keep (consumes the resolution).
Triggered by: signal→bet workflow human gate (operator: "approve this signal as a bet").

## Refusal patterns

- "We should improve X" — rejected. No metric.
- "Lift Y by ~10%" — rejected. No source, no window.
- "Owner: PMM team" — rejected. Single name.
- "Substrate: TBD" — rejected. Substrate must exist before bet opens.

## Calibration

Bet-open quality tracked via downstream: how many opened bets reach clean resolution vs need re-scoping vs go silent. Re-scoping rate above 30% means bet-open's intake bar is too low.

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

