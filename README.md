# leo-vibe-starter

> A battle-tested Claude Code starter kit for developers who want to ship faster with AI — not fight it.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

---

## What's inside

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Tells Claude how to work in your project — the single most impactful file |
| `.claude/settings.json` | Permissions, hooks, and sane defaults so Claude stops asking for approval on every `git status` |

No dependencies. No install script. Copy two files and Claude Code becomes a better collaborator immediately.

---

## Quickstart

```bash
# Clone into your project
git clone https://github.com/Tech-Messager/leo-vibe-starter.git
cp leo-vibe-starter/CLAUDE.md ./CLAUDE.md
cp -r leo-vibe-starter/.claude ./.claude

# Open in Claude Code and start vibe coding
claude
```

Then fill in the `<!-- -->` sections in `CLAUDE.md` with your project context. That's it.

---

## Why CLAUDE.md matters

Claude Code reads `CLAUDE.md` at the start of every session. Without it, Claude makes silent assumptions, over-engineers solutions, and asks too many questions.

With a good `CLAUDE.md`, Claude:
- Knows your stack and coding style before the first message
- Follows your preferences without repeating them every session
- Applies the right level of caution to the right actions

---

## The 4 coding rules inside (Karpathy-inspired)

This starter enforces four principles that prevent the most common LLM coding mistakes:

1. **Think before coding** — surface assumptions, don't hide confusion
2. **Simplicity first** — minimum code that solves the problem
3. **Surgical changes** — touch only what the task requires
4. **Goal-driven** — define verifiable success criteria, then loop until met

---

## Customize it

`CLAUDE.md` is a template. The `<!-- Fill in -->` comments tell you exactly what to replace:

```markdown
## Project Context
- **Stack**: <!-- e.g. Python + FastAPI + PostgreSQL -->
- **Goal**: <!-- What problem does this project solve? -->
```

Everything else works out of the box.

---

## Who is this for

- Developers new to Claude Code who want a head start
- Teams who keep re-explaining preferences to Claude every session
- Anyone who's had Claude "helpfully" refactor code they didn't ask to change

---

## Contributing

PRs welcome. If you've found a CLAUDE.md pattern that meaningfully improved your workflow, open a PR — include a one-line description of the problem it solves.

---

## License

MIT
