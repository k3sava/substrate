---
title: portability manifest
agent: agent/portability
date: 2026-05-08
scope: make substrate's runtime portable; strip client-specific/flywheel hardcodes
---

# portability manifest

Every file added or modified on the `agent/portability` branch, with a one-sentence purpose.

## Top-level

- `README.md` — quick-start now points at the templates the bootstrap copies in, drops the duplicate `cp templates/...` step.
- `_manifests/portability.md` — this file.

## bin/ (dispatcher + companion CLIs)

- `bin/substrate` — adds the FLYWHEEL_ROOT → SUBSTRATE_ROOT deprecation alias, exposes the BRIEF.md gate against the resolved `--client` slug, falls back to `sample-client` with a warning when no client is set.
- `bin/lib/skill-preflight.sh` — same deprecation alias, exports both names for one release cycle.
- `bin/substrate-bootstrap-prospect` — pre-seeds `competitors.yaml` and `verticals.yaml` from `templates/` so a freshly bootstrapped client can run gated skills immediately.
- `bin/substrate-status` — adds the deprecation alias and the `--client` flag.
- `bin/substrate-dashboard` — renames the script identity from `flywheel-dashboard`, swaps the hardcoded Vercel URL for a `DASHBOARD_URL` env var.
- `bin/heartbeat-tick` — same deprecation alias; the prompt and lock paths now reference substrate.
- `bin/init-calibration-db` — accepts SUBSTRATE_ROOT in front of the FLYWHEEL_ROOT fallback.
- `bin/refresh-leaderboard` — same precedence; LaunchAgent comment generalized.
- `bin/score-calibration` — primary env var is now SUBSTRATE_ROOT.
- `bin/bet` — collapsed to a deprecation shim that maps the old `bet` verbs onto current `substrate` skills and exits 64.

## skills/ (37 wired runtimes)

### Hardcode strip (the architectural work)

- `skills/competitive-scout/bin/competitive-scout` — competitor matrix moved out of code; the skill now reads `clients/<client>/competitors.yaml`, refuses cleanly if missing, and surfaces the brand from BRIEF.md.
- `skills/competitive-scout/SKILL.md` — schema, refusal pattern, and decay table all reference the per-client YAML.
- `skills/pre-publish-check/bin/preflight` — competitor and vertical aliases for LP page-type detection now read from `clients/<client>/competitors.yaml` + `verticals.yaml`; defaults to `lead-capture` when neither file exists, no failure.
- `skills/pre-publish-check/SKILL.md` — substrate layers listed by name, generic operator language.
- `skills/aeo-tune/bin/aeo-relevance-engineering` — vertical taxonomy moved out of code; the gate reads `clients/<client>/verticals.yaml` aliases (plus the `horizontal` slug), refuses with a fix message if missing, and falls through to the generic `pre-publish-check` runtime when the legacy `skills/preflight/` path is absent.
- `skills/aeo-tune/SKILL.md` — vertical input documented as a substrate-loaded slug, not a fixed enum.
- `skills/lp-ship/bin/lp-ship` — composite-gate path falls through `pre-publish-check` then `preflight` so external installs that pinned the legacy path still work.
- `skills/lp-ship/SKILL.md` — client-specific-specific notes generalized; per-client substrate paths cited.

### De-vendor / generic-language pass

- `skills/positioning-forge/SKILL.md` — required-reads reference most-recent canonical-statement, layers listed by name.
- `skills/voice-enforce/bin/voice-enforce` — comment renamed to "substrate's own infrastructure docs"; deprecation alias added.
- `skills/voice-enforce/SKILL.md` — kill-list source pointed at `clients/<client>/brand-voice/kill-list.md` + `knowledge/voice/how-we-write.md`.
- `skills/humanizer/SKILL.md` — client-specific-specific voice canon replaced with substrate default + per-client override path.
- `skills/humanizer/bin/humanizer` — header comment lists substrate's actual rule packs, not the client-specific-named ones.
- `skills/audience-test/SKILL.md` — displacement panel sourced from `clients/<client>/competitors.yaml`; vertical slugs come from `verticals.yaml`; refusal-pattern doc generalized.
- `skills/audience-test/run.sh` — `--personas` doc generalized; example slugs replaced with `<slug>` placeholders.
- `skills/audience-test/test-fixtures/good.md` — fixture text now generic.
- `skills/audience-test/bin/synthetic-audience-test` — deprecation alias.
- `skills/claim-verify/SKILL.md` — failure-mode example written without a named competitor.
- `skills/claim-verify/bin/claim-verify` — deprecation alias.
- `skills/pre-publish-check/SKILL.md` — client-specific-specific master removed.

### Deprecation alias on every skill runtime (37 files)

