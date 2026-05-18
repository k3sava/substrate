---
name: referral-targeting
description: Identify the hiring manager (not the recruiter), compose 2-3 value-add cold-outreach touches with an exit clause, fall back to advocate-mapping when the HM is unreachable. Voice-enforced operator-voice-warm on every touch (formal body with one-to-two traces of personal voice in load-bearing positions). Different shape from outbound-sequence-design (B2B SaaS SDR cadence); applies the YLP referral framework to the operator's own pipeline pursuit. Outputs to the operator's private outreach directory (not committed to substrate); the substrate skill itself is public.
version: 0.2
status: wired
updated_date: 2026-05-18
amplifies: independent operator running a consulting pipeline, candidate doing direct hiring-manager outreach, fractional PMM pitching prospects
masters: Yi Lin Pei (YLP Coaching — referral framework, hiring-manager-first, value-add + exit-clause), April Dunford (Setup → Follow-Through applied to one-to-one outreach), Anthony Pierri (5-second alternative-anchored opener), Chris Voss (tactical empathy, mirrors + labels in async copy), Becc Holland (event-based personalization), Sahil Bloom (advocate-mapping in adjacent roles), Adam Grant (Give and Take — value-first asymmetric exchange, asymmetric warmth builds trust), Lara Acosta / Justin Welsh (LinkedIn-native outreach craft for solo operators), Kesava (operator-voice-warm calibration via a 2026-05-08 outbound DM iteration)
substrate_layers_required: [prospect-dossier, operator-voice]
patterns_grounded: [hiring-manager-not-recruiter, value-add-with-exit-clause, operator-voice-warm, status-quo-is-the-real-objection-outbound, trigger-events-beat-cadence-blast]
contradictions_aware: [formal-vs-personal-voice-register, personalization-vs-scale]
preflight_refusal: substrate-gap, missing-prospect-dossier, missing-verified-jd, missing-hm-or-advocate, stub-dossier-blocks-outreach
required_reads:
  - data/research/{prospect}.md
  - knowledge/patterns/hiring-manager-not-recruiter.md
  - knowledge/patterns/value-add-with-exit-clause.md
  - knowledge/patterns/operator-voice-warm.md
  - knowledge/contradictions/formal-vs-personal-voice-register.md
---

# referral-targeting

## Purpose

`outbound-sequence-design` produces a B2B SaaS SDR cadence (8-12 touches, multi-channel, character-limit-enforced). Hiring-side outreach is a different shape — fewer touches, the buyer is one person not an account, the asymmetry is reversed (the candidate is asking, the HM is gatekeeping). The YLP referral framework (Yi Lin Pei, *How to Get a Referral*, Courageous Careers 2024) is the operator playbook: hiring-manager-first, value-add per the candidate's relevant work, exit-clause closer, advocate-mapping when the HM doesn't respond. This skill composes that into substrate's voice-enforce gate.

## When to use

- Outreach to a hiring manager for a prospect-pursuit (consulting pipeline OR direct hiring).
- Outreach to an advocate (peer in adjacent role) when the HM is unreachable.
- Re-engaging a prior contact at a new company.

## Inputs

