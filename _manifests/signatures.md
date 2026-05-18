---
title: Signatures (Gate 7 catalog) — agent/signatures branch manifest
status: active
last_updated: 2026-05-08
branch: agent/signatures
---

# signatures.md

Manifest for the sprint-1 behavioral-signature work on the `agent/signatures` branch. Adds 16 hand-tuned signatures to `bin/lib/skill-pattern-check.sh::pattern_signature_for()` covering the paid-ads, email/lifecycle, retention/CS, and ABM/sales patterns introduced in sprint 1. Calibration was done by reading every `## Implication` and `## Convergence` section, then identifying the load-bearing tokens an asset *applying* the pattern is hard to write without using.

## What this work added

- 16 new entries in `pattern_signature_for()`, each a hand-tuned alternation regex.
- 4 new fixtures (2 PASS, 2 FAIL) under `tests/pattern-check/fixtures/`.
- 7 new test groups (T11–T17) in `tests/pattern-check/run.sh` exercising signature wiring, self-match, asset-side PASS/FAIL behavior, and two-tier false-positive resistance (casual mentions in T16, surface-noun-only mentions in T17).
- 16 new rows under "Behavioral signatures (Gate 7 catalog)" in `knowledge/patterns/INDEX.md`.

## Files added

| Path | Purpose |
|---|---|
| `tests/pattern-check/fixtures/pass-ad-diagnose-paid-ads.md` | Passes Gate 7 against `ad-diagnose` (evidences all four grounded patterns: `creative-fatigue-window`, `intent-vs-interest-targeting`, `incrementality-not-attribution`, `buyer-mindset-not-product-features`). Also names the conditioned position on `no-decision-vs-named-competitor`. |
| `tests/pattern-check/fixtures/pass-activation-funnel-audit-retention.md` | Passes Gate 7 against `activation-funnel-audit` (evidences `aha-moment-defines-activation` + `retention-cohort-curves-over-blended-rates`). |
| `tests/pattern-check/fixtures/fail-ad-diagnose-paid-ads.md` | Fails Gate 7: mentions creative / CAC / ROAS without applying any pattern. Casual language ("refresh creatives sometime", "channel mix at the next quarterly review", "platform-reported ROAS looks fine"). |
| `tests/pattern-check/fixtures/fail-activation-funnel-audit-retention.md` | Fails Gate 7: mentions activation / retention / aha moment without curve segmentation, candidate event testing, or cohort decomposition. |
| `_manifests/signatures.md` | This file. |

## Files modified

| Path | Change |
|---|---|
| `bin/lib/skill-pattern-check.sh` | Added 16 hand-tuned signatures to `pattern_signature_for()` between `subtraction-first-operating-discipline` and the `*)` fallback. Each entry carries a header comment naming the load-bearing language so future readers can audit calibration. |
| `tests/pattern-check/run.sh` | Added test groups T11 (signature wiring + self-match), T12 (paid-ads PASS), T13 (retention PASS), T14 (paid-ads FAIL), T15 (retention FAIL), T16 (false-positive resistance — casual mentions for all 16 signatures), T17 (false-positive resistance — surface-noun-only mentions for the 12 hardest cases). Also rephrased T8 and T10 assertions to use distinctive gate names rather than gate numbers, so the tests stay green if preflight gate numbering shifts. |
| `knowledge/patterns/INDEX.md` | Appended 16 rows under "Behavioral signatures (Gate 7 catalog)" — one per sprint-1 pattern, paraphrasing the load-bearing cue. Catalog now lists 55 hand-tuned signatures. |

## The 16 signatures

Each signature is a `|`-separated alternation regex. The entries below name the slug, what makes the cue load-bearing (the operating verb / noun that distinguishes "applying the pattern" from "mentioning the topic"), and the calibration result.

### Paid-ads (4 patterns)

#### 1. `creative-fatigue-window`
- **Load-bearing**: "Refresh cadence is the lever" — operators applying this pattern frame creative refresh as the *upstream* lever for CAC, name fatigue thresholds (CTR decline, frequency above 3, CPM rise) before bid changes, and treat creative volume (10+ per week) as the operating cycle. Anyone who only says "we should refresh creatives sometime" is *mentioning* the topic.
- **Self-match**: yes — body matches "refresh cadence is the lever" + "weekly cadence on creative production" + "10+ creatives per week" + "30% CTR decline" + "frequency above 3.0".
- **False-positive test**: "we should probably refresh some creatives sometime — they look tired and our CAC is climbing" → no match. Adversarial: "I think we have creative fatigue but I'm not sure what to do" → no match (bare noun, no threshold/cadence/cycle); "fatigue thresholds for our org chart need work" → no match (threshold not paired with CTR/CPM/frequency/peak/14 day).

