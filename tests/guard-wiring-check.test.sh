#!/usr/bin/env bash
# Runs guard-wiring-check against throwaway git repos. No network, no deps.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
check="$here/scripts/guard-wiring-check.sh"
fail=0

setup() {
  dir=$(mktemp -d)
  cd "$dir" || exit 1
  git init -q -b main
  git config user.email t@t && git config user.name t
  echo base > README && git add . && git commit -qm base
  git checkout -q -b pr
}

expect() { # expect <label> <want-exit> <want-grep>
  out=$("$check" main --strict 2>&1); code=$?
  if [ "$code" -ne "$2" ] || ! grep -q -- "$3" <<< "$out"; then
    echo "FAIL $1 (exit $code)"; echo "$out"; fail=1
  else
    echo "pass $1"
  fi
}

# 1. Guard added with nothing else: warns.
setup; mkdir bin; echo 'exit 0' > bin/push-guard; git add .; git commit -qm g
expect "unwired guard warns" 1 "WARN: bin/push-guard"

# 2. Guard plus settings.json that names it: ok.
setup; mkdir -p bin .claude; echo 'exit 0' > bin/push-guard
echo '{"hooks":{"PreToolUse":[{"command":"bin/push-guard"}]}}' > .claude/settings.json
git add .; git commit -qm g
expect "guard with hook passes" 0 "ok: bin/push-guard"

# 3. Warn script plus a test that runs it: ok.
setup; mkdir -p bin tests; echo 'exit 0' > bin/merge-warn
echo 'bin/merge-warn --dry' > tests/merge-warn.test.sh
git add .; git commit -qm g
expect "warn with test passes" 0 "ok: bin/merge-warn"

# 4. Settings changed but does not name the guard: still warns.
setup; mkdir -p bin .claude; echo 'exit 0' > bin/push-guard
echo '{"hooks":{}}' > .claude/settings.json
git add .; git commit -qm g
expect "unrelated settings still warns" 1 "WARN: bin/push-guard"

# 5. Normal bin script: ignored.
setup; mkdir bin; echo 'exit 0' > bin/gdoc; git add .; git commit -qm g
expect "non-guard ignored" 0 ""

exit $fail
