---
name: ticket-cluster-analysis
description: Cluster a support ticket export by theme using a manual taxonomy plus TF-IDF token co-occurrence. Surfaces dominant theme clusters, sample tickets per cluster, suggested help-content topics in customer language, and a "novel cluster" track for tickets that do not match the manual taxonomy. Refuses with empty corpus or fewer than 50 tickets.
version: 0.1
amplifies: head of support, head of CS, head of lifecycle, PMM lead, head of content
masters: Stewart Butterfield (support is product; every ticket gets read), Tom Klein (tickets are the daily product brief), Sahil Bloom (compounding-fluency frame), Patrick Campbell (cohort-level diagnostic from ticket content), Brendan Hufford (3S — source content from sales/success/support)
substrate_layers_required: [voc, product-knowledge, icp]
patterns_grounded: [tickets-are-product-feedback-channel, frontline-as-pmm-substrate]
contradictions_aware: []
preflight_refusal: substrate-gap, empty-corpus, too-few-tickets
required_reads:
  - clients/{client}/00-INDEX.md
  - clients/{client}/voc/voc.md
  - clients/{client}/product-knowledge/product-knowledge.md
---

# ticket-cluster-analysis

## Purpose

Read a support ticket export, cluster it by theme, and surface what the cluster sizes, the sample verbatim tickets per cluster, and the suggested help-content topics tell a product or PMM team. The output is the substrate every downstream support skill reads from: gap detection runs against the clusters, churn-signal extraction reads the cluster sentiment, deflection experiments target the largest clusters, and help-docs gets pointed at the questions in customer language.

Per `tickets-are-product-feedback-channel`, this is product knowledge work, not a support-routing artifact. Per `frontline-as-pmm-substrate`, the ticket corpus is the highest-fidelity buyer-language source available; the cluster output is the operator-readable index into that source.

## Inputs

- `--client <client>` (required)
- `--tickets <path>` (required), path to a tickets CSV (canonical shape: `templates/support-tickets-example.csv`).
- `--top-clusters <int>` (default: 10), how many clusters to surface in the report.
- `--min-cluster-size <int>` (default: 3), the smallest a cluster can be and still appear.
- `--out-dir <path>` (optional, default: `clients/<client>/support/`).

## Substrate reads

- `clients/{client}/voc/voc.md`, to cross-check ticket language against documented customer language.
- `clients/{client}/product-knowledge/product-knowledge.md`, to flag clusters that imply product gaps vs documented-but-mis-discovered features.
- `clients/{client}/icp/icp.md`, to filter tickets by ICP-fit band when the export carries account-level fit data.

## Tickets CSV contract

Required columns: `ticket_id`, `opened_at`, `category`, `subject`, `body`. Optional but valued: `account_id`, `resolution_time_hours`, `csat`, `priority`, `first_response_minutes`, `escalated`, `resolved`. The skill reads what it can; missing optional columns flag the output as partial-confidence on the relevant analyses.

## Process

1. **Preflight**. Verify the tickets path resolves, the corpus has at least 50 rows, the required columns are present, and the substrate layers exist. Refuse with structured codes (`empty-corpus`, `too-few-tickets`, `substrate-gap`) when any of these fail.
2. **Manual taxonomy pass**. Run a deterministic keyword pass against the canonical support-theme taxonomy (onboarding-confusion, billing-question, integration-broken, integration-question, bug-blocking, bug-cosmetic, how-to-bulk-action, how-to-export, how-to-permissions, how-to-mobile, performance-slow, cancel-or-refund, feature-request, escalation). Each ticket can match multiple themes; the cluster is the union per theme.
3. **TF-IDF residual cluster pass**. For tickets that did not match any taxonomy theme (or matched generically), run TF-IDF over the subject + body, score token co-occurrence, and bucket into "novel clusters" by shared high-IDF tokens. Stop-word list is the standard English short list plus product-specific stop-words derived from the product-knowledge layer when present.
4. **Cluster report**. For each cluster: size, share of corpus, sample tickets verbatim (top 3 by escalation or low CSAT, since those are the highest-information samples), most-common tokens (TF-IDF top 5), suggested help-content topic phrased in customer language, and the recommended downstream skill.
5. **Per-cluster CSAT and resolution-time roll-up**. When CSAT and resolution-time columns are present, compute the cluster-level CSAT distribution and the median resolution time. Clusters with low CSAT + high volume are the priority queue.
6. **Output**. Write three artifacts: the markdown report, a JSON sidecar for downstream skills, and a CSV of (cluster, theme, ticket_id) for ticket-level joins.

