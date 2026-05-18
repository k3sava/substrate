#!/usr/bin/env bash
# tests/pattern-check/run.sh — exercise Gates 7 + 8 against fixture assets.
#
# Tests:
#   T1  pattern_check_all PASSES on pass-diagnose-before-execute.md
#       (frontline-contact grounds in [frontline-as-pmm-substrate,
#       rapport-surfaces-what-research-cannot, diagnose-before-execute];
#       fixture evidences all three).
#
#   T2  pattern_check_all FAILS on fail-diagnose-before-execute.md
#       (asset jumps to Plan/Recommendation without diagnosis section, no
#       frontline cues, no rapport cues).
#
#   T3  pattern_extract_signature returns a non-empty signature for
#       diagnose-before-execute (sanity check that signatures are wired).
#
#   T4  Structural diagnose-before-plan helper agrees with T1/T2.
#
#   T5  contradiction_check_all PASSES on pass-no-decision-position.md
#       (status-quo-frame is contradictions_aware: [no-decision-vs-named-
#       competitor]; fixture names Position A in frontmatter + body, with
#       conditioning rationale).
#
#   T6  contradiction_check_all FAILS on fail-no-decision-position.md
#       (no contradiction_positions field, no [contradiction:...] tag, no
#       Position A/B mention in body).
#
#   T7  contradiction_check_all FAILS (unconditioned variant) on
#       fail-no-decision-no-rationale.md (Position A is named, but no
#       conditioning rationale ties the pick to a fact).
#
#   T8  Full pre-publish-check Gate 9 + 10 integration on a passing fixture
#       (with bypassed citation gates so we isolate the new behavior).
#
# Exit:
#   0 — all tests pass
#   1 — at least one test failed
#
# Run:
#   FLYWHEEL_ROOT=$(pwd) tests/pattern-check/run.sh

set -uo pipefail

# Locate substrate root from this script's path.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUBSTRATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FLYWHEEL_ROOT="${FLYWHEEL_ROOT:-$SUBSTRATE_ROOT}"
export FLYWHEEL_ROOT SUBSTRATE_ROOT

FIXTURES="$SCRIPT_DIR/fixtures"

# shellcheck disable=SC1091
. "$SUBSTRATE_ROOT/bin/lib/skill-preflight.sh"
# shellcheck disable=SC1091
. "$SUBSTRATE_ROOT/bin/lib/skill-pattern-check.sh"
# shellcheck disable=SC1091
. "$SUBSTRATE_ROOT/bin/lib/skill-contradiction-check.sh"

# --- ANSI helpers (none — we keep it pure for grep-friendly output) ---

passes=0
fails=0
declare -a failure_log=()

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  PASS  $name"
    passes=$((passes + 1))
  else
    echo "  FAIL  $name"
    echo "        expected=$expected"
    echo "        actual=$actual"
    fails=$((fails + 1))
    failure_log+=("$name")
  fi
}

assert_contains() {
  local name="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -q -F "$needle"; then
    echo "  PASS  $name"
    passes=$((passes + 1))
  else
    echo "  FAIL  $name (does not contain '$needle')"
    echo "        haystack=$(echo "$haystack" | head -c 200)"
    fails=$((fails + 1))
    failure_log+=("$name")
  fi
}

echo ""
echo "=== tests/pattern-check/run.sh ==="
echo "  SUBSTRATE_ROOT=$SUBSTRATE_ROOT"
echo "  FIXTURES=$FIXTURES"
echo ""

# T3 first: signature wiring. If this fails the rest of the checks are moot.
echo "[T3] pattern_extract_signature has a non-empty signature for diagnose-before-execute"
sig=$(pattern_extract_signature "diagnose-before-execute")
if [ -n "$sig" ]; then
  echo "  PASS  signature length=${#sig}"
  passes=$((passes + 1))
else
  echo "  FAIL  signature is empty"
  fails=$((fails + 1))
  failure_log+=("T3")
fi
echo ""

