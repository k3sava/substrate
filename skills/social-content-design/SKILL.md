---
name: social-content-design
description: Design platform-native social posts grounded in canonical positioning, a buyer-state cohort, and a chosen platform shape. Channel-specific output (LinkedIn long-form, X thread, TikTok hook + script, Instagram caption, YouTube short outline). Composes voice-enforce on every body. Refuses without canonical positioning. Reads optional client calendar at clients/<client>/social/calendar.yaml.
version: 0.1
amplifies: social media lead, content marketer, creator-operating-as-PMM, founder writing in own voice
masters: Justin Welsh (LinkedIn-and-X solo creator system), Sahil Bloom (multi-platform native authoring), Jasmin Alic (LinkedIn format discipline), Chenell Basilio (creator distribution teardowns), Joanna Wiebe (Copyhackers hooks), Bob Moesta (JTBD forces), Adam Robinson (founder-led B2B social), Yamini Rangan (HubSpot employee advocacy thesis)
substrate_layers_required: [positioning, icp, voc, brand-voice, competitive]
patterns_grounded: [native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion, copywriting-craft-fundamentals, buyer-mindset-not-product-features]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-positioning, missing-buyer-state
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
  - clients/{client}/07-brand-voice.md
---

# social-content-design

## Purpose

Take canonical positioning, a buyer-state cohort, and a target platform, and emit a platform-native draft for a single social post. Each platform gets a different shape because each platform has native rhythms (per `native-format-beats-cross-post`). The draft includes the hook, body, call, format constraints, and substrate citations.

The skill refuses to ship a generic cross-post. It refuses without canonical positioning because the post would have no anchor. It runs voice-enforce on every body before write; voice failures are surfaced and the file is marked.

Posts default to `--author personal` because B2B reach compounds on personal accounts (per `creator-not-corporate`). The corporate-handle path is supported but separately framed: announcement copy, not growth copy.

## Inputs

- `--client <client>` (required)
- `--platform <linkedin-long|linkedin-text|x-thread|x-single|tiktok|instagram-caption|youtube-short>` (required)
- `--cohort <buyer-state-slug>` (required) — `unaware`, `problem-aware`, `solution-aware`, `most-aware`, or a named cohort under `clients/<client>/personas/`
- `--purpose <thought-leadership|teardown|story|how-to|news|hot-take|customer-spotlight>` (required) — picks the structural template
- `--author <personal|corporate>` (default `personal`)
- `--variants <int>` (default 1)
- `--out <dir>` (default `clients/<client>/social/drafts/`)
- `--calendar-slot <slot-id>` (optional) — if `clients/<client>/social/calendar.yaml` declares the slot, the post is tagged for that slot and the calendar's `theme` and `cohort` defaults apply when arguments are not passed

## Substrate reads

- `clients/<client>/01-position.md` — canonical statement, value pillars, anchor terms
- `clients/<client>/02-icp.md` — cohort-to-cell mapping, role and size hints
- `clients/<client>/03-voice-of-customer.md` (optional) — buyer language to mirror
- `clients/<client>/04-competitive.md` (optional) — for hot-take or teardown posts that name a category alternative
- `clients/<client>/07-brand-voice.md` — kill-list, voice patterns, throat-clearing rules
- `personas/buyer-state/<cohort>.md` or `clients/<client>/personas/<cohort>.md` — frictions, objections, decision criteria
- `clients/<client>/social/calendar.yaml` (optional) — theme planner and slot defaults

## Platform-native output shapes

Each platform's draft follows its own structural rules. The character counts and shape rules are baked into the runtime; variants that would exceed limits are flagged.

### `linkedin-long`
- Opener (1-2 lines, max 250 chars before "see more" preview).
- 3-7 body sections, each 1-3 lines, separated by blank lines for whitespace.
- No external link in the post body (kills reach); link in first comment if needed.
- Comment-prompt close (a question that invites reply).
- Total length 800-1500 chars; longer is fine but cohort fatigue rises after 1500.

### `linkedin-text`
- Single short post, max 1300 chars.
- Hook in first 2 lines.
- Body 3-6 lines.
- Soft close (no hard call).

### `x-thread`
- Tweet 1: hook (max 280 chars), no link, no @ mention in the lead.
- Tweets 2-7: body beats, each a self-contained tweet (max 280 chars).
- Final tweet: soft call (link to long-form, newsletter, or product).
- Default thread length 5-8 tweets.

### `x-single`
- Single tweet (max 280 chars).
- Hook + payoff in one breath.
- No call required.

### `tiktok`
- Hook script (first 1.5 seconds): voice-over line, max 12 words.
- Body script (15-30 seconds): 3-5 beats with pattern interrupts.
- Caption (max 2200 chars; first 100 chars visible).
- On-screen text suggestions for key moments.

