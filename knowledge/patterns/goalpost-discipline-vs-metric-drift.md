---
id: pat_goalpost-discipline-vs-metric-drift
title: Lock the measurement contract before the goal opens; metric definitions drift mid-quarter when locking happens after
captured_date: 2026-05-08
convergence_count: 3
tier: A
domains: [analytics-attribution, leadership-revops, pmm]
---

# Goalpost discipline beats metric drift

## Convergence

Three operators with revenue-and-retention track records converge on the same failure mode: a metric defined casually at the start of a quarter mutates by the time the quarter resolves. The cohort definition shifts. The attribution window flexes from 7 days to 30 days. "Active user" gains a qualifier. The number that originally meant one thing now means another, and whoever is reporting picks the definition that makes the result look best. The fix is structural: the measurement contract is written and frozen before the goal opens. The contract names the metric, the cohort, the source-system query, the attribution window, the resolution date, the kill criterion. Mid-quarter changes require an explicit override with attribution. Without that discipline, every quarter's report is a reconstruction.

The shape repeats: write-the-contract, freeze-the-contract, log-the-override, audit-the-result. Operators differ on the form of the contract (some use a goal doc, some use a SaaS tool, some use a wiki page) but converge on the claim that locking precedes opening. A team that opens goals before locking metrics is operating on retroactive-narrative substrate; the contract is what makes the goal falsifiable.

## Operators

- **Patrick Campbell**, founder ProfitWell, now Paddle. Campbell's research at ProfitWell repeatedly surfaces the same finding: SaaS teams report retention numbers that do not survive cross-cohort definition. The same product, measured under three "active user" definitions, produces three retention numbers, and teams cite whichever supports this quarter's narrative. ProfitWell's standardization push (the Recur Studios benchmarking series, the "honest retention" research) is fundamentally a goalpost-discipline argument: lock the definition or accept that you don't know the number.
- **Tomasz Tunguz**, partner at Theory Ventures (formerly Redpoint), prolific SaaS metrics writer. Tunguz has written that metric drift is the silent killer of SaaS reporting: definitions creep across quarters, dashboards are rebuilt with new filters, and year-over-year comparisons become meaningless. His "metrics covenant" framing argues that the operator who wrote the metric definition is the only person who can change it, and only with a logged change-note. Without that, the metric is folklore.
- **Frederick Reichheld**, Bain partner emeritus, Net Promoter creator. Reichheld's work on NPS and loyalty stresses one operational point above all: the survey instrument and the cohort definition must be frozen and reused across periods, or the score reads as noise. The original "Ultimate Question" framework specifies the wording, the scale, the timing, and the cohort precisely because moving any of those mutates the number. Goalpost discipline is loyalty-research methodology applied to all retention metrics.

## Variation

- Campbell frames it through *standardization research* (retention numbers don't agree across definitions).
- Tunguz frames it through *the metrics covenant* (definitions are owned, change-logged, and audited).
- Reichheld frames it through *survey-instrument discipline* (NPS as a worked example of the broader rule).
- Convergence: a metric without a frozen definition is folklore; the contract is what turns it into data.

## Implication

A goal opens only when the measurement contract is written, sourced, and frozen. The contract carries: (1) the metric name and one-sentence definition; (2) the source-system query (chart ID, event filter, SQL fragment); (3) the cohort definition with substrate citation; (4) the attribution model and window; (5) the resolution date; (6) the kill criterion; (7) the predicted_p (operator's prior probability of YES). Mid-quarter changes are logged as overrides with attribution; the override counts in the operator's calibration record.

Skills that open goals without writing the contract are violating the discipline. Skills that resolve goals without checking that the contract was honored are accepting drift. The substrate hook: every goal in `goals/ledger.md` cites a measurement contract under `goals/measurement-contracts/`. The pre-publish-check refuses to ship a goal report whose contract path is missing or whose contract has been edited after open.

The audit pattern: a quarterly review reads the resolved goals against their contracts, surfaces any silent edits, and updates the operator's calibration. Honest losses count as much as honest wins; a quarter with no surfaced drift is a quarter with surfaced calibration. Without the audit, goalpost drift becomes the default and the calibration record decays into theater.

## Sources

- Patrick Campbell, ProfitWell / Recur Studios research on SaaS retention measurement (multiple posts on standardized retention definitions, the Recur podcast series, paddle.com blog).
- Tomasz Tunguz, "tomtunguz.com" archive on SaaS metrics, multiple posts on metric definition drift, board-meeting metrics, and the cost of unstandardized retention numbers.
- Frederick Reichheld, "The Ultimate Question 2.0" (2011) and the original NPS methodology specification (Bain), which prescribes the wording, scale, timing, and cohort discipline as the load-bearing methodology behind the score.
