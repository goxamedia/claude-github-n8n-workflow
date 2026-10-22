#!/usr/bin/env sh
# Runs the task in prompts/claude-task.md with Claude Code, no questions asked:
# Claude may read and edit files and use git add/commit/push, nothing else.
# The full session is saved to claude-run.jsonl so you can see every step.
set -e
cd "$(dirname "$0")/.."
claude -p "$(cat prompts/claude-task.md)" \
  --allowedTools "Read" "Edit" "Write" "Bash(git status:*)" "Bash(git diff:*)" "Bash(git add:*)" "Bash(git commit:*)" "Bash(git push:*)" \
  --output-format stream-json --verbose > claude-run.jsonl
echo "Done. Session log: claude-run.jsonl"
