Build a complete business operations workspace (Business Brain) by interviewing the user and generating all files. This skill is designed for business owners/managers who use Claude Code but are not developers.

---

## Pre-flight Check

Check if CLAUDE.md already exists in the current directory. If it does:

```
This directory already has a Brain setup. Want to:
  A) Rebuild from scratch (existing files will be backed up to _backup_[timestamp]/)
  B) Update your config (re-run the interview, merge changes)
  C) Cancel

Pick A, B, or C:
```

If A: back up all existing files to `_backup_YYYY-MM-DD/` before proceeding.
If B: re-run relevant questions and merge answers into existing files without overwriting content.
If C: stop.

If no CLAUDE.md exists, proceed with the interview.

---

## Opening Message

```
Welcome to Business Brain setup. I'm going to ask you 5 questions, then
build your entire workspace — an Obsidian-compatible knowledge vault with
AI context, session management, a daily planner, and templates tailored
to your business.

This takes about 3 minutes. You can skip any question by pressing Enter
and I'll use sensible defaults.

Let's go.
```

---

## Question 1: Business Identity

Ask:

```
Q1 — Tell me about your business.

Give me one or two sentences: business name, what you do, where you're
based, and your role. For example:

  "Coastal Plumbing, residential and commercial plumbing in Brisbane.
   I'm the owner, 12 staff."

  "Sarah Chen Consulting, solo fractional CFO based in Sydney."

  "Apex Fabrication, custom metalwork in Melbourne. I'm the ops manager,
   about 40 people."

Your turn:
```

**Extract from their answer:**
- `business_name` — first proper noun / named entity
- `industry` — classify into: trades, professional-services, retail, manufacturing, hospitality, creative, tech, other
- `location` — city/state/country
- `user_role` — owner, manager, director, or specific title
- `team_size` — solo (1), small (2-5), medium (5-20), large (20+)
- `fy_start` — infer from country (Australia = July, US/UK = January, NZ = April — confirm if unsure)

**Default if skipped:** "My Business", general industry, Australia, Owner, small team, July FY

Wait for their answer before proceeding to Q2.

---

## Question 2: Business Structure

Adapt based on the industry detected in Q1. Show the matching Option B from this table:

| Detected Industry | Option B Label | Sections |
|---|---|---|
| Trades | Trades | Finance / Sales / Jobs / Procurement / Workshop / Admin |
| Manufacturing | Manufacturing | Finance / Sales & Marketing / Operations / Production / Procurement / Admin & HR |
| Professional Services | Professional Services | Finance / Clients / Projects / Marketing / Operations / Knowledge Base |
| Retail | Retail | Finance / Sales & Marketing / Inventory / Suppliers / Operations / Staff |
| Hospitality | Hospitality | Finance / Front of House / Kitchen-Menu / Suppliers / Staff / Marketing |
| Creative / Agency | Creative | Finance / Clients / Projects / Creative Assets / Marketing / Admin |
| Tech / SaaS | Tech | Finance / Product / Engineering / Sales / Marketing / Operations |
| Other / General | Standard | Finance / Sales & Marketing / Operations / Admin & HR / Projects |

Ask:

```
Q2 — What areas of your business do you need to organise?

Based on what you've told me, here's a starting structure. Pick one, or
tell me what to change:

  A) Standard (works for most businesses)
     Finance / Sales & Marketing / Operations / Admin & HR / Projects

  B) [Industry-specific label]
     [Industry-specific sections from table above]

  C) Let me tell you what I need
     (Just list your departments or functions, e.g. "Sales, Projects, Accounts, Workshop")

Pick A, B, C, or just type your own list:
```

**Store the chosen sections as a list.** These become the numbered folders.

**Default if skipped:** Option A

Wait for their answer before proceeding to Q3.

---

## Question 3: Systems & Tools

Ask:

```
Q3 — What software does your business run on?

Pick the closest match for each — type the letters, or skip any you don't use:

  Email:       G) Gmail/Google Workspace   O) Outlook/Microsoft 365   X) Other/skip
  Calendar:    G) Google Calendar           O) Outlook Calendar         X) Other/skip
  CRM:         Z) Zoho    H) HubSpot    S) Salesforce    N) None/spreadsheet
  Accounting:  X) Xero    M) MYOB       Q) QuickBooks    N) None/spreadsheet
  Tasks:       G) Google Tasks   T) Todoist   A) Asana   N) None/pen & paper

Example: "G, G, N, X, G" or "Gmail, Google Cal, no CRM, Xero, pen and paper"

Your tools:
```

