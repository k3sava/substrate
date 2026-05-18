---
name: eval-rubric
description: Builds and runs binary, single-judge evaluation rubrics on AI-generated outputs. Treats evals as data analysis, not subjective review. Operationalises the codex pattern that evals work when judges are single, criteria are binary, and the rubric is data.
version: 0.1
amplifies: any operator shipping AI-generated output
masters: Hamel Husain + Shreya Shankar (Your AI Product Needs Evals — single judge, binary rubrics, error analysis as the bottleneck), Cat Wu (Anthropic — evals as the daily drumbeat), Aishwarya Naresh Reganti (CCCD, continuous calibration), Eugene Yan (eval-driven dev for LLM apps), Greg Brockman (eval = product spec)
substrate_layers_required: [strategy, brand-voice]
patterns_grounded: [eval-as-data-analysis, verification-as-human-job, substrate-runs-loop-humans-run-alignment]
preflight_refusal: substrate-gap, missing-rubric, multiple-judges
required_reads:
  - clients/{client}/brand-voice/voice-guide.md
  - clients/{client}/strategy/quality-bar.md
---

# eval-rubric

## Purpose

Most teams "review" AI output as a vibe check. The codex pattern says evals work when:
- Each criterion is binary (pass/fail, not 1-5).
- A single human judge per rubric run, not committee.
- The output is a dataset you can analyse, not a feeling you can argue with.

This skill builds the rubric, runs it, and emits a dataset.

## Inputs

- `--client <client>` (required)
- `--target-skill <skill-name>` (the skill whose output is being evaluated)
- `--mode <build-rubric|run-eval|error-analyse>`
- `--samples <n>` (default 30, minimum 20 for statistical signal)

## Rubric structure

Each rubric carries:
- 5–15 binary criteria, each with a one-line pass/fail definition.
- A single named judge.
- A test set of N samples, including known-good and known-bad anchors.
- A pre-registered prediction (what % pass rate the operator predicts).

## Substrate reads

- `brand-voice/voice-guide.md`, voice criteria.
- `strategy/quality-bar.md`, quality criteria.
- The target skill's own output contract (what counts as a complete output).

## Output contract

- `evals/<target-skill>/rubric.md`, the rubric definition.
- `evals/<target-skill>/runs/<date>.jsonl`, one row per sample, columns = criteria, values = pass/fail, judge initials, timestamp.
- `evals/<target-skill>/error-analysis.md`, clusters of failure modes.
- A Brier-trackable prediction in the calibration ledger.

## Quality criteria

- Refuses to ship without binary criteria. "Quality 1-5" is not a rubric.
- Refuses to merge runs from multiple judges into a single dataset; multi-judge runs require explicit IRR analysis.
- Flags rubric drift: when the same input gets different verdicts on re-run.

## What error analysis looks like

Per Hamel/Shreya: the bottleneck is reading 30 traces and clustering failures. Don't optimise the rubric until you've read the failures. Cluster, name, prioritise by frequency × severity. The rubric improves once per cluster, not per gut feel.

## See also

- `skills/score-goal/`, where the eval results feed the calibration tracker.
- `skills/audience-test/`, the buyer-panel side of evaluation.
- `skills/pre-publish-check/`, the gate that may use eval output as a signal.
- `knowledge/patterns/eval-as-data-analysis.md`.
