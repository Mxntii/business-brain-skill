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
