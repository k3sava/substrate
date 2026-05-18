---
title: retention surface manifest
status: active
last_updated: 2026-05-08
agent: agent/retention
patterns_added: 4
contradictions_added: 1
skills_added: 6
routines_added: 2
templates_added: 3
---

# retention surface manifest

End-to-end retention subsystem built on the agent/retention branch. Six skills, four patterns, one contradiction, two routines, three sample data fixtures. Real cohort math; no prompt-emit stubs.

## What this surface does

Closes a measurable loop on the customer-success row of the README: activation diagnosis → cohort retention analysis → churn diagnosis → expansion trigger detection → win-back sequence design → NPS closed-loop program. Every output is structured (CSV, JSON, markdown) and downstream-readable. The save-vs-let-go contradiction is conditioned per-cohort, not applied globally.

## Files added

### Skills (6 added under `skills/`)

| Skill | Path | LOC | Purpose |
|---|---|---:|---|
| `activation-funnel-audit` | `skills/activation-funnel-audit/SKILL.md` + `bin/activation-funnel-audit` | 633 | Diagnoses signup → first-value → retained-week-N from real events; tests candidate value events for retention-curve divergence; names the activation event or refuses with `no-activation-candidate`. |
| `retention-cohort-analysis` | `skills/retention-cohort-analysis/SKILL.md` + `bin/retention-cohort-analysis` | 688 | Computes cohort retention curves (week or month grain), splits by activation status, runs slope-change detection (1.5 SD against trailing 4-cohort baseline). Writes md + csv + json. |
| `churn-diagnose` | `skills/churn-diagnose/SKILL.md` + `bin/churn-diagnose` | 701 | Surfaces ranked churn drivers from a churned-accounts CSV scored on coverage × addressability; conditions save-vs-let-go recommendation on ICP fit per the contradiction. Writes md + json + drivers csv. |
| `expansion-trigger-detect` | `skills/expansion-trigger-detect/SKILL.md` + `bin/expansion-trigger-detect` | 582 | Scores accounts on adoption breadth × value-event density × growth-rate × threshold-proximity (tenure NOT primary axis). Bands: cold/warm/hot/burning. Writes md + json + csv. |
| `win-back-sequence` | `skills/win-back-sequence/SKILL.md` + `bin/win-back-sequence` | 619 | Designs per-band win-back sequences from a churn-diagnose output; reads contradiction position per band; enforces voice gate; writes measurement contract. Refuses without diagnosis. |
| `nps-loop-design` | `skills/nps-loop-design/SKILL.md` + `bin/nps-loop-design` | 467 | Closed-loop NPS program spec with detractor routing conditioned on ICP fit (4 sub-tracks); promoter no-ask branch required; 60-day cadence floor; measurement contract. |

Total runtime LOC: **3,690**.

### Knowledge patterns (4 added under `knowledge/patterns/`)

| Pattern | Path | Convergent operators |
|---|---|---|
| `aha-moment-defines-activation` | `knowledge/patterns/aha-moment-defines-activation.md` | Casey Winters, Lenny Rachitsky, Andrew Chen, Brian Balfour |
| `retention-cohort-curves-over-blended-rates` | `knowledge/patterns/retention-cohort-curves-over-blended-rates.md` | Casey Winters, Reforge faculty, Mike Maples Jr., Tomasz Tunguz |
| `behavioral-expansion-signals-beat-tenure` | `knowledge/patterns/behavioral-expansion-signals-beat-tenure.md` | Bridget Gleason, Tomasz Tunguz, Patrick Campbell |
| `churn-prediction-vs-churn-diagnosis` | `knowledge/patterns/churn-prediction-vs-churn-diagnosis.md` | Tomasz Tunguz, Patrick Campbell, Frederick Reichheld |

### Knowledge contradictions (1 added under `knowledge/contradictions/`)

| Contradiction | Path | Positions |
|---|---|---|
| `save-everyone-vs-let-the-wrong-fit-go` | `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md` | Murphy/Mehta (save) vs Reichheld/Elliott-McCrea (let go), conditioned on ICP fit, time-in-product, expansion potential |

### Routines (2 added under `routines/`)

| Routine | Path | Cadence |
|---|---|---|
| `retention-monthly` | `routines/retention-monthly.md` | Monthly, first Tuesday, full activation + cohort + diagnosis + sequence + NPS-resolve loop |
| `expansion-watcher` | `routines/expansion-watcher.md` | Weekly, Tuesday, refresh expansion trigger queue + resolve prior-week burning/hot triggers |

### Templates / sample data fixtures (3 added under `templates/`)

| Template | Path | Purpose |
|---|---|---|
| `events-export-example.csv` | `templates/events-export-example.csv` | Canonical events CSV shape (87 rows, 12 users, full lifecycle: signup → onboarding → activation → upgrade → seats added) |
| `churned-accounts-example.csv` | `templates/churned-accounts-example.csv` | Canonical churned-accounts CSV shape (20 rows, mixed ICP fit, multiple churn drivers, NPS scores, support ticket counts) |
| `cohort-table-example.md` | `templates/cohort-table-example.md` | Canonical cohort retention table output shape (8 cohorts × 8 weeks + slope-change detection narrative) |

## Files modified

