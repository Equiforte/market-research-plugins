---
name: intelligence-content
description: Assembly-only skill that takes collected market data from other skills and produces the final YAML output files. Provides the mandatory output format and structure for all Equiforte intelligence content types. Use after all research skills have completed. This skill performs ZERO web searches.
---

# Intelligence Content Assembly

Assemble all collected data into structured YAML content files. This skill performs **ZERO web searches** — it only formats and writes data already gathered by other skills.

## CRITICAL: YAML File Rules

1. **Every YAML file MUST begin with `---` on the very first line.** No whitespace, comments, or blank lines before `---`. The website parser requires this — files without `---` as the first line will fail to load.
2. All HTML content goes inside YAML multiline string fields (`preview: |` and `full_content: |`).
3. Use only these HTML tags: `<h3>`, `<p>`, `<table>`, `<thead>`, `<tbody>`, `<tr>`, `<th>`, `<td>`, `<ul>`, `<li>`, `<strong>`, `<em>`, `<blockquote>`, `<hr/>`.
4. Escape `&` as `&amp;` in HTML content within YAML.

## Output File 1: Daily Brief (`daily-brief/YYYY-MM-DD.yaml`)

### Schema

```yaml
---
title: "Daily Market Brief"
date: "YYYY-MM-DD"
author: "Equiforte Intelligence"
status: "published"
summary: "string"         # Under 200 chars, for homepage card and SEO
preview: |                # HTML — sections 1-2 (ungated, visible to all)
  ...
full_content: |           # HTML — all 6 sections (gated, requires registration)
  ...
```

### Section Structure

**Preview (ungated)** — sections 1-2:

```html
<h3>1. Market Snapshot</h3>
<!-- HTML tables for each asset class -->

<h3>2. Regulatory Watch</h3>
<!-- Regulatory items -->
```

**Full content (gated)** — all 6 sections. MUST include sections 1-2 verbatim, then add:

```html
<h3>1. Market Snapshot</h3>
<!-- Same as preview -->

<h3>2. Regulatory Watch</h3>
<!-- Same as preview -->

<h3>3. Operational Intel</h3>
<!-- Fund admin, tech, ILPA, ops items -->

<h3>4. Data Snapshot</h3>
<!-- Compact metrics table — numbers MUST match section 1 -->

<h3>5. The CFO Take</h3>
<!-- 3 actionable items for PE CFOs -->

<h3>6. Coming This Week</h3>
<!-- Forward calendar table -->
```

### Section Details

#### 1. Market Snapshot
- Use `<table>` with key indices grouped by asset class
- Sub-tables or sub-headers for: U.S. Equities, Global Equities, Rates & Credit, Commodities, FX & Digital Assets
- Include Level/Price, Change, and % Change columns
- Add 1-2 sentence narrative after each sub-table
- All numbers from the market-snapshot skill — never estimate

#### 2. Regulatory Watch
- Each item: `<p><strong>Headline</strong></p><p>Description with affected parties, dates, required actions.</p>`
- Include specific deadlines and effective dates
- State which fund types/sizes affected
- 2-4 items from regulatory-ops-intel skill

#### 3. Operational Intel
- Each item: `<p><strong>Headline</strong></p><p>Description with timeline and impact.</p>`
- Focus on changes requiring CFO action
- 2-3 items from regulatory-ops-intel skill

#### 4. Data Snapshot
- Single compact `<table>` with Metric, Value, Signal columns
- Maximum 10-15 rows
- Numbers MUST be consistent with section 1 — cross-check
- Include Fed Funds rate, key spreads, major indices, notable data releases

#### 5. The CFO Take
```html
<ul>
  <li><strong>Action 1 — Topic.</strong> Actionable guidance in 2-3 sentences tied to today's data.</li>
  <li><strong>Action 2 — Topic.</strong> Actionable guidance in 2-3 sentences tied to today's data.</li>
  <li><strong>Action 3 — Topic.</strong> Actionable guidance in 2-3 sentences tied to today's data.</li>
</ul>
```
- Each item ties to something reported in sections 1-4
- Actionable: starts with what to do (review, coordinate, prepare, update, evaluate)
- PE CFO perspective: operations, compliance, LP relations, fund admin, treasury

#### 6. Coming This Week
- `<table>` with Date, Event, Significance columns
- From event-calendar skill data
- Only high-importance events
- Include day + time (ET) for economic releases

### Full Example

