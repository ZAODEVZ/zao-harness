#!/usr/bin/env bash
# claims-paths: list the paths a PR description names that the PR does not touch.
#
# This is the path part of a merge "claims gate": a PR body that says it changed
# `src/lib/foo.ts` when the diff never touches it is a fabricated claim.
#
# The trap this file fixes (cowork card #10586): a scoped npm package name like
# `@scope/name` has a slash, so a naive gate reads it as a path, finds no such
# file in the diff, and refuses the merge. Rule here: a token shaped like
# @scope/name (optionally @scope/name@1.2.3) that does NOT exist in the repo
# tree is a package name, not a path claim, and is skipped. If it DOES exist in
# the tree (a real folder named @scope/name), it is still checked as a path.
#
# Usage: scripts/claims-paths.sh <base-ref> [body-file]   (body on stdin if no file)
# Prints one untouched path per line. Exit 1 if any, 0 if none, 2 on bad input.
# Source it to reuse is_scoped_package_ref in another gate:
#   source scripts/claims-paths.sh; is_scoped_package_ref "@scope/name" && echo pkg
set -u

# 0 if $1 is a scoped package reference that is not a path in the repo tree.
is_scoped_package_ref() {
  local tok="$1"
  [[ "$tok" =~ ^@[a-z0-9][a-z0-9._~-]*/[a-z0-9][a-z0-9._~-]*(@[^/[:space:]]+)?$ ]] || return 1
  # Present in the tree at HEAD (file or folder)? Then it is a path, not a package.
  local bare="$tok"
  [[ "$tok" =~ ^(@[^/]+/[^@]+)@.+$ ]] && bare="${BASH_REMATCH[1]}"
  if git cat-file -e "HEAD:$bare" 2>/dev/null; then return 1; fi
  return 0
}

# Path-like tokens from text in backticks: has a slash, or ends in .ext
claimed_tokens() {
  grep -o '`[^`[:space:]]\+`' | tr -d '`' | grep -E '/|\.[A-Za-z0-9]{1,6}$' | sort -u
}

claims_main() {
  local base="${1:-}"; local body="${2:-/dev/stdin}"
  if [ -z "$base" ] || ! git rev-parse --verify -q "$base" >/dev/null; then
    echo "claims-paths: base ref '${base}' not found" >&2; return 2
  fi
  local touched; touched=$(git diff --name-only "$base"...HEAD)
  local bad=0 tok
  while IFS= read -r tok; do
    [ -z "$tok" ] && continue
    case "$tok" in http://*|https://*) continue ;; esac
    if is_scoped_package_ref "$tok"; then continue; fi
    tok="${tok#./}"; tok="${tok%/}"
    # Touched if it is a changed file, or a folder that holds a changed file.
    if grep -qxF -- "$tok" <<< "$touched" || grep -q -- "^${tok//./\\.}/" <<< "$touched"; then continue; fi
    echo "$tok"; bad=1
  done < <(claimed_tokens < "$body")
  return $bad
}

# Run only when executed, not when sourced.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then claims_main "$@"; exit $?; fi
