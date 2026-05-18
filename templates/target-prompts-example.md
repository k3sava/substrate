---
asset_type: aeo-target-prompts
client: example-client
last_updated: 2026-05-08
---

# Target prompts — example-client

Canonical list of buyer-side prompts the brand wants to win citations on. Used by:

- `skills/aeo-relevance` (score relevance per asset against this prompt set)
- `skills/aeo-manual-action` (action plans keyed to a single prompt)
- `skills/aeo-tune` (per-vertical AEO pass)

Each entry: an id (slug), an intent label, the prompt text as the buyer would phrase it,
and the source (where the prompt was captured).

## prompt-id-1: solution-aware

What's the best alternative to [incumbent-tool] for SMB customer support?

Source: clients/example-client/voc/processed/win-loss/2026-q1-summary.md

## prompt-id-2: problem-aware

How do I reduce customer support response time without hiring more agents?

Source: clients/example-client/voc/processed/calls/2026-04-15-discovery-acme.md

## prompt-id-3: comparison

[example-client] vs [competitor-a] for help-desk software

Source: clients/example-client/competitive/competitor-a-battle-card.md

## prompt-id-4: most-aware-pricing

[example-client] pricing for 50-agent team

Source: clients/example-client/voc/processed/calls/2026-04-22-pricing-question.md

## prompt-id-5: troubleshooting

How to set up [example-client] integration with Slack

Source: clients/example-client/help-docs/integrations/slack.md

# How to use

1. Replace the example prompts above with actual prompts captured from your call corpus,
   support tickets, and search-console queries.
2. Tag each prompt with an `intent label` (unaware / problem-aware / solution-aware /
   product-aware / most-aware) — the same five-stage frame used in the messaging matrix.
3. Run `bin/substrate aeo-relevance --client <client> --asset <path> --mode gap-analysis`
   to score the prompt × asset matrix and surface unmet prompts.
4. For unmet prompts, run `--mode content-brief --prompt-id <id>` to draft the missing
   passage shape per `pat_passage-as-citation-unit`.
