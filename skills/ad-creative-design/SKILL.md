---
name: ad-creative-design
description: Generate ad-creative variant briefs grounded in canonical positioning, status-quo competitor, and buyer-state cohort. Channel-specific output shapes (Google text ads, Meta image+caption, LinkedIn sponsored, X post). Refuses without canonical positioning. Reads buyer-state from personas/, status-quo from competitive layer, voice from brand-voice.
version: 0.1
amplifies: paid-marketing lead, content lead, copywriter
masters: April Dunford (positioning to ad-copy carry-through), Joanna Wiebe (Copyhackers ad copy formulas), Anthony Pierri (homepage to one buyer; same logic for ad creative), Susan Wenograd (creative is the targeting), Andrew Foxwell (variant volume), Aaron Orendorff (hook-led direct-response craft), Bob Moesta (JTBD forces in ad copy)
substrate_layers_required: [positioning, icp, voc, competitive, brand-voice]
patterns_grounded: [creative-fatigue-window, intent-vs-interest-targeting, buyer-mindset-not-product-features, copywriting-craft-fundamentals]
contradictions_aware: [no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-positioning, missing-buyer-state, missing-status-quo
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/04-competitive.md
  - clients/{client}/07-brand-voice.md
---

# ad-creative-design

## Purpose

Take the canonical positioning, the status-quo / named competitor framing, and a target buyer-state cohort, and emit a structured creative brief per channel. The brief is a structured prompt for a downstream LLM to generate the actual variants, plus the manual scaffolding (character limits, format constraints, what to test). It is not a prompt-emit stub: it pulls real content from the substrate and applies the channel-specific format.

The skill refuses to run without canonical positioning. It refuses to generate prospecting creative without a buyer-state cohort the brief can target. It refuses to generate competitive creative without the status-quo / named-competitor framing.

## Inputs

- `--client <client>` (required)
- `--channel <google-search|meta-paid-social|linkedin-sponsored|x|tiktok|reddit>` (required)
- `--cohort <buyer-state-slug>` (required) one of `unaware|problem-aware|solution-aware|most-aware` or a named cohort under `clients/<client>/personas/`.
- `--frame <status-quo|named-competitor>` (required) which competitive frame to apply. Status-quo = no-decision is the real competitor (Position A from `no-decision-vs-named-competitor`). Named = battle card against a specific competitor (Position B).
- `--competitor <slug>` (required when `--frame named-competitor`) which competitor to displace.
- `--variants <int>` (optional, default 4) how many variants to include in the brief.
- `--out <dir>` (optional, default `clients/<client>/ads/briefs/`)

## Substrate reads

- `clients/<client>/01-position.md` for the canonical statement, value pillars, and unique attributes.
- `clients/<client>/04-competitive.md` for status-quo framing and competitor one-liners.
- `clients/<client>/07-brand-voice.md` for the kill-list and voice patterns to apply / avoid.
- `clients/<client>/03-voice-of-customer.md` (optional) for buyer language to mirror.
- `personas/buyer-state/<cohort>.md` (or `clients/<client>/personas/<cohort>.md`) for the cohort's frictions, decision criteria, and objections.

## Channel-specific output shape

The brief is rendered with channel-specific format constraints baked in:

### `google-search`
- 3 RSA headlines (max 30 chars each), 2 description lines (max 90 chars each).
- Headline 1 includes the canonical category. Headline 2 includes the unique attribute. Headline 3 includes the call.
- Description 1 includes the value theme. Description 2 includes proof or specificity (named outcome, time-to-pilot, named-customer hint).
- Final URL path component is suggested from the cohort + frame.
- Keyword themes are NOT generated here (separate skill / Keyword Planner work).

### `meta-paid-social`
- Hook (first 3 seconds) script for video, or hook line for static.
- Primary text (max 125 chars before truncation).
- Headline (max 27 chars).
- Description (max 27 chars).
- 2-3 image / video direction notes (composition, on-creative text size, motion if applicable).
- A counterpart variant ("if hook A, then hook B is the contrast").

### `linkedin-sponsored`
- Headline (max 70 chars before truncation).
- Intro text (max 600 chars; first 150 chars before "see more").
- Single-image LP companion or carousel direction.
- Targeting note: roles + seniorities + company sizes, drawn from ICP.

### `x`
- Tweet 1 (max 280 chars) for the hook.
- Tweet 2 with the proof or specificity.
- Optional thread continuation.
- Image / video direction.

### `tiktok`
- Hook (first 1.5 seconds): voice-over line + visual.
- Pattern interrupt (3-5 second mark).
- Payoff (15-30 second mark).
- Caption direction.

### `reddit`
- Title format (max 300 chars).
- Body (max 40,000 chars for promoted posts; suggested length 250-500 words).
- Subreddit-fit notes if the operator named the subreddit in their input.
- A second, less-promotional variant (Reddit's audience is hostile to direct ad copy).

## Output contract

Writes a brief at `clients/<client>/ads/briefs/<channel>-<cohort>-<frame>-<YYYY-MM-DD>.md`:

```yaml
---
brief_id: <client>-ads-<channel>-<cohort>-<frame>-<YYYY-MM-DD>
channel: <channel>
cohort: <cohort>
frame: <status-quo|named-competitor>
competitor: <slug-or-empty>
variants_requested: <int>
substrate_layers_read: [positioning, icp, voc, competitive, brand-voice]
patterns_applied: [creative-fatigue-window, intent-vs-interest-targeting, buyer-mindset-not-product-features]
contradictions_resolved: [no-decision-vs-named-competitor]
canonical_position_excerpt: |
  <verbatim from clients/<client>/01-position.md>
status_quo_or_competitor_frame: |
  <verbatim from clients/<client>/04-competitive.md>
cohort_voice_signals: |
  <verbatim from personas/buyer-state/<cohort>.md>
---
```

Body sections:

1. **Brief context** the canonical statement, the cohort's daily reality, the chosen frame.
2. **Format constraints** the channel's character limits, image/video specs, lengths.
3. **Anchor terms** load-bearing words the variants must include (drawn from positioning).
4. **Avoid list** kill-list words, off-position terms, claims not in the allowed-claims set.
5. **N variant scaffolds** structured per channel.
6. **Test design note** which two variants are the A/B contrast and what hypothesis they test.
7. **Substrate citations** every load-bearing claim ties to a substrate path.
8. **Refusal-pattern compliance** explicit "this brief does not claim X without Y" notes.

## Quality criteria

- Every variant scaffold cites the substrate paths it drew from.
- Character limits are enforced (the brief shows exact counts).
- The cohort's actual frictions and objections appear in the variant logic.
- Anchor terms from positioning appear in at least 60% of headlines.
- Kill-list and off-position terms are explicitly excluded with a reason.

## What this skill does NOT do

- Does not generate finished ad copy. The brief is the input to a downstream LLM call (or human writer).
- Does not pick which channel to spend on. That is `ad-spend-allocate`.
- Does not refresh fatiguing creatives without an `ad-diagnose` flag. The brief responds to a flagged campaign or a fresh test, not to a vibe.
- Does not pick a global side of the no-decision-vs-named-competitor contradiction; the operator passes `--frame`.

## Refusal patterns

- Missing positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Missing competitive layer returns `SUBSTRATE-GAP — missing-competitive` (the brief depends on a frame).
- Missing buyer-state cohort returns `SUBSTRATE-GAP — missing-buyer-state` (cannot brief prospecting without a cohort).
- `--frame named-competitor` without `--competitor` returns `INPUT-GAP — competitor-required-with-named-frame`.
- `--frame named-competitor` with a competitor not in the competitive layer returns `INPUT-GAP — competitor-not-in-substrate`.

## See also

- `ad-diagnose` flags creatives that need a refresh; the flag becomes the input to this brief.
- `narrative-compose` produces longer-form copy that the ad creative can compress against.
- `messaging-matrix` provides the cell (persona x pain x value pillar x proof x call) that maps to a channel brief.
- `routines/ad-fatigue-routine.md` schedules the weekly brief queue from fatigue flags.
