---
title: monthly support cluster review
status: active
last_updated: 2026-05-08
patterns_grounded: [tickets-are-product-feedback-channel, deflection-is-not-the-goal, frontline-as-pmm-substrate]
contradictions_aware: [save-everyone-vs-let-the-wrong-fit-go]
schedule: monthly, second Tuesday of month
---

# Monthly support cluster review

Support is where churn announces itself before churn happens, and where buyer language shows up at the highest fidelity. Per `tickets-are-product-feedback-channel`, the ticket corpus is product knowledge, not a routing artifact. Per `frontline-as-pmm-substrate`, the same corpus is the highest-fidelity buyer-language source on the team. Most teams read tickets to resolve them, not to learn from them; this routine forces the read every month so the cluster sizes, the verbatim language, and the gaps in the help catalog become first-class artifacts.

The routine is a closed loop: cluster the corpus, cross-reference with the help catalog to find the gaps, score the team's quality on the same corpus, design the closed-loop CSAT response, and queue the highest-volume cluster for a deflection experiment. Resolve any prior-month experiment predictions before opening new ones.

## Cadence contract

Monthly, on the second Tuesday. The previous month's tickets are fully observable by then; the support team has had time to close the late-month tickets, and the CSAT survey responses have settled.

## Loop steps

### 1. Pull the tickets export

The support team or RevOps lands the prior month's tickets at `clients/<client>/support/tickets-<YYYY-MM>.csv`. Required columns: `ticket_id`, `account_id`, `opened_at`, `category`, `subject`, `body`. Optional but valued: `resolution_time_hours`, `csat`, `priority`, `first_response_minutes`, `escalated`, `resolved`, `agent_id`.

If the export is missing, the routine refuses to start. Without the corpus, the cluster read is a guess.

### 2. Run `ticket-cluster-analysis`

```
substrate ticket-cluster-analysis --client <client> --tickets <path-to-csv>
```

Produces `clients/<client>/support/ticket-clusters-<date>.md` plus JSON sidecar plus per-ticket assignment CSV. The output is the substrate every downstream support skill reads from.

Look at:
- The taxonomy-match share. Below 60% means the manual taxonomy is stale; the novel-cluster track shows where to extend it.
- The top clusters table. Cluster size × CSAT-deficit is the priority queue.
- The novel cluster track. New themes that appear two months in a row should be promoted to the manual taxonomy.

### 3. Run `help-content-gap-detect`

```
substrate help-content-gap-detect --client <client> \
  --clusters clients/<client>/support/ticket-clusters-<date>.json \
  --help-catalog <path-to-help-catalog>
```

The help catalog can be a directory of markdown articles, a CSV, or a JSON file. The skill computes Jaccard token overlap between each cluster and each article and surfaces three findings: gap clusters (no article matches), drift candidates (articles whose declared source clusters no longer match), stale articles (articles with no current cluster).

The gap queue is the docs team's priority list for the month. The drift list is the refresh queue. The stale list is the deprecation candidate list (operator decides; some articles remain useful even when the underlying cluster has resolved).

### 4. Run `support-quality-score`

```
substrate support-quality-score --client <client> --tickets <path-to-csv>
```

Produces the team scorecard plus per-agent breakdown when `agent_id` is present. The four dimensions (response time, FCR, CSAT mean, agent consistency) compose into a team grade.

The most actionable finding is rarely the team grade; it is the inter-agent SD on the consistency dimension. Per Campbell's retention research, lifting the bottom quartile produces more retention impact than lifting the team mean. The targeted-coaching list at the bottom of the scorecard is the input to the support-team lead's coaching plan.

The CSAT-correlation read is also load-bearing. A CSAT score that does not correlate with resolution time or escalation is a measurement instrument problem (the survey is mis-timed or the language is leading). Investigate before acting on the response-time dimension.

### 5. Run `csat-loop-design`

```
substrate csat-loop-design --client <client>
```

Refresh the CSAT program spec for the upcoming month. The detractor routing logic conditions on ICP fit per the `save-everyone-vs-let-the-wrong-fit-go` contradiction; the position is logged on the artifact.

If the prior month's `support-quality-score` flagged a CSAT-correlation issue, design fires first; ship a corrected survey before the new cycle starts.

### 6. Pick the cluster for a deflection experiment, design it

The highest-volume, lowest-CSAT cluster from step 2 is the candidate. Design the experiment:

```
substrate deflection-experiment-design --client <client> \
  --clusters clients/<client>/support/ticket-clusters-<date>.json
```

