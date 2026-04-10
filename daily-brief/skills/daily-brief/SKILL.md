---
name: daily-brief
description: Generate a comprehensive daily market briefing with global indices, rates, commodities, FX, economic data, geopolitical developments, and upcoming events. Produces YAML intelligence content files for the Equiforte website. Use when the user asks to "generate daily brief", "create morning briefing", "run the daily brief", or invokes /daily-brief.
---

# Daily Market Brief

Generate a daily market briefing for **{{ focus | default: "all" }}** professionals as of **{{ date | default: "today" }}**.

## CRITICAL: Efficiency Constraints

This brief must complete within **5 minutes**. Total web operations (WebSearch + WebFetch combined): **maximum 26**.

- Market snapshot: 2-3 WebSearch + 3 WebFetch = max 6 steps
- Geopolitical monitor: 4-5 WebSearch = max 5 steps
- Regulatory & ops intel: max 4 WebSearch
- PE community news: 5 WebFetch + 1 WebSearch = max 6 steps (steps 4-6 conditional)
- Event calendar: 2-3 WebSearch + 1-2 WebFetch = max 5 steps
- Intelligence content assembly: 0 searches (uses only collected data)

**DO NOT** re-search for data you already have. **DO NOT** search for individual assets one at a time. Use broad queries that return summary/dashboard pages. Accept the precision available from summary pages. Mark gaps as `N/A` rather than retrying.

## Instructions

Follow these 5 research phases in order. Each phase has a corresponding SKILL.md file at `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` with the detailed search strategies — read it before starting that phase.

1. **Market Snapshot** (consult `market-snapshot/SKILL.md`) — global equity indices, rates, credit spreads, commodities, FX, volatility
2. **Geopolitical Monitor** (consult `geopolitical-monitor/SKILL.md`) — central bank actions, economic data releases, geopolitical/trade/policy developments, major corporate events
3. **Regulatory & Ops Intel** (consult `regulatory-ops-intel/SKILL.md`) — SEC/CFTC/EU regulatory actions, fund admin technology news, ILPA template/DDQ updates, operational developments for PE CFOs
4. **PE Community News** (consult `pe-community-news/SKILL.md`) — news from 9 PE industry organizations (ACG, SBIA, M&A Source, ILPA, NAIC, TMA, LSTA, ACC/AIMA, MFA). Items feed into existing sections — conferences → Coming This Week, policy → Regulatory Watch, reports → Operational Intel
5. **Event Calendar** (consult `event-calendar/SKILL.md`) — upcoming economic calendar, central bank meetings, earnings, conferences, IPOs, auctions

**Avoid cross-phase duplication:**
- Central bank **actions that already happened today** → phase 2 only
- Central bank **upcoming meeting dates** → phase 5 only
- Economic data **already released today** → phase 2 only
- Economic data **scheduled for future dates** → phase 5 only
- **Regulatory news** → phase 3 only (not phase 2)
- **Fund admin/tech vendor news** → phase 3 only
- **ILPA Reporting Templates / DDQ updates** → phase 3 only (not phase 4)
- **ILPA events, policy positions, non-template news** → phase 4 only (not phase 3)
- **PE org conference announcements** → phase 4 only (not phase 5)
- **PE org policy/advocacy on regulation** → phase 4 only (not phase 3)

6. **Assembly** (consult `intelligence-content/SKILL.md`) — assemble all collected data into the final YAML output files. No additional searches. The intelligence-content SKILL.md contains the exact YAML schemas, complete examples from the live website, and a WRONG vs RIGHT section.

## Output: Intelligence Content YAML Files

**The YAML files are the primary deliverable.** Follow the `intelligence-content` skill format exactly.

1. Create the output directories:
   ```
   mkdir -p output/intelligence-data/{ticker,daily-brief}
   ```

2. Write **three** files:
   - **`output/intelligence-data/daily-brief/{{ date | default: "YYYY-MM-DD" }}.yaml`** — Full daily brief with all 6 standard sections
   - **`output/intelligence-data/ticker/latest.yaml`** — Ticker banner with 4-6 key data points from the brief
   - **`output/intelligence-data/sources.md`** — All sources used during research, grouped by skill, with URLs and what data was pulled from each

