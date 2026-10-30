# ZAO rules for agents

## Cost
- Lowest overhead. No paid tool unless it clearly beats Claude Code or Codex. Ask before any new spend.

## Git and PRs
- Never push or open a PR without the go-ahead of the repo owner.
- One PR per topic. Never stack PRs. Branch from fresh `main`.
- Before pushing to a PR branch, check the PR is still open (`gh pr view <n> --json state`). Merged PRs get a new branch.
- Research goes in ZAODEVZ/ZAOresearch only, numbered in the 1900-1999 band, one research PR open at a time, changelog row as the last commit.
- Markdown for Zaal goes in GitHub, never as a chat attachment. Send the link.

## Writing
- Write for the reader: short, plain words, facts only. If the reader is confused, we failed.
- One question per message, and no more than 5 open questions at once.
- Give times in the reader's time zone (Zaal: US Eastern).
- No em dash in any text shown in a UI.
- No "made with AI" labels baked into content.

## Music on stream
- Only play music we have the rights to stream. Check the distributor before a song goes in a stream crate (YouTube claims TuneCore and Revelator/Merlin releases).

## Safety
- Secrets live in env or the host's secret store, never in git.
- Security tools (scanners, pentest agents) only against our own staging copies, never a live site or anyone else's.