- `--prospect <slug>` (required) — must have an existing dossier at `data/research/<slug>.md`
- `--role-title <string>` (required) — the specific role being outreach-targeted
- `--jd-url <url>` (required) — verified JD URL; the AI Rocketship precedent applies (reaction signal alone is not hire signal)
- `--hm-handle <linkedin-url>` (optional but preferred) — hiring manager identified via LinkedIn `<role-function> + <company>` search
- `--advocate-handle <linkedin-url>` (optional) — fallback when HM unreachable
- `--operator-angle <string>` (required) — the substrate-derived hook (one sentence; what the operator brings that's specifically relevant to the prospect)
- `--touch-channel <linkedin-connect|linkedin-message|email>` (required for each touch generated)
- `--output-dir <path>` (optional, default `<operator-outreach-dir>/<prospect>/`). Outputs go to the operator's private outreach directory (not committed to substrate). Substrate stays clean of personal outreach files. The substrate skill itself is public.

## Substrate reads

- `data/research/<prospect>.md` — the prospect dossier; the skill refuses without it. Anti-fabrication: if the dossier is a stub (per `prospect-identification`), refuse to outreach. The upstream `anti_fabrication_mode` field is read; hard-fail stubs block all outreach drafting.
- `data/research/<prospect>.md`'s `verified` status — the JD must be `verified: yes` or the equivalent. Reaction-only signal refuses (the Sybill precedent).
- `knowledge/patterns/hiring-manager-not-recruiter.md` — the YLP target-selection pattern (15× rule).
- `knowledge/patterns/value-add-with-exit-clause.md` — the YLP touch-architecture pattern.
- `knowledge/patterns/operator-voice-warm.md` — the load-bearing voice-register pattern (formal body with 1-2 personal traces in load-bearing positions).
- `knowledge/contradictions/formal-vs-personal-voice-register.md` — the conditioning on register pick per destination.
- `knowledge/voice/how-we-write.md` — formal-register source rules (kill-list, em-dash discipline, throat-clearing).
- *(External, operator-specific)* your own operator-voice and writing-voice definitions — personal-register source (which traces are permitted).
- Yi Lin Pei, *How to Get a Referral* (Courageous Careers 2024) — the YLP framework source.

## Step 1: identify the hiring manager

The skill produces an identification report before drafting any touch.

- For a manager-level role (e.g. "Product Marketing Manager"), the HM is usually the Director of Product Marketing. Search `Product Marketing + <Company>`. Top result with the "hiring" badge is the HM.
- For a Head-of / VP role, the HM is the CMO / CRO / Founder/CEO depending on org shape. For founding-PMM roles at a startup, default to the Founder/CEO.
- For an unidentified prospect (the AI Rocketship case), the skill refuses and routes back to `prospect-identification`.

If the HM is unreachable (no LinkedIn profile, no public handle, no "hiring" badge, no recent activity), the skill produces an advocate-mapping report instead.

## Step 2: advocate-mapping (fallback)

- Peer in adjacent role at the company (e.g. another PMM, a Sr PMM, a Marketing Manager).
- Alumni overlap (same prior company as the operator).
- Mutual LinkedIn connection.
- Output: a ranked advocate list with 2-3 candidates, each with a one-line "why this person" rationale.

## Step 3: compose 2-3 touches per the YLP framework

| Touch | Channel | Length | Frame |
|---|---|---|---|
| 1 | linkedin-connect | ≤300 chars | Value-add hook + role-relevance one-liner. No ask. Connection request only. |
| 2 (post-connect) | linkedin-message | ≤900 chars | Setup (alternative-anchored opener per Pierri) + middle (specific relevance to the JD + operator-angle) + exit-clause close ("I know this is a lot to ask; if not, no worries — wish you a great day"). |
| 3 (optional follow-up after 5-7 days) | linkedin-message | ≤500 chars | Single nudge. Reference the original message. Exit-clause. No third follow-up — YLP rule. |

For advocate outreach, the third touch is replaced with an informational-interview ask (Calendly link, "20 minutes," exit clause).

For email instead of LinkedIn (when the HM has a public email and prefers it): same three-touch shape, longer body limits (subject 4-7 words, body 60-150 words).

### Voice register on every touch — operator-voice-warm

Per resolution #1 in `UPGRADES-2026-05-18.md` (Kesava 2026-05-18): the default register is formal operator-voice with **1-2 traces of personal voice in load-bearing positions** — *more human, not pure-formal*. See `knowledge/patterns/operator-voice-warm.md` for the canonical implementation.

**Body register is formal:**
- Kill-list applies: `orchestration`, `seamless`, `strategic`, `leverage`, `transform`, `holistic`, `synergy`, `bespoke`, `unlock`, `empower`, `streamline`, `optimize` (as adjective).
- No em dashes in body. (P.S. lines can carry a single em dash if it lands; body cannot.)
- No throat-clearing openers ("In today's rapidly evolving landscape", "As we navigate").
- Gary Provost cadence: short, medium, long; vary length within each touch.
- Past-tense (what was shipped) + future-tense (what I'd build); never first-person present-tense ramble.

**Permitted personal-voice traces (1-2 per touch, in load-bearing positions):**
- **Opener empathy beat:** a single phrase warmer than pure-formal would land. Example phrasings in a canonical 2026-05-08 outbound DM: *"That fits cleanly into my reality"* (preferred over the drier *"That window fits cleanly"*), *"Saw your post and it stayed with me"* (preferred over *"Saw your post"*).
- **One mid-body hedge or confession:** *"I have about 20 years..."* (preferred over *"20 years across..."*), *"this is a learning role for me, too"*, *"though I'm still learning myself"* appended after any large operator-claim. *"Comfort kills growth, and this feels like a good time to try again."*
- **P.S. or warm signoff:** YLP's P.S. shape — a genuine shared-context beat (alumni overlap, mutual friend, conference attended). Not invented. Outcomes presented as `+`-prefixed bullets, not `-` or `•`.

**Refused traces:**
- Multiple confessions per touch (one trace is calibration; two traces is the touch sliding to personal register).
- Throw-away humor that doesn't land (the recipient lacks parasocial context to anchor the joke).
- Em dashes in body for emphasis (em dashes are personal-LinkedIn signature; in outbound they read as AI-fingerprint).
- Generic "I'm thrilled to share" / "excited to announce" / "humbled by" (covered by kill-list).
- Self-praise modifiers (`world-class`, `best-in-class`, `industry-leading`, `robust`, `comprehensive`).

The asymmetric placement rule from `pat_operator-voice-warm`: warmth at opener + one mid-body line + exit clause + P.S. The body middle (where the operator-angle lives) is predominantly formal. Trace count is **2 maximum per touch**; voice-enforce hard-fails at 3+.

## Process

1. Preflight: validate prospect dossier exists, JD is verified, HM or advocate handle is provided. Refuse if any missing. If dossier is a hard-fail stub (per `prospect-identification`), refuse all drafting.
2. Run identification report: confirm HM is reachable; if not, escalate to advocate-mapping.
3. Read `data/research/<prospect>.md` for: status-quo competitor, ICP language, founder/CEO voice cues, the specific business problem the role exists to solve.
4. Compose touch 1 (connection request, ≤300 chars). Voice-enforce per operator-voice-warm; re-emit on fail. Trace count cap: 2.
5. Compose touch 2 (post-connect message, ≤900 chars). Open with the alternative-anchored hook (what the company is doing today that the operator's substrate addresses); middle with one specific operator-angle (the one substrate skill or prior engagement that's relevant); close with exit-clause. Voice-enforce per operator-voice-warm; re-emit on fail.
6. Compose touch 3 (optional follow-up). Voice-enforce per operator-voice-warm.
7. Write each touch to `<operator-outreach-dir>/<prospect>/<file>` with frontmatter. File structure per prospect:
   - `dm-connection-request.md` — touch 1
   - `dm-followup.md` — touch 2 (post-connect) and optional touch 3 (single nudge)
   - `email-parallel.md` — email-channel variant if the HM has a public email
   - `outreach-log.md` — timestamps of each touch sent, recipient response (when received), state transitions
   - `advocate-<handle>.md` — fallback when HM unreachable, one per advocate
8. Write the manifest at `<operator-outreach-dir>/<prospect>/manifest.md` summarizing: HM identified or advocate-mapped, touches composed, voice-enforce results, exit-clause present check, trace-count per touch.

## Output contract

```yaml
---
asset_type: hiring-side-outreach-touch
produced_by: referral-targeting
prospect: <slug>
role_title: <string>
jd_url: <url>
hm_or_advocate: <hm|advocate>
hm_handle: <linkedin-url|null>
advocate_handle: <linkedin-url|null>
touch_number: <1|2|3>
channel: <linkedin-connect|linkedin-message|email>
voice_enforce_status: <pass|fail>
character_count: <int>
exit_clause_present: <true|false>
substrate_cited:
  - data/research/<prospect>.md
  - knowledge/patterns/value-add-with-exit-clause.md
contradiction_positions:
  - personalization-vs-scale: <A|B>
  - formal-vs-personal-voice-register: <A|B>
position_rationale: <one sentence per contradiction>
---

# Touch N — <channel>

## Body
<the actual message body>

## Exit clause
<the closing one-liner that gives the recipient an out>

## Substrate cite (load-bearing claim)
<which line in the dossier the operator-angle is grounded in>
```

## Quality criteria

- Refuses without a verified JD. Reaction-only signal refuses (the Sybill precedent).
- Refuses against a hard-fail stub dossier (per `prospect-identification` and `con_hard-fail-vs-soft-fail-on-unidentified`).
- Refuses any touch that doesn't open with the alternative (status-quo or trigger), not the operator's pitch.
- Refuses any touch without an exit clause (YLP hard rule).
- Refuses third follow-ups within the same campaign (YLP rule: not more than twice).
- Voice-enforce hard-fail on operator-voice kill-list (`orchestration`, `seamless`, `strategic`, `leverage`, `transform`, `holistic`, `synergy`, `bespoke`, `unlock`, `empower`, `streamline`, `optimize` as adjective, plus em dashes in body).
- Voice-enforce hard-fail when personal-trace count exceeds 2 per touch (per `pat_operator-voice-warm`).
- Voice-enforce hard-fail when zero traces are present (pure-formal reads as posture; the touch needs at least one warmth beat at opener or signoff).
- Refuses if `--operator-angle` reads as generic ("I help PMMs scale" — fail; "I built the substrate that compresses your first 60 days as PMM" — pass).
- Refuses if the touch references a claim about the operator (case study, prior outcome) that isn't cited in their portfolio or substrate. Anti-fabrication applies to the operator's own claims too.

## Contradictions awareness

- `personalization-vs-scale` — default Position A (hand-personalize). Hiring-side outreach is by definition Tier 1A: one buyer, one operator-pursuit, hand-crafted. The skill refuses scale-templating across multiple prospects from one operator-angle.
- `formal-vs-personal-voice-register` — default Position A (formal operator-voice) with the operator-voice-warm trace allowance (per resolution #1 in `UPGRADES-2026-05-18.md`, Kesava 2026-05-18). The hiring-manager DM is outbound, not feed-content, so Position A applies. The override flag `--operator-angle-shape feed-response` permits a slightly warmer opener when the touch is genuinely responding to a public artifact the recipient wrote — but the body register stays formal, and the trace-count cap stays at 2.

## Refusal patterns

- `SUBSTRATE-GAP — prospect dossier missing` → run `prospect-identification` first.
- `MISSING-VERIFIED-JD` → reaction signal alone is not enough. Verify the JD before drafting.
- `NO-HM-OR-ADVOCATE` → both unreachable; the skill produces an identification report and stops. No outreach gets drafted.
- `VOICE-ENFORCE-FAIL` → re-emit; do not soft-fail.
- `MISSING-EXIT-CLAUSE` → re-emit; YLP rule is hard-fail.

## What this skill does NOT do

- Does not send the outreach. The operator sends it. Substrate writes; the operator ships.
- Does not negotiate the engagement. That's `engagement-shape-pricing` once the conversation opens.
- Does not write a referral message for an existing connection asking the operator for help. (Different shape — that's the operator's response, not their pursuit.)
- Does not generalize to B2B SaaS SDR cadences — that's `outbound-sequence-design`. The two skills share voice-enforce but the buyer shape is different.

## See also

- `skills/outbound-sequence-design/` — the B2B SaaS parallel skill.
- `skills/prospect-identification/` — runs before this skill when the company is anonymized; hard-fail stubs block all drafting.
- `skills/voice-enforce/` — composed on every touch.
- `data/research/` — the prospect dossier directory; this skill refuses without one.
- `knowledge/patterns/hiring-manager-not-recruiter.md` — the YLP 15× target-selection pattern.
- `knowledge/patterns/value-add-with-exit-clause.md` — the YLP touch-architecture pattern.
- `knowledge/patterns/operator-voice-warm.md` — the voice register (formal-with-traces).
- `knowledge/contradictions/formal-vs-personal-voice-register.md` — the conditioning rule.
- Yi Lin Pei, *How to Get a Referral* (Courageous Careers 2024) — the YLP framework source.
- `knowledge/voice/how-we-write.md` — formal-register source.
- *(External, operator-specific)* `<your-operator>/voice/` — personal-register source (the trace direction), operator-voice and kill-list definitions.
- *(External, output target — private to operator)* `<your-outreach-dir>/<prospect>/` — the output directory; outputs never commit to substrate.
- `UPGRADES-2026-05-18.md` — gap analysis that derived this skill (Resolutions #1 and #4 inline).

## Future work (deferred to substrate v1.7 back-half)

- Wire to `prospect-identification` so a hard-fail stub-dossier blocks outreach automatically at the framework level (today it's a manual preflight check).
- `account-pursuit-rhythm` composition: when a prospect's outreach is sent and no response after 7 days, escalate to advocate-mapping path automatically.
- Templates for the four file shapes (`dm-connection-request.md`, `dm-followup.md`, `email-parallel.md`, `outreach-log.md`) at `templates/referral-targeting/`.
