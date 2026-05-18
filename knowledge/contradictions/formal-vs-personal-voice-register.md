---
id: con_formal-vs-personal-voice-register
title: Formal operator-voice vs personal-voice register for outbound touches
captured_date: 2026-05-18
---

# Formal-vs-personal voice register

## Position A — formal operator-voice; outbound is claim-bearing, kill-list-clean, asymmetric warmth in load-bearing positions
- Operator: Kesava (`ins_kesava-voice-register-rule`), Yi Lin Pei (`ins_ylp-formal-with-pscript-warmth`), Anthony Pierri (`ins_pierri-alternative-anchored-opener`)
- Claim: outbound (cold DMs, cover letters, fractional pitches, hiring-manager messages) leads with what the operator built and shipped. Body copy is formal — no em dashes, kill-list applied, Gary Provost cadence, no throat-clearing openers. One to two *traces of personal voice* are permitted in load-bearing positions (opener empathy beat, one mid-body hedge or confession, exit clause, P.S./signoff). Pure-formal touches read as posture; pure-personal touches read as unprofessional; the formal-with-traces register is the trust-building shape. See `pat_operator-voice-warm` for the canonical implementation.

## Position B — personal-LinkedIn register; first-person present-tense, mid-sentence personality, throw-away humor
- Operator: Kesava (`ins_kesava-personal-writing-rule`), Justin Welsh (`ins_welsh-creator-not-corporate`), Lara Acosta (`ins_acosta-feed-content-as-personal-thinking`)
- Claim: public posts (LinkedIn feed, blog posts on iamkesava.com, /about pages, casual chat) use first-person present-tense, mid-sentence personality injection, throw-away humor, occasional self-deprecating confession, direct reader address. The personal register is "someone thinking aloud who happens to write well" — Kesava's mode, distinct from Claude's default "polished essay" mode. Operator-voice in a LinkedIn post reads as posture; personal voice in a cold DM reads as unprofessional. 

## Conditions distinguishing them

- **Destination** is the dominant variable. Outbound (DM, cover letter, pitch artifact, deck cover) → Position A (formal). Feed-content (LinkedIn post, blog, public byline) → Position B (personal). The destination determines the register; the writer doesn't.
- **Recipient's parasocial context**: outbound recipients (hiring managers, founders, peer operators) don't have the parasocial context that LinkedIn feed-followers have. Throw-away humor that lands in feed-content falls flat in outbound because the recipient doesn't have the prior reads to anchor the joke.
- **Shape of the artifact**: outbound is past-tense (what was shipped) + future-tense (what I'd build). Personal writing is first-person present-tense (what I'm doing / thinking now). The tense pick is itself a register signal.
- **One-to-one vs one-to-many**: outbound is one-to-one (the touch lands in a single inbox). Feed-content is one-to-many (the post is read by a feed of followers). One-to-one earns the asymmetric-warmth shape (Grant); one-to-many earns the throw-away-humor shape (Welsh, Acosta).
- **Override for feed-shaped outbound**: when the operator-angle is *I read your post on X and have built Y in response*, the touch's opener is feed-content-shaped (referencing the recipient's public artifact). The override allows a slightly warmer opener while keeping the body formal. The trace count stays at 2 — not a slide back to personal register.

## Resolution / synthesis

Not orthogonal; both can be true at different destinations inside the same operator's writing pipeline. The genuine contradiction is in *default register pick per surface*:

- LinkedIn feed post → personal register (Position B). Pure-formal here reads as posture; the operator burns the feed by sounding like a brand.
- Cover letter / outbound DM / consulting cold pitch → formal operator-voice with traces (Position A). Pure-personal here reads as unprofessional; the operator loses credibility before the claim lands.
- Blog post on iamkesava.com → personal register (Position B). The byline carries personal voice; the operator-voice rules don't apply.
- /about page on iamkesava.com → personal register with operator-credentials embedded. The operator credentials are claim-bearing but the surrounding prose is personal.
- Wiki page (internal substrate, not outbound) → looser register; personal voice acceptable; operator-voice rules apply only when the page becomes outbound (portfolio-foundation, career-ops, certain companies/* pages).
- Outbound-shaped feed-content (a LinkedIn post addressed *to* a specific recipient, e.g., a public reply): hybrid — feed-shape carries personal register, but the addressed-recipient context borrows the formal-with-traces shape from outbound.

## How substrate uses this contradiction

`referral-targeting` reads this contradiction's `Conditions` section and picks the default register per touch:

- `--touch-channel linkedin-connect` or `linkedin-message` or `email` (all outbound) → Position A (formal operator-voice with traces, per `pat_operator-voice-warm`).
- Override flag `--operator-angle-shape feed-response` (when the operator-angle is responding to the recipient's public artifact) → still Position A, but opener can be slightly warmer; voice-enforce trace-count cap stays at 2.

The position is recorded on the output artifact (`contradiction_positions.formal-vs-personal-voice-register: <A|B>`). The default for `referral-targeting` is A; B is the operator's manual override only when the touch is genuinely feed-content-shaped (rare).

`voice-enforce` reads the recorded position and gates the touch accordingly. A touch tagged A that hits 3+ personal-trace markers fails; a touch tagged B that strips all personality fails on the opposite axis.

## Related

- `pat_operator-voice-warm` — the canonical Position-A implementation
- `wiki/concepts/operator-voice.md` — the formal-register source
- `wiki/concepts/writing-voice.md` — the personal-register source (the 10-point calibration)
- `wiki/concepts/ai-fingerprint.md` — pattern-detection defense rules
- `feedback_kesava_voice_registers.md` (memory) — the two-register rule
- `feedback_dm_voice_calibration.md` (memory) — canonical phrasings from a 2026-05-08 outbound DM iteration
- `feedback_personal_writing_voice.md` (memory) — the first-person present-tense rule for personal writing
