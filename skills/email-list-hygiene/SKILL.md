---
name: email-list-hygiene
description: Analyze a subscriber list export for hygiene risks. Parses a CSV of subscribers, flags hard-bounce candidates, never-engaged subs, role-based addresses, suspected spam traps, and TLD distribution risks. Outputs a prune candidate list, a suppression list, and segment recommendations. Real CSV parsing with disposable-domain and role-address detection.
version: 0.1
amplifies: lifecycle marketer, RevOps owner of email lists, growth lead before a major send
masters: Kath Pay (Holistic Email Marketing; list-quality vs list-size), Andrew Bonar (deliverability practitioner; spam-trap taxonomy), Brian Kotlyar (segment-or-die; list segmentation discipline), public mailbox-provider documentation (Gmail Postmaster bounce thresholds; AOL/Yahoo Sender Hub; Microsoft SNDS)
substrate_layers_required: [icp, brand-voice]
patterns_grounded: [sender-reputation-is-a-domain-asset, one-segment-one-trigger]
contradictions_aware: []
preflight_refusal: substrate-gap
required_reads:
  - clients/{client}/BRIEF.md
  - clients/{client}/02-icp.md
---

# email-list-hygiene

## Purpose

Take a subscriber list export and produce three actionable artifacts: a prune candidate list (addresses to suppress), a suppression list (addresses to soft-suppress with re-engagement attempt), and a segment recommendation set (cohorts the surviving list naturally splits into). The audit runs real CSV parsing with role-based address detection, disposable-domain detection, hard-bounce flagging, never-engaged flagging, and TLD distribution analysis.

This skill replaces "we should clean the list before the launch" with "of 84,000 subscribers, 6,200 are prune candidates (3,400 hard-bounced, 1,800 role-based, 1,000 never-opened past 18 months); 11,400 are re-engagement candidates; 66,400 split cleanly into three behavior cohorts the next send should segment by."

## Inputs

- `--client <client>` (required)
- `--list <path>` (required, CSV)
- `--out <path>` (optional, default: `clients/<client>/email/hygiene/<YYYY-MM-DD>/`)
- `--inactive-days <n>` (default 540 for B2B, lifecycle marketers commonly use 18 months)
- `--bounce-threshold <n>` (default 1; any address with `bounce_count >= 1` of type `hard` is a prune candidate)
- `--gmail-share-warn <pct>` (default 70; if Gmail TLDs exceed this share, single-provider concentration risk is flagged)

## CSV expected columns

The skill reads CSVs with at minimum these columns (header row required):

```
email,signup_date,last_open,last_click,bounce_count,bounce_type,status
```

Optional columns the skill uses if present:

```
source,country,first_name,last_name,custom_field_*,tags
```

## Substrate reads

`02-icp.md` is read so the segment recommendations can map to ICP cells (not just behavior buckets). The skill refuses if ICP is missing because it cannot recommend segments without a target buyer reference.

## Process

1. **Preflight**: required-reads check.
2. **CSV parse**: read header, validate required columns, count rows. Refuse if columns are missing.
3. **Per-row classification**:
   - **hard-bounce**: `bounce_type == hard` or `bounce_count >= --bounce-threshold` for any `hard` bounce. Prune candidate.
   - **role-based**: local-part matches `info|admin|support|sales|noreply|no-reply|webmaster|postmaster|abuse|hostmaster|root|contact|hello|team|hr|jobs|press|marketing|billing|legal|privacy|security`. Suppress candidate (not prune; some role addresses convert).
   - **disposable-domain**: domain matches a curated list of disposable-mail providers (mailinator, guerrillamail, 10minutemail, etc.). Prune candidate.
   - **suspected spam-trap**: never-opened in the entire history AND signup_date older than 24 months AND no clicks ever. Heuristic, not deterministic; flagged as suppress with a note.
   - **never-engaged**: last_open and last_click both null or older than `--inactive-days`. Re-engagement candidate.
   - **active**: any open or click within `--inactive-days`. Keep.
4. **TLD distribution**: count by domain TLD. Flag if Gmail share exceeds `--gmail-share-warn` (single-provider concentration is a deliverability risk if the provider's posture changes).
5. **Cohort hint generation**: for the active subset, propose 3 segment recommendations grounded in `02-icp.md` cells (e.g. by behavior recency × ICP cell).
6. **Output emit**:
   - `prune-candidates.csv` — hard-bounce + disposable + confirmed spam-trap.
   - `suppression-candidates.csv` — role-based + suspected spam-trap.
   - `re-engagement-candidates.csv` — never-engaged.
   - `summary.md` — counts by class, TLD distribution table, segment recommendations, ICP cell map.

## Output contract

```
clients/<client>/email/hygiene/<YYYY-MM-DD>/
  summary.md
  prune-candidates.csv
  suppression-candidates.csv
  re-engagement-candidates.csv
  segment-recommendations.md
```

Summary frontmatter:

```yaml
---
hygiene_run_date: <YYYY-MM-DD>
list_path: <input-path>
total_rows: <n>
prune_candidates: <n>
suppression_candidates: <n>
re_engagement_candidates: <n>
active_subscribers: <n>
gmail_share_pct: <n>
single_provider_risk: yes|no
auditor_skill: email-list-hygiene
auditor_version: 0.1
---
```

## Quality criteria

- Every output count is reproducible from the input CSV (audit log shows the row index ranges that hit each rule).
- No fabricated email addresses (the skill never adds rows; it only classifies and partitions).
- Disposable domain list is documented in the skill's bin (not invented per-run).
- Role-address regex is documented in the skill's bin.
- Segment recommendations cite ICP cells from `02-icp.md` by section header.

## What this skill does NOT do

- Does not validate addresses against an SMTP probe (no live mailbox check). The audit is statistical, not active.
- Does not export to ESPs (Klaviyo, Customer.io, Iterable). The CSVs are handed to the operator who applies them through their tool's UI.
- Does not predict re-engagement success. The re-engagement list is a candidate set; success rates depend on the campaign downstream.
- Does not run on lists smaller than 100 addresses (the statistical signal is too weak; the skill warns and exits 0 with a summary saying so).

## Refusal patterns

- **substrate-gap** — `BRIEF.md` or `02-icp.md` missing.
- **csv-malformed** — required columns missing or no header row. The skill cannot infer; it refuses.
- **list-too-small** — fewer than 100 rows (warning, not refusal — the skill exits 0 but the summary documents the limit).
- **encoding-mismatch** — non-UTF8 CSVs are refused with a clear remediation message.

## See also

- `email-deliverability-audit` — domain-side complement.
- `email-cohort-trigger` — uses the segment recommendations as input.
- `email-engagement-decay-watcher` — decay on a sequence may flag list-hygiene as the root cause; the watcher links here.
- `knowledge/patterns/sender-reputation-is-a-domain-asset.md`
- `knowledge/patterns/one-segment-one-trigger.md`
