---
title: Email deliverability monthly audit
status: active
last_updated: 2026-05-08
schedule: monthly
day_of_month: 1
hour_local: 08
---

# Email deliverability monthly routine

A monthly run of `email-deliverability-audit` against the client's sending domain and known subdomains. Catches DKIM rotations gone wrong, DMARC policy regressions, and authentication drift before they show up in the inbox-placement signals.

## Why this routine exists

DNS posture decays. A DKIM key gets rotated and the wrong selector goes live. A new transactional service spins up under a forgotten subdomain with no DMARC. An SPF include exceeds the 10-lookup limit because Marketing added a new vendor. Each of these is a slow-moving deliverability bug that the inbox-placement signals catch only after the damage has compounded.

Per `knowledge/patterns/sender-reputation-is-a-domain-asset.md`, the sending domain is a multi-year compounding asset. The monthly audit is the routine that defends the asset.

## Cadence

- **Frequency**: monthly, first business day, local morning.
- **Scope**: the client's primary sending domain and every subdomain in the configured list.
- **Optional**: a 30-day send-log CSV is provided; the audit cross-references against Gmail Postmaster bounce/complaint thresholds.

## What the routine does

1. Resolves A and MX for the domain (refuses if neither resolves).
2. Audits SPF record:
   - presence
   - lookup count (10 = permerror; 8+ = warn)
   - qualifier (`+all` critical; `?all` high; missing `~all`/`-all` high)
3. Audits DKIM by probing a default selector list plus any operator-supplied selectors:
   - presence
   - key length (1024-bit base64 < 250 chars; 2048-bit ≥ ~390 chars)
   - revocation (`p=` empty)
4. Audits DMARC at `_dmarc.<domain>`:
   - presence (critical if missing)
   - policy (`p=none` high; `p=quarantine` low; `p=reject` ideal)
   - reporting (`rua=` missing is high)
   - subdomain policy (`sp=` missing is medium)
5. Repeats 2-4 for each subdomain.
6. If `--send-log` provided, computes 30-day bounce rate and complaint rate and compares to Gmail Postmaster thresholds (2%/5% for bounce; 0.10%/0.30% for complaint).
7. Writes findings to `clients/<client>/email/audits/deliverability-<domain>-<YYYY-MM-DD>.md` with severity tiers and a remediation queue.

## Output

A monthly findings report. Non-zero exit on any critical finding.

## Run by hand

```bash
substrate email-deliverability-audit \
  --client <client> \
  --domain <domain> \
  --subdomains mail.<domain>,news.<domain>,go.<domain> \
  --dkim-selectors selector1,selector2,google,k1
```

With send-log:

```bash
substrate email-deliverability-audit \
  --client <client> \
  --domain <domain> \
  --send-log clients/<client>/email/send-log/2026-04.csv
```

## Run as a cron / LaunchAgent

macOS LaunchAgent:

```xml
<key>Label</key><string>com.substrate.email-deliverability-monthly</string>
<key>ProgramArguments</key>
<array>
  <string>/Users/<you>/r2d2/substrate/bin/substrate</string>
  <string>email-deliverability-audit</string>
  <string>--client</string><string><client></string>
  <string>--domain</string><string><domain></string>
</array>
<key>StartCalendarInterval</key>
<dict>
  <key>Day</key><integer>1</integer>
  <key>Hour</key><integer>8</integer>
  <key>Minute</key><integer>0</integer>
</dict>
```

Linux cron:

```
0 8 1 * * /home/<you>/substrate/bin/substrate email-deliverability-audit --client <client> --domain <domain>
```

## Pre-conditions

- `dig` or `host` is installed and on PATH.
- The client's `BRIEF.md` exists.
- For the send-log section, a CSV with header `date,sent,delivered,bounced,complained,opened` exists at the path passed via `--send-log`.

## What this routine does NOT do

- Does not test inbox placement against a seed list (no Glock Apps, MailGenius, or Litmus integration).
- Does not run blacklist lookups against every RBL, that field is too volatile to trust to a one-shot monthly check.
- Does not change DNS records. Findings are advisory; the human applies fixes through their DNS provider.

## Related routines

- `routines/email-decay-routine.md`, weekly engagement decay watcher.
- `routines/aeo-routine.md`, same posture-audit shape, different surface.

## See also

- `skills/email-deliverability-audit/SKILL.md`
- `skills/email-list-hygiene/SKILL.md`
- `knowledge/patterns/sender-reputation-is-a-domain-asset.md`
