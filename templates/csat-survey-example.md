---
title: CSAT survey, canonical template
status: active
last_updated: 2026-05-08
purpose: Reference shape for csat-loop-design output. Operator-readable; not a live survey.
---

# CSAT survey template

This is the canonical shape `csat-loop-design` produces. The skill writes a per-client variant grounded in the client's brand voice, ICP, and product knowledge. This file is the reference template.

## Survey design

### Single primary question

```
On a scale of 1 (very dissatisfied) to 5 (very satisfied), how satisfied were you with the support you received today?
```

Five-point Likert scale. Not a 10-point NPS. CSAT is per-interaction; NPS is per-relationship. The two surveys serve different jobs and answer different questions; do not conflate them.

### Single follow-up question (open text)

```
What is the primary reason for your score?
```

One follow-up, not five. The open-text answer is the load-bearing data; multi-question surveys see drop-off rates above 60% and the verbatim language is what feeds the downstream analysis.

### Send timing rules

- Fires within 30 minutes of ticket resolution.
- Does not fire if the ticket was reopened within the last 7 days (the resolution did not stick; surveying about the prior interaction generates noise).
- Does not fire on a per-account basis more than once per 14 days (survey fatigue compounds and the data quality degrades; this matches the operator practice on relational NPS but at a tighter cadence because CSAT is per-interaction).

## Routing logic

### Promoter band (score 5)

Three branches, picked in order based on account state:

- **Reference / case-study branch** — if the account is high-fit, late-stage, and has not been asked for a reference in the last 90 days, route to a low-friction reference request. The request must include a "we will not ask again for 90 days" clause; over-asking promoters is the most common goodwill-burn failure mode.
- **Review request branch** — if the account is high-fit and active in a public review channel (G2, Capterra, vertical site), route to a review request with a direct link.
- **No-ask branch** — required option per Reichheld's loyalty research; some promoters are routed to a thank-you message that does not ask for anything. The brand-voice gate requires this branch exists. A program that asks every promoter for something is a program that depletes its promoter goodwill.

### Passive band (score 3 or 4)

- **Re-engage branch** — route to a follow-up that asks one question: "what would have made this a 5?" The verbatim answers compose into the product-feedback feed and the help-content gap-detect input. A passive who answers tells the company exactly what was missing; a passive who is ignored becomes a detractor on the next interaction.
- **Product feedback collection** — the verbatim answer routes into the product-feedback queue, tagged by category (the same categories the ticket carried).

### Detractor band (score 1 or 2)

Conditioned on ICP fit (per the save-everyone-vs-let-the-wrong-fit-go contradiction):

- **Save-call branch** — high-fit detractors get routed to a save call within 24 hours. The save call agenda is: read the ticket history, ask what is breaking, ask what would resolve it, name a concrete action, follow up in 7 days.
- **Honest-close branch** — low-fit detractors get routed to an honest "we may not be the right fit" follow-up. The follow-up names the mismatch and offers a clean off-ramp. Per Reichheld and Elliott-McCrea, investing save-call hours in low-fit detractors produces a treadmill, not a save.
- **Conditional triage branch** — mid-fit detractors get triaged based on time-in-product, expansion potential, and the specific ticket category. Triage criteria documented in the routing logic, not left to operator judgment in the moment.

## Voice constraints

The survey copy passes the same voice gate as customer-facing copy. Specifically:

- No em-dashes in body copy.
- No kill-list words (`orchestration`, `seamless`, `strategic`, `leverage`, `transform`, `holistic`, `synergy`, `bespoke`, `unlock`, `robust`, `sophisticated`, `comprehensive`).
- No throat-clearing openers ("We hope you're well," "Thanks so much for being a customer," etc.).
- Reads in customer language; mirrors the verbatim language in the source ticket cluster.

## Measurement contract

The CSAT program is a closed-loop program, not a metric. The measurement contract specifies:

- **Predicted close-the-loop rate**: percentage of surveys that produce a routed action (response, save call, reference request, honest close). Target depends on baseline; baseline must be measured for 4 weeks before opening the goal.
- **Predicted promoter-to-reference conversion**: percentage of routed promoter requests that produce a reference, review, or case study within 90 days.
- **Predicted detractor reactivation rate**: percentage of routed detractor saves that result in account retention at 90 days.
- **Resolution date**: 90 days from program launch.
- **Source of truth**: the survey response data plus the lifecycle-tooling action log; both must be referenceable when the goal resolves.

## Cadence calendar

- **Transactional**: per-ticket-resolution, with the 14-day per-account cap.
- **Relational** (separate program): not part of the CSAT loop. Relational satisfaction is the NPS loop's job; do not blend them.

## Substrate citations

- ICP layer: `clients/{client}/icp/icp.md` (drives detractor routing band selection).
- Brand voice: `clients/{client}/brand-voice/brand-voice.md` (drives copy gate).
- VoC: `clients/{client}/voc/voc.md` (mirrors customer language in survey body).
- Pattern: `knowledge/patterns/deflection-is-not-the-goal.md` (the survey is part of the right-routing system, not the deflection metric).
- Pattern: `knowledge/patterns/tickets-are-product-feedback-channel.md` (the open-text answer is product feedback substrate).
- Contradiction: `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md` (detractor routing condition).

## Template usage

This file is the reference. The `csat-loop-design` skill writes a client-specific variant under `clients/{client}/support/csat-program-spec-{date}.md` that picks the routing logic, the question wording (in client brand voice), the cadence, and the measurement contract specific to that client's substrate.
