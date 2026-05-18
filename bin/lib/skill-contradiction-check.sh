#!/usr/bin/env bash
# skill-contradiction-check.sh — behavioral enforcement for `contradictions_aware`
#
# The runtime gap this closes:
#
#   PRINCIPLES.md rule 9 says a skill that touches a contradicted area must
#   pick a position with citation. The preflight library only verifies that
#   the contradiction file exists. The model receives the contradiction body
#   in the prompt, but the runtime never confirms the output names the
#   chosen position OR its conditioning evidence.
#
#   This file checks the *output side*: does the asset name which Position
#   was picked, AND the conditioning fact that justifies the pick?
#
# Acceptable signals (any one is enough):
#
#   1. Frontmatter:
#        contradiction_positions:
#          <slug>: A
#          <slug>: B
#      Plus a `position_rationale` or rationale-by-line nearby.
#
#   2. Inline tag in body:
#        [contradiction:<slug>] picked Position A because <conditioning>
#        position-picked: <slug>::A — <conditioning>
#
#   3. A `## Contradiction navigation` (or `## Contradiction:` / `## Position
#      picked`) section that names the contradiction slug, the position, and
#      the reason.
#
# In every case the asset must include a "because", "since", "given", "due to"
# or `--` connector that ties the pick to an actual conditioning variable
# (deal stage, buyer state, JTBD persistence, reversibility, cohort size, etc).
# A bare "Position A" with no rationale fails — the rule is conditioning-aware
# selection, not coin-flip.
#
# Public functions:
#
#   contradiction_check_position <asset> <slug>
#     Return 0 if the asset names a position for <slug> and provides
#     conditioning evidence; print the matched fragment. Return 1 otherwise
#     (and 2 if the position is named but conditioning is missing).
#
#   contradiction_check_all <asset> <skill>
#     Read the skill's contradictions_aware, run contradiction_check_position
#     for each. Set CONTRADICTION_CHECK_PICKED + CONTRADICTION_CHECK_MISSING.
#     Return 0 if every contradiction has a conditioned pick; 1 otherwise.
#
# Sourced by: skills/pre-publish-check/bin/preflight (Gate 10).

set -uo pipefail

# Backwards-compat: accept FLYWHEEL_ROOT as deprecated alias for SUBSTRATE_ROOT.
if [ -n "${FLYWHEEL_ROOT:-}" ] && [ -z "${SUBSTRATE_ROOT:-}" ]; then
  SUBSTRATE_ROOT="$FLYWHEEL_ROOT"
fi
: "${SUBSTRATE_ROOT:?SUBSTRATE_ROOT must be set (substrate repo root)}"
CONTRADICTIONS_DIR="$SUBSTRATE_ROOT/knowledge/contradictions"

CONTRADICTION_CHECK_PICKED=()      # list of "<slug>::<position>"
CONTRADICTION_CHECK_MISSING=()     # list of slugs with no conditioned pick
CONTRADICTION_CHECK_UNCONDITIONED=()  # named position but no rationale

# Conditioning connectors we accept as "rationale present".
_COND_CONNECTORS='(because|since|given|due to|when|condition(ed|ing)?|rationale[: ]|reason[: ]|because the|because we|—|--)'

# Pull the contradiction_positions block from frontmatter, return one
# "<slug>:<position>" per line.
_contradiction_fm_positions() {
  local asset="$1"
  awk '
    BEGIN{infm=0; in_block=0}
    NR==1 && /^---$/ { infm=1; next }
    infm && /^---$/ { exit }
    !infm { next }
    /^[a-z_-]+:/ { in_block = 0 }
    /^contradiction_positions:/ { in_block = 1; next }
    in_block && /^[[:space:]]+[a-z0-9_-]+:[[:space:]]*[A-Z]/ {
      sub(/^[[:space:]]+/, "");
      print
    }
  ' "$asset"
}