# T1: pattern_check_all on the passing fixture.
echo "[T1] pattern_check_all PASSES on pass-diagnose-before-execute.md (skill=frontline-contact)"
if pattern_check_all "$FIXTURES/pass-diagnose-before-execute.md" "frontline-contact" 2>/tmp/t1.stderr; then
  echo "  PASS  pattern_check_all returned 0"
  passes=$((passes + 1))
  echo "    evidenced count=${#PATTERN_CHECK_EVIDENCED[@]}"
  echo "    missing count=${#PATTERN_CHECK_MISSING[@]}"
else
  echo "  FAIL  pattern_check_all returned 1"
  echo "    stderr:"
  sed 's/^/      /' /tmp/t1.stderr
  fails=$((fails + 1))
  failure_log+=("T1")
fi
echo ""

# T2: pattern_check_all on the failing fixture.
echo "[T2] pattern_check_all FAILS on fail-diagnose-before-execute.md (skill=frontline-contact)"
if pattern_check_all "$FIXTURES/fail-diagnose-before-execute.md" "frontline-contact" 2>/tmp/t2.stderr; then
  echo "  FAIL  pattern_check_all returned 0 (expected non-zero)"
  echo "    stderr:"
  sed 's/^/      /' /tmp/t2.stderr
  fails=$((fails + 1))
  failure_log+=("T2")
else
  echo "  PASS  pattern_check_all returned non-zero"
  passes=$((passes + 1))
  # Verify diagnose-before-execute is in the missing list.
  if [[ " ${PATTERN_CHECK_MISSING[*]:-} " == *" diagnose-before-execute "* ]]; then
    echo "    PASS  'diagnose-before-execute' is in PATTERN_CHECK_MISSING"
    passes=$((passes + 1))
  else
    echo "    FAIL  'diagnose-before-execute' should be in PATTERN_CHECK_MISSING but isn't"
    echo "          missing: ${PATTERN_CHECK_MISSING[*]:-<empty>}"
    fails=$((fails + 1))
    failure_log+=("T2.missing-list")
  fi
fi
echo ""

# T4: structural check directly.
echo "[T4] _pattern_diagnose_structure_check identifies Diagnosis-before-Plan order"
struct_pass=$(_pattern_diagnose_structure_check "$FIXTURES/pass-diagnose-before-execute.md" 2>&1 || true)
struct_fail=$(_pattern_diagnose_structure_check "$FIXTURES/fail-diagnose-before-execute.md" 2>&1 || true)
assert_contains "T4.pass-fixture has 'diagnosis-before-plan' or no-plan" "$struct_pass" "diagnosis-before-plan"
assert_contains "T4.fail-fixture has 'no-diagnosis-section' or 'plan-before-diagnosis'" "$struct_fail" "no-diagnosis-section"
echo ""

# T5: contradiction PASS.
echo "[T5] contradiction_check_all PASSES on pass-no-decision-position.md (skill=status-quo-frame)"
if contradiction_check_all "$FIXTURES/pass-no-decision-position.md" "status-quo-frame" 2>/tmp/t5.stderr; then
  echo "  PASS  contradiction_check_all returned 0"
  passes=$((passes + 1))
  echo "    picked count=${#CONTRADICTION_CHECK_PICKED[@]}"
  echo "    unconditioned count=${#CONTRADICTION_CHECK_UNCONDITIONED[@]}"
else
  echo "  FAIL  contradiction_check_all returned non-zero"
  echo "    stderr:"
  sed 's/^/      /' /tmp/t5.stderr
  fails=$((fails + 1))
  failure_log+=("T5")
fi
echo ""

# T6: contradiction FAIL (no position picked at all).
echo "[T6] contradiction_check_all FAILS on fail-no-decision-position.md (skill=status-quo-frame)"
if contradiction_check_all "$FIXTURES/fail-no-decision-position.md" "status-quo-frame" 2>/tmp/t6.stderr; then
  echo "  FAIL  contradiction_check_all returned 0 (expected non-zero)"
  fails=$((fails + 1))
  failure_log+=("T6")
