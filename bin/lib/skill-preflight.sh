#!/usr/bin/env bash
# skill-preflight.sh — shared preflight library for substrate skills
#
# Sourced by every skill's bin/<skill> runtime. Validates the contract a skill
# declares in its SKILL.md frontmatter:
#
#   substrate_layers_required: [voc, icp, positioning, ...]
#   patterns_grounded:         [<slug from knowledge/patterns/>]
#   contradictions_aware:      [<slug from knowledge/contradictions/>]
#   required_reads:            [<paths>]
#   preflight_refusal:         substrate-gap, missing-X, ...
#
# Public functions:
#   skill_preflight <skill-name> <client>      run all checks; sets PREFLIGHT_FAIL on miss
#   skill_emit_prompt <skill-name> <client>    write a structured LLM prompt for the skill
#   skill_refuse <reason> <detail>             print structured refusal + exit 3
#
# Exit codes (when running standalone, e.g. via the bin runtime):
#   0 — preflight passed
#   3 — refused (substrate gap, missing layer, missing pattern file, etc.)
#   4 — invalid args
#   5 — config error (missing SKILL.md, SUBSTRATE_ROOT not set)
#
# This library has no external deps beyond awk, grep, sed, find — all POSIX.

set -uo pipefail

# Backwards-compat: if FLYWHEEL_ROOT is set but SUBSTRATE_ROOT isn't, alias and
# warn. The variable rename happened in v1.2; FLYWHEEL_ROOT still works for one
# release cycle so existing LaunchAgents and shell rcs don't break overnight.
if [ -n "${FLYWHEEL_ROOT:-}" ] && [ -z "${SUBSTRATE_ROOT:-}" ]; then
  echo "DEPRECATED: FLYWHEEL_ROOT is deprecated; use SUBSTRATE_ROOT." >&2
  SUBSTRATE_ROOT="$FLYWHEEL_ROOT"
  export SUBSTRATE_ROOT
fi

: "${SUBSTRATE_ROOT:?SUBSTRATE_ROOT must be set (substrate repo root)}"

# Keep FLYWHEEL_ROOT exported for the deprecation cycle so any skill that still
# reads it sees the same path as SUBSTRATE_ROOT.
FLYWHEEL_ROOT="${FLYWHEEL_ROOT:-$SUBSTRATE_ROOT}"
export FLYWHEEL_ROOT SUBSTRATE_ROOT

PATTERNS_DIR="$SUBSTRATE_ROOT/knowledge/patterns"
CONTRADICTIONS_DIR="$SUBSTRATE_ROOT/knowledge/contradictions"

PREFLIGHT_FAIL=0
PREFLIGHT_REASONS=()

# --- frontmatter parsers ---

# Read a YAML list value from a SKILL.md frontmatter block.
# Usage: skill_fm_list <skill-md> <key>
# Handles both inline form ([a, b, c]) and block form (- a\n- b\n).
skill_fm_list() {
  local file="$1" key="$2"
  awk -v key="$key" '
    BEGIN { infm=0; in_key=0; }
    NR==1 && /^---$/ { infm=1; next; }
    infm && /^---$/ { exit; }
    !infm { next; }
    /^[a-z_-]+:/ { in_key=0; }
    $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "");
      if ($0 ~ /^\[/) {
        gsub(/^\[|\][[:space:]]*$/, "");
        n = split($0, parts, /,[[:space:]]*/);
        for (i=1;i<=n;i++) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", parts[i]); if (parts[i] != "") print parts[i]; }
      } else {
        in_key=1;
      }
      next;
    }
    in_key && /^[[:space:]]*-/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "");
      sub(/[[:space:]]*$/, "");
      gsub(/^["'\'']|["'\'']$/, "");
      if ($0 != "") print;
    }
    in_key && /^[[:space:]]*$/ { next; }
    in_key && !/^[[:space:]]*-/ && !/^[[:space:]]*$/ { in_key=0; }
  ' "$file"
}