| File | Change |
|---|---|
| `knowledge/patterns/INDEX.md` | Added 4 new tier-A patterns to the table; bumped tier-A count from 20 to 24; added customer-success domain row to coverage table |
| `knowledge/contradictions/INDEX.md` | Added save-everyone-vs-let-the-wrong-fit-go to the ledger |
| `skills/README.md` | Added "Retention / customer success / lifecycle" surface section with 6 new skills |

## Files NOT modified (per scope guard)

- `README.md`, left untouched; surface visibility is via `_manifests/retention.md` per the agent scope.
- `goals/ledger.md`, not touched.
- Other surfaces (paid ads, email, ABM, gate library, pre-publish-check), not touched.
- `bin/lib/skill-preflight.sh`, not touched; new skills have their own preflight functions for retention-specific checks (events CSV format, ICP layer, etc.) and use FLYWHEEL_ROOT / SUBSTRATE_ROOT env compatibly.

## End-to-end pipeline (smoke test)

The full pipeline runs cleanly on the sample data:

```bash
FLYWHEEL_ROOT=$PWD SUBSTRATE_ROOT=$PWD

# 1. Diagnose churn (writes diagnosis json)
substrate churn-diagnose --client <client> \
  --churned templates/churned-accounts-example.csv

# 2. Design per-band win-back sequences (reads diagnosis json)
substrate win-back-sequence --client <client> \
  --diagnosis clients/<client>/retention/churn-diagnosis-<date>.json

# 3. Score accounts for expansion (reads events csv)
substrate expansion-trigger-detect --client <client> \
  --events templates/events-export-example.csv

# 4. Compute cohort retention (reads events csv)
substrate retention-cohort-analysis --client <client> \
  --events templates/events-export-example.csv

# 5. Audit activation funnel (reads events csv)
substrate activation-funnel-audit --client <client> \
  --events templates/events-export-example.csv

# 6. Design NPS program
substrate nps-loop-design --client <client>
```

Each skill runs preflight, refuses on substrate-gap (with `--strict-substrate`) or warns and proceeds. Each skill produces real artifacts (md + json + csv) under `clients/<client>/retention/`. The contradiction position is logged on every win-back-sequence and nps-loop-design output, citing the conditioning that picked it.

## Quality bar checklist

- [x] Real depth: every runtime ≥150 LOC (smallest is nps-loop-design at 467 LOC; total 3,690 LOC).
- [x] Real CSV parsing in 4 of 6 skills (activation-funnel-audit, retention-cohort-analysis, churn-diagnose, expansion-trigger-detect).
- [x] Real cohort math: 7-day-bucket retention windows, population SD, z-score slope-change detection.
- [x] Real driver ranking: coverage × addressability score; per-band breakdown; ICP-fit conditioning.
- [x] Real funnel computation: signup → onboarding → activation → week-1 active → week-N retained, with step-to-step + signup-to-step conversion + segment dropoff.
- [x] Real expansion scoring: 4 weighted components, banded output, threshold-proximity per pricing tier, recent upgrade detection.
- [x] Real voice gate: kill-list (12 words), em-dash, throat-clearing checks on win-back and nps copy.
- [x] Pattern grounding: every skill cites ≥1 pattern in `patterns_grounded`.
- [x] Contradictions awareness: 2 skills cite the new contradiction in `contradictions_aware`.
- [x] Refusal patterns: clear refusal triggers (substrate-gap, missing-events-export, no-activation-candidate, missing-diagnosis, missing-icp, cadence-too-frequent, discount-without-evidence, low-confidence).
- [x] Anti-fabrication: every operator citation references real, verifiable positions (Reichheld books, Tunguz blog series, Reforge curriculum, Murphy / Mehta books, Campbell ProfitWell research, Winters Reforge posts).
- [x] Operator voice in every artifact: no em-dashes, no kill-list words.
- [x] SUBSTRATE_ROOT supported (also FLYWHEEL_ROOT for compat with existing dispatcher).
- [x] All skills auto-discovered by `bin/substrate --list`.

## What this surface does NOT do

- Does not send emails, surveys, or in-product nudges. Outputs are *specs*, not *sends*.
- Does not predict future churn. Per the contradiction, prediction is downstream of diagnosis.
- Does not auto-update other surfaces. Cross-surface composition is operator-driven (e.g., taking expansion-trigger-detect's CSV into HubSpot is a manual hand-off; activation-funnel-audit's recommendations into product team is a manual hand-off).
- Does not invent ICP, positioning, or VoC. Refuses without these layers.

## Next steps for the operator

1. Drop the 6-skill surface into a real client by populating `clients/<client>/icp/`, `clients/<client>/positioning/`, `clients/<client>/voc/`, `clients/<client>/brand-voice/`, `clients/<client>/product-knowledge/`.
2. Place an events export at `clients/<client>/events/exports/<YYYY-MM>.csv` and a churned-accounts CSV at `clients/<client>/retention/churned-accounts-<YYYY-MM>.csv`.
3. Run `substrate activation-funnel-audit --client <client> --events <path>` first; the named activation event flows into all downstream skills.
4. Wire `routines/retention-monthly.md` and `routines/expansion-watcher.md` into the substrate routine scheduler.
5. Open goals against the predictions in win-back-sequence and nps-loop-design measurement contracts, score them at resolution.

## Related

- README.md row "Customer Success" was previously aspirational; this surface makes it concrete.
- See `knowledge/patterns/INDEX.md` for the four new patterns added to the tier-A list.
- See `knowledge/contradictions/INDEX.md` for the new contradiction added to the ledger.
