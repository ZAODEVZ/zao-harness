# AGENTS.md

Codex and other agents: follow `CLAUDE.md` in this folder. It is the single source of the ZAO rules.

When more than one agent works in the same repo:
- One git worktree per agent.
- Add an `Agent: <name>` line to every commit message.
- Never stack PRs; check the PR is open before pushing to it.
