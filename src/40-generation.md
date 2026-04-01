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
