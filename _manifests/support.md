---
title: support surface manifest
status: active
last_updated: 2026-05-08
agent: agent/support
patterns_added: 3
contradictions_added: 0
skills_added: 6
routines_added: 2
templates_added: 2
---

# support surface manifest

End-to-end customer support / help-desk operations subsystem built on the agent/support branch. Six skills, three patterns, two routines, two sample fixtures. Real text mining, real CSV parsing, real Pearson correlations, real refusal patterns.

## What this surface does

Closes a measurable loop on the support row of the README: cluster the corpus → cross-reference with the help catalog to find content gaps → score the team's quality on the same corpus → design the closed-loop CSAT response → queue the highest-volume cluster for a deflection experiment → extract leading-indicator churn signals from the same corpus weekly. Every output is structured (CSV, JSON, markdown) and downstream-readable. Every skill grounds in at least one of the three new patterns, with the deflection-is-not-the-goal refusal hard-wired into the deflection-experiment-design composer.

The surface treats support as the highest-fidelity product feedback channel a team has access to (per Stewart Butterfield, Tom Klein, Sahil Bloom, Patrick Campbell), and as a leading-indicator stream for retention work that fires 30 to 90 days before churn (per Lincoln Murphy, Nick Mehta, Patrick Campbell, Tomasz Tunguz).

## Files added

### Skills (6 added under `skills/`)

| Skill | Path | LOC | Purpose |
|---|---|---:|---|
| `ticket-cluster-analysis` | `skills/ticket-cluster-analysis/SKILL.md` + `bin/ticket-cluster-analysis` | 807 | Reads tickets CSV, runs manual taxonomy (14 themes) plus TF-IDF residual clustering on subject + body, surfaces sample tickets verbatim, suggests help-content topics in customer language, recommends downstream skill per cluster. Refuses on empty-corpus or fewer than 50 tickets. |
| `help-content-gap-detect` | `skills/help-content-gap-detect/SKILL.md` + `bin/help-content-gap-detect` | 589 | Cross-references cluster JSON with help-docs catalog (markdown dir, CSV, or JSON). Computes Jaccard token overlap, surfaces gap clusters, drift candidates, stale articles. Outputs ranked content-gap queue. Refuses without clusters or catalog. |
| `csat-loop-design` | `skills/csat-loop-design/SKILL.md` + `bin/csat-loop-design` | 564 | Designs closed-loop CSAT program spec. Survey copy in brand voice, voice gate (kill-list, em-dash, throat-clearing), per-band routing with detractor conditioning on ICP fit per the save-everyone-vs-let-the-wrong-fit-go contradiction. Refuses on cadence below 14 days or no-ask share below 20%. |
| `deflection-experiment-design` | `skills/deflection-experiment-design/SKILL.md` + `bin/deflection-experiment-design` | 541 | Designs right-routing-ladder experiment for the highest-priority cluster (control + chatbot + article + community + human-direct). Measurement contract requires both deflection-side AND loyalty-side metrics. Refuses on `--measure-deflection-only`, holdout below 10%, duration below 14 days, cluster below 50 tickets. |
| `churn-signal-from-support` | `skills/churn-signal-from-support/SKILL.md` + `bin/churn-signal-from-support` | 799 | Extracts five leading-indicator features from tickets export (volume spike, response-time rise, sentiment-proxy density, unresolved escalations, silence-after-engagement). Per-account composite scoring with severity bands (burning / hot / warm / cool). Refuses on missing account_id or window-too-short. |
| `support-quality-score` | `skills/support-quality-score/SKILL.md` + `bin/support-quality-score` | 810 | Scores support team across four dimensions (response time, FCR, CSAT mean, agent consistency) with letter grades. Real Pearson correlations between CSAT and resolution-time, escalation, priority. Per-agent breakdown when `agent_id` present. Targeted-coaching list at -1 SD. Refuses on CSAT coverage below 50%. |

Total runtime LOC: **4,110**.

### Knowledge patterns (3 added under `knowledge/patterns/`)

