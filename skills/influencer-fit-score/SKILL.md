---
name: influencer-fit-score
description: Score influencer fit against canonical ICP, brand voice, and audience overlap. Reads clients/<client>/social/influencers.yaml. Outputs a ranked list with disqualification reasons. Refuses without canonical positioning, brand voice, or an influencer roster. Per-account scoring across ICP fit, audience overlap with closed-won, content-voice alignment, prior-collaboration history, and platform-native shape.
version: 0.1
amplifies: social media lead, content marketer, brand-marketing lead, founder-led-growth operator
masters: Justin Welsh (creator economics and personal-brand collaboration discipline), Sahil Bloom (audience-quality-over-size), Adam Robinson (founder-led B2B social and warm-outbound from creator audiences), Yamini Rangan (employee-advocacy thesis applied to external creators), Chenell Basilio (creator-distribution teardowns and audience-overlap analysis), Joe Pulizzi (Content Marketing Institute on creator-collab discipline)
substrate_layers_required: [positioning, icp, brand-voice, competitive]
patterns_grounded: [creator-not-corporate, social-as-distribution-not-conversion, native-format-beats-cross-post, distribution-as-moat, copywriting-craft-fundamentals]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-positioning, missing-brand-voice, missing-influencers
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
  - clients/{client}/07-brand-voice.md
---

# influencer-fit-score

## Purpose

Take a roster of candidate influencers (declared in `clients/<client>/social/influencers.yaml`) and score each one against five fit dimensions: ICP fit, audience overlap with closed-won, content-voice alignment, prior-collaboration history, and platform-native shape. Emit a ranked list with per-influencer scores and a one-line rationale per dimension. Disqualify on hard-rules (kill-list voice, anti-ICP audience, brand-safety flags) before scoring; soft-flag on partial fit; recommend a tier (1A primary partner, 1B exploratory, 2 watch, defer).

The skill refuses without canonical positioning because there's no anchor for the fit score. It refuses without brand voice because the voice-alignment check has nothing to compare. It refuses on a missing influencers.yaml because there's no roster to score.

The fit model is read from canonical substrate, not invented per session. The ranking compounds across cycles because the same canonical position scores every roster the same way; differences in score come from candidate quality, not from drifting criteria.

## Inputs

- `--client <client>` (required)
- `--influencers <yaml>` (optional, default `clients/<client>/social/influencers.yaml`)
- `--platform <linkedin|x|tiktok|instagram|youtube>` (optional) — restrict scoring to one platform's roster
- `--top-n <int>` (optional, default `25`) — truncate output to the top N
- `--audience-overlap-csv <path>` (optional) — closed-won-deal contacts list to compute audience overlap
- `--out <path>` (optional, default `clients/<client>/social/influencer-rankings/<YYYY-MM-DD>.md`)

## Substrate reads

- `clients/<client>/01-position.md` — canonical statement, value pillars, anchor terms
- `clients/<client>/02-icp.md` — industries, sizes, role and seniority hints
- `clients/<client>/04-competitive.md` (optional) — to flag influencers who currently work with named competitors (a brand-safety surface, not necessarily a disqualifier)
- `clients/<client>/07-brand-voice.md` — kill-list, voice patterns
- `clients/<client>/social/influencers.yaml` — the candidate roster

## Influencers YAML shape

```yaml
# clients/<client>/social/influencers.yaml
influencers:
  - handle: "@operator-name"
    name: "Real Name"
    platform: linkedin            # one of linkedin, x, tiktok, instagram, youtube
    follower_count: 48000
    audience_role: ["head of sales", "VP sales", "CRO"]   # claimed audience composition
    audience_industry: ["SaaS", "B2B services"]
    primary_topics: ["sales-ops", "pipeline-coverage", "outbound-discipline"]
    voice_signals: ["plain-spoken", "data-cited", "founder-tone"]
    prior_collabs: ["company-a", "company-b"]
    competitor_collabs: []         # named competitors this influencer currently posts about
    brand_safety_flags: []         # known issues (off-brand controversy, plagiarism, etc.)
    sample_posts:                  # 3-7 representative permalinks
      - "https://www.linkedin.com/posts/example-1"
      - "https://www.linkedin.com/posts/example-2"
    notes: "<free text from the operator>"
```

The schema is documented in `templates/social-influencers-example.yaml`.

## Scoring dimensions

Each dimension scores 0-1; the composite is a weighted sum normalised to 0-100.

