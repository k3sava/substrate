---
title: Substrate, agent rules
status: active
last_updated: 2026-05-17
---

# How AI tools should use this folder

This file is read by AI sessions that operate inside `substrate/`. It states what Substrate is, where the load-bearing files live, and the rules that compound across sessions.

## What Substrate is, in one paragraph

An AI-native operating system for PMM, GTM, and marketing workflows. Every external draft (landing page, ad, email, content piece, video, sales sequence, CS playbook) is grounded in canonical context, gated by a pre-publish check, scored against a stand-in buyer panel, and tied to a goal with a calibration score. Context is the multiplier, not AI. Same operator, same task, with context, produces materially better output. v1.6 ships 86 wired skills across 16 surfaces, 84 codex-grounded patterns, 20 contradictions with conditioning rules, and 8 end-to-end orchestrations that compose skills into named PMM / GTM cycles.

## The eight layers

1. **Context**, `clients/<client>/` plus `knowledge/`. Slow-changing reference material; canonical citations.
2. **Skills**, `skills/`. Specific tasks the system can run. 86 wired skills as of v1.6.
3. **Goals**, `goals/ledger.md`. Falsifiable predictions; scored at resolution.
4. **Routines**, `routines/`. Single-purpose recurring loops + 8 end-to-end orchestrations that compose skills into named cycles.
5. **UX**, `bin/substrate-status` plus `dashboard/`. Operator review queue and live web view.
6. **Calibration**, per-(operator, taste-type) Brier history.
7. **Principles**, `PRINCIPLES.md`. The operating rules (the nine rules + Rule 9a behavioral grounding). Slowest to change.
8. **Reconciliation**, the weekly knowledge check. Always-on freshness and link integrity.

## Top-level files

- `README.md`, outside-facing summary.
- `QUICKSTART.md`, clone-and-run flow.
- `PRINCIPLES.md`, the operating rules.
- `DOCTRINE.md`, operating posture for a team running substrate.
- `ORIGIN.md`, how this came together (v0.1 through v1.6).
- `CONTRIBUTING.md`, how to contribute.
- `VERSION`, current version.

## Calling skills

```
bin/substrate <skill> <args>      # primary entry
bin/substrate --list              # list registered skills
bin/substrate-status              # operator review queue
bin/substrate-dashboard           # regenerate the dashboard
```

Run from the repo root, or add `bin/` to PATH.

## Anti-fabrication rules

- Every claim cites a context path. No invented metrics, dates, or quotes.
- Five-tier evidence ladder per `knowledge/ideas/how-confident-are-we.md`: `verified`, `self-reported`, `contextual`, `indirect`, `direct`.
- The pre-publish check refuses to ship if any cited context path is missing.
- Voice rules per `knowledge/voice/how-we-write.md`: no em dashes in body copy, kill-list applied, no throat-clearing openers.

## How to start a session

1. Read `PRINCIPLES.md` (slow layer; sets the rules every other layer follows).
2. If working with a project's context, read its index file first (`clients/<client>/00-INDEX.md`).
3. Run `bin/substrate-status` to see the review queue.
4. Pick a goal or a draft. Run the relevant skill. Trust the gate.

## Multi-function collaboration

Substrate is designed to operate across every GTM function: product, PMM, content marketing, performance / growth, SEO / AEO / GEO, sales, success, support, and leadership / RevOps. The "what, why, and who for" is shared Substrate; everything downstream gates against it. A skill called by a sales lead reads the same canonical positioning a PMM authored. A blog post drafted by content marketing passes the same voice gate as an outbound sales sequence. An LP variant from performance marketing carries the same measurement-contract discipline as a quarter-level company goal. A claim a CS playbook depends on is gated by the same `claim-verify` skill that gates an AEO-tuned passage. The system enforces consistency *across functions*, not just within one.

The `clients/<client>/team-canonical/` folder is the in-repo snapshot of cross-functional canonical docs (ICP, pain corpora, vertical files, LP briefs, allowed-claims, banned-words, displacement framing). These supplement the 10-layer context.

## Self-evolution loop

A daily ingest (`routines/digest-ingest.md`) reads research digests produced by an upstream research pipeline. Digests carry "apply-to-substrate" sections, which skills, principles, or knowledge layers should change. Low-risk knowledge updates auto-merge. Skill / principle changes file a proposal for human review. Substrate ships the contract; bring your own digest source.

## What not to do

- Don't ship an external draft without running the pre-publish check.
- Don't fabricate context paths. If a citation is missing, fix the context first.
- Don't bypass the voice check on customer-facing copy.
- Don't open a goal without a measurement contract, a window, and a predicted confidence.
- Don't resolve a goal without a real signal from the named source system.
- Don't soften the calibration-over-volume framing.
