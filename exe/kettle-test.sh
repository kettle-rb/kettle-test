#!/usr/bin/env bash
# exe/kettle-test — Run specs and emit a structured highlight summary.
#
# Provided by the kettle-test gem.
#
# Usage:
#   bundle exec kettle-test [SPEC_ARGS...]
#
# By default this runs `bundle exec turbo_tests2`, so projects get parallel
# RSpec execution with the same command used by CI and Rake tasks. Set
# KETTLE_TEST_RUNNER=rspec to force direct `bundle exec rspec`.
#
# All arguments are forwarded to the selected runner.
# Output is captured, written to tmp/kettle-test/rspec-TIMESTAMP.log,
# and then key sections are printed to STDOUT in a compact summary block.
#
# Exit code mirrors RSpec's exit code (including coverage hard-failure).
#
# Environment variables (from kettle-soup-cover):
#   K_SOUP_COV_DO        - set to "true" to enable coverage (default: off locally)
#   K_SOUP_COV_MIN_HARD  - set to "true" to hard-fail on coverage (default: CI only)
#   KETTLE_TEST_RUNNER   - turbo_tests2 (default) or rspec
#   KETTLE_TEST_TURBO_PROCESSES    - passed to turbo_tests2 -n
#   KETTLE_TEST_TURBO_RUNTIME_LOG  - passed to turbo_tests2 --runtime-log
#   KETTLE_TEST_TURBO_NICE         - set true to pass turbo_tests2 --nice
#
# Examples:
#   bundle exec kettle-test
#   bundle exec kettle-test spec/my_spec.rb
#   K_SOUP_COV_DO=true bundle exec kettle-test
#
set -euo pipefail

# ── Helpers ──────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

hr() { printf '%s\n' "────────────────────────────────────────────────────────────────"; }

# ── Project root ──────────────────────────────────────────────────────────────
# When run via `bundle exec`, BUNDLE_GEMFILE points to the project's Gemfile.
# Fall back to the current working directory.

if [ -n "${BUNDLE_GEMFILE:-}" ]; then
  PROJECT_ROOT="$(cd "$(dirname "$BUNDLE_GEMFILE")" && pwd)"
else
  PROJECT_ROOT="$(pwd)"
fi

LOG_DIR="$PROJECT_ROOT/tmp/kettle-test"
mkdir -p "$LOG_DIR"
TIMESTAMP="$(date -u +%Y%m%d-%H%M%S)"
RUNNER="${KETTLE_TEST_RUNNER:-turbo_tests2}"
LOG_FILE="$LOG_DIR/${RUNNER}-${TIMESTAMP}-$$.log"

# ── Run specs ─────────────────────────────────────────────────────────────────
# Run via Bundler so the project's own Gemfile is always used.
# We tee to the log so the full output is preserved even if the user interrupts.

rspec_exit=0
cd "$PROJECT_ROOT"

case "$RUNNER" in
  turbo|turbo_tests2)
    export PARALLEL_TEST_FIRST_IS_1="${PARALLEL_TEST_FIRST_IS_1:-true}"
    command=(bundle exec turbo_tests2)
    if [ -n "${KETTLE_TEST_TURBO_PROCESSES:-}" ]; then
      command+=(-n "$KETTLE_TEST_TURBO_PROCESSES")
    fi
    if [ -n "${KETTLE_TEST_TURBO_RUNTIME_LOG:-}" ]; then
      command+=(--runtime-log "$KETTLE_TEST_TURBO_RUNTIME_LOG")
    fi
    if [ "${KETTLE_TEST_TURBO_NICE:-false}" = "true" ]; then
      command+=(--nice)
    fi
    command+=("$@")
    ;;
  rspec)
    command=(bundle exec rspec "$@")
    ;;
  *)
    printf 'Unknown KETTLE_TEST_RUNNER: %s\n' "$RUNNER" >&2
    printf 'Supported values: turbo_tests2, turbo, rspec\n' >&2
    exit 64
    ;;
esac

"${command[@]}" 2>&1 | tee "$LOG_FILE" || rspec_exit=$?

