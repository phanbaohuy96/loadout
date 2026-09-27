# loadout

Skills I carry into every AI coding session — Claude Code, Codex and Grok.

| Skill | What it does |
|---|---|
| [`start-task`](skills/start-task/SKILL.md) | One task from idea to reviewed PR: grill it into a plan on a strong model, implement on a cheaper subagent, ask before the PR, review it with the skill you pick (default `/review`), report tokens per phase. Models are resolved from each harness's live catalog. |
| [`engineering-visibility`](skills/engineering-visibility/SKILL.md) | Turn commits, PRs and tickets into standup notes, weekly digests, PR descriptions and demo scripts. |

## Install

```bash
git clone https://github.com/phanbaohuy96/loadout.git && cd loadout
./install.sh                # all skills
./install.sh start-task     # one skill
```

Skills are symlinked into `~/.claude/skills/` and `~/.codex/skills/` (Grok reads the Claude folder),
and any `agents/*.md` into `~/.claude/agents/`, so edits here take effect immediately.

## Dependencies

`start-task` builds on skills from two other libraries. Install them for the full workflow:

| Skill | From | Used for | Without it |
|---|---|---|---|
| `grill-with-docs` | [mattpocock/skills](https://github.com/mattpocock/skills) | Phase 1 — grilling the task into a plan | grills inline, one question at a time |
| `/review` (default review skill) | [garrytan/gstack](https://github.com/garrytan/gstack) | Phase 5 — reviewing the PR (`gstack-review` in Codex) | falls back to the builtin checklist in `roles/reviewer.md` |

At the review step you can name any other review skill instead, `builtin`, or `skip`.