**Parse into:** email (gmail|outlook|other), calendar (google|outlook|other), crm (zoho|hubspot|salesforce|none), accounting (xero|myob|quickbooks|none), tasks (google-tasks|todoist|asana|none)

**Default if skipped:** All `none`

Wait for their answer before proceeding to Q4.

---

## Question 4: Sensitivity & Access

Ask:

```
Q4 — How careful do we need to be with your data?

  A) Solo / trusted team — everything in one vault, no restrictions needed
  B) Some sensitive data — keep financials and pricing locked down, everything else open
  C) Multi-level access — different people see different things (e.g. staff vs managers)

Most small businesses pick B. Pick A, B, or C:
```

**If they pick C, ask follow-up:**

```
Quick follow-up — what access levels do you need? For example:
  "Owner, Manager, Staff" or "Directors, Team Leads, Everyone"

Your levels (or press Enter for Owner / Manager / Staff):
```

**Store as:** sensitivity_mode (none|two-tier|four-tier) and access_levels list

**Default if skipped:** B (two-tier)

Wait for their answer before proceeding to Q5.

---

## Question 5: Daily Workflow

Ask:

```
Q5 — What does a typical morning look like when you sit down to work?

Pick everything that applies:

  1) Check and triage email
  2) Review today's calendar / appointments
  3) Check on team tasks or delegate work
  4) Review sales pipeline or leads
  5) Check financials (cash flow, invoices, payments)
  6) Review project status / job progress

Type the numbers that match, e.g. "1, 2, 4" or "all of them":
```

**Store selections.** Filter out impossible combinations:
- Selection 3 (team tasks): skip if team_size is solo — add self-management block instead
- Selection 4 (sales pipeline): only if crm != none — otherwise generate manual checklist
- Selection 5 (financials): only if accounting != none — otherwise generate manual checklist

**Default if skipped:** 1 and 2 (email + calendar)

---

## Confirmation

After all 5 questions, display:

```
Here's what I'll build for you:

[Business Name] Vault
├── .claude/commands/          → /resume, /wrap-up, /morning skills
├── .obsidian/                 → Vault config (ready to open in Obsidian)
├── Sessions/                  → Session logs (auto-managed)
├── Templates/                 → [N] templates for your common note types
├── CLAUDE.md                  → Your business context (Claude reads this every session)
├── PROGRESS.md                → Status dashboard across all areas
│
├── 01-[Section 1]/            → [description]
├── 02-[Section 2]/            → [description]
├── [... rest of structure ...]
│
└── Memory files pre-loaded

Skills configured:
  /resume     → Pick up where you left off (reads last 3 sessions + all memory)
  /wrap-up    → Log what you did this session
  /morning    → Daily briefing: [list of selected sections from Q5]

Systems referenced: [list from Q3]
Data sensitivity: [tier description from Q4]

Does this look right? (Y to build, or tell me what to change)
```

If they request changes, re-ask only the relevant question and re-display confirmation.

If they confirm, proceed to generation.

---

## Generation

Execute in this exact order. Create ALL files — do not skip any step.

### Step 1: Folder Structure

Create the numbered section folders based on Q2. For each section, create:
- `[NN]-[Section-Name]/_index.md` — with frontmatter: title, sensitivity (default from Q4), access
- `[NN]-[Section-Name]/dashboard.md` — Dataview-style dashboard referencing content in that section

Also create:
- `00-Home/dashboard.md` — master hub linking all sections
- `Sessions/` — empty directory for session logs
- `Templates/` — directory for templates
- `.claude/commands/` — directory for skills

### Step 2: CLAUDE.md

Write CLAUDE.md at the vault root. **MUST be under 200 lines.** Use this structure:

