---
name: outbound-sequence-design
description: Design a multi-channel multi-step outbound sequence (email + LinkedIn + voice/SMS) grounded in canonical positioning + status-quo competitor + buyer-state. Channel-specific output shapes with character limits. Composes voice-enforce on every step.
version: 0.1
amplifies: SDR, AE, ABM lead, sales enablement
masters: April Dunford (Setup → Follow-Through pitch architecture), Jeb Blount (cadence discipline, Fanatical Prospecting), John Barrows (multichannel touch design), Trish Bertuzzi (pursuit-not-chase rhythm), Becc Holland (event-based personalization), Sam Nelson (multithread on trigger), Chris Voss (tactical empathy in conversation), Anthony Pierri (5-second alternative-anchored opener)
substrate_layers_required: [icp, positioning, competitive, voc, brand-voice]
patterns_grounded: [status-quo-is-the-real-objection-outbound, rhythm-beats-blast, trigger-events-beat-cadence-blast, copywriting-craft-fundamentals]
contradictions_aware: [personalization-vs-scale, outbound-vs-inbound-budget, no-decision-vs-named-competitor]
preflight_refusal: substrate-gap, missing-positioning, missing-icp, missing-tier
required_reads:
  - clients/{client}/positioning/positioning-canonical-statement.md
  - clients/{client}/icp/00-INDEX.md
  - clients/{client}/voc/processed/
  - clients/{client}/competitive/status-quo.md
---

# outbound-sequence-design

## Purpose

Take a tier assignment (1A / 1B / 2), a target persona, and a trigger (or no-trigger fallback), produce a fully-composed outbound sequence with channel-specific touches. Each touch is voice-enforced, character-limited per channel, and anchored on the canonical positioning's status-quo frame (Dunford's Setup → Follow-Through, per `pat_status-quo-is-the-real-objection-outbound`). The sequence is shipped as a directory of per-touch markdown files, ready for SDR / AE ingestion into Outreach, Salesloft, Apollo, or Smartlead.

## Inputs

- `--client <client>` (required)
- `--persona <persona-id>` (required) — pinned ICP persona
- `--tier 1A|1B|2` (required) — picks position from `con_personalization-vs-scale`
- `--category-maturity mature|emerging|hybrid` (required) — picks position from `con_outbound-vs-inbound-budget`
- `--trigger <type>` (optional) — funding | exec-hire | product-launch | layoff | acquisition | tech-change | none
- `--length <8|10|12>` (optional, default per tier) — number of touches
- `--output-dir <path>` (optional) — where to write sequence; default `clients/<client>/sales/sequences/<date>-<persona>-<tier>/`

## Substrate reads

- `clients/<client>/positioning/positioning-canonical-statement.md` — the canonical statement that anchors every touch
- `clients/<client>/icp/00-INDEX.md` and persona file — to ground language in actual ICP
- `clients/<client>/voc/processed/` — for buyer-language quotes that go into proof touches
- `clients/<client>/competitive/status-quo.md` — for the alternative the buyer is currently using
- `clients/<client>/competitive/battle-cards/` — for displacement framing if a competitor is named

## Channel character limits (enforced)

| Channel | Subject | Body | Notes |
|---|---|---|---|
| email_intro | 4-7 words | 50-90 words | Setup phase; opens with alternative or trigger |
| email_proof | 4-7 words | 60-110 words | Includes one VoC quote with citation |
| email_breakup | 4-7 words | 30-60 words | Closes the loop; permission to re-open |
| linkedin_connect | — | ≤300 chars | Connection request note |
| linkedin_message | — | ≤900 chars | Post-connect or open-profile |
| voicemail_script | — | 25-35 words spoken (~12 sec) | Voss-pattern accusation audit + label |
| sms | — | ≤160 chars | Tier 1A only; with-permission |
| video_script | — | 45-75 words spoken (~30 sec) | Tier 1A only |

## Cadence templates (per tier)

### Tier 1A — 12 touches over 30 days, hand-personalized

Setup phase (touches 1-4): email-intro → linkedin-connect → voice-vm → email-proof
Follow-Through (touches 5-9): email-proof → linkedin-message → video-script → email-breakup-soft → voice-vm
Re-open (touches 10-12): email-curiosity → linkedin-content-share → email-breakup-final

### Tier 1B — 10 touches over 30 days, hybrid

