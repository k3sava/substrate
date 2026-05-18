---
manifest: stubs-1
branch: agent/stubs-1
date: 2026-05-08
agent: opus-4-7
purpose: Take 6 foundational PMM skills from prompt-emit stubs (~50 LOC each) to substantive runtimes (~600 LOC each) with real parsing, structured output, validation, and refusal patterns.
---

# stubs-1, foundational PMM skills deepened

Six skills moved from "preflight + emit prompt + exit" to first-class runtimes a working PMM can run their week through. Each skill has real input parsing, structured md + json + (where appropriate) yaml/csv output, multiple modes, refusal patterns rooted in the substrate, and contradiction-position logging where the contradictions apply.

Three new patterns added to ground the deepening work, plus four templates that let the skills be tested end-to-end against fixtures.

## LOC delta

| Skill | bin/ before | bin/ after | SKILL.md before | SKILL.md after | Δ bin | Δ skill |
|---|---:|---:|---:|---:|---:|---:|
| `frontline-contact` | 50 | 718 | 60 | 61 | +668 | +1 |
| `win-loss-interview` | 50 | 737 | 65 | 80 | +687 | +15 |
| `narrative-strategy` | 50 | 546 | 71 | 79 | +496 | +8 |
| `messaging-matrix` | 50 | 663 | 69 | 88 | +613 | +19 |
| `icp-cut` | 39 | 653 | 76 | 94 | +614 | +18 |
| `agent-jtbd-map` | 50 | 576 | 76 | 102 | +526 | +26 |
| **Total** | **289** | **3,893** | **417** | **504** | **+3,604** | **+87** |

Floor target was 200 LOC per skill, the worst case here is 546 LOC. Each skill bumped to v2.0 in frontmatter.

## What each skill now does

### `frontline-contact` (718 LOC)

Three modes (`harvest`, `score`, `both`). Reads `clients/<client>/voc/inbox/<date>-*.md` transcripts, runs:

- **Cadence check**, refuses with fewer than `--min-quarter-logs` (default 3) in trailing 90 days. Flags longest-gap > 14 days. Cites `frontline-as-pmm-substrate`.
- **Per-call quality scoring**, weighted average of open-question-ratio (30%), customer-share-of-lines (30%), duration-score (20%, 45-min target), length-score (20%, 80-line target). Detects speakers via four timestamp formats. Flags `no-speaker-labels`, `no-timestamps`, `call-shorter-than-15min`, `open-question-ratio-below-40pct`, `interviewer-dominant-conversation`.
- **TF-IDF noun-phrase extraction** over the corpus with stop-word filter, doc-frequency floor of 2, log-IDF + frequency boost. Filters one-call idiosyncrasies.
- **Manual-taxonomy classifier** with regex pools per category (`jtbd`, `objections`, `alternatives`, `value-words`). Extracts ±80-char context per match.
- **New-signal proposals** when frequency ≥ 3 across 3+ files. Queues for `signal-routine`.
- Output, `voc/findings/<date>.{md,json}` with full citations. Soft-fail (exit 1) when more than half the calls score below 0.40 quality.

Patterns grounded: `frontline-as-pmm-substrate`, `rapport-surfaces-what-research-cannot`, `diagnose-before-execute`, `jtbd-as-buyer-mental-model`, `tf-idf-themes-from-customer-language`.

### `win-loss-interview` (737 LOC)

Four modes (`script`, `capture`, `score`, `aggregate`):

- **`script`**, generates a 23-question interview script per deal, parameterised by canonical positioning. Pulls audience, category, alternatives from positioning canonical statement and drops them into Section 3 (positioning probe) so each question tests a real load-bearing term.
- **`capture`**, writes a structured per-deal `<deal-id>.md` template with frontmatter carrying `contradiction_positions: [no-decision-vs-named-competitor: A|B]`. Pick conditioned on `--alternative-considered`: A if `no-decision`/`status-quo`/`internal-build`, B otherwise. Position rationale logged inline. Refuses without `--loss-amount` for non-won outcomes.
- **`score`**, scores a captured transcript against a 5-dimension rubric (decision-driver-clarity, alternatives-surfaced, status-quo-signal, quote-pulls-verbatim, mindset-diagnosis-present), each 0-3. Soft-fail under 50%.
- **`aggregate`**, walks per-deal JSON for the trailing quarter. Refuses with fewer than 5 captures. Computes ranked deal-pattern drivers by `frequency × (1 + lost_amount/10k)`. Computes status-quo share; if > 40%, sets the global contradiction position to A with rationale; otherwise B. Writes outcome distribution, ranked drivers, status-quo share, contradiction distribution.

