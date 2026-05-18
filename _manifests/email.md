---
asset_type: manifest
manifest: email surface
authored_by: agent/email
authored_date: 2026-05-08
branch: agent/email
---

# Email surface manifest

The email surface adds 5 skills, 4 patterns, 2 routines, and 3 template fixtures to substrate. Every skill grounds in at least one new pattern, refuses on substrate gaps, composes voice-enforce on customer-facing output, and uses real substrate (DNS lookups, CSV parsing, metric math).

## Skills (5)

- `skills/email-sequence-design/SKILL.md` — frontmatter + body for the sequence-design skill (cohort-grounded multi-step lifecycle/nurture/re-engagement design).
- `skills/email-sequence-design/bin/email-sequence-design` — runtime: validates cohort and trigger, writes one README plus N step files under `clients/<client>/email/sequences/<id>/`, composes voice-enforce on every body.
- `skills/email-deliverability-audit/SKILL.md` — frontmatter + body for the domain-side deliverability audit skill.
- `skills/email-deliverability-audit/bin/email-deliverability-audit` — runtime: real `dig` lookups for SPF/DKIM/DMARC across the domain and any subdomains, parses records for known failure modes (lookup overflow, weak qualifiers, missing reporting, key length), optional send-log CSV cross-reference against Gmail Postmaster thresholds, severity-tiered findings report.
- `skills/email-list-hygiene/SKILL.md` — frontmatter + body for the list-hygiene skill.
- `skills/email-list-hygiene/bin/email-list-hygiene` — runtime: real CSV parsing in Python, role-address regex, curated disposable-domain list, hard-bounce flagging, suspected spam-trap heuristic, TLD distribution analysis with single-provider risk flag, prune/suppression/re-engagement candidate CSVs and ICP-grounded segment recommendations.
- `skills/email-cohort-trigger/SKILL.md` — frontmatter + body for the cohort/trigger design skill.
- `skills/email-cohort-trigger/bin/email-cohort-trigger` — runtime: bootstraps `events.yaml` template, validates events-taxonomy schema and freshness, resolves a named cohort against the taxonomy, computes Levenshtein suggestions on miss, refuses broadcast triggers and stale events, emits target-tool-shaped specs (Customer.io, Iterable, webhook, generic) with smoke-test instructions.
- `skills/email-engagement-decay-watcher/SKILL.md` — frontmatter + body for the weekly decay watcher.
- `skills/email-engagement-decay-watcher/bin/email-engagement-decay-watcher` — runtime: reads weekly CSVs at `clients/<client>/email/metrics/`, computes 4-week-vs-prior-4-week lift on open/click/complaint/bounce rates, classifies decay shape (sudden cliff / gradual taper / step-down) with first-hypothesis routing per the engagement-decay pattern, severity-tiered digest, non-zero exit on critical alerts.

## Patterns (4)

- `knowledge/patterns/engagement-decay-as-relevance-signal.md` — Val Geisler, Brian Kotlyar, Jen Capstraw, mailbox-provider docs. Engagement decay points first at relevance, not deliverability. Order matters: segment before prune.
- `knowledge/patterns/sender-reputation-is-a-domain-asset.md` — Kath Pay, Mathew Sweezey, mailbox-provider docs, DMARC.org/RFC 7489. Domain reputation accrues over years; treat the sending domain as a multi-year brand asset, not a throwaway.
- `knowledge/patterns/one-segment-one-trigger.md` — Bob Moesta, Andy Crestodina, Val Geisler, Litmus/Klaviyo benchmarks. The smallest viable lifecycle unit is one cohort × one trigger; broadcast nurtures lose to behavioral triggers consistently.
- `knowledge/patterns/subject-line-as-experiment-not-art.md` — Joanna Wiebe, Val Geisler, Andy Crestodina. Subject lines are testable hypotheses about audience pain, mined from substrate, scoped to a cohort, with a statistical bar set before the test.

## Routines (2)

- `routines/email-decay-routine.md` — weekly cron description for `email-engagement-decay-watcher`. macOS LaunchAgent and Linux cron snippets included.
- `routines/email-deliverability-monthly.md` — monthly cron description for `email-deliverability-audit`. Same shape; first business day at 08:00 local.

## Templates / fixtures (3)

- `templates/subscriber-list-example.csv` — 93-row realistic subscriber CSV covering active/inactive/role-based/disposable/hard-bounce/spam-trap-suspect cohorts. Used for smoke-testing list hygiene and as a starter shape for operators.
- `templates/events-yaml-example.yaml` — starter events taxonomy with 8 events and 4 cohorts mapped to ICP cells. Operator copies into `clients/<client>/events.yaml` and edits.
- `templates/email-sequence-example/welcome-onboarding/` — worked example sequence (README + 5 step files) showing the shape `email-sequence-design` produces. Files: `README.md`, `step-01.md` through `step-05.md`.

