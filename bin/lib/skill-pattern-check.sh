#!/usr/bin/env bash
# skill-pattern-check.sh — behavioral enforcement for `patterns_grounded`
#
# The runtime gap this closes:
#
#   PRINCIPLES.md rule 9 says every skill grounds in patterns. The preflight
#   library (`skill_check_patterns`, bin/lib/skill-preflight.sh:122-134) only
#   verifies the named pattern files exist on disk. The pattern body reaches
#   the model as input, and the runtime then trusts the model. A skill can
#   pass with output that ignores every pattern it lists.
#
#   This file checks the *output side*: does the produced asset evidence
#   the patterns the skill claims to ground in?
#
# Public functions:
#
#   pattern_extract_signature <slug>
#     Extract a behavioral signature for the named pattern. The signature is
#     not a generic noun-phrase pull; each Tier-A pattern has a hand-tuned
#     signature derived from its `## Implication` and `## Convergence`
#     load-bearing phrases. Patterns without an explicit signature fall back
#     to a heuristic extraction.
#
#   pattern_check_applied <asset> <slug>
#     Scan the asset for the pattern's signature. Print the matched fragment
#     when found. Return 0 (signature present) or 1 (absent).
#
#   pattern_check_all <asset> <skill>
#     Read the skill's `patterns_grounded`, run pattern_check_applied for each.
#     Report which patterns are evidenced vs missing on stderr. Return 0 if
#     all present, 1 otherwise. Sets PATTERN_CHECK_MISSING (newline list).
#
# Calibration philosophy:
#   - Multiple acceptance signals per pattern (a literal phrase OR a structural
#     element OR a load-bearing noun pair). One-of-N matches is enough.
#   - Asset-side evidence: prefer the asset's body, not its frontmatter.
#   - Forgiving: paraphrase counts when the load-bearing token appears.
#   - Sharp: vague nouns alone do not count — pair them with a verb or context.
#
# Sourced by: skills/pre-publish-check/bin/preflight (Gate 9).

set -uo pipefail

# Backwards-compat: accept FLYWHEEL_ROOT as deprecated alias for SUBSTRATE_ROOT.
if [ -n "${FLYWHEEL_ROOT:-}" ] && [ -z "${SUBSTRATE_ROOT:-}" ]; then
  SUBSTRATE_ROOT="$FLYWHEEL_ROOT"
fi
: "${SUBSTRATE_ROOT:?SUBSTRATE_ROOT must be set (substrate repo root)}"
PATTERNS_DIR="$SUBSTRATE_ROOT/knowledge/patterns"

# State exported by pattern_check_all
PATTERN_CHECK_EVIDENCED=()
PATTERN_CHECK_MISSING=()

# ---------------------------------------------------------------------------
# Hand-tuned signatures per pattern.
#
# Each entry is a `|`-separated list of regex alternatives. A signature hits
# when ANY alternative matches the asset body (case-insensitive). Regexes
# follow extended-regex (grep -E) syntax.
#
# These were calibrated by reading every `## Implication` and `## Convergence`
# section in knowledge/patterns/. The chosen tokens are the ones an asset that
# *applies* the pattern is hard to write without using.
# ---------------------------------------------------------------------------

