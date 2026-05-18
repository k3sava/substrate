---
name: ai-native-category-positioning
description: Positioning forge specialized for AI-native categories (AI infra, foundation-model platform, agentic workflow, vertical AI, AI dev-tool). Conditions on capability-decay, agent-washing, and the emerging-category vs displacement distinction. Composes positioning-forge + agent-jtbd-map + capability-pin + status-quo-frame, then runs an evidence-tagged claims register before any artifact ships.
version: 0.2
status: wired
updated_date: 2026-05-18
amplifies: PMM lead at an AI-native company, founder pitching an AI product, head of marketing at a Series A-C AI startup
masters: April Dunford (positioning rules generalize; AI-native conditions on capability-decay), Mike Maples Jr. (inflection theory — agentic AI is an inflection, not a feature), Geoffrey Moore (Crossing the Chasm — Tornado dynamics apply to AI infra), Eddie Yoon (category creation playbook), Andy Raskin (strategic narrative for emerging categories), Andrej Karpathy (the AI capability surface moves; pin to capability classes not models), Patrick Campbell (pricing-as-positioning when model costs shift), Bret Taylor (outcomes pricing for AI), Hilary Mason / Cassie Kozyrkov (eval-as-data-analysis — claims about AI need eval-grounding), Yamini Rangan (named agent per JTBD with named human checkpoint)
substrate_layers_required: [positioning, icp, voc, competitive, product-knowledge, allowed-claims, eval-rubric]
patterns_grounded: [anti-agent-washing, agents-mapped-to-jtbd, capability-decay-rebaseline, eval-as-data-analysis, status-quo-is-the-competitor, narrative-as-strategy, raskin-narrative-five-act, build-for-next-model]
contradictions_aware: [emerging-vs-mature-category, no-decision-vs-named-competitor, build-quietly-vs-distribution-first, agents-as-team-vs-agents-as-tools]
preflight_refusal: substrate-gap, missing-claims-register, missing-eval-rubric, missing-capability-pin
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/positioning/positioning-canonical-statement.md
  - clients/{client}/allowed-claims/register.md
  - clients/{client}/agents/agents-jtbd-map.md
  - knowledge/patterns/anti-agent-washing.md
  - knowledge/patterns/agents-mapped-to-jtbd.md
  - knowledge/patterns/capability-decay-rebaseline.md
  - knowledge/contradictions/emerging-vs-mature-category.md
---

# ai-native-category-positioning

## Purpose

`positioning-forge` runs Dunford + JTBD + Raskin generically. The AI-native category has its own conditioning variables: model capability decays (this quarter's frontier is next quarter's baseline), agents map 1:1 to JTBD with named human checkpoints, eval-is-data-analysis (a claim about an AI capability is a claim about an eval), and *agent-washing* is the procurement-failure mode that voids the buyer's trust. This skill is the AI-native specialization of positioning-forge with those conditioning gates baked in.

## When to use

- The prospect's category is one of: foundation-model platform, AI infra, agentic workflow, vertical AI (legal / health / sec / finance / creative / data-observability), AI dev-tool, AI-native app with a model substrate.
- Generic `positioning-forge` is insufficient because the load-bearing claim is *about the AI* (capability, eval, agent boundary), not *around the AI* (workflow, integration).
- An allowed-claims register exists or can be built (`allowed-claims-register`).

## Inputs

- `--client <slug>` (required)
- `--ai-primitive <foundation-model|ai-infra|agentic-workflow|vertical-ai|ai-dev-tool|ai-native-app>` (required) — picks the conditioning variables
- `--vertical <slug>` (optional, required if `--ai-primitive vertical-ai`) — e.g. `legal-compliance`, `cybersec-deepfake`, `data-observability`, `procurement`, `creative-content`, `voice-ai`, `developer-tooling`
- `--category-maturity <emerging|mature|hybrid>` (required) — picks position on `emerging-vs-mature-category` contradiction
- `--displacement-target <competitor-slug|none>` (required) — picks position on `no-decision-vs-named-competitor`
- `--output <path>` (optional, default `clients/<client>/positioning/ai-native-canonical-<date>.md`)

## Substrate reads

