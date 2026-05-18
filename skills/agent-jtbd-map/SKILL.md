---
name: agent-jtbd-map
description: Maps each AI agent in the client's product to a named jobs-to-be-done with a named human checkpoint and a class. Reads clients/<client>/product/agents.yaml, validates each entry against a JTBD catalog, applies team-shape vs tool-shape per the contradiction's conditioning, and outputs a wiring diagram + checkpoint contract.
version: 2.0
amplifies: founder, RevOps lead, head of marketing, head of GTM, head of product
masters: Evan Spiegel (map agents 1:1 to enumerated JTBD, not abstract layers), Yamini Rangan (HubSpot 9-agent flywheel, one named agent per job), Kieran Flanagan (cross-functional pod owns AI in GTM, not a bolt-on), Claire Vo (progressive trust onboarding, named tiers), Hamza Farooq (three-class agent taxonomy), Aishwarya Naresh Reganti (CCCD, continuous calibration / continuous development), Amol Avasare (CASH four-stage growth automation), Boris Cherny (give the model tools and a goal; don't box it in)
substrate_layers_required: [strategy, product-knowledge]
patterns_grounded: [agents-mapped-to-jtbd, agent-first-gtm, agents-as-product-users, substrate-runs-loop-humans-run-alignment, jtbd-as-buyer-mental-model]
contradictions_aware: [agents-as-team-vs-agents-as-tools]
preflight_refusal: substrate-gap, missing-agents-yaml, missing-jtbd-list
required_reads:
  - knowledge/patterns/agents-mapped-to-jtbd.md
  - knowledge/contradictions/agents-as-team-vs-agents-as-tools.md
---

# agent-jtbd-map

## Purpose

Refuse abstraction. Every agent has a name, a job, a checkpoint, a class. This skill produces the wiring diagram that pins each agent to a JTBD, names the human checkpoint, applies the right shape (team vs tool) per the contradiction conditioning, and emits a checkpoint contract that downstream skills (eval-rubric, capability-pin, goal-routine) consume.

## Inputs

- `--client <client>` (required)
- `--scope <function|stack|cross-stack>` (e.g. function=marketing, stack=customer-support, cross-stack=outbound-pipeline). Default `cross-stack`.
- `--mode <draft|refresh|audit>` (default draft).
- `--agents-yaml <path>` (default `clients/<client>/product/agents.yaml`).
- `--jtbd-list <path>` (default `clients/<client>/strategy/jtbd-list.md`).

## Required input: `agents.yaml`

The file is per-client. The skill refuses without it. Schema:

```yaml
agents:
  - name: "Inbound Triage Agent"
    jtbd: "Help me [verb] [object] when [situation]"
    persistence: "persistent" | "ephemeral"
    heterogeneity: "heterogeneous" | "homogeneous"
    trust_tier_current: "review-all" | "spot-check" | "exception-only" | "unattended"
    human_checkpoint: "Sales Manager (per-shift review)"
    escalation_trigger: "deal value > $25k OR sentiment < -0.3"
    loop_class: "tier-1-assistive" | "tier-2-autonomous-scoped" | "tier-3-system-level"
    operating_loop: "CASH-collect" | "CASH-automate" | "CASH-scale" | "CASH-hire" | "CCCD-calibrate" | "CCCD-develop"
    last_60d_run_history:
      runs_total: 4200
      exceptions: 7
      exception_rate_pct: 0.17
```

## Output contract

- `clients/<client>/strategy/agent-jtbd-map-<date>.md`: full wiring diagram with one row per agent, picked-shape rationale, and checkpoint contract.
- `clients/<client>/strategy/agent-jtbd-map-<date>.json`: structured form.
- `clients/<client>/strategy/agent-jtbd-checkpoint-contract-<date>.md`: per-agent contract a human can sign off on (named owner, review cadence, kill-switch).

## Contradiction handling: agents-as-team-vs-agents-as-tools

The contradiction `agents-as-team-vs-agents-as-tools` says persistence + heterogeneity decides shape:

- **Heterogeneous, persistent JTBD** → team-shape (Vo). Named identities, scoped contexts, progressive trust.
- **Homogeneous, ephemeral, goal-bound** → tool-shape (Cherny). Minimal scaffolding, give the goal, stay out.

The skill picks per-agent based on the `persistence` and `heterogeneity` fields in `agents.yaml`. The picked shape and rationale are logged on each row of the wiring diagram. The skill refuses to pick a global default; per-agent picks are mandatory.

## Quality criteria

- Refuses to map an agent without a JTBD in the `Help me [verb] [object] when [situation]` form. "AI in marketing" is not a JTBD.
- Refuses to assign tier-3 (system-level) trust without a 60-day exception-only run history. Validation: `last_60d_run_history.exception_rate_pct < 1.0` AND `runs_total >= 100`.
- Flags JTBD coverage gaps: jobs in `strategy/jtbd-list.md` with no agent assigned, or agents with no JTBD.
- Refuses upgrade to higher trust tier without `last_60d_run_history` evidence in the file.

## Trust tier ladder (Vo)

1. **review-all**: every output is reviewed by a named human before it ships.
2. **spot-check**: a sample (≥10%) is reviewed; the rest ships.
3. **exception-only**: only outputs the agent flagged for human review are reviewed.
4. **unattended**: agent ships without human review; kill-switch and escalation-trigger active.

The skill validates the requested tier against the `last_60d_run_history` and refuses to advance without evidence.

## Loop class (Farooq taxonomy)

- **tier-1-assistive**: agent suggests; human acts. Low risk, low autonomy.
- **tier-2-autonomous-scoped**: agent acts within a defined scope; human reviews exceptions.
- **tier-3-system-level**: agent acts across systems; review-by-exception; high autonomy.

## Operating loop

- **CASH (Avasare)**: Collect → Automate → Scale → Hire. The four-stage growth automation; agents handle inner stages, humans handle alignment.
- **CCCD (Reganti)**: Continuous Calibration, Continuous Development. Humans calibrate; agents develop.

The skill expects each agent to declare which stage of which loop it occupies.

## See also

- `routines/goal-routine.md`: where the agent's measurement contracts live.
- `skills/eval-rubric/`: how the agent's output gets evaluated.
- `skills/capability-pin/`: which capability class each agent is pinned to.
- `knowledge/patterns/agents-mapped-to-jtbd.md`.
- `knowledge/patterns/agent-first-gtm.md`.
- `knowledge/contradictions/agents-as-team-vs-agents-as-tools.md`.
