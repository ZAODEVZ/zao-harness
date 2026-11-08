# Guard wiring check

A rule is only as strong as the check that refuses its breach. A new guard script does nothing until something runs it.

## What it does

On every PR, `scripts/guard-wiring-check.sh` looks at the files the PR **adds**. For each new `bin/*guard*` or `bin/*-warn` file it asks one question: does another file in the same PR name it, and is that file a hook registration or a test?

- Counts as a hook registration: `settings.json`, `settings.local.json`, `hooks.json`, `install.sh`, `install.ps1`, a `Makefile`, a GitHub workflow.
- Counts as a test: anything under `test/` or `tests/`, or named `*.test.*`, `*_test.*`, `test_*`, `*.bats`.

If nothing names it, the PR gets a warning on that file. It does not block the merge. Pass `--strict` to make it fail instead.

## Run it by hand

```bash
bash scripts/guard-wiring-check.sh origin/main
bash scripts/guard-wiring-check.sh origin/main --strict
```

## Use it in another repo

Copy two files into that repo, keeping the paths:

- `scripts/guard-wiring-check.sh`
- `.github/workflows/guard-wiring.yml` (drop the self-test step if you do not copy `tests/`)

Bash and git only. No other dependencies.
