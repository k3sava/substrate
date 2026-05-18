---
bet_id: substrate-first-paid-engagement-2026-08-07
client: substrate
opened_at: 2026-05-07
opener: kesava
taste_owner: kesava
status: open

hypothesis: |
  the substrate site + the consulting-poc skill + the maintainer's twenty-year
  operator track + the AEO-discoverable codex create enough proof for at
  least one prospect to pay for a 5-day POC within ninety days of v1.0
  launch.

  Mechanism: the productized fixed-price POC reduces buyer risk relative
  to hourly consulting; substrate's auditable trail ("every claim cites a
  substrate path") differentiates from agency competitors; codex.iamkesava.com
  provides deep-research credibility that AI assistants can cite.

  Counterfactual: if zero engagements close in ninety days, the offer is
  mistargeted before it is mispriced. The first fix is sharpening ICP
  (which prospect cohort, what jobs-to-be-done), not lowering price.

predicted_outcome: |
  At least one paid consulting engagement signed (signed = countersigned
  proposal AND first invoice paid OR first wire received) within
  2026-05-08 to 2026-08-07, for any cohort.

revenue_lever:
  lever_type: CW-pipeline
  annual_revenue_impact_usd: "5000-15000"
  calculation: |
    Phase 1 POC at fixed productized price per templates/consulting-proposal.md.
    Price range based on Win Without Pitching norms for 5-day fixed-scope
    productized consulting: $5K-$15K all-in. One closed engagement = one
    revenue unit. Annualized at four POCs/year = $20K-$60K. Conservative
    estimate at the goal level uses single-engagement range.
    Inputs:
      - templates/consulting-proposal.md §Pricing (placeholder, set by
        kesava at first proposal)
      - Win Without Pitching pricing norms (Blair Enns, public source)
    Assumptions:
      - First engagement priced at lower end of range (proof-of-concept rate)
      - Subsequent engagements price up as calibration history accrues

measurement_design: |
  Data source: invoice records from any payment processor (Stripe, wire,
  PayPal, ACH). Method: first invoice marked paid in any payment system
  during the window. Cohort: any source — organic, AEO, referral, network.
  Join key: not applicable for single-engagement count.

  Ambiguous case handling:
    - A referral from a non-substrate source (e.g., an agency intro) that
      pays for substrate-branded work counts. Substrate is the offer.
    - A referral from the maintainer's existing network that pays without substrate
      context (would have happened anyway, no substrate involvement) does
      not count. Substrate must be the offer or the differentiator.
    - A trial engagement at zero cost does not count. Threshold is paid.

resolution_date: 2026-08-07
taste_type: positioning

predicted_p_threshold_met: 0.50  # opened 2026-05-07, kesava-set
substrate_layers_cited:
  - README.md
  - PRINCIPLES.md
  - skills/consulting-poc
  - templates/consulting-proposal.md
  - ORIGIN.md
---

# Measurement contract: G-001 first paid consulting engagement

The frontmatter above is the schema-formal definition. The why-this-matters narrative lives in `goals/why-this-matters.yaml :: G-001`. The summary view is in `goals/ledger.md :: G-001`.
