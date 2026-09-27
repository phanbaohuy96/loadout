# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo (**loadout**) is a personal skill library for AI coding agents. Skills here are installed as symlinks into both Claude Code (`~/.claude/skills/`) and Codex (`~/.codex/skills/`) so they're available in every session. Grok reads `~/.claude/skills/` too.

## Install

```bash
./install.sh                  # install all skills
./install.sh engineering-visibility  # install one skill
```

The script creates symlinks — edits to files here take effect immediately without reinstalling.

## Adding a skill

1. Create `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`)
2. Add `REFERENCE.md` alongside it if the content exceeds ~80 lines
3. Run `./install.sh <name>`

## Skill structure

```
skills/<name>/
├── SKILL.md       # Required. Frontmatter + concise instructions (≤80 lines)
├── REFERENCE.md   # Optional. Detailed formats, examples, extended docs
└── agents/*.md    # Optional. Claude Code subagents; install.sh links them into ~/.claude/agents/
```

A skill that must work in every harness refers to its own files by the directory holding `SKILL.md` (it is symlinked to a different path in each), and scripts find their siblings through their own real path.

`SKILL.md` frontmatter fields used by both Claude Code and Codex:
- `name` — kebab-case identifier
- `description` — ≤1024 chars; first sentence: what it does; second: "Use when [triggers]"

The `description` is the only thing the agent sees when selecting a skill — make triggers explicit.