## Manifest itself

- `_manifests/email.md` — this file.

## Composition shape

The skills compose linearly across the email lifecycle:

1. `email-cohort-trigger --mode bootstrap` writes `events.yaml`.
2. Operator edits `events.yaml` to match real events.
3. `email-cohort-trigger --mode design` produces the trigger spec for the email tool.
4. `email-sequence-design` writes the sequence directory; every body passes through `voice-enforce`.
5. `email-list-hygiene` runs before major sends to prune and segment.
6. `email-deliverability-audit` runs monthly to defend the sending domain.
7. `email-engagement-decay-watcher` runs weekly; gradual tapers route back to step 3 (relevance), sudden cliffs route to step 6 (deliverability).

## Anti-fabrication notes

- Every operator citation in the patterns references a real, verifiable position (Val Geisler at Klaviyo, Kath Pay at Holistic Email Marketing, Bob Moesta's JTBD work, etc.). Where a specific quote could not be verified, the citation paraphrases the operator's documented body of work.
- Every claim about mailbox-provider thresholds (Gmail bounce/complaint warnings, DMARC alignment behavior, DKIM key length recommendations) cites the public documentation it derives from (Gmail Postmaster, RFC 7489, RFC 7208, M3AAWG BCP).
- Every skill cites its substrate dependencies in `required_reads` and `substrate_layers_required`. Refusal patterns trigger when those dependencies are missing or stale.

## Voice notes

- No em-dashes in body copy across patterns, routines, or SKILL.md bodies (verified by lint pass).
- No kill-list words (`orchestration`, `seamless`, `strategic`, `leverage`, `transform`, `holistic`, `synergy`, `bespoke`, `unlock`, `robust`, `sophisticated`, `comprehensive`) in body copy.
- All body uses `SUBSTRATE_ROOT` for environment-variable references; `FLYWHEEL_ROOT` is preserved only at the bin-script entry point as a backward-compat fallback (`SUBSTRATE_ROOT="${SUBSTRATE_ROOT:-${FLYWHEEL_ROOT:-...}}"`).

## Smoke-test summary (run during development on a temp `test-email` client; no committed fixtures)

- `email-deliverability-audit --domain google.com` resolved live DNS, found 1 high (no DKIM probed) + 1 medium (DMARC missing sp=). PASS.
- `email-list-hygiene --list templates/subscriber-list-example.csv` parsed 93 rows, classified 11 prune / 13 suppression / 7 re-engagement / 62 active. Disposable-domain detection caught 4 mailinator/guerrilla addresses. PASS.
- `email-cohort-trigger --mode bootstrap` wrote a 70-line events.yaml template; `--mode design --target-tool customer-io` validated the cohort and emitted a Customer.io spec. PASS.
- `email-sequence-design --purpose onboarding --steps 5` wrote README + 5 step files; every body composed `voice-enforce` and passed. PASS.
- `email-engagement-decay-watcher` against synthetic 8-week metrics for two sequences flagged the decaying one as critical (gradual-taper, -67.7% open-rate lift), recommended `email-cohort-trigger or email-sequence-design`. PASS.

## Files added or modified

```
_manifests/email.md
knowledge/patterns/engagement-decay-as-relevance-signal.md
knowledge/patterns/one-segment-one-trigger.md
knowledge/patterns/sender-reputation-is-a-domain-asset.md
knowledge/patterns/subject-line-as-experiment-not-art.md
routines/email-decay-routine.md
routines/email-deliverability-monthly.md
skills/email-cohort-trigger/SKILL.md
skills/email-cohort-trigger/bin/email-cohort-trigger
skills/email-deliverability-audit/SKILL.md
skills/email-deliverability-audit/bin/email-deliverability-audit
skills/email-engagement-decay-watcher/SKILL.md
skills/email-engagement-decay-watcher/bin/email-engagement-decay-watcher
skills/email-list-hygiene/SKILL.md
skills/email-list-hygiene/bin/email-list-hygiene
skills/email-sequence-design/SKILL.md
skills/email-sequence-design/bin/email-sequence-design
templates/email-sequence-example/welcome-onboarding/README.md
templates/email-sequence-example/welcome-onboarding/step-01.md
templates/email-sequence-example/welcome-onboarding/step-02.md
templates/email-sequence-example/welcome-onboarding/step-03.md
templates/email-sequence-example/welcome-onboarding/step-04.md
templates/email-sequence-example/welcome-onboarding/step-05.md
templates/events-yaml-example.yaml
templates/subscriber-list-example.csv
```

24 files added; no existing files modified.
