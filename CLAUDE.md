# Claude Code Instructions
<!-- This file is loaded automatically at the start of every Claude Code session.
     Fill in the sections marked with <!-- Fill in --> to teach Claude your project. -->

## Project Context

- **Name**: <!-- Fill in: e.g. "MyApp" -->
- **Stack**: <!-- Fill in: e.g. "Python 3.12 + FastAPI + PostgreSQL + React" -->
- **Goal**: <!-- Fill in: one sentence — what problem does this project solve? -->
- **Current focus**: <!-- Fill in: what are you actively building right now? -->

## Coding Rules

### 1. Think before coding
State assumptions explicitly before writing code. If the requirement is ambiguous, name the ambiguity and ask — don't silently pick one interpretation. If a simpler approach exists, say so.

### 2. Simplicity first
Write the minimum code that solves the problem. No abstractions for single-use cases. No error handling for impossible scenarios. No features that weren't asked for. If 50 lines can do what 200 lines does, rewrite it.

### 3. Surgical changes
Touch only what the task requires. Don't improve adjacent code, fix unrelated style, or refactor things that aren't broken. If you notice unrelated dead code, mention it — don't delete it. Every changed line should trace directly to the request.

### 4. Goal-driven execution
For any non-trivial task, state a brief plan with verifiable checkpoints before starting:
```
1. [Step] → verify: [how to confirm it worked]
2. [Step] → verify: [how to confirm it worked]
```

## Communication Style

- Responses: short and direct. No trailing summaries — the diff speaks for itself.
- When referencing code: use `file_path:line_number` format.
- When uncertain: ask, don't assume.
- When blocked: say so immediately with the specific blocker.

## Project-Specific Rules

<!-- Add rules that apply only to this project. Examples:
- "Never modify files in /legacy — that code is frozen"
- "All API endpoints must have a corresponding test"
- "Use `ruff` for linting, not `flake8`"
- "Branch names follow the pattern: feat/short-description"
-->

## What NOT to do

- Don't add comments that describe what the code does — good names do that.
- Don't create documentation files unless explicitly asked.
- Don't run destructive git commands (reset --hard, push --force) without confirming.
- Don't install packages without checking if an equivalent already exists in the project.

## Commit Style

<!-- Fill in your preferred format. Example:
feat: add user authentication
fix: resolve null pointer in payment flow
refactor: simplify order calculation logic
-->

## Stack-Specific Notes

<!-- Fill in anything Claude should know about your specific setup. Examples:
- "The dev server runs on port 3001, not 3000"
- "Environment variables live in .env.local, never .env"
- "We use pnpm, not npm or yarn"
- "Database migrations go in /db/migrations and must be reviewed before running"
-->
