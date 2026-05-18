---
name: pricing-strategic
description: Pricing analysis from positioning + cohort LTV + competitor pricing matrix. Outputs pricing tier proposals, packaging logic, willingness-to-pay analysis (van Westendorp PSM intersection points), price-point sensitivity. Refuses without ICP, positioning, and a real WTP buyer panel or competitor pricing matrix.
version: 0.2
amplifies: founder, head of product, head of GTM, PMM lead, pricing leader
masters: Patrick Campbell (ProfitWell — pricing requires structured customer pricing research; pricing is the most-leveraged growth lever), Madhavan Ramanujam (Monetizing Innovation — willingness-to-pay before product, leaders / fillers / killers), Hermann Simon (Confessions of the Pricing Man — single price always suboptimal; discount discipline), Mårten Mickos (MySQL AB; HackerOne — startup pricing from research, not competitor copy), Bret Taylor (outcomes pricing for AI), Blair Enns (Pricing Creativity — anchor high), Dan Ariely (relativity, anchoring, pain-of-paying), Daniel Kahneman (anchor sets the range), Peter van Westendorp (PSM method, four-question canonical research)
substrate_layers_required: [voc, positioning, product-knowledge, market-context, competitive]
patterns_grounded: [pricing-as-the-most-leveraged-org-failure, behavioral-pricing-architecture, van-westendorp-over-vibes-pricing, frontline-as-pmm-substrate, economic-turing-test-rev-per-employee]
preflight_refusal: substrate-gap, missing-wtp-data, missing-competitor-pricing, missing-customer-calls
required_reads:
  - clients/{client}/voc/processed/pricing/
  - clients/{client}/product-knowledge/value-pillars.md
  - clients/{client}/competitive/competitor-pricing.yaml
---

# pricing-strategic

## Purpose

Pricing is the highest-ROI lever most teams touch least. Codex pattern: 1% pricing improvement compounds to roughly 11% profit improvement. The skill enforces a willingness-to-pay process, anchors via behavioral architecture, and runs price tests on a cadence. It refuses to set a price from team consensus, founder gut, or competitor copy — the structured alternative is documented buyer research.

## Inputs

- `--client <client>` (required)
- `--mode <wtp-survey|anchor-design|packaging|price-test|review>` (required)
- `--segment <pinned-icp>` (required for wtp-survey, anchor-design)
- `--wtp-csv <path>` (required for wtp-survey when computing intersections; CSV with columns: respondent_id, segment, too_cheap, cheap, expensive, too_expensive)
- `--ltv <usd>` (required for review and price-test; cited from cohort modeling, not back-of-envelope)
- `--out <dir>` (default: `clients/<client>/pricing/`)

## Output deliverables (per mode)

**wtp-survey** — Computes the four van Westendorp intersection points from the CSV and writes a per-segment WTP curve report. Output: `pricing/wtp-curves/<segment>-<date>.md` with OPP, IPP, PMC, PME, response count, distribution histograms, and a defensible price band.

**anchor-design** — Three-tier packaging proposal with anchor-high / target / decoy structure. Each tier carries a feature manifest, a value story sourced from VoC, and a switching-feature rationale. Output: `pricing/packaging/<package-name>.md` with tier card, switching-feature analysis, and the WTP-curve citation that justifies the per-tier price.

**packaging** — Feature-to-tier matrix. Each feature is binary: free, target, anchor. Output: `pricing/packaging/<package-name>-features.md` with per-feature tier mapping, switching-feature analysis (which feature moves the buyer from tier A to tier B), and Leaders / Fillers / Killers tagging per Ramanujam.

**price-test** — A measured price change with a registered prediction. Output: `pricing/tests/<test-id>.md` with A/B test design, falsifiable expected lift, kill criterion, and the substrate citations that justified the prediction.

**review** — Quarterly pricing audit. Output: `pricing/ledger.md` append-only entry with realised vs predicted impact, NRR delta, and discount-distribution drift.

## Substrate reads

- `voc/processed/pricing/`, customer pricing reactions from logged calls.
- `voc/processed/win-loss/`, where price was the decision driver.
- `product-knowledge/value-pillars.md`, the value statement that anchors price.
- `competitive/competitor-pricing.yaml`, comparable anchors per Simon and Mickos (informational, not load-bearing).
- `clients/<client>/closed-won-deals.csv` (when present), for cohort LTV input.

## Output contract

- `pricing/wtp-curves/<segment>-<date>.md`
- `pricing/packaging/<package-name>.md`
- `pricing/tests/<test-id>.md`
- `pricing/ledger.md` — append-only history of pricing changes and outcomes

Every artifact carries `produced_by: pricing-strategic` in frontmatter so Gate 7 (pattern-applied) can verify pattern application at pre-publish time.

## Quality criteria

- Refuses to compute van Westendorp intersections with fewer than 20 buyer responses per segment (Mickos and Campbell both name 20 as the floor; below it, the curves are noisy and the OPP is unstable).
- Refuses to design tiers without a stated switching-feature (the feature that moves the buyer from tier A to tier B; without it, the architecture is feature-checkbox parity, not buyer-perception architecture).
- Refuses to write a price-test without a calibrated prediction (Brier-scored on resolution).
- Refuses to ship a competitor-only price (without a buyer-research grounding); Mickos rule.
- Flags drift: pricing unchanged for >12 months in a market where competitor pricing has moved.
- Enforces discount discipline: discount distributions drifting right >5% quarter-over-quarter trigger a `discount-erosion` flag.

## Contradictions awareness

None directly named in this skill, though `behavioral-pricing-architecture` declares its own counter-evidence on commodity categories with strong external anchors. The skill's mode `--mode price-test` writes the contradiction position into the test design when one applies (e.g. category with public competitor pricing → cognitive-architecture muted; defer to Gabor-Granger revenue-max instead of van Westendorp OPP for the tier price).

## See also

- `skills/frontline-contact/`, where the pricing call data is captured.
- `skills/win-loss-interview/`, where price-as-decision-driver is logged.
- `knowledge/patterns/pricing-as-the-most-leveraged-org-failure.md`.
- `knowledge/patterns/behavioral-pricing-architecture.md`.
- `knowledge/patterns/van-westendorp-over-vibes-pricing.md`.
- `templates/competitor-pricing-example.yaml`.
- `templates/wtp-csv-example.csv`.
