---
title: Patterns layer, codex-grounded
status: active
last_updated: 2026-05-07
version: 1.0
source: upstream operator-insight library (synthesis/patterns/)
---

# Patterns

Cross-source patterns from the codex's insight corpus. Each pattern has 3+ operators with cards that genuinely converge. These are the load-bearing claims about how AI-native GTM works. Substrate is built to operationalise them.

The pattern files in this directory mirror codex synthesis output verbatim, by design. Codex is the source of truth, substrate is the application layer. When codex's daily ingest produces new patterns, the digest-ingest routine proposes additions here.

## How to read

- **Pattern**: a claim with 3+ operator citations.
- **Tier A**: strong convergence, multi-source, transferable.
- **Tier B**: meaningful convergence, narrower band.
- **Substrate hooks**: which skills, routines, or principles read this pattern.
- **Behavioral signature**: the regex / phrase / structural cue an asset that *applies* the pattern is hard to write without using. Maintained in `bin/lib/skill-pattern-check.sh::pattern_signature_for()`. Used by Gate 9 (pattern-applied) of `pre-publish-check` to verify the skill's output evidenced the pattern, not just declared it. See [PRINCIPLES.md rule 9a](../../PRINCIPLES.md).

A skill that runs without grounding in a pattern is unrooted. A pattern with no substrate hook is observational, not operational. Both are bugs.

## Tier A patterns

