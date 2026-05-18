---
name: competitive-scout
description: Weekly automated competitive monitoring. Checks per-client competitors for pricing changes, product launches, new comparison pages, and G2 review shifts. Writes signals to inbox for human approval before any substrate patch.
version: 0.2
status: active
wired: true
created: 2026-05-01
substrate_layers_required: [competitive]
consumed_by: signal-loop, signal-analyst, refresh-knowledge
launchagent: com.substrate.competitive-scout
schedule: weekly — Monday 08:00 IST (02:30 UTC)
---

# competitive-scout

## Purpose

Run weekly Exa searches against each tracked competitor. Detect: pricing changes, new product launches, new comparison pages, G2 review shifts. Write signal YAML files into `clients/<client>/signals/inbox/` for signal-analyst to process. No substrate changes happen without human approval.

## Inputs

```
substrate competitive-scout --client <client> [--tier T1|T2|T3|T4|all] [--competitor <slug>] [--dry-run] [--force]
```

- `--client` is required. There is no default; the registry is per-client.
- `--tier` defaults to `T1` (highest-priority displacement targets).
- `--dry-run` prints signals without writing to inbox.

## Competitor registry (per-client)

The list of competitors lives at `clients/<client>/competitors.yaml`. Schema is in `templates/competitors-example.yaml`. The skill refuses if the file is missing — generic registries cause every operator's competitive analysis to inherit someone else's defaults.

Each entry declares its tier, decay thresholds, display name, and aliases (which the pre-publish-check gate uses for filename detection on displacement LPs).

## Process

1. Read `clients/<client>/competitors.yaml` and resolve the tier filter.
2. For each competitor in scope, read `clients/<client>/substrate/competitive-data-bank/<slug>-*.md` and check the `Last verified` date.
3. For each competitor past decay threshold:
   - Search Exa for: pricing, vs-brand, new features, G2 reviews, alternative pages.
   - Capture significant findings (last 90 days only).
4. For each meaningful finding, write a signal YAML to `clients/<client>/signals/inbox/`.
5. Write a scout-run summary to `knowledge/intel/competitive-scout-<client>-<date>.md`.
6. Commit signals to git for signal-analyst to process.

## Signal types written

| Finding | Signal type | Target layer |
|---|---|---|
| Pricing change | competitive | competitive.md |
| New feature launch | competitive | competitive.md + product-knowledge |
| New comparison/vs page | competitive | competitive.md |
| G2 score shift (>0.2 pts) | competitive | competitive.md + voc |
| Rebrand | competitive | competitive.md (all references) |

## Output

- Signal YAML files in `clients/<client>/signals/inbox/`
- Scout run summary: `knowledge/intel/competitive-scout-<client>-<date>.md`

## Decay thresholds

Defaults (overridable in `competitors.yaml` `defaults:` block):

| Tier | Pricing decay | Features decay |
|---|---|---|
| T1 | 30 days | 60 days |
| T2 | 30 days | 90 days |
| T3 | 60 days | 90 days |
| T4 | 30 days | 90 days |

Per-competitor blocks may override `pricing_decay_days` and `features_decay_days` directly.

## Gates

- Refuses with exit code 3 if `clients/<client>/competitors.yaml` is missing or empty.
- Refuses if `--client` is not set and `SUBSTRATE_CLIENT` is not in the environment.
- Does NOT update substrate directly. Signal → proposal → human approval → patch.
- Dry-run mode available for testing without writing signals.

## Refusal pattern

Refuses to:
- Run without a per-client competitors.yaml (no shipped defaults).
- Write a signal that contradicts substrate without a live-verified source URL + retrieval date.
- Merge signals directly into competitive.md (human gate required).
- Mark a competitor as "no pricing change" without a successful retrieval.
