---
id: pat_van-westendorp-over-vibes-pricing
title: Structured price-sensitivity research beats opinion pricing
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_simon-pricing-discipline, ins_campbell-profitwell-customer-pricing-research, ins_mickos-startup-pricing-from-research, ins_van-westendorp-PSM-method]
domains: [pmm, pricing, product, gtm]
---

# Structured price-sensitivity research beats opinion pricing

## Convergence

Four operators across pricing science, monetisation research, and operator practice converge on a single operating claim: setting prices from team consensus, founder gut, or competitor copying systematically leaves money on the table. The structured alternative is documented, repeatable price-sensitivity research with a small set of asked-of-buyers questions and a curve-fit method (van Westendorp Price Sensitivity Meter, Gabor-Granger, conjoint with price levels). The output is a defensible price band with two named anchors (Optimal Price Point, Indifference Price Point) and explicit demand cliffs, sourced from at least 20 buyer responses per segment, refreshed at least annually. Operators who hold this discipline produce price changes that compound; operators who don't produce price changes that drift.

## Operators

- **Hermann Simon**, founder of Simon-Kucher, author of *Confessions of the Pricing Man* and *Price Management*. Simon's organisational thesis is that pricing is the highest-leverage decision a firm makes (a 1% price improvement compounds to roughly 11% profit improvement on typical SaaS unit economics) and that single prices are always suboptimal because willingness-to-pay is heterogeneous. Simon's published research method is structured: WTP research per segment, tier construction against the demand curve, hold-the-line discount discipline so reference prices do not reset.
- **Patrick Campbell**, founder of ProfitWell (acquired by Paddle), publisher of the Pricing Page Teardowns series. Campbell's recurring published claim is that pricing should be revisited every six months and that the input that feeds the revisit is structured customer-pricing research, specifically the four-question van Westendorp PSM administered on a weekly cadence to 8-15 buyers in target ICP. His operational discipline ties pricing to retention math (NRR > 100% as the discipline that hides pricing mistakes; pricing precision lifts NRR mechanically).
- **Mårten Mickos**, former CEO of MySQL AB and HackerOne, on startup pricing. Mickos's published advice (and his MySQL pricing playbook) is that early-stage pricing should be set from research, not from a competitor scan, because competitor pricing reflects an older market structure and an older cost basis. His operational rule: do not ship a pricing page until at least 20 in-ICP buyer responses on the WTP curve produce a defensible OPP and IPP.
- **Peter van Westendorp**, the Dutch economist whose 1976 PSM paper formalised the four-question method (too cheap, cheap, expensive, too expensive) and the curve intersections (Optimal Price Point, Indifference Price Point, Point of Marginal Cheapness, Point of Marginal Expensiveness). The method is the canonical structured alternative to opinion pricing; it is what Campbell's operational discipline implements and what Simon's pricing function institutionalises.

## Variation

- **Simon** names the *org-level discipline* (pricing function, tier structure, discount discipline, WTP heterogeneity).
- **Campbell** names the *operational cadence* (every six months, weekly buyer research, NRR as the pricing-mistake mask).
- **Mickos** names the *founder-level rule* (do not ship a pricing page from competitor scans; 20 responses minimum).
- **van Westendorp** names the *method* (the four questions, the curve intersections, the band).
- Convergence: pricing decisions made from buyer-response curves, not from team opinion or competitor copy, compound; ones made from opinion drift downward over time as discounts erode the reference price.

## Implication

For PMM, founders, and pricing leaders:

1. **Run the four van Westendorp questions on at least 20 in-ICP buyers per segment** before setting or revising tier prices. The questions: at what price would this product be (a) so cheap you would question its quality, (b) a bargain, (c) expensive but you would still consider it, (d) so expensive you would not consider it. Plot the four cumulative curves; read the intersections.
2. **Read four price points from the curves**, not one. Optimal Price Point (intersection of "too cheap" and "expensive") is the price that minimises buyer rejection. Indifference Price Point (intersection of "cheap" and "expensive") is the point where as many buyers see the price as cheap as see it as expensive. Point of Marginal Cheapness (intersection of "too cheap" and "cheap") is the floor; below it, buyers question quality. Point of Marginal Expensiveness (intersection of "expensive" and "too expensive") is the ceiling; above it, buyers walk.
3. **Cross-validate with Gabor-Granger** on the same buyer panel: ask each buyer at five price levels whether they would buy at that price. The Gabor-Granger curve produces the revenue-maximising price (price × predicted purchase rate). If van Westendorp's OPP and Gabor-Granger's revenue-max price agree within 10-15%, the tier price is calibrated. If they diverge by more than 25%, run more buyer responses; the curves are noisy at low N.
4. **Refresh the research every six months** in markets where competitor pricing is moving, every twelve months in steady-state markets. Pricing unchanged for 18 months in a market where competitors have moved is a structural drift signal, not a stability signal.
5. **Hold the line on discounts.** Simon's claim is non-negotiable: every discount resets the reference price downward in the buyer's perception, and the entire price architecture compounds the loss. Bound rep discretion (max 15% off list, requires manager approval; max 25% off list, requires VP approval). Track discount distributions monthly; investigate distributions that drift right.

## Counter-evidence

- **For commodity categories** with transparent public pricing (cloud compute primitives, API tokens, hardware components), van Westendorp's PSM is muted because buyers have reliable external anchors. The pattern still applies; the conclusion is "use Gabor-Granger for revenue-max calibration, not van Westendorp for OPP."
- **For network-effect categories** where pricing is a feature (free as the Power-of-Free threshold), the structured-research approach is bounded by the category structure. The pattern still applies in a constrained form: the research informs the paid-tier prices, not the free tier's existence.
- **For pre-PMF startups with under 100 customers**, sample sizes for segment-specific WTP curves are not achievable. The pattern still applies; the conclusion is "run on the whole user base as one segment; revisit at PMF."
- **For procurement-driven enterprise sales**, the buyer is professional and the pricing conversation is a negotiation, not a posted-price decision. The pattern still applies; the conclusion is "the posted price is the anchor for the negotiation; the WTP research informs where the anchor sits, not where the deal lands."

## Sources

- ins_simon-pricing-discipline, Hermann Simon (*Confessions of the Pricing Man*; *Price Management*; Simon-Kucher pricing function frame)
- ins_campbell-profitwell-customer-pricing-research, Patrick Campbell (ProfitWell pricing-page teardowns; published WTP research cadence; NRR-as-pricing-mistake-mask)
- ins_mickos-startup-pricing-from-research, Mårten Mickos (MySQL AB pricing playbook; HackerOne; founder-level pricing advice canon)
- ins_van-westendorp-PSM-method, Peter van Westendorp (1976 ESOMAR paper; canonical PSM method)

See also:
- `pat_pricing-as-the-most-leveraged-org-failure`, the org-level companion pattern.
- `pat_behavioral-pricing-architecture`, the cognitive-substrate companion (Ariely, Kahneman, Ramanujam, Hormozi).
- `skills/pricing-strategic/`, the operational implementation.