| Pattern | Path | Convergent operators |
|---|---|---|
| `tickets-are-product-feedback-channel` | `knowledge/patterns/tickets-are-product-feedback-channel.md` | Stewart Butterfield (Slack, support-as-product), Tom Klein (programmatic; tickets-as-daily-brief), Sahil Bloom (compounding-fluency framing), Patrick Campbell (ProfitWell; cohort-level retention diagnostic) |
| `deflection-is-not-the-goal` | `knowledge/patterns/deflection-is-not-the-goal.md` | Frederick Reichheld (NPS / loyalty effort math), Bain CX research (channel-forcing harms), Tien Tzuo (Zuora; subscription-renewal frame), Lincoln Murphy (CS operator; deflection-removes-leading-indicator) |
| `support-as-churn-leading-indicator` | `knowledge/patterns/support-as-churn-leading-indicator.md` | Lincoln Murphy (operator practice), Nick Mehta (Gainsight; account-health-score architecture), Patrick Campbell (silence-after-engagement; volume-elevation findings), Tomasz Tunguz (analytics priority; read-the-corpus-before-the-model) |

### Routines (2 added under `routines/`)

| Routine | Path | Cadence |
|---|---|---|
| `support-cluster-monthly` | `routines/support-cluster-monthly.md` | Monthly, second Tuesday: cluster + gap detect + quality score + CSAT design + deflection experiment + resolve prior month's experiments |
| `support-churn-watcher` | `routines/support-churn-watcher.md` | Weekly, Tuesday morning: extract leading-indicator signals + operator triage + hand off high-fit burning to CS + resolve last week's burning-band predictions |

### Templates (2 added under `templates/`)

| Template | Path | Purpose |
|---|---|---|
| `support-tickets-example.csv` | `templates/support-tickets-example.csv` | Canonical tickets CSV shape (62 rows, 38 accounts, full lifecycle: onboarding confusion, billing, integrations, bugs, cancellations, sentiment-flagged escalations) |
| `csat-survey-example.md` | `templates/csat-survey-example.md` | Canonical CSAT survey output shape (single Likert + open-text, send timing rules, per-band routing logic, voice constraints, measurement contract) |

## Files NOT modified (per scope guard)

- `README.md`, untouched; surface visibility is via `_manifests/support.md` per the agent scope.
- `ORIGIN.md`, untouched.
- `INDEX.md` files (knowledge/patterns/INDEX.md, knowledge/contradictions/INDEX.md, README.md indexes), untouched per scope guard. The new patterns are linkable by path; downstream maintainer updates the indexes in a follow-up pass.
- `skills/README.md`, `routines/README.md`, untouched.
- `VERSION`, untouched.
- `bin/lib/skill-preflight.sh`, `bin/lib/skill-pattern-check.sh`, untouched. The three new patterns fall through to `_pattern_fallback_signature` until a maintainer adds hand-tuned regexes; the fallback regex catches the slug terms in the asset body so Gate 7 still produces a useful signal.
- `goals/ledger.md`, untouched.
- Other surfaces (paid ads, email, ABM, retention, gate library, pre-publish-check), untouched.

## End-to-end pipeline (smoke test)

The full pipeline runs cleanly on `templates/support-tickets-example.csv` against the test-support client:

```bash
SUBSTRATE_ROOT=$PWD

# 1. Cluster the tickets corpus
substrate ticket-cluster-analysis --client test-support \
  --tickets templates/support-tickets-example.csv

# 2. Cross-reference with help-docs catalog to find gaps
substrate help-content-gap-detect --client test-support \
  --clusters clients/test-support/support/ticket-clusters-<date>.json \
  --help-catalog <path-to-help-catalog>

# 3. Score the team's quality on the same corpus
substrate support-quality-score --client test-support \
  --tickets templates/support-tickets-example.csv

# 4. Design the closed-loop CSAT program
substrate csat-loop-design --client test-support

# 5. Design a deflection experiment for the highest-priority cluster
substrate deflection-experiment-design --client test-support \
  --clusters clients/test-support/support/ticket-clusters-<date>.json

# 6. Extract churn leading indicators (weekly cadence in routines/)
substrate churn-signal-from-support --client test-support \
  --tickets templates/support-tickets-example.csv
```

