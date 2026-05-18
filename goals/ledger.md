---
title: Substrate Q2 2026 goal ledger
client: substrate
period: Q2 2026 (2026-05-07 – 2026-08-07)
status: active
last_updated: 2026-05-07
authored_by: kesava
sources:
  - README.md §What Substrate is
  - PRINCIPLES.md §The thesis
  - ORIGIN.md §v1.0 launch
  - skills/consulting-poc/SKILL.md
  - templates/consulting-proposal.md
---

# Substrate Q2 2026 Goal Ledger

Goals are falsifiable predictions: **metric · direction · threshold · window · cohort**. Every row cites its baseline source. `predicted_p` is the operator's estimate at open time. Brier score is computed at resolution. Lower Brier = better calibrated.

This is **substrate's own ledger**, scored in public. Substrate is its own first client; the calibration trail compounds publicly while the consulting-poc skill is exercised on real engagements in private forks. To use substrate for your own client: clone the repo privately, copy this file's structure into `clients/<your-client>/goals/ledger.md`, replace the goals with your own.

Each goal has a measurement contract (`goals/measurement-contracts/<id>.md`) and a why-this-matters narrative (`goals/why-this-matters.yaml :: <id>`). The dashboard renders all three.

## How to read a row

| Field | Meaning |
|---|---|
| `id` | Stable slug. Used by skills, dashboard, scoring. |
| `title` | One-sentence summary. |
| `metric` | The thing being measured. Must come from a real source system (analytics event, CRM property, payment metric). |
| `direction` | `up` / `down` / `delta` / `binary`. |
| `threshold` | The bar that separates "we hit it" from "we missed." |
| `window` | When measurement starts and ends. |
| `cohort` | Which slice counts. |
| `baseline` | Where you started, with citation. |
| `predicted_p` | Operator's confidence at open time (0.00 – 1.00). |
| `outcome` | `pending` / `hit` / `miss` / `partial`. Set at resolution. |
| `brier` | `(predicted_p - actual)^2`. Set at resolution. |

## Open goals

### G-001 — substrate-first-paid-engagement-2026-08-07

| Field | Value |
|---|---|
| id | `substrate-first-paid-engagement-2026-08-07` |
| title | First paid consulting engagement signed off the public substrate surface |
| metric | Count of signed-and-paid consulting engagements |
| direction | `up` |
| threshold | ≥ 1 |
| window | 2026-05-08 – 2026-08-07 |
| cohort | Any source: organic, AEO discovery, referral, network |
| baseline | 0 engagements at v1.0 launch (this commit) |
| measurement_contract | [`goals/measurement-contracts/substrate-first-paid-engagement-2026-08-07.md`](measurement-contracts/substrate-first-paid-engagement-2026-08-07.md) |
| predicted_p | 0.50 |
| operator | kesava |
| opened | 2026-05-07 |
| status | open |
| outcome | `pending` |
| brier | — |

**Why this matters.** Revenue is the test substrate's thesis cannot fool. Until one stranger pays for a substrate-led engagement, every claim is theoretical. After one closes, calibration begins.

**Intel pack.** README.md §What Substrate is · PRINCIPLES.md §The thesis · skills/consulting-poc/SKILL.md · templates/consulting-proposal.md · ORIGIN.md §v1.0 launch.

**Decision.** If this lands: Phase 2 retainer offers go live; second engagement opens at higher predicted_p; sanitized case study ships back to the public repo. If this misses by 2026-08-07: ICP is mistargeted before pricing is mispriced. First fix is sharpening which prospect cohort and which jobs-to-be-done; second fix is pricing.

---

### G-002 — substrate-first-inbound-prospect-2026-06-30

| Field | Value |
|---|---|
| id | `substrate-first-inbound-prospect-2026-06-30` |
| title | First inbound qualified prospect via the public surface |
| metric | Count of inbound emails to the maintainer's public contact channel matching qualification criteria |
| direction | `up` |
| threshold | ≥ 1 |
| window | 2026-05-08 – 2026-06-30 |
| cohort | Strangers (not in LinkedIn 1st-degree, not in 12-month email/DM history) |
| baseline | 0 inbound at v1.0 launch (AgentMail inbox audit, this commit) |
| measurement_contract | [`goals/measurement-contracts/substrate-first-inbound-prospect-2026-06-30.md`](measurement-contracts/substrate-first-inbound-prospect-2026-06-30.md) |
| predicted_p | 0.60 |
| operator | kesava |
| opened | 2026-05-07 |
| status | open |
| outcome | `pending` |
| brier | — |

**Why this matters.** First inbound is the leading indicator: it tells substrate whether the AEO + open-source surface is load-bearing for discovery. Stars are vanity until they convert to messages.

**Intel pack.** README.md · docs/llms.txt · docs/index.html · codex.iamkesava.com.

**Decision.** If this lands: AEO surface is working; double down on density (more codex content, more substrate.iamkesava.com pages) and add per-vertical AEO pages. If this misses by 2026-06-30: discovery surface needs review before more distribution effort. Audit AEO presence in major assistants, fix gaps, then redistribute.

---

### G-003 — substrate-100-stars-2026-08-07

| Field | Value |
|---|---|
| id | `substrate-100-stars-2026-08-07` |
| title | GitHub stars on `k3sava/substrate` reach 100 from non-network users |
| metric | Star count on `k3sava/substrate`, network-filtered |
| direction | `up` |
| threshold | ≥ 100 from non-network users |
| window | 2026-05-08 – 2026-08-07 |
| cohort | All GitHub users, with manual network filter |
| baseline | 1 star at v1.0 launch (kesava's own; GitHub API at this commit) |
| measurement_contract | [`goals/measurement-contracts/substrate-100-stars-2026-08-07.md`](measurement-contracts/substrate-100-stars-2026-08-07.md) |
| predicted_p | 0.35 |
| operator | kesava |
| opened | 2026-05-07 |
| status | open |
| outcome | `pending` |
| brier | — |

**Why this matters.** Stars feed the inbound funnel that feeds the engagement funnel. They don't pay rent, but they signal whether the opening sentence survives a stranger's three-second scan. Below 100 in 90 days, the hook isn't sharp.

**Intel pack.** README.md §thesis · ORIGIN.md · docs/index.html.

**Decision.** If this lands: README hook works; distribution effort moves to vertical AEO (per-vertical codex pages, ChatGPT and Perplexity citations). If this misses by 2026-08-07: README needs a sharper opening and a more shareable wedge. Iterate the opening sentence, post on HackerNews / Reddit / PMM Slack groups, retry next quarter.

---

## Resolved goals

| id | title | metric | predicted_p | actual | outcome | brier |
|---|---|---|---|---|---|---|

(none yet)

## Calibration

Run `bin/substrate score-goal --period 2026 Q2` to compute period-level Brier and aggregate the per-(operator, taste-type) leaderboard. Results land in `metrics/calibration.sqlite` and feed `bin/substrate-status` plus the dashboard.

---

*Substrate's own goals scored in public. Forks copy this file's structure into private fork `clients/<your-client>/goals/ledger.md`.*
