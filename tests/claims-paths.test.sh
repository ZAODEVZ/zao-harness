#!/usr/bin/env bash
# Runs claims-paths against throwaway git repos. No network, no deps.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
check="$here/scripts/claims-paths.sh"
fail=0

setup() {
  dir=$(mktemp -d); cd "$dir" || exit 1
  git init -q -b main; git config user.email t@t; git config user.name t
  mkdir -p src/lib; echo a > src/lib/a.ts; echo b > src/lib/b.ts
  git add .; git commit -qm base; git checkout -q -b pr
  echo a2 > src/lib/a.ts; git commit -qam change
}

expect() { # expect <label> <want-exit> <want-output> <body>
  out=$(printf '%s\n' "$4" | bash "$check" main 2>&1); code=$?
  if [ "$code" -ne "$2" ] || [ "$out" != "$3" ]; then
    echo "FAIL $1 (exit $code, got: '$out')"; fail=1
  else
    echo "pass $1"
  fi
}

setup
expect "touched path passes" 0 "" 'Changed `src/lib/a.ts`.'
expect "untouched path is flagged" 1 "src/lib/b.ts" 'Changed `src/lib/a.ts` and `src/lib/b.ts`.'
expect "scoped package is not a path" 0 "" 'Uses `@anthropic-ai/sdk` in `src/lib/a.ts`.'
expect "scoped package with version" 0 "" 'Bumps `@types/node@22.1.0`.'
expect "folder holding a touched file passes" 0 "" 'Work is in `src/lib/`.'
expect "urls are ignored" 0 "" 'See `https://example.com/a/b`.'

# A real folder named @scope/name in the tree is still a path claim.
mkdir -p @acme/ui; echo x > @acme/ui/index.ts; git add .; git commit -qm scoped-folder
git checkout -q main; git merge -q --ff-only pr 2>/dev/null; git checkout -q -b pr2
echo y > src/lib/b.ts; git commit -qam other
expect "scoped name that exists in tree is still checked" 1 "@acme/ui" 'Edited `@acme/ui` and `src/lib/b.ts`.'

# Folder tokens are compared as plain strings, never as a pattern (PR 4 verdict).
mkdir -p ab; echo f > ab/f; git add .; git commit -qm ab
expect "two-letter folder holding a touched file passes" 0 "" 'Work is in `ab/`.'
expect "brackets in a folder token are literal" 1 "a[b]" 'Work is in `a[b]/`.'
expect "star in a folder token is literal" 1 "a*" 'Work is in `a*/`.'
expect "caret in a folder token is literal" 1 "^ab" 'Work is in `^ab/`.'
expect "dot in a folder token is literal" 1 "a." 'Work is in `a./`.'

exit $fail