| Dimension | Weight | Source | Hard rules |
|---|---|---|---|
| `icp_fit` | 0.30 | `02-icp.md` industries + roles vs influencer's `audience_role` and `audience_industry` | Anti-ICP industry → score 0, disqualify |
| `audience_overlap` | 0.25 | optional `--audience-overlap-csv` of closed-won; intersection vs follower count | If supplied and overlap is < 1%, soft-flag low-relevance |
| `voice_alignment` | 0.20 | `07-brand-voice.md` kill-list against influencer's `voice_signals` and a sampled-post token check | Kill-list overlap >2 → score 0, disqualify |
| `topic_alignment` | 0.15 | `01-position.md` anchor terms vs influencer's `primary_topics` | <1 anchor overlap → soft-flag |
| `prior_relationship` | 0.10 | `prior_collabs` vs `competitor_collabs` | Active competitor exclusivity → disqualify |

A `brand_safety_flags` non-empty list triggers an immediate disqualification with the flags surfaced.

## Tier bands

| Tier | Composite range | Recommended pursuit |
|---|---|---|
| 1A | 75-100 | Primary partner; lead with co-authored long-form content + cross-promotion |
| 1B | 55-74 | Exploratory; one-off collaboration with a measurement contract |
| 2 | 35-54 | Watch; track for 90 days, re-score |
| defer | 0-34 | Do not pursue this cycle |
| dq | n/a | Disqualified per hard rule; reasons surfaced |

## Process

1. Preflight via shared library: required reads, required layers, declared patterns.
2. Read positioning; extract canonical statement, pillars, uniques, anchor terms.
3. Read ICP; extract industries, roles, anti-industries.
4. Read brand voice; extract kill-list.
5. (Optional) read competitive layer for competitor-collab cross-reference.
6. Read influencers.yaml; validate shape; collect handles.
7. (Optional) load closed-won-overlap CSV; compute per-influencer overlap fraction.
8. For each influencer, score across the five dimensions; apply hard rules; assign tier.
9. Sort by composite descending; truncate to top-N.
10. Write the ranked report with per-influencer block, disqualification reasons, and per-tier guidance.

## Output contract

Writes `clients/<client>/social/influencer-rankings/<YYYY-MM-DD>.md`:

```yaml
---
ranking_id: <client>-influencer-rank-<YYYY-MM-DD>
client: <client>
roster_size: <int>
scored_size: <int>
disqualified_size: <int>
substrate_layers_read: [positioning, icp, brand-voice, competitive]
patterns_applied: [creator-not-corporate, social-as-distribution-not-conversion, native-format-beats-cross-post, distribution-as-moat, copywriting-craft-fundamentals]
contradictions_resolved: []
produced_by: influencer-fit-score
authored_date: <YYYY-MM-DD>
---
```

Body sections:

1. **Summary** — roster size, disqualified count, tier distribution.
2. **Tier 1A primary partners** — composite, dimension breakdown, one-line rationale per influencer.
3. **Tier 1B exploratory** — same shape, plus the recommended-test angle.
4. **Tier 2 watch** — same shape, with the 90-day re-score note.
5. **Disqualified** — handle, reason (hard-rule citation).
6. **Audience-overlap notes** — if CSV supplied, surface the absolute overlap counts; per `pat_social-as-distribution-not-conversion`, this is a cohort-level metric, not a last-click attribution.
7. **Distribution note** — frame the rankings against `pat_creator-not-corporate` (personal accounts compound) and `pat_distribution-as-moat` (rented vs earned).
8. **Substrate citations** — every load-bearing claim cites a substrate path.

## Quality criteria

- Every disqualification cites the rule that fired.
- No invented follower counts or audience claims; if the operator hasn't supplied a number, the score reflects unknown.
- The audience-overlap dimension scores 0 when no CSV is supplied (so the model doesn't lie about coverage it doesn't have).
- Tier 1A is rare by design; the band is narrow and the hard rules are stricter at the top tier.

## What this skill does NOT do

- Does not scrape platform APIs. The roster is operator-curated.
- Does not contact influencers. It scores fit; the operator runs outreach.
- Does not commit to a partnership; the output is a ranking, not a contract.
- Does not measure post-collab performance. That's `social-fatigue-monitor` plus `social-amplification-test` plus a measurement contract.
- Does not pick a global default for personal-vs-corporate; the influencer's own account type carries through.

## Refusal patterns

- Missing canonical positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Missing brand voice returns `SUBSTRATE-GAP — missing-brand-voice`.
- Missing influencers roster returns `INPUT-GAP — missing-influencers` with the expected path.
- Influencers YAML with a missing required field per influencer is reported as `INPUT-WARN — schema-incomplete` per row; the row is not scored.
- Disqualification on hard rules is not an error; the disqualified rows are surfaced with reasons.

## See also

- `social-content-design` — design the influencer co-authored draft.
- `social-amplification-test` — measure the lift of an influencer post against the operator's own.
- `social-listening-themes` — feed audience comments back into the fit model on the next cycle.
- `competitive-scout` — flag competitor-collab signals before they bend brand-safety.
- `routines/social-content-cycle.md` — the weekly loop that consumes the ranking.
- `knowledge/patterns/creator-not-corporate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
- `knowledge/patterns/distribution-as-moat.md`
