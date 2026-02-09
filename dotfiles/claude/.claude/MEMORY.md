# Long-Term Memory

Lessons, patterns, and things to remember across sessions. Daily logs go in `~/.claude/memory/YYYY-MM-DD.md`.

## Session Startup

Always follow the startup sequence from CLAUDE.md first — read rules, read recent daily memory files, check the project CLAUDE.md against `PROJECT.md`. Orientation before action. Don't jump straight to git/lint/tests on a status check.

## Project Status

When asked "what were we working on" — check the project's `ROADMAP.md` (or equivalent), not just git history. The roadmap has the full context: completed items, remaining work, blockers, priorities.

## Planning Multi-Phase Features

For non-trivial features spanning multiple issues:
1. Update `ROADMAP.md` with new issues (high-level tracking, checkboxes)
2. Create `docs/PLAN_*.md` for detailed implementation plan (data models, function signatures, file changes)

Both are needed — roadmap for tracking progress, plan for execution details.

## Project-Specific Memory

For project-specific context, use `project/.claude/memory/YYYY-MM-DD.md`. Global memory (`~/.claude/memory/`) is for cross-project lessons. Keep them separate.

## Git Commits

Never reference personal setup (`.claude/PROJECT.md`, template comparisons, etc.) in commit messages. Other devs on the repo don't have that context. Explanations should make sense purely within the project.