else
  echo "  PASS  contradiction_check_all returned non-zero"
  passes=$((passes + 1))
  if [[ " ${CONTRADICTION_CHECK_MISSING[*]:-} " == *" no-decision-vs-named-competitor "* ]]; then
    echo "    PASS  'no-decision-vs-named-competitor' is in CONTRADICTION_CHECK_MISSING"
    passes=$((passes + 1))
  else
    echo "    FAIL  'no-decision-vs-named-competitor' should be in MISSING"
    echo "          missing: ${CONTRADICTION_CHECK_MISSING[*]:-<empty>}"
    fails=$((fails + 1))
    failure_log+=("T6.missing-list")
  fi
fi
echo ""

# T7: contradiction FAIL (unconditioned variant).
echo "[T7] contradiction_check_all FAILS (unconditioned) on fail-no-decision-no-rationale.md"
if contradiction_check_all "$FIXTURES/fail-no-decision-no-rationale.md" "status-quo-frame" 2>/tmp/t7.stderr; then
  echo "  FAIL  contradiction_check_all returned 0 (expected non-zero)"
  fails=$((fails + 1))
  failure_log+=("T7")
else
  echo "  PASS  contradiction_check_all returned non-zero"
  passes=$((passes + 1))
  if [[ " ${CONTRADICTION_CHECK_UNCONDITIONED[*]:-} " == *" no-decision-vs-named-competitor "* ]]; then
    echo "    PASS  'no-decision-vs-named-competitor' is in CONTRADICTION_CHECK_UNCONDITIONED (named without rationale)"
    passes=$((passes + 1))
  else
    echo "    FAIL  expected 'no-decision-vs-named-competitor' in UNCONDITIONED"
    echo "          unconditioned: ${CONTRADICTION_CHECK_UNCONDITIONED[*]:-<empty>}"
    echo "          missing: ${CONTRADICTION_CHECK_MISSING[*]:-<empty>}"
    fails=$((fails + 1))
    failure_log+=("T7.unconditioned-list")
  fi
fi
echo ""

# T8: integration through the actual preflight script. We need a test that can
# drive the pattern + contradiction gates *only*, since the asset will fail
# the upstream gates in our fixture (it doesn't have real substrate paths).
# We pipe the preflight output and verify both behavioral-grounding gates
# fire. The current preflight numbers them Gate 9 (pattern-applied) and
# Gate 10 (contradiction-position-logged); the assertion contains the
# distinctive gate name, not just the number, so the test is robust to
# renumbering.
echo "[T8] preflight runs the pattern-applied + contradiction-position-logged gates when produced_by is set"
preflight_out=$("$SUBSTRATE_ROOT/skills/pre-publish-check/bin/preflight" "$FIXTURES/pass-diagnose-before-execute.md" 2>&1 || true)
assert_contains "T8.pattern-gate-fired" "$preflight_out" "pattern-applied (produced_by=frontline-contact)"
assert_contains "T8.contradiction-gate-fired" "$preflight_out" "contradiction-position-logged"
# frontline-contact has no contradictions_aware, so the gate should mention "skill declares no contradictions_aware".
assert_contains "T8.gate-no-contras" "$preflight_out" "no contradictions_aware"
echo ""

# T9: integration — contradiction gate hard-fails on the unconditioned fixture.
echo "[T9] preflight contradiction-position-logged hard-fails on fail-no-decision-no-rationale.md"
preflight_out=$("$SUBSTRATE_ROOT/skills/pre-publish-check/bin/preflight" "$FIXTURES/fail-no-decision-no-rationale.md" 2>&1 || true)
assert_contains "T9.contradiction-fail-message" "$preflight_out" "contradiction-position-logged FAIL"
assert_contains "T9.unconditioned-call-out" "$preflight_out" "unconditioned"
echo ""

# T10: produced_by absent → both behavioral-grounding gates skipped.
# Preflight currently emits "Gates 9 + 10 skipped"; the assertion uses the
# distinctive verb "skipped" without the number so it survives renumbering.
echo "[T10] preflight skips behavioral-grounding gates when produced_by is absent"
preflight_out=$("$SUBSTRATE_ROOT/skills/pre-publish-check/bin/preflight" "$SCRIPT_DIR/fixtures/no-produced-by.md" 2>&1 || true)
assert_contains "T10.skipped-message" "$preflight_out" "skipped (asset has no 'produced_by' frontmatter"
echo ""

