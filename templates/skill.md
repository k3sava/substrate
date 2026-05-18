---
name: <skill-slug>
description: <one-line description of what this skill does>
when_to_use: <signal that triggers this skill>
type: skill
last_updated: <YYYY-MM-DD>
---

# <Skill name>

## What this skill does

<One paragraph. What output the skill produces, when to call it, what it refuses.>

## Required reads (context)

The skill refuses to run if any of these are missing or past freshness window:

- `<project>/01-position.md` — for <reason>.
- `<project>/02-icp.md` — for <reason>.
- `<project>/<other-layer>.md` — for <reason>.

## Inputs

- `<arg 1>` — <description>.
- `<arg 2>` — <description>.

## Outputs

- <output artifact 1> at `<path>`.
- <output artifact 2> at `<path>`.

## When to refuse

The skill refuses if:

1. Required context is missing.
2. Required context is past its freshness window.
3. A load-bearing claim has no citation.
4. The draft contradicts the canonical position.
5. The draft over-claims relative to source strength.

## Override

A reviewer can override a refusal with a logged justification. Logged in `<project>/decision-log/<date>-<slug>.md`. Repeated overrides on the same gate trigger recalibration.

## Sample input

See `sample-input.md`.

## Sample output

See `sample-output.md`.

## Runtime

```bash
bin/substrate <skill-slug> <args>
```
