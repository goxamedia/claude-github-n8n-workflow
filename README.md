# Claude Code → GitHub → n8n

One workflow instead of three separate tools:

1. **Claude Code** works on your code from one written task.
2. **GitHub** keeps every change (commit + push).
3. **n8n** sees the new commit by itself and finishes the job: it writes release notes and updates a public changelog page.

You write the task. Nothing else is manual. n8n needs **no GitHub login and no token**: it reads your public repo.

```
prompts/claude-task.md ──► Claude Code ──► git commit + push ──► GitHub (public repo)
                                                                   │
        changelog page  ◄── n8n (checks every 2 minutes, no login) ┘
```

## What is in this repo

| File | What it is |
|---|---|
| `site/index.html` | The example project: a small creator links page |
| `prompts/claude-task.md` | The task Claude Code runs (add a "Latest video" card, commit, push) |
| `scripts/run-claude-task.sh` / `.ps1` | Runs the task with Claude Code, no questions asked, and saves the session log |
| `n8n/claude-github-changelog.workflow.json` | The n8n workflow: new commit → release notes → changelog page |

## Setup (about 5 minutes)

**You need:** [Claude Code](https://docs.anthropic.com/en/docs/claude-code), git, a GitHub account, and n8n (self-hosted or n8n Cloud).

1. **Use this repo as your own.** Click *Use this template*, keep it **public**, then clone your copy.
2. **Import the workflow.** In n8n: *Workflows → Import from file* → `n8n/claude-github-changelog.workflow.json`.
   - Open the **Settings** node and put your GitHub username and repo name.
   - **Activate** the workflow (toggle at the top). It checks for new commits every 2 minutes.
   - Open the **Changelog page** node and copy its *Production URL*: that is your changelog page.
3. **Run the task.**
   ```sh
   ./scripts/run-claude-task.sh        # macOS / Linux
   ./scripts/run-claude-task.ps1       # Windows PowerShell
   ```
   Claude Code adds the card, commits and pushes. Within 2 minutes the change appears on your changelog page.

## A real run

Claude made the change in commit [`d6c9760`](https://github.com/goxamedia/claude-github-n8n-workflow/commit/d6c976092e857e15aaae04effe5d5ce5d783e20c) (one line in `site/index.html`): the task in `prompts/claude-task.md`, no other input.
n8n picked the commit up on its next check, under 2 minutes later, and added it to its changelog page with no one touching anything.
The next commit puts the page back to three cards so you start from a clean template.

## How it works

- **Claude Code** runs in headless mode (`claude -p`). It may only read and edit files and use `git status/diff/add/commit/push`.
- **n8n** asks GitHub's public API for the latest commit on `main` every 2 minutes (GitHub allows 60 anonymous requests per hour) and remembers the last one it saw. The first run only records the current commit. When a new commit appears, n8n writes release notes from the commit message and the changed files and adds them to the changelog it keeps.
- The **Changelog page** node serves that changelog as a web page. Anyone with the link can open it.
- Want to push without a changelog entry? Put `[skip changelog]` in the commit message.

### Notes

- n8n only remembers commits while the workflow is **active**. A manual *Test workflow* run does not save them.
- Private repo? Add a GitHub credential to the **Latest commit** node.
- Change the task: edit `prompts/claude-task.md`. Change what n8n does after a commit: add any n8n node after **Write release notes** (Slack, email, a sheet, a GitHub Release...).

## License

MIT
