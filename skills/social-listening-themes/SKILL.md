---
name: social-listening-themes
description: Analyse mentions, comments, and reply-thread exports for themes. TF-IDF style cluster + manual taxonomy. Identify customer pain language, competitor mentions, viral hook patterns. Reads clients/<client>/social/mentions/<source>-<YYYY-MM>.csv. Real text-cluster math; not vibes.
version: 0.1
amplifies: social media lead, content marketer, PMM owning voice-of-customer
masters: Joanna Wiebe (Copyhackers message mining from real comments), Brendan Hufford (3S content sourced from frontline conversations), Brian Kotlyar (segment-specific language as the lever), Jasmin Alic (LinkedIn comment-thread mining)
substrate_layers_required: [positioning, icp, voc, competitive]
patterns_grounded: [native-format-beats-cross-post, social-as-distribution-not-conversion, frontline-as-pmm-substrate, copywriting-craft-fundamentals]
contradictions_aware: []
preflight_refusal: substrate-gap, missing-positioning, missing-mentions
required_reads:
  - clients/{client}/01-position.md
  - clients/{client}/02-icp.md
---

# social-listening-themes

## Purpose

Read mentions / comments / reply-thread exports across one or more sources (LinkedIn comments, X replies, Reddit threads, G2 reviews, podcast YouTube comments, etc.). Cluster the comment text via a TF-IDF-shaped weighting against an in-corpus token frequency baseline. Surface:

- **Pain themes** — clusters whose tokens overlap with the cohort's friction language.
- **Competitor mentions** — comments that name a competitor by slug; routed to `competitive-scout` if the brand is uncovered or the volume is rising.
- **Viral hook patterns** — comments that responded to specific hook angles in the source post; surfaced as raw inputs to the next `social-content-design` cycle.
- **Off-brand or trolling** — comments flagged for moderation, not for content mining.

The output is two artefacts: a clustered themes report and a comment-by-comment classified CSV the operator can act on.

The skill refuses without canonical positioning (the themes need an anchor to be sorted against) and without a mentions corpus. It does real cluster math; it does not generate vibes.

## Inputs

- `--client <client>` (required)
- `--mentions-dir <dir>` (optional, default `clients/<client>/social/mentions/`)
- `--source <slug>` (optional) — restrict to one source (e.g., `linkedin-comments`)
- `--cluster-min-size <int>` (default 3) — minimum cluster size; smaller clusters are aggregated as "long-tail"
- `--max-themes <int>` (default 8)
- `--out <dir>` (optional, default `clients/<client>/social/themes/`)

## Substrate reads

- `clients/<client>/01-position.md` — for anchor terms used in pain-theme overlap.
- `clients/<client>/02-icp.md` — for cohort labels.
- `clients/<client>/03-voice-of-customer.md` (optional) — to feed the existing voice-of-customer corpus into the overlap.
- `clients/<client>/04-competitive.md` (optional) — for competitor slug list used in mention detection.

## Mentions CSV shape

Required headers (case-insensitive): `comment_id`, `text`. Recommended: `source`, `posted_at`, `author`, `parent_post_id`, `parent_post_url`, `replies_count`, `likes_count`.

The shape is forgiving on optional columns. Empty `text` rows are skipped with a count in the report.

## Output contract

Writes two files:

```
clients/<client>/social/themes/<YYYY-MM-DD>-themes.md       # themes report
clients/<client>/social/themes/<YYYY-MM-DD>-classified.csv  # comment-level classification
```

Themes report frontmatter:

```yaml
---
themes_id: <client>-social-themes-<YYYY-MM-DD>
asset_type: audit
mentions_read: [<path>, ...]
comments_total: <int>
comments_classified: <int>
substrate_layers_read: [positioning, icp, voc, competitive]
patterns_applied: [native-format-beats-cross-post, social-as-distribution-not-conversion, frontline-as-pmm-substrate, copywriting-craft-fundamentals]
contradictions_resolved: []
themes_count: <int>
competitor_mention_count: <int>
viral_hook_count: <int>
produced_by: social-listening-themes
---
```

Body sections:

1. **Cluster summary** — N themes, each with size, top tokens, representative comments, suggested cohort fit.
2. **Pain language vs positioning anchors** — overlap matrix; which positioning anchors do or don't appear in the corpus.
3. **Competitor mentions** — count per competitor, top comments, source spread.
4. **Viral hook patterns** — comment threads that responded to specific hook structures; raw inputs for `social-content-design`.
5. **Off-brand / trolling** — flagged for moderation, not for content reuse.
6. **Frontline-as-substrate note** — per pat_frontline-as-pmm-substrate, the comment corpus is canonical PMM input; the themes here should feed positioning and message-house revisions.

The classified CSV adds these columns to the source rows: `theme_id`, `theme_label`, `competitor_mentioned`, `flag_reason`.

## Quality criteria

- Cluster math is real (TF-IDF-style weighting), not random.
- Every theme has at least 3 representative comments and a 3-5 word label.
- Competitor detection uses the substrate's competitive layer where present, plus a curated default list as fallback.
- Off-brand classification has explicit rules (link spam, slur tokens, off-topic), not heuristic vibes.
- Stop-word filtering is conservative (keeps "speed", "slow", "cheap", "expensive" — these are pain-language signals).

## What this skill does NOT do

- Does not pull mentions from APIs. CSV exports come from the operator or platform.
- Does not write replies. Use `social-content-design` for outgoing posts.
- Does not score sentiment beyond the off-brand flag. Sentiment scoring is downstream.
- Does not classify intent or buying-signal. Use `intent-data-route` for that.

## Refusal patterns

- Missing positioning returns `SUBSTRATE-GAP — missing-positioning`.
- Missing mentions dir or empty corpus returns `INPUT-GAP — missing-mentions`.
- Total comments < 30 returns `INPUT-WARN — corpus-too-small`; report continues but flags reliability.

## See also

- `social-content-design` — consumes the viral hook patterns this skill identifies.
- `social-fatigue-monitor` — the quantitative sibling; pair both biweekly.
- `competitive-scout` — receives competitor-mention spikes from this skill.
- `frontline-contact` — the upstream skill that captures sales/CS frontline conversations.
- `routines/social-content-cycle.md` — the cycle that consumes themes weekly.
- `knowledge/patterns/frontline-as-pmm-substrate.md`
- `knowledge/patterns/social-as-distribution-not-conversion.md`
- `knowledge/patterns/copywriting-craft-fundamentals.md`
