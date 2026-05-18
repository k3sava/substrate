---
id: pat_engagement-decay-as-relevance-signal
title: Engagement decay is a relevance signal first, a deliverability problem second
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_geisler-onboarding-not-broadcast, ins_kotlyar-segment-or-die, ins_capstraw-engagement-as-permission, ins_postmaster-engagement-shapes-inbox-placement]
domains: [lifecycle, growth, email]
---

# Engagement decay is a relevance signal first, a deliverability problem second

## Convergence

Four operators converge on a counterintuitive claim: when open and click rates fall on a lifecycle program, the first hypothesis is not "we're hitting the spam folder" but "the message stopped matching the audience." Cleaning the list, warming new IPs, and re-tuning DKIM follow only after the relevance hypothesis is tested. Inverting the order is the most common diagnostic error in lifecycle marketing because list-cleaning feels safe and segmentation feels risky.

## Operators

- Val Geisler, `ins_geisler-onboarding-not-broadcast`. Geisler's lifecycle teardowns at Klaviyo and her independent practice argue that broadcast nurtures decay because the message was never anchored to a buyer state in the first place. The fix is segmentation by behavior, not list pruning. Background: former Head of Customer Acquisition at Klaviyo, lifecycle teardowns at valgeisler.com.
- Brian Kotlyar, `ins_kotlyar-segment-or-die`. Kotlyar's writing on lifecycle (former demand-gen lead at Hightouch and Segment) names the trap: when broadcast performance falls, marketers add list hygiene before they add segments. Both help, but only segmentation addresses the root.
- Jen Capstraw, `ins_capstraw-engagement-as-permission`. Capstraw, co-founder of Women of Email and longtime ESP-side strategist, frames engagement as a renewing permission contract: a subscriber's continued opens and clicks are an ongoing yes. Decay means the contract is silently revoked; the message changed without renegotiation.
- Postmaster guidance from Gmail, Microsoft, AOL/Yahoo, `ins_postmaster-engagement-shapes-inbox-placement`. Mailbox providers publicly state that engagement signals (opens, replies, "this is not spam") shape inbox placement, but those signals lag. By the time deliverability dashboards turn red, the relevance break already happened.

## Variation

- Geisler frames the *editorial fix*, rewrite for buyer state, segment, send less.
- Kotlyar frames the *operating sequence*, segment first, then prune.
- Capstraw frames the *contract metaphor*, permission renews through engagement.
- Mailbox providers frame the *causal chain*, relevance drives engagement, engagement shapes inbox placement, inbox placement shows up as deliverability.
- Convergence: deliverability dashboards are a downstream symptom. Pulling the relevance lever fixes both; pulling only the deliverability lever fixes neither.

## Implication

When a lifecycle program's open or click rate decays beyond noise, run this order:

1. Pull the cohort definition and ask, "what changed about this audience between when this sequence was written and now?" Onboarding shape, product surface, ICP composition, recent campaign exposure.
2. Audit the trigger, not the body copy. Triggers built on stale events keep firing on people who already moved past the moment.
3. Test segmentation against the same content first, smaller cohort, sharper trigger, before testing new content against the broad list.
4. Only after the relevance hypothesis is tested or rejected do you escalate to deliverability work (auth, IP warm-up, list pruning).

The skill that watches for this signal is `email-engagement-decay-watcher`. The skill that fixes the segmentation root is `email-cohort-trigger`. List hygiene (`email-list-hygiene`) addresses the symptom downstream, not the root cause upstream.

## Counter-evidence

- Genuine deliverability events (a blacklist hit, a sudden DMARC failure on a forgotten subdomain, an IP warming gone wrong) produce engagement decay that is not a relevance issue. The signal is the *shape* of the decay, not the existence of decay. Sudden cliff across all sequences = deliverability. Gradual taper on one sequence = relevance. The watcher skill flags the shape and suggests which hypothesis to chase first.
- Consumer commerce with high cadence (daily-deal email, content publishers) has a different decay shape than B2B SaaS lifecycle. Operators in those motions calibrate the watcher window differently.

## Sources

- ins_geisler-onboarding-not-broadcast, Val Geisler (lifecycle teardowns; former Klaviyo Head of Customer Acquisition)
- ins_kotlyar-segment-or-die, Brian Kotlyar (former demand-gen at Segment + Hightouch; "Department of Demand")
- ins_capstraw-engagement-as-permission, Jen Capstraw (co-founder Women of Email; longtime email strategist)
- ins_postmaster-engagement-shapes-inbox-placement, Gmail Postmaster Tools + Microsoft SNDS + Yahoo Sender Hub public guidance
