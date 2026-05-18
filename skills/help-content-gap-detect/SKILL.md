---
name: help-content-gap-detect
description: Cross-reference ticket clusters with the existing help-docs catalog. Outputs a ranked list of content gaps (clusters with no matching article), drift candidates (articles whose source clusters have evolved), and stale articles (catalog entries with no matching cluster). Suggests article topics in customer language pulled verbatim from tickets. Refuses without a help-docs catalog path or a ticket-clusters input.
version: 0.1
amplifies: head of support, head of CS, head of content, PMM lead, head of growth
masters: Tom Johnson (I'd Rather Be Writing — docs as a discipline), Stripe Docs team (the canonical SaaS docs bar), Brendan Hufford (3S — support is content), Yamini Rangan (start with support for fastest AI ROI), Patrick Campbell (cohort-level diagnostic from tickets)
substrate_layers_required: [voc, product-knowledge]
patterns_grounded: [tickets-are-product-feedback-channel, distribution-as-moat]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-clusters, missing-help-catalog
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/voc/voc.md
  - clients/{client}/product-knowledge/product-knowledge.md
---

# help-content-gap-detect

## Purpose

Take the cluster output from `ticket-cluster-analysis` and cross-reference it with an existing help-docs catalog. Surface three kinds of finding:

1. **Content gaps** — clusters of tickets with no matching help article. These are the priority topics the docs team should write.
2. **Drift candidates** — articles whose original ticket clusters no longer match the current ticket language. The article is stale or the ticket cluster has evolved; either way, the article needs a refresh pass.
3. **Stale articles** — articles in the catalog that no longer correspond to a meaningful ticket cluster. Deprecation candidates.

Per the `tickets-are-product-feedback-channel` pattern, the ticket corpus is the substrate the help catalog should match. Per `distribution-as-moat`, help docs are an AEO-citation surface and a long-term distribution moat; gaps in the catalog cost both deflection and AEO presence.

## Inputs

- `--client <client>` (required)
- `--clusters <path>` (required), JSON output from `ticket-cluster-analysis` (canonical shape: `clients/<client>/support/ticket-clusters-{date}.json`).
- `--help-catalog <path>` (required), the existing help-docs catalog. Accepted shapes: a directory containing `*.md` files (each with frontmatter `title:` plus optional `topic:` and `source_clusters:`); or a CSV with columns `article_id`, `title`, `topic`, `slug`, optional `source_clusters` (semicolon-delimited cluster_ids); or a JSON file at the same shape.
- `--match-threshold <float>` (default: 0.30), token-overlap Jaccard threshold above which a cluster is considered "covered" by an article.
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/voc/voc.md`, to cross-check that suggested topic phrasing matches documented customer language.
- `clients/{client}/product-knowledge/product-knowledge.md`, to flag suggestions that imply product behaviors not in the manifest.

## Process

1. **Preflight**. Verify the clusters JSON, the help catalog path, and substrate layers exist. Refuse with `missing-clusters`, `missing-help-catalog`, `substrate-gap` as appropriate.
2. **Load clusters**. Parse the cluster JSON; extract per-cluster top tokens and suggested topics.
3. **Load help catalog**. Parse the catalog (directory of markdown / CSV / JSON). Build a per-article token signature from title + topic + (when present) the article body's first 800 characters.
4. **Match**. For each cluster, compute Jaccard similarity between its top-N tokens and each article's token signature. The best match above `--match-threshold` is the covering article.
5. **Classify**. Each cluster is *covered* (matched), *gap* (no match above threshold), or *partial* (best match is between 0.15 and the threshold; surfaced as "weak coverage").
6. **Drift detection**. For articles with declared `source_clusters`, check whether the current cluster's tokens still match. If the article declares cluster X and the current cluster X has top tokens disjoint from the article, flag drift.
7. **Stale detection**. For articles in the catalog with no matching cluster (zero clusters above threshold), flag as stale candidates. Operator decides whether to deprecate.
8. **Suggested topics**. For each gap cluster, pull the suggested topic from the cluster JSON and pull a representative customer-language fragment from the cluster's sample tickets. Output the topic phrasing in customer language, never invented.
9. **Output**. Write three artifacts: markdown report, JSON sidecar, and a CSV gap queue for downstream `help-docs` runs.

## Output contract

Three artifacts under `clients/{client}/support/`:

1. `help-content-gaps-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Catalog summary (n articles, n with declared source clusters).
   - Cluster summary (n clusters, n covered, n gap, n partial).
   - Ranked content gap queue: cluster size × CSAT-deficit × no-coverage. The largest, lowest-CSAT, uncovered clusters rank first.
   - Drift candidates: articles whose source-cluster tokens no longer match.
   - Stale candidates: articles with no matching cluster.
   - Suggested article topics in customer language.
   - Substrate citations.
2. `help-content-gaps-{YYYY-MM-DD}.json`, structured per-cluster coverage data.
3. `help-content-gap-queue-{YYYY-MM-DD}.csv`, ranked queue for the docs team.

## Quality criteria

- Refuses without a clusters JSON; this is the substrate the cross-reference reads.
- Refuses without a help catalog path; the gap analysis is the cross-reference, not a dump of clusters.
- Suggested topics are pulled verbatim from the cluster JSON (which itself pulled from ticket bodies). The skill never invents a topic phrasing.
- Match threshold is configurable but defaults to 0.30; document the calibration choice in the output.
- Articles flagged as stale are surfaced as candidates, not auto-deprecated. Operator decides.

## What this skill does NOT do

- Does not write articles. That is `help-docs`.
- Does not score AEO presence. That is `aeo-relevance`.
- Does not run a deflection experiment. That is `deflection-experiment-design`.
- Does not invent article topics. The skill refuses to surface a topic that does not appear verbatim in the cluster's sample tickets.

## Refusal patterns

- `substrate-gap`: missing voc or product-knowledge layer.
- `missing-clusters`: clusters JSON path not present.
- `missing-help-catalog`: help catalog path not present.
- `low-coverage`: warning (not refusal) when more than 70% of clusters are gaps; flags the catalog as systematically thin.

## Composes with

- Reads from: clusters JSON (from `ticket-cluster-analysis`), help-docs catalog.
- Writes for: `help-docs` (which reads the gap queue to know what to write next), `aeo-relevance` (which reads the catalog to score AEO presence).
- Triggered by: monthly support cluster routine, content-roadmap planning, help-docs catalog refresh.

## Calibration

Tracked under taste-types `narrative` and `retention`. Brier signal: gap-queue topics shipped as articles should produce measurable lift in deflection or in cluster CSAT in the next quarter; failure to lift either is the calibration check on whether the gap was a real gap.

## See also

- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `knowledge/patterns/distribution-as-moat.md`
- `skills/ticket-cluster-analysis/SKILL.md`
- `skills/help-docs/SKILL.md`
- `skills/aeo-relevance/SKILL.md`
- `routines/support-cluster-monthly.md`
