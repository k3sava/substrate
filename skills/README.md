---
title: skills
status: active
last_updated: 2026-05-18
version: 1.6
---

# Skills

Skills are portable execution modules. Each skill accepts context as input at runtime; no client data is hardcoded. Each skill grounds in at least one codex pattern and declares contradiction-awareness where relevant (per `PRINCIPLES.md` rule 9).

## Skill registry

### Discovery and customer voice

| Skill | What it does |
|---|---|
| `frontline-contact` | Books, logs, harvests fresh customer contact into voc layer |
| `win-loss-interview` | Structured win/loss with coded objections, decision drivers, alternative considered |
| `tactical-empathy-discovery` | Voss-pattern discovery with mirrors, labels, accusation audit |

### Strategy and narrative

| Skill | What it does |
|---|---|
| `narrative-strategy` | Story-as-strategy: name the change, the stakes, the new game, the proof |
| `positioning-forge` | Positions a product against alternatives (named + status quo) |
| `dunford-value-frame` | Value-framing pass per April Dunford |
| `status-quo-frame` | Frames no-decision / status-quo as the dominant alternative |
| `messaging-matrix` | Persona × pain × value × proof × call matrix |
| `icp-cut` | ICP definition and cut |

### Agents and orchestration

| Skill | What it does |
|---|---|
| `agent-jtbd-map` | Maps each agent 1:1 to a JTBD with named human checkpoints |
| `capability-pin` | Pins skills to capability classes, not model versions; rebaselines quarterly |

### Content production

| Skill | What it does |
|---|---|
| `narrative-compose` | Generates copy artifacts from the narrative spine |
| `case-study-compose` | Composes a procurement-defensible case study from customer transcripts plus a named outcome; pins the verbatim quote; composes claim-verify and voice-enforce on the output |
| `founder-voice-substrate` | Reads a founder's public corpus, computes cadence stats, extracts reusable narrative beats, derives the kill-list from corpus absence, emits the substrate file voice-enforce reads |
| `lp-ship` | Lands a single LP with measurement instrumentation |
| `lp-cro-rubric` | Binary CRO rubric audit; proposes test variants |
| `humanizer` | Applies voice rules to AI-generated drafts |
| `pseo-framework` | Programmatic SEO at scale, gated for substrate quality |
| `help-docs` | Help articles as AEO-grade citation surfaces |
| `design-thinking-content` | Empathise→define→ideate→prototype→test for content |
| `design-principles` | Audits visual surfaces against a written principles ledger |

### Evaluation and gating

| Skill | What it does |
|---|---|
| `pre-publish-check` | The publish gate; refuses bad input before ship |
| `voice-enforce` | Voice rules enforcement |
| `claim-verify` | Verifies claims against substrate citation paths |
| `allowed-claims-register` | Composes the procurement-defensible claims register from the client's public surfaces; flags procurement-failure claims; the artifact claim-verify and pre-publish-check read against |
| `audience-test` | Synthetic-audience testing on draft artifacts |
| `eval-rubric` | Binary, single-judge, dataset-emitting evaluations |

### Goals and measurement

| Skill | What it does |
|---|---|
| `open-goal` | Opens a goal with measurement contract + calibrated prediction |
| `score-goal` | Scores a goal at resolution; updates calibration history |
| `mental-models` | Pre-decision audit using a curated mental-models library |

### AEO triangle

| Skill | What it does |
|---|---|
| `aeo-tune` | Presence layer of the AEO triangle (owned-domain) |
| `aeo-relevance` | Relevance layer (right citation, right framing) |
| `aeo-manual-action` | Manual-action / propagation layer (off-domain mention density) |

### Competitive

| Skill | What it does |
|---|---|
| `competitive-scout` | Tracks named-vendor competitive landscape |

### Paid ads / performance

| Skill | What it does |
|---|---|
| `ad-diagnose` | Audits an ad-account export for waste, fatigue, ICP mismatch, positioning drift; writes structured diagnostic |
| `ad-creative-design` | Channel-specific creative briefs grounded in canonical positioning + buyer-state cohort + frame |
| `ad-spend-allocate` | Allocates budget across channels with falsifiable predictions; emits one measurement contract per allocation |
| `ad-fatigue-monitor` | Weekly scan of recent diagnostics; surfaces new / persistent / recovered creatives; primes refresh-brief queue |
| `ad-attribution-honest` | Defensive gate; refuses claims of channel performance without attribution model + window + blind-spot disclosure |
| `ad-incrementality-test` | Designs geo-holdout / PSA-control tests with computed window from baseline + MDE + alpha + power |

### Pricing

| Skill | What it does |
|---|---|
| `pricing-strategic` | WTP, anchor design, packaging, price-test cadence |

### Launch and campaigns

| Skill | What it does |
|---|---|
| `campaign-strategy` | Multi-asset campaign tied to a falsifiable business goal |
| `launch-plan` | Research preview + cadence sequence, not a one-day push |

### Substrate hygiene

| Skill | What it does |
|---|---|
| `context-curate` | Curates the canonical context layers |
| `refresh-knowledge` | Refreshes context layers past freshness window |

### Retention / customer success / lifecycle

| Skill | What it does |
|---|---|
| `activation-funnel-audit` | Diagnoses signup → first-value → retained-week-N from real events; names the activation event by retention-curve divergence |
| `retention-cohort-analysis` | Computes weekly cohort retention curves with slope-change detection; refuses blended-only outputs |
| `churn-diagnose` | Surfaces ranked drivers of churn from a churned-accounts CSV; conditions save-vs-let-go on ICP fit per the contradiction |
| `expansion-trigger-detect` | Scores accounts on behavioral signals (adoption breadth × density × growth × threshold proximity); tenure is not the primary axis |
| `win-back-sequence` | Designs per-band win-back sequences from a churn-diagnose output; refuses without diagnosis |
| `nps-loop-design` | Closed-loop NPS program spec with detractor routing conditioned on ICP fit |

### Team and coaching

| Skill | What it does |
|---|---|
| `pmm-coaching` | Calibration-grounded coaching loop per operator |

## How skills read substrate

Each `SKILL.md` has frontmatter declaring:

```yaml
substrate_layers_required: [voc, icp, positioning, ...]
patterns_grounded: [<slug from knowledge/patterns/>]
contradictions_aware: [<slug from knowledge/contradictions/>]
preflight_refusal: substrate-gap, missing-X, ...
required_reads: [<paths>]
```

If a required layer is absent or expired, the skill returns a refusal. The operator fixes the substrate gap before re-running. This is `PRINCIPLES.md` rule 1 (context-first) and rule 9 (every skill grounds in patterns).

## Skill vs pattern vs playbook

A **skill** is the execution module: the prompt, the substrate contract, the output format.

A **pattern** is a codex-distilled claim with 3+ operator citations: `knowledge/patterns/<slug>.md`. Skills cite patterns; they don't define them.

A **playbook** in older substrate language was the methodology a skill implements. As of v1.1, playbooks are subsumed by patterns + skills. The codex playbook is the design rationale; the substrate skill is the execution.

## Adding a new skill

1. Create `skills/<name>/SKILL.md` with full frontmatter (`patterns_grounded` required).
2. Declare `substrate_layers_required`.
3. Write the purpose, inputs, substrate reads, output contract, quality criteria.
4. Add to this README's table.
5. Append to `knowledge/patterns/INDEX.md` if the skill operationalises a previously-unhooked pattern.
6. Append to `knowledge/contradictions/INDEX.md` if the skill is contradiction-aware.
