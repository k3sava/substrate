---
name: email-deliverability-audit
description: Audit an email program's deliverability posture by running real DNS lookups for SPF, DKIM, and DMARC on a sending domain, parsing the records for known failure modes, and producing a structured findings report with severity tiers. Optional inputs include a recent send-log CSV (bounce / complaint / open data) and a list of subdomains to audit together.
version: 0.1
amplifies: lifecycle marketer, growth lead, RevOps owner of email infra, security reviewer of outbound mail
masters: Kath Pay (Holistic Email Marketing; domain reputation as long-term asset), Mathew Sweezey (former Salesforce; domain trust as marketing velocity), Laura Atkins (Word to the Wise; deliverability practitioner), public mailbox-provider documentation (Gmail Postmaster, Microsoft SNDS, Yahoo Sender Hub), DMARC.org and RFC 7489
substrate_layers_required: [brand-voice]
patterns_grounded: [sender-reputation-is-a-domain-asset, engagement-decay-as-relevance-signal]
contradictions_aware: []
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
---

# email-deliverability-audit

## Purpose

Produce an evidence-grounded audit of an email program's deliverability posture, anchored on the *domain* as the unit of reputation per the `sender-reputation-is-a-domain-asset` pattern. The audit runs real DNS lookups (SPF, DKIM, DMARC) for the named domain and any subdomains, parses each record for known failure modes, and emits a structured findings report with severity tiers and recommended fixes. Where send-log data is provided, the audit cross-references bounce-rate and complaint-rate against industry thresholds.

This skill replaces "I think our email is fine" with "DKIM selector `mail` resolves; DMARC policy is `p=none` with no `rua` reporting target; subdomain `news.brand.com` has SPF but no DKIM; bounce rate over the last 30 days exceeds the 2% Postmaster Tools threshold."

## Inputs

- `--client <client>` (required)
- `--domain <domain>` (required, e.g. `brand.com`)
- `--subdomains <comma-separated>` (optional, e.g. `mail.brand.com,news.brand.com`)
- `--dkim-selectors <comma-separated>` (optional, e.g. `selector1,google,k1`; defaults to a probe list)
- `--send-log <path>` (optional, CSV with `date,sent,delivered,bounced,complained,opened`)
- `--out <path>` (optional, default: `clients/<client>/email/audits/deliverability-<domain>-<YYYY-MM-DD>.md`)

## Substrate reads

The skill is mostly substrate-light because the source-of-truth is DNS itself. It still requires `BRIEF.md` so the audit ships into the client's substrate folder with the correct attribution.

## Process

1. **Preflight**: required-reads check.
2. **Resolve A and MX**: confirm the domain resolves and identify the receiving infrastructure if relevant.
3. **SPF audit**: `dig TXT <domain>` filtered to `v=spf1`. Parse for: include count (>10 lookups breaks SPF), `+all` / `?all` (insecure), missing `~all` or `-all`.
4. **DKIM probe**: for each selector in `--dkim-selectors` (or the default probe list of common selectors), `dig TXT <selector>._domainkey.<domain>`. Parse for: presence of a public key, key length (1024 < flagged warn; 2048 = recommended).
5. **DMARC audit**: `dig TXT _dmarc.<domain>`. Parse for: presence, policy (`p=none` / `p=quarantine` / `p=reject`), reporting addresses (`rua` / `ruf`), alignment (`adkim` / `aspf`), subdomain policy (`sp`).
6. **Subdomain sprawl audit**: repeat 3–5 for every subdomain in `--subdomains`. Forgotten subdomains with weak DMARC are flagged at HIGH severity.
7. **Optional send-log analysis**: if `--send-log` provided, parse the CSV and compute 30-day bounce rate, complaint rate, and open rate. Compare against industry thresholds (Gmail Postmaster: 0.10% complaint warn, 0.30% high; bounce 2% warn, 5% high).
8. **Severity tiering**: each finding gets `critical` / `high` / `medium` / `low`. Critical = active deliverability damage (no DMARC, `+all` SPF, expired keys). High = compounding damage (open subdomain DMARC, unmonitored DMARC). Medium = posture gap (1024-bit keys, missing `rua`). Low = best-practice nudge.
9. **Findings report**: write a structured markdown audit to `--out` with frontmatter, executive summary, per-domain findings table, and a remediation queue ordered by severity.

## Output contract

```
clients/<client>/email/audits/deliverability-<domain>-<YYYY-MM-DD>.md
```

Frontmatter:

```yaml
---
audit_type: email-deliverability
domain: <domain>
audited_subdomains: [<...>]
audit_date: <YYYY-MM-DD>
findings_critical: <n>
findings_high: <n>
findings_medium: <n>
findings_low: <n>
auditor_skill: email-deliverability-audit
auditor_version: 0.1
---
```

Body sections:
- Executive summary (one paragraph, severity counts, top three actions)
- Authentication posture per (sub)domain (SPF / DKIM / DMARC table)
- Send-log signals (when provided)
- Findings by severity (one block per finding, with recommended fix and citation to the relevant Postmaster doc)
- Remediation queue (ordered list, ready to assign)

## Quality criteria

- Every finding has a real DNS query record showing the resolved value (or the absence).
- No fabricated DNS records. If a selector probe returns NXDOMAIN, the report says NXDOMAIN; it does not invent a key.
- Every recommendation cites the relevant standard (RFC 7489 for DMARC; Gmail Postmaster docs; Microsoft SNDS; Yahoo Sender Hub).
- Severity tiers follow a documented rubric (in the body of the audit), not the auditor's gut.
- The skill exits non-zero if any *critical* finding is detected, surfacing the issue to the operator queue.

## What this skill does NOT do

- Does not connect to ESP APIs (Klaviyo, Customer.io, Iterable). Send-log is consumed as a CSV.
- Does not test inbox placement (no Glock Apps, MailGenius, or Litmus integration). It audits configuration, not arrival.
- Does not run blacklist lookups against every RBL (Spamhaus, Barracuda, etc.) — the field is too volatile to trust to a one-shot check; treat as a separate concern.
- Does not change DNS records. Findings are advisory; the human applies fixes through their DNS provider.

## Refusal patterns

- **substrate-gap** — `BRIEF.md` missing.
- **dig-unavailable** — `dig` or `host` not on PATH. The skill cannot run real DNS lookups without one of them.
- **invalid-domain** — the domain does not resolve at all (no A, no MX, no TXT). The audit cannot proceed against a domain that does not exist.
- **send-log-malformed** — when `--send-log` is provided but does not parse, the skill warns and continues without the send-log section rather than fabricating numbers.

## See also

- `email-list-hygiene` — list-side complement to this domain-side audit.
- `email-engagement-decay-watcher` — when decay points at deliverability rather than relevance.
- `knowledge/patterns/sender-reputation-is-a-domain-asset.md`
- `routines/email-deliverability-monthly.md`
