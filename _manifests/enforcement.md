---
title: Enforcement (Gates 7 + 8) — agent/enforcement branch manifest
status: active
last_updated: 2026-05-08
branch: agent/enforcement
---

# enforcement.md

Manifest for the behavioral-grounding enforcement work on the `agent/enforcement` branch. Closes the gap between Rule 9's *declarative* grounding (frontmatter lists patterns + contradictions) and *behavioral* grounding (the produced asset evidences the patterns and names the conditioned position on each contradiction).

## What this work added

A pair of new pre-publish gates, two new library files, two new tests fixtures, and a Rule 9a addition to PRINCIPLES.md.

## Files added

| Path | Purpose |
|---|---|
| `bin/lib/skill-pattern-check.sh` | Gate 7 library. Hand-tuned behavioral signature per pattern + structural diagnose-before-plan check + the public `pattern_extract_signature`, `pattern_check_applied`, `pattern_check_all` entry points. |
| `bin/lib/skill-contradiction-check.sh` | Gate 8 library. Verifies the asset names the picked position AND ties the pick to a conditioning fact via frontmatter, inline tag, or `## Contradiction navigation` section. Public `contradiction_check_position` + `contradiction_check_all`. |
| `tests/pattern-check/run.sh` | 17-assertion test runner exercising both libraries plus the integration through `pre-publish-check/bin/preflight`. Pass on every assertion. |
| `tests/pattern-check/fixtures/pass-diagnose-before-execute.md` | Passes Gate 7 against `frontline-contact` (evidences all three grounded patterns; structural Diagnosis-before-Plan present). |
| `tests/pattern-check/fixtures/fail-diagnose-before-execute.md` | Fails Gate 7: skips Diagnosis section, no frontline cues, no rapport cues. |
| `tests/pattern-check/fixtures/pass-no-decision-position.md` | Passes Gate 8 for `status-quo-frame` (frontmatter `contradiction_positions: A` + `position_rationale` with conditioning evidence + body inline `[contradiction:...] picked Position A because`). |
| `tests/pattern-check/fixtures/fail-no-decision-position.md` | Fails Gate 8: contradiction is not addressed at all. |
| `tests/pattern-check/fixtures/fail-no-decision-no-rationale.md` | Fails Gate 8 with the unconditioned variant: position named, no conditioning rationale. |
| `tests/pattern-check/fixtures/no-produced-by.md` | Verifies Gate 7 + 8 skip when `produced_by` frontmatter is absent. |
| `_manifests/enforcement.md` | This file. |

## Files modified

| Path | Change |
|---|---|
| `skills/pre-publish-check/bin/preflight` | Added Gate 7 (pattern-applied) and Gate 8 (contradiction-position-logged). Both fire only when asset frontmatter has `produced_by: <skill>`. Gate 7 soft-fails by default; flips to hard-fail under `STRICT_PATTERN_CHECK=1` or `enforce_patterns: true` in the named skill. Gate 8 always hard-fails. |
| `PRINCIPLES.md` | Added Rule 9a (Patterns and contradictions are behaviorally enforced) under Rule 9. Updated the ship-this-draft decision routing to count Gates 7 + 8. |
| `knowledge/patterns/INDEX.md` | Added "Behavioral signature" line to How-to-read. Appended a `## Behavioral signatures (Gate 7 catalog)` section listing the load-bearing cue per pattern (39 entries). |

## How it works (one paragraph)

When an asset reaches `pre-publish-check`, the preflight script reads `produced_by:` from the asset's frontmatter. If present, it sources `bin/lib/skill-pattern-check.sh` and runs `pattern_check_all` for each pattern in the named skill's `patterns_grounded`. Each pattern has a hand-tuned regex / phrase signature in `pattern_signature_for()`, calibrated against the language operators actually use when applying the pattern. `diagnose-before-execute` also accepts a structural signal: a Diagnosis/Audit section before any Plan/Recommendation section. Then it sources `bin/lib/skill-contradiction-check.sh` and runs `contradiction_check_all` for each entry in `contradictions_aware`. The asset must name the picked position (via frontmatter, inline `[contradiction:...]` tag, or section header) AND tie the pick to a conditioning fact (because / since / given / due to / —). Pattern grounding is soft-fail by default to preserve momentum; contradiction-conditioning is hard-fail because picking by accident is the bug Rule 9 was written to prevent.

## Calibration

- Each of the 39 patterns has a hand-tuned signature in `pattern_signature_for()`.
- Self-match coverage: 39/39 (each pattern's signature hits at least one fragment in its own body).
- Cross-pattern false positives in pattern bodies: tolerated. Pattern bodies aren't assets that go through preflight; the Gate 7 check fires only on `produced_by` assets, so cross-matches between patterns themselves don't degrade asset-side accuracy.
- Asset-side false positives validated against deliberately casual mentions ("we had a quick diagnostic chat") — the signature is sharp enough to refuse those.

## Run the tests

```
bash tests/pattern-check/run.sh
```

Expected: `passes: 17, fails: 0, all tests passed.`

## Non-scope

- FLYWHEEL_ROOT (Agent A's territory) was not modified.
- No new skills, patterns, or contradictions were added beyond test fixtures.
- Other skills' bin runtimes were not modified — only the preflight composite gate.