# ---------------------------------------------------------------------------
# Sprint-1 signature coverage (T11–T16)
# ---------------------------------------------------------------------------
# 16 new signatures were hand-tuned for the sprint-1 patterns: paid-ads,
# email/lifecycle, retention/CS, ABM/sales. The tests below verify that
# (a) each new signature is present + non-empty (T11),
# (b) the paid-ads PASS fixture evidences all four ad-diagnose patterns (T12),
# (c) the retention PASS fixture evidences both activation-funnel-audit
#     patterns (T13),
# (d) the paid-ads FAIL fixture (mentions topics but does not apply patterns)
#     fails (T14),
# (e) the retention FAIL fixture similarly fails (T15),
# (f) at least one new signature rejects a deliberately casual mention (T16).

NEW_SIGNATURES=(
  creative-fatigue-window
  channel-arbitrage-window
  intent-vs-interest-targeting
  incrementality-not-attribution
  engagement-decay-as-relevance-signal
  sender-reputation-is-a-domain-asset
  one-segment-one-trigger
  subject-line-as-experiment-not-art
  aha-moment-defines-activation
  retention-cohort-curves-over-blended-rates
  behavioral-expansion-signals-beat-tenure
  churn-prediction-vs-churn-diagnosis
  trigger-events-beat-cadence-blast
  account-not-lead-as-unit
  rhythm-beats-blast
  status-quo-is-the-real-objection-outbound
)

# T11: every new signature is present, non-empty, and not the slug-fallback.
echo "[T11] all 16 sprint-1 patterns have hand-tuned non-empty signatures"
t11_pass=1
for slug in "${NEW_SIGNATURES[@]}"; do
  sig=$(pattern_extract_signature "$slug")
  if [ -z "$sig" ] || [ "$sig" = "$slug" ] || [ "$sig" = "$(echo "$slug" | tr '-' ' ')" ]; then
    echo "  FAIL  $slug — signature is empty / slug-fallback"
    t11_pass=0
    fails=$((fails + 1))
    failure_log+=("T11.$slug")
  fi
done
if [ "$t11_pass" -eq 1 ]; then
  echo "  PASS  all 16 sprint-1 signatures non-empty + hand-tuned"
  passes=$((passes + 1))
fi
# Also: each new pattern self-matches its own body (calibration sanity check).
echo ""
echo "[T11.self-match] each sprint-1 pattern self-matches its own body"
t11s_pass=1
for slug in "${NEW_SIGNATURES[@]}"; do
  if ! pattern_check_applied "$SUBSTRATE_ROOT/knowledge/patterns/$slug.md" "$slug" >/dev/null 2>&1; then
    echo "  FAIL  $slug — does not self-match"
    t11s_pass=0
    fails=$((fails + 1))
    failure_log+=("T11.self-match.$slug")
  fi
done
if [ "$t11s_pass" -eq 1 ]; then
  echo "  PASS  all 16 sprint-1 patterns self-match"
  passes=$((passes + 1))
fi
echo ""

# T12: paid-ads PASS fixture evidences all four ad-diagnose patterns.
echo "[T12] pattern_check_all PASSES on pass-ad-diagnose-paid-ads.md (skill=ad-diagnose)"
if pattern_check_all "$FIXTURES/pass-ad-diagnose-paid-ads.md" "ad-diagnose" 2>/tmp/t12.stderr; then
  echo "  PASS  pattern_check_all returned 0"
  passes=$((passes + 1))
  echo "    evidenced count=${#PATTERN_CHECK_EVIDENCED[@]}"
  for sub in creative-fatigue-window intent-vs-interest-targeting incrementality-not-attribution buyer-mindset-not-product-features; do
    if [[ " ${PATTERN_CHECK_EVIDENCED[*]:-} " == *" $sub "* ]]; then
      echo "    PASS  T12.$sub-evidenced"
      passes=$((passes + 1))
    else
      echo "    FAIL  T12.$sub-evidenced (expected in PATTERN_CHECK_EVIDENCED)"
      fails=$((fails + 1))
      failure_log+=("T12.$sub")
    fi
  done
