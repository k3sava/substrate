#!/usr/bin/env python3
"""
brief_freshness_check.py — weekly BRIEF.md drift detector

Reads clients/{client}/BRIEF.md, extracts its source context file list from
frontmatter, then checks whether any source file has been modified more recently
than BRIEF.md's last_updated date. Surfaces drift for human ratification — does
NOT auto-rewrite BRIEF.md.

Output: knowledge/intel/brief-freshness-{client}-{date}.md with DRIFT-CANDIDATE entries.
Exits 0 if fresh, 1 if drift detected (for LaunchAgent alerting).

Usage:
  python3 brief_freshness_check.py --client <slug> [--dry-run]
"""

import argparse
import os
import re
import sys
from datetime import date, datetime, timedelta
from pathlib import Path

SUBSTRATE_ROOT = Path(
    os.environ.get("SUBSTRATE_ROOT")
    or os.environ.get("FLYWHEEL_ROOT")
    or Path(__file__).resolve().parents[2]
)
TODAY = date.today().isoformat()
BRIEF_STALE_DAYS = 14  # matches dispatcher hard-gate in bin/substrate


def parse_frontmatter(text: str) -> dict:
    """Extract YAML-ish frontmatter between --- markers."""
    match = re.match(r"^---\n(.+?)\n---", text, re.DOTALL)
    if not match:
        return {}
    fm = {}
    for line in match.group(1).splitlines():
        if ": " in line and not line.startswith(" "):
            k, _, v = line.partition(": ")
            fm[k.strip()] = v.strip()
    return fm


def extract_sources(text: str) -> list[str]:
    """Pull source file paths from BRIEF.md frontmatter sources block."""
    sources = []
    in_sources = False
    for line in text.splitlines():
        if line.strip() == "sources:":
            in_sources = True
            continue
        if in_sources:
            if line.startswith("  - "):
                # Strip leading "  - " and any trailing comment after #
                raw = line[4:].split("#")[0].strip()
                # Skip glob patterns (e.g. battle-card-*.md)
                if "*" not in raw:
                    sources.append(raw)
            elif line and not line.startswith(" "):
                break
    return sources


def resolve_source(client: str, raw_path: str):
    """Resolve a source path relative to substrate root or the client root."""
    candidates = [
        SUBSTRATE_ROOT / raw_path,
        SUBSTRATE_ROOT / "clients" / client / raw_path,
    ]
    for c in candidates:
        if c.exists():
            return c
    return None


def check_brief(client: str, dry_run: bool = False) -> int:
    brief_path = SUBSTRATE_ROOT / "clients" / client / "BRIEF.md"
    if not brief_path.exists():
        print(f"ERROR: BRIEF.md not found at {brief_path}")
        return 1

    text = brief_path.read_text()
    fm = parse_frontmatter(text)
    last_updated_str = fm.get("last_updated", "")

    try:
        last_updated = date.fromisoformat(last_updated_str)
    except ValueError:
        print(f"WARNING: could not parse last_updated '{last_updated_str}' — treating as stale")
        last_updated = date(2000, 1, 1)

    age_days = (date.today() - last_updated).days
    brief_mtime = datetime.fromtimestamp(brief_path.stat().st_mtime).date()

    sources = extract_sources(text)
    drift_candidates = []
    missing_sources = []

    for raw in sources:
        resolved = resolve_source(client, raw)
        if resolved is None:
            missing_sources.append(raw)
            continue
        src_mtime = datetime.fromtimestamp(resolved.stat().st_mtime).date()
        if src_mtime > last_updated:
            drift_candidates.append({
                "source": raw,
                "resolved": str(resolved),
                "source_mtime": src_mtime.isoformat(),
                "brief_last_updated": last_updated_str,
                "delta_days": (src_mtime - last_updated).days,
            })

    # Build report
    status = "FRESH" if not drift_candidates and age_days <= BRIEF_STALE_DAYS else "DRIFT-DETECTED"
    lines = [
        f"---",
        f"title: BRIEF.md freshness check — {client} — {TODAY}",
        f"client: {client}",
        f"run_date: {TODAY}",
        f"brief_last_updated: {last_updated_str}",
        f"brief_age_days: {age_days}",
        f"sources_checked: {len(sources)}",
        f"drift_candidates: {len(drift_candidates)}",
        f"missing_sources: {len(missing_sources)}",
        f"status: {status}",
        f"---",
        f"",
        f"# BRIEF.md freshness check — {client} — {TODAY}",
        f"",
        f"**Status: {status}**",
        f"BRIEF.md last_updated: {last_updated_str} ({age_days} days ago)",
        f"Sources checked: {len(sources)} | Drift candidates: {len(drift_candidates)} | Missing: {len(missing_sources)}",
        f"",
    ]

    if drift_candidates:
        lines += [
            "## Drift candidates — source context updated after BRIEF.md",
            "",
            "These source files have been modified since BRIEF.md was last refreshed.",
            "Review each for changes that should propagate into BRIEF.md.",
            "Operator ratifies; no auto-rewrite.",
            "",
        ]
        for d in sorted(drift_candidates, key=lambda x: -x["delta_days"]):
            lines += [
                f"### DRIFT-CANDIDATE: `{d['source']}`",
                f"- Source last modified: {d['source_mtime']} (+{d['delta_days']}d after BRIEF)",
                f"- Resolved path: `{d['resolved']}`",
                f"- Action: review for changes to positioning, ICP, claims, or voice rules",
                f"",
            ]

    if missing_sources:
        lines += [
            "## Missing sources (could not resolve)",
            "",
        ]
        for m in missing_sources:
            lines += [f"- `{m}`"]
        lines.append("")

    if not drift_candidates and age_days <= BRIEF_STALE_DAYS:
        lines += [
            "## No drift detected",
            "",
            f"All {len(sources)} source files predate BRIEF.md's last_updated date.",
            f"BRIEF.md is {age_days} days old (threshold: {BRIEF_STALE_DAYS} days).",
            "No action required.",
        ]

    report = "\n".join(lines)

    if dry_run:
        print(report)
        return 1 if drift_candidates else 0

    out_path = SUBSTRATE_ROOT / "knowledge" / "intel" / f"brief-freshness-{client}-{TODAY}.md"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(report)
    print(f"[brief-freshness-check] {status} — report: {out_path}")
    if drift_candidates:
        print(f"  {len(drift_candidates)} drift candidate(s) — review before next session")

    return 1 if drift_candidates or age_days > BRIEF_STALE_DAYS else 0


def main():
    p = argparse.ArgumentParser(description="Check BRIEF.md freshness against source context files")
    p.add_argument(
        "--client",
        default=os.environ.get("SUBSTRATE_CLIENT") or os.environ.get("CLIENT") or "sample-client",
    )
    p.add_argument("--dry-run", action="store_true", help="Print report to stdout; don't write file")
    args = p.parse_args()
    sys.exit(check_brief(args.client, args.dry_run))


if __name__ == "__main__":
    main()
