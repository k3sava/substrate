---
title: social content cycle
status: active
last_updated: 2026-05-08
cadence: weekly
skill_chain: [social-listening-themes, social-content-design, social-amplification-test, social-fatigue-monitor, influencer-fit-score]
patterns_grounded: [native-format-beats-cross-post, creator-not-corporate, social-as-distribution-not-conversion]
---

# Social content cycle

A weekly five-stage cycle that wires the substrate's social skills into a closed loop. The cycle reads from canonical positioning, ICP, brand voice, and a buyer-state cohort; emits drafts that compose `voice-enforce` on every body; tests hooks with falsifiable measurement contracts; flags fatigue against a rolling window; and feeds influencer collaborations through the same fit model.

The pattern in plain terms: social is a top-of-funnel surface that compounds awareness on personal accounts when the content is platform-native and the measurement is cohort-level. A program without a weekly rhythm and a fatigue watch loses ground quietly; the engagement curve flattens, the audience drifts, and the substrate that grounds the next post drifts with it. This routine is the operating loop that closes those gaps.

The work is operator-fired. Substrate does not auto-publish; the operator schedules through the platform of their choice. The substrate's job is to refuse bad input and surface the work that has to happen, not to be a posting tool.

---

## Stage 1, Listen

**Cadence**: every Monday, before the writing block.

**Trigger**: the operator pulls a fresh export of comments / mentions / replies for the prior week from each platform the program publishes on. LinkedIn comments via the LinkedIn export, X replies via the X archive (or a scraping helper), Reddit mentions via the operator's chosen monitoring tool. The export covers the last 7-14 days at the row-per-comment grain.

**Required headers** (per `social-listening-themes` SKILL.md):

```
source,date,post_id,author_handle,comment_text,sentiment,permalink
```

Recommended optional headers: `reply_to_post_id`, `competitor_mention`, `brand_mention`, `role_signal`.

**Run**:

```bash
substrate social-listening-themes --client <client> \
  --mentions-dir clients/<client>/social/mentions/ \
  --source linkedin
```

**Output**: `clients/<client>/social/themes/<source>-<YYYY-MM-DD>.md`. Surfaces:

- **Pain themes**, clusters whose tokens overlap with the cohort's friction language. Routes to the next-cycle `social-content-design` slot as the hook angle.
- **Competitor mentions**, comments that name a competitor by slug. Routes to `competitive-scout` if the volume is rising.
- **Viral hook patterns**, comments that responded to specific hooks; raw inputs to the writing block.
- **Off-brand or trolling**, flagged for moderation, not for content mining.

**Refusal triggers**: missing canonical positioning, missing mentions dir, mentions CSV missing required headers. Operator fixes substrate or the export, then re-runs.

---

## Stage 2, Draft

**Cadence**: every Monday, after Stage 1 completes.

**Trigger**: the calendar slots for the week (declared in `clients/<client>/social/calendar.yaml`) plus any new hook angles surfaced by Stage 1.

**Run** per scheduled slot:

```bash
substrate social-content-design --client <client> \
  --platform <platform> --cohort <buyer-state> \
  --purpose <thought-leadership|teardown|story|how-to|news|hot-take|customer-spotlight> \
  --calendar-slot <slot-id>
```

**What it does**: reads the canonical positioning, the buyer-state cohort, the brand voice, and (optionally) the calendar slot's defaults. Renders a platform-native draft with hook, body, close, format constraints, anchor terms used, and substrate citations. Composes `voice-enforce` on every body before write; voice failures mark the file `voice_check: fail` and exit non-zero (unless `--allow-voice-fail` is set for in-progress drafts).

**Output**: `clients/<client>/social/drafts/<platform>-<cohort>-<purpose>-<YYYY-MM-DD>-<idx>.md`.

**Refusal triggers**: missing canonical positioning, missing brand voice, missing buyer-state cohort, calendar-slot referenced but missing in calendar.yaml. Fix and re-run.

**Native-format note**: per `pat_native-format-beats-cross-post`, each platform is its own authoring lane. The same idea on LinkedIn and X is two separate drafts; do not paste a draft from one surface into another.

**Author-lane note**: per `pat_creator-not-corporate`, default `--author personal`. Reserve `--author corporate` for announcement copy.

