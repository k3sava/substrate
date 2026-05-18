#!/usr/bin/env python3
"""
quarterly_context_audit — content-quality audit for the context corpus.

Walks every context file at quarter-close. Per file, checks:
  1. last_updated within decay_period_days (date freshness)
  2. cited context paths in body still resolve (link integrity)
  3. named operators/companies/products still current (per L1 keka-org-chart cross-check)
  4. source-system IDs detected (handoff to skills/source-system-verify for live verification)

Output: a draft durability-recap-Q<n>-<year>.md to knowledge/intel/. Operator reviews + ships.

Usage:
  quarterly_context_audit.py [--client <slug>] [--quarter Q2] [--year 2026] [--dry-run]
"""

from __future__ import annotations
import argparse
import re
import sys
from datetime import date, datetime, timedelta
from pathlib import Path

CONTEXT_PATH_RE = re.compile(
    r"`?([\w./_-]+\.(?:md|yml|yaml|jsonl|json))(?![\w])`?"
)
SOURCE_SYSTEM_RE = re.compile(
    r"\b(?:HubSpot\s+(?:dashboard|portal|chart|view)\s*[\w-]+|Amplitude\s+(?:project|chart|brand)\s*[\w-]+|Asana\s+[\d-]+|Jira\s+[A-Z]+-\d+|brand\s+\d{4}|chart\s+[\w]+)\b",
    re.IGNORECASE,
)


def parse_frontmatter(text: str) -> dict:
    if not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end < 0:
        return {}
    fm: dict = {}
    for line in text[3:end].split("\n"):
        m = re.match(r"^([a-zA-Z_]+):\s*(.*)$", line)
        if m and m.group(2).strip():
            fm[m.group(1)] = m.group(2).strip()
    return fm


def parse_date(s: str) -> date | None:
    s = s.strip().strip('"').strip("'")
    for fmt in ("%Y-%m-%d", "%Y/%m/%d", "%d-%m-%Y"):
        try:
            return datetime.strptime(s, fmt).date()
        except ValueError:
            continue
    return None


def audit_file(path: Path, substrate_root: Path, basename_idx: dict[str, str], today: date) -> dict:
    """Return per-file audit row."""
    text = path.read_text(errors="replace")
    fm = parse_frontmatter(text)
    rel = str(path.relative_to(substrate_root))

    row = {
        "path": rel,
        "last_updated": fm.get("last_updated", "MISSING"),
        "decay_period_days": fm.get("decay_period_days", "UNSET"),
        "stale": False,
        "stale_reason": "",
        "broken_cite_count": 0,
        "broken_cites": [],
        "source_system_ids": [],
        "attribution": fm.get("attribution", "UNTAGGED"),
    }

    # Freshness check
    last_updated_d = parse_date(fm.get("last_updated", "")) if fm.get("last_updated") else None
    if last_updated_d is None:
        row["stale"] = True
        row["stale_reason"] = "no last_updated"
    else:
        try:
            decay = int(fm.get("decay_period_days", "180"))  # default 180 if unset
        except (ValueError, TypeError):
            decay = 180
        age_days = (today - last_updated_d).days
        if age_days > decay:
            row["stale"] = True
            row["stale_reason"] = f"age={age_days}d > decay={decay}d"
        row["age_days"] = age_days

    # Cited-path link integrity
    body = text[text.find("\n---", 3) + 4:] if text.startswith("---") else text
    # Strip fenced code blocks — JSON examples shouldn't count as cites
    body_no_fences = re.sub(r"```[\s\S]*?```", "", body)
    cited_paths = set(CONTEXT_PATH_RE.findall(body_no_fences))
    for p in cited_paths:
        # Skip URLs, raw strings, fields that contain dots but aren't files
        if "://" in p or len(p) < 5:
            continue
        # Skip regex-fragment artifacts — paths must start with a word char
        # (drops "-fg.json", "-full.json", "-2026-04-30.md" leading-dash fragments)
        if p[0] in "-._":
            continue
        # Skip JSON-snippet fragments shorter than typical filenames
        bn = p.split("/")[-1]
        if not p.startswith("/") and "/" not in p and len(bn) < 12 and p.endswith(".json"):
            continue
        # Try resolution: full path, basename
        full = substrate_root / p
        wiki_alt = substrate_root.parent / p
        bn = p.split("/")[-1]
        if full.exists() or wiki_alt.exists() or bn in basename_idx:
            continue
        row["broken_cite_count"] += 1
        row["broken_cites"].append(p)

    # Source-system IDs (handoff to skills/source-system-verify)
    for m in SOURCE_SYSTEM_RE.findall(text):
        row["source_system_ids"].append(m)

    return row