## Output contract

Three artifacts under `clients/{client}/support/`:

1. `ticket-clusters-{YYYY-MM-DD}.md`, narrative-friendly markdown with:
   - Corpus summary (n tickets, time window, taxonomy-match rate, novel-cluster share).
   - Top N clusters table (size, share, CSAT, resolution-time-median, suggested topic).
   - Per-cluster section: sample tickets verbatim, most-common tokens, suggested help-content topic in customer language, recommended downstream skill.
   - Novel-cluster track: TF-IDF-derived clusters that did not match the taxonomy, with the high-IDF tokens that defined them.
   - Substrate citations.
2. `ticket-clusters-{YYYY-MM-DD}.json`, structured per-cluster data for downstream skills (`help-content-gap-detect` reads this directly).
3. `ticket-clusters-{YYYY-MM-DD}.csv`, ticket-to-cluster assignment for joins.

## Quality criteria

- Refuses on a corpus smaller than 50 tickets with `too-few-tickets`. Smaller corpora produce noise, not signal; the per-cluster sample is too small to be useful.
- Reports the taxonomy-match rate explicitly. A corpus where less than 60% of tickets matched any taxonomy theme is a signal that the taxonomy needs extension; the output flags this and shows the largest novel clusters.
- Suggested help-content topics are phrased in customer language pulled from the ticket bodies, not invented. The skill will not invent a topic that does not appear in at least one ticket verbatim.
- Cluster size and share are computed from the corpus, not estimated.

## What this skill does NOT do

- Does not write help articles. That is `help-docs` (which reads this output to know what to write).
- Does not detect content gaps. That is `help-content-gap-detect` (which cross-references this output with the help-docs catalog).
- Does not extract churn signals. That is `churn-signal-from-support` (which reads this output for cluster sentiment).
- Does not embed or run an LLM cluster pass. The clustering is deterministic (manual taxonomy + TF-IDF residuals); operators can audit every cluster assignment.
- Does not invent themes. Novel clusters are surfaced by the data; the operator decides whether to add them to the taxonomy.

## Refusal patterns

- `substrate-gap`: missing voc, product-knowledge, or icp layer.
- `empty-corpus`: tickets file is present but has no rows.
- `too-few-tickets`: corpus has fewer than 50 rows.
- `schema-mismatch`: required columns missing.

## Composes with

- Reads from: tickets CSV, substrate layers (voc, product-knowledge, icp).
- Writes for: `help-content-gap-detect`, `churn-signal-from-support`, `deflection-experiment-design`, `help-docs`, `support-quality-score`.
- Triggered by: monthly support cluster routine, churn-signal investigation, product-feedback synthesis.

## Calibration

Tracked under taste-types `narrative` and `retention`. Brier signal: clusters named as priority should produce measurable lift in the next quarter's CSAT or resolution-time on the cluster's tickets after a help-docs article ships or a product change lands.

## See also

- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `knowledge/patterns/frontline-as-pmm-substrate.md`
- `templates/support-tickets-example.csv`
- `skills/help-content-gap-detect/SKILL.md`
- `skills/churn-signal-from-support/SKILL.md`
- `skills/help-docs/SKILL.md`
- `routines/support-cluster-monthly.md`
