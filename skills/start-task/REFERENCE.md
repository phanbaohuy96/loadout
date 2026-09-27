# start-task — reference

## Why the split saves, and when it does not

Measured on real sessions: about 99% of tokens are **cache reads** — the whole context re-read on
every turn. So a task costs context length × turns, far more than which model writes the code. The
implementer saves mainly because it starts clean, carrying the plan and not the grilling transcript;
the cheaper model saves again on top. But a spawn is not free (50–90k tokens on Claude, ~66k on
Codex), so a `small` task is done in the main session, and every run ends with `measure.py`.

## Models

| Harness | `fast` → implementer | `strong` → reviewer | How it is chosen |
|---|---|---|---|
| Claude Code | `sonnet`, effort medium | `opus`, effort high | `agents/start-task-*.md` frontmatter; aliases are always the newest model |
| Codex | resolved | resolved | `resolve-model.py codex <tier>` → `<model> <effort>` |
| Grok | resolved | resolved | `resolve-model.py grok <tier>` → `<model>`; effort is inherited |

`resolve-model.py` reads the preference list — the repository's `.agents/models.json` if it exists,
else `models.json` beside the script — takes the harness's live catalog (`~/.codex/models_cache.json`
or `codex debug models`; `grok models`), and returns the first candidate that answers a one-word
ping, cached for the day in `~/.cache/start-task/models/`. `--no-ping` skips the ping. Exit 3:
nothing answered — spawn without a model and it inherits the main session's.

The main session's model is fixed when it starts. Start it on the strong tier:

```bash
claude --model opus
read model effort < <(~/.codex/skills/start-task/resolve-model.py codex strong)
codex -m "$model" -c model_reasoning_effort="$effort"
grok -m "$(~/.claude/skills/start-task/resolve-model.py grok strong | cut -d' ' -f1)"
```

If the Claude agents are not installed (`~/.claude/agents/start-task-*.md`), spawn
`general-purpose` with `model: sonnet` (implementer) or `model: opus` (reviewer) instead.

## Plan format — `.agents/plans/<slug>.md`

```markdown
Started: 2026-09-27T14:05          # local ISO time; measure.py starts counting here
Size: small | normal

## Goal
One paragraph, in the project's own words (CONTEXT.md glossary if it has one).

## Changes
- `path/to/file` — what and why. Every file named; nothing else may change.

## Verify
- `exact command` — what passing looks like. Take them from AGENTS.md / CLAUDE.md / CI config.

## Out of scope
What the implementer must not touch.

## Open questions
None.   # must be empty before phase 2
```

Add sections the repository's rules demand (requirement IDs, translated strings, migrations…).
Keep the plan out of git: `grep -qx '.agents/plans/' .git/info/exclude || echo '.agents/plans/' >> .git/info/exclude`
(use `git rev-parse --git-path info/exclude` inside a worktree).

## Review skill names

The user types a skill as they know it (`/review`, `code-review`, `security-review`…). The reviewer
strips a leading `/` and looks for it in its harness; if absent it tries `gstack-<name>` (how gstack
names skills in Codex). Not found → it says so and falls back to the `builtin` checklist. Claude
Code's built-in `/code-review <PR>` can also be run by the user as a second opinion.