# ── Parse output ──────────────────────────────────────────────────────────────

LOG="$LOG_FILE"

# Strip ANSI escape codes for parsing
clean_log() { sed 's/\x1b\[[0-9;]*[mK]//g' "$LOG"; }

# Summary line: "N examples, N failures" or "N examples, N failures, N pending"
summary_line=$(clean_log | grep -E '^[0-9]+ example' | tail -1 || true)

# Finished timing line
finished_line=$(clean_log | grep -E '^Finished in' | tail -1 || true)

# Seed line
seed_line=$(clean_log | grep -E '^Randomized with seed' | tail -1 || true)

# Failed examples block (rspec ./path:N # description)
failed_block=$(clean_log | grep -E '^rspec \./.*#' || true)
failed_count=$(printf '%s\n' "$failed_block" | grep -c 'rspec \.' || true)
failed_count=${failed_count:-0}

# Coverage lines (simplecov-console output)
cov_line=$(clean_log | grep -E '^Line Coverage:' | tail -1 || true)
cov_branch=$(clean_log | grep -E '^Branch Coverage:' | tail -1 || true)
cov_summary=$(clean_log | grep -E '^(COVERAGE|BRANCH COVERAGE):' || true)
cov_hard_fail=$(clean_log | grep -iE '(minimum coverage|coverage requirement|failed.*coverage)' | tail -3 || true)

# ── Emit summary ──────────────────────────────────────────────────────────────

echo
hr
printf '%b\n' "${BOLD}[rspec_summary] Spec Run Highlights${RESET}"
hr

# Timing
if [ -n "$finished_line" ]; then
  printf '%b\n' "${CYAN}⏱  ${finished_line}${RESET}"
fi

# Seed
if [ -n "$seed_line" ]; then
  printf '%b\n' "${CYAN}🎲  ${seed_line}${RESET}"
fi

# Examples / failures / pending
if [ -n "$summary_line" ]; then
  if echo "$summary_line" | grep -qE ',\s*[1-9][0-9]* failure'; then
    printf '%b\n' "${RED}❌  ${summary_line}${RESET}"
  else
    printf '%b\n' "${GREEN}✅  ${summary_line}${RESET}"
  fi
else
  printf '%b\n' "${YELLOW}⚠️  No summary line found — check log: ${LOG_FILE}${RESET}"
fi

# Failed examples
if [ "$failed_count" -gt 0 ] 2>/dev/null; then
  echo
  printf '%b\n' "${RED}${BOLD}Failed examples (${failed_count}):${RESET}"
  echo "$failed_block" | while IFS= read -r line; do
    [ -n "$line" ] && printf '  %b\n' "${RED}${line}${RESET}"
  done
fi

# Coverage
if [ -n "$cov_line" ] || [ -n "$cov_summary" ]; then
  echo
  printf '%b\n' "${BOLD}Coverage:${RESET}"
  [ -n "$cov_line" ]    && printf '  %b\n' "${cov_line}"
  [ -n "$cov_branch" ]  && printf '  %b\n' "${cov_branch}"
  if [ -n "$cov_summary" ]; then
    echo "$cov_summary" | while IFS= read -r line; do
      [ -n "$line" ] && printf '  %b\n' "${CYAN}${line}${RESET}"
    done
  fi
  if [ -n "$cov_hard_fail" ]; then
    echo
    printf '%b\n' "${RED}${BOLD}Coverage hard-failure:${RESET}"
    echo "$cov_hard_fail" | while IFS= read -r line; do
      [ -n "$line" ] && printf '  %b\n' "${RED}${line}${RESET}"
    done
  fi
fi

# Exit code
echo
if [ "$rspec_exit" -eq 0 ]; then
  printf '%b\n' "${GREEN}${BOLD}Exit: 0 (PASSED)${RESET}"
else
  printf '%b\n' "${RED}${BOLD}Exit: ${rspec_exit} (FAILED)${RESET}"
fi

printf '%b\n' "${CYAN}📄  Full log: ${LOG_FILE}${RESET}"
hr
echo

exit "$rspec_exit"
