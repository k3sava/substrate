---
layer: 3 (voice-of-customer)
client: <project-slug>
last_updated: <YYYY-MM-DD>
freshness_window_days: 30
---

# VoC cadence contract

The written commitment that frontline customer contact is the substrate, not desk research. Per `knowledge/patterns/frontline-as-pmm-substrate.md`. Without this contract, every pricing, positioning, and content decision is a guess.

## Per-role weekly cadence

| Role | Cadence | Target | Source |
|---|---|---|---|
| Founder / CEO | 2 customer calls / week | first-30-days customers | live calls |
| PMM lead | 5 customer calls / week | mix: prospects, recent buyers, churned | live + Gong/Chorus |
| Head of Sales | 1 win-interview / week | closed-won within 30 days | structured interview |
| CS lead | 1 churn-interview / month | churned within 30 days | structured interview |
| Product lead | 2 user calls / week | early adopters of new features | live calls |
| Support lead | 1 trends-extract / week | top tickets, bug categories | tickets + chats |

## Logging contract

Every call gets a transcript file in `voc/inbox/` with this filename convention:

```
<YYYY-MM-DD>-<call-type>-<participant-or-deal-id>.md
```

Where `<call-type>` is one of: `discovery`, `customer-interview`, `support-call`, `win-interview`, `loss-interview`, `churn-interview`, `user-research`.

The file must include:

- Speaker labels on every line.
- Timestamps (at least one per minute).
- The participant's role and company size.
- The CRM deal-id or account-id where applicable.

## Refusal patterns

- A call without a logged transcript is not a call. Per the substrate-cite rule.
- A team member who has not logged a customer call in 14 days surfaces in the operator review queue.
- A quarter with fewer than 3 logged calls per role refuses to advance positioning, messaging, or ICP work.

## Reviewable

This contract is reviewed every quarter. If a role's cadence is not being kept, the contract is broken; do not soften the cadence to match what the role is actually doing. Either the role's responsibilities change, or the role does the calls.
