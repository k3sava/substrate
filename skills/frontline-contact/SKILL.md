---
name: frontline-contact
description: Parses interview transcripts and call notes from clients/<client>/voc/inbox/. Extracts themes via TF-IDF over noun-phrases plus a manual taxonomy (jobs-to-be-done, objections, alternatives-considered, words-they-use). Scores transcript quality (open-question ratio, customer-language presence, time-on-call). Writes structured findings to clients/<client>/voc/findings/. Refuses on under three logged calls per quarter.
version: 2.0
amplifies: PMM, growth lead, founder, CS, sales engineer
masters: Bob Moesta (JTBD interviews surface customer language and switch trigger), April Dunford (sales detects positioning failure first; test positioning in live pitch), Martina Lauchengco (PMM owns market→product and product→market loops), Patrick Campbell (without weekly customer calls, you have a guess not a strategy), Brendan Hufford (3S content from Sales/Success/Support, not keyword tools), Tony Hsieh (every new hire including the CFO does four weeks on the customer phones), Chris Orlob (POV-led outbound requires real call/research input), Andy Crestodina (message mining for verbatim customer language), Joanna Wiebe (customer language as copy substrate)
substrate_layers_required: [voc, icp, positioning]
patterns_grounded: [frontline-as-pmm-substrate, rapport-surfaces-what-research-cannot, diagnose-before-execute, jtbd-as-buyer-mental-model, tf-idf-themes-from-customer-language]
preflight_refusal: substrate-gap, missing-cadence-contract, too-few-logs
required_reads:
  - clients/{client}/voc/cadence-contract.md
---

# frontline-contact

## Purpose

Parse the conversation logs that already exist into operating substrate. Without a logged conversation, every pricing, positioning, and content decision is a guess. This skill enforces the cadence, ingests the conversation log into the VoC layer, runs verbatim language extraction (TF-IDF over noun-phrases), runs a manual taxonomy classifier (JTBD, objections, alternatives, words-they-use), and refuses to advance work that isn't sourced from at least three logged conversations per quarter.

## Inputs

- `--client <client>` (required)
- `--mode <harvest|score|both>` (default both): harvest extracts themes from inbox; score runs quality on each transcript.
- `--call-type <discovery|customer-interview|support-call|win-interview|loss-interview|all>` (default all)
- `--min-quarter-logs <n>` (default 3): refuse if fewer than n logs in the trailing quarter.
- `--top-themes <n>` (default 12): how many noun-phrases to surface per category.

## Substrate reads

- `voc/cadence-contract.md`: written weekly customer-contact cadence per role.
- `voc/inbox/<YYYY-MM-DD>-*.md`: raw call transcripts and notes (one file per call).
- `voc/findings/`: previous findings (skill is idempotent; new file per run-date).
- `icp/` and `positioning/` for cross-reference when classifying alternatives.

## Output contract

- `voc/findings/<run-date>.md`: structured findings with sections per category (JTBD, objections, alternatives, words-they-use, quality-scores), citations to the source file per phrase.
- `voc/findings/<run-date>.json`: machine-readable extract with phrase frequencies, theme clusters, and quality scores per source file.
- A patch proposal queued for `signal-routine.md` if a theme exceeds the new-signal threshold (frequency ≥ 3 across 3+ distinct calls).

## Quality criteria

- Refuses to harvest with fewer than 3 logged calls in the trailing quarter (cite frontline-as-pmm-substrate, diagnose-before-execute).
- Refuses transcripts without timestamps or speaker labels (need both for open-question ratio + time-on-call).
- Surfaces cadence misses (e.g., "Sales has not logged a customer call in 14 days") to the operator review queue.
- Each extracted phrase carries the source file path and approximate position. No paraphrase. No fabrication.

## What this skill does NOT do

- Does not write content (use `narrative-compose`, `lp-ship`, `narrative-strategy`).
- Does not score positioning fit (use `positioning-forge`).
- Does not interview the customer for you. The point is human contact.

## See also

- `routines/signal-routine.md`: processes the signals this skill captures.
- `skills/win-loss-interview/`: structured win/loss form.
- `skills/tactical-empathy-discovery/`: Voss-pattern interview craft.
- `knowledge/patterns/frontline-as-pmm-substrate.md`: load-bearing pattern.
- `knowledge/patterns/tf-idf-themes-from-customer-language.md`: extraction methodology.
- `knowledge/patterns/jtbd-as-buyer-mental-model.md`: classification taxonomy.