- `clients/<client>/BRIEF.md` — company, customer count, funding stage, last-named pricing.
- `clients/<client>/positioning/positioning-canonical-statement.md` — current canonical (if any); diff-target for the new artifact.
- `clients/<client>/allowed-claims/register.md` — every AI-capability claim must be a register entry (composes `allowed-claims-register`). Without this, the skill refuses.
- `clients/<client>/agents/agents-jtbd-map.md` — composed by `agent-jtbd-map`. Each agent must have a JTBD and a named human checkpoint.
- `clients/<client>/capability-pins.yaml` — composed by `capability-pin`. Capability classes (not model versions) the product's claims depend on.
- `clients/<client>/eval/` — eval rubrics scoring the AI's actual behavior on the JTBD. Without at least one rubric, the skill refuses.
- `clients/<client>/competitive/status-quo.md` — what the buyer does today (often a spreadsheet, a human team, or another AI). Composes `status-quo-frame`.

## Process

1. Preflight: validate all required substrate layers + claims register + at least one eval rubric. Refuse if any gap.
2. Run `agent-jtbd-map` cross-check: every claim in the proposed positioning must trace to a JTBD that an agent in the map handles, or be flagged as non-agent (workflow, integration, brand).
3. Run `capability-pin` cross-check: every capability claim cites a class, not a model. ("Reasons over 100-page contracts" passes. "Uses GPT-4" fails — bind to capability class, not version.)
4. Run vertical conditioning per `--vertical`:
   - **legal-compliance** (e.g. Blee): conditioning is *defensibility-of-output* — every claim must trace to an audit-trail or human-in-loop checkpoint.
   - **cybersec-deepfake** (e.g. GetReal): conditioning is *false-positive vs false-negative trade-off* — claim must state which side is optimized and the eval signal.
   - **data-observability** (e.g. Bigeye): conditioning is *signal-vs-noise on the data layer* — claims about "anomaly detection" need a precision/recall pair, not just precision.
   - **procurement** (e.g. Zip): conditioning is *integration-density on the buyer's stack* — claim about agent-action must list the systems the agent actually writes to.
   - **creative-content** (e.g. Typeface, Luma AI): conditioning is *brand-voice-fidelity at scale* — claim about output quality requires a voice-substrate eval.
   - **voice-ai** (e.g. AssemblyAI): conditioning is *latency × accuracy × cost* triple — claim must name the operating point on the triple.
   - **developer-tooling** (e.g. Kong AI Connectivity): conditioning is *time-to-first-success* — claim about adoption requires a TTFS-measured eval.
5. Run Dunford 5-step *over the AI-native overlay*: alternatives include status-quo (always) + human-only workflow + competitor AI + DIY-on-foundation-model.
6. Run Raskin strategic narrative *with the inflection frame*: the AI capability creates a new game; the old game is human-bottleneck; the promised land is *agent + human checkpoint*; the obstacle is trust (eval), agent-washing (positioning), or integration (technical).
7. Synthesize: one canonical positioning statement, capability-pin-cited, claims-register-cited, eval-grounded.
8. Voice-enforce on the canonical statement (kill-list, no em dashes, no throat-clearing). Anti-agent-washing language enforced: no "fully autonomous," no "human out of the loop," no "AI does everything" — every claim names the human checkpoint.
9. Diff against current positioning. Write to `clients/<client>/positioning/ai-native-canonical-<date>.md`.

## Output contract

```yaml
---
asset_type: positioning-statement
produced_by: ai-native-category-positioning
composed_skills: [positioning-forge, agent-jtbd-map, capability-pin, status-quo-frame, allowed-claims-register, eval-rubric]
client: <client>
ai_primitive: <primitive>
vertical: <vertical-or-null>
category_maturity: <emerging|mature|hybrid>
displacement_target: <competitor-or-none>
substrate_cited:
  - clients/<client>/allowed-claims/register.md
  - clients/<client>/agents/agents-jtbd-map.md
  - clients/<client>/capability-pins.yaml
  - clients/<client>/eval/<rubric-name>.md
  - clients/<client>/competitive/status-quo.md
contradiction_positions:
  - emerging-vs-mature-category: <A|B>
  - no-decision-vs-named-competitor: <A|B>
position_rationale: <one sentence per contradiction>
---

# Canonical positioning (AI-native)

## The new game (Raskin)
...

## Status-quo alternative
...

## Pillars (3)
1. <pillar-1> — backed by <eval-rubric-citation>
2. <pillar-2> — backed by <claims-register-entry>
3. <pillar-3> — backed by <capability-pin>

## What we are NOT (anti-agent-washing)
- Not <claim X that competitor makes that we won't make>
- Not <claim Y that requires human-out-of-loop, which we won't ship>
```