#### 2. `channel-arbitrage-window`
- **Load-bearing**: The 6-18 month "arbitrage window", saturation indicators (CPM trajectory YoY, share-of-voice category trend), 70/20/10 budget split, "rotate ahead of saturation", channel-product fit. Casual mentions of "channel mix" or "rotate channels" without window math don't qualify.
- **Self-match**: yes — matches "arbitrage closes" + "channel-product fit" + "decay curve" + "rotate ahead of the curve" + "early-cohort CAC".
- **False-positive test**: "let's revisit the channel mix this quarter and rotate channels more often" → no match (no arbitrage, no saturation indicator, no fit framework).

#### 3. `intent-vs-interest-targeting`
- **Load-bearing**: "Search buys intent / paid social buys interest", See/Think/Do/Care funnel mapping, separating dashboards/budgets *with channel context* (not just "separate dashboards" alone), demand-capture-vs-demand-generation metric pairing, branded-search lift, cohort-level CAC. Generic "demand generation team" doesn't qualify; bare "intent vs interest" alone is too easily said casually so the load-bearing form pairs the dichotomy with the channel(s).
- **Self-match**: yes — matches "Search ads buy intent; paid social buys interest" + "See, Think, Do, Care" + "demand-generation metrics" + "assisted conversions".
- **False-positive test**: "demand generation team is hiring; we should separate the dashboards next sprint" → no match. Adversarial: "intent vs interest is interesting question" → no match (no channel pairing).

#### 4. `incrementality-not-attribution`
- **Load-bearing**: Incrementality test / geo holdout / ghost ads / conversion-lift study / MMM as the *only credible* cross-channel measure; explicit attribution-model footnote on blended CAC; reported-vs-incremental divergence (2x-5x); the 5%-of-budget threshold. Bare "blended CAC" is too generic — operators report it without applying the pattern.
- **Self-match**: yes — matches "geographic holdout" + "ghost ads" + "conversion-lift study" + "marketing mix model" + "2x to 5x".
- **False-positive test**: "what is our blended CAC this quarter? something looks weird in the dashboard" → no match (blended CAC alone, no model footnote, no incrementality framing).

### Email / lifecycle (4 patterns)

#### 5. `engagement-decay-as-relevance-signal`
- **Load-bearing**: "Relevance hypothesis (first / before deliverability)", "gradual taper vs sudden cliff" diagnostic shape, "deliverability dashboards downstream", "broadcast nurtures decay/underperform", permission as renewing contract. Bare "broadcast nurture" or "cohort definition" is too generic.
- **Self-match**: yes — matches "the relevance hypothesis is tested" + "broadcast nurtures decay" + "engagement signals shape inbox placement" + "deliverability dashboards are a downstream symptom".
- **False-positive test**: "open rates are dropping, we should check the spam folder situation" → no match (jumps to deliverability, no relevance-first diagnostic).

#### 6. `sender-reputation-is-a-domain-asset`
- **Load-bearing**: "Domain reputation" as multi-year compounding asset; SPF/DKIM/DMARC at domain level (RFC 7489); refuse "burn-and-rotate"; subdomain sprawl audit; "organizational domain" as policy unit. DMARC alone is acceptable as load-bearing technical vocabulary in this domain (parallels how `Munger` / `Voss` / `MGI` are accepted in existing signatures). Bare "sender reputation" / "sending domain" is the symptom-noun (anyone in email-ops uses it); the load-bearing form is the domain-not-IP / multi-year-asset framing.
- **Self-match**: yes — matches "domain reputation" + "sender reputation accrues to the domain" + "DMARC" + "subdomain (sprawl|hierarchy|isolation)" + "RFC 7489".
- **False-positive test**: "we got an email saying delivery rates have dipped — anyone know why?" → no match. Adversarial: "sender reputation took a hit last quarter" → no match (no domain/IP/compounds/asset coupling); "sending domain change for the migration" → no match (no brand/years/persist/asset coupling).

