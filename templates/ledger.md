---
period: <period-slug>
client: <project-slug>
last_updated: <YYYY-MM-DD>
---

# Goal ledger — <period>

The current period's open and resolved goals. New goals are appended; resolved goals stay in the file with their accuracy score.

| ID | Function | Owner | Hypothesis | Measurement contract | Window | Predicted P | Status | Resolution | Score |
|---|---|---|---|---|---|---|---|---|---|
| G-content-001 | content | <name> | <one-liner> | <baseline → target> | <window> | 0.65 | active | <pending> | — |
| G-demand-001 | demand-gen | <name> | <one-liner> | <baseline → target> | <window> | 0.55 | resolved | yes | 0.20 |
| G-pmm-001 | pmm | <name> | <one-liner> | <baseline → target> | <window> | 0.70 | resolved | no | 0.49 |

## Per-goal detail

For each goal, the full measurement contract lives at `measurement-contracts/<id>.md`. The ledger row above is the summary.

## Period rollup

- **Goals opened:** <N>
- **Goals resolved:** <N>
- **Average accuracy score:** <0.0-1.0>
- **Best taste-type:** <function>
- **Worst taste-type:** <function>

## Carry-forwards

- <Goal X> — paused; resume in <next period>.
- <Goal Y> — extended; new resolution date <date>.