# Pull the rationale block (if any) from frontmatter — keyed by slug.
# Pattern: "position_rationale:" with sub-keys "<slug>: <text>" OR
# "position-rationale-<slug>: <text>" inline.
_contradiction_fm_rationale() {
  local asset="$1" slug="$2"
  awk -v slug="$slug" '
    BEGIN{infm=0; in_block=0}
    NR==1 && /^---$/ { infm=1; next }
    infm && /^---$/ { exit }
    !infm { next }
    /^[a-z_-]+:/ { in_block = 0 }
    /^position_rationale:/ { in_block = 1; next }
    in_block && $0 ~ ("^[[:space:]]+" slug ":") {
      sub("^[[:space:]]+" slug ":[[:space:]]*", "");
      print; exit
    }
    /^position-rationale-/ {
      key = $0;
      sub(/:.*/, "", key);
      sub(/^position-rationale-/, "", key);
      if (key == slug) {
        sub(/^position-rationale-[^:]+:[[:space:]]*/, "");
        print; exit
      }
    }
  ' "$asset"
}

# Strip frontmatter for body scanning.
_contradiction_asset_body() {
  awk '
    BEGIN{infm=0; done=0}
    NR==1 && /^---$/ { infm=1; next }
    infm && /^---$/ { infm=0; done=1; next }
    infm { next }
    { print }
  ' "$1"
}

