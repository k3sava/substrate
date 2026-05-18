---
id: pat_jtbd-as-buyer-mental-model
title: Jobs-to-be-done is the buyer mental model, not a product feature framework
captured_date: 2026-05-08
convergence_count: 4
tier: A
uses_cards: [ins_jtbd-interviews-surface-customer-language, ins_christensen-milkshake-jtbd, ins_ulwick-outcomes-as-jobs, ins_moesta-forces-of-progress, ins_use-case-epiphany-as-marketing-job]
domains: [pmm, gtm, product, research-discovery]
---

# Jobs-to-be-done is the buyer mental model

## Convergence

Four operators who built the JTBD discipline (Christensen, Moesta, Ulwick, Klement) converge on the same operating thesis: jobs-to-be-done is *not* a feature-prioritization framework, *not* a persona-replacement, and *not* a way to write better product specs. It is a *mental model of the buyer* that asks one question: in what context does someone "hire" a product, and what progress are they trying to make? The unit of analysis is the situation, not the user. Marketers and PMs who treat JTBD as a feature-checklist produce work that ranks features but does not move buyers.

## Operators

- **Clayton Christensen**, `ins_christensen-milkshake-jtbd`. The original frame: "people don't buy products, they hire them to do a job." The McDonald's milkshake research showed buyers hired the milkshake for the morning-commute job, a job persona-segmentation could never have surfaced. The job is contextual, not demographic.
- **Bob Moesta**, `ins_jtbd-interviews-surface-customer-language`, `ins_moesta-forces-of-progress`. JTBD is operationalized via switch interviews on recent buyers: name the moment of first thought, the moment of choice, the forces of progress (push of the situation, pull of the new), and the forces of resistance (anxiety about the new, allegiance to the existing). Interviews surface the buyer's *actual* language, not the rationalized version.
- **Tony Ulwick**, `ins_ulwick-outcomes-as-jobs`. Outcome-Driven Innovation: every job has 50-150 desired outcomes, each measurable. The job statement is "verb + object of the verb + contextual clarifier" (e.g., "minimize the time it takes to verify a customer's identity"). Outcomes are the falsifiable units of the job.
- **Tom Klement**, `ins_klement-jtbd-canvas`, `ins_klement-jobs-not-personas`. JTBD canvas as the operating artifact; jobs are not personas (a CFO and a CMO can share the same job in the same context; a single CFO can have multiple jobs across contexts). Persona-segmentation forces the wrong unit.

## Variation

- **Christensen** owns the *original frame* (job as the unit of demand).
- **Moesta** owns the *interview craft* (switch interviews, forces of progress).
- **Ulwick** owns the *outcome decomposition* (50-150 outcomes per job, ranked by importance × satisfaction).
- **Klement** owns the *practitioner artifact* (job canvas, ICP design).
- Convergence: the buyer's mental model is "I am in situation X trying to make progress Y, and the friction in my current path is Z."

## Implication

For PMMs, product managers, founders, and growth leads:

1. **Write the job statement in the form: "Help me [verb] [object] when [situation], so I can [outcome]."** The "when" clause is the load-bearing piece; without it the job is abstract. "Help me onboard a new customer" is incomplete; "Help me onboard a new B2B customer when I'm a 5-person sales team selling self-serve software, so I can convert before the trial expires" is operational.
2. **Run switch interviews on 8-15 recent buyers per job.** Per Moesta. Tag every utterance for forces of progress vs forces of resistance. The resistance language is the load-bearing copy substrate, more diagnostic than the progress language.
3. **Decompose each job into 30-100 desired outcomes.** Per Ulwick. Each outcome is a metric the buyer cares about (time-to-X, accuracy-of-Y, cost-of-Z). The ICP is the cohort whose outcomes you can move most.
4. **Build messaging from job-language, not feature-language.** The matrix cell for each job × persona pair carries the verbatim language from the interviews, not the marketer's rewrite. This is where most PMM work fails: the team paraphrases, and the resonance dies in paraphrase.
5. **Treat the job as the unit of segmentation.** A persona is a useful shorthand only when one persona reliably maps to one job in one context. When two CFOs are doing different jobs, persona-segmentation produces ambiguous work.

## Counter-evidence

- **Hardware / commodity products** with low engagement surface the job through purchase data alone; switch interviews produce thin signal because the buyer barely thought about the choice.
- **Greenfield categories** without prior alternatives have no "switch" to interview; the JTBD work shifts to forces of progress only (no resistance language exists yet).
- **Heavily regulated buying processes** (RFP-driven, compliance-driven) suppress the buyer's actual job-language under procurement language; the real job lives one layer deeper than the buyer is allowed to articulate.

## Sources

- ins_christensen-milkshake-jtbd, Clayton Christensen, *Competing Against Luck*
- ins_jtbd-interviews-surface-customer-language, Bob Moesta
- ins_moesta-forces-of-progress, Bob Moesta, *Demand-Side Sales 101*
- ins_ulwick-outcomes-as-jobs, Tony Ulwick, *Jobs To Be Done: Theory to Practice*
- ins_klement-jtbd-canvas, Tom Klement, *When Coffee and Kale Compete*
- ins_klement-jobs-not-personas, Tom Klement
- ins_use-case-epiphany-as-marketing-job, Krithika Shankarraman (related)

See also:
- `pat_buyer-mindset-not-product-features` (the broader buyer-side primacy thesis).
- `pat_frontline-as-pmm-substrate` (the upstream rule that JTBD interviews are part of).
- `pat_status-quo-is-the-competitor` (the related pattern; forces of resistance map to status-quo bias).
