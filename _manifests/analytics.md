---
title: analytics + attribution surface, agent/analytics manifest
status: shipped
last_updated: 2026-05-08
agent: agent/analytics
sprint: 1.3.0
---

# Analytics + attribution surface, agent/analytics manifest

Six skills, four patterns, two routines, three templates. The spine every other surface reads from. Retention, paid-ads, email, ABM, dashboards, and lift tests now share one ingest skill (`analytics-pull`), one taxonomy contract (events.yaml + `event-taxonomy-audit`), one metric tree (`metric-tree-design`), one attribution model (`attribution-model-design`), one lift-test designer (`lift-test-design`), and one dashboard generator (`dashboard-spec`).

Total runtime LOC: 5,032 across six bin scripts.
Total SKILL.md LOC: 609 across six SKILL.md files.
Total pattern LOC: ~370 across four pattern files.

## Skills shipped

| Skill | bin LOC | SKILL.md LOC | Purpose |
|---|---|---|---|
| `skills/analytics-pull` | 922 | 100 | Pull data from Amplitude / PostHog / Mixpanel / HubSpot / Stripe / Segment / GA4 into per-client substrate as schema-mapped CSVs. Mock-mode fallback when API keys absent; live placeholder ready for real wiring. |
| `skills/event-taxonomy-audit` | 1058 | 100 | Audit `events.yaml` against the per-source production stream. Five drift checks (declared-but-unfired, fired-but-undeclared, near-duplicate names, missing properties, naming-convention violations) plus ICP-cell-drift soft check. Outputs human MD + JSON + remediation CSV. |
| `skills/metric-tree-design` | 678 | 102 | Design north-star + supporting metric tree with ASCII tree art + YAML companion + audit checklist. Refuses with >4 inputs or >12 leaves (per `metric-tree-not-metric-stack`). Cites Reforge / Winters / Balfour / Sobers. |
| `skills/attribution-model-design` | 869 | 94 | Design the attribution model (8 candidates: last-touch / first-touch / linear / time-decay / position-based / markov-chain / incrementality-anchored / hybrid). Picks `no-decision-vs-named-competitor` contradiction position from channel mix. Outputs spec + measurement contract. |
| `skills/lift-test-design` | 835 | 112 | Design holdout / geo / synthetic-control / pre-post test with sample-size math, MDE, audience-holdout shape, randomization protocol, validity window. Six surfaces (paid-ads, email, retention, abm, content, onboarding) and six modes. Picks `short-feedback-vs-long-term-holdouts` contradiction position. Outputs design + measurement contract. |
| `skills/dashboard-spec` | 670 | 103 | Generate dashboard spec (YAML + markdown) from `metric-tree.yaml` + audience + decision context. Six audience templates (exec/growth/lifecycle/sales/support/all) + six decision frames + four cadences. Refuses on cadence-mismatch (panel cadence less frequent than dashboard cadence). Adapter notes for Amplitude / Looker / Metabase / Tableau / HubSpot. |

Every skill:
- Refuses on substrate gap (icp/positioning/sources.yaml/events.yaml as appropriate)
- Declares `patterns_grounded` and `contradictions_aware` in frontmatter
- Logs `produced_by: <skill>` on every output asset (Rule 9a behavioral grounding)
- Cites context paths inline; no `unverified` claims pass

## Patterns shipped

| Pattern | LOC | Convergence | Tier | Purpose |
|---|---|---|---|---|
| `knowledge/patterns/metric-tree-not-metric-stack.md` | 47 | 4 (Reforge faculty + Casey Winters + Brian Balfour + Rob Sobers) | A | Metrics organize as a tree, not a flat stack: north-star at root, 2-4 inputs as branches, supporting metrics, behavioral leaves. The team that cannot draw the tree on a whiteboard is operating on stack substrate. |
| `knowledge/patterns/event-taxonomy-as-product-knowledge.md` | 46 | 3 (Iris Vaknin + Yali Sassoon + Mike Kitchen) | A | Event schema is product knowledge, not marketing afterthought. The taxonomy is a contract; the auditor pattern enforces the contract. |
| `knowledge/patterns/goalpost-discipline-vs-metric-drift.md` | 44 | 3 (Patrick Campbell + Tomasz Tunguz + Frederick Reichheld) | A | Lock the measurement contract before the goal opens; mid-quarter changes are overrides with attribution. Without locking, every quarter's report is a reconstruction. |
| `knowledge/patterns/segment-of-one-vs-cohort-aggregate.md` | 46 | 3 (Casey Winters + Lenny Rachitsky + Avinash Kaushik) | A | Both views needed; cohort aggregate diagnoses shape, segment-of-one diagnoses mechanism. Skills must declare which layer they operate on. |

Citations are real: Vaknin's tracking-plan-as-deliverable talks, Sassoon's Snowplow body of work, Kitchen's "Tracking Plan as a First-Class Citizen" essays, Reforge growth-model curriculum, Winters retention writing, Balfour's growth-loops body, Sobers's marketing-attribution writing, Campbell's ProfitWell standardization research, Tunguz's metrics-covenant essays, Reichheld's NPS methodology, Rachitsky's Lenny's Newsletter interview corpus, Kaushik's "Web Analytics 2.0" (2010).

## Routines shipped

