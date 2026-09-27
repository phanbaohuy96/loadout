# Engineering Visibility — Reference

## Inputs

Pull from whatever is connected or provided:

- **GitHub** — commits, PRs, reviews, issues (via connected tool or pasted output)
- **Jira / Linear / Azure DevOps** — tickets, status transitions, story points, sprint scope
- **Fallback** — user pastes `git log --since=... --pretty=format:'%h %an %s'`, a PR/MR export, or a ticket CSV

## Mode: `standup`

Per-engineer DSM talking points. Three short lines per person:

- **Done** — output-backed items in the window, with IDs
- **Today** — concrete next action, ideally naming an expected artifact (e.g. "PR by EOD")
- **Blocker / ask** — or "none"

Keep each person to ~20 seconds spoken.

**Example output:**

> **Tana (iOS)** — Done: offline cart sync merged (PR #842); cold-start crash fixed (MOB-3311). Today: promo-code push wiring, PR expected EOD. Blocker: needs promo API contract from backend.
>
> **Ryo (Backend)** — Done: promo endpoint spec'd (LIN-204). Today: implementation, unit tests. Blocker: none.

Also emit a per-engineer copy block so each person can paste their own lines.

## Mode: `digest`

Weekly client-facing summary. Structure:

```
**Week of DD Mon — N PRs merged, M tickets closed across [platforms].**

### iOS
- Shipped: [feature] — [engineer] (PR #NNN, TKT-NNN)
- Fixed: [bug] — [engineer] (PR #NNN)
- In review: [feature] — [engineer] (PR #NNN)

### Android
...

### Backend
...

### Next week
- [Item] — [engineer]

### Risks / asks
- [Item]
```

Name the engineer on every line. Aim for a 60-second read. If evidence is thin for a person or period, say so plainly ("light week on Android — 1 PR, 2 tickets") rather than padding.

## Mode: `pr`

Rewrite a terse PR title or diff summary into:

1. **Title** — imperative, ≤72 chars (e.g. `Add offline cart sync with conflict resolution`)
2. **What & why** — 1–2 sentences on user-facing impact
3. **Ticket** — linked ticket key (e.g. `Closes MOB-3311`)
4. **Test notes** — how this was tested (unit / integration / manual)
5. **Screenshot** — placeholder if UI change (`<!-- screenshot -->`)

Goal: a client glancing at the repo reads a story, not "fix stuff".

## Mode: `demo`

From the sprint's closed tickets, produce:

**Demo running order** (5–8 minutes total):

```
1. [Feature name] — [Engineer] (2 min)
   Value: [One-line user benefit]
   Click path: [Step-by-step]

2. ...
```

**Customer-style release notes** (below the running order):

```
## What's new in Sprint N

- **[Feature]**: [Plain-language benefit] (credit: [engineer])
- **Fix**: [Bug description] resolved — [impact]
```

## Output defaults

- Format: paste-ready Markdown for email / Slack / Teams
- `standup`: also emit a per-engineer copy block
- If evidence is thin: state it plainly rather than padding — honesty makes strong weeks credible

## Suggested cadence

| Mode | Frequency |
|------|-----------|
| `standup` | Each morning before DSM |
| `digest` | Every Friday, sent to client |
| `pr` | On every non-trivial PR/MR |
| `demo` | End of each sprint |

`digest` is a good candidate for a scheduled task once the format is stable.