Setup (touches 1-3): email-intro → linkedin-connect → email-proof
Follow-Through (touches 4-7): email-proof → voice-vm → email-objection → email-soft-breakup
Re-open (touches 8-10): linkedin-message → email-curiosity → email-breakup-final

### Tier 2 — 8 touches over 30 days, scaled

email-intro → email-proof → linkedin-connect → email-objection → voice-vm-light → email-curiosity → linkedin-message → email-breakup-final

## Process

1. Preflight: validate positioning + ICP + persona exist; refuse if missing.
2. Resolve contradiction positions per inputs (tier → personalization mode, category-maturity → frame mode, trigger present → status-quo content gates change).
3. Read positioning canonical statement; extract: target market, alternative (status-quo), unique value, category.
4. Read persona file; extract: role, JTBD, top objections, voice anchors.
5. Read status-quo.md; extract: alternative the buyer uses, cost-of-inaction language.
6. For each touch in cadence: compose Setup or Follow-Through copy per gate; substitute persona language; respect channel character limit; insert citation back to substrate file.
7. Write each touch to `<output-dir>/<NN>-<channel>-<gate>.md` with frontmatter.
8. Compose voice-enforce on every produced touch; reject the touch and re-emit if voice-enforce fails.
9. Write a sequence manifest at `<output-dir>/manifest.md` summarizing: tier, length, contradiction positions applied, character-limit checks, voice-enforce results.

## Output contract

```
clients/<client>/sales/sequences/<date>-<persona>-<tier>/
  manifest.md
  01-email-intro-setup-alternative.md
  02-linkedin-connect.md
  03-voice-vm-setup-cost.md
  04-email-proof-voc-quote.md
  05-email-proof-differentiator.md
  ...
  NN-email-breakup-final.md
```

Each touch file:
```yaml
---
asset_type: outbound-touch
client: <client>
persona: <persona-id>
tier: 1A | 1B | 2
channel: email | linkedin | voice | sms | video
gate: setup-alternative | setup-cost | proof-voc | proof-differentiator | objection | breakup
character_limit_status: pass | fail
voice_enforce_status: pass | fail
substrate_cited:
  - clients/<client>/positioning/positioning-canonical-statement.md
  - clients/<client>/voc/processed/<file>.md
---

# Touch NN — <channel> — <gate>

## Subject (if email)
<subject>

## Body
<body>

## Substrate cite
<which substrate path the load-bearing claim came from>
```

## Quality criteria

- Every touch has a `substrate_cited` frontmatter list — no copy floats untethered.
- Touch 1 must reference the alternative (status-quo) or trigger, not the seller's product (per Pierri / Dunford).
- Touches 1-3 (or 1-4 for Tier 1A) must be Setup phase — no product pitch, no "want a demo," no feature lists.
- Voice-enforce runs on every touch; failed touch is re-emitted, not shipped.
- Cadence respects rhythm: each touch hits a distinct content gate; no two consecutive touches use the same gate (per `pat_rhythm-beats-blast`).
- Character limits enforced per channel; over-limit touches are flagged in manifest.

## Refusal patterns

- Refuses if positioning canonical statement is missing or older than 90 days.
- Refuses if persona file is missing or has no `voice_anchors` section.
- Refuses if `--tier` is not provided (must be set explicitly to pick `con_personalization-vs-scale` position).
- Refuses if `--category-maturity` is not provided (must pick `con_outbound-vs-inbound-budget` position).
- Refuses any sequence that violates the Setup-Follow-Through ordering (touch 1 is a pitch).

## What this skill does NOT do

- Does NOT send the sequence — that's the SDR's tool (Outreach, Salesloft, Apollo, Smartlead).
- Does NOT detect triggers — that's `sales-trigger-event-watch`.
- Does NOT prioritize accounts — that's `abm-account-prioritize`.
- Does NOT verify claims about the buyer's company — the SDR runs final verification before send.

## See also

- `skills/abm-account-prioritize/` — feeds tier assignment.
- `skills/sales-trigger-event-watch/` — feeds trigger context.
- `skills/voice-enforce/` — composed on every touch.
- `skills/positioning-forge/` — produces the canonical statement this skill reads.
- `knowledge/patterns/status-quo-is-the-real-objection-outbound.md`.
- `knowledge/patterns/rhythm-beats-blast.md`.
- `knowledge/patterns/trigger-events-beat-cadence-blast.md`.
- `knowledge/contradictions/personalization-vs-scale.md`.
- `knowledge/contradictions/outbound-vs-inbound-budget.md`.