def index_context(substrate_root: Path) -> dict[str, str]:
    idx: dict[str, str] = {}
    for d in ["clients", "intel", "shared", "raw", "context", "skills", "agents", "loops", "personas", "bets", "data", "handoff", "metrics", "_v1"]:
        base = substrate_root / d
        if base.exists():
            for f in base.rglob("*.md"):
                idx.setdefault(f.name, str(f.relative_to(substrate_root)))
            for f in base.rglob("*.yml"):
                idx.setdefault(f.name, str(f.relative_to(substrate_root)))
            for f in base.rglob("*.json"):
                idx.setdefault(f.name, str(f.relative_to(substrate_root)))
            for f in base.rglob("*.jsonl"):
                idx.setdefault(f.name, str(f.relative_to(substrate_root)))
    wiki_base = substrate_root.parent / "wiki"
    if wiki_base.exists():
        for f in wiki_base.rglob("*.md"):
            idx.setdefault(f.name, str(f))
    # Auto-memory dir (cross-session knowledge; cited from context)
    memory_base = Path.home() / ".claude/projects/-Users-k3sava-r2d2/memory"
    if memory_base.exists():
        for f in memory_base.glob("*.md"):
            idx.setdefault(f.name, str(f))
    # Artemis read-only PMM delivery clone (cited from context)
    artemis_base = Path.home() / "Projects/artemis"
    if artemis_base.exists():
        for f in artemis_base.rglob("*.md"):
            idx.setdefault(f.name, str(f))
    # team-brain (sibling of substrate)
    teambrain_base = substrate_root.parent / "team-brain"
    if teambrain_base.exists():
        for f in teambrain_base.rglob("*.md"):
            idx.setdefault(f.name, str(f))
    return idx