pattern_signature_for() {
  local slug="$1"
  case "$slug" in
    diagnose-before-execute)
      # Structural: a Diagnosis/Audit/Understanding section before any Plan/
      # Recommendation/Deliverable section (handled by _pattern_diagnose_structure_check).
      # Narrative: load-bearing phrases that signal the diagnose-first stance.
      # We deliberately avoid bare "diagnostic" / "diagnosis" — those false-positive
      # on casual mentions. The pattern's actual signature is the *refusal* to
      # produce the deliverable until the diagnosis is shared.
      echo "refuse the (playbook|deliverable|ask)|playbook ask|three divergent|3 divergent (PR-FAQs?|paths)|divergent paths|diagnos(is|tic) (artifact|first|brief|before)|understand[- ]work|understand[- ]first|going to bedrock|go to bedrock|DATE framework|understand.*then.*identify|understand.*identify.*execute|here'\''s what.*actual problem|3 divergent PR-FAQs?"
      ;;
    aeo-triangle)
      # Three-layer measurement (presence/readiness/impact), passage-grain,
      # citation-vs-mention, manual-action, slop loop, AEO as GTM capability.
      echo "presence.*readiness.*impact|three[- ]layer|passage[- ]grain|passage[- ]level|citation.*mention|mention.*citation|ghost[- ]citation|manual[- ]action|slop[- ]loop|AEO.*GTM capability|AEO triangle"
      ;;
    agent-first-gtm)
      # Cross-functional pod, single mandate, named agents per JTBD,
      # rebuild-not-bolt-on, system of action, NL deal questions.
      echo "cross[- ]functional pod|single mandate|named agents|rebuild.*not.*bolt[- ]on|don'?t bolt[- ]on|system of action|natural[- ]language deal|deal[- ]question access|agent[- ]first GTM"
      ;;
    agents-mapped-to-jtbd)
      # JTBD list before agents, named human checkpoint, trust tier ladder,
      # CASH/CCCD loop, Spiegel/Farooq taxonomy, wiring diagram.
      echo "JTBD list|named human checkpoint|human checkpoint|trust tier|trust[- ]tier ladder|wiring diagram|CASH|CCCD|Spiegel|Farooq|progressive trust|review[- ]all.*spot[- ]check|spot[- ]check.*exception[- ]only"
      ;;
    agents-as-product-users)
      # Agents as first-class users, machine customers, structured output for
      # agent consumption, dual-audience design, MCP/llms.txt/.well-known.
      echo "first[- ]class users?|machine customer|machine[- ]customer|structured output|MCP server|llms\\.txt|\\.well[- ]known|dual audience|design for output|agent consumption|natural[- ]language interface"
      ;;
    context-not-capability)
      # Context (not model/capability) is the bottleneck; .claude/ as deployed
      # artifact; greppable wiki; prune as models improve; first investigate
      # the context, not the prompt.
      echo "context (is|as) the bottleneck|not (the )?capability|context (curat|compound)|\\.claude/|deployable artifact|investigate the context|wiki.*own|own.*wiki|greppable.*context|prune.*context|tribal knowledge|encode.*greppable"
      ;;
    distribution-as-moat)
      # Distribution-as-moat, earned-channel, algorithm-rented vs earned,
      # rebrands are cosmetic, source content from frontline.
      echo "distribution.*moat|moat.*distribution|earned channel|algorithm[- ]rented|rented vs earned|rebrand.*cosmetic|cosmetic.*not growth|frontline conversation"
      ;;
    frontline-as-pmm-substrate)
      # Frontline (sales/CS/JTBD) as substrate, written cadence, log-the-call,
      # 3S content (Sales/Success/Support), Hsieh rotation, weekly customer calls.
      echo "frontline (contact|substrate|conversation)|written cadence|log[- ]the[- ]call|logged conversation|sales/success/support|3S content|customer calls|switch interview|JTBD interview|live (sales|customer) call"
      ;;
    narrative-as-strategy)
      # Narrative drift audit, name the shift in 1-3 words, world-shift,
      # old-game/new-game, narrative is the strategy, monthly audit across
      # surfaces.
      echo "narrative[- ]drift audit|name the shift|world[- ]shift|old game.*new game|new game.*old game|narrative IS strategy|narrative is the strategy|drift audit|across surfaces|1-3 word"
      ;;
    status-quo-is-the-competitor)
      # No-decision is the real competitor, status-quo bias, switching cost,
      # 2x value lift, problem-worth-solving, Setup-Follow-Through.
      echo "status[- ]quo.*competitor|no[- ]decision|status[- ]quo bias|loss aversion|2x switching|switching cost|setup.*follow[- ]through|problem (is|worth) (real|solving)|world[- ]shift|cost of inaction|use[- ]case epiphany"
      ;;
    buyer-mindset-not-product-features)
      # Buyer mindset (no-problem, implied, explicit, FOMU), Rackham SPIN,
      # Voss tactical empathy, Moesta forces of progress, JOLT for indecision.
      echo "buyer mindset|no[- ]problem.*implied|implied[- ]need|explicit need|FOMU|JOLT|tactical empathy|forces of progress|switch interview|push.*pull.*anxiety.*habit|mindset diagnos"
      ;;
    differentiation-vs-sameness)
      # Three checks (different + better + matters viscerally), live pitch,
      # external audience.
      echo "three checks|differentiation checks|different\\?.*better\\?|better\\?.*matters\\?|matters viscerally|external audience|live pitch|sameness perception|differentiation barrier"
      ;;
    specificity-becomes-profitable)
      # Segment specificity, narrowest viable niche, AI-spun segment LPs,
      # one-price/one-offer leaves 5x.
      echo "segment[- ]specific|narrowest viable niche|narrow.*niche|specific(ity)? becomes profitable|spin up segment|segment[- ]specific landing"
      ;;
    eval-as-data-analysis)
      # 100+ traces, open-code, axial-code, LLM-as-judge, binary rubrics,
      # 100% production threshold, single trusted taste owner, eval shop.
      echo "100\\+ traces?|sample 100|open[- ]code|axial[- ]code|LLM[- ]as[- ]judge|binary rubric|binary T/F|trusted[- ]taste|eval shop|100% (threshold|production)"
      ;;
    measurement-correlated-short-signals)
      # Absolute counts beat stage rates, 30-day proxy, 7-day correlated proxy,
      # pre/post if no sample size, holdout test.
      echo "absolute count|stage rate|count.*not rate|optimi[sz]e count|correlated.*proxy|7[- ]day proxy|30[- ]day (proxy|sample)|pre/post|holdout|year holdout|evaporation"
      ;;
    quality-as-growth-lever)
      # Cohort retention not first-step conversion, qualifying friction,
      # brand and quality compound, friction-as-feature.
      echo "cohort retention|first[- ]step conversion|qualifying friction|friction[- ]as[- ]feature|brand and quality|quality (is|as) (a )?growth (lever|metric)|right friction|wrong friction|reintroduce.*friction"
      ;;
    make-implicit-explicit)
      # Explicit-naming ritual, kill criterion, confidence label, uncertainty
      # UI, name the assumption.
      echo "explicit[- ]naming|name the (assumption|kill|confidence)|kill criterion|confidence label|uncertainty UI|implicit.*explicit|make.*explicit|name what'?s implicit"
      ;;
    verification-as-human-job)
      # Feedback path, transcript-level evidence, runs that worked vs didn't,
      # logging vs learning, reviewable + reversible.
      echo "feedback (path|signal|store)|transcript[- ]level|runs that worked|worked vs (runs that )?didn'?t|logging.*not learning|logging not learning|reviewable.*reversible|verification (path|gate)"
      ;;
    economic-turing-test-rev-per-employee)
      # Revenue per operator/employee, outcome-priced agent, undersize teams,
      # Economic Turing Test.
      echo "revenue per (operator|employee|operator-hour)|economic turing test|outcome[- ]priced|undersize|over[- ]invest.*top quartile"
      ;;
    principal-ic-as-force-multiplier)
      # Larson archetypes, glue work, multiplier evidence, others shipping
      # faster, no manager-track ladder.
      echo "Larson|principal IC|principal-IC|staff/principal|glue work|multiplier evidence|others shipping faster|force multiplier|archetype map"
      ;;
    decision-quality-through-process-not-willpower)
      # Independent ratings before debrief, pre-mortem, Munger latticework,
      # circle of competence, lollapalooza, devil's advocate.
      echo "pre[- ]mortem|independent (rating|written) (rating|estimate)|Munger|latticework|circle of competence|lollapalooza|devil'?s advocate|red team|noise (signal|spread)"
      ;;
    specific-knowledge-and-circle-of-competence)
      # Audit specific knowledge, intersection of skills, circle drift,
      # moving intersection.
      echo "specific knowledge|circle of competence|intersection of skills|circle drift|moving intersection|audit.*specific knowledge|inside[- ]circle|outside[- ]circle"
      ;;
    monopoly-economics-differentiation-beats-competition)
      # Thiel (death spiral / monopoly), Onlyness, starving crowd,
      # position around gap not parity.
      echo "Thiel|monopoly economics|death spiral|Onlyness|starving crowd|position around (the )?gap|gap.*not.*parity|parity.*not.*gap|vertical progress"
      ;;
    pricing-as-the-most-leveraged-org-failure)
      # Hire pricing officer, WTP research, NRR > 100%,
      # Leaders/Fillers/Killers, discount discipline.
      echo "pricing (officer|owner)|WTP research|willingness to pay|NRR\\b|net revenue retention|Leaders/Fillers/Killers|Leaders, Fillers, Killers|discount discipline|three[- ]question protocol"
      ;;
    behavioral-pricing-architecture)
      # Multiple tiers/anchor, free entry tier, pain of paying, arbitrary
      # coherence, demand cliffs.
      echo "anchor(ing)? (price|tier)|tier (anchor|architecture)|pain of paying|arbitrary coherence|relativity violation|demand cliff|free (or low[- ]friction )?entry|behavioral architecture|power of free"
      ;;
    llm-as-os)
      # LLM as OS, post-training as moat, commoditize-the-complement,
      # data flywheel, ecosystem positioning.
      echo "LLM[- ]as[- ]OS|LLM as the (OS|operating system)|post[- ]training|moat.*post[- ]training|commodit(ise|ize) the complement|data flywheel|ecosystem positioning|absorbed by.*foundation model"
      ;;
    build-for-next-model)
      # Current model is depreciating asset, quarterly re-baseline, hire
      # builders who rewrite, ceiling moves.
      echo "next model|next[- ]model|current[- ]model scaffold|depreciating asset|re[- ]baseline|quarterly re|ceiling moves|rewrite from scratch|model improves"
      ;;
    sustainability-beats-optimisation)
      # Long-window goals, retention not first-week, durable cohorts.
      echo "long[- ]window|long window|retention.*first[- ]week|durable cohort|sustainability.*optimi[sz]ation|optimi[sz]ation.*sustainability|long[- ]term retention"
      ;;
    research-preview-and-cadence)
      # Research preview branding, seasonal planning, frontier cohort,
      # weekly metric readouts, principle docs replace PRDs.
      echo "research preview|seasonal planning|frontier cohort|weekly metric readout|principle doc|PRD.*replace|replace.*PRD|metric goal"
      ;;
    parenting-meets-leadership)
      # Repair after rupture, MGI (most generous interpretation),
      # behavior not identity, indict behavior not the person.
      echo "MGI\\b|most (generous|charitable) interpretation|repair (after )?rupture|reset.*acknowledge|behavior not identity|indict.*identity|criticize.*public.*criticize.*private"
      ;;
    generalists-with-taste)
      # Generalists with taste, end-to-end, taste as the gate,
      # one deep dimension.
      echo "generalists?.*taste|taste.*generalist|end[- ]to[- ]end|one deep dimension|spiky.*strength|taste (gate|owner)|spiky candidate"
      ;;
    rapport-surfaces-what-research-cannot)
      # Tactical empathy, rapport before research, accusation audit,
      # mirroring + labeling, Voss-style.
      echo "tactical empathy|rapport.*research|accusation audit|mirror(ing)? (and|\\+) label|Voss|Chris Voss|accusation[- ]audit"
      ;;
    sales-as-engineered-system-not-art)
      # Sales as a system, scripted plays, Orlob, SPIN sequence,
      # objection handling matrix.
      echo "sales (is|as) a system|sales engine|engineered (sales )?system|scripted play|SPIN sequence|objection (handling )?matrix|Orlob|sales play"
      ;;
    copywriting-craft-fundamentals)
      # Specific over abstract, kill the darling, cut the unearned word,
      # Hemingway, Saunders.
      echo "specific over abstract|kill the darling|earn its place|cut.*unearned|Hemingway|Saunders|Zinsser|specific.*beat.*abstract"
      ;;
    market-and-offer-beat-funnel-optimisation)
      # Market beats offer beats funnel; if market is wrong, no funnel saves you;
      # offer architecture > funnel optimisation.
      echo "market (>|beats|over) offer|offer.*beats? funnel|funnel optimi[sz]ation|market.*then.*offer|wrong market|right market|offer architecture"
      ;;
    ai-defensibility-comes-from-non-ai)
      # Defensibility from non-AI; data, distribution, brand, integration;
      # not from the model itself.
      echo "non[- ]AI defens|defensibility (comes )?from non[- ]AI|moat.*not.*model|distribution.*brand.*integration|data.*distribution.*brand|model is not the moat"
      ;;
    execution-cheap-judgement-scarce)
      # Execution cheap / collapsing / free; judgement scarce / doesn't compress;
      # spec-writing + verification stay expensive; structurally scarce asset.
      echo "execution (is )?(cheap|free|collapsing|becoming free)|judg[e]?ment (is )?(scarce|doesn'?t compress|the scarce)|judg[e]?ment.*compress|taste (premium|scarcity|stays human)|spec[- ]writing.*verification|structurally scarce|scarcity supercycle|middle.*hollow|AI multipl(ies|ying) execution|multiply execution|production cost.*collaps|verification.*new human|outsource thinking"
      ;;
    substrate-runs-loop-humans-run-alignment)
      # Inner loop / outer loop split; humans run alignment, kill criteria,
      # taste calls, eval structure; resist queue.
      echo "inner loop.*outer loop|humans (run|own) alignment|substrate runs the loop|alignment design|kill criteri|named taste call|resist (the )?queue|eval structure|approval throughput"
      ;;
    subtraction-first-operating-discipline)
      # Subtraction-first, cut before adding, fewer surfaces, kill before ship.
      echo "subtraction[- ]first|cut before add|kill before ship|fewer (surfaces|moving parts)|remove before add|subtract.*before add"
      ;;
    creative-fatigue-window)
      # Refresh cadence is the lever (not bidding); fatigue thresholds (CTR
      # decline, frequency, CPM rise); creative volume target; weekly/daily
      # production cadence as the upstream cause of CAC drift. Bare
      # "creative fatigue" is too generic (industry vocab), so we require
      # coupling to a threshold/cadence/window/lever/volume claim.
      echo "refresh cadence|fatigue threshold.{0,80}(CTR|CPM|frequency|trip|peak|decline|14 day|defin|campaign)|creative[- ]fatigue (cycle|window|curve)|creative (refresh|rotation) (cadence|cycle)|creative (volume|production) (target|cadence|requirement)|new[- ]creative volume|10\\+ creatives|2-4 (new )?variants?|frequency above 3|CTR decline|fatigue (window|cycle)|fatigues? on a (measurable )?window|asset[- ]led structure|weekly cadence on creative"
      ;;
    channel-arbitrage-window)
      # 6-18 month arbitrage window, channel-product fit, 70/20/10 budget split,
      # decay curve, saturation indicators, rotate-ahead-of-saturation.
      echo "arbitrage (window|tax|closes|asymmetry)|channel arbitrage|saturation (indicator|curve)|channel[- ]product fit|channel choice.*half[- ]life|quarterly (channel mix|channel review|strategic channel)|channel mix every (90|60|180) days|70[-/ ]?20[-/ ]?10 (split|allocation)|decay curve|CPM trajectory.{0,30}(YoY|year)|share[- ]of[- ]voice.*category|rotate (ahead of|before).*saturat|window (closes|closing)|under[- ]exploited channel|new channel.*(6 (to )?18|six.*eighteen)|6.{0,5}18[- ]month|early.*cohort.*CAC|late[- ]entry.*tax|channel saturation"
      ;;
    intent-vs-interest-targeting)
      # Search buys intent vs paid social buys interest; See/Think/Do/Care
      # mapping; demand-capture-vs-demand-generation metrics; assisted
      # conversions, branded-search lift; separate dashboards / budgets per
      # channel; refusing the same KPI across both surfaces. Bare
      # "intent vs interest" is too easily said casually; the load-bearing
      # form pairs the dichotomy with the channel(s).
      echo "search (ads )?buys (intent|the query)|paid social buys interest|search.{0,20}buys.*intent|google.{0,15}intent.{0,30}meta.{0,15}interest|See/Think/Do/Care|See, Think, Do, Care|demand[- ]capture (channel|metric|ratio)|demand[- ]generation (metric|measure|KPI)|assisted conversions?|branded[- ]search lift|cohort[- ]level CAC|last[- ]click (CAC|undercount|attribution.*social)|separate (the )?(dashboards?|budgets?).{0,30}(search|social|channel)|intercept.{0,15}(existing )?demand|shape of demand|search.*social.*different|different (funnels|unit economics)|hold(ing)? (both )?channels to the same KPI|See[- ]stage (channel|KPI)"
      ;;
    incrementality-not-attribution)
      # Incrementality testing as the only credible cross-channel measure; geo
      # holdout, ghost ads, conversion-lift study, MMM; refuse blended CAC
      # without an attribution-model footnote; ROAS vs incremental divergence.
      echo "incremental(ity)?[- ]ad|incrementality (test|study|measur)|geo[- ]holdout|geographic holdout|conversion[- ]lift (study|test)|ghost ads?|matched[- ]market|MMM\\b|marketing mix model|blended CAC.*(footnote|model|assumed|hides|undercount|undercounts|noise)|(refuse|no).{0,15}blended CAC|attribution[- ]model footnote|attribution overcount|model.{0,30}explicit|attribution.*(causality|sequence)|reported.*incremental.*diverge|2x to 5x|ROAS (divergence|reported.*incremental)|holdout (test|window)|incrementality[- ]adjusted"
      ;;
    engagement-decay-as-relevance-signal)
      # Relevance hypothesis tested before deliverability; gradual taper vs
      # sudden cliff diagnostic shape; permission as renewing contract;
      # deliverability dashboards as downstream signal; segmentation > list
      # hygiene as the upstream lever.
      echo "relevance (hypothesis|hypothesis is tested|first|break|drives engagement|lever)|relevance (vs|over|before) deliverability|deliverability (vs|over) relevance|deliverability.*downstream|gradual taper|sudden cliff (across|all sequences)|engagement decay|decay (shape|signal|order)|broadcast nurtures? (decay|underperform|are|loses?|function)|audit the trigger.*not the body|trigger.*stale event|engagement.*permission|permission (renew|contract|revoke)|inbox placement (lag|signal|shap)|relevance.*drives.*engagement|engagement.*shapes.*inbox|test segmentation against the same content|deliverability dashboards? (are|turn red).*(downstream|after|already)"
      ;;
    sender-reputation-is-a-domain-asset)
      # Domain reputation as multi-year compounding asset; SPF/DKIM/DMARC at
      # domain level; refuse burn-and-rotate; subdomain sprawl audit;
      # organizational domain as policy unit (RFC 7489). Bare "sender
      # reputation" is the symptom-noun (anyone in email-ops uses it); the
      # load-bearing form is the domain-not-IP framing.
      echo "domain reputation|sending domain (itself|persists?|inherits?|like a brand|as|is the (asset|unit)|over (years|time))|sending domain.{0,40}(brand|reputation|asset|years|persist|compound|long[- ]term)|sender reputation accrues|sender reputation.{0,40}(domain|IP|compounds|asset|accrues)|DMARC|SPF.*DKIM|burn[- ]and[- ]rotate|don'?t (burn|rotate).*domain|subdomain (sprawl|hierarchy|isolation)|organizational domain|domain (level|asset|history)|multi[- ]year.*asset|compounding asset|domain (is|as) (the )?(unit|asset)|domain.*brand decision|RFC 7489|inherit(s|ed) reputation"
      ;;
    one-segment-one-trigger)
      # Smallest viable lifecycle unit = cohort × trigger; refuse
      # broad-list-broadcast nurture; trigger-first design discipline; trigger
      # fire-rate metric; JTBD progress moment as the trigger primitive.
      # Bare "broadcast nurture" is too generic (industry vocab); the
      # load-bearing form is the refusal/decay/underperform claim.
      echo "cohort.{0,5}trigger|smallest viable (lifecycle|unit)|one cohort.*one trigger|broad[- ]list[- ]broadcast|broadcast nurtures? (decay|underperform|loses?|are|function|fail)|refuse the broadcast|trigger[- ]first|cadence[- ]first|trigger fire[- ]rate|cohort definition.*before|JTBD progress moment|behavior(al)? trigger|triggered (vs|over|outperform.*) broadcast|broadcast.*function as floor noise"
      ;;
    subject-line-as-experiment-not-art)
      # Subject lines as testable hypotheses (not creative writing); message-
      # mining / review-mining for source language; cohort-scoped tests with a
      # statistical bar set before send; document the hypothesis not the winner.
      echo "subject line.*hypothes|subject lines? (are|as) (testable )?hypothes|message[- ]mining|review[- ]mining|cohort[- ]scoped (test|experiment)|statistical (bar|floor|threshold)|baseline open rate|set the (statistical )?bar (before|first)|document the hypothesis|hypothes.*not (just )?(winner|template)|catchy.*wrong (unit|question)|subject.*not (creative|art|craft)|mine.*from (substrate|VoC|customer language)|treat each subject as a (cohort|hypothes|experiment)"
      ;;
    aha-moment-defines-activation)
      # Aha moment defined by retention-curve segmentation, not UX milestone;
      # candidate value events tested against curve divergence; named examples
      # (Slack 2,000 messages, Airbnb two-way review, HubSpot first form);
      # activation event as the load-bearing primitive for downstream skills.
      echo "aha (moment|event|metric).{0,30}(activation|retention|curve|defines|lift|event)|activation (event|moment).{0,30}(curve|retention|defines|window|behavior|test)|retention[- ]curve (segmentation|divergence|lift)|candidate (value )?event|curve[- ]segmentation|sharpest divergence|hit in window N|two-way review|2,000 messages|first form created|habit[- ]forming event|UX milestone (substitut|vanity)|name(d|s) the activation (event|moment)|activation.*not.*UX (checklist|milestone)|first[- ]value event"
      ;;
    retention-cohort-curves-over-blended-rates)
      # Cohort retention curves vs blended rate; per-cohort table as floor
      # artifact; signup-cohort segmentation surfaces acquisition drift;
      # NDR / T2D3 require cohort decomposition; slope-change detection.
      echo "cohort retention|blended retention|cohort (curve|table|view|decomposition)|retention curve|by signup (cohort|month|week)|cohort.*per (period|window)|NDR\\b|net dollar retention|T2D3|slope[- ]change|signup cohort|acquisition (drift|cohort)|cohort.*diverge|read.*per cohort|asymptotic retention|cohort[- ]segment(ed|ation)"
      ;;
    behavioral-expansion-signals-beat-tenure)
      # Behavior beats tenure as expansion-timing primitive; expansion-signal
      # score per account; threshold crossing on usage tier; willingness-to-pay
      # tracks usage curve, not calendar; day-21 ready vs day-90 stuck. Bare
      # "day 21" / "day 90" is too generic; require the behavioral coupling.
      echo "expansion (trigger|signal|score)|behavior(al)? (signal|trigger).{0,40}(expansion|tenure|upsell)|tenure[- ]based (expansion|upsell)|usage curve|willingness[- ]to[- ]pay.*usage|adoption[- ]breadth|threshold[- ]crossing|seat (or )?workspace growth|value[- ]event density|score[- ]band|day 21.{0,40}(ready|expand|behavior|adopt|signal)|day 90.{0,40}(stuck|never adopted|low adoption|adopt|tenure|behavior|growth|churn)|behavior beats? (tenure|calendar)|tenure (is the wrong|secondary)"
      ;;
    churn-prediction-vs-churn-diagnosis)
      # Diagnose churn at cohort level before predicting at account level; rank
      # drivers by coverage × addressability; save calls fight symptoms while
      # the upstream loyalty deficit keeps generating churn. Bare "save call"
      # is too generic (CS vocab); the load-bearing form is the
      # symptom-vs-driver framing.
      echo "churn (diagnos|driver)|diagnos(is|e) (before|then|first).*predict|prediction (without|silent on)|save calls? (fight|do not|loses?|symptom|treadmill|secondary)|cohort[- ]level driver|driver.*ranking|coverage.*addressability|addressability.*coverage|why (accounts|customers) (in )?(this )?cohort|loyalty deficit|loyalty system|loyalty theory|symptom.*upstream|treadmill|fight(ing)? symptom|root cause.*churn|population[- ]level (driver|cause)|guess[- ]substrate"
      ;;
    trigger-events-beat-cadence-blast)
      # Trigger windows (60/90 day) as the relevance anchor; "why-now" required
      # on every touch; multi-thread inside the window; personalization from
      # event (10-K, earnings call, exec hire) not bio facts.
      echo "trigger[- ]event window|trigger window|trigger.{0,30}(60|90|30|120)[- ]?day|trigger detection (system|feed|service)|why[- ]?now (anchor|frame|justif|signal)|every (outbound )?touch.*why[- ]?now|event[- ]based personali[sz]ation|personali[sz]ation.{0,30}(event|not bio)|bio (fact|opener).*(stale|wasted)|10[- ]K (passage|language|quote|opener)|earnings[- ]call (quote|opener)|exec hire (announcement|window|trigger)|funding round (press|window|trigger)|multithread.{0,30}(trigger|window|fresh)|fresh (funding|trigger|exec[- ]hire) window|cohort accounts by trigger"
      ;;
    account-not-lead-as-unit)
      # Account replaces lead as unit of pursuit; MQL funnel = GTM debt; tiered
      # depth (1-to-1, 1-to-few, 1-to-many); stakeholder map per account;
      # account-fit dominates persona-fit in scoring weight. Bare "TEAM" is
      # too generic; require the framework expansion (Target → Engage →
      # Activate → Measure) inline.
      echo "account[- ]as[- ]unit|account.{0,15}(is|as) the unit|MQL.*GTM debt|MQL funnel.{0,40}(GTM debt|tear|down|debt|reject|replace|rewards|wrong|underweight|optimize|broken)|tear (down|the) (MQL|funnel)|TEAM \\(Target|Target.{0,12}Engage.{0,12}Activate.{0,12}Measure|1-to-1.*1-to-few|1-to-few.*1-to-many|stakeholder map (per|per account)|account[- ]fit (score|weight)|engaged accounts|6-?10 stakeholders|economic buyer.*decision[- ]makers|ABM (tier|depth)|account replaces lead|persona[- ]fit (residual|secondary)"
      ;;
    rhythm-beats-blast)
      # Consistent 30-60-90 rhythm vs burst-and-quiet; channel + content
      # rotation per touch; distinct content gates; "just checking in" as
      # filler-touch tell; pursuit-not-chase at the org level. Bare "channel
      # rotation" or "content gate" leak into Slack-ops talk; require the
      # paired/distinct/per-touch coupling.
      echo "(consistent )?rhythm.*blast|rhythm beats? (blast|burst|episodic)|burst[- ]and[- ]quiet|burst[- ]and[- ]purge|30[- ]day rule|30\\+? day (cadence|rhythm|window)|distinct content gates?|content gate (progression|sequence|per touch|hits|inside cadence)|gate progression|channel (\\+|and) content rotation|channel rotation \\+ content|channel rotation.{0,40}content rotation|channel.{0,20}content rotation per touch|just checking in|pursuit (not |over )chase|cadence (design|gate|discipline)|8[- ]?12 touches?|distinct content per touch|rep.*org level rhythm"
      ;;
    status-quo-is-the-real-objection-outbound)
      # The unstated objection in outbound is "we're fine"; Setup → Follow-
      # Through sequence architecture; cost-of-inaction before alternative;
      # discovery-before-pitch in the first 3-4 touches; no-decision rate as
      # sequence-quality metric.
      echo "Setup (.|→|->|then) Follow[- ]Through|Setup[- ]Follow[- ]Through|status[- ]quo.*(objection|real|outbound)|the unstated objection|\"we'?re fine\"|\"we are fine\"|we'?re fine as[- ]is|no[- ]decision (rate|bucket|reply|majority)|cost of inaction (touches|surface|frame|first)|cost of (the )?(current state|old game)|alternative[- ]anchored|opener.*(references? the )?alternative|discovery (before|over) pitch|first 3-?4 touches.*discovery|world changed.*old game|new game.*shape|setup phase.*follow[- ]through|sequence-quality metric|alternatives? being load[- ]bearing"
      ;;
    # ------------------------------------------------------------------------
    # Sprint-2 patterns (analytics, social, support, stubs deepening)
    # ------------------------------------------------------------------------
    metric-tree-not-metric-stack)
      # Metrics organize as a tree (root = north-star, branches = inputs,
      # leaves = behavioral leading indicators). Flat "metric stack" or twelve-
      # KPI dashboard is the failure mode. Reforge growth-model curriculum.
      echo "metric[- ]tree|metrics? (organize|organise|sit) as a tree|north[- ]star.*(branch|input|leaf|leaves)|(branches?|leaves?).*(branches?|leaves?).*(input|behavioral)|tree (is|IS) the strategy|draw the tree|node (of|in) the tree|growth model (curriculum|tree)|growth loops?|metric stack|flat (metric|dashboard|list|KPI)|noise dashboard|twelve[- ]KPI|four fits"
      ;;
    event-taxonomy-as-product-knowledge)
      # Event schema as product knowledge / API contract. Tracking plan as
      # deliverable. object_action snake_case naming. Schema-as-code. Audit
      # for drift (declared-but-unfired, fired-but-undeclared, near-duplicate).
      echo "event taxonomy|tracking plan|events?\\.yaml|schema[- ]as[- ]code|schema before code|object_action|snake_case|tracking schema|taxonomy.*contract|owned and gated|near[- ]duplicate (event|name)|undeclared event|fired but undeclared|declared but unfired|analytics[- ]engineer|Snowplow schema|Iteratively|Avo schema|first[- ]class citizen.*track|tracking[- ]plan as a first-class citizen"
      ;;
    goalpost-discipline-vs-metric-drift)
      # Lock the measurement contract before goal opens. Frozen definition.
      # Metrics covenant. Mid-quarter override logged with attribution. The
      # Reichheld NPS-instrument-discipline analogy.
      echo "measurement contract|lock.*(before|prior to).*(open|goal opens)|metric (drift|covenant)|metrics covenant|frozen (definition|metric|contract|cohort)|goalpost (discipline|drift)|definition (creep|drift|shifts)|cohort definition.*(shift|drift)|attribution window.*(flex|drift)|retention.*(definition|standardiz)|retroactive narrative|silent edit|change[- ]note|standardiz(e|ed) (retention|definition)|honest retention|pre[- ]frozen|the contract is what makes"
      ;;
    segment-of-one-vs-cohort-aggregate)
      # Both views needed: aggregate for shape (cohort curves, funnels),
      # segment-of-one for mechanism (user-record paths, session replays,
      # ticket reads). 10/90 rule, HiPPO, qualitative grounding.
      echo "segment[- ]of[- ]one|user[- ]record (path|level|analysis|narrative)|session replay|10/90 rule|aggregate.*mechanism|cohort.*user[- ]path|aggregate.*shape.*(mechanism|user)|both views|switch deliberately|qualitative grounding|HiPPO|sit (with|next to) (a CSM|the user)|watch real users|fact-?check the other|disagreement is signal|partial substrate"
      ;;
    native-format-beats-cross-post)
      # Each platform has native rhythms; cross-posting decays. Ideas portable,
      # format not. Authoring lane per platform. LinkedIn opener length,
      # X thread shape, TikTok hook window.
      echo "cross[- ]post(ed|ing|s)?|native (format|authoring|rhythm|shape|variant)|platform[- ]native|the rewrite is the work|ideas are portable|format[- ]decay|authoring lane|line break density|hook[- ]payoff|opener length|pattern interrupt|hook window|shared idea register|distribution port|distribution channel for a primary|per[- ]platform (cadence|performance)"
      ;;
    creator-not-corporate)
      # Personal accounts outperform corporate handles 5-to-1 to 20-to-1 on
      # B2B social. Trust flows to people; logos carry information not trust.
      # Employee advocacy as enterprise frame. Founder-led distribution.
      echo "personal account|corporate handle|creator[- ](led|economy)|trust flows to people|trust to (logos?|brands?)|trust accrues to|logos can carry information|employee advocacy|founder[- ]led (social|brand|distribution|account)|cost cent(re|er)|brand account|named operators?|warm outbound from (personal|founder)|5[- ]to[- ]1 to 20[- ]to[- ]1|asset class.*operating expense"
      ;;
    social-as-distribution-not-conversion)
      # Social is top-of-funnel awareness; last-click underweights it 50-80%.
      # Track cohort-level metrics (branded-search lift, audience overlap,
      # newsletter conversion), not last-click CAC.
      echo "last[- ]click (CAC|attribution)|branded[- ]search lift|direct[- ]traffic lift|content distribution flywheel|warming.*not.*convert(ing|er|s)?|warming.*(channel|surface)|social (drives|is) (top[- ]of[- ]funnel|awareness)|paid[- ]acquisition ceiling|cohort[- ]level (metric|attribution)|social copy.*conversion copy|warmth.*conversion|audience overlap with closed[- ]won|undercount(ing|s) social|starve(s|d|ing) (a |the )?awareness"
      ;;
    tickets-are-product-feedback-channel)
      # Support is product. Tickets are highest-fidelity feedback. Read
      # verbatim, cluster, feed upstream into roadmap/onboarding/positioning.
      # Reverse failure: tickets categorized for routing, content never crosses
      # the support team boundary.
      echo "support is product|tickets? are (a |the )?(product|feedback) (brief|channel|knowledge|substrate)|read (the )?tickets verbatim|ticket clusters?|every ticket gets read|compounding (knowledge|fluency)|ticket corpus|highest[- ]fidelity feedback|support reads like a product brief|cluster.*by theme|verbatim (language|fluency).*support|support[- ]team[- ]only artifact|product brief.*written daily"
      ;;
    deflection-is-not-the-goal)
      # Right-routing, not deflection. Effort score, channel-forcing,
      # subscription renewal moment. Four-tier ladder (self-serve / community
      # / chatbot / human). Deflection as side effect, not goal.
      echo "right[- ]routing|deflection (is not|isn'?t) (the )?goal|deflection[- ](as[- ]goal|maximization)|channel[- ]forcing|customer effort|effort score|cheapest channel that.*answers?|cheapest renewal call|right answer in the right window|four[- ]tier ladder|self[- ]serve.*community.*(chatbot|bot).*human|escalation rate is the truth|deferred churn signal|loyalty erosion"
      ;;
    support-as-churn-leading-indicator)
      # Support volume + sentiment lead churn 30-90 days. Volume spike,
      # response-time elevation, sentiment proxy, silence-after-engagement,
      # unresolved escalations. Account-level health score.
      echo "leading indicator|30[- ]to[- ]?90 days?|ticket[- ]volume spike|response[- ]time (elevation|rise|rising)|silence[- ]after[- ]engagement|sentiment proxy|account[- ]health score|baseline[- ]deviation alert|support churn score|support volume.*per account|early[- ]warning system|cohort[- ]level diagnostic|silence as signal|support signal leads churn"
      ;;
    raskin-narrative-five-act)
      # Five-act movie structure: name the change / raise the stakes /
      # promised land / name the obstacles / pitch the resolution. Buyer is
      # hero, brand is guide, product is gift. 1-3 word change.
      echo "(five|5)[- ]act (movie|narrative|structure|architecture|audit)|name the change|raise the stakes|promised land|name the obstacles|obstacles to a new game|pitch the resolution|setup.*follow[- ]through|product as (the )?(magic|gift|guide)|customer is the hero|hero.*guide.*magic|narrative spine|world[- ]shift|old game.*new game|1-3 word (change|shift)|StoryBrand"
      ;;
    jtbd-as-buyer-mental-model)
      # JTBD as mental model of the buyer (situation-shaped), not feature
      # framework. Switch interviews, forces of progress / resistance, hire
      # the milkshake. Job statement: "Help me [verb] [object] when [situation]".
      echo "Help me \\[?[a-z]+\\]? \\[?[a-z]+\\]? when|switch interview|forces of progress|forces of resistance|hire (a |the )?(product|milkshake)|jobs?(-| )to(-| )be(-| )done|JTBD (form|interview|canvas)|buyer mental model|job (is|as) the unit|outcome[- ]driven|moment of (first thought|choice)|push.*pull.*anxiety.*habit|situation-shaped|persona[- ]segmentation produces|the unit of (analysis|segmentation|demand) is"
      ;;
    tf-idf-themes-from-customer-language)
      # Customer-language extraction beats marketer-rewriting. TF-IDF on
      # noun-phrases, message mining, words they use, paraphrase last.
      # 50-document corpus minimum per cohort.
      echo "customer language|verbatim (language|phrases?|quote)|TF[- ]IDF|noun[- ]phrase|message mining|marketer (paraphrase|rewrite|language)|words they use|voice of customer|VoC corpus|listen for (words|language)|extract verbatim|paraphrase last|review[- ]mining|copyhackers|highlight every phrase|50[- ]document"
      ;;
    launch-as-coordinated-distribution)
      # Launches are tiered (T1/T2/T3) coordinated multi-channel sequences,
      # not single-day press moments. Research-preview cohort, narrative spine,
      # 30/60/90, measurement contract opened at plan time.
      echo "T1.*T2.*T3|tier (1|2|3) launch|research[- ]preview (cohort|program)|30/60/90|narrative spine|phased cohort|coordinated (multi[- ]channel|distribution|sequence)|frontier program|launch is (a )?(coordinated )?sequence|launch is not (a )?(single[- ]day|moment|press)|measurement contract.*plan time|launch[- ]week multi[- ]channel|stage the cohort|preview cohort.*narrative"
      ;;
    van-westendorp-over-vibes-pricing)
      # Structured WTP research (van Westendorp PSM + Gabor-Granger) over
      # team consensus, founder gut, competitor copying. OPP/IPP curve
      # intersections from 20+ buyer responses. Six-month refresh cadence.
      echo "van[- ]Westendorp|Price Sensitivity Meter|\\bPSM\\b|Optimal Price Point|Indifference Price Point|\\bOPP\\b|\\bIPP\\b|Gabor[- ]Granger|willingness[- ]to[- ]pay|WTP curve|four[- ]question (method|PSM)|too cheap.*expensive.*too expensive|reference price|hold the line on discount|conjoint with price|pricing (page )?(from|by) (research|gut)|opinion pricing|six[- ]month.*pricing"
      ;;
    synthetic-audience-as-pre-publish-floor)
      # Synthetic-audience scoring as cheap pre-publish floor; directional, not
      # magnitudinal. Interview-grounded twins (Park 2024). Refuse on pricing
      # variants and novel product behavior.
      echo "synthetic (audience|panel|twin)|pre[- ]publish floor|directional.*not magnitud(inal|e)|interview[- ]grounded (persona|twin)|generative agent|Park et al|1,?0(00|52) person|85% (accuracy|reliability)|78% (accuracy|individual)|LLM[- ]as[- ]judge|persona file is load[- ]bearing|cheap floor|panel filters|live test (adjudicates|resolves)|grounding quality determines"
      ;;
    passage-as-citation-unit)
      # AI assistants cite passages, not pages. 40-90 word self-contained
      # passages. Schema.org markup (FAQPage / HowTo / speakable). Pair with
      # YouTube + LinkedIn off-domain mirrors.
      echo "passage[- ](extractable|grain|level|as[- ]citation)|40[- ]?(?:to[- ]?)?90 words|self[- ]contained passage|schema\\.org|FAQPage|HowTo schema|speakable|cite (at the )?passage|stand[- ]alone passage|relevance engineering|TL;?DR (up top|at top|at the top)|question (in|as)? (the )?H3|question[- ]explicit|passage shape|extract.*answer.*skip the narrative|page is no longer the unit"
      ;;
    *)
      # Fallback: derive a heuristic signature from the pattern's title and
      # the first noun-phrase in `## Implication`. This catches new patterns
      # that haven't been hand-tuned yet.
      _pattern_fallback_signature "$slug"
      ;;
  esac
}

