#!/usr/bin/env bash
# smoke.sh — fail-fast checks for continuity-kit scripts.
# Usage: ./tests/smoke.sh
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0
while IFS= read -r f; do
  bash -n "$f" || { echo "SYNTAX FAIL: $f"; fail=1; }
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck -S warning "$f" || { echo "SHELLCHECK FAIL: $f"; fail=1; }
  fi
done < <(find "$REPO/install" "$REPO/bin" "$REPO/tests" -type f -name '*.sh' 2>/dev/null; find "$REPO/bin" -type f -name 'ck-*' 2>/dev/null)
[ "$fail" -eq 0 ] && echo "smoke: PASS (no scripts yet or all clean)"
exit "$fail"
