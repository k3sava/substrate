---
name: consulting-poc
description: Orchestrates a 5-day fixed-price proof-of-concept for a consulting prospect. Bootstraps a substrate scaffold from their public surface, runs diagnostic audits, ships 1-2 high-leverage artifacts, hands over a working clients/<prospect>/ they keep.
version: 0.1
amplifies: independent operator pitching consulting; agency lead running discovery; in-house PMM running an internal POC
masters: April Dunford (positioning is what you sell, not how you describe it), Allan Dib (1-page marketing plan as discovery output), Blair Enns (Win Without Pitching — value-priced engagements), Jonathan Stark (hourly billing is nuts; productized consulting), Patrick Campbell (diagnostic-as-discovery), David Maister (Trusted Advisor — diagnose before prescribing)
substrate_layers_required: []
patterns_grounded: [diagnose-before-execute, frontline-as-pmm-substrate, narrative-as-strategy, status-quo-is-the-competitor, agents-mapped-to-jtbd, distribution-as-moat, eval-as-data-analysis]
contradictions_aware: [no-decision-vs-named-competitor, build-quietly-vs-distribution-first]
preflight_refusal: substrate-gap, missing-prospect-bootstrap, missing-audit-baseline
required_reads:
  - templates/consulting-proposal.md
  - knowledge/patterns/diagnose-before-execute.md
---

# consulting-poc

## Purpose

Most consulting proposals offer capability ("I have a system, let's try it"). This skill orchestrates a productized POC that offers *artifacts the prospect keeps* and *a diagnostic they can audit*. Substrate makes the offer different in kind, not in degree: every claim cites a substrate path, every pattern cites 3+ operators, the prospect's team can run the same skills after the engagement.

## The three phases

### Phase 0: Public-surface diagnosis (free, 60-90 min)

Before any paid work, bootstrap a `clients/<prospect>/` from their public surface. Walk into the discovery call carrying:

- **Their positioning audit.** What their LP says vs what their reviews say. Drift score.
- **Their AEO triangle status.** Presence (do they appear), relevance (right framing), manual-action (off-domain density). Most teams have never seen this.
- **Their status-quo competitor map.** What alternative their reviews mention most. Usually a spreadsheet, an internal build, or no-decision.
- **Tier A pattern coverage.** Of substrate's 20 Tier A patterns, which they already operationalize, which they don't.

The 90-min call shows them their business through substrate. The pitch ends: "Here's what a 5-day POC produces. Here's the price."

### Phase 1: 5-day fixed-price POC

| Day | What ships | Substrate skills |
|---|---|---|
| 1 | Bootstrapped `clients/<prospect>/` with 10-layer context cut. 3 customer calls booked. | `frontline-contact`, `icp-cut`, `context-curate` |
| 2 | Canonical positioning statement + status-quo + named-competitor analysis | `positioning-forge`, `status-quo-frame`, `dunford-value-frame` |
| 3 | Strategic narrative (Raskin frame) + messaging matrix | `narrative-strategy`, `messaging-matrix` |
| 4 | High-leverage artifact: LP variant, content brief, or win-loss interview script | `lp-ship` or `narrative-compose` or `win-loss-interview` |
| 5 | Diagnostic report: pattern coverage map + 90-day skill roadmap + measurement contract on one open question | `eval-rubric`, `open-goal` |

### Phase 2: Optional continuation

- **Embedded operator** (4-8 weeks)
- **Monthly retainer** (3-month minimum, one strategic skill per month)
- **Train-the-team** (2-week sprint, certify their first calibration cycle)

## Inputs

- `--prospect <slug>` (required, used as `clients/<prospect>/`)
- `--mode <bootstrap|phase-0|phase-1-day-N|phase-2|generate-proposal>`
- `--public-sources <path-to-config>` (URLs for LP, blog, pricing, careers, reviews)
- `--engagement-shape <embedded|retainer|train-team>` (for phase-2 mode)

## Substrate reads

- `templates/consulting-proposal.md`, the proposal template the skill fills.
- `knowledge/patterns/`, the patterns this skill cites in diagnostics.
- `clients/<prospect>/` after bootstrap, all 10 layers.

## Output contract

### Phase 0 (free call)
- `clients/<prospect>/00-INDEX.md`, the bootstrapped index.
- `clients/<prospect>/diagnostics/phase-0-audit.md`, the substrate-grounded audit.
- `clients/<prospect>/proposal-draft.md`, populated from `templates/consulting-proposal.md` with the prospect's specifics.

### Phase 1 (5-day POC)
- One artifact per day, each substrate-cited.
- A `clients/<prospect>/diagnostics/phase-1-report.md` synthesizing the week.
- A `clients/<prospect>/roadmap-90d.md`, prioritized substrate-skill plan.
- A `clients/<prospect>/calibration-baseline.md`, Brier-scorable predictions on the artifacts shipped.
- A handover doc: how their team runs substrate after.

## Quality criteria

- Refuses Phase 1 work without a Phase 0 audit committed to git (the diagnosis is the consulting offer; skip = "let's try it").
- Refuses to ship the proposal-draft without a status-quo competitor identified.
- Refuses to advance to Day 5 without 3 customer calls logged in `voc/inbox/`. (`frontline-contact` rule.)
- Refuses to commit a roadmap-90d without at least 3 calibrated predictions.

## What this skill does NOT do

- Does not replace the consultative judgment call: "is this prospect a good fit?" That's `mental-models` + your taste.
- Does not produce sales emails or DMs (those are personal voice, ship as `narrative-compose` outputs separately).
- Does not handle pricing negotiation (use `pricing-strategic` if you want a structured approach to your own rates).

## See also

- `templates/consulting-proposal.md`, the fill-in proposal.
- `bin/substrate-bootstrap-prospect`, the public-surface bootstrap helper.
- `skills/positioning-forge/`, day 2.
- `skills/narrative-strategy/`, day 3.
- `skills/lp-cro-rubric/`, day 4 if the artifact is a page.
- `knowledge/patterns/diagnose-before-execute.md`, the load-bearing pattern (Shankarraman, Kaba, Fain, Rathi, Omojola).
