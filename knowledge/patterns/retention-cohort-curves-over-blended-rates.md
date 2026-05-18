---
id: pat_retention-cohort-curves-over-blended-rates
title: Cohort retention curves over blended retention rates
captured_date: 2026-05-08
convergence_count: 4
tier: A
domains: [pmm, growth, customer-success, finance]
---

# Cohort retention curves over blended retention rates

## Convergence

Four operators with portfolio-level retention exposure converge on the same diagnostic discipline: a single blended retention number hides the truth. The same business can show a flat 70% blended retention while one cohort decays from 80% to 40% and another holds at 90%. Cohort curves expose the drift; blended rates conceal it. The blended rate is reported because it is easy; the cohort view is reported because it is honest.

The convergence is not about the math (everyone agrees how to compute a cohort table). The convergence is about the *discipline*: refusing to read a blended rate without the cohort decomposition behind it, and treating the cohort table as the floor artifact for any retention conversation.

## Operators

- **Casey Winters**, The retention curve is the test of whether a product retains. Plot it by signup cohort, by acquisition channel, by first-week-action. If the curves diverge, the blended rate is meaningless. If they converge to a flat line, that flat line is the asymptotic retention; if they decay all the way to zero, the product has no retention regardless of what the blended number says. Reforge's user-retention course is built on this.
- **Reforge faculty (Brian Balfour, Sachin Rekhi, Casey Winters, et al.)**, The growth-loop framework treats every loop as cohort-conditional. A retention loop that works for cohort A may break for cohort B; a blended view erases the difference and the team optimizes for the wrong loop. Reforge's product-strategy curriculum centers cohort-segmented retention as the load-bearing analysis.
- **Mike Maples Jr.**, Floodgate, ex-Tellme. "Blended retention is the most lied-about metric in startups." Investors who fund growth-stage companies see the cohort curves under NDA and recognize the divergence; founders who present blended numbers to boards either don't have the cohort view or are hoping nobody asks. Cohort divergence is the leading indicator of acquisition drift, product change, or market saturation.
- **Tomasz Tunguz**, Theory Ventures (formerly Redpoint). The "T2D3" growth model and SaaS unit-economics frameworks both run on cohort retention; net dollar retention without cohort decomposition is a board theatre metric. Tunguz's blog posts on cohort analysis make the case quantitatively: the same NDR can come from very different cohort shapes, and the shape determines what to do next.

## Variation

- Winters frames it as *retention-curve-as-test*.
- Reforge faculty frames it as *loop-conditional cohort segmentation*.
- Maples Jr. frames it as *truth-telling discipline* (blended is the lie, cohort is the truth).
- Tunguz frames it as *board-grade analysis* (NDR without cohorts is theatre).
- Convergence: read retention as a curve per cohort, not a number per period.

## Implication

Any skill that touches retention reads cohorts, not blended. Any output that quotes a retention rate cites which cohort and which window. A team that reports "70% retention" without naming the cohort and the window is reporting a number that cannot be acted on, because the actions for fixing a 90%-stable cohort and a 90%-decaying-fast cohort are opposite.

Concrete artifact: a cohort retention table by signup month or week, with rows = cohorts and columns = weeks since signup, plus a slope-change detection step that flags cohorts where the curve bent down or up versus the prior cohort. That table is the substrate. Every downstream retention skill reads from it.

Cohort segmentation also exposes acquisition drift: if cohort N retains worse than cohort N-1 on the same product, the acquisition channel changed, not the product. Cohort segmentation also exposes product changes: a cliff at week 3 in the cohort that signed up the week of a feature launch is the cleanest A/B you will ever get for free.

## Sources

- Casey Winters, "Retention is the king of growth metrics," caseyaccidental.com; Reforge "Retention Engagement & Churn" course.
- Reforge faculty (Balfour, Rekhi, Winters, et al.), "Growth Series" curriculum; cohort-segmented retention is the spine.
- Mike Maples Jr., Floodgate (Pattern Breakers podcast and posts on the lies of blended retention).
- Tomasz Tunguz, "How to analyze cohort retention," tomtunguz.com (multiple posts on cohort decomposition for SaaS).
