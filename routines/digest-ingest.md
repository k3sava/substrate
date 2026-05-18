---
title: digest-ingest, daily research digest ingestion
status: active
last_updated: 2026-05-07
schedule: daily 06:30 local
runner: bin/substrate-ingest-digests
output: knowledge/learnings/
---

# digest-ingest routine

The self-evolution loop. Reads daily research digests produced by an upstream pipeline. Extracts the items that should change Substrate. Files proposals for human approval.

## Why this exists

Substrate works because the principles are slow and the skills are sharp. Both decay if nobody updates them. The digest-ingest routine closes that loop without anyone needing to remember.

The upstream pipeline (the team's own daily research routine, swap in any digest source) reads sources, runs sandboxes, drafts artifacts, and writes a daily markdown brief. The brief contains items tagged for which downstream systems they affect: Substrate, the team's portfolio, related projects.

Substrate ingests the items tagged for it.

## Contract

A digest is a markdown file at `${SUBSTRATE_DIGEST_DIR}/YYYY-MM-DD.md`. The format is left to the upstream pipeline. The minimum Substrate needs is:

- One file per date, dated `YYYY-MM-DD.md`.
- Markdown, freeform. Sections, headings, bullets, whatever the upstream operator finds readable.
- Items affecting Substrate carry one of these signals (any are accepted):
  - An italic sentence ending in `Slot into substrate as <path>`.
  - A label like `apply-to: substrate` on a separate line.
  - A frontmatter `apply_to:` array including `substrate`.

The runner is liberal in what it accepts; the LLM extract step handles ambiguity.

## How the runner works

```
bin/substrate-ingest-digests [--since YYYY-MM-DD] [--source <dir>] [--dry-run]
```

Steps:

1. Resolve `$SUBSTRATE_DIGEST_DIR` (or `--source` flag). Default: `${SUBSTRATE_ROOT}/digest-source/` (a sibling repo or symlink).
2. List digest files newer than `--since` (default: last successful run).
3. For each new file:
   - Copy verbatim to `knowledge/learnings/raw/YYYY-MM-DD.md`.
   - Run the extract prompt (`templates/digest-extract-prompt.md`) against the digest using the configured LLM (Claude Haiku tier, cheap, fast, sufficient).
   - Write the structured extraction to `knowledge/learnings/YYYY-MM-DD.md`.
   - For each high-confidence proposal in the extraction, write `knowledge/learnings/proposals/YYYY-MM-DD-<slug>.md`.
4. Update `knowledge/learnings/.last-run.json` with the latest processed date.
5. Print a one-line summary to stdout.

## What's high-confidence

A proposal is filed (vs. just listed in the day's summary) when:

- The digest names a specific Substrate file (`skills/<name>/SKILL.md`, `PRINCIPLES.md` §<section>, `knowledge/<topic>.md`) **and**
- The change is concrete: add a refusal pattern, tighten a kill-list entry, add a persona fragment, deprecate a skill, etc. **and**
- The digest cites a source (URL, person, prior artifact) the operator can verify.

Vague items ("Substrate should think about X") land in the day's summary but never become proposals.

## Auto-skill-proposal (v1.2)

When a digest surfaces a new codex pattern that lands at `knowledge/patterns/<slug>.md`, the runner does an additional check before filing it as a knowledge addition:

1. **Hook scan.** Grep every `skills/*/SKILL.md` for `patterns_grounded:` containing `<slug>`. Result: a list of skills already operationalising this pattern.
2. **If zero hooks**, the runner files an extra proposal: `knowledge/learnings/proposals/<date>-skill-proposal-<slug>.md`. This proposal contains:
   - The pattern's claim and operator citations.
   - A draft `SKILL.md` skeleton (name, description guesses, substrate_layers_required guesses, the obvious `patterns_grounded: [<slug>]`, a refusal-pattern starter).
   - A note: "no existing skill operationalises this pattern. Either accept this proposal to scaffold a new skill, or update an existing skill's `patterns_grounded` to claim it."
3. **If hooks exist**, the runner adds a one-liner in the day's summary noting which skills already cover the new pattern.

This closes Rule 9 from the other side: not just *every skill grounds in a pattern*, but *every pattern has a skill, or a proposal for one*.

The auto-proposal is opt-in. The operator can disable it with `--no-skill-proposals` on the runner.

## Approval model

The runner never modifies `skills/`, `PRINCIPLES.md`, or `knowledge/patterns/`, or `knowledge/contradictions/` directly. Proposals are written to `learnings/proposals/`. The operator reviews, accepts, and runs `bin/substrate accept-proposal <id>` to merge.

Auto-merge is reserved for two cases:
1. Pure additions to `knowledge/learnings/raw/` and `knowledge/learnings/<date>.md`. Those are append-only logs, no risk of overriding sharper rules.
2. New `knowledge/patterns/<slug>.md` files where the digest contains a complete pattern doc (claim, operators ≥3, mechanism, conditions, sources). The pattern adds itself to `knowledge/patterns/INDEX.md` under "Other convergent patterns" with substrate hooks marked `(none yet, see proposals/)`. A skill proposal is filed alongside per the rule above.

## Failure modes

- **Upstream digest format drifts.** The extract prompt is conservative; if it can't find apply-to-substrate signals, it writes `(no substrate-applicable items)` and exits 0. No false-positive merges.
- **LLM fails.** The runner exits 1, the cron job logs to `logs/digest-ingest.log`, and the next morning's run picks up where this one stopped.
- **Two days of digests build up.** The runner processes them in date order. No coalescing, each day gets its own structured extraction.

## Setup

```bash
# 1. Point Substrate at the digest source
export SUBSTRATE_DIGEST_DIR=~/path/to/your/research-digests

# 2. Set the API key for the LLM tier you're using (Anthropic example)
export ANTHROPIC_API_KEY=sk-ant-...

# 3. Run once manually
bin/substrate-ingest-digests --dry-run

# 4. When happy, schedule it
# launchd (macOS):
ln -s "$PWD/launchd/com.substrate.digest-ingest.plist" ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.substrate.digest-ingest.plist

# Or cron:
# 30 6 * * * /usr/bin/env -i HOME=$HOME PATH=/usr/bin:/usr/local/bin bash -lc 'cd ~/path/to/substrate && bin/substrate-ingest-digests'
```

## Why this isn't a hard dependency

Substrate works without digest-ingest running. The routine is opt-in. If you don't have a research digest pipeline (or you don't want one feeding Substrate), the system functions normally. You'd just be doing the manual update work yourself, and the question is whether that's worth automating for your throughput.
