---
title: routines + docs manifest
agent: agent/routines-docs
date: 2026-05-08
scope: ship 8 end-to-end orchestrations and refresh the docs that hold them
---

# routines + docs manifest

Every file added or modified on the `agent/routines-docs` branch, with a one-sentence purpose. Closes the gap between substrate-as-skill-registry (61 skills, 13 single-purpose routines) and substrate-as-operating-system (named PMM / GTM cycles that compose the skills into operator-readable workflows).

## What this branch ships

- 8 end-to-end orchestrations under `routines/` that compose skills into named cycles (new client, quarter, launch, full-funnel, customer-conversation, AEO publish, competitor watch, expansion).
- A README rewrite that opens with the wedge in two paragraphs and adds a "Two ways to use Substrate" section near the top.
- An ORIGIN extension covering v1.1, v1.2, v1.3, v1.4 (the codex-grounded knowledge layer, portability + behavioral grounding, sprint 1 surfaces, and end-to-end orchestrations respectively).
- Updated routines/README.md catalog that splits orchestrations from single-purpose loops.
- A CONTRIBUTING addition naming the codex-grounding rule and the behavioral-signature requirement (Rule 9a).
- Version bump to 1.4.0.

## Routines added (orchestrations)

| Path | Cadence | Composes |
|---|---|---|
| `routines/new-client-onboarding-week-1.md` | One-time, day 1 to day 5 of a paid engagement | `consulting-poc` wrapping `icp-cut`, `frontline-contact`, `positioning-forge`, `status-quo-frame`, `dunford-value-frame`, `narrative-strategy`, `messaging-matrix`, `lp-ship` or `narrative-compose` or `win-loss-interview`, `eval-rubric`, `open-goal` |
| `routines/quarterly-pmm-cycle.md` | Quarterly, with mid-quarter checkpoint at week 6 | `refresh-knowledge`, `competitive-scout`, `icp-cut`, `open-goal`, `mental-models`, `score-goal`, `pmm-coaching`; wraps `signal-routine`, `frontline-contact-routine`, `narrative-drift-routine`, `aeo-publish-cycle` |
| `routines/launch-flow.md` | Per-launch, T-12w through T+12w holdout | `launch-plan`, `campaign-strategy`, `narrative-strategy`, `messaging-matrix`, `ad-creative-design`, `email-sequence-design`, `narrative-compose`, `lp-ship`, `pre-publish-check`, `score-goal` |
| `routines/full-funnel-audit.md` | Quarterly, week 1 of the quarter | `ad-diagnose`, `ad-attribution-honest`, `email-deliverability-audit`, `email-engagement-decay-watcher`, `activation-funnel-audit`, `retention-cohort-analysis`, `churn-diagnose`, `eval-rubric`, `open-goal` |
| `routines/customer-conversation-rhythm.md` | Continuous, with 30 / 60 / 90 cadence | `frontline-contact`, `win-loss-interview`, `tactical-empathy-discovery`, `signal-routine`, `refresh-knowledge`, `score-goal`, `churn-diagnose` |
| `routines/aeo-publish-cycle.md` | Monthly, with weekly snapshot sub-loop | `aeo-tune`, `aeo-relevance`, `aeo-manual-action`, `help-docs`, `pseo-framework`, `pre-publish-check`, `score-goal` |
| `routines/competitor-watch-cycle.md` | Weekly, with quarterly re-baseline | `competitive-scout`, `battle-card-driver`, `status-quo-frame`, `claim-verify`, `positioning-forge` |
| `routines/expansion-flywheel.md` | Monthly review, weekly trigger watcher | `expansion-trigger-detect`, `retention-cohort-analysis`, `nps-loop-design`, `outbound-sequence-design`, `churn-diagnose`, `frontline-contact`, `score-goal` |

Each orchestration declares cadence, owner, patterns grounded, contradictions aware, skills composed (with paths), inputs required, outputs produced, failure modes, calibration hooks. Body sections follow the same schema across all 8 files.

## Docs modified

