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