### `instagram-caption`
- Hook (first 125 chars before "more").
- Body (200-1500 chars).
- Hashtag block (3-7 hashtags, mixed reach).
- Soft call.

### `youtube-short`
- Title (max 100 chars).
- Hook script (first 3 seconds): voice-over.
- 3-beat outline for the rest (15-50 seconds).
- Description (max 5000 chars; first 150 visible).

## Process

1. Preflight via `skill-preflight.sh` — required reads, required layers, declared patterns, contradictions.
2. Read positioning; extract canonical statement, value pillars, unique attributes, anchor terms.
3. Read cohort persona; extract frictions, objections, voice signals.
4. Read brand voice; extract kill-list and any platform-specific overrides.
5. (Optional) read calendar.yaml; resolve slot defaults.
6. Render the platform-native draft with frontmatter, body, format-constraint table, and substrate citations.
7. Write the draft to disk.
8. Run `voice-enforce` on the body; mark the frontmatter `voice_check: pass | fail` and exit non-zero on fail (unless `--allow-voice-fail` is passed for in-progress drafts).

## Output contract

Writes a draft at `clients/<client>/social/drafts/<platform>-<cohort>-<purpose>-<YYYY-MM-DD>-<idx>.md`:

```yaml
---
draft_id: <client>-social-<platform>-<cohort>-<purpose>-<YYYY-MM-DD>-<idx>
platform: <platform>
cohort: <cohort>
purpose: <purpose>
author: personal | corporate
calendar_slot: <slot-id-or-empty>
substrate_layers_read: [positioning, icp, voc, brand-voice]
patterns_applied: [native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion, buyer-mindset-not-product-features]
contradictions_resolved: []
canonical_position_excerpt: |
  <verbatim from clients/<client>/01-position.md>
cohort_voice_signals: |
  <verbatim from personas/buyer-state/<cohort>.md>
voice_check: pass | fail | pending
authored_date: <YYYY-MM-DD>
produced_by: social-content-design
---
```

Body sections:

1. **Brief context** — canonical statement excerpt, cohort one-liner, chosen platform and purpose.
2. **Format constraints** — character limits and structural rules baked in.
3. **The draft** — the post itself in platform-native shape.
4. **Anchor terms used** — load-bearing words from positioning that appear in the draft.
5. **Voice-check** — output of voice-enforce.
6. **Substrate citations** — every load-bearing claim ties to a substrate path.
7. **Refusal-pattern compliance** — explicit "this draft does not claim X without Y" notes.
8. **Distribution note** — reminder that social is top-of-funnel; track cohort-level metrics, not last-click.

## Quality criteria

- Hook lands in the cohort's frictions or objections, not in the product feature list.
- Anchor terms from positioning appear in body (at least 2 of the top-10 anchors).
- Character limits enforced; over-budget drafts flag rather than silently truncate.
- Kill-list words rejected (voice-enforce composed).
- Personal-account posts read in the operator's voice; corporate-handle posts read as announcement.
- Native-format rules applied per platform; no Twitter-thread shape on LinkedIn, no LinkedIn-essay shape on X.

## What this skill does NOT do

- Does not auto-publish. Drafts are written; the operator schedules.
- Does not generate finished video, audio, or image assets. Scripts and outlines only.
- Does not run A/B tests on hooks. Use `social-amplification-test` for that.
- Does not measure performance. Use `social-fatigue-monitor` for the post-publish loop.
- Does not score influencers. Use `influencer-fit-score`.
- Does not pick a global side of contradictions. The operator passes `--author personal|corporate`.

## Refusal patterns

- Missing canonical positioning at `clients/<client>/01-position.md` returns `SUBSTRATE-GAP — missing-positioning`.
- Missing brand voice returns `SUBSTRATE-GAP — missing-brand-voice`.
- Missing buyer-state cohort returns `SUBSTRATE-GAP — missing-buyer-state` (cannot draft without a cohort).
- Voice-enforce failure on the body marks the file `voice_check: fail` and exits non-zero unless `--allow-voice-fail` is set.
- Calendar-slot referenced but missing in calendar.yaml returns `INPUT-GAP — calendar-slot-undeclared`.
- `--platform x-single` with `--purpose teardown` returns `INPUT-WARN — purpose-platform-mismatch` (single tweet is too short for a teardown structure; the skill will continue but flag).

## See also

- `social-fatigue-monitor` — flags posts whose engagement is decaying.
- `social-amplification-test` — A/B tests hook variants and posting time.
- `social-listening-themes` — extracts themes from comments and mentions.
- `influencer-fit-score` — scores influencer fit against ICP and brand.
- `narrative-compose` — produces the long-form narrative the social posts compress.
- `voice-enforce` — gates every body.
- `routines/social-content-cycle.md` — the weekly operating loop.
- `knowledge/patterns/native-format-beats-cross-post.md`
- `knowledge/patterns/creator-not-corporate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
