<!-- AUTO-GENERATED FILE. Edit src/*.md and run scripts/build-command.sh. -->

Build or safely update a complete Business Brain workspace for a business owner or operator. This command must work for non-developers: ask short questions, normalize the answers into a concrete config, show a clear confirmation, then generate the workspace in one pass.

Keep `/setup-business-brain` as the command name. The workspace must be Obsidian-compatible and Claude-friendly.

Core outcomes:
- Generate a ready-to-use vault with numbered business sections, templates, dashboards, `CLAUDE.md`, `PROGRESS.md`, local memory files, and `/resume`, `/wrap-up`, `/morning`.
- Write a root config file named `.business-brain.json` so future update runs are deterministic.
- Use a single canonical frontmatter model everywhere:
  - Required: `title`, `date`, `source`, `sensitivity`
  - Optional: `access`, `private`
- Use a single canonical sensitivity enum everywhere: `RED`, `AMBER`, `BLUE`, `GREEN`
- Generate role-vault tooling only when it is enabled by the config.

Important operating rules:
- Be concise, direct, and practical.
- Do not ask more than the defined interview questions unless a follow-up is explicitly required below.
- Normalize answers after each question into a working config object in memory.
- When generating files, prefer deterministic content over open-ended prose.
- Never overwrite user-authored business content during update mode.

---

## Pre-flight

Before asking any setup questions:

1. Check for `.business-brain.json` in the current directory.
2. If it does not exist, check for `CLAUDE.md`.
3. Choose the mode:
   - **New setup:** no config and no `CLAUDE.md`
   - **Managed update:** `.business-brain.json` exists
   - **Legacy upgrade:** `CLAUDE.md` exists but `.business-brain.json` does not

### If `.business-brain.json` exists

Read it and show:

```text
This directory already has a Business Brain config.

Current setup:
- Business: [business_name]
- Sections: [comma-separated section names]
- Systems: [email/calendar/crm/accounting/tasks summary]
- Sensitivity: [mode]
- Role-vault tooling: [enabled/disabled]

Choose what to do:
  A) Update config safely
  B) Rebuild scaffold from scratch
  C) Cancel

Pick A, B, or C:
```

If the user picks `A`:
- Enter **update mode**
- Ask which parts to update:

```text
What do you want to update?
  1) Business identity
  2) Sections
  3) Systems
  4) Sensitivity / access
  5) Daily workflow
  6) Role-vault tooling

Type the numbers to update, e.g. "2, 4, 6":
```

- Re-ask only the relevant questions later.
- Rewrite only tracked scaffold files listed in `.business-brain.json.generated_files`.
- Never overwrite user-authored notes inside numbered section folders, `Sessions/`, or filled-in template-based notes.
- If a section is removed during update, do not delete its folder. Add it to `.business-brain.json.legacy_sections` and stop linking to it from newly generated dashboards.

If the user picks `B`:
- Enter **rebuild mode**
- Back up only tracked scaffold files from `.business-brain.json.generated_files` into `_backup_YYYY-MM-DD-HHMMSS/`
- Back up tracked generated directories only if they contain scaffold files created by this command.
- Do not move or delete user-authored notes inside numbered section folders unless the user explicitly asks for a full teardown.
- Then run the full interview again and regenerate the scaffold.

If the user picks `C`, stop.

### If `CLAUDE.md` exists but `.business-brain.json` does not

Treat this as a legacy setup and show:

```text
I found an existing `CLAUDE.md` but no `.business-brain.json`.

Choose what to do:
  A) Adopt this vault into the new managed Business Brain format
  B) Rebuild scaffold from scratch
  C) Cancel

Pick A, B, or C:
```

If the user picks `A`:
- Create a new normalized `.business-brain.json` from the interview answers and current folder structure.
- Preserve existing files unless they are regenerated scaffold files.

If the user picks `B`, run rebuild mode.
If `C`, stop.

### Normalized config object

Maintain this working config internally throughout the interview and write it to `.business-brain.json` during generation:

```json
{
  "version": "2.0.0",
  "business_name": "",
  "operator_name": "",
  "industry": "",
  "location": "",
  "user_role": "",
  "team_size": "small",
  "fy_start_month": "July",
  "sections": [],
  "systems": {
    "email": "none",
    "calendar": "none",
    "crm": "none",
    "accounting": "none",
    "tasks": "none"
  },
  "sensitivity": {
    "mode": "two-tier",
    "access_levels": ["owner", "manager", "staff"],
    "default_general": "GREEN",
    "default_restricted": "AMBER"
  },
  "daily_workflow": [],
  "feature_flags": {
    "role_vaults_enabled": false
  },
  "legacy_sections": [],
  "generated_files": [],
  "generated_directories": [],
  "generated_at": ""
}
```

---

## Interview

Ask the full 5-question interview for new setups and rebuilds. In update mode, ask only the relevant questions selected in pre-flight.

### Question 1: Business Identity

Ask:

```text
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

Normalize into:
- `business_name`
- `operator_name` if clearly present, otherwise leave blank
- `industry`: `trades`, `professional-services`, `retail`, `manufacturing`, `hospitality`, `creative`, `tech`, `other`
- `location`
- `user_role`
- `team_size`: `solo`, `small`, `medium`, `large`
- `fy_start_month`: infer from country where reasonable
  - Australia = `July`
  - New Zealand = `April`
  - US / UK / Canada / unspecified = `January`

Default if skipped:
- business_name: `My Business`
- operator_name: ``
- industry: `other`
- location: `Australia`
- user_role: `Owner`
- team_size: `small`
- fy_start_month: `July`

### Question 2: Business Structure

Use the detected industry to show the matching Option B.

| Industry | Label | Sections |
|---|---|---|
| trades | Trades | Finance / Sales / Jobs / Procurement / Workshop / Admin |
| manufacturing | Manufacturing | Finance / Sales & Marketing / Operations / Production / Procurement / Admin & HR |
| professional-services | Professional Services | Finance / Clients / Projects / Marketing / Operations / Knowledge Base |
| retail | Retail | Finance / Sales & Marketing / Inventory / Suppliers / Operations / Staff |
| hospitality | Hospitality | Finance / Front of House / Kitchen & Menu / Suppliers / Staff / Marketing |
| creative | Creative | Finance / Clients / Projects / Creative Assets / Marketing / Admin |
| tech | Tech | Finance / Product / Engineering / Sales / Marketing / Operations |
| other | Standard | Finance / Sales & Marketing / Operations / Admin & HR / Projects |

Ask:

```text
Q2 — What areas of your business do you need to organise?

Based on what you've told me, here's a starting structure. Pick one, or
tell me what to change:

  A) Standard
     Finance / Sales & Marketing / Operations / Admin & HR / Projects

  B) [industry-specific label]
     [industry-specific sections]

  C) Let me tell you what I need
     (List your departments or functions, e.g. "Sales, Projects, Accounts, Workshop")

Pick A, B, C, or type your own list:
```

Normalize into `sections` as an ordered array of objects:

```json
[
  {
    "number": "01",
    "name": "Finance",
    "folder": "01-Finance",
    "description": "Budgets, cash flow, invoices, financial controls",
    "default_sensitivity": "AMBER"
  }
]
```

Rules:
- Preserve the user’s chosen order.
- Use two-digit numbering: `01`, `02`, `03`, ...
- Slug folders as `[NN]-[Section-Name]`
- Default descriptions:
  - Finance: `Budgets, cash flow, invoices, financial controls`
  - Sales & Marketing / Sales: `Pipeline, campaigns, offers, analytics`
  - Operations / Jobs / Workshop / Production: `Procedures, delivery, execution, QA`
  - Admin & HR / Staff / Admin: `People, admin, hiring, compliance`
  - Projects / Clients / Product / Engineering / Knowledge Base / Inventory / Suppliers / Procurement / Front of House / Kitchen & Menu / Creative Assets: short plain-English description based on the section name
- If the user enters custom sections, generate sensible plain-English descriptions

Default if skipped:
- Use Option A

### Question 3: Systems & Tools

Ask:

```text
Q3 — What software does your business run on?

Pick the closest match for each:

  Email:       G) Gmail / Google Workspace   O) Outlook / Microsoft 365   X) Other / skip
  Calendar:    G) Google Calendar            O) Outlook Calendar          X) Other / skip
  CRM:         Z) Zoho    H) HubSpot    S) Salesforce    N) None / spreadsheet
  Accounting:  X) Xero    M) MYOB       Q) QuickBooks    N) None / spreadsheet
  Tasks:       G) Google Tasks   T) Todoist   A) Asana   N) None / pen & paper

Example: "G, G, N, X, G"

Your tools:
```

Normalize into:

```json
{
  "email": "gmail",
  "calendar": "google",
  "crm": "zoho",
  "accounting": "xero",
  "tasks": "google-tasks"
}
```

Defaults if skipped:
- all values = `none` except `email` and `calendar` can be `other` only if explicitly stated

Important truthfulness rule:
- Do not claim any MCP tool is connected during setup.
- In generated files, represent these as `Configured` or `Manual`, not `Connected`.

### Question 4: Sensitivity & Access

Ask:

```text
Q4 — How careful do we need to be with your data?

  A) Simple — one main vault, no staff filtering
  B) Some sensitive data — keep finance, pricing, and confidential docs restricted
  C) Multi-level access — different people should see different content

Most small businesses pick B. Pick A, B, or C:
```

Normalize as:
- `A` => mode `none`
- `B` => mode `two-tier`
- `C` => mode `four-tier`

Canonical sensitivity mapping:
- mode `none`
  - default general = `GREEN`
  - restricted notes can still use `private: true`
- mode `two-tier`
  - general = `GREEN`
  - restricted = `AMBER`
- mode `four-tier`
  - full enum available: `RED`, `AMBER`, `BLUE`, `GREEN`

If the user picks `C`, ask the required follow-up:

```text
Quick follow-up — what access levels do you need?
Examples: "Owner, Manager, Staff" or "Directors, Team Leads, Everyone"

Your levels (press Enter for Owner / Manager / Staff):
```

Normalize `access_levels`:
- lowercase
- hyphenated where needed
- keep order from highest to lowest access
- default: `owner`, `manager`, `staff`

Feature-flag rule:
- If mode = `four-tier`, set `feature_flags.role_vaults_enabled = true`
- If mode is not `four-tier`, default `feature_flags.role_vaults_enabled = false`

### Question 5: Daily Workflow

Ask:

```text
Q5 — What does a typical morning look like when you sit down to work?

Pick everything that applies:

  1) Check and triage email
  2) Review today's calendar / appointments
  3) Check on team tasks or delegate work
  4) Review sales pipeline or leads
  5) Check financials
  6) Review project status / job progress

Type the numbers that match, e.g. "1, 2, 4":
```

Normalize into `daily_workflow` using these values:
- `email`
- `calendar`
- `team-tasks`
- `sales-pipeline`
- `financials`
- `projects`

Rules:
- If team size is `solo`, convert `team-tasks` to `self-review`
- If CRM = `none`, keep `sales-pipeline` but generated `/morning` must use a manual checklist
- If accounting = `none`, keep `financials` but generated `/morning` must use a manual checklist

Default if skipped:
- `email`, `calendar`

---

## Confirmation

After the interview, always display a concrete build summary before generating files.

If role-vault tooling is currently disabled and the setup is not four-tier, ask one final optional question before the summary:

```text
Optional — do you also want staff-specific role vaults and a build script?

  A) No, keep one main vault only
  B) Yes, include optional role-vault tooling

Pick A or B:
```

If `B`, set `feature_flags.role_vaults_enabled = true`.

Then show:

```text
Here's what I'll build:

[Business Name]
├── .business-brain.json        → Managed config for future updates
├── .claude/commands/           → /resume, /wrap-up, /morning
├── .obsidian/                  → Minimal Obsidian config
├── 00-Home/                    → Master dashboard
├── [numbered section folders]  → Business areas based on your answers
├── Sessions/                   → Session logs
├── Templates/                  → Note templates
├── Memory/                     → Local memory reference files
├── CLAUDE.md                   → Business context for future sessions
└── PROGRESS.md                 → Cross-business dashboard

Sections:
[list every section as folder → description]

Systems:
- Email: [configured/manual value]
- Calendar: [configured/manual value]
- CRM: [configured/manual value]
- Accounting: [configured/manual value]
- Tasks: [configured/manual value]

Sensitivity:
- Mode: [none/two-tier/four-tier]
- Access levels: [comma-separated access levels]
- Role-vault tooling: [enabled/disabled]

Modules to generate:
- Core scaffold
- Templates
- Daily workflow command
- Local memory files
[If role_vaults_enabled:]
- Role-vault config, build script, and docs

Does this look right? (Y to build, or tell me what to change)
```

If the user requests changes:
- Re-ask only the relevant question(s)
- Rebuild the normalized config
- Re-display the confirmation summary

Only generate files after explicit confirmation.

---

## Generation

Generate files in this exact order.

### Step 1: Finalize tracked paths

Before writing files, build `generated_directories` and `generated_files`.

Always include these generated directories:
- `.claude/commands`
- `.obsidian`
- `00-Home`
- `Sessions`
- `Templates`
- `Memory`
- every section folder in `sections`

Always include these generated files:
- `.business-brain.json`
- `CLAUDE.md`
- `PROGRESS.md`
- `00-Home/dashboard.md`
- `.claude/commands/resume.md`
- `.claude/commands/wrap-up.md`
- `.claude/commands/morning.md`
- `.obsidian/app.json`
- `.obsidian/appearance.json`
- `.obsidian/community-plugins.json`
- `Templates/session-log.md`
- `Templates/meeting-notes.md`
- `Templates/general-note.md`
- `Memory/MEMORY.md`
- `Memory/user_profile.md`
- `Memory/project_overview.md`
- `Memory/reference_systems.md`
- `Memory/reference_team_map.md` when team size is not solo
- for every section:
  - `[folder]/_index.md`
  - `[folder]/dashboard.md`

Conditionally include:
- `Templates/procedure.md` when any section name contains `operations`, `jobs`, `workshop`, `production`, `procurement`, or `inventory`
- `Templates/project-brief.md` when any section name contains `projects`, `clients`, `product`, or `engineering`
- `vault-roles.yaml`, `build-vaults.sh`, `docs/build-vaults-README.md` only when `feature_flags.role_vaults_enabled = true`

### Step 2: Write `.business-brain.json`

Write the normalized config file at the vault root. It must include the finalized `generated_files`, `generated_directories`, `legacy_sections`, and today’s date in `generated_at`.

### Step 3: Create section folders and dashboards

For every section:

Write `[folder]/_index.md`:

```markdown
---
title: "[Section Name]"
date: {{today}}
source: "system"
sensitivity: [default_sensitivity]
---

# [Section Name]

[section description]

## What lives here
- Working notes and reference material for [section name in lowercase]
- Use templates from `Templates/` for consistent frontmatter

## Default rules
- Sensitivity default: `[default_sensitivity]`
- Keep note titles specific and searchable
```

Write `[folder]/dashboard.md`:

~~~~markdown
---
title: "[Section Name] Dashboard"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# [Section Name] Dashboard

## Purpose
Working view for [section name in lowercase].

## Recent notes
```dataview
TABLE date, source, sensitivity
FROM "[folder]"
WHERE file.name != "dashboard" AND file.name != "_index"
SORT date DESC
LIMIT 10
```
~~~~

Write `00-Home/dashboard.md`:

~~~~markdown
---
title: "Home Dashboard"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# [Business Name] Dashboard

## Sections
[bullet list of section links]

## Active Projects
```dataview
TABLE rows.status AS Status, rows.location AS Location
FROM "PROGRESS"
FLATTEN file.lists AS rows
WHERE contains(rows.text, "**Status:**")
LIMIT 20
```

## Recent Sessions
```dataview
TABLE date, project
FROM "Sessions"
SORT date DESC
LIMIT 5
```
~~~~

### Step 4: Write `CLAUDE.md`

Write `CLAUDE.md`. It must be deterministic and stay under 200 lines.

Use this structure:

```markdown
# [Business Name] — Operating Manual

Claude reads this file at the start of each session.

## Company Context
- Business: [business_name]
- Role: [user_role]
- Location: [location]
- Team size: [team_size]
- Systems: [short systems summary]
- Financial year starts: [fy_start_month]

## Workspace Structure
- `.business-brain.json` — managed setup config
- `.claude/commands/` — `/resume`, `/wrap-up`, `/morning`
- `00-Home/` — master dashboard
- `[section folders]` — business work areas
- `Sessions/` — session logs
- `Templates/` — note templates
- `Memory/` — local memory/reference files
- `PROGRESS.md` — cross-business dashboard

## Session Workflow
1. Start with `/resume`
2. Do the work
3. End with `/wrap-up`
4. Keep `PROGRESS.md` current when priorities change

## Sensitivity Rules
[mode none]
- Default working notes use `sensitivity: GREEN`
- Use `private: true` only for notes that should never be copied into staff-facing outputs

[mode two-tier]
- General notes use `sensitivity: GREEN`
- Restricted notes use `sensitivity: AMBER`
- Use `private: true` only for notes that should stay out of any shared copy

[mode four-tier]
- `RED` = master-vault-only critical data
- `AMBER` = restricted operational or commercial data
- `BLUE` = role-specific content
- `GREEN` = company-wide content
- Use `access` only when a note is limited to named access levels
- Use `private: true` only when a note must never appear in derived role vaults

## Content Rules
- Every generated or managed note uses: `title`, `date`, `source`, `sensitivity`
- `access` is optional
- `private` is optional
- Store reference summaries in `Memory/`, not hidden tool-specific paths
```

### Step 5: Write `PROGRESS.md`

```markdown
---
type: dashboard
last_updated: {{today}}
source: system
sensitivity: GREEN
---

# [Business Name] — Status Dashboard

## Active Areas
[for each section]

### [Section Name]
- **Status:** Not started
- **Location:** `[folder]/`
- **Next move:** Add the first working note for this area

---

## Session Log
| Date | Project | Summary |
|------|---------|---------|
```

### Step 6: Write slash commands

Write `.claude/commands/resume.md`:

```markdown
Read these files to understand the current state of the business workspace:

1. `CLAUDE.md`
2. `.business-brain.json`
3. `PROGRESS.md`
4. `Memory/MEMORY.md`
5. The 3 most recent files in `Sessions/`

Then:
- Read linked memory files from `Memory/MEMORY.md`
- Summarize the last 3 sessions in one line each
- Identify the current priority from `PROGRESS.md`
- Identify blockers or stale areas

If the latest session log is older than 2 calendar days, flag it.
If `PROGRESS.md` is older than 5 calendar days, flag it.

End with:
**What do you want to focus on today?**
```

Write `.claude/commands/wrap-up.md`:

```markdown
End-of-session wrap-up.

1. Create a session log in `Sessions/` named `YYYY-MM-DD-[topic].md` using `Templates/session-log.md`
2. Fill these sections:
   - Context
   - Work Done
   - Changes Applied
   - Decisions Made
   - Key Facts Learned
   - Pending / Next Steps
   - Handoff Notes
3. Update `PROGRESS.md`:
   - update `last_updated`
   - add or revise pending items where needed
   - append a row to the session log table
4. Summarize what was logged and what remains open
```

Write `.claude/commands/morning.md` based on the normalized config:

```markdown
Daily briefing for the [user_role] at [business_name].

## Pre-flight
- If today is Saturday or Sunday, output:
  "No work day scheduled. Run `/resume` if you want project context."
  Then stop.

## Phase 1 — Local context
Read:
1. `CLAUDE.md`
2. `.business-brain.json`
3. `PROGRESS.md`
4. `Memory/MEMORY.md`
5. The most recent session log in `Sessions/`

Summarize open work, blockers, and what changed last session.

## Phase 2 — Live sources
Use only the sections enabled in `.business-brain.json.daily_workflow`.

[email]
- If email = gmail: use Gmail MCP if available; otherwise note "Gmail configured but not connected"
- If email = outlook: use Outlook MCP if available; otherwise note "Outlook configured but not connected"
- Otherwise: "Email source is manual"

[calendar]
- If calendar = google: use Google Calendar MCP if available
- If calendar = outlook: use Outlook Calendar MCP if available
- Otherwise: "Calendar source is manual"

[team-tasks or self-review]
- If tasks = google-tasks: use Google Tasks MCP if available
- If tasks = todoist or asana: use that MCP if available
- Otherwise: use a manual team or self-review checklist

[sales-pipeline]
- If crm = zoho: use Zoho CRM MCP if available
- If crm = hubspot or salesforce: use that MCP if available
- Otherwise: use a manual sales checklist

[financials]
- If accounting is configured: use a manual accounting checklist unless a suitable MCP integration is available
- Otherwise: skip

[projects]
- Always pull project status from `PROGRESS.md`

## Output
Produce a short markdown briefing with:
- Today’s schedule
- Enabled workflow sections only
- Open blockers
- Data gaps

End with:
**What do you want to focus on first?**
```

### Step 7: Write templates

Always write `Templates/session-log.md`:

```markdown
---
title: "{{topic}}"
date: {{date}}
source: "session"
sensitivity: GREEN
---

# Session: {{date}} — {{topic}}

## Context

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
```

Always write `Templates/meeting-notes.md`:

```markdown
---
title: "{{title}}"
date: {{date}}
source: "meeting"
sensitivity: GREEN
---

# {{title}}

## Attendees
- 

## Agenda
1. 

## Notes

## Action Items
- [ ]

## Decisions Made
- 
```

Always write `Templates/general-note.md`:

```markdown
---
title: "{{title}}"
date: {{date}}
source: "{{source}}"
sensitivity: GREEN
---

# {{title}}

## Summary

## Details

## Next Actions
- [ ]
```

Conditionally write `Templates/procedure.md`:

```markdown
---
title: "{{title}}"
date: {{date}}
source: "{{source}}"
sensitivity: GREEN
---

# {{title}}

## Purpose

## Steps
1.

## Notes
- 
```

Conditionally write `Templates/project-brief.md`:

```markdown
---
title: "{{title}}"
date: {{date}}
source: "{{source}}"
sensitivity: GREEN
---

# {{title}}

## Objective

## Scope

## Timeline
- Start:
- End:

## Status
Not started
```

### Step 8: Write local memory files

Create a vault-local `Memory/` directory. Do not use a hidden Claude-internal filesystem path.

Write `Memory/MEMORY.md`:

```markdown
# [Business Name] Memory Index

## User
- [user_profile.md](user_profile.md) — role and working context

## Project Context
- [project_overview.md](project_overview.md) — business context and active workstreams

## References
- [reference_systems.md](reference_systems.md) — configured systems and manual sources
[if team size != solo]
- [reference_team_map.md](reference_team_map.md) — roles and responsibilities
```

Write `Memory/user_profile.md`:

```markdown
---
title: "User Profile"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# User Profile

- Name: [operator_name or "Primary operator"]
- Role: [user_role]
- Business: [business_name]
- Location: [location]
- Team size: [team_size]
```

Write `Memory/project_overview.md`:

```markdown
---
title: "Project Overview"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# [Business Name] Overview

- Industry: [industry]
- Systems: [short systems summary]
- Financial year starts: [fy_start_month]
- Sections: [comma-separated section names]
```

Write `Memory/reference_systems.md`:

```markdown
---
title: "Systems Reference"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# Systems Reference

| System | Choice | Status |
|--------|--------|--------|
| Email | [email] | [Configured or Manual] |
| Calendar | [calendar] | [Configured or Manual] |
| CRM | [crm] | [Configured or Manual] |
| Accounting | [accounting] | [Configured or Manual] |
| Tasks | [tasks] | [Configured or Manual] |
```

Write `Memory/reference_team_map.md` when team size is not solo:

```markdown
---
title: "Team Map"
date: {{today}}
source: "system"
sensitivity: GREEN
---

# Team Map

| Name | Role | Notes |
|------|------|-------|
| [operator_name or "Primary operator"] | [user_role] | |
```

### Step 9: Write minimal Obsidian config

Write `.obsidian/app.json`:

```json
{
  "defaultViewMode": "preview",
  "showLineNumber": false,
  "strictLineBreaks": false,
  "readableLineLength": true
}
```

Write `.obsidian/appearance.json`:

```json
{
  "theme": "system"
}
```

Write `.obsidian/community-plugins.json`:

```json
["dataview"]
```

Only preconfigure `dataview` because the generated dashboards depend on it.

### Step 10: Optional role-vault module

Only if `feature_flags.role_vaults_enabled = true`, generate:
- `vault-roles.yaml`
- `build-vaults.sh`
- `docs/build-vaults-README.md`

#### `vault-roles.yaml`

Use:
- output directory = `./Role-Vaults`
- roles from `access_levels`
- never include `RED` in derived role vaults

Sensitivity ceilings:
- highest role gets `AMBER`
- middle roles get `BLUE`
- lowest role gets `GREEN`
- single non-owner role gets `BLUE`

For include paths:
- highest role: `00-Home`, all numbered section folders except `01-Finance`, `Templates`
- middle roles: `00-Home`, non-finance numbered section folders, `Templates`
- lowest roles: `00-Home`, only `GREEN`-safe section folders by script filtering, `Templates`

Write generic YAML using the actual section folder names and actual access levels.

#### `build-vaults.sh`

Write an executable bash script that:
- reads `vault-roles.yaml`
- builds filtered copies into `Role-Vaults/`
- never modifies the master vault
- never copies `.claude`, `Sessions`, `Memory`, `.git`, `node_modules`, or `docs`
- never copies `RED` notes
- excludes notes with `private: true`
- respects `sensitivity` ceiling
- if an `access` field exists, only include the file when the role name is present in `access`
- supports:
  - `./build-vaults.sh`
  - `./build-vaults.sh --role manager`
  - `./build-vaults.sh --dry-run`

#### `docs/build-vaults-README.md`

Document:
- what the role-vault generator does
- quick start commands
- output location
- generated roles
- sensitivity hierarchy
- frontmatter requirements
- hard rules
- troubleshooting

Keep the documentation generic. Do not mention Savwinch or any company-specific paths.

---

## Completion

After generation, output:

```text
Your Business Brain is ready.

What I built:
  - [X] managed config: `.business-brain.json`
  - [X] numbered business folders
  - [X] `CLAUDE.md` and `PROGRESS.md`
  - [X] `/resume`, `/wrap-up`, and `/morning`
  - [X] templates for repeatable notes
  - [X] local `Memory/` reference files
  [If role_vaults_enabled]
  - [X] optional role-vault tooling

Recommended next steps:
  1. Open this folder in Obsidian
  2. Install the Dataview plugin
  3. Start your next session with `/resume`
  4. End sessions with `/wrap-up`
  5. Run `/morning` when you want a daily briefing
  [If role_vaults_enabled]
  6. Preview role vaults with `./build-vaults.sh --dry-run`

Notes:
- Update this setup later by re-running `/setup-business-brain`
- The command will use `.business-brain.json` to update scaffold files safely

What would you like to work on first?
```


