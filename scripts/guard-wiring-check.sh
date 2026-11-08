#!/usr/bin/env bash
# guard-wiring-check: warn when a PR adds a guard or warn script that nothing runs.
#
# A rule is only as strong as the check that refuses its breach. A new
# bin/*guard* or bin/*-warn file does nothing until a hook registers it or a
# test runs it. This check looks at the files a PR ADDS and, for each new guard,
# asks: does any other changed file in the same PR name it, and is that file a
# hook registration (settings.json, hooks.json, an install script) or a test?
# If not, it prints a warning.
#
# Usage: scripts/guard-wiring-check.sh [base-ref] [--strict]
#   base-ref  defaults to origin/main
#   --strict  exit 1 on any warning (default: warn only, exit 0)
set -u

BASE="origin/main"
STRICT=0
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    *) BASE="$arg" ;;
  esac
done

if ! git rev-parse --verify -q "$BASE" >/dev/null; then
  echo "guard-wiring-check: base ref '$BASE' not found" >&2
  exit 2
fi

added=$(git diff --diff-filter=A --name-only "$BASE"...HEAD)
changed=$(git diff --diff-filter=ACMR --name-only "$BASE"...HEAD)

# Files that count as wiring: hook registration or a test.
is_wiring() {
  case "$1" in
    *settings.json|*settings.local.json|*hooks.json|*hooks/*.json) return 0 ;;
    *install.sh|*install.ps1|*Makefile|*.github/workflows/*) return 0 ;;
    test/*|tests/*|*/test/*|*/tests/*|*.test.*|*_test.*|*test_*|*.bats) return 0 ;;
  esac
  return 1
}

warnings=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  case "$f" in
    bin/*guard*|bin/*-warn|bin/*-warn.*|*/bin/*guard*|*/bin/*-warn|*/bin/*-warn.*) ;;
    *) continue ;;
  esac
  name=$(basename "$f")
  stem="${name%.*}"
  wired=""
  while IFS= read -r c; do
    [ -z "$c" ] || [ "$c" = "$f" ] && continue
    is_wiring "$c" || continue
    [ -f "$c" ] || continue
    if grep -qF -- "$stem" "$c"; then wired="$c"; break; fi
  done <<< "$changed"
  if [ -n "$wired" ]; then
    echo "ok: $f is wired in $wired"
  else
    warnings=$((warnings + 1))
    msg="$f is a new guard, but no hook registration or test in this PR names '$stem'. Register it (settings.json / hooks.json) or add a test that runs it, or it will never fire."
    if [ -n "${GITHUB_ACTIONS:-}" ]; then
      echo "::warning file=$f::$msg"
    else
      echo "WARN: $msg"
    fi
  fi
done <<< "$added"

if [ "$warnings" -gt 0 ] && [ "$STRICT" -eq 1 ]; then exit 1; fi
exit 0
