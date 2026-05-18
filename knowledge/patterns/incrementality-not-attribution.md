---
id: pat_incrementality-not-attribution
title: Last-touch attribution overcounts paid; geo holdouts and lift studies are the only credible measure of incremental impact
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_kaushik-channel-mismatched-metrics, ins_wenograd-creative-is-the-targeting, ins_orendorff-content-as-direct-response, ins_jorgensen-arbitrage-shrinks-with-attention]
domains: [paid-ads, growth, measurement]
---

# Last-touch attribution overcounts paid, geo holdouts measure what is actually incremental

## Convergence

Four operators across digital analytics, paid social, e-commerce performance, and incrementality testing converge on the same operating claim: standard attribution models (last-touch, first-touch, linear, time-decay, even most data-driven attribution implementations) systematically overcount the impact of channels that intercept demand and undercount the impact of channels that create demand. The only credible measure of incremental channel impact is a designed test (geographic holdout, ghost ads, public service announcement substitution, conversion-lift study), not a model fit on observed conversions. Operating decisions made from in-platform attribution are decisions made from a number that confuses correlation with causation in a known direction.

## Operators

- **Avinash Kaushik**, formerly Digital Marketing Evangelist at Google, author of *Web Analytics 2.0*. Kaushik's long-running argument, across his blog *Occam's Razor* and dozens of conference talks, is that attribution models confuse the *order of touchpoints* with the *causality of the conversion*. The buyer who searched the brand on Google after seeing a Meta ad is recorded as a search conversion under last-touch; remove the Meta spend and the search conversion does not happen. Attribution dashboards do not show this counterfactual.
- **Susan Wenograd**, paid-social practitioner. Wenograd has argued repeatedly that Meta's in-platform attribution overstates Meta's contribution because the platform is incentivised to claim conversions, and that the only honest test is a holdout. Her operating recommendation: do not allocate budget across Meta and Google using each platform's self-reported ROAS, because both platforms double-count the same conversion under different attribution models.
- **Aaron Orendorff** and the Common Thread Collective performance team. CTC's published case studies repeatedly show that Meta's reported ROAS and the brand's actual incremental ROAS diverge by factors of 2x to 5x in mature accounts, and that scaling spend on platform-reported ROAS overshoots the actual demand and produces wasted budget that the dashboard does not show.
- **Brian Balfour** and the broader growth literature on incrementality. Balfour's Reforge curriculum has long argued that attribution is a planning tool with known biases, not a measurement tool, and that incrementality testing (geo holdouts, ghost ads, lift studies) is the only credible measure for channels above 5% of marketing budget.

## Variation

- **Kaushik** names the *causality vs sequence* confusion in attribution.
- **Wenograd** names the *platform incentive* (Meta is incentivised to overcount).
- **Orendorff / CTC** name the *empirical magnitude* (2-5x divergence between reported and incremental ROAS).
- **Balfour / Reforge** name the *budget threshold* (incrementality is required above 5% spend share).
- Convergence: attribution dashboards are useful for within-channel optimisation (which creative, which audience), but unreliable for between-channel allocation (Meta vs Google vs LinkedIn) and for budget-level decisions (scale up, scale down, kill).

## Implication

For paid-marketing teams making allocation decisions:

1. **Run a geographic holdout at least quarterly** for any channel above 5% of marketing budget. Pick matched-market pairs (similar size, similar baseline conversion), turn paid spend off in one set, leave it on in the other, measure the conversion delta over a 4-6 week window. The delta is the actual incremental impact; the platform-reported number is the upper bound.
2. **Refuse the question "what is our blended CAC" without an attribution-model footnote.** Blended CAC is a planning number whose meaning depends on the model assumed. The same data produces different blended CAC under last-touch, linear, and incrementality-adjusted models.
3. **Use platform-reported ROAS only for within-platform decisions** (which campaign in Meta, which audience in LinkedIn). Cross-platform allocation requires either a third-party MMM (marketing mix model) or a designed incrementality test.
4. **Make the attribution model explicit in any claim about channel performance.** The claim "Meta drove 40% of new revenue" is not falsifiable without naming the model and window; the same data can support 15% under incrementality and 60% under last-touch.

## Counter-evidence

- **For very small budgets** (under $50k/month total paid spend), incrementality testing is often impractical because the noise floor of geo holdouts swamps the signal. The pattern still applies; the conclusion is "spend humbly, do not over-claim performance" rather than "run a quarterly geo test."
- **For pure direct-response e-commerce** with short consideration cycles (single-session purchases under $100), last-touch attribution is closer to incremental than for considered B2B purchases, because the conversion happens in the same session as the click. The pattern still applies but the magnitude is smaller.
- **MMM (marketing mix modeling)** is a credible alternative to designed incrementality tests for large advertisers, but requires 18-24 months of clean data and a statistician's attention. Most teams do not have either; the geo holdout is the practical floor.

## Sources

Cards listed under uses_cards above. See also:
- `pat_intent-vs-interest-targeting`, on why platform-reported attribution is more reliable for search than for social.
- `pat_creative-fatigue-window`, on why CTR decay is a more honest within-channel signal than ROAS.
- `routines/ad-allocation-routine.md`, the operational implementation of incrementality-aware allocation.
