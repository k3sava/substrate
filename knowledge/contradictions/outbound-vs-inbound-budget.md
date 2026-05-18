---
id: con_outbound-vs-inbound-budget
title: Inbound-content compounds vs. outbound creates the category — where to put the GTM dollar
captured_date: 2026-05-08
---

# Inbound-content compounds vs. outbound creates the category

## Position A — in saturated categories, inbound + content compounds; outbound decays

- Operator: Devin Reed (`ins_reed-content-compounds-outbound-decays`), Joel Klettke (`ins_klettke-conversion-copy-from-research`), Dave Gerhardt (`ins_gerhardt-brand-as-distribution-moat`)
- Claim: in saturated B2B categories where 5-15 vendors fight for the same buyer, outbound reply rates compound downward as buyers learn to filter out cold sequences. Inbound content (SEO, AEO, podcast, community, brand) is the channel that compounds upward: every published asset becomes a perpetual touchpoint that searchers and AI-mediated buyers find on their own time. The unit economics: a piece of evergreen content paying back over 18-36 months beats an outbound sequence that produces leads for 30 days and decays. In saturated categories, the GTM dollar should weight 70-80% inbound, 20-30% outbound.

## Position B — in emerging categories, outbound creates the category awareness inbound can't

- Operator: Sangram Vajre (`ins_vajre-tear-mql-funnel`), Mark Roberge (`ins_roberge-sales-as-engineering-discipline`), Kyle Lacy (`ins_lacy-outbound-narrative-creation`)
- Claim: in emerging or sub-1000-search-volume categories, no one is searching for the solution because no one knows the solution exists. Inbound content has no audience to capture; ranking #1 for a search no one runs is a vanity metric. Outbound is what creates the category awareness: SDR conversations educate the market one buyer at a time, and those conversations feed back into the content engine with the language buyers actually use. In emerging categories, the GTM dollar should weight 60-70% outbound, 30-40% inbound, with the inbound serving as enablement substrate for the outbound (shareable artifacts, trust-builders, stage-2 conversion content).

## Conditions distinguishing them

- **Category maturity** is the dominant variable. Mature categories (CRM, helpdesk, project management, marketing automation) have 50K+ monthly searches across the category and a known competitive set; inbound dominates. Emerging categories (RAG infrastructure, voice AI agents, AEO tooling, OSS GTM platforms in 2026) have <5K searches; outbound dominates.
- **Brand recognition**: established brands harvest inbound at the brand-search level (people search the brand name); challenger brands get outranked even when their content is better. Challengers without brand recognition get more leverage from outbound.
- **Buyer self-education depth**: in categories where buyers self-educate heavily before talking to vendors (developer tools, infrastructure software), inbound captures a richer share of the funnel because most evaluation happens before a meeting. In categories where buyers don't self-educate (most legacy enterprise B2B), outbound is the only way to start the conversation.
- **Pipeline velocity required**: outbound produces pipeline in 30-60 days; inbound produces pipeline in 6-18 months. Companies with cash-runway pressure or aggressive board targets need outbound regardless of category maturity, because inbound's payback timer is too long.

## Resolution / synthesis

Not a universal contradiction; resolves by category × stage × runway. The framework:

| Category maturity | Brand | Cash runway | Mix recommendation |
|---|---|---|---|
| Mature | Established | Long | 70% inbound, 30% outbound |
| Mature | Challenger | Long | 50% inbound, 50% outbound (outbound earns the relationship that inbound can't, given brand gap) |
| Mature | Either | Short | 30% inbound, 70% outbound (need pipeline now; inbound payback is too slow) |
| Emerging | Either | Long | 40% inbound (category-creation content), 60% outbound (one-by-one education) |
| Emerging | Either | Short | 20% inbound, 80% outbound (must create category fast) |

Substrate skills using either position must declare which category-maturity assumption they're operating under, because the same outbound sequence design produces different ROI in mature vs. emerging categories.

The Reed / Klettke / Gerhardt position is correct *for mature categories with long runway*. The Vajre / Roberge / Lacy position is correct *for emerging categories or short runway*. The failure mode: applying the saturated-category recommendation to an emerging-category company starves the outbound engine that creates category awareness; applying the emerging-category recommendation to a saturated-category company over-invests in outbound that decays.

## How substrate uses this contradiction

`abm-account-prioritize` and `outbound-sequence-design` both read this contradiction's `Conditions` section. The skills require the operator to pass `--category-maturity mature|emerging|hybrid` to scope behavior:

- `mature`: skill assumes buyers are self-educating; outbound sequences default to event-driven triggers; cadence weighting is lighter.
- `emerging`: skill assumes buyers don't yet know the category; outbound sequences default to category-education frame; cadence weighting is heavier.
- `hybrid`: skill produces both modes and flags which accounts get which.

The output artifact records the maturity classification used. A skill that runs mature logic on an emerging-category account produces sequences that assume awareness the buyer doesn't have, which fail to convert.

## See also

- `pat_status-quo-is-the-real-objection-outbound.md`, which applies more strongly in mature categories where status quo is well-developed.
- `pat_trigger-events-beat-cadence-blast.md`, which applies in mature categories where buyers have a known current state to track triggers against.
- `pat_distribution-as-moat.md`, which describes inbound's compounding mechanism.
