---
name: icp-cut
description: Cut the ICP from data, not from narrative. Reads closed-won deals CSV plus optional review and event data, slices by firmographic dimensions (industry, size, geo) and behavioral signals (signup-source, time-to-value, expansion), and outputs ranked ICP segments with statistical evidence per slice (volume, conversion-rate, CAC, LTV, retention). Refuses with fewer than 30 closed deals.
version: 2.0
amplifies: PMM lead, growth lead, RevOps
masters: Tomasz Tunguz (cohort math), Lenny Rachitsky (PMF surveys + ICP fit), Sean Ellis (PMF score), Wes Bush (PLG cohort segmentation), Bob Moesta (JTBD as the unit of segmentation), April Dunford (best-fit-customer characteristics), May Habib (account scoring), Adam Robinson (account-graph), Kyle Poyar (PLG benchmarks), Reforge faculty (segment → activation)
substrate_layers_required: [voc, icp, positioning, market-context]
patterns_grounded: [jtbd-as-buyer-mental-model, frontline-as-pmm-substrate, specificity-becomes-profitable, market-and-offer-beat-funnel-optimisation]
preflight_refusal: substrate-gap, missing-closed-won, too-few-deals
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
---

# icp-cut

## Purpose

Define the ICP quantitatively, not narratively. The output is a segment definition that RevOps can filter on, sales can score against, and PMM can write for. Vibes-segmentation ("high-growth SMBs") refuses to ship; the skill produces ranked segments with real numbers per slice.

## Inputs

- `--client <client>` (required)
- `--closed-won <path.csv>` (required) — closed-won deals export
- `--reviews <path.csv>` (optional) — review/G2 corpus with attached firmographics
- `--events <path.csv>` (optional) — events export for behavioral signals (time-to-value, expansion, retention)
- `--top-segments <n>` (default 5)
- `--min-deals <n>` (default 30) — refuse with fewer

## Required CSV columns

`closed-won.csv` minimum columns:
- `deal_id`, `account_id`, `closed_date` (YYYY-MM-DD)
- `industry`, `company_size_band` (e.g., 1-10, 11-50, 51-200, 201-500, 501-1000, 1000+)
- `geo` (region / country)
- `arr_usd` (annual recurring revenue at close)
- `cac_usd` (customer acquisition cost; optional but enables CAC slicing)
- `signup_source` (organic / paid / partner / outbound / referral / sales-led)
- `time_to_value_days` (signup to first-value-event; optional)

`reviews.csv` (optional):
- `account_id`, `industry`, `company_size_band`, `geo`, `score` (1-5), `review_date`, `text`

`events.csv` (optional):
- `account_id`, `event_name`, `event_date`, `arr_at_event_usd` (for retention/expansion)

## Process

1. **Refuse** with fewer than `--min-deals` closed-won rows.
2. **Slice** the closed-won corpus along firmographic dimensions (industry × size × geo) and behavioral dimensions (signup-source, time-to-value-band).
3. **Score per slice**:
   - **Volume**: count of deals.
   - **Conversion-rate per signup-source**: deals / signups (when events.csv has signup events).
   - **Median ARR**, **mean CAC**, **LTV multiple** (LTV / CAC; LTV from retention events when present, else 3-year-ARR proxy).
   - **Retention proxy**: deals still in events.csv 12 months after close.
   - **Expansion proxy**: deals with arr-increase events post-close.
4. **Rank segments** by composite score: `(volume_share × ARR_band) × LTV_multiple × retention_proxy`.
5. **Compute Anti-ICP**: slices below the floor on volume × LTV (where the company is paying acquisition cost without recovery).
6. **Compute scoring rubric**: 5-7 dimensions extracted from the top 3 segments, each weighted by their contribution to the rank score.
7. **Write outputs**:
   - `clients/<client>/icp/icp-cut-<YYYY-MM-DD>.md`: ranked segments + Anti-ICP + rubric + evidence per slice.
   - `clients/<client>/icp/icp-cut-<YYYY-MM-DD>.json`: structured form for downstream skills.
   - `clients/<client>/icp/icp-rubric-<YYYY-MM-DD>.csv`: rubric per dimension with weights.

## Output contract

- Three files per run, all named with the same date stamp.
- Every cell traces to a row count in the source CSV. No "high-growth SMB" handwave.
- Anti-ICP is mandatory; skipping anti-ICP is positioning failure.
- `signup_source` × `industry` cross-tabulation included for paid-acquisition planning.

## Quality criteria

- **Data-chain enforcement**: every claim ships with row count + source CSV path + ingestion date.
- **Anti-ICP defined**: what we explicitly do not target.
- **No vibe-segmentation**: "high-growth SMBs" without a quantified definition is rejected.
- **Sample-size guard**: any slice with fewer than 5 deals is marked `early-signal` and excluded from the rank.
- **JTBD overlay**: top segments are paired with the dominant JTBD from VoC findings (when present at `voc/findings/`); if VoC is missing, segments ship without JTBD overlay and the file flags it.

## Refusal patterns

- **`too-few-deals`**: `<30` rows in closed-won, or `<--min-deals` if overridden.
- **`missing-required-columns`**: any of the minimum columns missing.
- **`single-source-icp`**: when CSV is the only input, the file flags low-confidence; review or events corpus increases the confidence band.
- **`anti-icp-overlap`**: if the anti-ICP slice overlaps the ICP on >2 dimensions, the cut refuses; the operator must cut harder.

## Composes with

- **Reads from**: `closed-won.csv`, `reviews.csv`, `events.csv`, `voc/findings/` (when present).
- **Writes for**: `positioning-forge`, `narrative-strategy`, `messaging-matrix`, `ad-spend-allocate` (targeting), `outbound-sequence-design` (sequencing), `competitive-displace` (top-alternatives by segment).
- **Triggered by**: quarterly cycle, material data shift (>20% volume change in any segment), new vertical entry.

## Calibration

Tracked under taste-type `demand-capture` and `narrative`. Brier signal: ICP-targeted bets win at higher rate than anti-ICP-targeted bets within 90 days.