# Read a scalar YAML value from frontmatter.
skill_fm_scalar() {
  local file="$1" key="$2"
  awk -v key="$key" '
    BEGIN { infm=0; }
    NR==1 && /^---$/ { infm=1; next; }
    infm && /^---$/ { exit; }
    !infm { next; }
    $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "");
      gsub(/^["'\'']|["'\'']$/, "");
      print;
      exit;
    }
  ' "$file"
}

# --- check helpers ---

skill_record_fail() {
  PREFLIGHT_FAIL=1
  PREFLIGHT_REASONS+=("$1")
}

# Validate that each substrate layer exists for the client.
# Layers map to directories or files under clients/<client>/.
# We check for the layer directory's existence; per-layer hygiene runs in refresh-knowledge.
skill_check_layers() {
  local client="$1"; shift
  local layers=("$@")
  local client_root="$SUBSTRATE_ROOT/clients/$client"
  if [ ! -d "$client_root" ]; then
    skill_record_fail "client root missing: clients/$client/"
    return
  fi
  for layer in "${layers[@]}"; do
    case "$layer" in
      voc|icp|positioning|competitive|product-knowledge|conversion-narrative|brand-voice|market-context|sales-pitch|strategy|distribution|team)
        if [ ! -d "$client_root/$layer" ] && [ ! -f "$client_root/$layer.md" ]; then
          skill_record_fail "layer missing: clients/$client/$layer/"
        fi
        ;;
      *)
        # unknown layer — log but don't fail, lets new layers ship without runtime updates
        echo "  warn: unknown substrate layer '$layer' (skill may need a layer registry update)" >&2
        ;;
    esac
  done
}