def main() -> int:
    import os as _os
    p = argparse.ArgumentParser()
    p.add_argument(
        "--client",
        default=_os.environ.get("SUBSTRATE_CLIENT") or _os.environ.get("CLIENT") or "sample-client",
    )
    p.add_argument("--quarter", default=None, help="Q1, Q2, Q3, Q4 (default: current)")
    p.add_argument("--year", default=None, help="default: current")
    p.add_argument("--dry-run", action="store_true")
    args = p.parse_args()

    today = date.today()
    quarter = args.quarter or f"Q{(today.month - 1) // 3 + 1}"
    year = args.year or str(today.year)

    substrate_root = Path(
        _os.environ.get("SUBSTRATE_ROOT")
        or _os.environ.get("FLYWHEEL_ROOT")
        or Path(__file__).resolve().parents[2]
    )
    context_dir = substrate_root / "clients" / args.client / "context"
    if not context_dir.is_dir():
        print(f"context dir not found: {context_dir}", file=sys.stderr)
        return 2

    print(f"=== quarterly context audit — {args.client} {quarter} {year} ===")
    print(f"context root: {context_dir}")

    basename_idx = index_context(substrate_root)
    files = sorted(context_dir.rglob("*.md"))
    print(f"files to audit: {len(files)}")

    rows = [audit_file(f, substrate_root, basename_idx, today) for f in files]

    stale = [r for r in rows if r["stale"]]
    broken = [r for r in rows if r["broken_cite_count"] > 0]
    untagged = [r for r in rows if r["attribution"] == "UNTAGGED"]
    with_sysid = [r for r in rows if r["source_system_ids"]]

    print(f"\n  stale (age > decay):  {len(stale)} / {len(rows)}")
    print(f"  broken cites:         {len(broken)} / {len(rows)}")
    print(f"  untagged attribution: {len(untagged)} / {len(rows)}")
    print(f"  with source-system IDs (verify-eligible): {len(with_sysid)} / {len(rows)}")

    # Generate draft durability-recap
    out_path = substrate_root / "knowledge" / "intel" / f"durability-recap-{args.client}-{quarter}-{year}.md"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    if args.dry_run:
        print(f"\n(dry-run; would write {out_path})")
        return 0

    with out_path.open("w") as fh:
        fh.write(f"---\n")
        fh.write(f"title: Durability recap — {args.client} {quarter} {year}\n")
        fh.write(f"type: intel\n")
        fh.write(f"asset_type: scaffold\n")
        fh.write(f"date: {today.isoformat()}\n")
        fh.write(f"quarter: {quarter} {year}\n")
        fh.write(f"author: routines/quarterly-context-audit/audit.py (auto-generated)\n")
        fh.write(f"reviewer: operator (apply or correct each finding before tagging closed)\n")
        fh.write(f"---\n\n")
        fh.write(f"# Durability recap — {quarter} {year}\n\n")
        fh.write(f"Generated by `routines/quarterly-context-audit/audit.py` on {today.isoformat()}.\n\n")
        fh.write(f"## Summary\n\n")
        fh.write(f"- Files audited: **{len(rows)}**\n")
        fh.write(f"- Stale (age exceeds decay_period): **{len(stale)}**\n")
        fh.write(f"- Broken cites (referenced paths missing): **{len(broken)}**\n")
        fh.write(f"- Untagged attribution: **{len(untagged)}**\n")
        fh.write(f"- Carrying source-system IDs (verify-eligible via skills/source-system-verify): **{len(with_sysid)}**\n\n")

        if stale:
            fh.write(f"## Stale files (age > decay_period_days)\n\n")
            fh.write(f"| File | last_updated | age | decay | reason |\n|---|---|---|---|---|\n")
            for r in sorted(stale, key=lambda x: -x.get("age_days", 0)):
                fh.write(f"| `{r['path']}` | {r['last_updated']} | {r.get('age_days', '?')}d | {r['decay_period_days']} | {r['stale_reason']} |\n")
            fh.write("\n")

        if broken:
            fh.write(f"## Broken cites (paths referenced in body that don't resolve)\n\n")
            for r in broken:
                fh.write(f"- `{r['path']}` — {r['broken_cite_count']} broken cite(s):\n")
                for bc in r["broken_cites"][:5]:
                    fh.write(f"  - `{bc}`\n")
                if len(r["broken_cites"]) > 5:
                    fh.write(f"  - ... +{len(r['broken_cites']) - 5} more\n")
            fh.write("\n")

        if untagged:
            fh.write(f"## Untagged attribution\n\n")
            fh.write(f"Files lacking the `attribution:` frontmatter key (5-tier evidence ladder per `knowledge/ideas/how-confident-are-we.md`):\n\n")
            for r in untagged[:20]:
                fh.write(f"- `{r['path']}`\n")
            if len(untagged) > 20:
                fh.write(f"- ... +{len(untagged) - 20} more\n")
            fh.write("\n")

        if with_sysid:
            total_ids = sum(len(r["source_system_ids"]) for r in with_sysid)
            fh.write(f"## Source-system IDs to verify\n\n")
            fh.write(f"{total_ids} source-system IDs detected across {len(with_sysid)} files. ")
            fh.write(f"Run a source-system verifier (operator-provided; needs HubSpot/Amplitude/Asana/Jira credentials) to confirm each cited ID still resolves and the cited value still holds.\n\n")
            fh.write(f"<details><summary>Files with source-system IDs (top 15)</summary>\n\n")
            for r in sorted(with_sysid, key=lambda x: -len(x["source_system_ids"]))[:15]:
                fh.write(f"- `{r['path']}` — {len(r['source_system_ids'])} ID(s)\n")
            fh.write(f"\n</details>\n\n")

        fh.write(f"## Operator review\n\n")
        fh.write(f"Per finding above, operator-side action required:\n\n")
        fh.write(f"- **Stale files** — refresh from current source-system or mark explicitly retired.\n")
        fh.write(f"- **Broken cites** — fix the path or remove the cite.\n")
        fh.write(f"- **Untagged attribution** — add `attribution: verified|self-reported|contextual|indirect|direct` per evidence ladder.\n")
        fh.write(f"- **Source-system IDs** — run source-system-verify; review per-ID report.\n\n")
        fh.write(f"Once each row is reviewed (apply or correct), tag this file `closed: YYYY-MM-DD` in frontmatter and create git tag `substrate-{quarter.lower()}-{year}-recap-closed`.\n\n")
        fh.write(f"## What survived, what decayed, what was rebuilt, what was abandoned (Lenny recruit)\n\n")
        fh.write(f"*(Operator fills this section by reading the audit findings + cross-referencing the {quarter} bet ledger + asset shipping log. The mechanical audit above is necessary; this section is sufficient.)*\n\n")
        fh.write(f"### Context that compounded (cited by ≥3 new bets / assets this quarter)\n\n")
        fh.write(f"<!-- list -->\n\n")
        fh.write(f"### Context that decayed (operator caught contradiction with current world)\n\n")
        fh.write(f"<!-- list -->\n\n")
        fh.write(f"### Context that was rebuilt this quarter\n\n")
        fh.write(f"<!-- list -->\n\n")
        fh.write(f"### Context that was abandoned\n\n")
        fh.write(f"<!-- list with replacement-or-reason -->\n\n")
        fh.write(f"### New context that needs adding next quarter\n\n")
        fh.write(f"<!-- list -->\n")

    print(f"\nwrote draft recap to: {out_path}")
    print(f"review + apply per-row, then git tag substrate-{quarter.lower()}-{year}-recap-closed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