## Quality criteria

- Refuses any pillar without a citation to one of: claims register entry, capability pin, or eval rubric.
- Refuses any claim of "autonomous" / "fully automated" / "no human required" unless an eval rubric explicitly scores the no-human-checkpoint pathway above a threshold the operator named.
- Refuses to bind a claim to a model version (e.g. "GPT-4o-mini"). Capability-pin gate is hard-fail.
- Voice-enforce hard-fail on agent-washing kill-list (`autonomous`, `human-out-of-loop`, `seamless`, `magic`, `just works`, `effortless`, `intelligent` as adjective).
- Refuses to ship if the strategic-narrative inflection isn't named (Raskin's new-game block empty = refusal).

## Contradictions awareness

- `emerging-vs-mature-category` — emerging (Position A): category-creation language, name-the-new-game first, displacement-target=none expected. Mature (Position B): displacement-target named, status-quo-comparison central, category-creation muted. Hybrid: pick A for narrative, B for sales-enablement.
- `no-decision-vs-named-competitor` — at emerging-AI stage Position A (no-decision) dominates. The skill defaults A and requires explicit `--displacement-target <slug>` to override.
- `build-quietly-vs-distribution-first` — AI-native conditioning: distribution-first is forced by capability decay (the window to claim the category closes faster than to perfect the product). Default Position B (distribution-first), override only for foundation-model labs where eval-trust is the bottleneck.

## Refusal patterns

- `SUBSTRATE-GAP — claims register missing` → run `allowed-claims-register` first.
- `SUBSTRATE-GAP — agent JTBD map missing` → run `agent-jtbd-map` first.
- `SUBSTRATE-GAP — no capability pin` → run `capability-pin` first; the pin gate is the anti-agent-washing floor.
- `SUBSTRATE-GAP — no eval rubric exists` → run `eval-rubric` for at least one JTBD; without an eval, the AI-native claim has no evidence ladder.
- `VOICE — agent-washing kill-list hit` → re-emit; do not soft-fail.

## What this skill does NOT do

- Does not write the LP. That's `lp-ship` reading this skill's output.
- Does not write ads. `ad-creative-design` reads this output.
- Does not run the eval. `eval-rubric` does that; this skill reads the rubric's output as a gate.
- Does not pick the vertical or the ai-primitive. The operator does; the skill conditions on the input.

## See also

- `skills/positioning-forge/` — the generic version this skill specializes.
- `skills/agent-jtbd-map/` — composed for the JTBD overlay.
- `skills/capability-pin/` — composed for the anti-version-binding gate.
- `skills/allowed-claims-register/` — composed for the procurement-defensibility gate.
- `skills/eval-rubric/` — composed for the eval-grounding.
- `skills/status-quo-frame/` — composed for the alternative analysis.
- `knowledge/patterns/anti-agent-washing.md` — the load-bearing procurement-defensibility pattern (Gartner G00842058, Karpathy, Yamini Rangan, Anthropic).
- `knowledge/patterns/agents-mapped-to-jtbd.md` — the JTBD-overlay pattern.
- `knowledge/patterns/capability-decay-rebaseline.md` — the quarterly rebaseline discipline (Karpathy, Anthropic, Gartner Hype Cycle).
- `knowledge/patterns/eval-as-data-analysis.md` — the eval-grounding pattern.
- `knowledge/contradictions/emerging-vs-mature-category.md` — the load-bearing category-maturity switch.
- `UPGRADES-2026-05-18.md` — gap analysis that derived this skill.

## Future work (deferred to substrate v1.7 back-half)

- Per-vertical playbooks (`vertical-ai-playbook-legal`, `vertical-ai-playbook-cybersec`, `vertical-ai-playbook-data-observability`, `vertical-ai-playbook-procurement`, `vertical-ai-playbook-creative`) compose this skill with vertical-specific conditioning blocks. Deferred to back-half v1.7.
- Wire into `routines/digest-ingest.md` so any digest tagged `ai-native-positioning` updates this skill's pattern citations and the per-vertical conditioning blocks.
- `category-creation-engagement` (`narrative-strategy` + `status-quo-frame` + Eddie Yoon overlay) is the parallel skill for the emerging-category Position A path. Deferred to back-half v1.7.
