---
id: pat_intent-vs-interest-targeting
title: Search ads buy intent; paid social buys interest — different funnels, different unit economics, different success metrics
captured_date: 2026-05-08
convergence_count: 3
tier: A
uses_cards: [ins_aslam-search-buys-intent, ins_kaushik-channel-mismatched-metrics, ins_fishkin-paid-social-shape-of-demand]
domains: [paid-ads, gtm, growth]
---

# Search ads buy intent; paid social buys interest

## Convergence

Three operators with deep paid-marketing practice converge on the same operating distinction: search advertising on Google buys *intent* (the buyer initiated the query and is already in market), while paid social on Meta, LinkedIn, TikTok, and X buys *interest* (the buyer might be in market). The two are not interchangeable. Intent traffic converts at much higher rates against narrower volume; interest traffic produces higher volume against lower conversion. Holding both channels to the same KPI (CAC, ROAS, conversion rate) misallocates budget toward the channel with the more legible numbers and starves the channel that produces the harder-to-attribute long-run pipeline.

## Operators

- **Kasim Aslam**, founder of Solutions 8, longtime Google Ads practitioner and host of the *Perpetual Traffic* podcast (with Ralph Burns). Aslam's repeated public position, across podcast episodes and workshops, is that Google search traffic is fundamentally different from Meta traffic because the buyer initiated the query. The corollary: search-ads campaigns should be measured on intent metrics (cost per qualified lead, conversion rate from query to demo) and Meta campaigns should be measured on demand-generation metrics (assisted conversions, branded-search lift, cohort-level CAC).
- **Avinash Kaushik**, formerly Digital Marketing Evangelist at Google, author of *Web Analytics 2.0*. Kaushik's *See, Think, Do, Care* framework is a buyer-stage map that names what each channel is good at: paid social and display work in See / Think (audience awareness, demand generation), search ads work in Do (purchase intent), email and CS work in Care (retention). Kaushik has argued for over a decade that holding See-stage channels to Do-stage KPIs is the most common cause of digital-marketing budget misallocation.
- **Rand Fishkin**, founder of SparkToro, formerly founder of Moz. Fishkin's operating frame, repeated in *Lost and Founder* and across SparkToro's audience-research work, is that paid social produces the *shape of demand* (which audiences cluster, which messages land, which adjacencies matter) while search ads produce the *intercept on existing demand*. Treating paid social as a direct-response channel ignores the substantial brand and discovery effect; treating search ads as a discovery channel ignores how narrow the queryable demand actually is.

## Variation

- **Aslam** names the *channel-level distinction* (Google buys intent; Meta buys interest).
- **Kaushik** names the *funnel-level mapping* (See, Think, Do, Care, with channels mapped to stages).
- **Fishkin** names the *demand-side distinction* (search intercepts existing demand; paid social shapes nascent demand).
- Convergence: a paid-marketing program that uses one playbook across both channels is mismeasuring at least one of them. The fixes differ by channel because the underlying buyer behaviour differs.

## Implication

For paid-marketing teams running both search and social:

1. **Measure search ads on intent metrics.** Cost per qualified lead, MQL-to-SQL rate, demo-to-close, search-impression-share for high-intent queries. ROAS and last-click CAC are reasonable here because the buyer's intent is captured in the query.
2. **Measure paid social on demand-generation metrics, not direct-response metrics in isolation.** Assisted conversions, branded-search lift after a campaign launches, cohort-level CAC over a 60-90 day window, audience overlap with closed-won. Last-click CAC for paid social is a known undercount and should not be the primary KPI.
3. **Separate the budgets and the dashboards.** A single "paid CAC" number that mixes search and social is a number that hides the actual mechanism. Operators allocating budget on a single CAC metric routinely starve the upper-funnel channel that fed the lower-funnel one.
4. **Match creative discipline to the channel.** Search creative is shorter-cycle (low fatigue, high relevance to query) and rewards copy-tightness against the query. Social creative is higher-cycle-fatigue (per the creative-fatigue-window pattern) and rewards story-arc, hook-density, and variant volume.

## Counter-evidence

- **Demand-capture brands** with established category demand may run paid social as direct-response with reasonable success because the buyer already knew the category before the impression. This is a special case of mature category demand, not a refutation of the pattern.
- **Some B2B SaaS verticals with very small TAM** find that search-ads volume is too low to be a meaningful channel, and shift the entire paid program to social-led demand-generation. The pattern still applies; the conclusion is "skip search, build social" rather than "treat them the same."
- **Performance Max and similar AI-rotation surfaces** blur the channel boundary by allocating across search, display, YouTube, and Discover behind a single bid signal. The pattern still applies at the asset level; the diagnostic shifts from channel-level dashboards to asset-group analysis.

## Sources

Cards listed under uses_cards above. See also:
- `pat_creative-fatigue-window`, on why social creatives fatigue and search creatives do not.
- `pat_incrementality-not-attribution`, on why last-click CAC undercounts paid social specifically.
- `pat_channel-arbitrage-window`, on the time dimension of channel exploration.