else
  echo "  FAIL  pattern_check_all returned non-zero (expected pass)"
  echo "    stderr:"
  sed 's/^/      /' /tmp/t12.stderr
  fails=$((fails + 1))
  failure_log+=("T12")
fi
echo ""

# T13: retention PASS fixture evidences both activation-funnel-audit patterns.
echo "[T13] pattern_check_all PASSES on pass-activation-funnel-audit-retention.md (skill=activation-funnel-audit)"
if pattern_check_all "$FIXTURES/pass-activation-funnel-audit-retention.md" "activation-funnel-audit" 2>/tmp/t13.stderr; then
  echo "  PASS  pattern_check_all returned 0"
  passes=$((passes + 1))
  for sub in aha-moment-defines-activation retention-cohort-curves-over-blended-rates; do
    if [[ " ${PATTERN_CHECK_EVIDENCED[*]:-} " == *" $sub "* ]]; then
      echo "    PASS  T13.$sub-evidenced"
      passes=$((passes + 1))
    else
      echo "    FAIL  T13.$sub-evidenced (expected in PATTERN_CHECK_EVIDENCED)"
      fails=$((fails + 1))
      failure_log+=("T13.$sub")
    fi
  done
else
  echo "  FAIL  pattern_check_all returned non-zero (expected pass)"
  echo "    stderr:"
  sed 's/^/      /' /tmp/t13.stderr
  fails=$((fails + 1))
  failure_log+=("T13")
fi
echo ""

# T14: paid-ads FAIL fixture (mentions topics, does not apply patterns).
echo "[T14] pattern_check_all FAILS on fail-ad-diagnose-paid-ads.md (mentions creative + CAC + ROAS but applies no pattern)"
if pattern_check_all "$FIXTURES/fail-ad-diagnose-paid-ads.md" "ad-diagnose" 2>/tmp/t14.stderr; then
  echo "  FAIL  pattern_check_all returned 0 (expected non-zero)"
  fails=$((fails + 1))
  failure_log+=("T14")
else
  echo "  PASS  pattern_check_all returned non-zero"
  passes=$((passes + 1))
  for sub in creative-fatigue-window intent-vs-interest-targeting incrementality-not-attribution; do
    if [[ " ${PATTERN_CHECK_MISSING[*]:-} " == *" $sub "* ]]; then
      echo "    PASS  T14.$sub-missing"
      passes=$((passes + 1))
    else
      echo "    FAIL  T14.$sub-missing (expected in PATTERN_CHECK_MISSING; missing list: ${PATTERN_CHECK_MISSING[*]:-<empty>})"
      fails=$((fails + 1))
      failure_log+=("T14.$sub-missing")
    fi
  done
fi
echo ""

# T15: retention FAIL fixture (mentions activation + retention but applies no pattern).
echo "[T15] pattern_check_all FAILS on fail-activation-funnel-audit-retention.md"
if pattern_check_all "$FIXTURES/fail-activation-funnel-audit-retention.md" "activation-funnel-audit" 2>/tmp/t15.stderr; then
  echo "  FAIL  pattern_check_all returned 0 (expected non-zero)"
  fails=$((fails + 1))
  failure_log+=("T15")
else
  echo "  PASS  pattern_check_all returned non-zero"
  passes=$((passes + 1))
  for sub in aha-moment-defines-activation retention-cohort-curves-over-blended-rates; do
    if [[ " ${PATTERN_CHECK_MISSING[*]:-} " == *" $sub "* ]]; then
      echo "    PASS  T15.$sub-missing"
      passes=$((passes + 1))
    else
      echo "    FAIL  T15.$sub-missing (expected in PATTERN_CHECK_MISSING)"
      fails=$((fails + 1))
      failure_log+=("T15.$sub-missing")
    fi
  done
fi
echo ""