---

## Stage 3, Test

**Cadence**: every Monday or Tuesday, when a slot has two competing hook hypotheses.

**Trigger**: the operator wants to test a hook variant, a format variant, or a posting time. Not every slot is a test; a sustainable cadence runs 1-2 tests per week, not five.

**Run**:

```bash
substrate social-amplification-test --client <client> \
  --platform <platform> --cohort <buyer-state> \
  --test-type <hook|format|time> \
  --baseline-engagement-rate <float> --target-lift-pct <float> \
  --variants 2
```

**What it does**: reads positioning + cohort + brand voice. Computes the sample-size window required to detect the target lift at the operator's chosen alpha and power (defaults 0.10 and 0.80). Writes a test spec with a measurement contract. The test spec is the input to the operator scheduling the variants on the platform; substrate does not run the test.

**Output**: `clients/<client>/social/tests/<test-id>/spec.md` plus a measurement-contract stub at `goals/measurement-contracts/<test-id>.md`.

**Refusal triggers**: missing positioning, missing cohort, sample-size impossible to reach within the platform's typical impressions cadence (the spec surfaces this with an `INPUT-WARN`, `window-too-long`, not an error). Fix and re-run.

---

## Stage 4, Watch

**Cadence**: every Monday, after Stage 1.

**Trigger**: a metrics export is committed to `clients/<client>/social/metrics/<platform>-<YYYY-MM>.csv`. Operators commit weekly; substrate does not pull from platform APIs.

**Run**:

```bash
substrate social-fatigue-monitor --client <client>
```

**What it does**: reads the last N months of per-platform metrics. Computes rolling 4-week-vs-prior-4-week lift on impressions, engagement rate, and follower-growth correlation. Flags posts whose engagement is more than one standard deviation below the platform's current-window mean. Classifies decay shape (sudden cliff, gradual taper, step-down). Routes each shape to the first-hypothesis fix:

- Sudden cliff → check platform algorithm change, account-level penalty, content-policy hit.
- Gradual taper → relevance erosion; route to `social-listening-themes` next cycle and `social-amplification-test` for hook variants.
- Step-down → format change or lost-comment-velocity; route to `social-content-design` for native-format refresh.

**Output**: `clients/<client>/social/fatigue-flags/<YYYY-MM-DD>.md`.

**Refusal triggers**: missing positioning, missing metrics dir, metrics CSV missing required columns. Fix and re-run.

---

## Stage 5, Influencer-fit (biweekly)

**Cadence**: every other Monday, after Stage 4.

**Trigger**: a curated influencer roster lives at `clients/<client>/social/influencers.yaml`. The operator updates the roster as new candidates enter the pipeline; the routine re-scores on a 14-day rhythm so a stale roster does not bend the ranking.

**Run**:

```bash
substrate influencer-fit-score --client <client> \
  --audience-overlap-csv clients/<client>/social/closed-won-contacts.csv
```

**What it does**: scores each influencer across five dimensions (ICP fit, audience overlap, voice alignment, topic alignment, prior relationship). Hard-disqualifies on brand-safety flags, kill-list voice, anti-ICP audience, or active competitor collaboration. Assigns a tier (1A primary partner, 1B exploratory, 2 watch, defer). Writes a ranked report.

**Output**: `clients/<client>/social/influencer-rankings/<YYYY-MM-DD>.md`.

**Refusal triggers**: missing positioning, missing brand voice, missing roster. Fix and re-run.

**Distribution note**: per `pat_creator-not-corporate`, tier-1A partnerships compound on personal-account collaborations. The corporate-handle path runs at structurally lower reach and is reserved for announcement co-branding.

---

## Stage 6, Operator review and ship

**Cadence**: every day during the week, in 30-minute writing-and-shipping blocks.

**Trigger**: drafts and tests from Stages 2-3 plus the weekly cadence target.

**What happens**: the operator (or named writers in a multi-operator program) walks the draft queue, picks the variant to ship, schedules it through the platform of choice. Substrate does not auto-publish; this is human-judgement work.

