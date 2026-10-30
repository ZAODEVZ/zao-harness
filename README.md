# zao-harness

One setup for every ZAO dev and agent: the ZAO rules, skills and tools, ready in Claude Code or Codex.
Plan: [ZAOresearch doc 1969](https://github.com/ZAODEVZ/ZAOresearch/pull/30).

## Install
Clone this repo, then from the ZAO repo you are working in:

- Windows (PowerShell): `..\zao-harness\scripts\install.ps1`
- Mac / Linux: `../zao-harness/scripts/install.sh`

It copies `CLAUDE.md`, `AGENTS.md` and `.claude/skills/` into that repo (it never overwrites a file that is already there).

## What is in it (build order)
| Step | What | Status |
|---|---|---|
| 1 | Rules (`CLAUDE.md`, `AGENTS.md`) + skills | started |
| 2 | MCP pack: Context7, Chrome DevTools, defuddle (`.mcp.json`) | next |
| 3 | Many agents, one repo: claims file + commit trailer | later |
| 4 | Auto-research bot: link in on Telegram, PR to ZAOresearch out | later |
| 5 | Content lane: Kokoro voice, Remotion, MotionClone test | later |

Private until the doc 1956 public-repo checklist passes.
