---
id: con_sprint-vs-retainer-default
title: Sprint-default engagement vs retainer-default engagement at different client stages
captured_date: 2026-05-18
---

# Sprint-default vs retainer-default

## Position A — sprint-default for early-stage clients; productized POC is the entry point
- Operator: Jonathan Stark (`ins_stark-hourly-billing-is-nuts`), Blair Enns (`ins_enns-value-priced-engagements`), Patrick Campbell (`ins_campbell-diagnostic-as-discovery`)
- Claim: at pre-seed, seed, and Series A, the client can't commit to a quarter — runway is too short, leadership turnover too high, the substrate too thin to justify a month-3 bet. A 5-day POC or a 4-week embedded sprint is the honest engagement shape. The sprint produces a calibrated diagnostic + 1-2 high-leverage artifacts; the client decides whether to renew based on substrate-grade evidence rather than vibe. Substrate's `consulting-poc` declares this shape explicitly.

## Position B — retainer-default for growth-stage clients; calibration compounds over months
- Operator: Alan Weiss (*Million-Dollar Consulting*; `ins_weiss-value-based-fees`), Madhavan Ramanujam (`ins_ramanujam-leaders-fillers-killers`), Hermann Simon (`ins_simon-tier-discipline`)
- Claim: at Series B and beyond, calibration compounds. The operator's Brier-scored bets accrue over months, not weeks; the substrate (positioning canon, ICP, message house, allowed-claims register) matures past the point where a sprint can return on the discovery cost. A 3-month retainer with quarterly renegotiation is the engagement shape that captures the compounding. Sprint-default at growth stage is operator-side mis-pricing — the operator leaves the multi-month value on the table.

## Conditions distinguishing them

- **Client funding stage** is the dominant variable. Pre-seed / seed / Series A → sprint-default (Position A). Series B / growth / established → retainer-default (Position B).
- **Customer-call corpus depth at engagement start**: thin corpus (≤3 logged customer calls) → sprint-default; the operator needs to ship a VoC sprint before any month-3 bet is meaningful. Mature corpus (≥10 logged calls per quarter) → retainer-default; calibration substrate exists.
- **Org leadership stability**: high turnover (CMO < 12 months) → sprint-default; the operator can't bank on the buyer surviving the retainer. Stable leadership (CMO > 18 months) → retainer-default; calibration trust compounds.
- **The operator's prior closes at this client stage**: an operator with 3+ Brier-scored retainers at growth stage has the calibration band to anchor a retainer pitch credibly. An operator with no prior retainer at this stage is anchoring on assumption — sprint-default is the rational fallback even if the client is growth-stage.

## Resolution / synthesis

Not orthogonal; both can be true across a single operator's pipeline at different prospect stages. The genuine contradiction is in *default engagement shape per prospect-stage band*:

- pre-seed / seed: sprint-default (Position A). 5-day POC or 4-week embedded. Refuse to anchor a retainer in the proposal frame; the prospect can't commit to a quarter.
- Series A: sprint-default with an explicit Phase-2 retainer option declared in the proposal frame. Phase 2 fires only if Phase 1's calibration-baseline produces evidence the retainer would compound.
- Series B / growth: retainer-default (Position B). 3-month retainer with quarterly renegotiation gate. The sprint becomes the *trial* on the front of the retainer, not the headline product.
- Established / public-co: retainer-default with a longer window (6-month embedded common). Sprints become the *audit shape* (Phase-0 free audit) not the main engagement.

## How substrate uses this contradiction

`engagement-shape-pricing` reads this contradiction's `Conditions` section and picks the default based on the prospect-stage input:

- `--prospect-stage pre-seed` or `seed` → sprint-default (Position A); anchor a Phase-0 / 5-day POC / 4-week embedded; do not anchor a retainer
- `--prospect-stage series-a` → sprint-default with declared Phase-2 retainer path
- `--prospect-stage series-b-plus` or `growth` or `established` → retainer-default (Position B); anchor a 3-month or 6-month retainer with explicit quarterly renegotiation gate

The position is recorded on the output artifact (`contradiction_positions.sprint-vs-retainer-default: <A|B>`). Anchoring a retainer at pre-seed produces a proposal the prospect can't accept; anchoring a sprint at Series B+ leaves the compounding-calibration value on the table.
