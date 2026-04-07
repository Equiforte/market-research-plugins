---
name: daily-brief
description: Generate a comprehensive daily market briefing with global indices, rates, commodities, FX, economic data, geopolitical developments, and upcoming events. Produces YAML intelligence content files for the Equiforte website. Use when the user asks to "generate daily brief", "create morning briefing", "run the daily brief", or invokes /daily-brief.
arguments:
  - name: focus
    description: "Optional focus area: 'pe' (private equity), 'pd' (private debt / credit), 'hf' (hedge funds), 'ib' (investment banking), or 'all' (default). Adjusts which sections are emphasized."
    required: false
  - name: date
    description: "Date for the briefing (YYYY-MM-DD). Defaults to today."
    required: false
  - name: output
    description: "Output path for the intelligence data directory. Defaults to ./output/intelligence-data"
    required: false
---

# Daily Market Brief

Generate a daily market briefing for **{{ focus | default: "all" }}** professionals as of **{{ date | default: "today" }}**.

## CRITICAL: Efficiency Constraints

This brief must complete within **5 minutes**. Total web operations (WebSearch + WebFetch combined): **maximum 20**.

- Market snapshot: 2-3 WebSearch + 3 WebFetch = max 6 steps
- Geopolitical monitor: 4-5 WebSearch = max 5 steps
- Regulatory & ops intel: max 4 WebSearch
- Event calendar: 2-3 WebSearch + 1-2 WebFetch = max 5 steps
- Intelligence content assembly: 0 searches (uses only collected data)

**DO NOT** re-search for data you already have. **DO NOT** search for individual assets one at a time. Use broad queries that return summary/dashboard pages. Accept the precision available from summary pages. Mark gaps as `N/A` rather than retrying.

## Instructions

Gather data using these skills in order, then assemble the final YAML output:

1. **market-snapshot** — global equity indices, rates, credit spreads, commodities, FX, volatility
2. **geopolitical-monitor** — central bank actions, economic data releases, geopolitical/trade/policy developments, major corporate events
3. **regulatory-ops-intel** — SEC/CFTC/EU regulatory actions, fund admin technology news, ILPA updates, operational developments for PE CFOs
4. **event-calendar** — upcoming economic calendar, central bank meetings, earnings, conferences, IPOs, auctions

**Important — avoid cross-task duplication:**
- Central bank **actions that already happened today** → geopolitical-monitor only
- Central bank **upcoming meeting dates** → event-calendar only
- Economic data **already released today** → geopolitical-monitor only
- Economic data **scheduled for future dates** → event-calendar only
- **Regulatory news** → regulatory-ops-intel only (not geopolitical-monitor)
- **Fund admin/tech vendor news** → regulatory-ops-intel only

5. **intelligence-content** skill — use this skill's format specifications to assemble all collected data into the final YAML output files. No additional searches.

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

3. After writing, verify all files exist and are non-empty:
   ```
   ls -la output/intelligence-data/daily-brief/*.yaml output/intelligence-data/ticker/*.yaml output/intelligence-data/sources.md
   ```

### YAML Structure Requirements

**CRITICAL: Every YAML file MUST begin with `---` on the very first line.** No whitespace, comments, or blank lines before `---`.

Each daily-brief YAML MUST contain:
- `title` — Full title with date
- `date` — YYYY-MM-DD format
- `author` — "Equiforte Intelligence"
- `status` — "published"
- `summary` — Under 200 chars, for homepage card
- `preview` — HTML content visible to all (ungated, first 2 sections)
- `full_content` — HTML content with ALL sections (gated, includes preview content plus additional sections)

The ticker YAML uses a different format — see intelligence-content skill.

### Daily Brief Standard Sections (in full_content)

1. **Market Snapshot** — rates, spreads, deal activity (HTML tables)
2. **Regulatory Watch** — new rules, deadlines, guidance
3. **Operational Intel** — fund admin, technology, vendor news
4. **Data Snapshot** — key metrics table
5. **The CFO Take** — 3 actionable items for PE CFOs today
6. **Coming This Week** — upcoming events and data releases

**Preview** includes sections 1-2 (Market Snapshot + Regulatory Watch).
**Full content** includes all 6 sections.

### Ticker Banner

Distill 4-6 key data points from the brief. Each item under 80 chars with ▲/▼ direction indicators.

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