# Heuristic signature for un-tuned patterns. Reads the pattern's title +
# Implication first sentence, extracts capitalized phrases and verbs.
# Returns a regex (best-effort).
_pattern_fallback_signature() {
  local slug="$1"
  local file="$PATTERNS_DIR/$slug.md"
  [ -f "$file" ] || { echo "$slug"; return; }

  local title
  title=$(awk '
    BEGIN{infm=0}
    NR==1 && /^---$/{infm=1; next}
    infm && /^---$/{infm=0; next}
    infm && /^title:/{sub(/^title:[[:space:]]*/,""); gsub(/^["'\'']|["'\'']$/,""); print; exit}
  ' "$file")

  # Lowercased multi-word substrings of the title (>= 3 letters), joined with |
  local title_l
  title_l=$(echo "$title" | tr 'A-Z' 'a-z' | tr -c 'a-z0-9 ' ' ')
  # Pick distinctive 2-word combos
  local sig
  sig=$(echo "$title_l" | awk '{
    n=split($0, a, " ");
    for (i=1; i<n; i++) {
      if (length(a[i]) >= 4 && length(a[i+1]) >= 4) {
        printf "%s[- ]%s|", a[i], a[i+1];
      }
    }
  }' | sed 's/|$//')
  # Add the slug itself as a fallback signature term (slugs are often spoken
  # aloud in good outputs, e.g. "no-decision" or "AEO triangle").
  if [ -n "$sig" ]; then
    echo "$sig|$(echo "$slug" | tr '-' ' ')"
  else
    echo "$slug"
  fi
}

# ---------------------------------------------------------------------------
# Public functions
# ---------------------------------------------------------------------------

# Print the signature regex for a pattern slug.
pattern_extract_signature() {
  local slug="$1"
  pattern_signature_for "$slug"
}

# Strip frontmatter + skill-internal comment fences before scanning. Mirrors
# what voice-enforce does so signatures hit on body content, not on the
# `produced_by:` / `patterns_grounded:` frontmatter that names them.
_pattern_asset_body() {
  local asset="$1"
  awk '
    BEGIN { infm=0; done_fm=0 }
    NR==1 && /^---$/ { infm=1; next }
    infm && /^---$/ { infm=0; done_fm=1; next }
    infm { next }
    !done_fm { done_fm=1 }
    { print }
  ' "$asset"
}

# Structural check for diagnose-before-execute: a Diagnosis/Audit/Understand
# section must appear before any Plan/Recommendation/Deliverable section.
#
# Implementation note: BSD awk on macOS has no IGNORECASE flag. We pre-fold
# the line via tolower() inside awk, then match against lower-cased patterns.
_pattern_diagnose_structure_check() {
  local asset="$1"
  awk '
    BEGIN { diag_line=0; plan_line=0 }
    {
      lower = tolower($0)
      if (diag_line == 0 && lower ~ /^##+ +(diagnos|audit|understand|discovery|what.{0,4}actually|bedrock|three (divergent|paths)|divergent path|problem analysis)/) {
        diag_line = NR
      }
      if (plan_line == 0 && lower ~ /^##+ +(plan|recommendation|deliverable|proposal|solution|next step|action|implementation|roll[- ]?out)/) {
        plan_line = NR
      }
    }
    END {
      if (diag_line == 0) { print "no-diagnosis-section"; exit 1 }
      if (plan_line == 0) { print "no-plan-section"; exit 0 } # diagnosis-only is fine
      if (diag_line < plan_line) { printf "diagnosis-before-plan (L%d < L%d)\n", diag_line, plan_line; exit 0 }
      printf "plan-before-diagnosis (L%d < L%d)\n", plan_line, diag_line; exit 1
    }
  ' "$asset"
}

# Check whether a single pattern's signature appears in an asset's body.
# Prints the matched fragment on stdout (truncated). Returns 0 (found) / 1.
pattern_check_applied() {
  local asset="$1" slug="$2"
  [ -f "$asset" ] || return 1

  local body
  body=$(_pattern_asset_body "$asset")

  # Special case: diagnose-before-execute also accepts the structural signal.
  # If the asset has a diagnosis section before any plan section, it counts
  # as evidence even without a literal phrase match.
  if [ "$slug" = "diagnose-before-execute" ]; then
    local struct
    struct=$(_pattern_diagnose_structure_check "$asset" 2>&1) || struct=""
    case "$struct" in
      diagnosis-before-plan*|no-plan-section)
        echo "structural: $struct"
        return 0
        ;;
    esac
  fi

  local sig
  sig=$(pattern_signature_for "$slug")
  [ -z "$sig" ] && return 1

  local match
  match=$(echo "$body" | grep -i -E -m1 "$sig" || true)
  if [ -n "$match" ]; then
    # Truncate to ~120 chars for log readability
    echo "${match:0:120}"
    return 0
  fi
  return 1
}