Patterns grounded: `frontline-as-pmm-substrate`, `status-quo-is-the-competitor`, `diagnose-before-execute`, `jtbd-as-buyer-mental-model`. Contradictions: `no-decision-vs-named-competitor`.

### `narrative-strategy` (546 LOC)

Composes Andy Raskin five-act strategic narrative grounded in substrate:

- Loads canonical positioning (refuses if missing), market-context (refuses if directory empty), VoC findings JSON, status-quo file, named-alternative battle cards, ICP cut.
- **Act 1 compression discipline**, derives 1-3-word change candidates from market-context titles (filters stop-words, drops words < 3 chars, gives 6 candidates max). Refuses if no candidate compresses to 1-3 words.
- **Acts 2 + 3** require VoC `objections` and `value-words` themes; warns if missing (operator must run `frontline-contact` first).
- **Act 4** pulls from `competitive/status-quo.md` head + named-alternative battle cards.
- **Act 5** uses canonical statement directly with audience/category/alternatives extraction.
- Writes a separate **drift-audit checklist** for monthly Raskin-style audit: 10 customer-facing surfaces × 3 columns (change-phrase consistency, Setup-before-Follow-Through, notes). Refusal trigger: if 3+ surfaces use a different change-phrase.
- Soft-fail (exit 1) if any act has zero substrate citations.
- Outputs: `strategy/narrative-<horizon>-<audience>-<date>.{md,json}` + `strategy/narrative-drift-audit-<date>.md`.

Patterns grounded: `narrative-as-strategy`, `raskin-narrative-five-act`, `buyer-mindset-not-product-features`, `status-quo-is-the-competitor`. Contradictions: `build-quietly-vs-distribution-first` (deferred to launch-plan), `post-training-moat-vs-distribution-moat` (picked by `--anchor-pattern`).

### `messaging-matrix` (663 LOC)

Two modes (`build`, `audit-channel`):

- **`build`**, persona × use-case grid. Pulls personas from `icp/icp-cut-*.json` top 3 segments (override via `--personas`), use-cases from VoC `jtbd` themes top 3 (override via `--use-cases`). Refuses without VoC findings (cite `tf-idf-themes-from-customer-language`).
- Per cell: `hook` (derived from positioning category × use-case), `pain_verbatim` (top objection sample with source), `trigger` (top objection hook), `current_path` (status-quo path), `value_pillars` (top 3 from `product-knowledge/value-pillars.md`), `proof_point` (top value-words sample with source), `cta`.
- **Validations per cell**: `pain_verbatim` must have a real source (refuses), value_pillars max 3, allowed-claims regex (when `positioning/allowed-claims.md` exists), banned-claims regex (when `banned-claims.md` exists), voice-gate (em-dash + 14-word kill-list + throat-clearing opener).
- **`audit-channel`** mode walks an audit dir, scans every `.md` for hook anchor terms from latest matrix yaml, banned terms, voice-gate violations. Writes `messaging/drift-log-<date>.md`. Exit 1 with divergences.
- Outputs: `messaging/matrix-<date>.{md,yaml}` with channel-adaptation rules embedded.

Patterns grounded: `narrative-as-strategy`, `raskin-narrative-five-act`, `buyer-mindset-not-product-features`, `jtbd-as-buyer-mental-model`, `tf-idf-themes-from-customer-language`, `copywriting-craft-fundamentals`.

### `icp-cut` (653 LOC)

Reads CSV inputs (closed-won required; reviews + events optional), slices by firmographics + behaviorals, ranks segments, computes anti-ICP, emits scoring rubric:

