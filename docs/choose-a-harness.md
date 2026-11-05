# Choose a harness

A harness is the setup around an AI coding agent: the app it runs in, the rules it follows, the tools it can use. Three questions decide most of it.

## 1. One agent or many?
- **One agent at a time:** Claude Code or Codex in the terminal, plus the ZAO rules from this repo. Nothing else to install.
- **Many agents at once:** Orca. Each task gets its own git worktree, so agents do not step on each other. zorca adds Zaal's playbook and board on top.

## 2. Which plan do you already pay for?
- Claude plan: Claude Code.
- ChatGPT plan: Codex.
- Both: use one to write and the other to review. Orca runs both side by side.
- Bring your own plan. Never use someone else's account or key.

## 3. How much do you want the agent to do on its own?
- Orca starts agents with every approval switched off by default. On day one set Settings, Agents, Agent Permissions to **Manual**, and turn telemetry off in Settings, Privacy.
- Keep `.env` files and keys out of git and out of Orca's `.worktreeinclude`.

## The ZAO's own setup
Zaal runs zorca on Orca. Details and the safety rails: [bettercallzaal/zorca](https://github.com/bettercallzaal/zorca). Full Orca research: [ZAOresearch doc 2423](https://github.com/ZAODEVZ/ZAOresearch/tree/research-2423/research/dev-workflows/2423-orca-open-source-lean-setup-and-zao-orca).

## Add yours
Built a harness or a workflow that works for you? Add it to the table in the [README](../README.md) with a PR.
