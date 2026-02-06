# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- SSH hosts and aliases
- Database connection details
- Local dev server ports and URLs
- Staging/production endpoints
- CLI aliases or shortcuts
- API quirks and rate limits
- Anything environment-specific

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

## Skills Rule: If You Learned It, Write It Down

When you figure out how to use a CLI, API, or multi-step process — turn it into a skill. Without one, every new session re-discovers the same thing through trial and error. That's wasted tokens and wasted time.

Each skill lives at `.claude/skills/{skill_name}/SKILL.md` and should include:

- **Purpose** — what it does, when to use it
- **Prerequisites** — what's installed, configured, or authenticated
- **Input/Output templates** — what goes in, what comes out, with placeholders
- **Execution template** — exact commands, copy-paste ready

**CLI trial-and-error happens once.** After that, it's a skill with a template. If you find yourself running `--help` or guessing at flags for something we've done before, stop and make a skill.

### Brief examples (delete each as you create real skills to replace them)

**`.claude/skills/bitbucket-pr-comments/SKILL.md`** — Fetch PR comments via `bb` CLI, summarize grouped by file, flag unresolved items at top.

**`.claude/skills/jira-todos/SKILL.md`** — Pull current sprint items via `jira` CLI, format by status (In Progress / To Do), sort by priority.

**`.claude/skills/ms-graph-email/SKILL.md`** — Read recent emails via MS Graph API, triage into "Needs Attention" vs "FYI", skip noise.

## Skill Inventory

Keep this list current. When you create, rename, or delete a skill, update it here.

<!-- Example:
- **bitbucket-pr-comments** — `.claude/skills/bitbucket-pr-comments/SKILL.md`
- **jira-todos** — `.claude/skills/jira-todos/SKILL.md`
-->

_(none yet)_

---

Add whatever helps you do your job. This is your cheat sheet.
