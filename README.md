# Claude Code → GitHub → n8n

One workflow instead of three separate tools:

1. **Claude Code** works on your code from one written task.
2. **GitHub** keeps every change (commit + push).
3. **n8n** sees the new commit by itself and finishes the job: it writes release notes from the change and publishes a GitHub Release.

You write the task. Nothing else is manual.

```
prompts/claude-task.md ──► Claude Code ──► git commit + push ──► GitHub
                                                                   │
                     GitHub Release  ◄── n8n (checks every minute) ┘
```

## What is in this repo

| File | What it is |
|---|---|
| `site/index.html` | The example project: a small creator links page |
| `prompts/claude-task.md` | The task Claude Code runs (add a "Latest video" card, commit, push) |
| `scripts/run-claude-task.sh` / `.ps1` | Runs the task with Claude Code, no questions asked, and saves the session log |
| `n8n/claude-github-release.workflow.json` | The n8n workflow: new commit → release notes → GitHub Release |

## Setup (about 10 minutes)

**You need:** [Claude Code](https://docs.anthropic.com/en/docs/claude-code), git, a GitHub account, and n8n (self-hosted or n8n Cloud).

1. **Use this repo as your own.** Click *Use this template* (or fork it), then clone your copy.
2. **Give n8n access to GitHub.** On GitHub: *Settings → Developer settings → Fine-grained tokens → Generate new token*. Select **only your copy of this repo**, and under *Repository permissions* set **Contents: Read and write**. In n8n: *Credentials → Add credential → GitHub API*, paste the token.
3. **Import the workflow.** In n8n: *Workflows → Import from file* → `n8n/claude-github-release.workflow.json`.
   - Open the **Settings** node and put your GitHub username and repo name.
   - Open **Latest commit** and **Publish GitHub release** and select your GitHub credential.
   - **Activate** the workflow (toggle at the top). It checks for new commits every minute.
4. **Run the task.**
   ```sh
   ./scripts/run-claude-task.sh        # macOS / Linux
   ./scripts/run-claude-task.ps1       # Windows PowerShell
   ```
   Claude Code adds the card, commits and pushes. Within a minute n8n publishes a release on your repo's *Releases* page.

## How it works

- **Claude Code** runs in headless mode (`claude -p`). It may only read and edit files and use `git status/diff/add/commit/push`.
- **n8n** asks GitHub for the latest commit on `main` every minute and remembers the last one it saw. The first run only records the current commit. When a new commit appears, n8n builds release notes from the commit message and the changed files, then creates a release tagged `update-<date>-<time>-<commit>`.
- Want to push without a release? Put `[skip release]` in the commit message.

### Notes

- n8n only remembers the last commit while the workflow is **active**. A manual *Test workflow* run does not save it.
- If your n8n has a public URL, you can replace the *Every minute* trigger with n8n's **GitHub Trigger** node (push event) for instant releases. The polling version also works on a laptop with no public URL.
- Change the task: edit `prompts/claude-task.md`. Change what n8n does after a commit: replace **Publish GitHub release** with any n8n node (post to Slack, send an email, update a sheet...).

## License

MIT
