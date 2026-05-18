---
id: pat_segment-of-one-vs-cohort-aggregate
title: Both views needed; segment-of-one user-record analysis catches what cohort aggregates hide, and vice versa
captured_date: 2026-05-08
convergence_count: 3
tier: A
domains: [analytics-attribution, growth, customer-success, product]
---

# Segment of one and cohort aggregate, both views

## Convergence

Three operators with growth-analytics track records converge on the same complaint about how teams read product data: most analytics work happens at the cohort-aggregate level (cohort retention curves, funnel conversion rates, segment averages), and most actionable signal lives one level below at the segment-of-one level (the individual user-record path through the product). Cohort aggregates tell you the curve; user-record paths tell you why the curve has its shape. Teams that work only at the aggregate level miss the failure modes individual users hit. Teams that work only at the user-record level miss the structural patterns. Both views are necessary and they answer different questions.

The shape repeats: aggregate-for-shape, segment-of-one-for-mechanism, switch-deliberately, reconcile-the-views. Operators differ on the tooling (some use Amplitude pathfinder + cohort builder, some use raw warehouse SQL, some sit a CSM next to a single user's session replay) but converge on the claim that one view alone is incomplete. A team that has only one view is operating on partial substrate.

## Operators

- **Casey Winters**, ex-Pinterest, ex-Eventbrite, Reforge. Winters has written that the strongest product-analytics work alternates between cohort retention curves (the structural diagnostic) and individual user-path analysis (the mechanism diagnostic). The cohort tells you the W4 retention dropped; the user-path analysis tells you that the new-onboarding flow lost a step that activated three of the top four retention drivers. Without the second view, the cohort drop becomes a hypothesis-generation exercise rather than a diagnosis.
- **Lenny Rachitsky**, Lenny's Newsletter, ex-Airbnb. Rachitsky's interviews with growth practitioners repeatedly surface the same observation: the operators with the highest hit rate on retention experiments are the ones who watch real users move through the product, not the ones who only read dashboards. Sitting with a CSM who is on a churn-save call, watching one user struggle through a new feature, reading verbatim support tickets, these are segment-of-one inputs that the dashboard cannot generate. The dashboard tells you what is happening; the user record tells you why.
- **Avinash Kaushik**, ex-Google, "Web Analytics 2.0." Kaushik has argued for two decades that "data without context is just noise; context without data is just opinion." His operating rule (the "10/90 rule" of analytics: 10% of effort on tools, 90% on people-and-process) is fundamentally an argument that aggregate analytics is incomplete without qualitative grounding. The qualitative grounding is the segment-of-one work: customer interviews, session replays, support-ticket reads, in-product behavior pathing. Both halves are required.

## Variation

- Winters frames it through the *retention-curve mechanism gap* (cohort curves diagnose shape; user paths diagnose mechanism).
- Rachitsky frames it through the *high-hit-rate-operator habit* (the best operators watch real users, not just dashboards).
- Kaushik frames it through the *10/90 rule* (the analytics work is the people-and-process work, not the tool work).
- Convergence: aggregate alone is incomplete; segment-of-one alone is anecdote; both views, switched between deliberately, are the work.

## Implication

A team's analytics practice carries two layered surfaces: an aggregate layer (cohort curves, funnels, segment averages, dashboards) and a segment-of-one layer (user-record paths, session replays, support ticket reads, customer interview transcripts). Skills must declare which layer they operate on and when to escalate to the other.

The substrate hooks: when a cohort retention drop fires, the diagnosis pipeline runs at the segment-of-one level (read N user records from the affected cohort, identify the path divergence, name the mechanism). When a user-record observation surfaces a hypothesis, the validation runs at the aggregate level (does the pattern reproduce across the cohort?). Each view fact-checks the other. A team that runs only one of these is shipping work on incomplete substrate.

The metric tree (per `metric-tree-not-metric-stack`) sits at the aggregate level. The user-record tools (session replay, customer interviews, account-level event timelines) sit at the segment-of-one level. The connection is: every aggregate metric should be traceable down to a user-record narrative, and every user-record observation should be testable up to an aggregate query. Skills that surface only one view without the bridge are providing partial signal.

When two analytics outputs disagree, the disagreement is signal. Aggregate says retention is fine; CSM says churn is rising; the discrepancy is the work. The team that resolves it does both views; the team that picks one view picks wrong.

## Sources

- Casey Winters, multiple Reforge posts on retention and user-research practice, reforge.com / caseyaccidental.com.
- Lenny Rachitsky, Lenny's Newsletter interview corpus on growth practitioners (Airbnb, Stripe, Notion, Linear, Figma, Webflow case studies), lennyrachitsky.com.
- Avinash Kaushik, "Web Analytics 2.0" (2010) and the kaushik.net archive on the 10/90 rule, qualitative grounding, and HiPPO problem (highest-paid-person's-opinion).
