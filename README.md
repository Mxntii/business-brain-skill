# Business Brain — Claude Code Skill

A Claude Code skill that builds a complete business operations workspace in ~3 minutes. It interviews you about your business, then generates an Obsidian-compatible knowledge vault with AI context, session management, a daily planner, and templates — all tailored to your setup.

## What You Get

- **CLAUDE.md** — Your business context file (Claude reads this every session)
- **PROGRESS.md** — Status dashboard across all business areas
- **Numbered folder structure** — Organised by your business functions (Finance, Sales, Operations, etc.)
- **3 skills** — `/resume` (session continuity), `/wrap-up` (session logging), `/morning` (daily planner)
- **Memory system** — Persistent context that carries across conversations
- **Templates** — Session logs, meeting notes, procedures, project briefs
- **Obsidian config** — Ready to open as a vault with recommended plugins

## Install

Copy the skill file into your Claude Code commands directory:

```bash
# Create the commands directory if it doesn't exist
mkdir -p .claude/commands

# Download the skill
curl -o .claude/commands/setup-business-brain.md \
  https://raw.githubusercontent.com/Mxntii/business-brain-skill/main/setup-business-brain.md
```

## Usage

Open Claude Code in the directory where you want your workspace, then run:

```
/setup-business-brain
```

It asks 5 questions:

1. **Business identity** — Name, industry, location, your role, team size
2. **Business structure** — Pick departments or list your own (industry-adaptive suggestions)
3. **Systems & tools** — Email, calendar, CRM, accounting, tasks (configures integrations)
4. **Sensitivity** — How to handle confidential data (solo / two-tier / four-tier)
5. **Daily workflow** — What you check each morning (configures your daily planner)

Every question has a skip default. Answer "A, A, A, A, 1 2" and you get a clean setup in under 60 seconds.

## What Gets Generated

```
Your Business/
├── .claude/commands/
│   ├── resume.md          → Pick up where you left off (reads last 3 sessions + memory)
│   ├── wrap-up.md         → Log what you did, update dashboard
│   └── morning.md         → Daily briefing tailored to your tools + workflow
├── .obsidian/             → Vault config (open in Obsidian immediately)
├── 00-Home/dashboard.md   → Master hub linking all sections
├── 01-Finance/            → With _index.md + dashboard.md
├── 02-[Your Sections]/    → 4-8 sections based on your answers
├── Sessions/              → Session logs for continuity
├── Templates/             → Note templates with frontmatter standards
├── CLAUDE.md              → Business context (under 200 lines)
├── PROGRESS.md            → Status dashboard
└── Memory files           → User profile, project overview, systems reference
```

## Recommended Obsidian Plugins

The skill suggests these after setup:

**Day 1:**
- [Dataview](https://github.com/blacksmithgu/obsidian-dataview) — Powers dashboard queries
- [Calendar](https://github.com/liamcain/obsidian-calendar-plugin) — Visual session log navigation
- [Folder Note](https://github.com/LostPaul/obsidian-folder-notes) — Click folders to see their index

**Week 1:**
- [Obsidian Git](https://github.com/denolehov/obsidian-git) — Free version history + backup
- [Kanban](https://github.com/mgmeyers/obsidian-kanban) — Visual project boards
- [Quick Switcher++](https://github.com/darlal/obsidian-switcher-plus) — Find any note instantly

## Design Principles

- **CLAUDE.md under 200 lines** — longer gets ignored
- **Max 3 folder levels** — deeper structures get abandoned
- **4 starter skills only** — `/resume`, `/wrap-up`, `/morning`, `/setup-business-brain`
- **Max 5 frontmatter fields** — over-structured templates don't get used
- **Manual memory curation** — beats automated noise every time
- **Skip-friendly** — every question has sensible defaults

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- [Obsidian](https://obsidian.md/) (free) — optional but recommended
- MCP tool connections (Gmail, Calendar, etc.) — optional, enhances `/morning` skill

## License

MIT — use it, adapt it, share it.
