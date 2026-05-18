---
id: pat_channel-arbitrage-window
title: New channels yield outsize ROI on a closing window — track and rotate, do not over-optimise the saturated channel
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_lenny-channel-saturation-curve, ins_andrew-chen-law-of-shitty-clickthroughs, ins_brian-balfour-channel-product-fit, ins_eric-jorgensen-channel-arbitrage]
domains: [paid-ads, growth, gtm]
---

# New channels yield outsize ROI on a closing window, track and rotate

## Convergence

Four growth operators converge on a structural claim about paid-acquisition channels: a new or under-exploited channel produces outsize ROI for a window of 6 to 18 months before saturation closes the gap. The operators disagree on the exact mechanism (auction dynamics, attention-supply drift, network effects in the platform) but agree on the pattern: early adopters of a channel see CAC well below later-cohort CAC, and a team that lives on a single channel will watch CAC rise and conversion rate fall as the auction matures and creative norms congeal.

## Operators

- **Andrew Chen**, *Law of Shitty Clickthroughs* (2009 essay, foundational to the modern channel literature; later partner at a16z, now founder at All-In). Chen's operating thesis: every new channel produces a high CTR on first exposure, decays toward an asymptote as buyers learn to ignore it, and arbitrage closes. The implication for paid teams is to monitor decay continuously and rotate ahead of the curve.
- **Brian Balfour**, founder of Reforge, formerly VP Growth at HubSpot. Balfour's *Four Fits* framework treats channel-product fit as a first-class condition: a product that is great on a saturated channel is undiscoverable; a product that finds a fresh channel sees compounding distribution. Balfour's repeated public position is that channel choice is a strategic decision with a half-life, not a tactic.
- **Lenny Rachitsky**, *Lenny's Newsletter*, formerly product lead at Airbnb. Rachitsky's interviews with growth operators across consumer and B2B converge on the same observation: every winning team has a story about being early on a channel (early Facebook ads, early YouTube influencers, early TikTok organic, early LinkedIn newsletters) and watching the window close as later cohorts piled in.
- **Eric Jorgensen** (curator of *The Almanack of Naval Ravikant*) and the broader leverage / arbitrage literature: channel arbitrage is one of the cleanest examples of "specific knowledge" producing outsize returns, and the asymmetry compresses as the knowledge generalises.

## Variation

- **Chen** names the *decay curve* (CTR falls as buyers learn).
- **Balfour** names the *fit framework* (channel-product fit alongside problem, model, market).
- **Rachitsky** names the *empirical pattern* across dozens of growth case studies.
- **Jorgensen / Naval** name the *first-principle* (specific knowledge, leverage, asymmetric returns).
- Convergence: paid-acquisition channels are not interchangeable, and the team that wins on a channel is the team that entered before the auction matured. Late-entry teams pay an arbitrage tax that compounds with every quarter of campaign spend.

## Implication

For growth teams allocating paid-ads budget:

1. **Treat channel choice as a quarterly strategic question, not a tactical one.** Review the channel mix every 90 days against ROAS by channel and against the saturation indicators (CPM trajectory, average creative tenure, share-of-voice for the category).
2. **Hold a fraction of paid-ads budget for channel exploration.** Default split for established teams: 70% on proven channels, 20% on a maturing channel being scaled up, 10% on exploration of new surfaces. The 10% loses money in expectation but produces the option-value when a saturating channel forces a move.
3. **Predict saturation before the data shows it.** Indicators that close the arbitrage: total category spend on the channel rising faster than category revenue; CPM rising more than 20% YoY against flat creative; competitor brands appearing in the auction with previously-absent budget.
4. **Document channel-product fit explicitly**, not only channel ROAS. A channel can be ROAS-positive in the short window and still be wrong for the product (audience mismatch, brand-safety mismatch, creative-format mismatch); the long-run loss is invisible in the platform dashboard.

## Counter-evidence

- **Mature search ads on Google** are nominally saturated, but produce stable returns for products with clear category-defining queries because the buyer triggers the impression. Treating Google Search as a "saturated channel to exit" misreads the dynamics.
- **Some channels are structurally durable** for specific buyer types. LinkedIn for high-ACV B2B has compounded for over a decade rather than decaying, because the audience is concentrated and the alternative formats have not displaced it. The pattern applies most strongly to interrupt-based creative on algorithmic feeds.
- **The arbitrage window varies enormously** by product category and channel-fit quality. The 6-18-month default is a heuristic; some windows close in 3 months (TikTok organic in some categories), some last 5 years (early Facebook ads for D2C in 2014-2018). The right move is to measure decay locally, not to apply the heuristic literally.

## Sources

Cards listed under uses_cards above. See also:
- `pat_distribution-as-moat`, the broader frame on distribution-as-defensible-asset.
- `pat_creative-fatigue-window`, the within-channel creative analogue.
- `pat_intent-vs-interest-targeting`, on why search and social have different saturation curves.
