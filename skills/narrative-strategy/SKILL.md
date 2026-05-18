---
name: narrative-strategy
description: Composes a Raskin five-act strategic narrative (name the change, raise the stakes, promise the land, name the obstacles, pitch the resolution) from canonical positioning, ICP, VoC, and market-context substrate. Validates each act against substrate citations. Outputs the narrative with per-act source paths and a drift-audit checklist.
version: 2.0
amplifies: founder, PMM lead, CEO communications
masters: Andy Raskin (the strategic narrative — name a change, raise the stakes, promise the land, name the obstacles, pitch the resolution), April Dunford (positioning as a strategy artifact, not a deck; setup-follow-through pitch), Anthony Pierri (homepage narrative tells one story to one buyer), Mihika Kapoor (vision pitch interleaves pain/solution/proof per beat), Christopher Lochhead (category design as the act of naming the change publicly)
substrate_layers_required: [positioning, voc, market-context, icp]
patterns_grounded: [narrative-as-strategy, raskin-narrative-five-act, buyer-mindset-not-product-features, status-quo-is-the-competitor]
contradictions_aware: [build-quietly-vs-distribution-first, post-training-moat-vs-distribution-moat]
preflight_refusal: substrate-gap, missing-market-context, missing-positioning
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# narrative-strategy

## Purpose

Most companies write the strategy first and the narrative second. The codex pattern (Raskin, Dunford, Kapoor, Pierri, Lochhead) is the inverse: the narrative IS the strategy. Get the story right and the strategy follows. Get the strategy right without the story and the team aligns on a slide nobody cares about.

This skill produces a five-act strategic narrative artifact, validates each act against substrate citations (no act ships unsourced), and emits a drift-audit checklist for the monthly review.

## The five acts (Raskin)

1. **Name a change in the world.** A market change, technology change, regulatory change. Name it in 1-3 words. Cite from `market-context/`.
2. **Raise the stakes.** Cost of inaction for the buyer who does not adapt. Cite from `voc/findings/` (verbatim resistance language preferred).
3. **Promise the land.** The post-resolution state in the buyer's vocabulary. Cite from `voc/findings/` (value-words category).
4. **Name the obstacles.** What stands between the buyer and the promised land. Cite from `voc/findings/` (objections), `competitive/status-quo.md`, named-competitor files.
5. **Pitch the resolution.** Only here does the product appear, as the magic the protagonist needs. Cite from `positioning/positioning-canonical-statement.md` and `product-knowledge/`.

## Inputs

- `--client <client>` (required)
- `--audience <buyer-archetype>` (required, must be in ICP)
- `--horizon <12mo|18mo|24mo>` (default 18mo)
- `--anchor-pattern <slug>` (e.g., `agent-first-gtm`, `distribution-as-moat`; optional, used to validate the change-naming)
- `--mode <build|refresh|audit>` (default build)

## Substrate reads

- `positioning/positioning-canonical-statement.md`: required.
- `voc/findings/<latest>.json`: themes by category (jtbd, objections, alternatives, value-words). If absent, the skill warns and runs without verbatim language; the operator is told to run `frontline-contact` first.
- `market-context/`: required; the trends backing the change. The skill walks the directory.
- `competitive/status-quo.md` and any `competitive/<vendor>.md`: source for Act 4 obstacles.
- `icp/icp-cut-<latest>.md` (or `icp/icp.md`): the audience cohort.

## Output contract

- `clients/<client>/strategy/narrative-<horizon>-<audience>-<date>.md`: five-act narrative with per-act citations.
- `clients/<client>/strategy/narrative-<horizon>-<audience>-<date>.json`: structured form.
- `clients/<client>/strategy/narrative-drift-audit-<date>.md`: a checklist that can be run against homepage, deck, sales pitch, release notes (per Raskin's monthly drift audit).

## Quality criteria

- Refuses without canonical positioning. Refuses with empty market-context directory.
- Refuses if any act has zero substrate citations.
- Refuses if Act 1 ("name the change") cannot be compressed to 1-3 words (Raskin discipline).
- Each act includes both the prose and the source paths it draws from.
- Voice gate: no em-dashes in the narrative body, kill-list applied (operator runs `voice-enforce` separately).

## Distinction from narrative-compose

- `narrative-strategy` produces the narrative itself.
- `narrative-compose` produces copy artifacts (LP, email, ad) FROM a finished narrative.
- Run this skill before `narrative-compose`, never instead of it.

## Contradiction handling

- `build-quietly-vs-distribution-first`: the narrative-strategy itself is silent on whether to ship the narrative loud or quiet; that decision belongs in `launch-plan`. The skill logs the contradiction without picking.
- `post-training-moat-vs-distribution-moat`: the resolution (Act 5) may invoke either moat language; the skill's `--anchor-pattern` flag picks the position when the operator names it.

## See also

- `skills/positioning-forge/`: positioning that maps onto Acts 4-5.
- `skills/dunford-value-frame/`: the value-framing for Act 5.
- `skills/status-quo-frame/`: the framing of Act 4 obstacles.
- `skills/messaging-matrix/`: downstream consumer of the narrative.
- `knowledge/patterns/raskin-narrative-five-act.md`.
- `knowledge/patterns/narrative-as-strategy.md`.
