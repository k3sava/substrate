---
name: ad-attribution-honest
description: Defensive gate. Scans an asset (LP, blog, deck, board update, exec slide) for claims of channel performance and refuses to pass it without an attribution model named, a window declared, and known blind-spots cited (last-touch vs multi-touch vs incrementality). Composes with claim-verify and voice-enforce in pre-publish-check.
version: 0.1
amplifies: paid-marketing lead, head of growth, RevOps
masters: Avinash Kaushik (See/Think/Do/Care + attribution as planning tool), Susan Wenograd (platform self-attribution incentives), Aaron Orendorff (Common Thread Collective ROAS-vs-incremental divergence), Brian Balfour (Reforge incrementality discipline), Annie Duke (Thinking in Bets — naming uncertainty)
substrate_layers_required: []
patterns_grounded: [incrementality-not-attribution, intent-vs-interest-targeting]
preflight_refusal: missing-attribution-model, missing-window, missing-blindspot-disclosure
required_reads: []
---

# ad-attribution-honest

## Purpose

A claim like "Meta drove 40% of new revenue last quarter" is not falsifiable without naming the attribution model and the window. The same data can support 15% under incrementality and 60% under last-touch. Operators routinely make allocation decisions on the more-flattering number; downstream readers cannot tell which model is in use.

This skill is the gate that catches those claims before ship. It scans an asset for "channel X drove Y" pattern claims. For every claim found, it requires:

1. An **attribution model name** within the same paragraph or 5-line proximity (last-touch, first-touch, linear, time-decay, data-driven, multi-touch, MMM, incrementality, geo-holdout, ghost-ads).
2. A **window declaration** (specific dates, or a relative window like "last 30 days").
3. A **blind-spot disclosure** somewhere in the asset (a footnote or aside that names the known biases of the model used).

If any of the three is missing, the asset is rejected. The operator either adds the missing context or downgrades the claim (e.g., "Meta correlates with Y in our last-touch dashboard" instead of "Meta drove Y").

This skill defends against the most common paid-ads epistemic failure: confident channel performance claims that are not falsifiable.

## Inputs

- `<asset>` (required, positional) path to the asset file (`.md`).
- `--strict` (optional) raise blind-spot threshold from "asset-level" to "claim-level" (every channel-claim must have its own blind-spot footnote, not just one for the asset).
- `--threshold <int>` (optional, default 0) maximum number of bare claims allowed before failure.
- `--json` (optional) emit machine-readable output.

## Substrate reads

This skill is content-agnostic; it reads the asset itself. It does not require client substrate.

## Output contract

Stderr: per-claim findings.
Stdout: `PASS: <asset>` or `FAIL: <asset>` with the count.
Exit: 0 if pass, 1 if fail (claims above threshold), 2 if file not found.

When `--json` is set, stdout is a JSON object:

```json
{
  "asset": "<path>",
  "claims_total": 0,
  "claims_grounded": 0,
  "bare_claims": [
    {"line": 42, "claim": "Meta drove 40% of new revenue", "missing": ["attribution-model", "window"]}
  ]
}
```

## Quality criteria

- Every channel-performance claim either passes (model + window + blind-spot disclosure) or is flagged.
- Asset-level blind-spot disclosure satisfies non-strict mode; per-claim blind-spot satisfies strict mode.
- The pattern catches both formats: "Meta drove 40%" and "40% from Meta", and across channel synonyms (Meta = Meta / Facebook / Facebook Ads).

## What this skill does NOT do

- Does not verify the claim's value (that is `claim-verify`).
- Does not enforce voice / tone (that is `voice-enforce`).
- Does not compute incrementality (that is `ad-incrementality-test`).
- Does not block on assets that have no channel-performance claims; passes them through.

## Refusal patterns

- Asset path not found returns exit 2.
- Claims found without attribution model name within proximity: bare-claim.
- Claims found with model named but no window declared: bare-claim.
- No blind-spot disclosure anywhere in asset (when claims exist): asset-level fail.

## Composes with

- `pre-publish-check` runs this gate alongside `claim-verify` and `voice-enforce` for assets that mention paid-ads channels.
- `ad-spend-allocate` outputs are exempt because they declare model and window in their frontmatter; this skill detects that and bypasses.

## See also

- `claim-verify` — checks that the claim's value matches a substrate citation.
- `voice-enforce` — checks brand voice and kill-list.
- `ad-incrementality-test` — designs the geo holdouts that produce credible incrementality numbers.
- `pat_incrementality-not-attribution` — the pattern this gate operationalises.