# Run pattern_check_applied for every entry in the skill's patterns_grounded.
# Reports per-pattern result on stderr. Sets PATTERN_CHECK_EVIDENCED +
# PATTERN_CHECK_MISSING. Returns 0 if all evidenced, 1 if any missing.
pattern_check_all() {
  local asset="$1" skill="$2"
  local skill_md="$SUBSTRATE_ROOT/skills/$skill/SKILL.md"
  if [ ! -f "$skill_md" ]; then
    echo "    pattern-check: no SKILL.md for skill='$skill'" >&2
    return 0
  fi

  # Source skill_fm_list from skill-preflight.sh if not already loaded.
  if ! command -v skill_fm_list >/dev/null 2>&1; then
    # shellcheck source=skill-preflight.sh
    . "$SUBSTRATE_ROOT/bin/lib/skill-preflight.sh"
  fi

  local patterns
  patterns=$(skill_fm_list "$skill_md" "patterns_grounded")

  PATTERN_CHECK_EVIDENCED=()
  PATTERN_CHECK_MISSING=()

  if [ -z "$patterns" ]; then
    echo "    pattern-check: skill='$skill' declares no patterns_grounded (rule 9 violation; preflight should have caught this)" >&2
    return 0
  fi

  while IFS= read -r slug; do
    [ -z "$slug" ] && continue
    if [ ! -f "$PATTERNS_DIR/$slug.md" ]; then
      echo "    · $slug: pattern file missing (knowledge/patterns/$slug.md)" >&2
      PATTERN_CHECK_MISSING+=("$slug")
      continue
    fi
    local frag
    if frag=$(pattern_check_applied "$asset" "$slug"); then
      echo "    ✓ $slug: evidenced — \"${frag:0:90}\"" >&2
      PATTERN_CHECK_EVIDENCED+=("$slug")
    else
      echo "    ✗ $slug: no signature match in asset body" >&2
      PATTERN_CHECK_MISSING+=("$slug")
    fi
  done <<< "$patterns"

  if [ ${#PATTERN_CHECK_MISSING[@]} -gt 0 ]; then
    return 1
  fi
  return 0
}
