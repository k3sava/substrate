# Substrate

> An AI-native operating system for PMM, GTM, and marketing workflows. Context is the load-bearing layer — not the headcount. Clone it, install it, run it for your team.

Most marketing teams treat AI as a faster typist. Substrate treats it as a function of context. Same operator, same model, with shared canonical context, produces materially better work than the same operator without it. The system is the floor; people set the ceiling.

Substrate ships 86 wired skills across 16 surfaces, 84 codex-grounded patterns (each with hand-tuned behavioral signatures), 20 contradictions with conditioning rules, behavioral grounding gates that check that produced output actually applies the patterns the skill named, and 8 end-to-end orchestrations that compose skills into named PMM / GTM cycles. Open source, MIT, built for any GTM team to clone and run.

[![license](https://img.shields.io/badge/license-MIT-1A4DDE)](LICENSE) [![version](https://img.shields.io/badge/version-1.6.0-0EA572)](VERSION) [![principles](https://img.shields.io/badge/principles-nine%20rules-7A9CC6)](PRINCIPLES.md)

---

## What this is

A context-first operating system for go-to-market work. Every external draft (landing page, ad, email, content piece, video, sales sequence, CS playbook) is grounded in canonical context, gated by a pre-publish check, scored against a stand-in buyer panel, and tied to a goal with a calibration score. Context is the multiplier, not AI.

The traditional GTM org has a dedicated head for every function because each function used to need one. Context infrastructure changes that math. One operator with substrate covers positioning, content, AEO, performance, sales enablement, and retention — what used to need six dedicated seats. A team on a shared substrate layer covers what used to need twenty. Run it solo, run it with a team, or private-fork per client. The OS is the same; the context layer is yours.

---

## Two ways to use Substrate

**Pick a skill, gate an artifact.** A landing page draft. A positioning statement. An ad creative brief. An outbound sequence. An AEO FAQ batch. The skill reads canonical context, refuses on substrate gaps, runs the work, gates the output. One artifact at a time. The composite `pre-publish-check` runs before anything ships.

```bash
substrate pre-publish-check <draft.md> --client <slug>
substrate positioning-forge --diagnose --client <slug>
substrate ad-creative-design --client <slug> --channel meta --variants 4
```

**Pick an orchestration, run a cycle.** A new team onboarding. A quarter of PMM work. A launch. A funnel audit. An AEO publish month. A competitor watch week. An expansion play. Orchestrations compose 4-12 skills into a named operator cycle with declared cadence, owner, inputs, outputs, failure modes, and calibration hooks. End-to-end, not artifact-at-a-time.

| Orchestration | Cadence | What it produces |
|---|---|---|
| [`new-client-onboarding-week-1`](routines/new-client-onboarding-week-1.md) | Day 1 to day 5 of a new team or client onboarding | Bootstrapped client, positioning, narrative, messaging matrix, one customer-facing artifact, 90-day roadmap, three calibrated goals |
| [`quarterly-pmm-cycle`](routines/quarterly-pmm-cycle.md) | Quarterly, with mid-quarter checkpoint | Refresh + open at week 1, signal continuous, mid-quarter checkpoint, resolve + calibrate at week 13 |
| [`launch-flow`](routines/launch-flow.md) | Per-launch, T-12w through T+12w | Plan, brief and generate, gate every asset, ship in cadence, holdout, debrief and Brier score |
| [`full-funnel-audit`](routines/full-funnel-audit.md) | Quarterly, week 1 of the quarter | Paid + email + activation + retention + churn diagnosis, three opened goals naming next quarter's funnel-shaping bets |
| [`customer-conversation-rhythm`](routines/customer-conversation-rhythm.md) | Continuous, with 30 / 60 / 90 cadence | Per-role weekly call quotas, 30-day rotation, 60-day substrate update, 90-day calibration |
| [`aeo-publish-cycle`](routines/aeo-publish-cycle.md) | Monthly, with weekly snapshot sub-loop | Citation snapshot, queue refresh, generate, ship, propagate, re-pull at month +1, Brier score |
| [`competitor-watch-cycle`](routines/competitor-watch-cycle.md) | Weekly, with quarterly re-baseline | Monday scout, Tue-Wed battle-card audit, Thursday status-quo, Friday narrative-drift |
| [`expansion-flywheel`](routines/expansion-flywheel.md) | Monthly review, weekly trigger watcher | Trigger queue, retention cohort feed, NPS routing, expansion outbound design, quarterly resolve |

A team usually starts with `new-client-onboarding-week-1` and graduates into the rhythm cycles after week 1 closes. Without orchestrations, substrate is a pile of skills. With them, it's an operating system.

---

## Who Substrate is for

| Function | What Substrate gives you |
|---|---|
| **PMM** | Canonical positioning, ICP cut on real evidence, claim-verified narrative, calibrated launches. |
| **Content marketing** | Voice gate on every draft (kill-list, em-dash, throat-clearing), citation-aware claim checks, narrative coherence across pieces. The same brand voice file gates a blog post, an ebook, and a webinar deck. |
| **Performance / growth** | LP gate ladder (`lp-ship`), CRO test queue with measurement contracts, ad-diagnose / ad-fatigue-monitor / ad-incrementality-test, baseline + lift targets cited from analytics. Every variant is a calibrated bet, not a hunch. |
| **SEO / AEO / GEO** | `aeo-tune` weekly watcher, schema.org delta tracker, per-vertical AEO pass, off-domain citation audit. Designed for AI-mediated buyers (ChatGPT, Perplexity, AI-assisted research): passages-as-citation-units, machine-readable differentiation. |
| **Sales / SDR / AE** | Battle cards that update themselves, ABM account prioritisation, trigger-event watching, intent-data routing, gated voice on outbound, claim-verify on every promise. |
| **Customer Success** | Activation funnel audit, cohort retention curves, churn diagnosis, expansion trigger detection conditioned on behavior not tenure. Save-vs-let-go conditioned per band. |
| **Product marketing-adjacent product** | A read on what the buyer panel actually says, not what marketing wishes they said. Roadmap claims under the same gate. |
| **Leadership / RevOps** | Calibrated bets with measurement contracts. Brier-scored predictions. Authority follows accuracy, not the org chart. |

If your team operates inside a GTM motion and your work could be wrong in measurable ways, Substrate is for you.

---

## The thesis, in one paragraph

The same team, with the same model, with shared context, produces materially better work than the same team without it. Faster, sharper, with citations that hold up. Most teams treat context as documentation. Substrate treats it as the load-bearing layer, alongside goals you can score, skills that refuse bad input, and orchestrations that compose the skills into named cycles. AI is not the multiplier. The context AI reads is. The result: one operator end-to-end covers what a traditional GTM org used to staff six dedicated seats for. A small team on a shared substrate layer covers what twenty used to. Context infrastructure makes role compression structural, not heroic.

---

## The eight layers

| # | Layer | Where | What |
|---|---|---|---|
| 1 | **Context** | `clients/<client>/` | 10 layers per project. Canonical. Cited. Freshness-windowed. |
| 2 | **Skills** | `skills/` | Gated CLI runtimes. Refuse bad input before it ships. |
| 3 | **Goals** | `goals/ledger.md` | Falsifiable predictions. Calibration-scored at resolution. |
| 4 | **Routines** | `routines/` | Recurring single-purpose loops + end-to-end orchestrations. |
| 5 | **UX** | `bin/substrate-status` + `dashboard/` | Operator queue + web dashboard. |
| 6 | **Calibration** | per-(operator, taste-type) Brier history | Authority follows accuracy, not title. |
| 7 | **Principles** | [`PRINCIPLES.md`](PRINCIPLES.md) | Operating rules. Slowest layer to change. |
| 8 | **Reconciliation** | weekly knowledge check | Always-on freshness + link integrity. |

A closed loop: **ingest signals → ground the context → open goals → generate assets → gate quality → ship → close the loop**. Context carries the routine. Humans own taste, which goals are worth opening, and asset approval.

### The knowledge layer (codex-grounded)

Substrate's context isn't just per-client. The framework itself reads from a corpus of operator-grade research:

- **`knowledge/patterns/`** — cross-source synthesis patterns from a public operator-insight library, each citing 3+ operators (e.g. *frontline contact IS the PMM substrate*, *agents mapped to JTBD with named human checkpoints*, *narrative is strategy*, *AEO triangle*, *aha-moment-defines-activation*, *creative-fatigue-window*, *trigger-events-beat-cadence-blast*, *behavioral-expansion-signals-beat-tenure*).
- **`knowledge/contradictions/`** — places where credible operators disagree, with the conditioning variables that decide which position applies (e.g. *no-decision vs named competitor*, *save-everyone vs let-the-wrong-fit-go*, *personalization vs scale*, *outbound vs inbound budget*, *short-feedback vs long-term holdouts*).
- Every skill declares `patterns_grounded` and (where relevant) `contradictions_aware` in its `SKILL.md` frontmatter. Skills without pattern grounding are unrooted; skills that touch contradictions without naming them pick a position by accident. Both are bugs, both are caught by the publish gate.

---

## Quick start

```bash
# 1. Clone + add bin to PATH
git clone https://github.com/k3sava/substrate.git
cd substrate
export PATH="$PWD/bin:$PATH"

# 2. List available skills
substrate --list

# 3. Bootstrap your first client (creates the 10-layer scaffold,
#    a templated BRIEF.md, and pre-seeds competitors.yaml + verticals.yaml
#    from templates/competitors-example.yaml and templates/verticals-example.yaml).
substrate-bootstrap-prospect <your-product>

# 4. Edit the per-client config (competitors + verticals are first-class)
$EDITOR clients/<your-product>/competitors.yaml
$EDITOR clients/<your-product>/verticals.yaml

# 5. Fill the brief; sketch your positioning
$EDITOR clients/<your-product>/BRIEF.md
$EDITOR clients/<your-product>/positioning/01-canonical.md

# 6. Run the gate before you ship anything
substrate pre-publish-check <draft.md> --client <your-product>
```

For a longer walkthrough see [`QUICKSTART.md`](QUICKSTART.md). For an end-to-end engagement, run [`routines/new-client-onboarding-week-1.md`](routines/new-client-onboarding-week-1.md) and follow the day-by-day sequence.

An example populated client lives at [`clients/example-client/`](clients/example-client/) (fake data, illustrative shape only). Clone the structure; replace the contents with yours.

---

## Skills

86 wired skills, organised across sixteen surfaces. Each grounds in a codex pattern (rule 9 + 9a). Each runs the **pre-publish-check** composite gate plus a skill-specific check. All refuse on missing required-reads or a stale BRIEF. Skill outputs are checked behaviorally for pattern application and contradiction-position-logging via gates 9 and 10.

| Surface | Skills |
|---|---|
| **Discovery / customer voice** | `frontline-contact`, `win-loss-interview`, `tactical-empathy-discovery` |
| **Strategy / narrative** | `narrative-strategy`, `positioning-forge`, `dunford-value-frame`, `status-quo-frame`, `messaging-matrix`, `icp-cut` |
| **Agents / orchestration** | `agent-jtbd-map`, `capability-pin` |
| **Content production** | `narrative-compose`, `lp-ship`, `lp-cro-rubric`, `humanizer`, `pseo-framework`, `help-docs`, `design-thinking-content`, `design-principles` |
| **Evaluation / gating** | `pre-publish-check`, `voice-enforce`, `claim-verify`, `audience-test`, `eval-rubric` |
| **Goals / measurement** | `open-goal`, `score-goal`, `mental-models` |
| **AEO triangle** | `aeo-tune` (presence), `aeo-relevance` (right answer), `aeo-manual-action` (off-domain propagation) |
| **Competitive / pricing** | `competitive-scout`, `pricing-strategic` |
| **Launch / campaigns** | `campaign-strategy`, `launch-plan` |
| **Substrate hygiene / coaching** | `context-curate`, `refresh-knowledge`, `pmm-coaching` |
| **Consulting / engagement** | `consulting-poc` |
| **Paid ads / performance** | `ad-diagnose`, `ad-creative-design`, `ad-spend-allocate`, `ad-fatigue-monitor`, `ad-attribution-honest`, `ad-incrementality-test` |
| **Email / lifecycle** | `email-sequence-design`, `email-deliverability-audit`, `email-list-hygiene`, `email-cohort-trigger`, `email-engagement-decay-watcher` |
| **Retention / CS** | `activation-funnel-audit`, `retention-cohort-analysis`, `churn-diagnose`, `expansion-trigger-detect`, `win-back-sequence`, `nps-loop-design` |
| **ABM / sales engagement** | `abm-account-prioritize`, `outbound-sequence-design`, `sales-trigger-event-watch`, `intent-data-route`, `account-pursuit-rhythm`, `battle-card-driver` |
| **Analytics / social / support** | sprint 2 surfaces, see [`skills/README.md`](skills/README.md) |

Per-skill specs live at `skills/<name>/SKILL.md` with `patterns_grounded` + `contradictions_aware` declared.

---

## consulting-poc, the team onboarding skill

`consulting-poc` orchestrates a productized 5-day proof-of-concept for a new team or client. The skill offers *artifacts the team keeps* and *a diagnostic they can audit*: every claim cites a substrate path, every pattern cites 3+ operators, the team can run the same skills independently after the onboarding closes.

The flow:

- **Phase 0 (free, 60-90 min)**: bootstrap a `clients/<prospect>/` from public surface; carry a positioning audit, AEO triangle status, status-quo competitor map, and Tier A pattern coverage into the first call. The call shows the team their business through substrate.
- **Phase 1 (5-day sprint)**: day 1 bootstrap + ICP cut + 3 customer calls booked; day 2 positioning + status-quo + Dunford value frame; day 3 narrative spine + messaging matrix; day 4 a high-leverage artifact (LP variant, content brief, or win-loss interview); day 5 diagnostic report + 90-day roadmap with three calibrated goals.
- **Phase 2 (optional continuation)**: embedded operator (4-8 weeks), shared substrate (team runs it with you), or train-the-team (2-week sprint).

Run Phase 1 through the [`new-client-onboarding-week-1`](routines/new-client-onboarding-week-1.md) orchestration; `consulting-poc` is the load-bearing skill, the orchestration wraps it with a day-by-day script.

---

## Public-private fork pattern

Substrate is open source. Every team running it accumulates client-specific layers that don't belong in the public repo. The pattern:

- **Use the public substrate as your base.** Clone, drop your client-specific layers under `clients/<your-client>/`, run the same skills against your context. The framework layer (skills, gates, principles, knowledge patterns) is shared; the data layer is yours. Per-client isolation is the trust contract.
- **Contribute generalised patterns back.** When a client-specific layer reveals a transferable insight (a new pattern, a new contradiction, a sharper refusal pattern, a new orchestration), generalise it and PR it back to the public substrate. The codex-grounded knowledge layer compounds.

A consultancy running substrate against real client work keeps its client folders private; the public substrate is the cleaned-and-generalised version that updates as patterns prove themselves out. This is how the framework gets sharper without leaking client data.

---

## End-to-end routines

The 8 orchestrations (full descriptions in [`routines/README.md`](routines/README.md)) compose substrate's skills into named PMM / GTM cycles. Every orchestration declares cadence, owner, inputs required, outputs produced, failure modes, and calibration hooks. They are how a working team turns the skill registry into a quarter's worth of work mapped end-to-end.

The routines split two ways:

- **End-to-end orchestrations** — `new-client-onboarding-week-1`, `quarterly-pmm-cycle`, `launch-flow`, `full-funnel-audit`, `customer-conversation-rhythm`, `aeo-publish-cycle`, `competitor-watch-cycle`, `expansion-flywheel`.
- **Single-purpose routines** — `frontline-contact-routine`, `signal-routine`, `goal-routine`, `content-routine`, `aeo-routine`, `narrative-drift-routine`, `digest-ingest`, `ad-fatigue-routine`, `ad-allocation-routine`, `email-decay-routine`, `email-deliverability-monthly`, `retention-monthly`, `expansion-watcher`, `sales-trigger-routine`, `account-tier-review`.

Single-purpose routines are the recurring sub-loops the orchestrations wrap. A skill might call into a routine; a routine never calls a skill back. An orchestration calls skills and reads the data routines produce.

---

## Behavioral grounding (Gates 9 + 10)

Rule 9 says every skill grounds in patterns and declares contradiction-awareness. The runtime validates that the named pattern files exist and feeds their bodies to the model. But the runtime never re-reads the *output* to confirm the model used what it was given. Rule 9a closes that gap with two new gates that compose into `pre-publish-check`:

- **Gate 9 (pattern-applied)** — for each pattern in the producing skill's `patterns_grounded`, scan the asset body for a behavioral signature drawn from the pattern's `## Implication` and `## Convergence` sections. The signatures are hand-tuned per pattern in `bin/lib/skill-pattern-check.sh::pattern_signature_for()`. Soft-fail by default; hard-fail under `STRICT_PATTERN_CHECK=1` or when the named skill's `SKILL.md` carries `enforce_patterns: true`.
- **Gate 10 (contradiction-position-logged)** — for each entry in the skill's `contradictions_aware`, the asset must (a) name the picked position (A, B, C, ...) AND (b) cite the conditioning evidence that justified the pick. Acceptable forms: frontmatter `contradiction_positions:` + `position_rationale:`, an inline `[contradiction:<slug>] picked Position A because <conditioning>`, or a `## Contradiction navigation` section. A bare "Position A" without rationale fails. Hard-fail.

Both gates fire only when an asset's frontmatter has `produced_by: <skill>`. Substrate's structural docs don't carry that frontmatter, so they pass through unchecked; customer-facing assets do, so they get gated. Declaration is the floor; behavior is the bar. Full spec in [`PRINCIPLES.md`](PRINCIPLES.md) §9a.

---

## First principles

Three rules everything else descends from:

1. **Anti-fabrication**: every claim cites a context file by path. No invented metrics, dates, composite quotes, or aggressive rounding.
2. **Five-tier evidence ladder**: `verified` / `self-reported` / `contextual` / `indirect` / `direct`. Every claim is tagged. Source-system pulls beat operator reports beat inferred guesses.
3. **Buyer is the audience, not the marketer**: drafts are tested against pinned buyer panels, not against the team's taste. Internal applause is not signal.

Full operating rules (the nine rules, plus Rule 9a) in [`PRINCIPLES.md`](PRINCIPLES.md).

---

## Operating model

> **Fewer assets, higher ground.** Every asset ships with an evidence trail. Every claim traces to a context file. Calibration over volume.

Revenue per operator-hour is the north star metric. Not assets shipped. Not campaigns run. Not goals opened. Calibrated bets with measurement contracts. Brier scores at resolution. Authority follows accuracy.

AI-mediated buyers (searching in ChatGPT, Perplexity, AI-assisted research) require machine-readable differentiation: schema.org typed entities, passages-as-citation-units, off-site mirrors. Substrate ships an `aeo-tune` weekly watcher and a per-vertical pass to compound on that surface, plus an `aeo-publish-cycle` orchestration that runs the AEO triangle (presence, relevance, manual-action) as a closed monthly loop.

---

## Self-evolution

Substrate is fed by a daily research-and-digest pipeline (a separate upstream system the maintainer runs). The contract is documented; the implementation is pluggable:

1. Scan operator-relevant sources (newsletters, GTM teardowns, founder posts, weekly platform updates).
2. Produce dated digests with insights + sandbox-tested ideas.
3. Each digest tags an "apply-to-substrate" section: which skills, principles, or knowledge layers should change in response.
4. Substrate's daily ingest reads those tagged sections and either auto-merges low-risk knowledge updates or files a proposal for the human-in-loop gate.

Auto-skill-proposal closes Rule 9 from the other side: when a digest surfaces a pattern with no substrate hook, the runner files a skill proposal alongside the knowledge addition. Every pattern has a skill or a proposal for one. See `routines/digest-ingest.md` for the full contract; bring your own digest source.

The result: Substrate gets sharper without anyone having to remember to update it.

---

## Substrate-on-substrate

Substrate's own structural docs (`README.md`, `PRINCIPLES.md`, `ORIGIN.md`, `CLAUDE.md`, `CONTRIBUTING.md`, the routine and skill specs) read against the same voice rules and refusal patterns the customer-facing assets do. The dispatcher's BRIEF-gate refuses customer-facing skills without a current `BRIEF.md`; the same rule applies to substrate's own knowledge layer (patterns must cite operators, contradictions must name conditioning, routines must declare cadence + owner). Self-accountability is in the principles; the system applies to its author.

Substrate doesn't carry `produced_by: <skill>` frontmatter on its own structural docs (so gates 9 and 10 don't fire on README.md), but the voice rules (kill-list, em-dash, throat-clearing) do apply, and the citation rules (no fabricated metrics, no invented dates, no guessed claims) apply universally. Patterns and contradictions evolve through `digest-ingest`, not through ad-hoc edits to the framework.

---

## What Substrate is not

- **Not a campaign management tool.** No approval workflows, no calendar views, no status meetings. Use Asana / Trello / Linear for that.
- **Not a replacement for taste.** Humans open goals. Humans approve assets. Humans own the message. The system is the floor; people set the ceiling.
- **Not a team management system.** It measures output quality, not headcount.
- **Not a CRM.** It reads from your CRM (HubSpot, Salesforce, Pipedrive). It doesn't replace it.
- **Not a content generator.** AI generates. Substrate refuses bad output before it ships.

---

## Top-level files

| File | Purpose |
|---|---|
| [`README.md`](README.md) | This file. |
| [`QUICKSTART.md`](QUICKSTART.md) | Clone-and-run flow for a new client team. |
| [`PRINCIPLES.md`](PRINCIPLES.md) | Operating rules. Slowest layer to change. |
| [`ORIGIN.md`](ORIGIN.md) | How Substrate came together (v0.1 through v1.5). |
| [`CLAUDE.md`](CLAUDE.md) | Agent rules (how AI tools should use this folder). |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | How to contribute. |
| [`VERSION`](VERSION) | Current version. |
| [`LICENSE`](LICENSE) | MIT. |

---

## A note on the work

Substrate is the open-source distillation of a system built and run across PMM, content marketing, performance, AEO, sales enablement, and customer success functions. Field-tested against real clients, real copy, real measurement contracts. The public release strips every client-specific artifact and ships the structure: the loop, the principles, the skills, the gates, the calibration ledger, the knowledge layer, the behavioral grounding gates, and the orchestrations.

v1.6.0 is the current release. Issues and PRs welcome via GitHub.

---

*Built by Kesava Mandiga · MIT licensed*