# Validate that every pattern_grounded file exists in knowledge/patterns/.
skill_check_patterns() {
  local patterns=("$@")
  if [ ${#patterns[@]} -eq 0 ]; then
    skill_record_fail "patterns_grounded is empty (rule 9: every skill grounds in a pattern)"
    return
  fi
  for slug in "${patterns[@]}"; do
    if [ ! -f "$PATTERNS_DIR/$slug.md" ]; then
      skill_record_fail "pattern file missing: knowledge/patterns/$slug.md"
    fi
  done
}

# Validate that every contradictions_aware file exists.
skill_check_contradictions() {
  local contras=("$@")
  for slug in "${contras[@]}"; do
    if [ ! -f "$CONTRADICTIONS_DIR/$slug.md" ]; then
      skill_record_fail "contradiction file missing: knowledge/contradictions/$slug.md"
    fi
  done
}

# Resolve required_reads against the substrate root + client root.
# Each entry can include {client} as a placeholder.
skill_check_required_reads() {
  local client="$1"; shift
  local reads=("$@")
  for read_path in "${reads[@]}"; do
    local resolved="${read_path//\{client\}/$client}"
    if [ ! -f "$SUBSTRATE_ROOT/$resolved" ] && [ ! -d "$SUBSTRATE_ROOT/$resolved" ]; then
      skill_record_fail "required_read missing: $resolved"
    fi
  done
}

# --- public entry point ---

# skill_preflight <skill-name> <client>
# Reads the skill's SKILL.md and runs all checks.
skill_preflight() {
  local skill="$1" client="$2"
  local skill_md="$SUBSTRATE_ROOT/skills/$skill/SKILL.md"
  if [ ! -f "$skill_md" ]; then
    echo "config error: missing $skill_md" >&2
    exit 5
  fi

  # Parse frontmatter lists.
  local layers patterns contras reads
  layers=$(skill_fm_list "$skill_md" "substrate_layers_required")
  patterns=$(skill_fm_list "$skill_md" "patterns_grounded")
  contras=$(skill_fm_list "$skill_md" "contradictions_aware")
  reads=$(skill_fm_list "$skill_md" "required_reads")

  # Convert to arrays (newline-delimited; empty stays empty).
  local -a layers_arr patterns_arr contras_arr reads_arr
  while IFS= read -r line; do [ -n "$line" ] && layers_arr+=("$line"); done <<< "$layers"
  while IFS= read -r line; do [ -n "$line" ] && patterns_arr+=("$line"); done <<< "$patterns"
  while IFS= read -r line; do [ -n "$line" ] && contras_arr+=("$line"); done <<< "$contras"
  while IFS= read -r line; do [ -n "$line" ] && reads_arr+=("$line"); done <<< "$reads"

  # Run checks.
  if [ -n "$client" ] && [ ${#layers_arr[@]} -gt 0 ]; then
    skill_check_layers "$client" "${layers_arr[@]}"
  fi
  if [ ${#patterns_arr[@]} -gt 0 ] || [ -z "$patterns" ]; then
    skill_check_patterns "${patterns_arr[@]}"
  fi
  if [ ${#contras_arr[@]} -gt 0 ]; then
    skill_check_contradictions "${contras_arr[@]}"
  fi
  if [ -n "$client" ] && [ ${#reads_arr[@]} -gt 0 ]; then
    skill_check_required_reads "$client" "${reads_arr[@]}"
  fi

  if [ "$PREFLIGHT_FAIL" -eq 1 ]; then
    echo "" >&2
    echo "preflight: REFUSED (skill=$skill, client=${client:-<none>})" >&2
    for r in "${PREFLIGHT_REASONS[@]}"; do
      echo "  · $r" >&2
    done
    echo "" >&2
    echo "  fix the substrate gap, then re-run." >&2
    return 3
  fi
  return 0
}

# skill_emit_prompt <skill-name> <client> <mode> [extra args...]
# Writes a structured LLM prompt to stdout. Operator pipes to LLM CLI of choice.
skill_emit_prompt() {
  local skill="$1" client="$2" mode="${3:-default}"; shift 3 || true
  local skill_md="$SUBSTRATE_ROOT/skills/$skill/SKILL.md"

  echo "# Substrate skill prompt: $skill"
  echo "# Generated $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# Client: $client"
  echo "# Mode: $mode"
  echo "# Pass-through args: $*"
  echo ""
  echo "## Skill specification"
  echo ""
  cat "$skill_md"
  echo ""
  echo "## Patterns grounding this skill"
  echo ""
  for slug in $(skill_fm_list "$skill_md" "patterns_grounded"); do
    if [ -f "$PATTERNS_DIR/$slug.md" ]; then
      echo "### $slug"
      echo ""
      cat "$PATTERNS_DIR/$slug.md"
      echo ""
    fi
  done
  local contras
  contras=$(skill_fm_list "$skill_md" "contradictions_aware")
  if [ -n "$contras" ]; then
    echo "## Contradictions this skill must resolve"
    echo ""
    for slug in $contras; do
      if [ -f "$CONTRADICTIONS_DIR/$slug.md" ]; then
        echo "### $slug"
        echo ""
        cat "$CONTRADICTIONS_DIR/$slug.md"
        echo ""
      fi
    done
  fi
  if [ -n "$client" ]; then
    echo "## Client substrate snapshot"
    echo ""
    if [ -f "$SUBSTRATE_ROOT/clients/$client/00-INDEX.md" ]; then
      cat "$SUBSTRATE_ROOT/clients/$client/00-INDEX.md"
    fi
  fi
  echo ""
  echo "## Instruction"
  echo ""
  echo "Execute the skill above, in mode='$mode', for client='$client'."
  echo "Cite every claim against a substrate path. Refuse if anything is unverified."
  echo "Apply patterns. Pick contradiction positions per the conditioning, log the choice."
  echo "Output: as specified in the skill's Output contract section."
}

# Convenience: hard refuse with structured exit.
skill_refuse() {
  local reason="$1" detail="${2:-}"
  echo "REFUSED: $reason" >&2
  if [ -n "$detail" ]; then echo "  $detail" >&2; fi
  exit 3
}
