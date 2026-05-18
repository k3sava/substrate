---
id: con_emerging-vs-mature-category
title: Emerging-category creation language vs mature-category displacement language
captured_date: 2026-05-18
---

# Emerging-category vs mature-category positioning

## Position A — emerging category; name the new game, displacement-target is none, narrative leads
- Operator: Mike Maples Jr. (`ins_maples-inflection-theory`), Eddie Yoon (`ins_yoon-category-creation-playbook`), Andy Raskin (`ins_raskin-narrative-is-strategy`)
- Claim: in emerging AI-native categories (agentic workflow, vertical AI, AI dev-tool sub-segments), the buyer's mental model is unformed. Positioning against a named competitor confuses the buyer — they don't yet know what category the product belongs to. The load-bearing PMM artifact is the *strategic narrative* that names the new game, raises the stakes, and points at the promised land. Maples's inflection theory: at the inflection, the first PMM names the category language; the buyer adopts it because no competing language has stabilised. Yoon's playbook: category-creation companies grow 10x larger than category-displacement companies in the same timeframe.

## Position B — mature category; displacement-target is named, status-quo comparison is central
- Operator: April Dunford (`ins_dunford-no-decision-is-real-competitor`), Geoffrey Moore (Crossing the Chasm; `ins_moore-tornado-dynamics`), Gartner (battle-cards as workflow primitive; `ins_battle-cards-as-workflow-primitive`)
- Claim: in mature categories (B2B SaaS verticals with 10+ named competitors, CCaaS, MarTech, established AI infra), the buyer arrives with a shortlist. Positioning that doesn't name the displacement-target reads as evasive; the buyer pattern-matches the absence as a tell that the operator can't win the head-to-head. The load-bearing PMM artifacts are battle cards, status-quo-vs-named-competitor analysis, and Dunford-style alternative-anchored copy. Category-creation language at mature stage reads as marketing-fluff to a buyer who's already in the comparison phase.

## Conditions distinguishing them

- **Category-leader name density in buyer language** is the dominant variable. If buyer interviews surface 2+ named competitors per call (`"we looked at X and Y"`), the category is mature. If buyer interviews surface mostly status-quo or no-decision language (`"we're using a spreadsheet"`, `"we don't have anything for this"`), the category is emerging.
- **Named-competitor count in the market**: ≤3 named competitors with overlapping JTBD = emerging. ≥10 = mature. Hybrid: 4-9 named competitors = the genuinely hard middle, where conditioning depends on the specific buyer segment.
- **Switching-from-spreadsheet vs switching-from-vendor signal**: switching-from-spreadsheet (Position A; emerging). Switching-from-named-vendor (Position B; mature).
- **Funding-stage curve of the category**: 80% of category companies still pre-Series B → emerging. 50%+ at Series C and beyond → mature.

## Resolution / synthesis

Not orthogonal; both can be true at different *sub-segments* inside a single category. The genuine contradiction is in *load-bearing artifact pick*:

- Emerging category → narrative-led (Position A). Strategic narrative is the load-bearing artifact. Battle cards are deferred. The LP, the deck, the AEO copy all carry the new-game language.
- Mature category → battle-card-led (Position B). Battle cards become workflow primitives in seller stacks. Status-quo + named-competitor analysis carries the LP, the deck, the sales-call enablement.
- Hybrid category → narrative-led for the *top of funnel* (the new-game name is the AEO and brand layer), battle-card-led for the *bottom of funnel* (the comparison-stage buyer needs the battle card). The two artifacts cohabit in the same pipeline at different stages.

## How substrate uses this contradiction

`ai-native-category-positioning` reads this contradiction's `Conditions` section and picks the default based on the `--category-maturity` input:

- `--category-maturity emerging` → Position A. Refuse to anchor on a named competitor. Anchor on the new-game language; status-quo is the alternative; named-competitors are optional context.
- `--category-maturity mature` → Position B. Refuse to write category-creation copy. Anchor on the displacement-target named; status-quo is one alternative among named-competitors.
- `--category-maturity hybrid` → split: Position A for narrative artifacts, Position B for sales-enablement artifacts. The skill emits both with the position recorded per artifact.

The position is recorded on the output artifact (`contradiction_positions.emerging-vs-mature-category: <A|B>`). Running A logic in a mature category produces brand-fluff the buyer dismisses; running B logic in an emerging category produces battle cards against competitors the buyer hasn't heard of.

## Related to

- `no-decision-vs-named-competitor.md` — companion contradiction at the buyer-state layer (no-decision dominates emerging; named-competitor dominates mature).