| Pattern | File | Substrate hooks |
|---|---|---|
| Substrate runs the loop, humans run alignment | [substrate-runs-loop-humans-run-alignment.md](substrate-runs-loop-humans-run-alignment.md) | architecture-wide; `goal-routine`; `content-routine`; `pre-publish-check`; PRINCIPLES.md rule 3 |
| Context is the bottleneck, not capability | [context-not-capability.md](context-not-capability.md) | `context-curate`; `refresh-knowledge`; `quarterly-context-audit`; PRINCIPLES.md rule 1 |
| Generalists with taste, end-to-end | [generalists-with-taste.md](generalists-with-taste.md) | architecture-wide; the operator persona substrate is designed for |
| Frontline customer contact IS the PMM substrate | [frontline-as-pmm-substrate.md](frontline-as-pmm-substrate.md) | `frontline-contact` routine (new); `signal-routine`; `win-loss-interview`; `tactical-empathy-discovery` |
| Agents mapped 1:1 to JTBD with named human checkpoints | [agents-mapped-to-jtbd.md](agents-mapped-to-jtbd.md) | `agent-jtbd-map` (new); `goal-routine`; skill-as-named-agent doctrine |
| Agent-first GTM (rebuild, don't bolt-on) | [agent-first-gtm.md](agent-first-gtm.md) | architecture-wide; `agent-jtbd-map` (new); INDEX.md; ORIGIN.md |
| Distribution and earned channels are the new moat | [distribution-as-moat.md](distribution-as-moat.md) | `aeo-routine`; `content-routine`; `pseo-framework` (new) |
| Status quo / no-decision is the real competitor | [status-quo-is-the-competitor.md](status-quo-is-the-competitor.md) | `status-quo-frame` (new); `competitive-scout`; `dunford-value-frame` |
| Narrative IS strategy | [narrative-as-strategy.md](narrative-as-strategy.md) | `narrative-strategy` (new); `positioning-forge`; `dunford-value-frame` |
| Make the implicit explicit | [make-implicit-explicit.md](make-implicit-explicit.md) | `claim-verify`; `pre-publish-check`; PRINCIPLES.md rule 2 |
| Diagnose before executing, refuse the playbook ask | [diagnose-before-execute.md](diagnose-before-execute.md) | `tactical-empathy-discovery` (new); `open-goal` preflight; `signal-routine` |
| The aha moment defines activation | [aha-moment-defines-activation.md](aha-moment-defines-activation.md) | `activation-funnel-audit` (new); `retention-cohort-analysis` (new); `nps-loop-design` (new) |
| Cohort retention curves over blended rates | [retention-cohort-curves-over-blended-rates.md](retention-cohort-curves-over-blended-rates.md) | `retention-cohort-analysis` (new); `churn-diagnose` (new); `expansion-trigger-detect` (new) |
| Behavioral signals beat tenure for expansion | [behavioral-expansion-signals-beat-tenure.md](behavioral-expansion-signals-beat-tenure.md) | `expansion-trigger-detect` (new); `retention-monthly` routine (new) |
| Diagnose churn before predicting it | [churn-prediction-vs-churn-diagnosis.md](churn-prediction-vs-churn-diagnosis.md) | `churn-diagnose` (new); `win-back-sequence` (new); retention measurement |
| AEO triangle: presence, relevance, manual-action | [aeo-triangle.md](aeo-triangle.md) | `aeo-tune` (presence); `aeo-relevance` (new); `aeo-manual-action` (new); `aeo-routine` |
| Quality + friction-as-feature are growth levers | [quality-as-growth-lever.md](quality-as-growth-lever.md) | `pre-publish-check`; `audience-test`; `lp-cro-rubric` (new) |
| Absolute counts beat stage rates | [measurement-correlated-short-signals.md](measurement-correlated-short-signals.md) | `goal-routine`; `score-goal`; measurement-framework |
| Build for the next model, not the current | [build-for-next-model.md](build-for-next-model.md) | `capability-pin` (new); skill registry discipline |
| Agents are first-class users | [agents-as-product-users.md](agents-as-product-users.md) | `aeo-tune`; llms.txt; `.well-known/*`; substrate-status JSON |
| Evals are data analysis, single judge, binary rubrics | [eval-as-data-analysis.md](eval-as-data-analysis.md) | `eval-rubric` (new); `score-goal`; `audience-test` |
| Economic Turing test → revenue per employee | [economic-turing-test-rev-per-employee.md](economic-turing-test-rev-per-employee.md) | metric design (revenue per operator); `goal-routine`; PRINCIPLES.md |
| Principal IC as force multiplier | [principal-ic-as-force-multiplier.md](principal-ic-as-force-multiplier.md) | operator persona; `pmm-coaching` (new) |
| LLM-as-OS, post-training as moat | [llm-as-os.md](llm-as-os.md) | architecture-wide; thesis substrate operationalises |
| Trigger events outperform blanket cadence | [trigger-events-beat-cadence-blast.md](trigger-events-beat-cadence-blast.md) | `sales-trigger-event-watch` (new); `abm-account-prioritize` (new); `outbound-sequence-design` (new); `intent-data-route` (new) |
| Account is the unit of pursuit, not the lead | [account-not-lead-as-unit.md](account-not-lead-as-unit.md) | `abm-account-prioritize` (new); `account-pursuit-rhythm` (new); `intent-data-route` (new); `icp-cut` |
| Consistent rhythm beats episodic blast | [rhythm-beats-blast.md](rhythm-beats-blast.md) | `account-pursuit-rhythm` (new); `outbound-sequence-design` (new) |
| Status quo is the real objection in outbound | [status-quo-is-the-real-objection-outbound.md](status-quo-is-the-real-objection-outbound.md) | `outbound-sequence-design` (new); `battle-card-driver` (new); `status-quo-frame` |
| Strategic narrative is a five-act movie structure | [raskin-narrative-five-act.md](raskin-narrative-five-act.md) | `narrative-strategy` (new); `messaging-matrix` (new); `positioning-forge` |
| JTBD is the buyer mental model, not feature framework | [jtbd-as-buyer-mental-model.md](jtbd-as-buyer-mental-model.md) | `frontline-contact` (new); `win-loss-interview` (new); `messaging-matrix` (new); `icp-cut` |
| Customer-language extraction beats marketer-rewriting | [tf-idf-themes-from-customer-language.md](tf-idf-themes-from-customer-language.md) | `frontline-contact` (new); `messaging-matrix` (new); `lp-ship` |

## Tier B patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Differentiation requires three checks | [differentiation-vs-sameness.md](differentiation-vs-sameness.md) | `positioning-forge`; `dunford-value-frame`; `status-quo-frame` (new) |
| Specificity becomes profitable | [specificity-becomes-profitable.md](specificity-becomes-profitable.md) | `positioning-forge`; copywriting skills; `lp-cro-rubric` (new) |
| Research preview + cadence | [research-preview-and-cadence.md](research-preview-and-cadence.md) | `launch-plan` (new); `campaign-strategy` (new) |
| Parenting meets leadership | [parenting-meets-leadership.md](parenting-meets-leadership.md) | `pmm-coaching` (new); leadership domain |

## Other convergent patterns (15)

| Pattern | File | Substrate hooks |
|---|---|---|
| AI defensibility comes from non-AI | [ai-defensibility-comes-from-non-ai.md](ai-defensibility-comes-from-non-ai.md) | architecture; context layer; `context-curate` |
| Behavioral pricing architecture | [behavioral-pricing-architecture.md](behavioral-pricing-architecture.md) | `pricing-strategic` (new) |
| Buyer mindset, not product features | [buyer-mindset-not-product-features.md](buyer-mindset-not-product-features.md) | `positioning-forge`; `narrative-strategy` (new); `dunford-value-frame` |
| Copywriting craft fundamentals | [copywriting-craft-fundamentals.md](copywriting-craft-fundamentals.md) | `humanizer`; `voice-enforce`; `lp-cro-rubric` (new); `narrative-compose` |
| Decision quality through process, not willpower | [decision-quality-through-process-not-willpower.md](decision-quality-through-process-not-willpower.md) | `mental-models` (new); `open-goal`; `score-goal` |
| Execution cheap, judgement scarce | [execution-cheap-judgement-scarce.md](execution-cheap-judgement-scarce.md) | architecture-wide; PRINCIPLES.md |
| Market and offer beat funnel optimisation | [market-and-offer-beat-funnel-optimisation.md](market-and-offer-beat-funnel-optimisation.md) | `positioning-forge`; `narrative-strategy` (new); `icp-cut` |
| Monopoly economics, differentiation beats competition | [monopoly-economics-differentiation-beats-competition.md](monopoly-economics-differentiation-beats-competition.md) | `positioning-forge`; `dunford-value-frame`; `status-quo-frame` (new) |
| Pricing as most-leveraged org failure | [pricing-as-the-most-leveraged-org-failure.md](pricing-as-the-most-leveraged-org-failure.md) | `pricing-strategic` (new) |
| Rapport surfaces what research cannot | [rapport-surfaces-what-research-cannot.md](rapport-surfaces-what-research-cannot.md) | `tactical-empathy-discovery` (new); `frontline-contact` (new) |
| Sales as engineered system, not art | [sales-as-engineered-system-not-art.md](sales-as-engineered-system-not-art.md) | sales-enablement skills (deferred); `tactical-empathy-discovery` (new) |
| Specific knowledge and circle of competence | [specific-knowledge-and-circle-of-competence.md](specific-knowledge-and-circle-of-competence.md) | `positioning-forge`; `icp-cut` |
| Subtraction-first operating discipline | [subtraction-first-operating-discipline.md](subtraction-first-operating-discipline.md) | CONTRIBUTING.md; operator discipline |
| Sustainability beats optimisation | [sustainability-beats-optimisation.md](sustainability-beats-optimisation.md) | `goal-routine` (long-window goals); retention measurement |
| Verification as human job | [verification-as-human-job.md](verification-as-human-job.md) | `claim-verify`; `pre-publish-check`; PRINCIPLES.md rule 2 |

## Paid-ads / performance patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Creative fatigue window, refresh cadence is the lever | [creative-fatigue-window.md](creative-fatigue-window.md) | `ad-diagnose`; `ad-fatigue-monitor`; `ad-creative-design`; `routines/ad-fatigue-routine.md` |
| Channel arbitrage window, track and rotate | [channel-arbitrage-window.md](channel-arbitrage-window.md) | `ad-spend-allocate`; `routines/ad-allocation-routine.md` |
| Intent vs interest targeting, different funnels different unit economics | [intent-vs-interest-targeting.md](intent-vs-interest-targeting.md) | `ad-diagnose`; `ad-spend-allocate`; `ad-creative-design`; `ad-attribution-honest`; `ad-incrementality-test` |
| Incrementality, not attribution | [incrementality-not-attribution.md](incrementality-not-attribution.md) | `ad-attribution-honest`; `ad-incrementality-test`; `ad-spend-allocate` |

## Email / lifecycle patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Engagement decay as relevance signal | [engagement-decay-as-relevance-signal.md](engagement-decay-as-relevance-signal.md) | `email-engagement-decay-watcher`; `email-cohort-trigger`; `routines/email-decay-routine.md` |
| Sender reputation is a domain asset | [sender-reputation-is-a-domain-asset.md](sender-reputation-is-a-domain-asset.md) | `email-deliverability-audit`; `routines/email-deliverability-monthly.md` |
| One segment one trigger | [one-segment-one-trigger.md](one-segment-one-trigger.md) | `email-cohort-trigger`; `email-sequence-design` |
| Subject line as experiment, not art | [subject-line-as-experiment-not-art.md](subject-line-as-experiment-not-art.md) | `email-sequence-design`; `audience-test` |

## Retention / customer-success patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Aha moment defines activation | [aha-moment-defines-activation.md](aha-moment-defines-activation.md) | `activation-funnel-audit`; `retention-cohort-analysis`; `nps-loop-design` |
| Retention cohort curves over blended rates | [retention-cohort-curves-over-blended-rates.md](retention-cohort-curves-over-blended-rates.md) | `retention-cohort-analysis`; `churn-diagnose`; `expansion-trigger-detect` |
| Behavioral expansion signals beat tenure | [behavioral-expansion-signals-beat-tenure.md](behavioral-expansion-signals-beat-tenure.md) | `expansion-trigger-detect`; `routines/retention-monthly.md` |
| Diagnose churn before predicting it | [churn-prediction-vs-churn-diagnosis.md](churn-prediction-vs-churn-diagnosis.md) | `churn-diagnose`; `win-back-sequence` |

## ABM / sales-engagement patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Trigger events beat cadence blast | [trigger-events-beat-cadence-blast.md](trigger-events-beat-cadence-blast.md) | `sales-trigger-event-watch`; `abm-account-prioritize`; `outbound-sequence-design`; `intent-data-route` |
| Account is the unit, not the lead | [account-not-lead-as-unit.md](account-not-lead-as-unit.md) | `abm-account-prioritize`; `account-pursuit-rhythm`; `intent-data-route`; `icp-cut` |
| Rhythm beats blast | [rhythm-beats-blast.md](rhythm-beats-blast.md) | `account-pursuit-rhythm`; `outbound-sequence-design` |
| Status-quo is the real objection in outbound | [status-quo-is-the-real-objection-outbound.md](status-quo-is-the-real-objection-outbound.md) | `outbound-sequence-design`; `battle-card-driver`; `status-quo-frame` |

## Analytics / attribution patterns (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Metric tree, not metric stack | [metric-tree-not-metric-stack.md](metric-tree-not-metric-stack.md) | `metric-tree-design`; `dashboard-spec`; goal-routine |
| Event taxonomy is product knowledge | [event-taxonomy-as-product-knowledge.md](event-taxonomy-as-product-knowledge.md) | `event-taxonomy-audit`; `analytics-pull`; `email-cohort-trigger` |
| Goalpost discipline beats metric drift | [goalpost-discipline-vs-metric-drift.md](goalpost-discipline-vs-metric-drift.md) | `attribution-model-design`; `lift-test-design`; `score-goal`; `open-goal` |
| Segment-of-one and cohort aggregate, both views | [segment-of-one-vs-cohort-aggregate.md](segment-of-one-vs-cohort-aggregate.md) | `retention-cohort-analysis`; `churn-diagnose`; `audience-test` |

## Social-media patterns (3)

| Pattern | File | Substrate hooks |
|---|---|---|
| Native format beats cross-post | [native-format-beats-cross-post.md](native-format-beats-cross-post.md) | `social-content-design`; `routines/social-content-cycle.md` |
| Creator, not corporate | [creator-not-corporate.md](creator-not-corporate.md) | `social-content-design`; `influencer-fit-score` |
| Social as distribution, not conversion | [social-as-distribution-not-conversion.md](social-as-distribution-not-conversion.md) | `social-amplification-test`; `attribution-model-design` |

## Customer-support patterns (3)

| Pattern | File | Substrate hooks |
|---|---|---|
| Tickets are the product feedback channel | [tickets-are-product-feedback-channel.md](tickets-are-product-feedback-channel.md) | `ticket-cluster-analysis`; `help-content-gap-detect`; `churn-signal-from-support` |
| Deflection is not the goal, right-routing is | [deflection-is-not-the-goal.md](deflection-is-not-the-goal.md) | `deflection-experiment-design`; `csat-loop-design` |
| Support volume + sentiment lead churn 30-90 days | [support-as-churn-leading-indicator.md](support-as-churn-leading-indicator.md) | `churn-signal-from-support`; `churn-diagnose` |

## PMM-craft patterns added by stub deepening (3)

| Pattern | File | Substrate hooks |
|---|---|---|
| Strategic narrative as five-act movie structure | [raskin-narrative-five-act.md](raskin-narrative-five-act.md) | `narrative-strategy`; `messaging-matrix`; `positioning-forge` |
| JTBD as buyer mental model | [jtbd-as-buyer-mental-model.md](jtbd-as-buyer-mental-model.md) | `frontline-contact`; `win-loss-interview`; `messaging-matrix`; `icp-cut` |
| TF-IDF themes from customer language | [tf-idf-themes-from-customer-language.md](tf-idf-themes-from-customer-language.md) | `frontline-contact`; `messaging-matrix`; `lp-ship` |

## Consulting-engagement / career-ops patterns added 2026-05-18 (front-half v1.7) (10)

| Pattern | File | Substrate hooks |
|---|---|---|
| Founding PMM amplifies founder voice | [founding-pmm-amplifies-founder-voice.md](founding-pmm-amplifies-founder-voice.md) | `first-pmm-compression`; `founder-voice-substrate` |
| Anti-agent-washing | [anti-agent-washing.md](anti-agent-washing.md) | `ai-native-category-positioning`; `capability-pin`; `eval-rubric`; `agent-jtbd-map` |
| Capability decays; rebaseline quarterly | [capability-decay-rebaseline.md](capability-decay-rebaseline.md) | `ai-native-category-positioning`; `capability-pin`; `eval-rubric` |
| Anchor high, decoy between anchor and target | [anchor-high-then-decoy.md](anchor-high-then-decoy.md) | `engagement-shape-pricing`; `pricing-strategic` |
| Productized fixed-fee consulting beats hourly | [productized-consulting-beats-hourly.md](productized-consulting-beats-hourly.md) | `engagement-shape-pricing`; `consulting-poc` |
| Hiring-manager-not-recruiter (15× rule) | [hiring-manager-not-recruiter.md](hiring-manager-not-recruiter.md) | `referral-targeting` |
| Value-add hook plus exit-clause closer | [value-add-with-exit-clause.md](value-add-with-exit-clause.md) | `referral-targeting`; `outbound-sequence-design` |
| Operator-voice-warm (formal body with traces) | [operator-voice-warm.md](operator-voice-warm.md) | `referral-targeting`; `voice-enforce` |
| Anti-fabrication on prospects | [anti-fabrication-on-prospects.md](anti-fabrication-on-prospects.md) | `prospect-identification`; `referral-targeting` |
| Candidate landscape, not finalist | [candidate-landscape-not-finalist.md](candidate-landscape-not-finalist.md) | `prospect-identification` |

## Production / measurement patterns added by stub deepening (4)

| Pattern | File | Substrate hooks |
|---|---|---|
| Launch as coordinated distribution | [launch-as-coordinated-distribution.md](launch-as-coordinated-distribution.md) | `launch-plan`; `campaign-strategy` |
| Van Westendorp over vibes-pricing | [van-westendorp-over-vibes-pricing.md](van-westendorp-over-vibes-pricing.md) | `pricing-strategic` |
| Synthetic audience as pre-publish floor | [synthetic-audience-as-pre-publish-floor.md](synthetic-audience-as-pre-publish-floor.md) | `audience-test`; `pre-publish-check` |
| Passage as citation unit | [passage-as-citation-unit.md](passage-as-citation-unit.md) | `aeo-relevance`; `aeo-tune`; `aeo-manual-action` |

## How to read a pattern

Every pattern in this directory carries:
- The convergent claim (what 3+ operators agree on).
- The operator citations (which insight cards back the claim).
- The variation (how each operator scopes it).
- The implication (what a team should do with the pattern).

Substrate adds:
- The skill/routine that operationalises the pattern.
- The principle the pattern reinforces.
- The deck card the pattern feeds.

A pattern with zero substrate hook is observational. A skill that doesn't cite a pattern is unrooted. Both are bugs to close.

## How patterns evolve

Codex's daily ingest produces new pattern proposals when 3+ operators converge on a claim. The substrate `digest-ingest` routine reads codex digests and either auto-merges new pattern files (low-risk knowledge updates) or files a proposal for human review (skill or principle changes). Patterns here are append-only at the file level — superseded patterns are marked `status: superseded` in frontmatter, not deleted.

## Coverage

| Domain | Tier A coverage | Substrate hooks |
|---|---|---|
| ai-native | 8 patterns | architecture-wide |
| pmm | 6 patterns | positioning, narrative, frontline, status-quo |
| gtm | 5 patterns | agent-jtbd-map, distribution, agent-first-gtm |
| sales-cs | 3 patterns | tactical-empathy, win-loss, frontline |
| customer-success | 4 patterns | aha-moment, cohort-curves, expansion-signals, churn-diagnosis |
| growth | 3 patterns | quality-as-lever, distribution, measurement |
| pricing | 2 patterns | pricing-strategic, behavioral-pricing |
| paid-ads | 4 patterns | ad-diagnose, ad-spend-allocate, ad-creative-design, ad-fatigue-monitor, ad-attribution-honest, ad-incrementality-test |
| design-ux | 0 patterns | gap; design playbooks pending |

Design coverage is light because the codex itself flags it as light. Tracked.

## Behavioral signatures (Gate 9 catalog)

For pattern X, the signature answers the question: "If a draft applies pattern X, what load-bearing language or structure must show up?" Calibration came from reading every `## Implication` and `## Convergence` section, identifying the verbs and noun pairs that carry the pattern's actual instruction, and rejecting generic nouns alone (since those false-positive on assets that mention the topic without applying it).

| Pattern | Behavioral cue (paraphrased) |
|---|---|
| `diagnose-before-execute` | A Diagnosis/Audit section before any Plan/Recommendation section, OR a literal phrase like "refuse the playbook ask" / "three divergent paths" / "go to bedrock" / "understand-work" |
| `aeo-triangle` | Names all three layers (presence + readiness + impact), or "passage-grain", or distinguishes citation from mention rate, or warns on manual-action / slop loop |
| `agent-first-gtm` | "Cross-functional pod" + "single mandate", or "rebuild not bolt-on", or "system of action", or named agents per JTBD |
| `agents-mapped-to-jtbd` | A JTBD list before agents, named human checkpoint, trust-tier ladder (review-all → spot-check → exception-only), CASH/CCCD loop, wiring diagram |
| `agents-as-product-users` | "First-class users", "machine customers", structured-output endpoints (MCP / llms.txt / .well-known), dual-audience design |
| `context-not-capability` | "Context (not capability) is the bottleneck", `.claude/` as a deployable artifact, "investigate the context first", greppable wiki, prune as models improve |
| `distribution-as-moat` | "Distribution is the moat", earned-channel framing, "algorithm-rented vs earned", "rebrands are cosmetic", source from frontline |
| `frontline-as-pmm-substrate` | "Frontline contact", "written cadence", "logged conversation", "live sales/customer call", switch interview |
| `narrative-as-strategy` | "Narrative-drift audit", "name the shift in 1-3 words", "old game / new game", "narrative IS strategy", monthly audit across surfaces |
| `status-quo-is-the-competitor` | "No-decision", "status-quo bias", "2× switching cost", "loss aversion", "Setup-Follow-Through", "world-shift", "use-case epiphany" |
| `buyer-mindset-not-product-features` | Buyer-mindset taxonomy (no-problem → implied → explicit → FOMU), JOLT for indecision, tactical empathy, forces of progress |
| `differentiation-vs-sameness` | The three checks (different + better + matters viscerally), live pitch, external audience, "sameness perception" |
| `specificity-becomes-profitable` | "Segment specificity", "narrowest viable niche", spin up segment-specific LPs |
| `eval-as-data-analysis` | "100+ traces", open-code → axial-code → automate, LLM-as-judge with binary T/F rubrics, 100% production threshold |
| `measurement-correlated-short-signals` | "Absolute counts beat stage rates", "correlated 7-day proxy", "30-day sample", "year holdout", evaporation |
| `quality-as-growth-lever` | "Cohort retention", "qualifying friction", "friction-as-feature", "brand and quality compound" |
| `make-implicit-explicit` | "Explicit-naming ritual", "kill criterion", "confidence label", "uncertainty UI" |
| `verification-as-human-job` | "Feedback path", transcript-level evidence, "runs that worked vs runs that didn't", "logging not learning", reviewable + reversible |
| `economic-turing-test-rev-per-employee` | "Revenue per operator", outcome-priced agent revenue, undersize teams + over-invest top quartile |
| `principal-ic-as-force-multiplier` | Larson archetypes, "glue work", "multiplier evidence", others shipping faster |
| `decision-quality-through-process-not-willpower` | Pre-mortem, independent ratings before debrief, Munger latticework, lollapalooza watch, devil's advocate / red team |
| `specific-knowledge-and-circle-of-competence` | "Audit specific knowledge", "circle of competence", intersection of skills, circle drift, moving intersection |
| `monopoly-economics-differentiation-beats-competition` | Thiel death spiral, Onlyness, starving crowd, "position around the gap not parity", vertical progress |
| `pricing-as-the-most-leveraged-org-failure` | Hire pricing officer, WTP research, NRR > 100%, Leaders/Fillers/Killers, discount discipline |
| `behavioral-pricing-architecture` | Tier anchor, pain of paying, arbitrary coherence, demand cliffs, free entry tier |
| `llm-as-os` | "LLM as OS", post-training as moat, "commoditize the complement", data flywheel, ecosystem positioning |
| `build-for-next-model` | "Next model", current-model scaffolding as depreciating asset, "quarterly re-baseline", "ceiling moves" |
| `sustainability-beats-optimisation` | Long-window, "retention not first-week", durable cohorts |
| `research-preview-and-cadence` | "Research preview", seasonal planning, frontier cohort, weekly metric readouts, principle docs replace PRDs |
| `parenting-meets-leadership` | MGI / most-charitable-interpretation, repair after rupture, behavior not identity, criticize-in-private |
| `generalists-with-taste` | "Generalists with taste", end-to-end, one deep dimension, spiky strength, taste gate |
| `rapport-surfaces-what-research-cannot` | Tactical empathy, accusation audit, mirroring + labeling, Voss |
| `sales-as-engineered-system-not-art` | "Sales as a system", scripted plays, SPIN sequence, objection-handling matrix |
| `copywriting-craft-fundamentals` | "Specific over abstract", "kill the darling", "earn its place", Hemingway / Saunders / Zinsser |
| `market-and-offer-beat-funnel-optimisation` | "Market beats offer beats funnel", "wrong market no funnel saves", offer architecture |
| `ai-defensibility-comes-from-non-ai` | "Defensibility from non-AI", "model is not the moat", data + distribution + brand + integration |
| `execution-cheap-judgement-scarce` | "Execution cheap, judgement scarce", "taste premium", AI multiplies execution |
| `substrate-runs-loop-humans-run-alignment` | Inner loop / outer loop split, humans run alignment, "kill criteria", "named taste call", "resist the queue" |
| `subtraction-first-operating-discipline` | "Subtraction-first", "cut before adding", "kill before ship", fewer surfaces |
| `creative-fatigue-window` | "Refresh cadence" as the lever (not bidding), fatigue thresholds (CTR decline, frequency above 3, CPM rise), creative volume target (10+ per week), weekly cadence on creative as the upstream cause of CAC drift |
| `channel-arbitrage-window` | "Channel arbitrage" window (6-18 month), saturation indicators, channel-product fit, 70/20/10 budget split, "rotate ahead of saturation", quarterly channel review |
| `intent-vs-interest-targeting` | "Search buys intent / paid social buys interest", See/Think/Do/Care mapping, demand-capture vs demand-generation metrics, assisted conversions, branded-search lift, separate dashboards/budgets per channel |
| `incrementality-not-attribution` | "Incrementality test", geo holdout / ghost ads / conversion-lift study, MMM, attribution model footnote, "blended CAC...footnote/model assumed", 2x to 5x reported-vs-incremental divergence, the 5%-of-budget threshold |
| `engagement-decay-as-relevance-signal` | "Relevance hypothesis (first/before deliverability)", "gradual taper vs sudden cliff", "deliverability dashboards downstream", "broadcast nurtures decay/underperform", permission as renewing contract, "audit the trigger not the body" |
| `sender-reputation-is-a-domain-asset` | "Domain reputation", "sending domain", DMARC / SPF + DKIM / RFC 7489, "burn-and-rotate" refusal, "subdomain sprawl" audit, "organizational domain", "multi-year compounding asset" |
| `one-segment-one-trigger` | "Cohort × trigger" as smallest viable lifecycle unit, "broad-list-broadcast" refusal, "broadcast nurture", trigger-first vs cadence-first, trigger fire-rate metric, JTBD progress moment as the trigger primitive |
| `subject-line-as-experiment-not-art` | "Subject line as hypothesis (not creative writing)", message-mining / review-mining for source language, cohort-scoped tests with statistical bar set before send, "document the hypothesis", "catchy is the wrong question" |
| `aha-moment-defines-activation` | "Aha moment / activation event" tied to retention-curve segmentation (not UX milestone), candidate value events tested against curve divergence, named examples (Slack 2,000 messages, Airbnb two-way review, HubSpot first form), "first-value event", refusing UX-milestone substitution |
| `retention-cohort-curves-over-blended-rates` | "Cohort retention curves vs blended rate", per-cohort table by signup week/month, NDR / T2D3 require cohort decomposition, slope-change detection, asymptotic retention, refuse to read blended without the cohort decomposition behind it |
| `behavioral-expansion-signals-beat-tenure` | "Expansion (trigger / signal / score)", "behavioral signal beats tenure", tenure-based expansion is the wrong primitive, usage curve > calendar, adoption-breadth + value-event-density + threshold-crossing, "day 21 ready vs day 90 stuck" |
| `churn-prediction-vs-churn-diagnosis` | "Diagnose (before / then / first) predict", churn driver ranked by "coverage × addressability", save calls fight symptoms, "cohort-level driver", "loyalty deficit", population-level cause vs account-level intervention, "treadmill" |
| `trigger-events-beat-cadence-blast` | "Trigger window" (60-90 day), "why-now anchor / frame", "event-based personalization (not bio)", "bio facts are stale", 10-K passage / earnings-call quote / exec-hire announcement as opener, multithread inside the fresh trigger window |
| `account-not-lead-as-unit` | "Account is/as the unit (of pursuit)", "MQL is GTM debt" / "tear down the MQL funnel" / "MQL funnel", TEAM (Target → Engage → Activate → Measure), 1-to-1 / 1-to-few / 1-to-many tier model, stakeholder map per account, account-fit dominates persona-fit |
| `rhythm-beats-blast` | "Rhythm beats blast / burst / episodic", "burst-and-quiet" anti-pattern, 30-day rule, channel + content rotation per touch, distinct content gates, "just checking in" as filler-touch tell, pursuit-not-chase at the org level |
| `status-quo-is-the-real-objection-outbound` | Setup → Follow-Through sequence architecture, "the unstated objection" / "we're fine" as the no-decision reply, cost-of-inaction before alternative, discovery-before-pitch in the first 3-4 touches, alternative-anchored opener, no-decision rate as sequence-quality metric |
| `raskin-narrative-five-act` | "Name the change", "raise the stakes", "promised land", "name the obstacles" / "obstacles to a new game", "pitch the resolution" / "Setup-Follow-Through", five-act audit, "1-3 word change" |
| `jtbd-as-buyer-mental-model` | "Help me [verb] [object] when [situation]", switch interview, forces of progress / forces of resistance, outcomes per job, "hire the product", "job is the unit" |
| `tf-idf-themes-from-customer-language` | "Customer language", "verbatim", message mining, TF-IDF / noun-phrase frequency, "words they use", "marketer paraphrase" warning |

Patterns added later either get hand-tuned signatures (preferred) or fall back to a heuristic in `_pattern_fallback_signature()` that derives a regex from the pattern's title. Add hand-tuned entries when authoring a new pattern; the fallback's accuracy is "directionally right, often false-positive" — fine for soft-fail mode, sharper signatures earn hard-fail mode.

## See also

- `knowledge/contradictions/INDEX.md`, where credible operators disagree, and what conditioning picks the right position.
- `PRINCIPLES.md`, the slow layer the patterns reinforce.
- `skills/README.md`, the skill registry that operationalises the patterns.
- `routines/README.md`, the recurring loops that close the patterns into practice.
- `ORIGIN.md`, how substrate came to be codex-grounded.
- [pat_outcomes-tied-pricing](outcomes-tied-pricing.md)
- [pat_brier-priced-engagement](brier-priced-engagement.md)