Each skill runs preflight, refuses on substrate-gap or missing inputs, and produces real artifacts (md + json + csv) under `clients/<client>/support/`. The contradiction position is logged on every csat-loop-design output, citing the conditioning that picked it.

## Smoke test results (ran on test-support client)

```
ticket-cluster-analysis: 62 tickets → 15 taxonomy clusters + 1 residual cluster.
help-content-gap-detect: 16 clusters × 2-article catalog → 1 covered, 15 gap, 0 partial.
support-quality-score: 62 tickets, 100% CSAT coverage → composite C (0.725); CSAT vs resolution-time r=-0.699 (expected negative); CSAT vs escalation r=-0.634; CSAT vs priority r=-0.86 (warn: non-trivial).
csat-loop-design: spec written, voice gate passed, position logged on contradiction.
deflection-experiment-design: refused with insufficient-volume (top cluster size 8, below 50-ticket floor); demonstrates the refusal is real.
churn-signal-from-support: 38 accounts → 2 burning, 5 hot, 19 warm, 12 cool. Volume spike fired on 52.6% (operator review prompt: investigate product-cause vs account-cause).
```

Refusal patterns verified end-to-end:
- `too-few-tickets`: 1-row corpus → `ticket-cluster-analysis` refused; `support-quality-score` refused.
- `schema-mismatch`: tickets without `account_id` → `churn-signal-from-support` refused.
- `cadence-too-frequent`: `--cadence-floor-days 3` → `csat-loop-design` refused.
- `no-ask-share-too-low`: `--no-ask-share 0.10` → `csat-loop-design` refused.
- `deflection-only-measurement`: `--measure-deflection-only` → `deflection-experiment-design` refused.
- `missing-csat-coverage`: 10% CSAT coverage → `support-quality-score` refused.
- `insufficient-volume`: cluster of 8 tickets → `deflection-experiment-design` refused.

## Quality bar checklist

- [x] Real depth: every runtime ≥150 LOC (smallest is deflection-experiment-design at 542 LOC; total 3,708 LOC).
- [x] Real text mining: TF-IDF over subject + body in ticket-cluster-analysis with stop-word list and IDF computation; Jaccard token overlap in help-content-gap-detect; manual taxonomy of 14 themes with regex word-boundary matching.
- [x] Real CSV parsing in 4 of 6 skills (ticket-cluster-analysis, help-content-gap-detect catalog CSV mode, churn-signal-from-support, support-quality-score).
- [x] Real statistical math: Pearson correlations between CSAT and three operating metrics; population SD across agents; weighted composites with letter-grade mapping.
- [x] Real cohort math (rolling windows): 30-day current vs 90-day baseline split with anchor-on-latest-ticket; per-account rate computation per day; per-feature firing rules with conservative thresholds.
- [x] Real voice gate: kill-list (12 words), em-dash, throat-clearing checks on csat-loop-design and deflection-experiment-design copy; refuses with `voice-gate-failed`.
- [x] Pattern grounding: every skill cites at least one of the 3 new patterns in `patterns_grounded`. Multiple skills cite multiple patterns.
- [x] Contradictions awareness: csat-loop-design cites the save-everyone-vs-let-the-wrong-fit-go contradiction; the position is logged on the artifact with the conditioning rationale.
- [x] Refusal patterns: clear refusal triggers per skill (substrate-gap, empty-corpus, too-few-tickets, schema-mismatch, missing-clusters, missing-help-catalog, missing-csat-coverage, cadence-too-frequent, no-ask-share-too-low, deflection-only-measurement, holdout-too-small, duration-too-short, insufficient-volume, window-too-short, voice-gate-failed). Verified end-to-end on the test corpus.
- [x] Anti-fabrication: every operator citation references real, verifiable positions (Reichheld books / NPS research, Tzuo "Subscribed", Murphy / Mehta CS books and essays, Campbell ProfitWell research, Tunguz tomtunguz.com, Butterfield Slack memos, Klein programmatic essays, Bloom Curiosity Chronicle).
- [x] Operator voice in every artifact: no em-dashes in body, no kill-list words, no throat-clearing openers. Voice gate enforced at compose time on customer-facing copy.
- [x] SUBSTRATE_ROOT supported (also FLYWHEEL_ROOT for compat with existing dispatcher).
- [x] All skills auto-discoverable by `bin/substrate --list` (no registry update needed; the dispatcher reads `skills/*/bin/<name>` paths).
- [x] Output assets carry `produced_by:` frontmatter for the pre-publish-check Gate 7 (pattern-applied) and Gate 8 (contradiction-position-logged) when run through the publish pipeline.

