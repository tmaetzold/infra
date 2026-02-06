# Project CLAUDE.md Template

<!-- Annotated example based on the loom project. -->
<!-- Use this as a reference when creating or evaluating project CLAUDE.md files. -->

```markdown
# CLAUDE.md

<!-- One-liner. What is this and why does it exist. -->
Portfolio analytics dashboard — Dash app for custom basket comparison and trader analytics. Deployed via Posit Connect.

## Project Structure

<!-- ALWAYS INCLUDE THIS. Run tree and paste the output. -->
<!-- Saves massive time vs traversing the filesystem every session. -->
<!-- Update when the structure changes meaningfully. -->
<!-- Suggested flags: tree -L 3 --dirsfirst -I '.git|node_modules|__pycache__|.venv|*.egg-info' -->

.
├── data                    # Static CSV metadata
├── docs
│   ├── NEW_PAGES_PLAN.md
│   └── ROADMAP.md          # Source of truth for planning/priorities
├── loom
│   ├── assets              # JS/CSS served by Dash
│   ├── backend
│   │   ├── analytics.py    # Calculations, transforms
│   │   └── data.py         # Data fetching from grapefruit/APIs
│   ├── components
│   │   ├── ids.py          # All callback-referenced component IDs
│   │   ├── stores.py       # Data stores + update callbacks
│   │   ├── settings.py     # Settings component + callbacks
│   │   ├── search.py       # Search component + callbacks
│   │   └── navbar.py       # Navbar layout (no callbacks)
│   ├── pages               # Page layouts + page-specific callbacks
│   ├── app.py              # Root layout + cross-cutting callbacks
│   ├── __main__.py         # CLI entry point (click)
│   ├── constants.py
│   └── utils.py
├── tests
│   ├── backend             # Unit + integration tests for data/analytics
│   └── pages               # Page-level tests
├── pyproject.toml
└── manifest.json           # Posit Connect deployment config

<!-- Annotate directories/files whose purpose isn't obvious from the name. -->
<!-- Don't annotate everything — just what would confuse a new reader. -->

## Running

<!-- Copy-paste ready. No prose, just commands. -->

uv sync                     # Install deps
uv run loom run             # Production mode
uv run loom run -d          # Debug mode (verbose logging)
uv run loom run -p 8080     # Custom port

## Task Runners

<!-- Whatever the project uses: make, just, poe, npm scripts, etc. -->

uv run poe lint             # ruff format + ruff check --fix (with isort)
uv run poe test             # pytest
uv run poe typecheck        # basedpyright
uv run poe export           # Export requirements.txt (also runs on commit when deps change)

## Testing

<!-- How to run tests, markers/flags, and any testing conventions. -->

pytest with markers: `pytest -m unit`, `pytest -m integration`

Every data getter function needs two tests:
1. Integration test — confirms data source returns expected schema
2. Unit test — mocks the data pull, tests transformations

## Pre-commit Hooks

<!-- What runs on commit so the agent doesn't fight the hooks. -->

Runs on commit: ruff format → ruff check --fix → export requirements.txt (if pyproject.toml or uv.lock changed).

After cloning: `uv run pre-commit install`

## Code Style

<!-- Only project-specific style rules. General preferences live elsewhere. -->

- 120 char line length, Google-style docstrings
- Document DataFrame return columns in docstrings
- f-strings for formatting, `df.itertuples()` over `df.iterrows()`

## Conventions

<!-- Project-specific patterns that aren't obvious from the code. -->
<!-- Skip this section entirely if the project follows standard conventions. -->

### Component IDs (`loom/components/ids.py`)

Only IDs referenced by callbacks go in ids.py. Inline IDs for internal wiring only.

Pattern: `PAGE_OBJECTTYPE_DESCRIPTION` → `SUMMARY_GRID_TOPPERFORMERS`

### Callback co-location

Callbacks live in the same file as the component they modify, right after the component function.

### Component visibility

Wrap in a div with an ID, toggle `style={"display": "none"}` vs `style={}` via callback.

## Git

<!-- Use conventional commits across all repos. -->
<!-- Format: <type>[optional scope]: <description> -->
<!-- Lowercase type, imperative description, no period at end. -->

Types:

- `feat` — new feature or capability
- `fix` — bug fix
- `refactor` — code change that neither fixes a bug nor adds a feature
- `docs` — documentation only
- `test` — adding or updating tests
- `style` — formatting, whitespace, linting (no logic change)
- `perf` — performance improvement
- `build` — build system or dependency changes
- `ci` — CI/CD configuration
- `chore` — maintenance tasks that don't fit above
- `revert` — reverts a previous commit

Scope is optional, in parentheses: `fix(auth): handle expired tokens`

Breaking changes: append `!` before colon: `feat!: redesign API response format`
```
