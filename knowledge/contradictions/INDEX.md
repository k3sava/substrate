---
title: Contradictions layer, when patterns disagree
status: active
last_updated: 2026-05-07
version: 1.0
source: upstream operator-insight library (synthesis/contradictions/)
---

# Contradictions

When 2+ operators with credible track records disagree on a substantive question, codex captures the contradiction. Substrate needs both layers: patterns tell the system *what* to apply when there's convergence; contradictions tell the system *when* to switch when there isn't.

A pattern without a contradiction is a rule. A pattern with a contradiction is a rule with a condition.

## How to read a contradiction

Each file carries:
- **Position A**, the operator and claim.
- **Position B**, the operator and counter-claim.
- **Conditions distinguishing them**, the variables that decide which position applies.
- **Resolution / synthesis**, the reconcilable rule, or the genuinely orthogonal axis.

Substrate uses the conditions field to gate skill behavior. A skill that runs across both positions must read the conditions and pick the right one for the client context.

## Contradictions ledger

| Contradiction | Positions | Conditioning variable | Substrate hook |
|---|---|---|---|
| [Agents-as-team vs agents-as-tools](agents-as-team-vs-agents-as-tools.md) | Vo (team) vs Cherny (tools) | Persistence + heterogeneity of agent's job | `agent-jtbd-map` (skill picks team-shape vs tool-shape per job) |
| [Build quietly vs distribution-first](build-quietly-vs-distribution-first.md) | Younis (quiet) vs Verna/Balfour/Halligan (distribution) | Stage + operator capital + category | `narrative-strategy`, `campaign-strategy` |
| [Circle of competence vs iterative deployment](circle-of-competence-vs-iterative-deployment.md) | Buffett-style vs Bezos-style | Reversibility of the bet | `mental-models`, `open-goal` |
| [Concentrate vs barbell allocation](concentrate-vs-barbell-allocation.md) | Munger (concentrate) vs Taleb (barbell) | Volatility regime + tail risk | `mental-models`, `open-goal` |
| [Criticize in public vs praise public, criticize private](criticize-in-public-vs-praise-public-criticize-private.md) | Open-debate vs psychological-safety | Org maturity + trust capital | `pmm-coaching` |
| [No-decision vs named competitor](no-decision-vs-named-competitor.md) | Dunford (status-quo) vs Klue-style (named comp) | Category maturity + buyer urgency | `status-quo-frame`, `competitive-scout`, `ad-diagnose`, `ad-creative-design`, `ad-spend-allocate` |
| [PM prototype vs PM up-level](pm-prototype-vs-pm-up-level.md) | Build-it-yourself PM vs orchestrator PM | AI-tool fluency + team structure | `pmm-coaching` |
| [Post-training moat vs distribution moat](post-training-moat-vs-distribution-moat.md) | Custom-model moat vs distribution-channel moat | Model-availability curve + category | `narrative-strategy` |
| [Quality as growth vs marginal-user friction removal](quality-as-growth-vs-marginal-user-friction-removal.md) | Naik-style quality bar vs Verna-style funnel ungating | Cohort lifecycle + retention math | `lp-cro-rubric`, `pre-publish-check` |
| [Save everyone vs let the wrong-fit go](save-everyone-vs-let-the-wrong-fit-go.md) | Murphy/Mehta (save) vs Reichheld/Elliott-McCrea (correction) | ICP fit + time-in-product + expansion potential | `churn-diagnose`, `win-back-sequence` |
| [Short feedback vs long-term holdouts](short-feedback-vs-long-term-holdouts.md) | Abrams-style fast loop vs Verna-style holdout | Decision reversibility + cohort size | `goal-routine`, `score-goal` |
| [Specialist vs generalist hiring](specialist-vs-generalist-hiring.md) | Specialist depth vs generalist surface | Org stage + AI-augmentation level | `pmm-coaching` |
| [Personalization vs. scale](personalization-vs-scale.md) | Hand-personalize every touch vs. scaled cadence with smart variables | Account tier + ACV + sales-cycle length + SDR seniority | `outbound-sequence-design`, `account-pursuit-rhythm` |
| [Outbound vs. inbound budget](outbound-vs-inbound-budget.md) | Inbound compounds in saturated cats vs. outbound creates emerging cats | Category maturity + brand recognition + cash runway + buyer self-education depth | `abm-account-prioritize`, `outbound-sequence-design` |
| [Scope-flex vs. fixed-fee](scope-flex-vs-fixed-fee.md) | Stark/Enns/Baker (fixed-fee) vs. Weiss/Williams (scope-flex on long engagements) | Engagement window length + substrate maturity + operator calibration history | `engagement-shape-pricing` |
| [Sprint vs. retainer default](sprint-vs-retainer-default.md) | Sprint-default at early stage vs. retainer-default at growth | Client funding stage + customer-call corpus depth + leadership stability | `engagement-shape-pricing` |
| [Emerging vs. mature category](emerging-vs-mature-category.md) | Maples/Yoon/Raskin (emerging — name new game) vs. Dunford/Moore/Gartner (mature — battle cards) | Category-leader name density + named-competitor count + funding-stage curve | `ai-native-category-positioning` |
| [Formal vs. personal voice register](formal-vs-personal-voice-register.md) | Formal operator-voice-warm for outbound vs. personal-LinkedIn register for feed-content | Destination + recipient parasocial context + artifact shape | `referral-targeting`, `voice-enforce` |
| [Hard-fail vs. soft-fail on unidentified](hard-fail-vs-soft-fail-on-unidentified.md) | Hard-fail (stub-only) vs. soft-fail (ship most-likely with flag) | Pipeline urgency + recruiter-relationship value + candidate landscape clarity | `prospect-identification`, `referral-targeting` |

## How substrate uses contradictions

A skill calling a contradicted pattern must:

1. **Detect the contradiction.** SKILL.md frontmatter declares `contradictions_aware: [<slug>...]`.
2. **Read the conditioning.** The skill's preflight reads the contradiction's `Conditions` section.
3. **Pick the position.** The skill picks the position whose conditions match the client context.
4. **Cite the choice.** The output artifact records which position was applied and why.

Example: `agent-jtbd-map` reads `agents-as-team-vs-agents-as-tools.md`. For a JTBD that produces heterogeneous artifacts and persists across sessions, it applies Vo's "team" shape. For a JTBD that's homogeneous and ephemeral, it applies Cherny's "tool" shape. The choice is logged on the artifact.

## How contradictions evolve

A genuine resolution arrives only when:
- A new tier-A pattern emerges that subsumes both positions.
- Or one position's conditions become consistently met across the codex corpus.
- Or operators on both sides converge after new evidence (model capability shift, market shift).

Until then, the contradiction stays open. Substrate refuses to pick a global default. Skills pick locally.

## See also

- `knowledge/patterns/INDEX.md`, the convergent rules.
- `knowledge/patterns/build-for-next-model.md`, why some contradictions resolve as model capability changes.
- `PRINCIPLES.md` rule 9, every skill grounds in a pattern AND declares contradictions-aware.
- [con_floor-as-draw-vs-floor-as-retainer](floor-as-draw-vs-floor-as-retainer.md)
