---
id: pat_capability-decay-rebaseline
title: AI capability decays; quarterly re-baseline against the capability class, not the model version
captured_date: 2026-05-18
convergence_count: 3
tier: A
uses_cards: [ins_karpathy-capability-decay, ins_anthropic-frontier-rebase-cadence, ins_gartner-hype-cycle-capability-window]
domains: [ai-native, product, pmm, capability-management]
---

# Capability decays; rebaseline quarterly

## Convergence

Three operators converge on the same operating rule for AI-native products: the capability surface moves under your feet on a quarterly cadence. A product built on "GPT-4 reasoning" depreciates as soon as the next model class ships; a product positioned on "reasons over 100-page contracts" remains durable because the claim binds to the *capability class* the JTBD requires, not the model version delivering it. Quarterly rebaselining — auditing whether the capability claim still names what the product actually does — is the operator-side discipline.

## Operators

- Andrej Karpathy, `ins_karpathy-capability-decay`. The capability surface of frontier models moves quarter-to-quarter. Today's frontier is next quarter's baseline; today's baseline is next year's commodity. Product claims pinned to a model version (`GPT-4o-mini`, `Claude 3.7 Sonnet`) are depreciating assets; product claims pinned to capability classes (`reasons over multi-document evidence`, `executes multi-step plans with rollback`) are durable.
- Anthropic (Managed Agents documentation + Claude platform launches), `ins_anthropic-frontier-rebase-cadence`. Managed-agent capability is documented at the capability-class layer (eval rubrics scoring task performance, not model-version stamps). The cadence is explicit: capability classes evolve; eval rubrics are re-baselined; product claims update against the rubrics.
- Gartner (Hype Cycle for Agentic AI 2026, G00842058), `ins_gartner-hype-cycle-capability-window`. The hype-cycle frame: AI categories move through capability windows on a ~9-18 month cadence. Vendors who pin claims to a window's peak get caught flat-footed when the window shifts. Vendors who pin to capability classes durable across windows survive the rebaseline.

## Variation

- Karpathy provides the *operator-level frame* — what to bind product claims to.
- Anthropic provides the *eval-grounded operational frame* — how to rebaseline rigorously.
- Gartner provides the *market-cycle frame* — the cadence the rebaseline operates against.
- Convergence: bind claims to capability classes; rebaseline quarterly; document the rebaseline in an audit-grade eval substrate.

## Implication

For PMM, founders, and AI-native product leaders:

1. **Audit every product claim for model-version binding.** Search the LP, the docs, the pricing page, the sales deck for any reference to a specific model name. Replace with the capability class the JTBD requires.
2. **Stand up a capability-pin substrate.** `clients/<client>/capability-pins.yaml` records the capability classes the product depends on. Each pin: the JTBD it serves, the eval rubric that measures it, the model class currently delivering it, the rebaseline date.
3. **Rebaseline quarterly.** Each quarter: do the current capability claims still name what the product does? Has a model release shifted the floor? Has a new capability class emerged that the product can claim? Update the pins; update the claims.
4. **Refuse to bind copy to model versions.** Product copy that says "powered by Claude 3.7" or "uses GPT-4o" is depreciating-asset copy. Replace with "reasons over multi-document evidence" or whatever the capability class is.
5. **Use the rebaseline as a competitive-positioning lever.** When a competitor pins to a model version, their copy becomes stale on the next model release. The rebaseline-discipline operator is positioned to take the category language during the competitor's stale window.

## Counter-evidence

- For **foundation-model labs themselves** (Anthropic, OpenAI, Google DeepMind), model versions ARE the product. The pin-to-capability-class rule inverts — the lab's competitive claim is the version, not the class. The downstream consumer-product rule (bind to class) is the load-bearing case; the lab-product rule (bind to version) is the exception.
- For **research-frontier publications** (capability-frontier announcements, benchmark scores), the version binding is part of the publication's reproducibility. The pin-to-class rule applies to the *product* layer above the research layer.
- For **deprecated capability windows** (the model class itself is being deprecated by the provider), the rebaseline becomes an urgent migration, not a quarterly cadence. The operator-side rule: when a provider announces deprecation, rebaseline within the deprecation window or accept a coming claim-failure.

## Sources

- ins_karpathy-capability-decay, Andrej Karpathy (LLM-as-OS essays, 2026 conference talks, Twitter/X posts on capability classes)
- ins_anthropic-frontier-rebase-cadence, Anthropic Managed Agents documentation + Claude platform launch posts
- ins_gartner-hype-cycle-capability-window, Gartner G00842058 (Hype Cycle for Agentic AI 2026)

## Related substrate

- `skills/ai-native-category-positioning/SKILL.md` — composes this pattern as the capability-binding rule
- `skills/capability-pin/SKILL.md` — produces the capability-pin substrate
- `skills/eval-rubric/SKILL.md` — produces the eval substrate the rebaseline operates against
- `knowledge/patterns/build-for-next-model.md` — companion pattern (rebaseline as scaffolding discipline)
- `knowledge/patterns/eval-as-data-analysis.md` — companion pattern for eval-grounded claims
- `knowledge/patterns/anti-agent-washing.md` — companion pattern at the procurement-defensibility layer
