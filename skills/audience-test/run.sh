#!/usr/bin/env bash
# synthetic-audience-test — Phase 2 working implementation.
# Runs N copy variants against the 5 grounded personas and emits the structured YAML read.
#
# Usage:
#   ./run.sh <variant-file> [<variant-file-2> ...] [--personas <slug>,<slug>,...]
#   echo "<copy>" | ./run.sh -    (read variant from stdin)
#
# --personas filters the personas/ tree by filename substring. The slugs are
# project-specific; pass any slug whose persona file exists under personas/.
#
# Output: writes shared/synthetic-audience/reads/<variant-id>-YYYY-MM-DD.yaml
# Also pastes the YAML to stdout for piping into a bet's `## Synthetic audience read` section.

set -euo pipefail

# Backwards-compat: accept FLYWHEEL_ROOT as deprecated alias for SUBSTRATE_ROOT.
if [ -n "${FLYWHEEL_ROOT:-}" ] && [ -z "${SUBSTRATE_ROOT:-}" ]; then
  echo "DEPRECATED: FLYWHEEL_ROOT is deprecated; use SUBSTRATE_ROOT." >&2
  SUBSTRATE_ROOT="$FLYWHEEL_ROOT"
fi
SUBSTRATE_ROOT="${SUBSTRATE_ROOT:-${SUBSTRATE_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}}"
PERSONAS_DIR="${SUBSTRATE_PERSONAS_DIR:-$SUBSTRATE_ROOT/personas}"
READS_DIR="${SUBSTRATE_READS_DIR:-$SUBSTRATE_ROOT/shared/synthetic-audience/reads}"
DATE_STAMP="$(date +%F)"

mkdir -p "$READS_DIR"

# Parse args
PERSONAS_FILTER=""
VARIANTS=()
ANCHOR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --personas) PERSONAS_FILTER="$2"; shift 2 ;;
    --anchor) ANCHOR="$(cat "$2")"; shift 2 ;;
    -) VARIANTS+=("$(cat -)"); shift ;;
    *) VARIANTS+=("$(cat "$1")"); shift ;;
  esac
done