```yaml
---
title: "Daily Market Brief"
date: "2026-03-30"
author: "Equiforte Intelligence"
status: "published"
summary: "S&P 500 +0.20%; UST 10Y at 4.35%; gold at $4,553; Brent above $111 on Hormuz crisis."
preview: |
  <h3>1. Market Snapshot</h3>

  <p><strong>U.S. Equities</strong></p>
  <table>
    <thead><tr><th>Index</th><th>Level</th><th>Change</th><th>% Chg</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>6,381.77</td><td>+12.92</td><td>+0.20%</td></tr>
      <tr><td>Dow 30</td><td>45,398.17</td><td>+231.53</td><td>+0.51%</td></tr>
    </tbody>
  </table>

  <h3>2. Regulatory Watch</h3>

  <p><strong>Form PF Compliance Extended to October 2026</strong></p>
  <p>The SEC and CFTC have further extended the compliance date for amended Form PF.</p>

full_content: |
  <h3>1. Market Snapshot</h3>
  <!-- Same content as preview section 1 -->

  <h3>2. Regulatory Watch</h3>
  <!-- Same content as preview section 2 -->

  <h3>3. Operational Intel</h3>
  <p><strong>ILPA Template Adoption — Action Required</strong></p>
  <p>The Q1 2026 implementation window is closing...</p>

  <h3>4. Data Snapshot</h3>
  <table>
    <thead><tr><th>Metric</th><th>Value</th><th>Signal</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>6,381.77</td><td>+0.20%</td></tr>
    </tbody>
  </table>

  <h3>5. The CFO Take</h3>
  <ul>
    <li><strong>Action 1 — Review Hormuz Exposure.</strong> Request updated commodity hedging positions.</li>
  </ul>

  <h3>6. Coming This Week</h3>
  <table>
    <thead><tr><th>Date</th><th>Event</th><th>Significance</th></tr></thead>
    <tbody>
      <tr><td>Mon Mar 30</td><td>Fed Chair Powell speaks</td><td>First remarks since March FOMC hold</td></tr>
    </tbody>
  </table>
```

## Output File 2: Ticker Banner (`ticker/latest.yaml`)

Always overwrites `latest.yaml` — not versioned by date.

### Schema

```yaml
---
date: "YYYY-MM-DD"
updated_at: "YYYY-MM-DDTHH:MM:SS-04:00"
items:
  - text: "string"        # Under 80 chars — metric + direction + value
    category: "string"    # equity | rates | commodity | volatility
```

### Rules

- 4-6 items
- Each item under 80 characters
- Direction indicators: `▲` (up), `▼` (down)
- Categories: `equity`, `rates`, `commodity`, `volatility`
- Mix positive and negative indicators for balance
- Distill the most market-moving data points from the daily brief

### Full Example

```yaml
---
date: "2026-03-30"
updated_at: "2026-03-30T14:00:00-04:00"
items:
  - text: "S&P 500 6,381.77 ▲ +0.20%"
    category: "equity"
  - text: "UST 10Y 4.348% ▼ -9.2 bps"
    category: "rates"
  - text: "Brent $111.10 ▼ -$0.16 | Hormuz closed"
    category: "commodity"
  - text: "VIX 30.08 ▼ -3.12% | Elevated"
    category: "volatility"
  - text: "Gold $4,568.71 | -13% from ATH"
    category: "commodity"
  - text: "EUR/USD 1.1468 ▼ -0.37% | 34% net short"
    category: "rates"
```

## Assembly Checklist

Before writing the files, verify:

- [ ] Daily brief has all 6 sections in `full_content`
- [ ] `preview` contains sections 1-2 only
- [ ] `preview` content appears verbatim in `full_content`
- [ ] `summary` is under 200 characters
- [ ] Numbers in Data Snapshot (section 4) match Market Snapshot (section 1)
- [ ] Each CFO Take item (section 5) references data from sections 1-4
- [ ] Ticker has 4-6 items, each under 80 characters
- [ ] Ticker items have both `text` and `category` fields
- [ ] Both files start with `---` on line 1
- [ ] All `&` in HTML are escaped as `&amp;`
- [ ] No fabricated data — `N/A` for unavailable values

## Output File 3: Sources (`sources.md`)

After writing the YAML files, write a `sources.md` file that logs every source used during research. This file is a deliverable alongside the YAML files.

**Path:** `output/intelligence-data/sources.md`

### Format

```markdown
# Sources — Daily Brief YYYY-MM-DD

## Market Snapshot
- [Source name](URL) — what data was pulled (e.g., "US equities, VIX")
- [Source name](URL) — what data was pulled

## Geopolitical & Macro
- [Source name](URL) — what was reported

## Regulatory & Ops Intel
- [Source name](URL) — what was reported

## Event Calendar
- [Source name](URL) — what events were found

## Notes
- Any data gaps, stale data, or blocked sources encountered
```

### Rules

- List every URL that was searched or fetched, grouped by skill
- For WebSearch results, use the source article/page URL, not the search query
- For WebFetch, use the exact URL fetched
- Note which data points came from which source
- Note any data that was unavailable or stale (e.g., "Credit spreads from FRED — 403 blocked, used approximation from search")

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Daily Brief | `YYYY-MM-DD.yaml` | `daily-brief/2026-03-30.yaml` |
| Ticker | `latest.yaml` (always) | `ticker/latest.yaml` |
| Sources | `sources.md` | `sources.md` |