**Cadence target**: 4-6 personal-account posts per week per active operator is the sustainable B2B cadence (per `pat_creator-not-corporate`). 1-2 corporate-handle announcements per week is the upper bound. Falling below cadence target for three consecutive weeks is a separate signal (production gap) that needs a writing-capacity conversation, not a content-strategy conversation.

**Output**: shipped posts on the platforms; metric updates land in `clients/<client>/social/metrics/` by next Monday's Stage 4.

---

## Stage 7, Goal close-loop

**Cadence**: when a tested variant or measured collaboration resolves against its baseline (typically 14-30 days post-ship).

**Trigger**: prior tested variant or partnership had a tracked goal (an entry on `goals/ledger.md`) with a predicted lift.

**Run**:

```bash
substrate score-goal --goal-id <goal-id>
```

The Brier score updates the operator's calibration on the `social-distribution` taste type. Repeated wins on a hook pattern, platform, or cohort feed back into the brief queue priority for the next cycle.

---

## Pattern grounding

This routine operationalises:

- `knowledge/patterns/native-format-beats-cross-post.md`. The Stage 2 per-platform draft discipline and the Stage 6 cadence-per-platform target follow this pattern's implication directly. Cross-posting is refused; native authoring is the work.
- `knowledge/patterns/creator-not-corporate.md`. The default `--author personal`, the personal-vs-corporate gap reporting in Stage 4, and the personal-led influencer ranking in Stage 5 follow this pattern. The corporate handle is announcement surface; the personal account is growth surface.
- `knowledge/patterns/social-as-distribution-not-conversion.md`. The Stage 4 cohort-level metric framing and the Stage 7 goal-resolution discipline (track branded-search lift, audience-overlap-with-closed-won, newsletter signups) follow this pattern. Last-click CAC is structurally undercount; the routine refuses to fund the social program against it.

---

## Common failure modes

1. **Operator skips Stage 1 and writes from a stale theme bank.** Drafts feel disconnected from the cohort's current frictions; engagement decays in 4-6 weeks. Fix: run `social-listening-themes` weekly even when the export is small.
2. **Operator cross-posts the LinkedIn long-form to X verbatim.** Per `pat_native-format-beats-cross-post`, the LinkedIn opener length and line break density do not map to X. Fix: rewrite for the surface; the rewrite is the work.
3. **Operator measures on aggregate impressions and misses the per-platform decay.** A "social media performance" dashboard hides per-platform decay. Fix: run `social-fatigue-monitor` per platform; track per-platform engagement rate separately.
4. **Operator funds the corporate handle on the same metrics as personal accounts.** Per `pat_creator-not-corporate`, the corporate handle is structurally a lower-reach surface; measuring it on the same growth metrics produces misallocation. Fix: define the corporate handle's role narrowly (announcements) and measure it against announcement metrics only.
5. **Operator opens a goal with a last-click CAC target.** Per `pat_social-as-distribution-not-conversion`, the channel is undercount on last-click. The goal will resolve below target even when the channel is doing real work. Fix: predict cohort metrics (branded search lift, audience overlap), not last-click conversions.

---

## What this routine is not

- Not an attribution audit. That is `ad-attribution-honest` (composes with `pre-publish-check` for any asset that cites channel performance).
- Not a brand-safety review. That is the operator's editorial judgement; the influencer-fit-score surfaces flags but does not adjudicate.
- Not a paid-social budget routine. Paid social belongs to `routines/ad-fatigue-routine.md` and `routines/ad-allocation-routine.md`; this routine handles the organic-and-creator-led layer.
- Not a content production tool. Substrate refuses bad input; it does not generate finished posts. The operator (or a downstream LLM call) writes the final body inside the substrate scaffold.

---

## See also

- `skills/social-content-design/SKILL.md`
- `skills/social-fatigue-monitor/SKILL.md`
- `skills/social-amplification-test/SKILL.md`
- `skills/social-listening-themes/SKILL.md`
- `skills/influencer-fit-score/SKILL.md`
- `routines/social-fatigue-check.md`
- `knowledge/patterns/native-format-beats-cross-post.md`
- `knowledge/patterns/creator-not-corporate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
- `templates/social-calendar-example.yaml`
- `templates/social-mentions-example.csv`
- `templates/social-influencers-example.yaml`