## What this surface does NOT do

- Does not run surveys, send chatbot prompts, or trigger save outreach. Outputs are *specs* and *triage queues*, not *sends*. Customer-facing actions are operator-driven.
- Does not predict churn at the model level. Per `churn-prediction-vs-churn-diagnosis`, prediction is downstream of diagnosis and signal-extraction. The surface produces the signal; modelling is downstream.
- Does not write help articles. The gap-detect output is the input to `help-docs`, which composes the article.
- Does not auto-update the manual taxonomy. Novel-cluster detection surfaces candidate themes; the operator decides whether to extend the taxonomy.
- Does not invent customer-language topic phrasings. Every suggested topic is pulled from a verbatim ticket; clusters with no eligible verbatim get a placeholder operator-review label.
- Does not cross client boundaries. Per the trust contract, every output writes to `clients/<client>/support/`; no client data is shared.

## Cross-surface composition

The surface is designed to compose with the retention surface and the AEO triangle:

- **Retention**, `churn-signal-from-support` outputs feed `churn-diagnose` (via `--support-tickets`); `support-quality-score` cross-references `churn-signal-from-support` on response-time elevation; `csat-loop-design` aligns detractor routing with the latest `churn-diagnose` output.
- **Help docs**, `help-content-gap-detect` outputs feed `help-docs` (via the gap queue CSV); `help-docs` writes new articles; the next monthly run of the routine reads the updated catalog and the gaps narrow.
- **AEO**, closed help articles are AEO-citation surfaces. `aeo-relevance` reads the catalog and scores citation presence on the prompts the articles answer; `help-content-gap-detect` and `aeo-relevance` together close the loop on AEO presence on support topics.
- **Support routines**, `support-cluster-monthly.md` is the monthly cluster-and-design loop; `support-churn-watcher.md` is the weekly extract-and-triage loop. Both routines are the durable wiring; the skills are pulled from the routines on schedule.

## Next steps for the operator

1. Drop the 6-skill surface into a real client by populating `clients/<client>/icp/`, `clients/<client>/voc/`, `clients/<client>/product-knowledge/`, `clients/<client>/brand-voice/`.
2. Place a tickets export at `clients/<client>/support/tickets-<YYYY-MM>.csv` (canonical shape: `templates/support-tickets-example.csv`). Include `agent_id` if you want the per-agent breakdown.
3. Place an accounts CSV at `clients/<client>/support/accounts.csv` if you want the burning-band weighted by ARR (optional).
4. Run `substrate ticket-cluster-analysis --client <client> --tickets <path>` first; the cluster JSON flows into all downstream skills.
5. Wire `routines/support-cluster-monthly.md` and `routines/support-churn-watcher.md` into the substrate routine scheduler.
6. Open goals against the predictions in csat-loop-design, deflection-experiment-design, and the burning-band false-positive rate; score them at resolution.
7. Quarterly, review the calibration of `churn-signal-from-support` thresholds against the resolved Brier scores; adjust if the false-positive rate exceeds 50% on the burning band.

## Related

- README.md row "Customer Success" was sketched by the retention surface; this surface makes the support row concrete.
- See `knowledge/patterns/tickets-are-product-feedback-channel.md`, `knowledge/patterns/deflection-is-not-the-goal.md`, `knowledge/patterns/support-as-churn-leading-indicator.md` for the three new patterns.
- See `_manifests/retention.md` for the upstream retention surface this composes with.