- **Refuses** with fewer than `--min-deals` (default 30) closed-won rows or missing required columns (`deal_id, account_id, closed_date, industry, company_size_band, geo, arr_usd, signup_source`).
- **Per-slice scoring**: volume share, median ARR, mean CAC, LTV multiple (3-year-ARR proxy if no events; retention-adjusted if events present), median TTV, retention 12mo (from events), expansion share, composite rank score (`vol × log10(arr+100) × ltv_factor × retention_factor`). Slices < 5 deals flagged `early-signal` and excluded from rank.
- **Conversion-rate per signup-source** computed when events.csv has `signup` events.
- **Anti-ICP** = below-median rank slices where CAC consumes > 40% of first-year ARR or LTV× < 1.5. Mandatory.
- **Anti-ICP overlap check**: warns if anti-ICP overlaps top-3 on ≥ 2 dimensions; exit 1.
- **JTBD overlay** automatically pulled from `voc/findings/*.json` if present; pairs top segment with top JTBD hook.
- **Auto-derived ICP scoring rubric** with 6 dimensions + weights, written as both md table and `icp-rubric-<date>.csv` for RevOps consumption.

Patterns grounded: `jtbd-as-buyer-mental-model`, `frontline-as-pmm-substrate`, `specificity-becomes-profitable`, `market-and-offer-beat-funnel-optimisation`.

### `agent-jtbd-map` (576 LOC)

Reads `clients/<client>/product/agents.yaml` (with a built-in minimal YAML parser, no python-yaml dependency), validates each agent, picks shape per the contradiction conditioning, emits wiring diagram + checkpoint contract:

- **JTBD form validator**: every agent must declare its job in the form `Help me [verb] [object] when [situation]`. Refuses agents whose JTBD doesn't match. "AI in marketing" is not a JTBD.
- **Shape picker** per `agents-as-team-vs-agents-as-tools` contradiction:
  - persistent + heterogeneous → `team` (Vo)
  - ephemeral + homogeneous → `tool` (Cherny)
  - persistent + homogeneous → `team-light` (named identity, simpler context)
  - ephemeral + heterogeneous → `tool-bounded` (per-task context, no long-lived state)
- **Trust-tier validator**: `unattended` requires `runs_total >= 100` AND `exception_rate_pct < 1.0` in `last_60d_run_history`. `exception-only` requires history at all. Refuses upgrades without evidence.
- **Loop class** + **operating loop** validated against Farooq + CASH/CCCD enums.
- **Human checkpoint validator**: must name a real human, not "AI" or "the system".
- **JTBD coverage gaps**: cross-references `strategy/jtbd-list.md` against agent JTBDs (loose 3-content-word overlap). Flags uncovered JTBD and orphan agents.
- **Checkpoint contract** as a separate artifact, per-agent rows with named owner, review cadence (auto-derived from trust tier), kill-switch, current/next tier, sign-off checkboxes.

Patterns grounded: `agents-mapped-to-jtbd`, `agent-first-gtm`, `agents-as-product-users`, `substrate-runs-loop-humans-run-alignment`, `jtbd-as-buyer-mental-model`. Contradictions: `agents-as-team-vs-agents-as-tools`.

## New patterns

Three patterns added in `knowledge/patterns/` to ground skills that were stubs because the patterns hadn't existed yet.

| Pattern | Tier | Operators | Used by |
|---|---|---|---|
| [`raskin-narrative-five-act.md`](../knowledge/patterns/raskin-narrative-five-act.md) | A | Andy Raskin, April Dunford, Anthony Pierri, Christopher Lochhead | `narrative-strategy`, `messaging-matrix` |
| [`jtbd-as-buyer-mental-model.md`](../knowledge/patterns/jtbd-as-buyer-mental-model.md) | A | Clayton Christensen, Bob Moesta, Tony Ulwick, Tom Klement | `frontline-contact`, `win-loss-interview`, `messaging-matrix`, `icp-cut`, `agent-jtbd-map` |
| [`tf-idf-themes-from-customer-language.md`](../knowledge/patterns/tf-idf-themes-from-customer-language.md) | A | Andy Crestodina, Joanna Wiebe, April Dunford, Bryan Eisenberg | `frontline-contact`, `messaging-matrix` |