Every skill's `bin/` runtime accepts `${SUBSTRATE_ROOT:-${FLYWHEEL_ROOT:-derived}}` and prints a one-line deprecation notice when only the old name is set. Files modified for this pass:

```
skills/aeo-manual-action/bin/aeo-manual-action
skills/aeo-relevance/bin/aeo-relevance
skills/aeo-tune/bin/aeo-relevance-engineering
skills/agent-jtbd-map/bin/agent-jtbd-map
skills/audience-test/bin/synthetic-audience-test
skills/audience-test/run.sh
skills/campaign-strategy/bin/campaign-strategy
skills/capability-pin/bin/capability-pin
skills/claim-verify/bin/claim-verify
skills/competitive-scout/bin/competitive-scout
skills/consulting-poc/bin/consulting-poc
skills/context-curate/bin/context-curate
skills/design-principles/bin/design-principles
skills/design-thinking-content/bin/design-thinking-content
skills/dunford-value-frame/bin/dunford-value-frame
skills/eval-rubric/bin/eval-rubric
skills/frontline-contact/bin/frontline-contact
skills/help-docs/bin/help-docs
skills/humanizer/bin/humanizer
skills/icp-cut/bin/icp-cut
skills/launch-plan/bin/launch-plan
skills/lp-cro-rubric/bin/lp-cro-rubric
skills/lp-ship/bin/lp-ship
skills/mental-models/bin/mental-models
skills/messaging-matrix/bin/messaging-matrix
skills/narrative-compose/bin/narrative-compose
skills/narrative-compose/bin/narrative-check
skills/narrative-strategy/bin/narrative-strategy
skills/open-goal/bin/bet-open
skills/pmm-coaching/bin/pmm-coaching
skills/positioning-forge/bin/positioning-forge
skills/pre-publish-check/bin/preflight
skills/pricing-strategic/bin/pricing-strategic
skills/pseo-framework/bin/pseo-framework
skills/refresh-knowledge/bin/substrate-curate
skills/score-goal/bin/bet-resolve
skills/status-quo-frame/bin/status-quo-frame
skills/tactical-empathy-discovery/bin/tactical-empathy-discovery
skills/voice-enforce/bin/voice-enforce
skills/win-loss-interview/bin/win-loss-interview
```

## routines/

- `routines/competitive-scout/scout.sh` — full rewrite: discovers every `clients/<slug>/competitors.yaml` automatically, runs the per-client scout under the substrate dispatcher, exits cleanly when no clients are configured.
- `routines/brief-freshness/check.py` — accepts SUBSTRATE_ROOT, defaults `--client` to `sample-client` instead of a hardcoded slug, writes the report under `knowledge/intel/`.
- `routines/quarterly-context-audit/audit.py` — same path correction; output lives under `knowledge/intel/`.
- `routines/aeo-routine.md` — `[Vendor]` placeholder replaced with "the client".
- `routines/narrative-drift-routine.md` — outputs land under `knowledge/intel/...` (existed; verified).

## knowledge/

- `knowledge/voice/copy-rules-source.md` — full de-vendor pass; renamed to "Substrate copy rules (generic)" with per-client override notes.

## templates/

- `templates/competitors-example.yaml` — schema + tier table + 5 example competitors.
- `templates/verticals-example.yaml` — schema for vertical slugs and aliases.
- (`templates/term-dictionary.yaml` — already generic, unchanged.)

## Test fixtures touched

- `skills/narrative-compose/test-fixtures/good.md` — generic narrative.
- `skills/narrative-compose/test-fixtures/no-cta.md` — generic narrative.
- `skills/audience-test/test-fixtures/good.md` — `[Vendor]` placeholder removed.

## Verified manually

- `bin/substrate --list` lists 37 wired skills cleanly under SUBSTRATE_ROOT.
- `bin/substrate --version` reports `substrate 1.2.0`.
- `bin/substrate positioning-forge --help` runs (gracefully refuses on a stub `sample-client` with the expected "substrate-gap" message).
- `bin/substrate competitive-scout --client sample-client --dry-run` runs end-to-end against the bootstrapped sample client.
- `bin/substrate competitive-scout --client nonexistent` refuses with exit 3 and the bootstrap hint.
- `bin/substrate pre-publish-check /tmp/test-asset.md --client sample-client` runs every gate (gates 1-7) and returns PASS.
- `FLYWHEEL_ROOT="$PWD" bin/substrate --version` prints the deprecation notice and still resolves correctly.
- `bin/substrate-bootstrap-prospect <slug>` produces a client tree that contains `competitors.yaml` and `verticals.yaml` pre-seeded from templates.
- `grep -r 'FLYWHEEL_ROOT' bin/ skills/ knowledge/ templates/` shows 47 hits, every one inside an explicit backwards-compat block or a documentation string.