#### 7. `one-segment-one-trigger`
- **Load-bearing**: "Cohort × trigger" as the smallest viable lifecycle unit; refuse "broad-list-broadcast"; trigger-first vs cadence-first design discipline; trigger fire-rate metric; JTBD progress moment as the trigger primitive. Bare "broadcast nurture" alone is too generic (industry vocab); the load-bearing form is the refusal/decay/underperform claim.
- **Self-match**: yes — matches "smallest viable lifecycle (unit)" + "broadcast nurtures decay" + "trigger-first" + "JTBD progress moment" + "cohort × trigger".
- **False-positive test**: "let's send a Tuesday email blast to everyone signed up in March" → no match. Adversarial: "broadcast nurture campaigns are old school" → no match (no decay/underperform/refusal coupling).

#### 8. `subject-line-as-experiment-not-art`
- **Load-bearing**: "Subject lines are testable hypotheses (not creative writing)"; message-mining / review-mining for source language; cohort-scoped tests with the statistical bar *set before the send*; document the hypothesis not the winner. Bare "subject line test" is too generic — operators run those without applying the discipline.
- **Self-match**: yes — matches "subject lines are testable hypotheses" + "message-mining" + "statistical bar" + "treat each subject as a cohort-scoped experiment".
- **False-positive test**: "the subject test ran last week and one had a 4% lift" → no match (test ran without statistical bar, hypothesis, or cohort scoping).

### Retention / customer-success (4 patterns)

#### 9. `aha-moment-defines-activation`
- **Load-bearing**: Aha moment / activation event tied to retention-curve segmentation (not UX milestone); candidate value events tested against curve divergence; named examples (Slack 2,000 messages, Airbnb two-way review, HubSpot first form); refusing UX-milestone substitution. Bare "aha moment" couples with activation/retention/curve to filter casual-meeting usage.
- **Self-match**: yes — matches "aha moment defines activation" + "candidate value event" + "retention-curve segmentation" + "first form created".
- **False-positive test**: "had an aha moment on the call today — Sara mentioned the pricing thing" → no match (aha moment without activation/retention/curve coupling).

#### 10. `retention-cohort-curves-over-blended-rates`
- **Load-bearing**: "Cohort retention curves vs blended rate"; per-cohort table by signup week/month as the floor artifact; NDR / T2D3 require cohort decomposition; slope-change detection; asymptotic retention. Refuse to read blended without cohort decomposition behind it.
- **Self-match**: yes — matches "cohort retention" + "blended retention" + "retention curve" + "NDR" + "T2D3" + "signup cohort".
- **False-positive test**: "retention this quarter is 75%, up from 70% last quarter" → no match (blended rate reported with no cohort decomposition).

#### 11. `behavioral-expansion-signals-beat-tenure`
- **Load-bearing**: "Expansion (trigger / signal / score)"; "behavioral signal beats tenure"; tenure-based expansion is the wrong primitive; usage curve > calendar; adoption-breadth, value-event-density, threshold-crossing; "day 21 ready vs day 90 stuck". Bare "day 21" / "day 90" is too generic; the load-bearing form pairs each calendar marker with the behavioral neighbour (ready / expand / behavior / adopt / signal / stuck).
- **Self-match**: yes — matches "expansion (trigger|signal|score)" + "tenure-based" + "usage curve" + "adoption-breadth" + "day 21.{0,40}ready" / "day 90.{0,40}stuck/never adopted" + "behavior beats tenure".
- **False-positive test**: "let's send an upsell email to all 90-day customers" → no match. Adversarial: "day 21 customers churned this week" → no match (no ready/expand/behavior/adopt/signal coupling).

#### 12. `churn-prediction-vs-churn-diagnosis`
- **Load-bearing**: "Diagnose (before / then / first) predict"; churn driver ranked by "coverage × addressability"; save calls fight symptoms; "cohort-level driver"; population-level cause vs account-level intervention; "treadmill"; "loyalty deficit". Bare "save call" alone is too generic (CS vocab); the load-bearing form pairs save calls with the symptom-vs-driver framing (fight / do not / loses / symptom / treadmill / secondary).
- **Self-match**: yes — matches "Diagnose first, predict second" + "fight(ing) symptom" + "treadmill" + "population-level driver" + "loyalty deficit" + "loyalty system" + "guess-substrate".
- **False-positive test**: "churn is up to 6% MoM, we should do something about it" → no match. Adversarial: "save call rate is improving" → no match (save call without symptom-vs-driver coupling).