Each pattern carries: full `convergence_count: 4`, four operator entries with cards, variation analysis, implication (5 numbered actions for operators), counter-evidence (3 honest exceptions), source list. All three got pattern-signature regex entries in `knowledge/patterns/INDEX.md` for the `pre-publish-check` Gate 7 to recognise them in downstream assets.

`knowledge/patterns/INDEX.md` updated with all three new patterns under the "Tier A" section + their pattern-signature regex entries under the gate-7 lookup table.

## New templates

Four templates in `templates/` so skills can be tested end-to-end against fixtures:

- `templates/voc-cadence-contract.md`, the cadence contract `frontline-contact` reads.
- `templates/voc-inbox-example.md`, an example transcript the skill can parse (timestamps + speaker labels).
- `templates/closed-won-example.csv`, 32-row CSV with all required columns; `icp-cut` runs end-to-end against it.
- `templates/agents-example.yaml`, four-agent YAML covering all four shape combinations; `agent-jtbd-map` runs end-to-end against it.

## End-to-end smoke tests (passed)

All six skills were run end-to-end against `clients/test-client/` (gitignored). The pattern: each skill produces real artifacts at the expected paths, refuses on missing substrate, and exits with the expected code.

| Skill | Test command | Result |
|---|---|---|
| `frontline-contact` | `--client test-client` | 4 inbox files parsed, themes extracted, 182-line findings.md + .json |
| `win-loss-interview` | `--mode script --deal-id D-001 --outcome lost` | 81-line script with positioning probe injected |
| `narrative-strategy` | `--client test-client --audience "logistics ops"` | 5-act narrative + drift audit; correctly flagged Act 4 citation gap |
| `messaging-matrix` | `--client test-client` | 73-line matrix.md + 32-line matrix.yaml; 2 cells with validation flags |
| `icp-cut` | `--closed-won templates/closed-won-example.csv` | 111-line ranked-segments.md + json + rubric.csv |
| `agent-jtbd-map` | `--client test-client` (using templates/agents-example.yaml) | 100-line wiring.md + 59-line contract.md + 88-line json |

All refusals fired correctly when substrate was missing (positioning, market-context, deal-id, agents.yaml, closed-won.csv).

## Files touched

- `skills/frontline-contact/{SKILL.md, bin/frontline-contact}`
- `skills/win-loss-interview/{SKILL.md, bin/win-loss-interview}`
- `skills/narrative-strategy/{SKILL.md, bin/narrative-strategy}`
- `skills/messaging-matrix/{SKILL.md, bin/messaging-matrix}`
- `skills/icp-cut/{SKILL.md, bin/icp-cut}`
- `skills/agent-jtbd-map/{SKILL.md, bin/agent-jtbd-map}`
- `knowledge/patterns/{raskin-narrative-five-act, jtbd-as-buyer-mental-model, tf-idf-themes-from-customer-language}.md` (new)
- `knowledge/patterns/INDEX.md` (Tier A entries + pattern-signature lookup entries)
- `templates/{voc-cadence-contract, voc-inbox-example, closed-won-example, agents-example}.{md,csv,yaml}` (new)

## What was NOT touched (per scope boundaries)

- `README.md`, `ORIGIN.md`, `INDEX.md` (skills/, routines/, etc.), `VERSION`, `bin/lib/*`
- Any other skill not in the list of 6
- `clients/*` (gitignored; only used as ephemeral test fixture)

## What's next

These six skills now compose with each other through real outputs:

1. `frontline-contact` writes VoC findings JSON.
2. `icp-cut` reads that JSON for the JTBD overlay.
3. `narrative-strategy` reads it for Acts 2-3 verbatim language.
4. `messaging-matrix` reads it for use-cases and verbatim pain/proof.
5. `win-loss-interview` reads positioning canonical for the script and writes per-deal artifacts.
6. `agent-jtbd-map` wires every product-side agent to a JTBD, ready for `eval-rubric` and `capability-pin`.

A working PMM can now run their week through these six and have the artifacts a downstream skill needs.