The skill picks the highest-priority cluster automatically (operator can override with `--cluster <id>`). The variants tier through the right-routing ladder (control + chatbot suggest + article surface + community route + human-direct). The measurement contract requires both a deflection-side metric and a loyalty-side metric; per `deflection-is-not-the-goal`, an experiment that drops the loyalty-side metric is rejected at the design step.

If the cluster is below 50 tickets in the corpus, the skill refuses with `insufficient-volume`. Pick a higher-volume cluster, or accept a longer experiment window, or stratify against multiple clusters.

### 7. Resolve prior month's experiment predictions

Open the prior month's `deflection-experiment-*.md`. For each prediction (predicted resolution-or-deflection rate, predicted effort/CSAT change), look up the actual outcome in the support tooling. Record the resolution in `goals/ledger.md`. Brier-score it.

Per PRINCIPLES.md rule 2, predictions get an accuracy score on resolve. Honest losses count. An experiment that won on deflection but lost on CSAT/effort is a *failed* experiment per the kill criterion in the contract; do not declare it a win.

### 8. Write the monthly report

Compose a one-page summary at `clients/<client>/support/monthly-review-<YYYY-MM>.md`:

- Headline cluster (largest, lowest-CSAT cluster of the month).
- Taxonomy-match share. If the share dropped, name the new themes from the novel-cluster track.
- Top 5 content gaps from `help-content-gap-detect`.
- Team quality composite grade. Surface the inter-agent SD if greater than 0.10.
- CSAT correlation read. Flag any near-zero correlation against expected directions.
- Active deflection experiments and their close dates.
- Prior month's experiments resolved (with Brier scores).
- Open questions for next month.

Keep it short. The artifact density underneath is high; the monthly report is the operator-readable index.

## Failure modes the routine prevents

- **Tickets resolved but never read.** Per `tickets-are-product-feedback-channel`, the most common failure is treating tickets as a routing artifact. The routine forces the cluster read every month with verbatim sample tickets surfaced at the top of the report.
- **Help catalog drift unnoticed.** The catalog accumulates articles; the cluster shape evolves with the product. Without a monthly cross-reference, the catalog and the corpus drift apart silently. The routine forces the cross-reference.
- **Team mean reported, agent variance hidden.** A team scorecard with a passing mean can carry a long bottom-quartile tail. The routine surfaces the variance every month, with the targeted-coaching list named.
- **CSAT measured but not connected to retention.** A CSAT mean above target with low correlation to resolution time is a measurement-instrument problem. The routine reads the correlation, not just the mean.
- **Deflection-only experiments.** Per `deflection-is-not-the-goal`, an experiment that measures deflection only is the failure mode this surface exists to prevent. The skill refuses such designs at compose time; the routine reinforces by reading the loyalty-side metric at every resolution.
- **Save-everyone treadmill.** Per the contradiction, undifferentiated save outreach misallocates CS hours. The CSAT design step runs the conditioning every month so detractor routing tracks the latest ICP-fit definitions.

## Substrate reads + writes

- Reads: `clients/<client>/support/tickets-*.csv`, `clients/<client>/support/help-catalog/`, `clients/<client>/icp/`, `clients/<client>/voc/`, `clients/<client>/product-knowledge/`, `clients/<client>/brand-voice/`.
- Writes: `clients/<client>/support/ticket-clusters-*`, `help-content-gaps-*`, `support-quality-score-*`, `csat-program-spec-*`, `deflection-experiment-*`, `monthly-review-<YYYY-MM>.md`.

## Quality criteria

- Refuses to mark the month complete if the tickets export is missing.
- Refuses to mark the month complete if the cluster output is more than 60% novel (taxonomy is too stale to use without an extension pass).
- Refuses to mark the month complete if prior-month experiment predictions are unresolved.
- Refuses to mark the month complete if the CSAT-correlation read flagged a measurement instrument issue and `csat-loop-design` was not re-run.

## See also

- `skills/ticket-cluster-analysis/SKILL.md`
- `skills/help-content-gap-detect/SKILL.md`
- `skills/csat-loop-design/SKILL.md`
- `skills/deflection-experiment-design/SKILL.md`
- `skills/support-quality-score/SKILL.md`
- `skills/help-docs/SKILL.md`
- `routines/support-churn-watcher.md` (weekly companion)
- `routines/retention-monthly.md` (cross-reads with churn-signal-from-support output)
- `knowledge/patterns/tickets-are-product-feedback-channel.md`
- `knowledge/patterns/deflection-is-not-the-goal.md`
- `knowledge/patterns/frontline-as-pmm-substrate.md`
- `knowledge/contradictions/save-everyone-vs-let-the-wrong-fit-go.md`
