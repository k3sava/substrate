---
title: ABM + sales-engagement surface, build manifest
status: shipped
last_updated: 2026-05-08
agent: abm
branch: agent/abm
---

# ABM + sales-engagement surface

Substrate's account-based marketing and sales-engagement layer. Six skills, four patterns, two contradictions, two routines, three template fixtures. Sales is where positioning becomes pipeline; this surface makes that connection load-bearing.

## Skills (6)

| File | Purpose |
|---|---|
| `skills/abm-account-prioritize/SKILL.md` | Skill spec: score and tier a target-account list against canonical ICP. |
| `skills/abm-account-prioritize/bin/abm-account-prioritize` | Runtime (703 LOC, Python). Reads ICP, competitive registry, triggers feed, intent feed; computes weighted 5-feature scores; assigns tier 1A/1B/2/defer with a 15% cap on 1A; writes ranked CSV + summary. Refuses without ICP, refuses on missing CSV columns, refuses on tier-1A overflow. |
| `skills/outbound-sequence-design/SKILL.md` | Skill spec: design multi-channel outbound sequence per tier × category-maturity × trigger. |
| `skills/outbound-sequence-design/bin/outbound-sequence-design` | Runtime (900 LOC, Python). Reads canonical positioning + ICP persona + status-quo frame + VoC; composes Setup → Follow-Through cadence (12/10/8 touches per 1A/1B/2); enforces channel character limits (email subject 4-7 words, LinkedIn ≤300 chars, voicemail 25-35 spoken words, etc); composes voice-enforce on every touch; refuses without positioning. |
| `skills/sales-trigger-event-watch/SKILL.md` | Skill spec: detect funding, exec-hire, product-launch, layoff, acquisition, tech-change events on watched accounts. |
| `skills/sales-trigger-event-watch/bin/sales-trigger-event-watch` | Runtime (628 LOC, Python). Real RSS / Atom feed parser; per-account Google News template; trigger-window classification (funding 60d, exec-hire 90d, product-launch 30d, etc); significance scoring (primary vs secondary corroboration); writes daily triggers file + rolling INDEX.md; refuses on >5000 accounts without --force. |
| `skills/intent-data-route/SKILL.md` | Skill spec: route intent feed (G2, Bombora, generic) to ICP cohort + recommended next-action. |
| `skills/intent-data-route/bin/intent-data-route` | Runtime (394 LOC, Python). Reads intent feed CSV, latest rankings, latest triggers; applies routing matrix (score × tier × trigger → action); enforces anti-ICP filter; refuses on >50% fast-track without --force; writes routed CSV + summary. |
| `skills/account-pursuit-rhythm/SKILL.md` | Skill spec: design 30/60/90-day pursuit rhythm spec for a tier. |
| `skills/account-pursuit-rhythm/bin/account-pursuit-rhythm` | Runtime (463 LOC, Python). Per-tier cadence skeletons (1A: 12 in 30d + 6 in 31-60 + 4 in 61-90; 1B and 2 scaled down); validators for consecutive-channel-gate, max-gap, min-density; design + audit modes; outputs cadence schedule + hand-off rules + review checkpoints. |
| `skills/battle-card-driver/SKILL.md` | Skill spec: surface battle-card content for a deal-in-flight against a named competitor. |
| `skills/battle-card-driver/bin/battle-card-driver` | Runtime (538 LOC, Python). Reads battle-card markdown, extracts position / when-they-win / when-we-win / honest-losses / talk-track / pricing / recent-shifts; routes (buyer-state × deal-stage) to relevant sections; surfaces VoC displacement quote; composes claim-verify on output; outputs AE talking points. |

Total runtime LOC across the six skills: ~3,626 lines of real bash + Python with ICP reads, scoring, contradictions resolution, content composition, feed parsing, and validator gates. No prompt-emit stubs.

## Patterns (4 new)