### ABM / sales (4 patterns)

#### 13. `trigger-events-beat-cadence-blast`
- **Load-bearing**: Trigger window (60 / 90 / 30 / 120 day); "why-now anchor"; event-based personalization (not bio); "bio facts are stale"; 10-K passage / earnings-call quote / exec-hire announcement / funding round press as opener material; multithread inside the fresh trigger window. Bare "trigger event" alone is too generic — operators say it without applying the practice.
- **Self-match**: yes — matches "trigger-event window" + "60-90 day window" + "why now" + "trigger detection" (system) + "exec hire" (announcement) + "funding round (window)".
- **False-positive test**: "we got an alert about a funding round at TargetCo — should we reach out?" → no match (alert-with-no-window, no detection-system, no opener material framework).

#### 14. `account-not-lead-as-unit`
- **Load-bearing**: "Account is/as the unit (of pursuit)"; "MQL is GTM debt" / "MQL funnel rewards lead volume" / "tear down the MQL funnel"; TEAM (Target → Engage → Activate → Measure); 1-to-1 / 1-to-few / 1-to-many tier model; stakeholder map per account; account-fit dominates persona-fit; 6-10 stakeholders. Bare "TEAM" is too loose (catches "TEAM Foundations training"); bare "MQL funnel" is too loose (catches "MQL funnel review meeting"). The load-bearing forms require the TEAM-paren-Target framework expansion or the MQL-funnel-rejection coupling (GTM debt / tear / debt / reject / rewards / wrong / underweight).
- **Self-match**: yes — matches "MQL funnel" coupled with "GTM debt" / "rewards lead volume" + "TEAM (Target → Engage → Activate → Measure)" + "1-to-1...1-to-few...1-to-many" + "stakeholder map per account" + "6-10 stakeholders" + "account-fit (score|weight)".
- **False-positive test**: "MQL count is up 30% — celebrating with cake" → no match. Adversarial: "TEAM Foundations training next month" → no match (no Target→Engage→Activate→Measure expansion); "MQL funnel review meeting" → no match (no GTM-debt/tear/reject coupling).

#### 15. `rhythm-beats-blast`
- **Load-bearing**: "Rhythm beats blast / burst / episodic"; "burst-and-quiet" anti-pattern; 30-day rule; channel + content rotation per touch; distinct content gates; "just checking in" as filler-touch tell; pursuit-not-chase at the org level; 8-12 touches. Bare "channel rotation" / "content gate" leak into Slack-ops talk (channel rotation in chat platforms; content gate in CMS workflows); the load-bearing forms require the paired/distinct/per-touch coupling.
- **Self-match**: yes — matches "rhythm beats episodic blast" + "burst-and-quiet" + "30-day rule" + "channel + content rotation" / "channel rotation + content rotation" + "distinct content gates" + "pursuit (not) chase".
- **False-positive test**: "let's just blast the list once and see" → no match. Adversarial: "channel rotation in Slack confuses people" → no match (no content rotation pairing); "we have a content gate review meeting" → no match (no distinct/progression/per-touch coupling).

#### 16. `status-quo-is-the-real-objection-outbound`
- **Load-bearing**: Setup → Follow-Through sequence architecture; "the unstated objection" / "we're fine" as the no-decision reply; cost-of-inaction before alternative; discovery-before-pitch in the first 3-4 touches; alternative-anchored opener; no-decision rate as sequence-quality metric.
- **Self-match**: yes — matches "Setup → Follow-Through" + "we're fine as-is" + "the unstated objection" + "discovery (before|over) pitch" + "world changed (cost of) old game" + "no-decision (bucket|reply|rate)".
- **False-positive test**: "we lost the deal to no-decision again, third one this quarter" → no match (the loss is observed without the Setup-Follow-Through architecture or the cost-of-inaction frame applied).

## Calibration coverage

