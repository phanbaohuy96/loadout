---
name: start-task
description: Run one task end to end in any repository — grill it into a written plan with grill-with-docs on a strong model, hand the plan to a cheaper implementer subagent (or do a small task in place), check its work, ask before committing and opening a pull request, then review that PR with a fresh reviewer subagent running the review skill the user picks (default /review), and report the tokens each phase spent. Works in Claude Code, Codex and Grok. Use when the user says "start task", "bắt đầu task", "làm task", or hands over an issue or feature to take from idea to reviewed PR.
---

# Start a task

The strong model thinks; a cheaper model types, in a clean context; a fresh model reviews. The
repository's own rules (`AGENTS.md`, `CLAUDE.md`, `CONTEXT.md`) still apply — above all, nothing is
committed, pushed or opened without asking. `<skill>` below is the directory holding this file.

## Models and effort

| Work | Tier | Claude Code | Codex / Grok |
|---|---|---|---|
| Plan, check, review | `strong`, effort high | main session on `opus`; `start-task-reviewer` agent | `<skill>/resolve-model.py <codex\|grok> strong` |
| Implement | `fast`, effort medium | `start-task-implementer` agent (`sonnet`) | `<skill>/resolve-model.py <codex\|grok> fast` |

The resolver takes the harness's **live** catalog and returns the first preferred model that answers
a ping (prints `<model> <effort>`; exit 3 → spawn without a model). Details: `REFERENCE.md`.
If the main session is not on the strong tier, say so once and suggest restarting on it.

## Phase 1 — Plan
1. `git switch -c <type>/<slug>` from an up-to-date default branch (no need to ask).
2. Run **grill-with-docs** on the task. Not installed → grill inline: one question at a time, each
   with your recommendation; answer codebase questions by reading the code.
3. Write `.agents/plans/<slug>.md` and make sure `.agents/plans/` is in `.git/info/exclude`.
   Sections (format in `REFERENCE.md`): `Started:`, Size (`small` ≤ ~3 files, no new behaviour —
   or `normal`), Goal, Changes (every file named), Verify (exact commands), Out of scope,
   Open questions (must be empty).
4. Show the plan with its Size; wait for the go-ahead.

## Phase 2 — Implement
- **small:** do it yourself, following `<skill>/roles/implementer.md`. A spawn costs ~50–66k tokens.
- **normal:** spawn the implementer with only the plan path, branch and the line "Read
  `<skill>/roles/implementer.md`; it is your role." Claude: `subagent_type: start-task-implementer`.
  Codex: `spawn_agent` with `model` + `reasoning_effort` from the resolver (timeouts are integers).
  Grok: `spawn_subagent` with `model` from the resolver.
- Plan reported wrong or blocked → back to phase 1 with the user; never patch the design yourself.

## Phase 3 — Check
Never trust the report: `git diff --stat` matches **Changes** and nothing else moved; re-run every
**Verify** command yourself. Small fixes are fine; design changes go back to the user.

## Phase 4 — Commit and PR (ask first)
Show the diff summary, verify output and a commit message in the repository's style. Ask:
**commit, push and open a PR?** Yes → commit, `git push -u`, `gh pr create` (fill the repo's PR
template if any), give the URL. No → stop and say what is uncommitted.

## Phase 5 — Review the PR
Ask: **"Review with which skill? [/review]"** — accept any skill name, `builtin` (the checklist in
`<skill>/roles/reviewer.md`) or `skip`. Save the PR for a sandboxed subagent:
`gh pr view <n> --json number,title,body,headRefName,baseRefName,files > .agents/plans/<slug>.pr.json`
and `gh pr diff <n> > .agents/plans/<slug>.pr.diff`.
Spawn the reviewer (strong tier) with the three paths, the chosen skill, and "Read
`<skill>/roles/reviewer.md`; it is your role." Claude: `subagent_type: start-task-reviewer`.
Relay findings most severe first; ask: fix (small yourself, larger via another implementer run),
post as PR comments (outward-facing — only on a yes), or leave.

## Phase 6 — Report cost
`<skill>/measure.py claude` (or `codex`) — show the table; if the implementer's cache reads were not
well below the main session's, say the task was too small to split. Grok is not measured.