| File | Convergence | Operators |
|---|---|---|
| `knowledge/patterns/trigger-events-beat-cadence-blast.md` | Trigger-driven outbound beats blanket cadence by 5-10x; the relevance signal does the work. | Aaron Ross, Jeb Blount, Sam Nelson, Becc Holland |
| `knowledge/patterns/account-not-lead-as-unit.md` | In B2B with multi-buyer committees, account is the unit of pursuit; lead-as-unit underweights committee dynamics. | Sangram Vajre, Jon Miller, Bev Burgess, Maja Voje |
| `knowledge/patterns/rhythm-beats-blast.md` | Consistent 30-60-90 day cadence with content gates outperforms episodic burst-and-quiet. | Jeb Blount, John Barrows, Trish Bertuzzi, Becc Holland |
| `knowledge/patterns/status-quo-is-the-real-objection-outbound.md` | In outbound, the unstated objection is "we're fine"; sequences must run Setup before Follow-Through. | April Dunford, Anthony Pierri, Jessica Fain |

Each pattern: real operators, real claim attribution, Convergence + Operators + Variation + Implication + Counter-evidence + Sources sections. ≥3 distinct operators with verifiable positions.

## Contradictions (2 new)

| File | Position A | Position B | Conditioning |
|---|---|---|---|
| `knowledge/contradictions/personalization-vs-scale.md` | Holland / Nelson / Brazier: hyper-personalize every touch | Barrows / Bertuzzi / Roberge: scaled cadence with smart variables | Account tier + ACV + sales-cycle length + SDR seniority |
| `knowledge/contradictions/outbound-vs-inbound-budget.md` | Reed / Klettke / Gerhardt: inbound compounds in saturated categories | Vajre / Roberge / Lacy: outbound creates emerging categories | Category maturity + brand recognition + cash runway + buyer self-education depth |

Skills declare these contradictions in `contradictions_aware` frontmatter; runtimes read the conditioning section and apply the right position per client context. Substrate does not pick a global default.

## Routines (2 new)

| File | Cadence | What it does |
|---|---|---|
| `routines/sales-trigger-routine.md` | Daily 06:30 IST | Scan target accounts for trigger events; high-significance triggers page AE within 4h; medium batched into SDR queue. |
| `routines/account-tier-review.md` | Quarterly first Monday | Re-prioritize target-account list against refreshed ICP; diff promotions / demotions; log tier-prediction accuracy as calibration signal. |

## Templates (3 fixtures)

| File | Purpose |
|---|---|
| `templates/target-accounts-example.csv` | Realistic target-account list with company / domain / industry / size / geo / tech_stack / signals / strategic / logo_value / vertical_leader columns; 26 rows for end-to-end testing. |
| `templates/intent-feed-example.csv` | Generic intent feed shape (G2 / Bombora / 6sense compatible): company / domain / industry / signal_type / signal_topic / total_score / signal_count / surge; 26 rows. |
| `templates/outbound-sequence-example/` | Three example touches + manifest demonstrating Setup-Follow-Through architecture for a tier-1A funding-trigger sequence. |

## Index updates

| File | Change |
|---|---|
| `knowledge/patterns/INDEX.md` | Added 4 new Tier-A pattern rows; updated Tier-A count to 25. |
| `knowledge/contradictions/INDEX.md` | Added 2 new contradiction rows. |
| `routines/README.md` | Added rows for sales-trigger-routine and account-tier-review. |

## Composition graph

```
sales-trigger-event-watch  →  triggers/<date>.md
                               ↓
target-accounts.csv  →  abm-account-prioritize  →  account-rankings/<date>-ranked.csv
                                                    ↓
intent-feed.csv  →  intent-data-route  →  intent-routing/<date>-routed.csv
                                          ↓
                       account-pursuit-rhythm  →  pursuit-rhythms/<date>-tier-X-rhythm.md
                                                  ↓
                       outbound-sequence-design  →  sequences/<date>-<persona>-<tier>/{01-12}-touch.md
                       (+ voice-enforce on every touch)

deal-in-flight  →  battle-card-driver  →  talking-points/<date>-<account>-<competitor>.md
                   (+ claim-verify on every claim)
```

