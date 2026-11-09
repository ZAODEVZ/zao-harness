# Claims paths check

A merge "claims gate" compares the paths a PR description names (in backticks) with the files the PR actually changes. A path that the PR never touches is a claim that is not true, and the gate refuses the merge.

## The bug it fixes

A scoped npm package name such as `@anthropic-ai/sdk` or `@types/node@22.1.0` has a slash, so a simple gate reads it as a path, finds no such file in the diff, and blocks a good PR.

The rule here: a token shaped like `@scope/name` (with or without `@version`) that is **not** in the repo tree is a package name, and the gate skips it. If the repo really has a folder called `@scope/name`, it is still checked as a path.

## Run it

```bash
gh pr view 12 --json body -q .body | bash scripts/claims-paths.sh origin/main
```

It prints each untouched path and exits 1, or prints nothing and exits 0.

## Use it in another gate

```bash
source scripts/claims-paths.sh
is_scoped_package_ref "@scope/name" && echo "package, skip it"
```

Bash and git only. Tests: `bash tests/claims-paths.test.sh` (7 cases).
