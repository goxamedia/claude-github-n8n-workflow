# Runs the task in prompts/claude-task.md with Claude Code, no questions asked:
# Claude may read and edit files and use git add/commit/push, nothing else.
# The full session is saved to claude-run.jsonl so you can see every step.
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$task = Get-Content -Raw 'prompts/claude-task.md'
claude -p $task `
  --allowedTools 'Read' 'Edit' 'Write' 'Bash(git status:*)' 'Bash(git diff:*)' 'Bash(git add:*)' 'Bash(git commit:*)' 'Bash(git push:*)' `
  --output-format stream-json --verbose | Out-File -Encoding utf8 claude-run.jsonl
Write-Host 'Done. Session log: claude-run.jsonl'
