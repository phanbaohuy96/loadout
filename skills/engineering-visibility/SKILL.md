---
name: engineering-visibility
description: Turn real engineering work (commits, PRs, merge requests, tickets) into client-facing visibility — daily standup talking points, a weekly "what we shipped" digest, sharp PR/MR descriptions, and sprint demo scripts. Use when preparing for standup/DSM, writing a status update or weekly summary for a client, cleaning up a PR description, or prepping a sprint demo. Triggers include "standup notes", "DSM points", "what did we ship", "weekly digest", "status update for the client", "rewrite this PR", "demo script". Works with GitHub and Jira/Linear/Azure DevOps, or from pasted git logs / ticket exports.
---

# Engineering Visibility

Convert actual engineering activity into formats clients see: standup lines, weekly digest, PR descriptions, and demo scripts. Surface true work — never manufacture the appearance of it.

## Quick start

1. Pick a mode: `standup`, `digest`, `pr`, or `demo`
2. Confirm: **window** (yesterday / this sprint / this week), **scope** (platform/team), **people** (all or subset)
3. Paste raw data — `git log --since=... --pretty=format:'%h %an %s'`, PR list, or ticket export — or connect GitHub/Jira
4. Receive paste-ready Markdown

## Modes at a glance

| Mode | When | Output |
|------|------|--------|
| `standup` | Every morning before DSM | Per-engineer: Done / Today / Blocker (~20 sec spoken) |
| `digest` | Every Friday | Weekly client "What We Shipped" (60-sec read) |
| `pr` | Before opening any PR | Rewritten title + description with ticket link |
| `demo` | End of sprint | Demo running order + customer release notes |

## Hard rules (non-negotiable)

- **Only real work** — every claim traces to a commit SHA, PR/MR number, or ticket key; if it can't, don't state it
- **No inflation** — open PR = "in review", not "shipped"; in-progress is never "done"
- **Correct attribution** — git author / ticket assignee on every line; never absorb one person's work into another's name
- **No data, no output** — if the activity data is missing, ask the user to paste it; do not fabricate to fill a template
- **Specific over boastful** — plain factual lines with IDs land harder and survive scrutiny

See [REFERENCE.md](REFERENCE.md) for detailed output format and examples per mode.