Each skill produces the input the next consumes. The end-to-end pipeline runs from a raw target-account CSV to per-touch outbound copy, with tier assignment, intent routing, cadence design, voice enforcement, and claim verification gating each step.

## Pattern grounding (declared)

- `abm-account-prioritize` grounds in `account-not-lead-as-unit` and `trigger-events-beat-cadence-blast`.
- `outbound-sequence-design` grounds in `status-quo-is-the-real-objection-outbound`, `rhythm-beats-blast`, `trigger-events-beat-cadence-blast`, and `copywriting-craft-fundamentals`.
- `sales-trigger-event-watch` grounds in `trigger-events-beat-cadence-blast` and `account-not-lead-as-unit`.
- `intent-data-route` grounds in `account-not-lead-as-unit` and `trigger-events-beat-cadence-blast`.
- `account-pursuit-rhythm` grounds in `rhythm-beats-blast`, `account-not-lead-as-unit`, and `trigger-events-beat-cadence-blast`.
- `battle-card-driver` grounds in `status-quo-is-the-real-objection-outbound`, `differentiation-vs-sameness`, and `copywriting-craft-fundamentals`.

## End-to-end validation

Built a synthetic test client (`testco`) with ICP, positioning, status-quo, persona, VoC, target accounts, intent feed, battle card. Ran each skill end-to-end against this fixture:

- `abm-account-prioritize`: 26 accounts → 2 tier-1A, 6 tier-1B, 5 tier-2, 13 defer (with 15% cap honored); summary written.
- `intent-data-route`: 26 rows → 4 fast-track, 6 outbound-now, 12 nurture, 1 disqualify; 3 anti-ICP dropped.
- `account-pursuit-rhythm`: tier 1A / 90d horizon → 22 touches with no consecutive same-channel-gate violations.
- `outbound-sequence-design`: tier 1A / mature / funding trigger → 12 touches composed, 0 character-limit warnings, 0 voice-enforce failures.
- `battle-card-driver`: aircall / product-aware / demo → talking points with VoC displacement quote, claim-verify composed.
- `sales-trigger-event-watch`: 3 default RSS feeds × 26 accounts → 1 real trigger detected (acquisition signal).

All refusal paths verified: missing client root, missing ICP layer, missing positioning, missing target accounts CSV, missing required columns, >5000 accounts, >50% fast-track without --force.

## Operator voice and anti-fabrication

- Body composition uses no em-dashes (sed-replaced through the runtime); voice-enforce passes naturally.
- No kill-list words in any generated copy.
- All operator citations in patterns and contradictions reference real, verifiable positions: Aaron Ross's Predictable Revenue, Jeb Blount's Fanatical Prospecting, Sam Nelson's Outreach / Sales Assembly, Becc Holland's Flip the Script, Sangram Vajre's Terminus / GTM Partners, Jon Miller's Marketo / Engagio / Demandbase, Bev Burgess's ITSMA, Maja Voje's GTM Strategist, John Barrows's JB Sales, Trish Bertuzzi's The Bridge Group, April Dunford's Obviously Awesome, Anthony Pierri's FletchPMM, Jessica Fain, Devin Reed's Reeder, Joel Klettke's Conversion Copy, Dave Gerhardt, Mark Roberge's HubSpot CRO frame, Kyle Lacy, Sarah Brazier.

## Non-scope respected

- No modifications to: paid-ads / email / retention / FLYWHEEL_ROOT renaming / gate library / pre-publish-check / goals/ledger.md / README.md.
- All skills use `SUBSTRATE_ROOT` (with `FLYWHEEL_ROOT` fallback for compat with the shared preflight library).
