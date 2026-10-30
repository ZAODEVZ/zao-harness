#!/bin/sh
# Copies the ZAO rules and skills into the current repo. Never overwrites.
H="$(cd "$(dirname "$0")/.." && pwd)"
for f in CLAUDE.md AGENTS.md; do [ -e "$f" ] && echo "kept your $f" || cp "$H/$f" "$f"; done
mkdir -p .claude/skills
for s in "$H"/.claude/skills/*/; do n=$(basename "$s"); [ -e ".claude/skills/$n" ] && echo "kept skill $n" || cp -r "$s" ".claude/skills/$n"; done
echo "ZAO harness installed"