- Self-match: 16/16 (each new signature hits at least one fragment in its own pattern body — verified by T11.self-match).
- False-positive resistance, tier 1 — casual mentions: 16/16 (T16). Phrases like "we should probably refresh some creatives sometime" reject cleanly.
- False-positive resistance, tier 2 — surface-noun-only mentions: 12/12 (T17). The harder cases: bare "creative fatigue", "intent vs interest", "sender reputation", "broadcast nurture", "save call", "TEAM", "MQL funnel", "channel rotation", "content gate", "sending domain", "fatigue threshold", "day 21 customers" — all reject after the calibration tightening that paired each load-bearing noun with a verb-shaped or framework-shaped neighbour.
- Asset-side PASS: paid-ads PASS evidences all 4 ad-diagnose patterns; retention PASS evidences both activation-funnel-audit patterns.
- Asset-side FAIL: paid-ads FAIL and retention FAIL both fail every grounded pattern despite mentioning the surface vocabulary.

### Calibration tightening (post-initial-pass adversarial sweep)

The first signature pass passed T11 + T16 cleanly, but an adversarial probe revealed seven surface-noun-only false-positives that the existing T16 single-fragment-per-slug test could not catch. Each tightening pairs the bare load-bearing noun with a structural neighbour the pattern's discipline requires:

| Pattern | Bare noun (rejected) | Required neighbour |
|---|---|---|
| `creative-fatigue-window` | "creative fatigue" / "fatigue threshold" alone | threshold metric (CTR / CPM / frequency / 14 day / peak / decline / trip / defin / campaign) |
| `intent-vs-interest-targeting` | "intent vs interest" alone | channel pairing (search/social/google/meta/See-Think-Do-Care) or a metric pairing |
| `sender-reputation-is-a-domain-asset` | "sender reputation" / "sending domain" alone | the asset / brand / years / persist / compound framing |
| `one-segment-one-trigger` | "broadcast nurture" alone | decay / underperform / loses / refuse / function-as-floor-noise |
| `churn-prediction-vs-churn-diagnosis` | "save call" alone | fight / do not / loses / symptom / treadmill / secondary |
| `account-not-lead-as-unit` | "TEAM" / "MQL funnel" alone | TEAM-paren-Target framework expansion; MQL funnel + GTM debt / tear / debt / reject / wrong / underweight |
| `rhythm-beats-blast` | "channel rotation" / "content gate" alone | distinct / per touch / progression / + content rotation / sequence |
| `behavioral-expansion-signals-beat-tenure` | "day 21" / "day 90" alone | ready / expand / behavior / adopt / signal / stuck / never adopted |

Each tightening preserves self-match against the pattern's own body (verified by T11.self-match) while killing the casual-mention false-positive (verified by T17). The bar is "could a person say this phrase without applying the pattern's discipline?" — when the answer is yes, the bare noun gets paired with a verb-shaped or framework-shaped neighbour that is hard to write without the discipline.

## How this composes with existing work

- The 39 prior signatures from `agent/enforcement` cover the v1.1.0 / v1.2.0 patterns. Sprint-1 adds 16 more, bringing the catalog to 55 hand-tuned entries.
- Gate 7 in `pre-publish-check` (the integration site) is unchanged — it just sees more signatures wired into `pattern_signature_for()`. Soft-fail / hard-fail behavior is unchanged.
- The patterns INDEX catalog table grew by 16 rows; the existing "Gate 7 catalog" header reflects how the lib is invoked as Gate 7 of the operational gate sequence even though preflight numbers it Gate 9 internally. That naming drift predates this branch and is out of scope here.

## Run the tests

```
bash tests/pattern-check/run.sh
```

Expected: `passes: 36, fails: 0, all tests passed.`

The test groups added on this branch:
- T11 / T11.self-match — signatures non-empty + self-match (2 assertions)
- T12 — paid-ads PASS fixture against ad-diagnose (5 assertions)
- T13 — retention PASS fixture against activation-funnel-audit (3 assertions)
- T14 — paid-ads FAIL fixture (4 assertions)
- T15 — retention FAIL fixture (3 assertions)
- T16 — false-positive resistance, casual mentions for all 16 signatures (1 aggregate assertion)
- T17 — false-positive resistance, surface-noun-only mentions covering the 12 hardest cases the calibration tightening fixed (1 aggregate assertion)

T8 and T10 were rephrased to use distinctive gate names rather than gate numbers, so they pass against the current preflight while staying robust to future renumbering.

## Non-scope

- `skills/pre-publish-check/bin/preflight` was not modified.
- Pattern body files (`knowledge/patterns/*.md`) were not modified.
- `PRINCIPLES.md`, `README.md`, `ORIGIN.md`, `VERSION` were not modified.
- New skills, contradictions, routines were not added.
- `bin/lib/skill-contradiction-check.sh` was not modified.