| Path | Change |
|---|---|
| `README.md` | Comprehensive refresh. Opens with a 2-paragraph wedge (was 5 paragraphs of GTM-problem prose). Adds "Two ways to use Substrate" section near the top, with a table mapping the 8 orchestrations to cadence + output. Updates stats to 61 skills, 55 patterns, 14 contradictions, 15 surfaces, 8 orchestrations. Adds dedicated sections for consulting-poc, the public-private fork pattern, behavioral grounding (Gates 7 + 8), end-to-end routines, and substrate-on-substrate. Notes sprint 2 surfaces (analytics, social, support, stub-deepening) as expanding. |
| `ORIGIN.md` | Extended with v1.1, v1.2, v1.3, v1.4 sections. Each names what changed, why, what didn't. v1.4 highlights end-to-end orchestrations and the README rewedge. The forward-roadmap line names sprint 2 surfaces. |
| `routines/README.md` | Rewritten catalog. Two-section split: "End-to-end orchestrations" (the 8 new routines, table format with cadence + composes) and "Single-purpose routines" (the 15 loops the orchestrations wrap). Adds a closing section explaining why routines split into orchestrations + loops ("an orchestration calls skills and reads the data routines produce; a routine never calls a skill back"). |
| `CLAUDE.md` | Updated paragraph: now reflects 61 skills + 8 orchestrations, references rule 9a, mentions ORIGIN.md goes through v1.4. The "eight layers" section's Routines line now reads "single-purpose recurring loops + 8 end-to-end orchestrations." |
| `CONTRIBUTING.md` | Adds a "Contributing patterns" section explaining the codex-grounding rule (3+ operator citations per pattern), the behavioral-signature requirement under Rule 9a (every new pattern needs a Gate-7-checkable signature), and a "Contributing contradictions" + "Contributing routines" sub-section. Cleans up trailing typo. |
| `VERSION` | Bumped to 1.4.0 (sprint 1 + sprint 2 substantive enough to warrant the minor version). |
| `bin/substrate` | No code change needed; `--version` reads from `VERSION` dynamically. Verified the deprecation alias still works (FLYWHEEL_ROOT to SUBSTRATE_ROOT). |

## Files added

| Path | Purpose |
|---|---|
| `routines/new-client-onboarding-week-1.md` | Day-by-day Week 1 sequence for a paid engagement; composes `consulting-poc`. |
| `routines/quarterly-pmm-cycle.md` | PMM function as a closed quarterly loop with mid-quarter checkpoint. |
| `routines/launch-flow.md` | End-to-end launch as research-preview-and-cadence with post-launch holdout + Brier score. |
| `routines/full-funnel-audit.md` | Quarterly cross-surface diagnostic across paid + email + activation + retention + churn. |
| `routines/customer-conversation-rhythm.md` | 30 / 60 / 90 cadence on top of per-role weekly minimums. |
| `routines/aeo-publish-cycle.md` | Monthly AEO publish + measure cycle wrapping the weekly aeo-routine. |
| `routines/competitor-watch-cycle.md` | Weekly competitive surveillance with quarterly re-baseline. |
| `routines/expansion-flywheel.md` | Closed loop from retention's cohort read to expansion's revenue. |
| `_manifests/routines-docs.md` | This file. |

## Why orchestrations matter

v1.3 ended with 61 skills and 13 single-purpose routines. A new operator opening substrate could see the registry of skills and the registry of loops but had to assemble the cycle themselves. The skills list answers "what can I do?"; the loops list answers "what runs unattended?". Neither answers "what's a quarter's worth of PMM work?" or "how do I start a new client engagement?" The 8 orchestrations close that gap. Each composes 4-12 skills into a named cycle with a cadence, an owner, declared inputs / outputs, failure modes, and calibration hooks. They are how a working operator turns substrate from a tool into an operating system.

## Verified manually

- `bin/substrate --version` reports `substrate 1.4.0`.
- `bin/substrate --list` lists 61 wired skills (some still spec-only on the v1.1-era surfaces).
- All 8 new orchestration files load cleanly (frontmatter parses, no broken markdown).
- Cross-references between orchestrations and single-purpose loops resolve (every `routines/<slug>.md` referenced exists).
- Cross-references between orchestrations and skills resolve (every `skills/<slug>/SKILL.md` referenced exists).
- README.md "Two ways to use Substrate" table links resolve to the 8 new orchestration files.
- ORIGIN.md v1.1, v1.2, v1.3, v1.4 sections read in voice with the v0.1-v1.0 sections (kill-list, em-dash, throat-clearing rules applied).
- routines/README.md catalog reflects the 8 orchestrations + 15 single-purpose routines that exist on disk.

## Non-scope

- No skill changes (per scope: agents/skills work belongs to other branches).
- No knowledge layer changes (patterns + contradictions evolve through digest-ingest, not through a routines-docs PR).
- No PRINCIPLES.md changes (the existing rules cover what the orchestrations do; Rule 9a is the load-bearing addition and was shipped on `agent/enforcement`).
- No bin/lib changes.
- No INDEX.md changes (skills/README.md, knowledge/patterns/INDEX.md, knowledge/contradictions/INDEX.md left alone; those track skill/pattern/contradiction registry, not orchestration registry).
