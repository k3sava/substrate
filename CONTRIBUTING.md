# Contributing to Substrate

Substrate is open source. Contributions are welcome from operators across PMM, sales, CS, product, and leadership.

## What kinds of contributions land

**Most welcome:**
- Skill modules, new gates, new refusal patterns, new compositions. Skills are the high-leverage surface.
- Persona fragments, additions to `personas/fragments/`, `personas/buyer-state/`, `personas/displacement/`, etc. The fragment architecture lets one persona compose across vertical, role, awareness state, and pricing tier.
- Routine workflows, recurring jobs (signal scouts, freshness checks, drift detectors).
- Knowledge layer, `knowledge/` entries that hold across clients (voice rules, evidence-ladder methodology, AEO/GEO methodology, displacement framing).
- Bug fixes, type-fixes, refusal-pattern hardening.
- Better dashboard / UX (the dashboard is currently a static generator; happy to take browser improvements).

**Less suitable:**
- Client-specific data. The whole architecture is built to keep client artifacts out of the public framework. If you have a client-specific layer that you want to share generalized, generalize it first.
- Skills that bypass the pre-publish-check gate.
- Voice changes that soften the operator-voice rules. The rules are deliberately strong; bring evidence if you want to relax them.

## Ground rules

1. **Anti-fabrication is non-negotiable.** Every claim cites a source. PRs that add unverified claims to `knowledge/` or `personas/` get rejected.
2. **Falsifiability over plausibility.** New skills must define what input they refuse and why. New goals (in template / example form) must include a measurement contract.
3. **Single-verb commands.** CLI surfaces stay small. `bin/substrate <skill>` is the dispatcher.
4. **Voice rules apply to docs too.** No em dashes in body copy, no kill-list words, no throat-clearing openers. PR descriptions can be relaxed; documentation can't.
5. **One change per PR.** A skill addition is one PR. A persona-fragment batch is one PR. A doc cleanup pass is one PR.

## Branch / commit conventions

```bash
# Feature
git checkout -b skill/<skill-name>
git checkout -b persona/<axis>-<slug>

# Fix
git checkout -b fix/<short-description>

# Docs
git checkout -b docs/<area>

# Knowledge
git checkout -b knowledge/<topic>
```

Commit messages: imperative mood, sentence case, no trailing period.

```
add skill/displacement-frame: gated displacement copy generator
fix skill/voice-enforce: kill-list collision on "leverage" inside quotes
docs/principles: clarify five-tier evidence ladder ordering
```

## How to add a skill

```bash
mkdir -p skills/<skill-name>
cd skills/<skill-name>

# Required:
# SKILL.md       : frontmatter (name, description, version, masters, substrate_layers_required, preflight_refusal, required_reads), purpose, inputs, outputs, gate, refusals
# test-fixtures/ : at least one good.md and one bad.md fixture
# (optional)     : runner.sh / runner.py / runner.mjs if the skill has executable logic
```

Required-reads must resolve. Refusal patterns must be testable. The skill must compose with `pre-publish-check`.

## How to add a persona

Personas live across 7 axes. Pick the right axis or argue for a new one in the PR.

```
personas/buyer-state/        # unaware / problem-aware / solution-aware / product-aware / most-aware
personas/displacement/        # who we win from
personas/fragments/           # role + function + seniority components
personas/g2-cohort/           # firmographic + cohort cuts
personas/internal-org/        # CXO panel, sales-leader, finance, etc.
personas/pricing-tier/        # by plan
personas/synthetic-audience/  # vertical + buyer-state combos
personas/vertical/            # by industry
```

A new persona file needs:
- Frontmatter: title, axis, slug, summary, substrate_grounded_by (the source corpus / public review patterns / methodology that makes it not-invented)
- Body: firmographics, voice signature, objection patterns, decision criteria, sample reactions

## Contributing patterns

Patterns live in `knowledge/patterns/<slug>.md`. They are codex-distilled claims that 3+ credible operators converge on. Skills cite patterns under `patterns_grounded`; the runtime feeds the pattern body to the model and (under Rule 9a) checks that the asset evidences it.

**Codex grounding rule.** A pattern PR needs three operator citations minimum. Each citation names the operator, links the source (article, podcast, talk, gist), and includes a verbatim or near-verbatim quote that supports the pattern's central claim. One operator's blog post is an observation; three operators converging on the same claim is a pattern. The PR description must list the three sources up top.

A new pattern file needs:

- Frontmatter: title, status (`active`), slug, type (`pattern`), tier (`A` | `B` | `C` per `knowledge/patterns/INDEX.md`), source-count, last_updated.
- Body sections: `## Claim` (one sentence), `## Evidence` (operator quotes with citations), `## Convergence` (where operators agree), `## Implication` (what this means for substrate), `## Behavioral signature` (the load-bearing phrase or structural element a Gate-7 check looks for).

**Behavioral signature requirement (Rule 9a).** Every new pattern PR must include a behavioral signature that Gate 9 can check. The signature is a regex / phrase / structural element drawn from the `## Implication` and `## Convergence` sections, calibrated against the language operators actually use when applying the pattern. The signature lives in two places: the pattern's own body (in `## Behavioral signature`), and the Gate 9 library (`bin/lib/skill-pattern-check.sh::pattern_signature_for()`).

Signature calibration:

- Self-match: the pattern's own body must hit at least one signature. Run `tests/pattern-check/run.sh` to verify.
- Asset-side false-positive check: ensure a casual mention ("we did a quick diagnostic chat") doesn't spuriously pass. The signature should be sharp enough to refuse asset-side handwaving.
- Skills declaring the new pattern in `patterns_grounded` get scanned by Gate 9 when their output assets reach `pre-publish-check`.

Soft-fail by default to preserve momentum; hard-fail under `STRICT_PATTERN_CHECK=1` or when a skill's `SKILL.md` carries `enforce_patterns: true`.

**Contributing contradictions.** Contradictions live in `knowledge/contradictions/<slug>.md`. They name a substantive question where credible operators disagree, plus the conditioning variables that decide which position applies in a given client context. A contradiction PR needs:

- Two named positions (A and B; sometimes A/B/C if the disagreement is multi-way), each with at least one operator citation.
- A `## Conditioning` section naming the variables (firm size, ICP fit, market maturity, etc.) that make Position A right in one context and Position B right in another.
- Skills declaring `contradictions_aware: <slug>` must (per Gate 10, hard-fail) name the picked position AND cite the conditioning evidence in the produced asset.

## Contributing routines

Routines live in `routines/`. Two flavors: end-to-end orchestrations (compose multiple skills into a named cycle) and single-purpose loops (a recurring sub-cadence). Both follow the same schema:

- Frontmatter: title, status, last_updated, cadence, owner, patterns_grounded (any patterns the routine operationalises), contradictions_aware (any contradictions the routine resolves), composes (skills + sub-routines).
- Body sections: `## Why this exists`, `## Stages`, `## Skills it composes`, `## Inputs required`, `## Outputs produced`, `## Failure modes`, `## Calibration hooks`, `## Composes with`, `## See also`.

Orchestrations declare cadence (one-time, weekly, monthly, quarterly, per-launch). Loops declare cadence (continuous, weekly, monthly) and the data they produce.

## Code of conduct

Be direct. Be operator-grade. Disagree with the work, not the person. If a claim doesn't cite, say so. If a refusal pattern misses, propose a tightening.

## Reach

GitHub issues for bugs / feature requests. Discussions for "should the framework do X?" questions.

For consulting (helping a team set Substrate up for their context): open a GitHub discussion on the repo.

*Maintainer: [Kesava Mandiga](https://github.com/k3sava)*
