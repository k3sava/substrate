---
id: pat_event-taxonomy-as-product-knowledge
title: Event schema is product knowledge, not a marketing afterthought; the taxonomy is the contract between product, analytics, and growth
captured_date: 2026-05-08
convergence_count: 3
tier: A
domains: [analytics-attribution, product, growth]
---

# Event taxonomy is product knowledge

## Convergence

Three operators with analytics-implementation track records converge on the same anti-pattern fix: when event tracking is treated as "marketing's data feed," the schema rots within a quarter. Events get added by whoever needs a number, named in inconsistent shapes, missing properties, duplicated under near-identical names, and the resulting analytics warehouse becomes uninterpretable to anyone who didn't write the events themselves. The fix is to treat the event taxonomy as a first-class product artifact, owned and gated like an API contract. Every event has a single canonical name, a documented purpose, a typed property set, an owner, and a versioning policy. New events go through review the way new API endpoints go through review.

The shape repeats: taxonomy-as-contract, owner-per-event, schema-as-code, review-on-add. Operators differ on the tooling (some advocate Iteratively / Avo / Snowplow schema registries, others advocate a YAML file in the product repo) but converge on the structural claim. A team without a versioned event taxonomy is operating on schema-drift substrate; the taxonomy is what makes the analytics warehouse trustworthy.

## Operators

- **Iris Vaknin**, analytics consultant and ex-Mixpanel solutions architect. Vaknin has argued in industry talks and posts that "the event you didn't define is the event you can't trust." Her implementation playbooks treat the tracking plan as the deliverable: schema before code, naming convention before instrumentation, property dictionary before any event lands in production. Without the plan, every analytics question becomes a forensic exercise.
- **Yali Sassoon**, co-founder of Snowplow. Sassoon's writing centers on events-as-rich-data, not events-as-counters. A Snowplow event carries dozens of structured properties; the value is in the schema. Sassoon argues the team that tracks "page_view" without dimensions is doing the work of tracking with none of the value of tracking. Schema design is the work; event firing is the by-product.
- **Mike Kitchen**, ex-Amplitude product manager and analytics-engineering writer. Kitchen has published widely on event-naming conventions (object_action, snake_case, present-tense), property-typing (string vs number vs boolean discipline), and the politics of who owns the taxonomy (the analytics-engineer role exists because no one else will). His "Tracking Plan as a First-Class Citizen" essays are the source most teams cite when they finally build a taxonomy.

## Variation

- Vaknin frames it through the *implementation-playbook lens* (the plan is the deliverable).
- Sassoon frames it through the *rich-data lens* (the value is in the schema).
- Kitchen frames it through the *role-and-naming lens* (the analytics-engineer owns the taxonomy because no one else will).
- Convergence: events without a versioned schema are not data; they are a maintenance liability.

## Implication

A team's event taxonomy carries the same weight as the product's API surface, and earns the same review discipline. Adding an event is a code review. Renaming an event is a breaking change with a migration plan. Property typing is enforced by schema. Duplicate near-named events are bugs.

The substrate hooks are concrete: an `events.yaml` file in the client substrate is the canonical taxonomy. Every event has a canonical name (object_action, snake_case), a one-sentence description, a typed property list, an owner, a `last_observed` date for decay tracking, and an `icp_cells` annotation for cohort routing. Skills that read events read the taxonomy file first, refuse if it is missing, and warn if events fired in production are not represented in the file (drift).

The auditor pattern: a quarterly `event-taxonomy-audit` reads the taxonomy and the production event stream, surfaces drift (events fired but undeclared, events declared but unfired, near-duplicate names, missing properties on declared events), and produces a remediation list. Without this audit, the taxonomy is documentation; with it, the taxonomy is the contract.

Skills that touch events without naming the taxonomy file are operating on guess substrate. Skills that touch events while ignoring the audit are operating on stale substrate.

## Sources

- Iris Vaknin, analytics-implementation talks at Measure Camp and various analytics conferences; published implementation playbooks circulating in the analytics-engineering community.
- Yali Sassoon, "Why we built Snowplow" and follow-on posts at snowplow.io / discourse.snowplow.io on event-as-rich-data design philosophy.
- Mike Kitchen, "Tracking Plan as a First-Class Citizen" and related essays on amplitude.com / analytics-engineering blogs on naming conventions, property typing, and analytics-engineer ownership.
