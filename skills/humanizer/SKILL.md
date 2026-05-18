---
name: humanizer
description: Strips AI-writing tells from any draft. Combines the operator's voice canon (per-client brand-voice or knowledge/voice/how-we-write.md) with the blader/humanizer v2.5.1 workflow + Wikipedia's WikiProject AI Cleanup field guide. Detects 11 rule-pack categories (kill-list, weak-verbs, abstract-nouns, throat-clearing, cliches, banned-vocab, negative-parallelism, meta-commentary, participle-phrases, chatbot-artifacts, copula-avoidance, dead-phrases) plus an LLM-driven rewrite pass.
version: 0.2
status: wired (detection layer; rewrite step requires --rewrite flag + Claude CLI)
absorbed_from:
  - knowledge/voice/how-we-write.md (substrate default voice canon)
  - clients/<client>/brand-voice/voice-dna-*.md (per-client override, optional)
  - https://github.com/blader/humanizer (v2.5.1; MIT; workflow + audit pattern)
  - https://en.wikipedia.org/wiki/Wikipedia:WikiProject_AI_Cleanup (rule-source-of-truth)
absorption_date: 2026-05-01
amplifies: every operator who ships customer-facing copy (LP, email, blog, content, ad, video script)
masters: Cole Schaefer (Honey Copy sentence craft); Joanna Wiebe (Copyhackers conversion canon); Wikipedia WikiProject AI Cleanup (Signs of AI writing field guide).
substrate_layers_required: [brand-voice]
preflight_refusal: substrate-gap
composes_with: [voice-enforce, voice-enforce-vale, pre-publish-check, copywrite]
---

# humanizer

## Purpose

Audit any draft against the full anti-AI-writing canon, then rewrite the failing parts so the output reads like a sharp human typed it. Three-layer detection (Vale rule packs → semantic check → LLM rewrite); single-pass operator workflow.

## Inputs

- `--asset <path>` (positional) — the draft markdown
- `--rewrite` — if set, invoke Claude CLI to rewrite each flagged span (default: detect-only)
- `--strict` — fail on warnings as well as errors
- `--report-only` — emit JSON of all violations; no rewrite

## Detection layer (the 11 rule packs)

Runs Vale with substrate's default style packs (operators may add per-client packs under `.vale-styles/<client>/`):

| Rule pack | Severity | Source |
|---|---|---|
| `KillList` | error | knowledge/voice/how-we-write.md (kill-list canon) |
| `WeakVerbs` | warning | Cole Schaefer + per-client voice canon |
| `AbstractNouns` | warning | Wiebe + per-client voice canon |
| `ThroatClearing` | error | substrate voice rules + per-client voice canon |
| `Cliches` | warning | knowledge/voice/how-we-write.md (AI-fingerprint section) |
| `BannedVocab` | **error** | per-client banned-claims.md or knowledge/voice/how-we-write.md |
| `NegativeParallelism` | **error** | "not just X — but Y" pattern (16 known variants) |
| `MetaCommentary` | error | substrate voice rules |
| `ParticiplePhrases` | warning | substrate voice rules |
| `ChatbotArtifacts` | error | humanizer field guide |
| `CopulaAvoidance` | warning | per-client voice canon + humanizer |
| `DeadPhrases` | error | substrate voice rules |

## Rewrite layer (when `--rewrite` set)

For each flagged span, the rewriter runs the Claude CLI with this contract:
- Read the asset's surrounding paragraph (context window).
- Read the Vale finding (which rule fired + why).
- Read the per-client voice canon (or the substrate default) for that rule category.
- Produce a single replacement sentence/clause that fixes the violation, preserves the underlying claim, and matches the asset's voice.

The rewrite is non-destructive: it writes to `<asset>.humanized.md` (sibling file) for human review. The operator (or a downstream cron) merges manually after a quick read-through.

## Audit layer (the humanizer signature pass)

After detection + optional rewrite, ask the LLM the blader/humanizer audit question on the (possibly rewritten) text:

> "What makes this obviously AI generated?"

Record the answer in stderr. If the answer names new tells the rule packs missed, add them to the rule-pack queue at `knowledge/intel/voice-rule-pack-queue-<date>.md`. This is the auto-improvement loop.

## Outputs

- **stderr** — per-violation table (rule × severity × line × match × why × fix-hint).
- **stdout** — single-line summary: `PASS / FAIL N errors M warnings`.
- **`<asset>.humanized.md`** (only with `--rewrite`) — sibling file with rewrites applied span by span.

## Exit codes

- `0` — clean (no errors; warnings allowed unless `--strict`)
- `1` — error-level violations found
- `2` — file not found / Vale not installed / Claude CLI not available (only matters with `--rewrite`)

## Composes with

- **voice-enforce-vale** — humanizer wraps the same Vale infrastructure but adds the LLM rewrite layer on top. voice-enforce-vale is the gate; humanizer is the editor.
- **pre-publish-check** — humanizer can be added as a richer voice gate (default pre-publish-check uses voice-enforce-vale; humanizer is the strict superset).

## Refusal patterns

- Substrate gap: if `clients/<client>/brand-voice/voice-dna-*.md` is missing AND `knowledge/voice/how-we-write.md` is missing, refuse to rewrite (would invent voice instead of inheriting it).
- Internal-spec asset (knowledge/intel/, substrate/, raw/, etc.): bypass automatically per `.vale.ini` glob rules.
- Empty asset / non-markdown: exit 2 with explanation.

## Calibration

Tracked under taste-type `voice-enforcement` and `humanizer-rewrite`. Brier signal: post-publish reader-detection rate (we look for *low* AI-detection rate on a published page).

## Substrate preflight

This skill verifies its declared layer dependency (brand-voice) is `covered` per the client's substrate index. If neither a per-client `voice-dna-*.md` nor `knowledge/voice/how-we-write.md` is present, refuses to ship a rewrite (canon-less rewrite would drift).

## Why this matters

The negative-parallelism pattern ("not just X — but Y") is the single most common AI tell. Detection alone catches the gap; humanizer closes the gap by rewriting. Without the rewrite layer, operators get a fail report and have to fix by hand — that's voice-enforce-vale's role. With humanizer, the operator gets a draft + a reviewable rewrite. The compound is the read-time-to-ship reduction.

## Open work

- Voice-calibration pass: ingest a sample of operator's prior writing → fingerprint their voice → rewrite to that voice.
- Cross-link to an eval framework — humanizer becomes a graded eval against the published-content corpus.
- Auto-add-to-rule-queue loop: the audit-layer LLM answer feeds back into rule pack updates.