3. **Run the validation hook** (MANDATORY — do not skip):
   ```
   bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/post-generate.sh
   ```
   This script validates that both YAML files match the exact schema the website expects.
   - If it exits with code 0: **PASS** — output is ready.
   - If it exits with non-zero: **FAIL** — you MUST read every ERROR line, fix the files, and re-run the hook. Repeat until it passes. Do NOT deliver output that fails validation.

   **Common fixes the hook will catch:**
   - Forbidden fields like `sections:`, `subtitle:`, `classification:` → remove them, use only the 7 allowed fields
   - Missing `preview: |` or `full_content: |` → content must be YAML multiline strings with HTML
   - Plain text instead of HTML → wrap in `<h3>`, `<table>`, `<p>`, `<ul>` tags
   - Wrong ticker structure → each item needs only `text:` and `category:`, not `symbol:`/`value:`/`direction:`
   - Missing section headers → ensure all 6 `<h3>` section headers are in `full_content`

### YAML Structure — STRICT FORMAT (website will break otherwise)

The website parses these files with `gray-matter` and reads ONLY specific fields. Any deviation produces blank pages.

**Daily brief YAML — EXACTLY 7 top-level fields, nothing else:**
```yaml
---
title: "Daily Market Brief"
date: "YYYY-MM-DD"
author: "Equiforte Intelligence"
status: "published"
summary: "Under 200 chars"
preview: |
  <h3>1. Market Snapshot</h3>
  ...HTML tables and content for sections 1-2...
  <h3>2. Regulatory Watch</h3>
  ...HTML content...
full_content: |
  <h3>1. Market Snapshot</h3>
  ...same as preview...
  <h3>2. Regulatory Watch</h3>
  ...same as preview...
  <h3>3. Operational Intel</h3>
  ...HTML content...
  <h3>4. Data Snapshot</h3>
  ...HTML table...
  <h3>5. The CFO Take</h3>
  ...HTML list...
  <h3>6. Coming This Week</h3>
  ...HTML table...
```

**DO NOT** add `sections:`, `subtitle:`, `classification:`, `generated_at:`, `footer:`, `metadata:`, or ANY other top-level field. The website ignores them.

**DO NOT** use plain text or markdown inside `preview`/`full_content`. It MUST be HTML (`<h3>`, `<table>`, `<p>`, `<ul>`, `<strong>`, etc.) because the website renders it via `dangerouslySetInnerHTML`.

**Ticker YAML — EXACTLY 3 top-level fields:**
```yaml
---
date: "YYYY-MM-DD"
updated_at: "YYYY-MM-DDTHH:MM:SS-04:00"
items:
  - text: "S&P 500 6,381.77 ▲ +0.20%"
    category: "equity"
```

**DO NOT** use `equities:`, `fixed_income:`, `alerts:`, `symbol:`, `value:`, `direction:` or any other structure. Each item has ONLY `text` and `category`.

See the `intelligence-content` skill for complete examples from the live website.

## Focus Area Guidance

- **all**: Full briefing across all sections with equal weight.
- **pe**: Emphasize M&A activity, leveraged loan / HY markets, sponsor-backed deal flow, PE conferences.
- **pd**: Emphasize credit spreads, leveraged loan indices, CLO markets, default rates, direct lending.
- **hf**: Emphasize volatility, flows, positioning, factor performance, cross-asset momentum.
- **ib**: Emphasize ECM/DCM issuance, M&A announced/closed, IPO pipeline, sector deal activity.

## Content Rules

- All HTML content within YAML fields. Use `<h3>`, `<p>`, `<table>`, `<ul>`, `<li>`, `<strong>`, `<em>`, `<blockquote>`.
- Facts, data, and sourced statistics only. No opinions, forecasts, or subjective interpretation.
- `N/A` for unavailable data — never fabricate.
- `full_content` MUST include all preview content plus additional gated sections.
- Positive changes: `+`, Negative: `-`, Unchanged: `Unchanged`
- Rate changes in bps. Billions: `$12.3B`, Millions: `$456.7M`.

Do NOT skip the file write step. The YAML files in `output/intelligence-data/` are the deliverable.
