# ZAO Orca: one download, then helping

Goal (Zaal, 5 Nov 2026): a person downloads one thing, signs in to Codex (or Claude Code), pastes the ZAO DEVZ GitHub, does nothing else, and is helping straight away.

## What exists today
- **Orca** (orca.stably.ai, MIT, github.com/stablyai/orca): the app that runs many coding agents side by side. Free to download.
- **zorca** (github.com/bettercallzaal/zorca): Zaal's layer on top of Orca. Public part is `PLAYBOOK.md`, the board GUI and the safety rails. The ~109 working tools live in a private dotfiles repo, by design.
- **zao-harness** (this repo): ZAO rules (`CLAUDE.md`, `AGENTS.md`), skills and install scripts. Works in Claude Code or Codex.

## The first-run flow
1. Download Orca.
2. Sign in to Codex (ChatGPT plan) or Claude Code inside it.
3. Paste `https://github.com/ZAODEVZ` into the first agent.
4. The agent reads `AGENTS.md` here, clones the repo you pick, runs `scripts/install`, and picks an open issue.

## Build steps
| Step | What | Status |
|---|---|---|
| 1 | `AGENTS.md` first-run block: "if you were given github.com/ZAODEVZ, do this" | next |
| 2 | `scripts/zao-orca.ps1` / `.sh`: checks Orca, git and gh, clones zao-harness, installs into the picked repo | next |
| 3 | Pull the safe, public zorca rules (danger words, no fabrication, receipt checks) into `AGENTS.md` | next |
| 4 | Test on a clean Windows machine and a Mac, time it from download to first PR | later |
| 5 | One-page "start here" on the ZAO DEVZ org profile | later |

## Open questions for Zaal
- Which zorca tools are OK to extract as public, canonical copies?
