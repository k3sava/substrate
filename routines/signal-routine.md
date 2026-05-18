---
title: signal loop
status: active
last_updated: 2026-04-30
---

# Signal loop

The signal loop is continuous. It processes incoming information that either confirms or challenges what the substrate says. Signals do not update the substrate directly. They go through a processing step first.

---

## Signal types

| Type | Examples | Decay sensitivity | Substrate layers affected |
|---|---|---|---|
| VoC | Customer interviews, support tickets, G2 reviews, call transcripts | High (VoC layer decays in 30 days) | voc, icp, positioning |
| Buyer behavior | Session recordings, conversion event changes, funnel drops | Medium | positioning, competitive |
| Competitive | Competitor page changes, new ads, pricing updates | Very high (competitive decays in 14 days) | competitive, positioning |
| Market context | Industry reports, search trend shifts, LLM citation changes | High (market-context decays in 14 days) | market-context, strategy |
| Sales intel | Win/loss interviews, objection pattern changes, deal velocity shifts | Medium | sales-pitch, icp, voc |

---

## Ingest

A signal enters when the operator (or an agent) runs:
```
signal.ingest(type, source, content, client)
```

The signal is written to `clients/<slug>/signals/inbox/` with a timestamp and type tag.

**Format:**
```yaml
signal_id: <client>-<type>-<YYYY-MM-DD>-<hash>
type: voc | buyer-behavior | competitive | market-context | sales-intel
source: <URL or file path or interview reference>
ingested_at: YYYY-MM-DD
raw_content: |
  [The actual content — a review, a page diff, a transcript excerpt, etc.]
```

---

## Processing

The signal-analyst agent reads each inbox signal and produces a patch proposal:

1. Which substrate layer(s) does this signal bear on?
2. What specific claim does the signal make or challenge?
3. What should change in the layer to reflect this signal?
4. How confident is the signal? (Single data point vs. pattern across multiple signals)

The patch proposal is written to `clients/<slug>/signals/proposals/` with a `pending` status.

---

## Human approval gate

The operator reviews pending proposals. Options:
- **Approve:** the patch goes to the substrate layer. Layer's `last_updated` is set to today.
- **Reject:** the signal does not change the substrate. Reason logged.
- **Defer:** the signal is noted but the substrate update waits for corroboration. Deferred signals expire after 14 days if no corroboration arrives.

**Why the gate exists:** signals can be noisy. A single G2 review is not a positioning insight. A single competitor homepage change may be a test, not a pivot. The gate prevents premature substrate drift from one-off signals.

**When to approve immediately:** a signal from a primary source (customer interview, direct observation, verified data source) that confirms a pattern already visible in the substrate warrants fast approval. The gate is a judgment check, not a bureaucratic delay.

---

## Corroboration requirement

For high-stakes substrate layers (positioning, icp, competitive), a patch that contradicts the current substrate requires corroboration from at least two independent signals before the operator can approve.

The signal-analyst tracks corroboration: when Signal B confirms the patch proposed by Signal A, it notes the corroboration and upgrades the proposal's confidence level.

Low-stakes patches (adding a new VoC verbatim to the review corpus, updating a pricing number) do not require corroboration.

---

## Staleness prevention

The signal loop is what prevents the substrate from going stale. If signals stop flowing for a given type, the substrate-curator flags the affected layers.

When the competitive layer hasn't received a new signal in 10 days (against its 14-day decay period), the substrate-curator sends an alert: "competitive layer is 4 days from expiry — no recent signals. Consider running competitive scout on [list of competitors]."

This alert is not automated. The operator reads it and decides whether to run a competitive check.

---

## Cross-bet impact

When a patch is approved that materially changes a substrate layer, the signal-analyst checks active bets that cite that layer.

If a bet's hypothesis depends on a claim that the patch changes, the bet-reviewer flags it: "Bet [bet-id] cites [layer] — the updated layer may change the hypothesis. Operator review recommended."

The operator decides whether to revise the bet, abandon it, or proceed as-is with a note that the substrate has changed since the bet was opened.
