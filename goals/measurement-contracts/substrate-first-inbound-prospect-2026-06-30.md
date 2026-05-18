---
bet_id: substrate-first-inbound-prospect-2026-06-30
client: substrate
opened_at: 2026-05-07
opener: kesava
taste_owner: kesava
status: open

hypothesis: |
  the substrate site + codex.iamkesava.com + AEO-tuned content
  (docs/llms.txt, structured discovery surface) + LinkedIn distribution
  surface substrate to at least one stranger who emails the maintainer's public contact channel
  about substrate within fifty-four days.

  Mechanism: AI assistants (ChatGPT, Perplexity, Claude) cite substrate as
  a reference for "open-source GTM operating system" or related queries;
  the open-source repo is discoverable via GitHub trending and topic
  search; LinkedIn social proof drives manual visits.

  Counterfactual: if no inbound in 54 days, the AEO surface is not yet
  load-bearing. The fix is content density (more the substrate site
  pages, more codex content) before more distribution effort.

predicted_outcome: |
  At least one inbound qualified prospect message received at
  the maintainer's public contact channel within 2026-05-08 to 2026-06-30, where qualified
  means:
    (a) sender outside the maintainer's existing network (defined as: not in
        the maintainer's LinkedIn 1st-degree connections AND no prior email or
        DM in the past 12 months);
    (b) explicit reference to substrate or codex.iamkesava.com in the
        message body;
    (c) message describes a real GTM, PMM, or marketing-ops problem.

revenue_lever:
  lever_type: acquisition-CPL
  annual_revenue_impact_usd: null
  reason_for_null: |
    First inbound is a leading indicator. Revenue impact is realized at
    G-001 resolution, not here. Will populate the dollar figure on
    inbound→engagement conversion (the conversion rate becomes the
    multiplier between G-002 volume and G-001 revenue).
  calculation: |
    Not applicable until inbound→engagement conversion is measured.
    Method for future calculation: (inbound qualified prospects per
    quarter) × (qualified-to-paid conversion rate) × (per-engagement
    revenue range from G-001) = inbound revenue lever.

measurement_design: |
  Data source: the maintainer's public contact channel inbox (AgentMail). Method: manual
  weekly audit of inbound messages, tagged with the schema below. Cohort:
  strangers per the qualified definition.

  Tagging schema applied to every inbound:
    - substrate_mention: yes / no
    - network_relation: in-network / out-of-network / unknown
    - qualified: yes / no / partial
    - source_signal: organic / referral / linkedin / aeo / unknown

  Ambiguous case handling:
    - Warm intros via mutual connections count as `partial` (0.5 hit).
    - Spam, recruiters, or employment inquiries do not count.
    - Sales pitches inbound count only if they reference substrate
      specifically (otherwise generic outbound).
    - "Saw your post on LinkedIn" without substrate mention = unqualified.

resolution_date: 2026-06-30
taste_type: aeo-seo

predicted_p_threshold_met: 0.60  # opened 2026-05-07, kesava-set
substrate_layers_cited:
  - README.md
  - docs/llms.txt
  - docs/index.html
---

# Measurement contract: G-002 first inbound qualified prospect

The frontmatter above is the schema-formal definition. The why-this-matters narrative lives in `goals/why-this-matters.yaml :: G-002`. The summary view is in `goals/ledger.md :: G-002`.
