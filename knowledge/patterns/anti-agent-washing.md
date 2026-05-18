---
id: pat_anti-agent-washing
title: Anti-agent-washing — every AI capability claim names a human checkpoint and binds to a capability class
captured_date: 2026-05-18
convergence_count: 4
tier: A
uses_cards: [ins_gartner-agent-washing-taxonomy, ins_karpathy-capability-class-not-version, ins_yamini-named-agent-per-job, ins_anthropic-managed-agents-eval-grounded]
domains: [ai-native, gtm, pmm, procurement]
---

# Anti-agent-washing

## Convergence

Four credible AI-native operators converge on the same procurement-defensibility rule: an AI capability claim that doesn't (a) name the human checkpoint, (b) bind to a capability class rather than a model version, and (c) cite an eval rubric is "agent-washing" and voids buyer trust on contact. Gartner's 2026 Hype Cycle (G00842058) names the failure mode; Karpathy names the capability-class discipline; HubSpot's GTM flywheel and Anthropic's managed-agents posture operationalise it.

## Operators

- Gartner (G00842058 Hype Cycle for Agentic AI 2026), `ins_gartner-agent-washing-taxonomy`. Names "agent-washing" as a Trough-of-Disillusionment risk: vendors rebrand existing automation as agents without trust-grounding. Procurement-side defense: refuse claims that don't specify the autonomy boundary and the eval signal.
- Andrej Karpathy, `ins_karpathy-capability-class-not-version`. Bind product claims to capability classes ("reasons over 100-page contracts") not model versions ("uses GPT-4o-mini"). Model versions deprecate quarterly; capability classes are the durable claim surface.
- Yamini Rangan (HubSpot), `ins_yamini-named-agent-per-job`. 2026-04-28 GTM flywheel: nine named agents, one JTBD per agent, one human checkpoint per agent. The naming discipline is itself the anti-agent-washing posture — the buyer can audit each agent's boundary.
- Anthropic (Managed Agents), `ins_anthropic-managed-agents-eval-grounded`. Every managed-agent capability ships with an eval rubric and a documented human-in-the-loop boundary. Eval-as-data-analysis is the procurement-grade evidence ladder for AI claims.

## Variation

- Gartner provides the *procurement frame* — name the failure mode and the buyer-side defense.
- Karpathy provides the *capability-pin discipline* — what to bind claims to.
- Yamini provides the *operating frame* — named agent per JTBD with the human checkpoint visible.
- Anthropic provides the *evidence frame* — eval rubric as the claim's backing artifact.
- Convergence: a claim about an AI capability is a claim about an eval. No eval = no claim. No human checkpoint = no claim. No capability class = no durable claim.

## Implication

For PMM, founders, and AI-native marketing leads:

1. **Audit every existing claim against three gates.** Capability class (not model version)? Named human checkpoint? Eval rubric backing? Any miss = re-emit.
2. **Refuse the word "autonomous" without an eval.** "Fully autonomous" or "no human required" claims must cite an eval rubric that scores the no-human pathway above an operator-named threshold. Otherwise the claim is agent-washing.
3. **Refuse to bind claims to model versions.** "Uses GPT-4o" or "powered by Claude 3.7" is depreciating-asset positioning. Bind to the capability class the JTBD requires.
4. **Map every AI claim to a JTBD with a named agent.** Per Yamini's flywheel: if you can't name the agent and the human checkpoint on a whiteboard, you don't have an AI feature, you have a marketing word.
5. **Voice-enforce a kill-list for AI-fingerprint terms.** `autonomous`, `human-out-of-loop`, `seamless`, `magic`, `just works`, `effortless`, `intelligent` (as adjective). These are agent-washing tells procurement teams pattern-match on.

## Counter-evidence

- For **internal-only AI tooling** (engineering productivity, dev infrastructure), the procurement-defensibility frame is gentler because the buyer is also the operator. The capability-pin discipline still applies; the eval-grounding bar is softer.
- For **research-frontier claims** (foundation-model labs announcing capability gains), the eval-grounding is the load-bearing claim; the human-checkpoint frame is implicit in the eval design. Gartner's frame still applies to the buyer-facing surface, not the research-publication surface.

## Sources

- ins_gartner-agent-washing-taxonomy, Gartner G00842058 (Hype Cycle for Agentic AI 2026)
- ins_karpathy-capability-class-not-version, Andrej Karpathy (LLM-as-OS essays + 2026 conference talks)
- ins_yamini-named-agent-per-job, Yamini Rangan (HubSpot Q1 2026 earnings + Spring Spotlight 2026)
- ins_anthropic-managed-agents-eval-grounded, Anthropic Managed Agents documentation + Claude platform launch posts

## Related substrate

- `skills/ai-native-category-positioning/SKILL.md` — composes this pattern as the load-bearing refusal
- `skills/capability-pin/SKILL.md` — produces the capability-class binding
- `skills/eval-rubric/SKILL.md` — produces the eval-grounding artifact
- `skills/agent-jtbd-map/SKILL.md` — produces the named-agent-per-JTBD map
- `knowledge/patterns/agents-mapped-to-jtbd.md` — companion pattern
- `knowledge/patterns/eval-as-data-analysis.md` — companion pattern
- `knowledge/patterns/build-for-next-model.md` — capability-class durability discipline
