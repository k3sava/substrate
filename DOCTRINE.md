---
title: Substrate operating doctrine
status: active
last_updated: 2026-05-17
version: 2.0
---

# Substrate operating doctrine

The doctrine sits a layer above [PRINCIPLES.md](PRINCIPLES.md). Principles govern how substrate skills behave; the doctrine governs what kind of work substrate is built to do, and the posture an operating team takes when running it. Slowest layer to change in the repo.

## Claim

Most marketing teams treat AI as a faster typist. That posture caps output at the shape of the prompt. Substrate's posture is the opposite: AI is a function of context, and the team's job is to design the context AI reads.

Substrate is built to run that posture as an operating system. Skills, gates, calibration, orchestrations, every layer exists so a team can produce work that holds up under scrutiny: cited claims, falsifiable goals, buyer-tested drafts, calibrated bets.

Five rules govern how a team operates substrate.

## The five rules

### 1. Context first, always

Before any skill runs, any draft ships, any goal opens, the context that informs it must exist, be inside its freshness window, and be cited. The corpus (knowledge layer), the per-client record (`clients/<slug>/`), the schema (events, taxonomy, measurement contracts) are the shippable artifact, not the side effect of the work. Team effort moves to designing the context; substrate runs the loop.

### 2. Fewer assets, higher ground

Volume is not the metric. Every asset ships with an evidence trail. Every claim traces to a context file. Calibration over volume. The team that ships 10 calibrated assets per quarter beats the team that ships 100 unevidenced ones, because the calibrated team's predictions get sharper over time.

### 3. Buyer is the audience, not the marketer

Customer transcripts are substrate input. AI clusters at scale; humans read what matters and act. Every product decision traces to a verbatim quote. The frontline conversation is the substrate; the office is downstream. (See `pat_frontline-as-pmm-substrate`, `pat_jtbd-as-buyer-mental-model`, `pat_tf-idf-themes-from-customer-language`, `pat_tickets-are-product-feedback-channel`.) Drafts are tested against pinned buyer panels, not the team's taste. Internal applause is not signal.

### 4. Authority follows accuracy, not title

Whoever has the best Brier score on a craft cell calls the shot on that cell, regardless of role or seniority. The accuracy tracker is institutional memory. Decision authority on a craft is the top operator on that cell with at least three resolved goals. This is structure-agnostic; it works under any org shape leadership picks.

### 5. The loop closes, or it doesn't count

When a goal resolves, the context updates to reflect what the resolution taught. If the goal said "this position works" and the resolution said "it didn't," the competitive layer and brand voice layer update accordingly. A loop that doesn't close is a read operation, not a learning operation. The value is in the learning.

## Mechanism

Each rule alone is fragile.

- Context-first without falsifiable goals becomes documentation theatre.
- Fewer-assets-higher-ground without buyer-grounding becomes a slow-shipping team that ships the wrong thing slowly.
- Buyer-as-audience without calibrated authority means the loudest voice still wins arguments.
- Authority-follows-accuracy without the closing step means the tracker rots.
- The loop closing only matters if the four upstream rules are honoured.

Together the rules compound. Context absorbs the coordination tax. Calibration replaces opinion with evidence. The buyer's voice routes the bets. The team that ships under substrate's gates produces work that gets sharper every quarter.

## Conditions the doctrine holds under

- The team is willing to refuse to ship work that fails the gate, even under deadline pressure.
- Customer transcripts are captured, indexed, and queryable from day one.
- Leadership treats Brier-scored accuracy as a routing signal, not a performance review.
- The team accepts that fewer, sharper assets beat higher volume.

## Conditions the doctrine fails under

- Leadership measures the marketing team on output volume, not outcomes.
- The team treats gates as suggestions and overrides freely.
- Customer transcripts aren't captured, so buyer-as-audience can't be operationalised.
- Goals open without measurement contracts, so the loop never closes.

## Signals (the doctrine is being followed)

- Every external draft ships with a citation trail.
- Goal ledger has more `resolved` entries than `opened` entries, with Brier scores recorded on every resolution.
- Per-(operator, craft) accuracy data is the input to who-calls-what decisions, not seniority.
- Customer transcripts are routed to the team and substrate skills consume them as canonical input.
- The freshness check runs weekly; stale layers are refreshed, not papered over.

## Operator posture

The team running substrate is small, judgment-dense, and willing to be wrong in public (because being wrong in public is what the Brier score makes legible). Authority routing is calibration-aware, not seniority-aware. The system is the floor; people set the ceiling.

## See also

- [`PRINCIPLES.md`](PRINCIPLES.md) — the operating principles for substrate skills. Doctrine sets the posture; principles enforce the floor for what ships.
- [`ORIGIN.md`](ORIGIN.md) — substrate's version arc.
- [`goals/ledger.md`](goals/ledger.md) — example goal entries scored against the doctrine.
- [`knowledge/ideas/calm-company-lineage.md`](knowledge/ideas/calm-company-lineage.md) — operator lineage research informing substrate's posture (separate research file; pointer only).
