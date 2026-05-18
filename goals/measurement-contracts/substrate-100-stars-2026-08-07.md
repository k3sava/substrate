---
bet_id: substrate-100-stars-2026-08-07
client: substrate
opened_at: 2026-05-07
opener: kesava
taste_owner: kesava
status: open

hypothesis: |
  Substrate's open-source positioning ("a context-first operating system
  for GTM"), MIT licensing, and codex grounding generate at least 100
  GitHub stars on k3sava/substrate within ninety days of v1.0 launch,
  with most coming from non-network users.

  Mechanism: HackerNews / Twitter / LinkedIn shareability of "I
  open-sourced my consulting framework" + AEO discoverability + network
  amplification from the maintainer's posts and the codex cross-link.

  Counterfactual: if star count is below 100 in 90 days, the README is
  not hooky enough OR distribution channels are not activated. The fix
  is iterating the README opener (sharper wedge, clearer one-line
  positioning) and posting on relevant forums (HN Show, r/marketing,
  PMM Slack groups), not adding more skills.

predicted_outcome: |
  GitHub star count on k3sava/substrate reaches at least 100 from
  non-network users by 2026-08-07. Network = the maintainer's LinkedIn
  first-degree + former colleagues from prior roles.

revenue_lever:
  lever_type: acquisition-CPL
  annual_revenue_impact_usd: null
  reason_for_null: |
    Stars are a top-of-funnel discoverability signal with no direct
    revenue mapping. Downstream conversion to inbound (G-002) and
    engagement (G-001) carries the revenue impact. Stars feed the
    funnel; the funnel produces revenue at G-001.
  calculation: |
    Not applicable directly. The funnel math: stars → watchers → forks →
    README-readers → site-visitors → inbound (G-002) → engagement
    (G-001). Conversion rates measured at each stage as the funnel
    accumulates data.

measurement_design: |
  Data source: GitHub API (`/repos/k3sava/substrate/stargazers`). Method:
  star count at resolution_date minus baseline (1 at v1.0 launch).
  Cohort: stargazers excluding the maintainer's known-network handles.

  Network filter:
    - Manual review of stargazer profiles against the maintainer's
      known-network handles list (kept private, off-repo).
    - A handle the maintainer recognises from prior roles or LinkedIn
      first-degree counts as network.
    - A handle the maintainer does not recognise counts as non-network
      even if they later turn out to be a mutual.

  Ambiguous case handling:
    - If a star comes from a username that was once the maintainer's coworker
      but he has lost touch with (no contact in 12+ months), count as
      non-network (out-of-touch = stranger now).
    - Bot-flagged accounts do not count toward the threshold.
    - Anonymous / pseudonymous accounts count as non-network unless
      identifiable as someone in the maintainer's known-network.

resolution_date: 2026-08-07
taste_type: positioning

predicted_p_threshold_met: 0.35  # opened 2026-05-07, kesava-set
substrate_layers_cited:
  - README.md
  - ORIGIN.md
  - docs/index.html
---

# Measurement contract: G-003 100 stars from non-network

The frontmatter above is the schema-formal definition. The why-this-matters narrative lives in `goals/why-this-matters.yaml :: G-003`. The summary view is in `goals/ledger.md :: G-003`.