# Look in body for a position tag for <slug>. Acceptable forms:
#
#   [contradiction:<slug>] picked Position A because <text>
#   position-picked: <slug>::A because <text>
#   [contradiction:<slug>] Position A — <text>
#   ## Contradiction navigation: <slug> → Position A
#   Position A on <slug> because <text>
#
# Returns "<position>|<rationale-line>" on stdout; empty if none found.
_contradiction_body_pick() {
  local asset="$1" slug="$2"
  local body
  body=$(_contradiction_asset_body "$asset")

  # Attempt 1: bracket form
  local hit
  hit=$(echo "$body" | grep -i -E -m1 "\[contradiction:[[:space:]]*$slug[[:space:]]*\][^A-Z]*Position[[:space:]]+[ABCD]" || true)
  if [ -n "$hit" ]; then
    local pos
    pos=$(echo "$hit" | grep -i -E -o "Position[[:space:]]+[ABCD]" | head -1 | awk '{print toupper($2)}')
    echo "${pos}|${hit}"
    return 0
  fi

  # Attempt 2: position-picked form
  hit=$(echo "$body" | grep -i -E -m1 "position[- ]picked:[[:space:]]*$slug[[:space:]]*::[[:space:]]*[ABCD]" || true)
  if [ -n "$hit" ]; then
    local pos
    pos=$(echo "$hit" | grep -i -E -o "::[[:space:]]*[ABCD]" | head -1 | tr -d ': ' | tr 'a-z' 'A-Z')
    echo "${pos}|${hit}"
    return 0
  fi

  # Attempt 3: "## Contradiction navigation:" or "## Contradiction picked:" or
  # "## Position picked:" section that mentions the slug + position. We grab
  # the next 6 lines after the heading.
  local section_hit
  section_hit=$(awk -v slug="$slug" '
    BEGIN{capture=0; lines=0}
    /^##+ (Contradiction (navigation|picked|position)|Position picked|Picked position)/i { capture=1; next }
    capture {
      print;
      if ($0 ~ slug) found_slug=1;
      lines++;
      if (lines >= 8 || /^##+ /) { capture=0; if (found_slug) exit }
    }
  ' "$asset")
  if echo "$section_hit" | grep -q -i "$slug"; then
    local pos
    pos=$(echo "$section_hit" | grep -i -E -o "Position[[:space:]]+[ABCD]" | head -1 | awk '{print toupper($2)}')
    if [ -n "$pos" ]; then
      local rationale_line
      rationale_line=$(echo "$section_hit" | grep -i -E "$_COND_CONNECTORS" | head -1)
      [ -z "$rationale_line" ] && rationale_line=$(echo "$section_hit" | grep -i "Position" | head -1)
      echo "${pos}|${rationale_line}"
      return 0
    fi
  fi

  # Attempt 4: prose form "Position A on <slug> because <text>" or
  # "<slug>: picked Position A because <text>"
  hit=$(echo "$body" | grep -i -E -m1 "(Position[[:space:]]+[ABCD][^.]*$slug|$slug[^.]*Position[[:space:]]+[ABCD])" || true)
  if [ -n "$hit" ]; then
    local pos
    pos=$(echo "$hit" | grep -i -E -o "Position[[:space:]]+[ABCD]" | head -1 | awk '{print toupper($2)}')
    echo "${pos}|${hit}"
    return 0
  fi

  return 1
}

# Decide if a candidate rationale string carries a real conditioning signal.
# The connectors are flexible; the rule is "ties pick to a fact, not vibes".
_contradiction_has_rationale() {
  local text="$1"
  [ -z "$text" ] && return 1
  echo "$text" | grep -q -i -E "$_COND_CONNECTORS"
}

# Public: check whether the asset names a conditioned position for <slug>.
# Print "<position> <truncated-fragment>" on stdout when found.
contradiction_check_position() {
  local asset="$1" slug="$2"
  [ -f "$asset" ] || return 1

  # 1) Frontmatter form takes precedence if present.
  local fm_line fm_pos fm_rationale
  fm_line=$(_contradiction_fm_positions "$asset" | grep -i -E "^${slug}:" | head -1 || true)
  if [ -n "$fm_line" ]; then
    fm_pos=$(echo "$fm_line" | sed -E 's/^[^:]+:[[:space:]]*//' | tr 'a-z' 'A-Z' | head -c 1)
    fm_rationale=$(_contradiction_fm_rationale "$asset" "$slug")
    if [ -z "$fm_rationale" ]; then
      # Fall back to body for rationale tied to this slug.
      fm_rationale=$(_contradiction_asset_body "$asset" | grep -i -m1 "$slug" || true)
    fi
    if _contradiction_has_rationale "$fm_rationale"; then
      echo "${fm_pos} (fm) — ${fm_rationale:0:100}"
      return 0
    fi
    # Position named, but no conditioning. Soft-signal, return 2.
    echo "${fm_pos} (fm; rationale missing)"
    return 2
  fi

  # 2) Body-level pick.
  local body_pick
  body_pick=$(_contradiction_body_pick "$asset" "$slug" || true)
  if [ -n "$body_pick" ]; then
    local pos rationale_line
    pos="${body_pick%%|*}"
    rationale_line="${body_pick#*|}"
    if _contradiction_has_rationale "$rationale_line"; then
      echo "${pos} (body) — ${rationale_line:0:100}"
      return 0
    fi
    echo "${pos} (body; rationale missing)"
    return 2
  fi

  return 1
}

# Public: run contradiction_check_position for every entry in the skill's
# contradictions_aware. Sets CONTRADICTION_CHECK_PICKED +
# CONTRADICTION_CHECK_MISSING + CONTRADICTION_CHECK_UNCONDITIONED.
# Returns 0 if every contradiction has a conditioned pick. 1 otherwise.
contradiction_check_all() {
  local asset="$1" skill="$2"
  local skill_md="$SUBSTRATE_ROOT/skills/$skill/SKILL.md"
  if [ ! -f "$skill_md" ]; then
    echo "    contradiction-check: no SKILL.md for skill='$skill'" >&2
    return 0
  fi

  if ! command -v skill_fm_list >/dev/null 2>&1; then
    # shellcheck source=skill-preflight.sh
    . "$SUBSTRATE_ROOT/bin/lib/skill-preflight.sh"
  fi

  local contras
  contras=$(skill_fm_list "$skill_md" "contradictions_aware")

  CONTRADICTION_CHECK_PICKED=()
  CONTRADICTION_CHECK_MISSING=()
  CONTRADICTION_CHECK_UNCONDITIONED=()

  if [ -z "$contras" ]; then
    return 0  # nothing to enforce
  fi

  local any_failure=0
  while IFS= read -r slug; do
    [ -z "$slug" ] && continue
    if [ ! -f "$CONTRADICTIONS_DIR/$slug.md" ]; then
      echo "    · $slug: contradiction file missing (knowledge/contradictions/$slug.md)" >&2
      CONTRADICTION_CHECK_MISSING+=("$slug")
      any_failure=1
      continue
    fi
    local frag rc
    frag=$(contradiction_check_position "$asset" "$slug")
    rc=$?
    case "$rc" in
      0)
        echo "    ✓ $slug: $frag" >&2
        CONTRADICTION_CHECK_PICKED+=("$slug::$frag")
        ;;
      2)
        echo "    ⚠ $slug: position named but no conditioning rationale ($frag)" >&2
        CONTRADICTION_CHECK_UNCONDITIONED+=("$slug")
        any_failure=1
        ;;
      *)
        echo "    ✗ $slug: no position picked in asset" >&2
        CONTRADICTION_CHECK_MISSING+=("$slug")
        any_failure=1
        ;;
    esac
  done <<< "$contras"

  return "$any_failure"
}
