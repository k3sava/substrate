---
name: allowed-claims-register
description: Given a client's load-bearing public surfaces (LP, press, blog, sales deck, investor deck), produce the procurement-defensible register where each numeric or superlative claim carries attribution, operational definition, source-of-truth, comparison anchor, audit trail, and the surfaces it can ship on. Flags procurement-failure claims.
version: 0.1
amplifies: PMM, founding marketer, AE bench, RevOps
masters: April Dunford (positioning claims must be defensible against the alternative), Anthony Pierri (operational definition over claim grandeur), Andy Raskin (proof-line discipline), Peep Laja (CRO grade: every claim with a comparison anchor and a window), Bev Burgess (1-to-1 ABM materials gated by procurement-defended claims)
substrate_layers_required: [positioning, market-context]
patterns_grounded: [evidence-ladder, anti-fabrication, copywriting-craft-fundamentals]
contradictions_aware: [verified-vs-self-reported, claim-grandeur-vs-procurement-defense]
preflight_refusal: substrate-gap, missing-surfaces, no-claims-found
required_reads:
  - clients/{client}/positioning/
---

# allowed-claims-register

## Purpose

Every claim above $50K ARR triggers procurement scrutiny. Without an allowed-claims register, every discovery call back-tracks to "what do you mean by 3x faster?" With one, the AE hands over a single document and the buyer's security review reads it in 30 minutes. The register is the artifact that compounds founder credibility into the AE bench.

Four top-10 consulting prospects asked for it directly — across AI-native Series A/B companies where the claims library was verbal, team-irreproducible, or unverified. The pattern is universal: founders ship claims verbally; the team cannot reproduce them under scrutiny; deals stall. The register closes that gap.

## Inputs

- `--client <client>` (required)
- `--surfaces <path-or-url>` (required, repeatable) — homepage HTML, pricing page, press release markdown, sales deck export, investor deck, blog posts
- `--output <path>` (default: `clients/<client>/allowed-claims-register.md`)

## Substrate reads

- `clients/<client>/positioning/positioning-canonical-statement.md` for thesis alignment
- `clients/<client>/competitive/` for comparison anchors
- `clients/<client>/voc/processed/` for customer-language patterns the claim should echo

## Process

1. Preflight: validate the client root and at least one surface input.
2. For each surface, fetch the text (read file OR HTTP GET the URL with a short timeout). Strip HTML tags to plain text.
3. Scan each surface for numeric claims using the canonical regex (digits + unit token).
4. Scan each surface for superlative claims (first, only, fastest, cheapest, biggest, largest, best, most + up to 5 trailing words).
5. Dedupe claims that appear on multiple surfaces; track every surface a claim appears on.
6. For each claim, mark default attribution as `self-reported`. Mark operational definition and source-of-truth as `TBD` placeholders.
7. Compose the register table with the nine canonical columns.
8. Flag procurement-failure claims: any claim with no operational definition or no comparison anchor goes into the "DO NOT SHIP" section with a remediation hint.
9. Emit the register file with frontmatter, the table, the failure section, and an audit-cadence block.

## Output contract

```
clients/<client>/allowed-claims-register.md
```

Sections:
- Frontmatter (title, client, last_compiled, review_cadence, produced_by)
- Allowed claims table (Claim, Attribution, Source of truth, Operational definition, Time period, Comparison anchor, Audit trail, Allowed surfaces, Status)
- Procurement-failure claims (DO NOT SHIP) with remediation hints
- Surfaces register (which claims ship where)
- Audit cadence (monthly re-verify, quarterly strike-decayed, on-change re-verify)

## Quality criteria

- Refuses without at least one surface input that resolves to text.
- Refuses if zero numeric and zero superlative claims are extracted (surface may be locked behind JS; expand to text-rendered alternative).
- Every claim carries an attribution tier in its row; default is `self-reported`.
- Operational definition placeholder is `TBD` until the operator fills it; rows with `TBD` cannot be cited by `pre-publish-check`.
- Surfaces are tracked per claim so the operator can see which page a stale claim still lives on.

## Refusal patterns

- No surfaces resolve to text → refuse; expand surface list or fall back to a manual scrape.
- Surface returns HTML that is mostly JS-driven (text length less than 500 chars after strip) → soft warn; flag the surface as "thin extraction" in the register footer.
- Network surface times out → soft warn; mark surface as "unreachable at compile time" and continue.

## What this skill does NOT do

- Does NOT replace `claim-verify` — that gates each claim one at a time against substrate citations.
- Does NOT replace `pre-publish-check` — that gates the whole asset.
- This skill produces the register both gates read against.
- Does NOT fill in operational definitions or source-of-truth systems; those require the operator's investigation pass.

## See also

- `skills/claim-verify/` — per-claim gate that reads the register.
- `skills/pre-publish-check/` — composite gate that reads the register.
- `skills/case-study-compose/` — case studies cite the operational_definition from the register.
- `skills/positioning-forge/` — produces the canonical statement the register's thesis alignment runs against.
- `knowledge/patterns/evidence-ladder.md`.
- `knowledge/patterns/anti-fabrication.md`.
