---
name: first-pmm-compression
description: 30-day playbook for the first / founding PMM at a startup that's never had one. Compresses VoC capture, positioning v0, messaging matrix, and the first customer-facing artifact into a four-week sequence that produces a 90-day roadmap with three calibrated bets. Different in shape from `new-client-onboarding-week-1` (which assumes a team exists).
version: 0.2
status: wired
updated_date: 2026-05-18
amplifies: founding PMM, fractional PMM, founder doing their own PMM, head of marketing onboarding a first-PMM hire
masters: April Dunford (positioning is a process not a workshop), Anthony Pierri (founder-PMM thesis, "do less marketing better"), Mike Maples Jr. (inflection theory, the first PMM names the new game), Sangram Vajre (Move, GTM Operating System), Sarah Tavel (3-jobs-of-a-startup PMM), Ramli John (product-led storytelling), Bob Moesta (forces of progress at category-zero), Andy Raskin (the strategic narrative is the founder's voice amplified), a founding CEO ("I am my own product marketer; I need to stop")
substrate_layers_required: [voc, positioning, icp, brand-voice]
patterns_grounded: [founding-pmm-amplifies-founder-voice, frontline-as-pmm-substrate, narrative-as-strategy, status-quo-is-the-competitor, diagnose-before-execute, jtbd-as-buyer-mental-model]
contradictions_aware: [no-decision-vs-named-competitor, build-quietly-vs-distribution-first, personalization-vs-scale, emerging-vs-mature-category]
preflight_refusal: substrate-gap, missing-founder-voice, missing-3-customer-calls, missing-category
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/founder-voice/00-INDEX.md
  - knowledge/patterns/founding-pmm-amplifies-founder-voice.md
  - knowledge/patterns/frontline-as-pmm-substrate.md
  - knowledge/patterns/narrative-as-strategy.md
  - knowledge/patterns/diagnose-before-execute.md
---

# first-pmm-compression

## Purpose

The first PMM at a startup has no team to inherit, no playbook to read, no calibration history, no canonical positioning to gate against. `consulting-poc` runs a 5-day diagnostic and `new-client-onboarding-week-1` runs days 1-5 of a paid engagement assuming a team exists. Neither speaks the founding-PMM language: *"I am my own product marketer; I need to stop."* This skill is the 30-day shape for that case. It refuses to ship positioning before VoC, refuses to ship a customer-facing artifact before positioning, and refuses to commit a roadmap before three calibrated bets land in the ledger.

## When to use

- The prospect's hiring text says *founding PMM*, *first PMM*, *first marketing hire*, or the founder explicitly says they're doing PMM themselves.
- The company has no canonical positioning, no documented ICP, and no message house. (If they do, run `new-client-onboarding-week-1` instead.)
- The engagement shape is fractional, embedded, or train-the-team — not POC.

## Inputs

- `--client <slug>` (required) — the prospect, used as `clients/<slug>/`
- `--founder-handle <linkedin-url-or-handle>` (required) — for `founder-voice-substrate` pre-read
- `--category <slug>` (required) — substrate categorization (e.g. `ai-infra`, `agentic-creative`, `legal-compliance-ai`)
- `--customer-call-target <int>` (optional, default 5) — number of frontline calls to log before positioning v0
- `--output-dir <path>` (optional) — default `clients/<client>/roadmap/30d/`

## Substrate reads

- `clients/<client>/BRIEF.md` — must exist and name the company, the founder, the customer count, the funding stage.
- `clients/<client>/founder-voice/` — populated by `founder-voice-substrate` before day 1. If absent, the skill refuses.
- `knowledge/patterns/frontline-as-pmm-substrate.md` — load-bearing pattern: positioning without VoC is fiction.
- `knowledge/patterns/narrative-as-strategy.md` — the strategic narrative is the load-bearing artifact, not the LP.

## The four-week shape

### Pre-day-1 (Phase 0, free, before contract)

- Founder-voice substrate captured (composes `founder-voice-substrate`): cadence stats, kill-list, reusable narrative beats, voice-anchors.
- Customer-call calendar: 5 calls booked across users, churned, prospects-who-said-no.
- What-already-shipped audit: every customer-facing surface (LP, blog, docs, sales deck, demo script) read and citation-tagged.
- *Single-message inheritance problem* named: the one claim the founder repeats that no PMM artifact has codified yet.

### Week 1 (days 1-7) — VoC + positioning v0

- Five frontline calls logged in `clients/<client>/voc/inbox/` (composes `frontline-contact`).
- Status-quo identification: what alternative the buyer is currently using (spreadsheet, internal build, no-decision, named-competitor). Composes `status-quo-frame`.
- Positioning v0 drafted (composes `positioning-forge` with `--scope whole-product`). Refuses to ship a v1 in week 1 — v0 is the substrate-cited skeleton, not the message.
- No customer-facing assets ship this week. The team's instinct will be to ship a blog post or an updated LP; the skill blocks both with the load-bearing refusal: positioning before publishing.

### Week 2 (days 8-14) — message house + one artifact

- Messaging matrix composed (`messaging-matrix`) from positioning v0 + the five VoC calls.
- ICP cut formalized (`icp-cut`) from VoC firmographics.
- One customer-facing artifact ships, gated by `pre-publish-check`. Highest-leverage of: (a) a single LP variant tested against the status-quo frame, (b) a content brief that names the new game per Raskin, (c) a sales deck rewrite for the top of funnel. The founder picks. The skill enforces only that one ships.
- Calibration baseline: one 90-day Brier-scorable prediction opened in `goals/ledger.md`.

### Week 3 (days 15-21) — launch or LP

- Higher-leverage of: `launch-plan` (if a product release is in window) or `lp-ship` (if not).
- Voice gate runs on every asset. The founder's voice substrate gates the team's drafts, not just the PMM's.
- Competitive layer initialized (`competitive-scout`) — at least the status-quo + 2 named competitors with battle-card seeds.

### Week 4 (days 22-30) — roadmap + handover

- 90-day roadmap (`clients/<client>/roadmap-90d.md`) with three calibrated bets opened against `goals/ledger.md`.
- Handover doc: how the founder (or the next hire) runs substrate after the engagement closes. Includes which skills to run weekly, which monthly, which quarterly.
- Calibration baseline: predicted Brier scores for the three bets, with kill criteria.

## Output contract

```
clients/<client>/
  founder-voice/
    voice-anchors.md
    kill-list.md
    cadence-stats.md
  voc/
    inbox/
      day-N-<persona>-<date>.md  (5 files minimum)
  positioning/
    positioning-canonical-statement.md  (v0, week 1)
    positioning-canonical-statement.md  (v1, week 4 if changed)
  icp/
    00-INDEX.md
  competitive/
    status-quo.md
    battle-cards/  (2 seed cards)
  assets/
    week-2-<artifact-type>.md  (one ships)
    week-3-<artifact-type>.md  (one ships)
  roadmap/30d/
    week-1-report.md
    week-2-report.md
    week-3-report.md
    week-4-report.md
    handover.md
  roadmap-90d.md
```

Every artifact carries `produced_by: first-pmm-compression` (with the composing skill in `composed_skills:`) so Gate 9 and Gate 10 fire on pre-publish.

## Quality criteria

- Refuses to advance past week 1 without 5 frontline calls logged.
- Refuses to ship the week-2 artifact without positioning v0 committed.
- Refuses to commit the 90-day roadmap without three calibrated bets in `goals/ledger.md`.
- Refuses to skip founder-voice-substrate. Without it, every asset carries the team's voice not the founder's, and the first PMM's job — *amplify the founder's clarity* — is impossible.
- Voice-enforce gates every ship. Kill-list from founder-voice substrate gates the team's drafts, not the PMM's alone.

## Contradictions awareness

- `no-decision-vs-named-competitor` — first-PMM engagements skew status-quo: the buyer is choosing nothing or a spreadsheet. The skill picks Position A by default and logs the conditioning evidence (typical founding-PMM startup is in a category-creation moment, not a category-displacement one). Override flag: `--displacement-context`.
- `build-quietly-vs-distribution-first` — at founding-PMM stage, the founder usually has the inverse problem: they've built loudly and have no product-craft moat. The skill picks Position B (distribution-first conditioning is rare at this stage) but flags every week's report for re-eval.
- `personalization-vs-scale` — week 2 artifact defaults to Tier 1A (hand-personalize, the founder's calls drive copy). Override only if the prospect already has a category-leader brand.

## Refusal patterns

- `SUBSTRATE-GAP — founder-voice missing` — run `founder-voice-substrate --founder-handle <X>` first.
- `SUBSTRATE-GAP — fewer than 5 customer calls logged` — block at week-1 close.
- `SUBSTRATE-GAP — no category named` — refuse to draft positioning v0 without a category. Use `--category none` only as a logged exception.
- `SUBSTRATE-GAP — no founder-voice cadence stats` — the substrate file exists but no calibration. Refuse and re-run `founder-voice-substrate`.

## What this skill does NOT do

- Does not run the discovery call. That's `consulting-poc --phase-0`.
- Does not negotiate pricing. That's `engagement-shape-pricing`.
- Does not hire the next PMM. The handover doc names what the next hire needs to read; it doesn't write the JD.
- Does not generalize to non-founding engagements. Director-PMM onboarding compression is a separate skill (proposed `director-pmm-onboarding-compression`, v1.7).

## See also

- `skills/consulting-poc/` — the entry point; first-pmm-compression typically starts after a Phase-0 audit closes.
- `skills/founder-voice-substrate/` — the required pre-read.
- `skills/frontline-contact/` — composes for VoC capture.
- `skills/positioning-forge/` — composes for positioning v0.
- `skills/messaging-matrix/` — composes for the message house.
- `skills/launch-plan/` and `skills/lp-ship/` — week-3 artifact options.
- `routines/new-client-onboarding-week-1.md` — the alternative routine when the team already exists.
- `knowledge/patterns/founding-pmm-amplifies-founder-voice.md` — the load-bearing pattern (Pierri, Raskin, Shewey, Maples).
- `knowledge/patterns/frontline-as-pmm-substrate.md` — VoC-as-substrate companion.
- `knowledge/patterns/narrative-as-strategy.md` — strategic-narrative companion.
- `knowledge/contradictions/emerging-vs-mature-category.md` — the category-maturity switch for week-1 positioning v0.
- `UPGRADES-2026-05-18.md` — the gap analysis that derived this skill.

## Future work (deferred to substrate v1.7 back-half)

- `templates/first-pmm-30d-roadmap.md` — fill-in template the skill emits at week 4. Deferred to back-half v1.7.
- Wire into `routines/digest-ingest.md` so any digest tagged `founding-pmm` updates this skill's pattern citations.
- Per-stage conditioning (pre-seed vs seed vs Series A founding-PMM engagements have different week-1 shapes). Currently the skill collapses them; v1.7 splits.