if [[ ${#VARIANTS[@]} -eq 0 ]]; then
  echo "Usage: $0 <variant-file> [variant-file-2 ...] [--personas list] [--anchor file]" >&2
  exit 1
fi

# Build persona block — recursive find to pick up subdirs (buyer-states/, internal-org/, internal/)
PERSONA_FILES=()
if [[ -n "$PERSONAS_FILTER" ]]; then
  IFS=',' read -ra WANTED <<< "$PERSONAS_FILTER"
  for w in "${WANTED[@]}"; do
    while IFS= read -r f; do
      bn="$(basename "$f" .md)"
      if [[ "$bn" == *"$w"* ]] || [[ "${bn//-/}" == *"${w//-/}"* ]]; then
        PERSONA_FILES+=("$f")
      fi
    done < <(find -L "$PERSONAS_DIR" -type f -name "*.md" ! -name "*.meta.md" 2>/dev/null)
  done
else
  while IFS= read -r f; do
    PERSONA_FILES+=("$f")
  done < <(find -L "$PERSONAS_DIR" -type f -name "*.md" ! -name "*.meta.md" 2>/dev/null)
fi

if [[ ${#PERSONA_FILES[@]} -eq 0 ]]; then
  echo "  synthetic-audience: no personas matched filter '$PERSONAS_FILTER'" >&2
  exit 2
fi

PERSONA_BLOCK=""
for pf in "${PERSONA_FILES[@]}"; do
  PERSONA_BLOCK+=$'\n--- PERSONA: '"$(basename "$pf" .md)"$' ---\n'"$(cat "$pf")"$'\n'
done

# Build variants block
VARIANT_BLOCK=""
for i in "${!VARIANTS[@]}"; do
  idx=$((i + 1))
  VARIANT_BLOCK+=$'\n--- VARIANT '"$idx"$' ---\n'"${VARIANTS[$i]}"$'\n'
done

VARIANT_ID="$(printf '%s' "${VARIANTS[0]}" | shasum -a 256 | cut -c1-12)"
OUT_FILE="$READS_DIR/${VARIANT_ID}-${DATE_STAMP}.yaml"

ANCHOR_BLOCK=""
if [[ -n "$ANCHOR" ]]; then
  ANCHOR_BLOCK=$'\n--- COMPARISON ANCHOR (current live copy or competitor claim) ---\n'"$ANCHOR"$'\n'
fi

PROMPT="You are running a synthetic-audience pre-flight test inside substrate. Use the Gartner+Wynter 7-dim schema (per SKILL.md last_updated 2026-04-28).

Below are 1+ COPY VARIANTS under test, $(printf '%s' "${#PERSONA_FILES[@]}") grounded BUYER PERSONAS (each with the canonical files they read for grounding listed in their YAML frontmatter), and optionally a COMPARISON ANCHOR.

Critical: personas respond AS BUYERS reading the variant — not as marketers evaluating creative. Per Gartner G00823537 + feedback_synthetic_audience_buyer_side: internal-only feedback (sales reps, PMMs reviewing each other) leads to biased outputs that do not represent buyer reality.

Your job:
1. For each persona, respond AS that buyer reading each variant. Stay strictly grounded in the persona frontmatter + the canonical sources its grounded_in: list points at. If a dimension is not grounded, say 'unverified - canonical does not cover this' rather than guess.

2. Score each variant per persona on the 7-dim Gartner+Wynter schema. **Wynter cascade rule:** if clarity_1to5 < 3, do NOT score later layers (relevance/value/differentiation) — they are moot. Set them to null with reason. Same cascade applies down the chain.
   - clarity_1to5 — I get it (Wynter + Gartner)
   - relevance_1to5 — it is for me (Wynter + Gartner)
   - value_1to5 — I want the promises (Wynter + Gartner)
   - differentiation_1to5 — I get how this is different (Wynter Differentiation / Gartner Uniqueness)
   - credibility_1to5 — I believe the claims; backed by data not salesy (Gartner)
   - urgency_1to5 — I should act now (Gartner)
   - friction_1to5 — resistance, doubts, anxieties (Wynter inverse — LOWER IS BETTER)

3. Per variant per persona, also capture:
   - one_read_takeaway — verbatim sentence the buyer would say after one read
   - objections — list of objections this specific buyer would raise
   - comprehension_gaps — things the buyer expected to see but did not
   - irrelevant_message_avoidance — true|false — per Gartner 73%-of-B2B-buyers-avoid-irrelevant-vendors finding, would this buyer avoid the vendor on this message
   - intent_lift_vs_anchor — only if anchor given: -2 worse to +2 much better
   - confidence — 0.0 to 1.0 — how grounded the read is in canonical
   - VERIFY_flags — list of dims where the score derives from <50% literal-overlap with the variant text

4. Across variants, predict the winner per persona AND overall.

5. Operator voice in the persona quotes: no em dashes; no kill-list words (orchestration, seamless, leverage, transform, holistic, synergy, bespoke, unlock); no throat-clearing.

Output STRICT YAML matching this schema. No prose before or after. Do NOT use code fences:

variant_id: $VARIANT_ID
tested_at: $DATE_STAMP
schema_version: 7-dim-gartner-wynter
variants_count: ${#VARIANTS[@]}
panel:
  - persona: <persona-name>
    grounding_quality: <high|medium|low>
    per_variant:
      - variant: 1
        clarity_1to5: <int>
        relevance_1to5: <int or null>
        value_1to5: <int or null>
        differentiation_1to5: <int or null>
        credibility_1to5: <int or null>
        urgency_1to5: <int or null>
        friction_1to5: <int>
        one_read_takeaway: <quote>
        objections: [<list>]
        comprehension_gaps: [<list>]
        irrelevant_message_avoidance: <true|false>
        intent_lift_vs_anchor: <int or null>
        confidence: <float>
        VERIFY_flags: [<list of dims>]
      - variant: 2
        ...
predicted_winner: <variant index or 'none - all weak'>
forecast_recorded: false
notes:
  - <anything surfaced that isn't covered by schema>
$PERSONA_BLOCK
$VARIANT_BLOCK
$ANCHOR_BLOCK
"

echo "  synthetic-audience: testing $VARIANT_ID against ${#PERSONA_FILES[@]} personas..." >&2

if command -v gtimeout >/dev/null 2>&1; then TO="gtimeout 300"; elif command -v timeout >/dev/null 2>&1; then TO="timeout 300"; else TO=""; fi
output=$($TO claude --print -p "$PROMPT" 2>&1) || {
  echo "  synthetic-audience: failed" >&2
  echo "$output" >&2
  exit 1
}

printf '%s\n' "$output" > "$OUT_FILE"
printf '%s\n' "$output"
echo "  synthetic-audience: wrote $OUT_FILE" >&2