```markdown
# [Business Name] — Operating Manual

Claude reads this file at the start of every session.

## Company Context

**[Business Name]** — [industry description], [location]
- Role: [user_role]
- Team: [team_size description]
- Systems: [list from Q3]
- FY: [fy_start] to [fy_end]

## Workspace Structure

    [vault root]/
    ├── .claude/commands/     → /resume, /wrap-up, /morning
    ├── Sessions/             → Session logs
    ├── Templates/            → Note templates
    ├── CLAUDE.md             → This file
    ├── PROGRESS.md           → Status dashboard
    ├── 00-Home/              → Master dashboard
    ├── 01-[Section]/         → [description]
    ├── 02-[Section]/         → [description]
    [... all sections ...]

## Session Workflow

1. Start every session with `/resume` to load context
2. End every session with `/wrap-up` to log what was done
3. Update PROGRESS.md when completing or starting major work

## Cross-Project Rules

1. Read project-specific CLAUDE.md before doing work in a sub-project
2. Never delete production data without asking — disable instead
3. Keep PROGRESS.md current — update when completing or starting work
4. Session logs go in Sessions/
5. Every function/automation change: save old version dated before deploying new version

## Sensitivity Classification

[Generate based on Q4 choice:]

[If A — None:]
No formal tiers. Use `private: true` in frontmatter for anything Claude should not store in memory.

[If B — Two-tier:]
| Tier | Label | Content | Rule |
|------|-------|---------|------|
| PRIVATE | Restricted | Financials, pricing, margins, supplier costs | Claude stores structural refs only, never values |
| OPEN | General | Everything else | Normal access |

[If C — Four-tier:]
| Tier | Label | Content | Rule |
|------|-------|---------|------|
| RED | Encrypted | [user-defined top-tier content] | Claude stores structural refs only, never values |
| AMBER | Restricted | [user-defined second-tier content] | Limited access |
| BLUE | Role-specific | [user-defined third-tier content] | Role-based access |
| GREEN | Company-wide | Policies, training, general docs | All access |

## Content Rules

- Every content note needs frontmatter: `title`, `date`, `source`, `sensitivity`
- Notes with `private: true`: Claude stores structural refs only, never values
- Use Templates/ for consistent note creation
```

### Step 3: PROGRESS.md

```markdown
---
type: dashboard
last_updated: [today's date]
---

# [Business Name] — Status Dashboard

## Active Projects

[For each section from Q2, create a block:]

### [Section Name]
**Status:** Not started
**Location:** `[NN]-[Section-Name]/`

[... repeat for each section ...]

---

## Session Log
| Date | Project | Summary |
|------|---------|---------|
```

### Step 4: /resume Skill

Write `.claude/commands/resume.md`:

```markdown
Read the following files to understand where we left off:

## Core Context (always read)

1. CLAUDE.md — master project context
2. PROGRESS.md — cross-project status dashboard
3. The **3 most recent files** in Sessions/ (sort by date in filename)
4. Claude memory — read all project and reference memory files listed in MEMORY.md

## Project-Specific Context

Check the last 3 session logs to determine which projects are active, then read any project-specific CLAUDE.md files in those areas.

## Staleness Check

- If the most recent session log is more than 2 calendar days old, flag: **"Session log may be stale (last: [date])."**
- If PROGRESS.md `last_updated` is more than 5 days old, flag: **"PROGRESS.md hasn't been updated since [date]."**

## Briefing Output

Give a concise briefing covering:

1. **Last 3 sessions summary** — one line each, reverse chronological
2. **Current priority** — what's most urgent across all projects?
3. **Open blockers** — anything blocking progress?
4. **Pending tasks** — key unchecked items from PROGRESS.md
5. **Standing decisions** — any feedback memories relevant to likely work today

End with: **"What do you want to focus on today?"**
```

### Step 5: /wrap-up Skill

Write `.claude/commands/wrap-up.md`:

