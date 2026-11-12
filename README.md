# zao-harness

The ZAO's guide to coding harnesses: the setups people use to run AI coding agents, with links to each one, so you can pick the one that fits you.

This repo is the info hub. It does not hold the harnesses themselves: each one lives in its own repo, and this page links out to it. Everything here is built in public.

## Pick a harness

| Harness | Built by | What it is | Good if you | Link |
|---|---|---|---|---|
| zorca on Orca | Zaal | Zaal's operating layer on top of Orca: a playbook with safety rails, a task board, and the tools he runs The ZAO with | want the setup The ZAO runs on, many agents at once | [bettercallzaal/zorca](https://github.com/bettercallzaal/zorca) |
| Orca | Stably | Free MIT app that runs Claude Code, Codex and others side by side, each in its own git worktree | want many agents in parallel with a GUI | [stablyai/orca](https://github.com/stablyai/orca) |
| Claude Code + ZAO rules | The ZAO | Claude Code in the terminal with this repo's `CLAUDE.md`, `AGENTS.md` and skills | want one agent, simple, in the terminal | [install below](#zao-rules-for-any-harness) |
| Codex + ZAO rules | The ZAO | OpenAI's Codex CLI reading the same `AGENTS.md` | already pay for ChatGPT | [install below](#zao-rules-for-any-harness) |

Built your own harness or a workflow that works? Add a row: open a PR that adds it to this table (name, who built it, one line on what it is, who it suits, link). Or open an issue and we add it.

How to choose: [docs/choose-a-harness.md](docs/choose-a-harness.md). The one-download plan for newcomers: [docs/zao-orca.md](docs/zao-orca.md).

## What would you want in your ideal harness?
That is the question this repo started from. Open an issue with your answer: the tools you wish every session started with, the rules that saved you, the skills you keep rewriting. Plan: [ZAOresearch doc 1969](https://github.com/ZAODEVZ/ZAOresearch/pull/30).

## ZAO rules for any harness
Whatever harness you pick, these files make the agent follow The ZAO's rules. Clone this repo, then from the ZAO repo you are working in:

- Windows (PowerShell): `..\zao-harness\scripts\install.ps1`
- Mac / Linux: `../zao-harness/scripts/install.sh`

It copies `CLAUDE.md`, `AGENTS.md` and `.claude/skills/` into that repo (it never overwrites a file that is already there).

Claims paths check: flags paths a PR description names that the PR never touches, and skips scoped package names like `@scope/name`. See [docs/claims-paths.md](docs/claims-paths.md).

## Skills worth installing on day one
Public skill repos that fit ZAO work, picked in [ZAOresearch doc 2477](https://github.com/ZAODEVZ/ZAOresearch/tree/main/research/dev-workflows/2477-five-reddit-links-12-nov-agent-repos-shortcuts-skills-starwire-zaowire). Each is a folder you drop into `.claude/skills/` (or the Codex equivalent).

| Skill repo | What it gives the agent | Use it on |
|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | The Word, PDF, PowerPoint and Excel skills behind Claude's document tools | Any doc, deck or sheet a ZAO repo produces |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | 40+ React and Next.js performance rules ranked by impact, 100+ UI checks, a Vercel deploy skill | zao-website, Sparkz, every Next.js repo |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Design commands for a coding agent: critique, audit, polish, bolder, quieter | Any screen that "looks bad" before a redesign |

## Contact
The ZAO: info@thezao.com. MIT licensed, see LICENSE.
