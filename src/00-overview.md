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
