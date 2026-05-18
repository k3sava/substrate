---
slug: gtm-engineer
axis: internal-org
role: GTM Engineer / RevOps Engineer
seniority: senior IC
company_stage: growth
company_size: 201-1000
verticals: [b2b-saas]
tech_stack: [Salesforce, HubSpot, dbt, Hex, Slack, Python]
decision_authority: influencer
buyer_state: most-aware
attribution: synthetic-but-grounded
last_updated: 2026-04-30
substrate_grounded_by:
  - substrate/shared/synthetic-audience/personas/internal/gtm-engineer-teammate.md
---

# The GTM engineer

## One-line snapshot
Builds substrates that turn marketing + sales + CS data into shipped systems, evaluates work by whether it's reusable, instrumented, and survives a Monday.

## Daily reality
She opens dbt, the warehouse, the Slack alerts channel, and a Hex notebook. She's wiring a HubSpot-to-Salesforce dedup pipeline. She's also building a synth-audience scoring service.

## Goals (top 3, ranked)
1. Ship 1 reusable substrate per sprint.
2. Auto-instrument every shipped asset.
3. Reduce one-off requests by 40%.

## Frictions (top 5)
- One-off requests from PMM that should be self-serve.
- Brittle attribution models.
- Tools that don't expose webhooks.
- Slack-as-system-of-record for ops decisions.
- Lack of test environments.

## Decision criteria
- must-have: API depth, webhook events, sandbox, SCIM, CSV export.
- nice-to-have: SDKs, GraphQL, terraform provider.
- deal-breaker: closed system with no extensibility.

## Voice + tone signature
- writes like: code comments. Bullet lists. "If X, then Y, else Z."
- pet peeves: vendors that don't publish webhook event references.
- forwards content when: someone publishes a clean architecture diagram.

## Objections to expect
- "Webhook event reference — public and versioned?"
- "Sandbox — same shape as prod?"
- "Rate limits — published?"
- "API auth — OAuth, API key, JWT?"
- "Bulk export — full or paginated only?"
- "SCIM — full schema?"
- "Terraform provider — official or community?"

## Sample reactions
- Outcome-led hero copy: "fine for the buyer. Send me the API docs."
- Feature-list copy: "where's the integration architecture?"
- Social-proof-heavy LP: "logos help. The Stripe-style API doc is the unlock."
- AI-feature pitch: "what's the API surface? Can I call the [product feature] from a workflow?"

## Synth-audience scoring weights
- outcomes-language importance: low
- differentiation importance: high (API depth)
- voice-fit importance: med
- proof-density importance: very high (engineering blog + architecture diagrams)

## What would make THIS persona share / forward
- A clean webhook event reference.
- An engineering blog post about scaling decisions.
- A terraform provider on GitHub.

## What would make THIS persona disengage
- Closed system.
- "Talk to your CSM for API access".
- No sandbox.
