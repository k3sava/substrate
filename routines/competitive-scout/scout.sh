#!/usr/bin/env bash
# competitive-scout.sh — weekly competitive intel sweep wrapper.
#
# Called by the com.substrate.competitive-scout LaunchAgent (or a cron of your
# choice). Runs the substrate competitive-scout skill against every client
# that has a competitors.yaml. Each per-client run writes signals into
# clients/<client>/signals/inbox/ and commits.
#
# Configure via env:
#   SUBSTRATE_ROOT     — substrate repo root (required if not auto-detected)
#   SUBSTRATE_CLIENTS  — space-separated list of client slugs to scout
#                        (defaults to every clients/* with competitors.yaml)
#   SUBSTRATE_TIER     — tier filter (default: T1)
#   SUBSTRATE_LOG_DIR  — log directory (default: $SUBSTRATE_ROOT/.logs)
#
# Logs: $SUBSTRATE_LOG_DIR/competitive-scout.log

set -euo pipefail

SUBSTRATE_ROOT="${SUBSTRATE_ROOT:-${FLYWHEEL_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}}"
TIER="${SUBSTRATE_TIER:-T1}"
LOG_DIR="${SUBSTRATE_LOG_DIR:-$SUBSTRATE_ROOT/.logs}"
LOG="$LOG_DIR/competitive-scout.log"
mkdir -p "$LOG_DIR"

LOCK="/tmp/substrate-competitive-scout.lock.d"
if ! mkdir "$LOCK" 2>/dev/null; then
  AGE=$(( $(date +%s) - $(stat -f %m "$LOCK" 2>/dev/null || echo 0) ))
  if (( AGE > 1800 )); then
    rm -rf "$LOCK" && mkdir "$LOCK"
  else
    echo "[$(date +%H:%M:%S)] skipped (scout already running, lock age ${AGE}s)" >> "$LOG"
    exit 0
  fi
fi
trap 'rm -rf "$LOCK"' EXIT

echo "[$(date +%H:%M:%S)] competitive-scout starting — $(date -u +%Y-%m-%d)" >> "$LOG"

# Pull latest repo state if this is a checked-out clone (best-effort).
git -C "$SUBSTRATE_ROOT" pull --rebase --autostash 2>&1 | tail -1 >> "$LOG" || true

# Resolve client list.
clients=()
if [ -n "${SUBSTRATE_CLIENTS:-}" ]; then
  read -r -a clients <<< "$SUBSTRATE_CLIENTS"
else
  while IFS= read -r yaml; do
    slug=$(basename "$(dirname "$yaml")")
    clients+=("$slug")
  done < <(find "$SUBSTRATE_ROOT/clients" -mindepth 2 -maxdepth 2 -name competitors.yaml 2>/dev/null)
fi

if [ "${#clients[@]}" -eq 0 ]; then
  echo "[$(date +%H:%M:%S)] no clients with competitors.yaml — nothing to scout" >> "$LOG"
  echo "  drop templates/competitors-example.yaml at clients/<slug>/competitors.yaml to enable" >> "$LOG"
  exit 0
fi

for slug in "${clients[@]}"; do
  echo "[$(date +%H:%M:%S)] scouting client=$slug tier=$TIER" >> "$LOG"
  SUBSTRATE_ROOT="$SUBSTRATE_ROOT" \
    "$SUBSTRATE_ROOT/bin/substrate" competitive-scout \
      --client "$slug" --tier "$TIER" >> "$LOG" 2>&1 || {
        echo "[$(date +%H:%M:%S)] competitive-scout exited non-zero for $slug" >> "$LOG"
      }
done

# Final git push (best-effort; lets the operator's regular sync take over).
git -C "$SUBSTRATE_ROOT" push 2>&1 | tail -1 >> "$LOG" || true

echo "[$(date +%H:%M:%S)] competitive-scout done" >> "$LOG"
