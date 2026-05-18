---
slug: finserv-collections
axis: vertical
role: Collections Manager / Credit Operations
seniority: manager
company_stage: growth
company_size: 51-200
verticals: [financial-services, lending, fintech]
tech_stack: [Salesforce-Financial-Services, Latitude, Genesys-considering, Slack]
decision_authority: influencer (compliance signs)
buyer_state: solution-aware
attribution: synthetic-but-grounded
last_updated: 2026-04-30
substrate_grounded_by:
  - substrate/shared/synthetic-audience/personas/financial-services-mortgage-broker.md
  - substrate/shared/synthetic-audience/personas/g2-financial-services-administrator-11-50-employees-ringcentral-contact-.md
---

# Vivek, Collections Manager at a 140-agent consumer lender

## One-line snapshot
Runs a 60-agent collections floor under FDCPA + Reg F, evaluates dialers on compliance audit trail first, contact rate second.

## Daily reality
He opens the compliance dashboard before email. Reg F call-frequency caps need verification daily. He's running a hybrid: a manual-dial team for early-stage delinquency, predictive for later buckets. The phone system has to log every attempt with timestamp, agent ID, and outcome — for the auditor.

## Goals (top 3, ranked)
1. Stay 100% Reg F compliant on call frequency caps (7-in-7 rule).
2. Improve right-party-contact rate above 18%.
3. Build an audit trail that survives a CFPB exam.

## Frictions (top 5)
- Reg F 7-in-7 cap enforcement is manual; agents accidentally over-dial.
- Call recordings retention isn't centralized; some go to the dialer, some to Salesforce.
- Predictive dialer abandonment rates spike during voicemail-drop tests.
- Spanish-language IVR routing is half-broken.
- AI summary risks recording compliance-sensitive language wrongly.

## Decision criteria when evaluating contact-center platforms
- must-have: native Reg F frequency-cap enforcement, immutable audit log, FDCPA-compliant scripting, encrypted recording retention 7+ years, mini-Miranda flow.
- nice-to-have: AI summary with PII redaction, Spanish-language fluency.
- deal-breaker: any vendor that says "your compliance team handles that".

## Voice + tone signature
- writes like: precise, hedged, citations to Reg F section numbers. "Per 12 CFR 1006.14(b)(2)(i)..."
- pet peeves: vendors who confuse FDCPA (1977) with Reg F (2021).
- forwards content when: ACA International publishes an enforcement summary.

## Objections to expect
- "Reg F call cap — natively enforced or is it on me?"
- "What's your CFPB enforcement history?"
- "Mini-Miranda — auto-played per call or manual?"
- "Encrypted recording retention — what's the keying model?"
- "Does AI summary redact SSN, account numbers, sensitive PII?"
- "Spanish-language compliance scripts — built-in or BYO?"
- "Show me a lender at my size with a clean exam history."

## Sample reactions
- Outcome-led hero copy ("3x conversations"): "I don't want 3x conversations, I want 1x compliant conversations."
- Feature-list copy: "where's Reg F frequency capping? if it's not on the LP, you don't serve collections."
- Social-proof-heavy LP: "where's the lender? where's the BPO collector?"
- AI-feature pitch: "AI agent for collections? CFPB will eat me alive. Hard pass unless you've thought through the Reg F implications."

## Synth-audience scoring weights
- outcomes-language importance: low
- differentiation importance: very high (compliance moat)
- voice-fit importance: med
- proof-density importance: very high (named lender + clean exam = unlock)

## What would make THIS persona share / forward
- A Reg F enforcement playbook with technical implementation detail.
- A named consumer-lender case study with audit-pass evidence.
- A side-by-side vs Genesys / NICE on compliance feature parity.

## What would make THIS persona disengage
- Generic SaaS framing.
- Missing FDCPA / Reg F language anywhere on the LP.
- AI features positioned without redaction or compliance story.