```markdown
End-of-session wrap-up. Do the following:

1. Create a session log file in Sessions/ named `[today's date]-[brief-topic].md` using the session-log template from Templates/

2. Fill in all sections:
   - **Context:** What was the goal of this session?
   - **Work Done:** Bullet list of everything completed
   - **Changes Applied:** Files created, edited, or deleted
   - **Decisions Made:** Any choices or trade-offs decided
   - **Key Facts Learned:** New information discovered
   - **Pending / Next Steps:** What still needs doing
   - **Handoff Notes:** What the next session needs to know

3. Update PROGRESS.md:
   - Check off any completed items
   - Add any new pending items discovered
   - Update `last_updated` date in frontmatter
   - Add a row to the Session Log table

4. Show a brief summary of what was logged and any open items for next time.
```

### Step 6: /morning Skill

Write `.claude/commands/morning.md` — configured based on Q3 (systems) and Q5 (workflow selections):

```markdown
Daily planner for [user_name] — [user_role] at [business_name].

This command generates a prioritised daily briefing.

---

## Pre-flight Check

Check what day it is. If today is Saturday or Sunday, output:
> "No work day scheduled. Run `/resume` if you want project context."
Then stop.

---

## Phase 1 — Local Data (mandatory)

Read these files:
1. CLAUDE.md — business context
2. PROGRESS.md — project status
3. The most recent file in Sessions/ (flag if >2 days old)
4. Claude memory — read relevant project/reference memories

Compile: open tasks, blockers, what was done last session.

---

## Phase 2 — Live Data (MCP + fallback)

**Call available sources in parallel.** If an MCP tool is not connected, skip that source and note it in Data Gaps.

[ONLY INCLUDE SECTIONS THE USER SELECTED IN Q5:]

[If Q5 includes 1 (Email):]
### Email
[If Q3 email = gmail:]
Use `mcp__claude_ai_Gmail__gmail_search_messages` with `q: "in:inbox newer_than:2d"`, maxResults 50.
[If Q3 email = outlook:]
Use Outlook MCP if available, otherwise note "Connect Outlook MCP for email integration".
[If Q3 email = other:]
Note: "Email source not configured — check manually."

Extract: sender, subject, snippet for classification.

[If Q5 includes 2 (Calendar):]
### Calendar
[If Q3 calendar = google:]
Use `mcp__claude_ai_Google_Calendar__gcal_list_events` with timeMin/timeMax for today, timeZone based on location, condenseEventDetails false.
Only include events where the user has accepted or is organiser. Exclude working location events.
[If Q3 calendar = outlook:]
Use Outlook Calendar MCP if available.
[If Q3 calendar = other:]
Note: "Calendar source not configured — check manually."

Extract: meetings with times, titles, attendees.

[If Q5 includes 3 (Team tasks) AND team_size > solo:]
### Team Tasks
[If Q3 tasks = google-tasks:]
Use `mcp__claude_ai_Zapier__google_tasks_get_tasks_by_list` for incomplete tasks.
[If Q3 tasks = todoist/asana:]
Note: "Connect [tool] MCP for task integration".
[If Q3 tasks = none:]
Provide a blank "Team check-in" section for manual notes.

[If Q5 includes 4 (Sales pipeline) AND Q3 crm != none:]
### Sales Pipeline
[If Q3 crm = zoho:]
Use Zoho CRM MCP or browser fallback to check leads/pipeline.
[If Q3 crm = hubspot/salesforce:]
Note: "Connect [CRM] MCP for pipeline integration".

[If Q5 includes 5 (Financials) AND Q3 accounting != none:]
### Financials
Note: "Check [accounting tool] for: outstanding invoices, bills due, account balances."
(Accounting MCP integrations vary — provide manual checklist until connected.)

[If Q5 includes 6 (Projects):]
### Project Status
Pull from PROGRESS.md — one-liner per active project.

---

## Phase 3 — Output

Generate a scannable markdown briefing:

```
## Daily Briefing — [Day, Date]
[Work hours | Meetings: X | Open tasks: X]

### Today's Schedule
| Time | Block | Detail |
[Calendar events + open blocks labelled "Deep Work" or "Admin"]

[Include only sections matching Q5 selections:]

### [Email section if selected]
### [Sales section if selected]
### [Financials section if selected]
### [Team section if selected]
### [Project status if selected]

### Data Gaps
[List any source that failed or isn't connected. Skip if all succeeded.]
```

End with: **"What do you want to focus on first?"**
```

### Step 7: Templates

**Always create:**

`Templates/session-log.md`:
```markdown
---
type: session
project: "{{project}}"
date: {{date}}
tags:
  - session
---

# Session: {{date}} — {{topic}}

## Context
[What was the goal?]

## Work Done
-

## Changes Applied
-

## Decisions Made
-

## Key Facts Learned
-

## Pending / Next Steps
- [ ]

## Handoff Notes
[What does the next session need to know?]
```

`Templates/meeting-notes.md`:
```markdown
---
title: "{{title}}"
date: {{date}}
attendees: []
source: "meeting"
sensitivity: open
---

# {{title}}

## Attendees
-

## Agenda
1.

## Discussion Notes


## Action Items
- [ ]

## Decisions Made
-
```

**Conditionally create based on Q2 sections:**

If Operations/Jobs/Workshop section exists, create `Templates/procedure.md`:
```markdown
---
title: "{{title}}"
date: {{date}}
source: "{{source}}"
sensitivity: open
---

# {{title}}

## Purpose
[What is this procedure for?]

## Steps
1.

## Notes
-
```

If Clients/Projects section exists, create `Templates/project-brief.md`:
```markdown
---
title: "{{title}}"
date: {{date}}
source: "{{source}}"
sensitivity: open
---

# {{title}}

## Objective
[What are we trying to achieve?]

## Scope
[What's included / excluded?]

## Timeline
- Start:
- End:

## Key Contacts
-

## Status
Not started
```

### Step 8: Memory System

Create the memory directory at the Claude project-specific memory path for the current working directory. Then create:

**MEMORY.md:**
```markdown
# [Business Name] Memory Index

## User
- [user_profile.md](user_profile.md) — [user_name]'s role and working style

## Project Context
- [project_overview.md](project_overview.md) — [Business Name] context and active workstreams

## References
- [reference_systems.md](reference_systems.md) — Tools and platforms in use
[If team_size > solo:]
- [reference_team_map.md](reference_team_map.md) — Team roster and roles
```

**user_profile.md:**
```markdown
---
name: [user_name] profile
description: [user_name]'s role, responsibilities, and working style at [business_name]
type: user
---

[user_name] is the [user_role] at [business_name] ([industry], [location]).
Team size: [team_size].

Working style and preferences will be captured as sessions progress.
```

**project_overview.md:**
```markdown
---
name: [Business Name] overview
description: [Business Name] business context, systems, and current state
type: project
---

**[Business Name]** — [industry], [location]
- [user_role]: [user_name]
- Team: [team_size]
- Systems: [list from Q3]
- FY: [fy_start] to [fy_end]

Active workstreams and projects will be tracked in PROGRESS.md and updated here as context develops.
```

**reference_systems.md:**
```markdown
---
name: Systems and tools
description: Software platforms used at [business_name] — for configuring integrations and MCP tools
type: reference
---

| System | Tool | Status |
|--------|------|--------|
| Email | [Q3 email choice] | [Connected/Not connected] |
| Calendar | [Q3 calendar choice] | [Connected/Not connected] |
| CRM | [Q3 crm choice or "None"] | [Connected/Not connected] |
| Accounting | [Q3 accounting choice or "None"] | [Connected/Not connected] |
| Tasks | [Q3 tasks choice or "None"] | [Connected/Not connected] |

To connect a tool as an MCP integration, tell Claude: "set up [tool] integration"
```

**reference_team_map.md** (only if team_size > solo):
```markdown
---
name: Team roster
description: [Business Name] team members, roles, and contact details
type: reference
---

# Team Map

| Name | Role | Email | Notes |
|------|------|-------|-------|
| [user_name] | [user_role] | | |

Add team members as you work with Claude. This file helps Claude understand who does what and how to classify communications.
```

### Step 9: Obsidian Config

Create `.obsidian/app.json`:
```json
{
  "defaultViewMode": "preview",
  "showLineNumber": false,
  "strictLineBreaks": false,
  "readableLineLength": true
}
```

Create `.obsidian/appearance.json`:
```json
{
  "theme": "system"
}
```

Create `.obsidian/community-plugins.json`:
```json
["dataview", "folder-note-core"]
```

---

## Completion Message

After all files are generated, output:

```
Your Business Brain is ready.

What I built:
  - [X] folders organised by business area
  - [X] templates for notes, meetings, and sessions
  - CLAUDE.md with your full business context
  - /resume, /wrap-up, and /morning skills
  - PROGRESS.md dashboard
  - Memory system pre-loaded with your profile

Recommended Obsidian plugins (install from Settings > Community Plugins):
  Day 1:
  - Dataview (powers your dashboards — query notes like a database)
  - Calendar (visual sidebar for navigating session logs by date)
  - Folder Note (click a folder to see its index page)

  Week 1:
  - Obsidian Git (auto-commit changes — free version history + backup)
  - Kanban (visual project boards for task tracking)
  - Quick Switcher++ (find any note instantly)

  Later:
  - Meld Encrypt (encrypt sensitive notes at rest)
  - Tasks (track tasks with due dates across the vault)
  - Homepage (set 00-Home/dashboard.md as your landing page)

Next steps:
  1. Open this folder in Obsidian (File > Open Vault > select this folder)
  2. Install the recommended plugins above
  3. Run /morning tomorrow to try your daily briefing
  4. Start any session with /resume — Claude will know where you left off
  5. End sessions with /wrap-up to keep your log current

You're good to go. What would you like to work on first?
```