# T16: false-positive resistance — a deliberately casual fragment that
# mentions sprint-1 topics without applying any pattern must NOT match.
# This is the inverse of T11.self-match: same regex, very different input.
#
# bash 3.2 (macOS default) does not support associative arrays, so we use
# parallel arrays keyed by index.
echo "[T16] sprint-1 signatures reject deliberately casual mentions"
T16_CASUAL=(
  "we should probably refresh some creatives sometime - they look tired and our CAC is climbing"
  "let's revisit the channel mix this quarter and rotate channels more often"
  "demand generation team is hiring; we should separate the dashboards next sprint"
  "what is our blended CAC this quarter? something looks weird in the dashboard"
  "open rates are dropping, we should check the spam folder situation"
  "we got an email saying delivery rates have dipped - anyone know why?"
  "let's send a Tuesday email blast to everyone signed up in March"
  "the subject test ran last week and one had a 4% lift"
  "had an aha moment on the call today - Sara mentioned the pricing thing"
  "retention this quarter is 75%, up from 70% last quarter"
  "let's send an upsell email to all 90-day customers"
  "churn is up to 6% MoM, we should do something about it"
  "we got an alert about a funding round at TargetCo - should we reach out?"
  "MQL count is up 30% - celebrating with cake"
  "let's just blast the list once and see"
  "we lost the deal to no-decision again, third one this quarter"
)
t16_pass=1
for i in "${!NEW_SIGNATURES[@]}"; do
  slug="${NEW_SIGNATURES[$i]}"
  sig=$(pattern_extract_signature "$slug")
  casual="${T16_CASUAL[$i]}"
  if echo "$casual" | grep -i -E -q "$sig"; then
    echo "  FAIL  $slug -- casual mention false-positive: \"$casual\""
    t16_pass=0
    fails=$((fails + 1))
    failure_log+=("T16.$slug")
  fi
done
if [ "$t16_pass" -eq 1 ]; then
  echo "  PASS  all 16 sprint-1 signatures rejected their casual mention"
  passes=$((passes + 1))
fi
echo ""

# T17: deeper false-positive sweep — phrases that name the surface noun of
# the pattern but do not invoke its discipline. These are the calibration
# stress-tests that exposed weak alternatives during signature tuning. Each
# row is (slug, fragment) and must be REJECTED by the slug's signature.
echo "[T17] sprint-1 signatures reject surface-noun-only mentions"
T17_PAIRS=(
  "creative-fatigue-window|I think we have creative fatigue but I am not sure what to do"
  "creative-fatigue-window|fatigue thresholds for our org chart need work"
  "intent-vs-interest-targeting|intent vs interest is interesting question"
  "sender-reputation-is-a-domain-asset|sender reputation took a hit last quarter"
  "sender-reputation-is-a-domain-asset|sending domain change for the migration"
  "one-segment-one-trigger|broadcast nurture campaigns are old school"
  "churn-prediction-vs-churn-diagnosis|save call rate is improving"
  "account-not-lead-as-unit|TEAM Foundations training next month"
  "account-not-lead-as-unit|MQL funnel review meeting"
  "rhythm-beats-blast|channel rotation in Slack confuses people"
  "rhythm-beats-blast|we have a content gate review meeting"
  "behavioral-expansion-signals-beat-tenure|day 21 customers churned this week"
)
t17_pass=1
for pair in "${T17_PAIRS[@]}"; do
  slug="${pair%%|*}"
  text="${pair#*|}"
  sig=$(pattern_extract_signature "$slug")
  if echo "$text" | grep -i -E -q "$sig"; then
    matched=$(echo "$text" | grep -i -E -o "$sig" | head -1)
    echo "  FAIL  $slug -- false-positive on \"$text\" :: matched \"$matched\""
    t17_pass=0
    fails=$((fails + 1))
    failure_log+=("T17.$slug")
  fi
done
if [ "$t17_pass" -eq 1 ]; then
  echo "  PASS  all surface-noun-only mentions rejected"
  passes=$((passes + 1))
fi
echo ""

echo ""
echo "=== summary ==="
echo "  passes: $passes"
echo "  fails:  $fails"
if [ "$fails" -gt 0 ]; then
  echo ""
  echo "  failed tests:"
  for t in "${failure_log[@]}"; do
    echo "    - $t"
  done
  exit 1
fi
echo ""
echo "  all tests passed."
exit 0
