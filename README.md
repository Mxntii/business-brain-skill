# Business Brain — Claude Code Command

`/setup-business-brain` builds or safely updates a business operations workspace for Claude Code users who want a clean Obsidian-compatible vault without hand-building the structure.

It interviews the user, normalizes the answers into a managed `.business-brain.json` config, then generates the workspace scaffold in one pass.

## What It Generates

Always generated:
- `.business-brain.json` — managed config for future update runs
- `CLAUDE.md` — deterministic business context for future sessions
- `PROGRESS.md` — cross-business dashboard
- numbered section folders with `_index.md` and `dashboard.md`
- `.claude/commands/resume.md`
- `.claude/commands/wrap-up.md`
- `.claude/commands/morning.md`
- `Templates/` with starter note templates
- `Memory/` with vault-local reference files
- minimal `.obsidian/` config

Generated only when enabled:
- `vault-roles.yaml`
- `build-vaults.sh`
- `docs/build-vaults-README.md`

The role-vault module is enabled automatically for multi-level access setups, or manually if the user asks for staff-specific vaults during confirmation.

## Install

### Preferred bootstrap install

```bash
curl -fsSL https://raw.githubusercontent.com/Mxntii/business-brain-skill/main/install.sh | bash
```

This creates `.claude/commands/setup-business-brain.md` in the current directory by default.

### Install to a different commands directory

```bash
curl -fsSL https://raw.githubusercontent.com/Mxntii/business-brain-skill/main/install.sh | \
  bash -s -- --commands-dir /path/to/.claude/commands
```

### Manual single-file fallback

```bash
mkdir -p .claude/commands
curl -fsSL \
  https://raw.githubusercontent.com/Mxntii/business-brain-skill/main/setup-business-brain.md \
  -o .claude/commands/setup-business-brain.md
```

## Usage

Open Claude Code in the folder where you want the workspace, then run:

```text
/setup-business-brain
```

The command:
1. checks for an existing `.business-brain.json` or `CLAUDE.md`
2. offers safe update, rebuild, or adoption when appropriate
3. asks 5 setup questions
4. shows a concrete build summary
5. generates the workspace after confirmation

## Example Outcome

For a small services business, the generated tree looks like:

```text
My Business/
├── .business-brain.json
├── .claude/commands/
│   ├── resume.md
│   ├── wrap-up.md
│   └── morning.md
├── .obsidian/
├── 00-Home/
│   └── dashboard.md
├── 01-Finance/
│   ├── _index.md
│   └── dashboard.md
├── 02-Clients/
├── 03-Projects/
├── 04-Marketing/
├── 05-Operations/
├── Sessions/
├── Templates/
├── Memory/
├── CLAUDE.md
└── PROGRESS.md
```

If role-vault tooling is enabled, it also generates:

```text
build-vaults.sh
vault-roles.yaml
docs/build-vaults-README.md
```

## Update and Rebuild Behavior

If `.business-brain.json` already exists:
- **Update config safely** re-runs only the selected interview sections and rewrites tracked scaffold files only
- **Rebuild scaffold from scratch** backs up generated scaffold files into `_backup_YYYY-MM-DD-HHMMSS/` before regenerating

Important safety rules:
- user-authored business content inside numbered section folders is not deleted during update
- removed sections are marked as legacy in `.business-brain.json` instead of being silently deleted
- `Sessions/` content is preserved

## Source Layout

This repo uses a multi-file source package for maintainability:

```text
src/
├── 00-overview.md
├── 10-preflight.md
├── 20-interview.md
├── 30-confirmation.md
├── 40-generation.md
└── 50-completion.md
scripts/
├── build-command.sh
└── validate.sh
```

`setup-business-brain.md` at the repo root remains the legacy single-file install artifact for compatibility.

## Local Development

Rebuild the command artifact:

```bash
./scripts/build-command.sh
```

Run lightweight validation:

```bash
./scripts/validate.sh
```

## Truthful Constraints

- The setup records configured tools, but does not prove MCP connectivity during install.
- Dataview is the only Obsidian plugin preconfigured, because the generated dashboards rely on it.
- Role-vault tooling is optional and should not be assumed to exist unless it was enabled during setup.

## License

MIT
