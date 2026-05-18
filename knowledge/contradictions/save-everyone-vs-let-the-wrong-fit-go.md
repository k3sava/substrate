---
id: con_save-everyone-vs-let-the-wrong-fit-go
title: Save every churn vs. let the wrong-fit churn happen
captured_date: 2026-05-08
---

# Save every churn vs. let the wrong-fit churn happen

## Position A, Every churn is saveable; run save-call programs

- Operator: Lincoln Murphy (`Customer Success: How Innovative Companies Are Reducing Churn and Growing Recurring Revenue`, sixteenventures.com), Nick Mehta (Gainsight CEO; "The Customer Success Economy" with Allison Pickens)
- Claim: Churn is a CS execution failure unless explicitly proven otherwise. The default posture is to fight every churn with a save call, an outcome reset, an executive escalation, or a tier change. The cost of a save attempt is small relative to the LTV at risk, and the data from save calls feeds back into product, pricing, and onboarding. Even churns that don't save produce signal. A program that "lets churn happen" without an attempt is leaving revenue and learning on the table.

## Position B, Wrong-fit churn is healthy churn; investing in saves is misallocation

- Operator: Frederick Reichheld (Bain, "The Loyalty Effect"; NPS/loyalty research argues that ICP misfit produces low-quality revenue and detractor behavior that costs more than it brings), Kellan Elliott-McCrea (ex-Etsy CTO, ex-Blink; published "The Cost of an Unhappy Customer" and posts on prioritizing PMF-fit customers over save-everyone churn programs)
- Claim: Churn from accounts that never matched the ICP is a *correction*, not a failure. Investing CS hours in saving them produces a treadmill: they're saved this quarter, they leave next quarter, and meanwhile high-fit accounts get less attention. The CS economy of attention is finite; spending it on wrong-fit saves is misallocation, both economically (the LTV is lower and the cost-to-save is higher) and culturally (the team optimizes for retention metrics that don't translate to revenue per operator). The save program also sends the wrong product signal: features get built for the saved accounts, drifting the product away from the ICP.

## Conditions distinguishing them

- **ICP fit score**: When the churning account scores high on ICP fit (firmographic match, expected value-event behavior present early), the churn is recoverable and Position A applies. When the churning account scores low on ICP fit (firmographic mismatch, never adopted core value events, support tickets indicate persistent confusion), the churn is correction and Position B applies. Without an ICP fit score, the team applies Position A by default and pays the misallocation tax.
- **Time-in-product before churn**: Early churn (before the activation event) is usually fit-driven; investing in saves at this stage produces noise. Late churn (after activation, after retention curve flattening) is usually intervention-driven (price change, champion left, integration broke); save attempts here have meaningful conversion. The two stages need different programs, not the same save-call playbook.
- **Expansion potential of the account**: A churning account whose usage trajectory implied expansion in another quarter is worth a save attempt regardless of cost. A churning account at flat-line usage with no expansion signal is, at best, a low-cost in-product save attempt; sending the AE to fight for it is misallocation.
- **CS bandwidth**: When CS hours are abundant, Position A's "every save attempt produces learning" defense holds. When CS hours are constrained (which is the steady state), Position B's "wrong-fit saves displace high-fit work" defense wins. Most teams operate in the constrained state and apply the abundant-state playbook by default.

## Resolution / synthesis

Both positions agree on the editing rule: spend CS hours on the saves with the highest expected value. They disagree on the *prior* placed on saveability.

- Murphy and Mehta place a high prior: most churn is saveable, default to saving, learn from the misses.
- Reichheld and Elliott-McCrea place a low prior: most wrong-fit churn is healthy, default to letting it go, focus the saved hours on high-fit retention and acquisition-quality work.

Synthesis: *condition the save-program on the ICP fit score and the time-in-product*. High-fit, late-stage churn gets the full save playbook (Position A). Low-fit, early-stage churn gets the cheapest possible in-product save attempt or no attempt (Position B). The contradiction surfaces when teams apply one rule to the whole base; it dissolves when the rule is conditioned on fit-score-times-stage.

A `win-back-sequence` skill must read the conditioning. For a cohort with high ICP fit and late-stage churn, the sequence carries the full Murphy-style save playbook (named champion outreach, executive call, outcome reset). For a cohort with low ICP fit, the sequence is restricted to a low-cost automated touch and an honest "we may not be the right fit" close. Skills that ignore the conditioning end up running the same save sequence on both cohorts and lose on both.

The substrate hooks: `churn-diagnose` reads ICP layer + time-in-product + expansion signal to score each churned cohort on the conditioning axes. `win-back-sequence` reads the score and picks Murphy or Reichheld locally, with the choice logged on the artifact. There is no global default, the contradiction stays open, the skill picks per cohort.
