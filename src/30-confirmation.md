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
