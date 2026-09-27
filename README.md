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

`start-task` expects [`grill-with-docs`](https://github.com/mattpocock/skills) to be installed, and
falls back to grilling inline when it is not.
