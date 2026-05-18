---
title: Q2 activation funnel audit — example client
asset_type: external-customer
produced_by: activation-funnel-audit
last_updated: 2026-05-08
substrate_consumed:
  - clients/example/00-INDEX.md
  - clients/example/icp/icp.md
  - clients/example/product-knowledge/product-knowledge.md
---

# Q2 activation audit — naming the activation event

This audit reads Q2 events exports and names the activation event by the procedure: pick candidate value events from product behavior; for each event, split users into "hit in window N" and "did not hit"; plot retention curves for each split; the candidate that produces the sharpest divergence is the aha moment. Activation is not "completed onboarding" or "logged in twice"; it is the first product event after which the retention curve bends up.

## Activation candidate test results

We tested four candidate value events against week-2 retention divergence on the May signup cohort. The procedure: cohort retention curves per candidate, by signup week, with the activated cohort defined as users who hit the candidate event within 24 hours of signup.

| Candidate event | Activated count | Activated week-2 retention | Non-activated week-2 retention | Divergence (pts) | Decision |
| --- | --- | --- | --- | --- | --- |
| `team_invite_sent` | 612 | 71% | 18% | 53 | Named the activation event |
| `first_value_event_x` | 388 | 64% | 22% | 42 | Strong but team_invite is sharper |
| `onboarding_completed` | 2,140 | 38% | 24% | 14 | Reject — UX milestone, not activation |
| `logged_in_twice` | 3,302 | 31% | 27% | 4 | Reject — vanity step |

The named activation event is `team_invite_sent` within 24 hours of signup. The candidate with the sharpest retention-curve divergence beat the runner-up by 11 points and beat onboarding-completion by 39 points. We refused to substitute a UX milestone (onboarding-completed) for the activation event when the behavioral event tested stronger; the sharpest-divergence candidate is the aha moment, by procedure.

## Cohort retention curves over blended retention rates

Reading retention as a curve per cohort, not a number per period. The blended week-2 retention this quarter is 35%, which hides the truth: the May 8 signup cohort retains at 48%, the May 15 cohort retains at 41%, the May 22 cohort retains at 28%, the May 29 cohort retains at 24%. Acquisition drift is showing in the cohort table, not in the blended number.

The cohort table by signup week with rows = cohorts and columns = weeks since signup is the floor artifact for this audit. Every downstream retention skill reads from it. Slope-change detection on the May 22 cohort flags it: the curve bent down versus the prior cohort even though the product did not change. The acquisition channel changed (a new paid surface activated mid-month), not the product.

Net dollar retention without cohort decomposition is board theatre; the same NDR can come from very different cohort shapes, and the shape determines what to do next. We refuse to read the blended rate without the cohort decomposition behind it.

## Funnel conversion

| Step | Count | Conversion to next |
| --- | --- | --- |
| Signup | 12,400 | — |
| Onboarding-started | 11,150 | 90% |
| Onboarding-completed | 7,800 | 70% |
| First-value-event-x | 4,920 | 63% |
| **Activation event (`team_invite_sent`)** | 1,840 | 37% |
| Week-1 active | 1,250 | 68% |
| Week-2 retained | 1,310 | 71% (of activated) |

The largest drop is between first-value-event and activation. The activated cohort retains at 71% at week-2; the non-activated cohort retains at 18%.

## Drop-off cohort segmentation

The drop between first-value-event and activation is most concentrated in two segments:

- Signup source = `paid_meta` (drop 78%, vs 52% blended). Aligns with the May 22 acquisition-drift cohort signal.
- Persona = `solo_user` (drop 81%, vs 52% blended). Solo users do not form teams and so cannot fire the team_invite event. Treat as a separate retention curve; do not optimize this cohort against the team-activation funnel.

## Time-to-aha statistics

Distribution of time from signup to `team_invite_sent` for users who ever activate: median 2 hours, p75 6 hours, p90 18 hours. The 24-hour window holds 91% of eventual activators; tightening to 12 hours would lose 18% of them.

## Substrate citations

The activation choice cites the candidate-test table row that named it. The cohort drift signal cites `clients/example/icp/icp.md` (paid_meta channel was added on 2026-05-22). The persona drop-off cites `clients/example/icp/icp.md` (solo_user persona axis).

## Refusal log

`logged_in_twice` and `onboarding_completed` produced divergences below the 10-point floor; we refused to name them as activation candidates. The first-value-event-x candidate produced a 42-point divergence, strong but secondary; we logged it for downstream skill use as a partial signal but did not name it the activation event.