| Routine | LOC | Cadence | Purpose |
|---|---|---|---|
| `routines/analytics-monthly-refresh.md` | 88 | monthly, 2nd Tuesday | Refresh sources.yaml, run `analytics-pull`, run `event-taxonomy-audit`, validate metric-tree leaves still bind to live events, dashboard sanity check, goal ledger calibrations, segment-of-one spot check. Refuses to mark month complete if revenue-load-bearing source is in mock-fallback or if high-severity audit findings are not triaged. |
| `routines/lift-test-rhythm.md` | 116 | quarterly, week 2 of quarter | Lock the quarterly slate, run `lift-test-design` per surface, execute through validity window, mid-quarter pulse week 6, resolve every measurement contract on declared date, calibrate the attribution model. Refuses to extend a validity window without an explicit override. Picks `short-feedback-vs-long-term-holdouts` position per surface. |

## Templates shipped

| Template | LOC | Purpose |
|---|---|---|
| `templates/analytics-sources-example.yaml` | 169 | Starter `sources.yaml` shape: 7 source-systems, 10 channels, 2 cohorts, identity-resolution policy. (Pre-existing; documents `analytics-pull` schema contract.) |
| `templates/metric-tree-example.md` | 175 | Acme-anonymous (mid-market SaaS workflow-automation) metric tree: 1 north-star, 4 inputs, 8 supporting metrics, 5 behavioral leaves. ASCII tree art, full SQL example for north-star, validity windows, override log shape. |
| `templates/attribution-model-example.md` | 124 | Acme-anonymous attribution spec: hybrid model (multi-touch + quarterly incrementality calibration), all 8 model comparison table, channel inventory, override log shape, decision-rights table. |

## Test artifacts

End-to-end smoke tests run during build (test client `_test_analytics`, removed before commit). All six skills produced their declared output contracts:

- `analytics-pull`: 7 source CSVs + manifests + run log (19,658 mock events across 7 sources, 0% taxonomy coverage as expected because mock event vocab differs from declared taxonomy).
- `event-taxonomy-audit`: human MD (1058-line runtime exercised on 19,658 events, 8 declared, 62 fired distinct, surfacing 8 declared-but-unfired + 62 fired-but-undeclared + 4 near-duplicate-name pairs + 10 naming-violations).
- `metric-tree-design`: tree with 4 inputs / 5 leaves (under the 4-max / 12-max limits).
- `attribution-model-design`: hybrid model + measurement contract under `goals/measurement-contracts/` with `no-decision-vs-named-competitor` position picked from balanced channel mix.
- `lift-test-design`: email + audience-holdout test design with sample-size math + measurement contract.
- `dashboard-spec`: 5-panel exec / retention-watch dashboard YAML + MD with drill-paths, refused on cadence-mismatch when attempted at weekly cadence (correct behavior).

## What this surface unblocks

- **Retention skills** (`retention-cohort-analysis`, `activation-funnel-audit`, `churn-diagnose`, `expansion-trigger-detect`) read CSVs from `analytics-pull` and metric-tree leaves from `metric-tree-design`.
- **Paid-ads skills** (`ad-spend-allocate`, `ad-incrementality-test`, `ad-fatigue-monitor`) read channel inventory from sources.yaml and the attribution-model spec.
- **Email skills** (`email-cohort-trigger`, `email-sequence-design`, `email-deliverability-audit`) read events.yaml + the audit findings (decommission-candidate events get dropped from cohort triggers).
- **ABM skills** (`abm-account-prioritize`, `account-pursuit-rhythm`) read the metric tree leaves (engagement-decay flag) and the channel inventory (ABM channel is one of the inventory entries).
- **Goal ledger** receives measurement contracts from `attribution-model-design` and `lift-test-design`; the contracts open with locked measurement design + revenue lever + kill criterion + resolution date per `goalpost-discipline-vs-metric-drift`.

## Files touched

```
knowledge/patterns/event-taxonomy-as-product-knowledge.md   NEW
knowledge/patterns/goalpost-discipline-vs-metric-drift.md   NEW
knowledge/patterns/metric-tree-not-metric-stack.md          NEW
knowledge/patterns/segment-of-one-vs-cohort-aggregate.md    NEW
routines/analytics-monthly-refresh.md                       NEW
routines/lift-test-rhythm.md                                NEW
skills/analytics-pull/SKILL.md                              NEW
skills/analytics-pull/bin/analytics-pull                    NEW (922 LOC)
skills/attribution-model-design/SKILL.md                    NEW
skills/attribution-model-design/bin/attribution-model-design NEW (869 LOC)
skills/dashboard-spec/SKILL.md                              NEW
skills/dashboard-spec/bin/dashboard-spec                    NEW (670 LOC)
skills/event-taxonomy-audit/SKILL.md                        NEW
skills/event-taxonomy-audit/bin/event-taxonomy-audit        NEW (1058 LOC)
skills/lift-test-design/SKILL.md                            NEW
skills/lift-test-design/bin/lift-test-design                NEW (835 LOC)
skills/metric-tree-design/SKILL.md                          NEW
skills/metric-tree-design/bin/metric-tree-design            NEW (678 LOC)
templates/analytics-sources-example.yaml                    NEW
templates/attribution-model-example.md                      NEW
templates/metric-tree-example.md                            NEW
_manifests/analytics.md                                     this file
```

No files outside scope touched. README.md, ORIGIN.md, INDEX files, signatures library (bin/lib/), VERSION, and skills/README.md are intentionally unmodified.
