#!/usr/bin/env python3
"""bet-resolution/resolve.py — SQLite version (replaces the Postgres script).

Walks goals/ledger.md for goals whose resolution_date has passed. For each:
  1. If goals/<bet-id>/resolution.json exists (operator already ran /bet resolve),
     copy that resolution into gate_events as a permanent record.
  2. Otherwise, surface the goal in the "needs resolution" list.

Deliberate scope cut from the v1 Postgres script: that script auto-resolved
goals by dispatching per-source (HubSpot deal-tag count, Amplitude funnel CR,
Slack mention count, etc.). That dispatch is reproducible against SQLite +
per-source readers, but it's a multi-week build. Until that lands, the Slack
/bet resolve verb is the canonical resolution path. This script just promotes
resolution.json sidecars into the calibration DB.

Usage:
  python3 resolve.py --v2-ledger goals/ledger.md
  python3 resolve.py --dry-run
"""
from __future__ import annotations

import argparse
import json
import os
import sqlite3
import sys
from datetime import date
from pathlib import Path


def _root() -> Path:
    return Path(os.environ.get("SUBSTRATE_ROOT") or Path(__file__).resolve().parents[2])


def parse_v2_ledger(ledger_path: Path) -> list[dict]:
    """Return [{bet_id, resolution_date, status, ...}] for active bets."""
    out = []
    text = ledger_path.read_text()
    in_active = False
    headers = None
    for line in text.split("\n"):
        if line.startswith("## ") and ("active bets" in line.lower() or "active goals" in line.lower()):
            in_active = True
            continue
        if in_active and line.startswith("## "):
            break
        if not in_active:
            continue
        if line.startswith("|") and headers is None and "bet_id" in line:
            headers = [h.strip() for h in line.split("|")[1:-1]]
            continue
        if line.startswith("|---"):
            continue
        if headers and line.startswith("|"):
            cells = [c.strip() for c in line.split("|")[1:-1]]
            if len(cells) != len(headers):
                continue
            row = dict(zip(headers, cells))
            if not row.get("bet_id") or row["bet_id"].startswith("("):
                continue
            out.append(row)
    return out


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--v2-ledger", default="goals/ledger.md", help="path to v2 ledger relative to repo root")
    p.add_argument("--dry-run", action="store_true")
    args = p.parse_args()

    root = _root()
    ledger_path = (root / args.v2_ledger).resolve()
    db_path = root / "data" / "calibration.sqlite"

    if not ledger_path.exists():
        print(f"[bet-resolve] ledger not found: {ledger_path}", file=sys.stderr)
        sys.exit(2)
    if not db_path.exists():
        print(f"[bet-resolve] DB not initialised: {db_path}", file=sys.stderr)
        print(f"[bet-resolve] run: bin/init-calibration-db", file=sys.stderr)
        sys.exit(2)

    today = date.today()
    bets = parse_v2_ledger(ledger_path)
    overdue = []
    promoted = 0

    for b in bets:
        rd = b.get("resolution_date", "")
        if not rd or len(rd) < 10:
            continue
        try:
            close = date.fromisoformat(rd[:10])
        except ValueError:
            continue
        if close > today:
            continue  # not yet due

        sidecar = root / "goals" / b["bet_id"] / "resolution.json"
        if not sidecar.exists():
            overdue.append(b)
            continue

        resolution = json.loads(sidecar.read_text())

        with sqlite3.connect(db_path) as conn:
            cur = conn.execute(
                "SELECT 1 FROM gate_events WHERE event_id = ?",
                (f"resolve-{b['bet_id']}",),
            )
            if cur.fetchone():
                continue  # already promoted
            if args.dry_run:
                print(f"[bet-resolve] would promote: {b['bet_id']} → gate_events")
                promoted += 1
                continue
            conn.execute(
                """
                INSERT INTO gate_events
                  (event_id, bet_id, asset_type, taste_owner, predicted_p_threshold_met,
                   actual_outcome, brier_score, log_score, resolved_at, notes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    f"resolve-{b['bet_id']}",
                    b["bet_id"],
                    b.get("taste_type"),
                    resolution.get("taste_owner"),
                    resolution.get("predicted_p"),
                    resolution.get("actual_outcome"),
                    resolution.get("brier_score"),
                    resolution.get("log_score"),
                    resolution.get("resolved_at"),
                    resolution.get("note", ""),
                ),
            )
        promoted += 1
        print(f"[bet-resolve] promoted {b['bet_id']} → gate_events (brier={resolution.get('brier_score')})")

    if overdue:
        print("")
        print(f"[bet-resolve] {len(overdue)} goals past resolution_date with no resolution.json:")
        for b in overdue:
            print(f"  · {b['bet_id']:<28}  closed {b.get('resolution_date')}  status={b.get('status')}")
        print("")
        print("  Run `bet resolve <bet-id> threshold-met|missed` for each.")
        if not args.dry_run:
            sys.exit(1)

    if promoted == 0 and not overdue:
        print("[bet-resolve] nothing to do — no overdue goals, no unpromoted resolutions.")


if __name__ == "__main__":
    main()
