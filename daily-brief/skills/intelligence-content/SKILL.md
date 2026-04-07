---
name: intelligence-content
description: Assembly-only skill that takes collected market data from other skills and produces the final YAML output files. Provides the mandatory output format and structure for all Equiforte intelligence content types. Use after all research skills have completed. This skill performs ZERO web searches.
---

# Intelligence Content Assembly

Assemble all collected data into structured YAML content files. This skill performs **ZERO web searches** — it only formats and writes data already gathered by other skills.

## CRITICAL: The website will BREAK if you deviate from the exact schemas below.

The website uses the `gray-matter` npm package to parse these YAML files. It reads **only** the specific fields listed below. Any other fields are silently ignored, meaning the page will render blank or crash.

The website TypeScript interfaces are:

```typescript
// For daily-brief YAML — these are the ONLY fields the website reads
interface IntelligenceArticle {
  title: string;       // Rendered as <h1>
  date: string;        // Shown as metadata
  author: string;      // Shown as metadata
  status: string;      // Must be "published" to appear on site
  summary: string;     // Used on homepage card
  preview: string;     // HTML string — ungated content
  full_content: string; // HTML string — all content rendered via dangerouslySetInnerHTML
}

// For ticker YAML — these are the ONLY fields the website reads
interface TickerData {
  updated_at: string;
  separator?: string;
  items: { text: string; direction: "up" | "down" | "neutral" }[];
}
```

## WRONG vs RIGHT — Common Mistakes

### WRONG: Using a `sections:` array (NEVER DO THIS)
```yaml
sections:
  - id: market-snapshot
    title: "Market Snapshot"
    content: |
      Some text here...
```
The website does NOT read a `sections` field. This produces a blank page.

### WRONG: Using structured data objects (NEVER DO THIS)
```yaml
equities:
  - symbol: "SPX"
    value: 5820
    direction: "down"
```
The website does NOT read `equities`, `fixed_income`, `commodities`, `fx`, `volatility`, or `alerts` fields. This produces a blank ticker.

### WRONG: Using plain text content (NEVER DO THIS)
```yaml
full_content: |
  US equity markets pulled back on Tuesday as geopolitical risk dominated...

  **Equities:**
  - S&P 500: ~5,820 (intraday), down ~0.3%
```
The website renders `full_content` as raw HTML via `dangerouslySetInnerHTML`. Plain text and markdown will render as an unformatted blob.

### WRONG: Adding extra fields (NEVER DO THIS)
```yaml
subtitle: "April 7, 2026"
classification: "CONFIDENTIAL"
generated_at: "2026-04-07T15:29:00-04:00"
footer:
  disclaimer: "..."
```
The website ignores all of these. They are waste.

### RIGHT: Daily Brief (follow this EXACTLY)
```yaml
---
title: "Daily Market Brief"
date: "2026-04-07"
author: "Equiforte Intelligence"
status: "published"
summary: "Under 200 chars summary for homepage card."
preview: |
  <h3>1. Market Snapshot</h3>
  <p><strong>U.S. Equities</strong></p>
  <table>
    <thead><tr><th>Index</th><th>Level</th><th>Change</th><th>% Chg</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>5,820</td><td>-17.46</td><td>-0.30%</td></tr>
    </tbody>
  </table>
  <h3>2. Regulatory Watch</h3>
  <p><strong>Headline</strong></p>
  <p>Description text.</p>
full_content: |
  <h3>1. Market Snapshot</h3>
  ...all 6 sections as HTML...
```

### RIGHT: Ticker (follow this EXACTLY)
```yaml
---
date: "2026-04-07"
updated_at: "2026-04-07T14:00:00-04:00"
items:
  - text: "S&P 500 5,820 ▼ -0.30%"
    category: "equity"
  - text: "UST 10Y 4.34% ▲ +3 bps"
    category: "rates"
```

---

## Output File 1: Daily Brief (`daily-brief/YYYY-MM-DD.yaml`)

The file has **exactly 7 top-level YAML fields** and nothing else:

```yaml
---
title: "Daily Market Brief"
date: "YYYY-MM-DD"
author: "Equiforte Intelligence"
status: "published"
summary: "..."
preview: |
  ...HTML...
full_content: |
  ...HTML...
```

**No other top-level fields.** No `subtitle`, `classification`, `generated_at`, `as_of`, `sections`, `footer`, `metadata`, or anything else.

### `preview` field — HTML for ungated content (sections 1-2)

The `preview` field is a YAML multiline string (`preview: |`) containing HTML. It includes sections 1 and 2 only. The content renders directly in the browser via `dangerouslySetInnerHTML`, so it MUST be valid HTML.

### `full_content` field — HTML for all 6 sections (gated)

The `full_content` field is a YAML multiline string (`full_content: |`) containing HTML. It includes ALL 6 sections. Sections 1-2 must appear identically in both `preview` and `full_content`.

### The 6 sections (all inside `full_content` as HTML)

Every section is an `<h3>` followed by HTML content. All 6 must appear in order:

```html
<h3>1. Market Snapshot</h3>
<!-- Tables for: U.S. Equities, Global Equities, Rates & Credit, Commodities, FX & Digital Assets -->
<!-- 1-2 sentence narrative after each sub-table -->

<h3>2. Regulatory Watch</h3>
<!-- Each item: <p><strong>Headline</strong></p><p>Description with dates, affected parties, required actions.</p> -->

<h3>3. Operational Intel</h3>
<!-- Each item: <p><strong>Headline</strong></p><p>Description with timeline and impact.</p> -->

<h3>4. Data Snapshot</h3>
<!-- Single <table> with Metric, Value, Signal columns. Numbers must match section 1. -->

<h3>5. The CFO Take</h3>
<!-- <ul> with 3 <li> items. Each: <strong>Action N — Topic.</strong> 2-3 sentences. -->

<h3>6. Coming This Week</h3>
<!-- <table> with Date, Event, Significance columns. -->
```

### Complete Daily Brief Example

This is a real file from the website. Your output must match this structure exactly:

```yaml
---
title: "Daily Market Brief"
date: "2026-03-30"
author: "Equiforte Intelligence"
status: "published"
summary: "Strait of Hormuz crisis drives oil above $111; UST 10Y at 4.35%; gold at $4,553; S&P 500 rebounds +0.2%; NFP Friday on Good Friday."
preview: |
  <h3>1. Market Snapshot</h3>

  <p><strong>U.S. Equities</strong></p>
  <table>
    <thead><tr><th>Index</th><th>Level</th><th>Change</th><th>% Chg</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>6,381.77</td><td>+12.92</td><td>+0.20%</td></tr>
      <tr><td>Dow 30</td><td>45,398.17</td><td>+231.53</td><td>+0.51%</td></tr>
      <tr><td>Nasdaq Composite</td><td>20,937.44</td><td>-10.92</td><td>-0.05%</td></tr>
      <tr><td>Russell 2000</td><td>2,434.10</td><td>-15.60</td><td>-0.64%</td></tr>
      <tr><td>VIX</td><td>30.08</td><td>-0.97</td><td>-3.12%</td></tr>
    </tbody>
  </table>

  <p><strong>Rates &amp; Credit</strong></p>
  <table>
    <thead><tr><th>Instrument</th><th>Level</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>UST 2Y</td><td>3.96%</td><td>+60 bps MTD</td></tr>
      <tr><td>UST 10Y</td><td>4.348%</td><td>-9.2 bps</td></tr>
      <tr><td>UST 30Y</td><td>~4.96%</td><td>Near 8-mo high</td></tr>
      <tr><td>Fed Funds</td><td>3.50%-3.75%</td><td>Unchanged (Mar 18)</td></tr>
      <tr><td>HY OAS (ICE BofA)</td><td>321 bps</td><td>Historically tight</td></tr>
    </tbody>
  </table>
  <p>Bond yields eased from peaks as growth concerns temper inflationary pressures.</p>

  <p><strong>Commodities</strong></p>
  <table>
    <thead><tr><th>Commodity</th><th>Price</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>Brent Crude</td><td>$111.10/bbl</td><td>-$0.16</td></tr>
      <tr><td>WTI Crude</td><td>$101.37/bbl</td><td>+$1.73</td></tr>
      <tr><td>Gold (Spot)</td><td>$4,568.71</td><td>N/A</td></tr>
      <tr><td>Natural Gas</td><td>$3.025</td><td>+0.87%</td></tr>
    </tbody>
  </table>

  <p><strong>FX &amp; Digital Assets</strong></p>
  <table>
    <thead><tr><th>Pair</th><th>Level</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>EUR/USD</td><td>1.1468</td><td>-0.37%</td></tr>
      <tr><td>DXY</td><td>101.42</td><td>&#9660;</td></tr>
      <tr><td>USD/JPY</td><td>~160.00</td><td>Near intervention line</td></tr>
      <tr><td>BTC/USD</td><td>$67,219.31</td><td>+1.12%</td></tr>
    </tbody>
  </table>

  <h3>2. Regulatory Watch</h3>

  <p><strong>Form PF Compliance Extended to October 2026</strong></p>
  <p>The SEC and CFTC have further extended the compliance date for amended Form PF from October 1, 2025 to October 1, 2026.</p>

  <p><strong>CFTC QEP Exemption Restored (Interim)</strong></p>
  <p>The CFTC's December 2025 no-action letter restores the former Rule 4.13(a)(4) exemption on an interim basis.</p>

full_content: |
  <h3>1. Market Snapshot</h3>

  <p><strong>U.S. Equities</strong></p>
  <table>
    <thead><tr><th>Index</th><th>Level</th><th>Change</th><th>% Chg</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>6,381.77</td><td>+12.92</td><td>+0.20%</td></tr>
      <tr><td>Dow 30</td><td>45,398.17</td><td>+231.53</td><td>+0.51%</td></tr>
      <tr><td>Nasdaq Composite</td><td>20,937.44</td><td>-10.92</td><td>-0.05%</td></tr>
      <tr><td>Russell 2000</td><td>2,434.10</td><td>-15.60</td><td>-0.64%</td></tr>
      <tr><td>VIX</td><td>30.08</td><td>-0.97</td><td>-3.12%</td></tr>
    </tbody>
  </table>

  <p><strong>Rates &amp; Credit</strong></p>
  <table>
    <thead><tr><th>Instrument</th><th>Level</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>UST 2Y</td><td>3.96%</td><td>+60 bps MTD</td></tr>
      <tr><td>UST 10Y</td><td>4.348%</td><td>-9.2 bps</td></tr>
      <tr><td>UST 30Y</td><td>~4.96%</td><td>Near 8-mo high</td></tr>
      <tr><td>Fed Funds</td><td>3.50%-3.75%</td><td>Unchanged (Mar 18)</td></tr>
      <tr><td>HY OAS (ICE BofA)</td><td>321 bps</td><td>Historically tight</td></tr>
    </tbody>
  </table>
  <p>Bond yields eased from peaks as growth concerns temper inflationary pressures.</p>

  <p><strong>Commodities</strong></p>
  <table>
    <thead><tr><th>Commodity</th><th>Price</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>Brent Crude</td><td>$111.10/bbl</td><td>-$0.16</td></tr>
      <tr><td>WTI Crude</td><td>$101.37/bbl</td><td>+$1.73</td></tr>
      <tr><td>Gold (Spot)</td><td>$4,568.71</td><td>N/A</td></tr>
      <tr><td>Natural Gas</td><td>$3.025</td><td>+0.87%</td></tr>
    </tbody>
  </table>

  <p><strong>FX &amp; Digital Assets</strong></p>
  <table>
    <thead><tr><th>Pair</th><th>Level</th><th>Change</th></tr></thead>
    <tbody>
      <tr><td>EUR/USD</td><td>1.1468</td><td>-0.37%</td></tr>
      <tr><td>DXY</td><td>101.42</td><td>&#9660;</td></tr>
      <tr><td>USD/JPY</td><td>~160.00</td><td>Near intervention line</td></tr>
      <tr><td>BTC/USD</td><td>$67,219.31</td><td>+1.12%</td></tr>
    </tbody>
  </table>

  <h3>2. Regulatory Watch</h3>

  <p><strong>Form PF Compliance Extended to October 2026</strong></p>
  <p>The SEC and CFTC have further extended the compliance date for amended Form PF from October 1, 2025 to October 1, 2026.</p>

  <p><strong>CFTC QEP Exemption Restored (Interim)</strong></p>
  <p>The CFTC's December 2025 no-action letter restores the former Rule 4.13(a)(4) exemption on an interim basis.</p>

  <h3>3. Operational Intel</h3>

  <p><strong>ILPA Template Adoption — Action Required</strong></p>
  <p>The Q1 2026 ILPA implementation window is closing. GPs must assess accounting systems and data capture methodologies.</p>

  <p><strong>EDGAR Next Enrollment Mandatory</strong></p>
  <p>All EDGAR filers must be enrolled in EDGAR Next to submit Section 13 filings.</p>

  <h3>4. Data Snapshot</h3>

  <table>
    <thead><tr><th>Metric</th><th>Value</th><th>Signal</th></tr></thead>
    <tbody>
      <tr><td>S&amp;P 500</td><td>6,381.77</td><td>+0.20%</td></tr>
      <tr><td>VIX</td><td>30.08</td><td>-3.12% (elevated)</td></tr>
      <tr><td>UST 10Y</td><td>4.348%</td><td>-9.2 bps</td></tr>
      <tr><td>Brent Crude</td><td>$111.10</td><td>$14-18 war premium</td></tr>
      <tr><td>Gold</td><td>$4,568.71</td><td>-13% from ATH</td></tr>
      <tr><td>EUR/USD</td><td>1.1468</td><td>34% net short</td></tr>
    </tbody>
  </table>

  <h3>5. The CFO Take</h3>

  <ul>
    <li><strong>Action 1 — Review Hormuz Exposure.</strong> Portfolio companies with energy-intensive operations need immediate P&amp;L impact assessments. Stress test 2026 budgets against a $120+ Brent scenario.</li>
    <li><strong>Action 2 — Finalize ILPA 2.0 Template Readiness.</strong> Ensure your fund administrator can produce compliant quarterly financials. LPs are using ILPA 2.0 compliance as a fundraising screening criterion.</li>
    <li><strong>Action 3 — Reassess Refinancing Timelines.</strong> Leveraged loan spreads have widened ~100 bps since January. Consider bank-led syndication as an alternative to private credit.</li>
  </ul>

  <h3>6. Coming This Week</h3>

  <table>
    <thead><tr><th>Date</th><th>Event</th><th>Significance</th></tr></thead>
    <tbody>
      <tr><td>Mon Mar 30</td><td>Fed Chair Powell speaks (10:30 AM ET)</td><td>First remarks since March FOMC hold</td></tr>
      <tr><td>Fri Apr 3</td><td>US NFP (March) — Good Friday</td><td>Consensus: +56K; released to closed markets</td></tr>
    </tbody>
  </table>
```

---

## Output File 2: Ticker Banner (`ticker/latest.yaml`)

Always overwrites `latest.yaml`. The file has **exactly 3 top-level YAML fields** and nothing else:

```yaml
---
date: "YYYY-MM-DD"
updated_at: "YYYY-MM-DDTHH:MM:SS-04:00"
items:
  - text: "..."
    category: "..."
```

**No other top-level fields.** No `equities`, `fixed_income`, `commodities`, `fx`, `volatility`, `alerts`, `separator`, or anything else.

Each item has exactly 2 fields:
- `text` — Under 80 chars. Contains metric name + value + direction symbol (▲/▼) + change.
- `category` — One of: `equity`, `rates`, `commodity`, `volatility`

### Complete Ticker Example

This is a real file from the website:

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

### What the website does with ticker items

```typescript
const tickerItems = ticker.items.map(i => i.text);
```

It extracts ONLY the `text` field from each item and displays them in a scrolling banner. The `category` field is used for styling. That's it.

---

## Output File 3: Sources (`sources.md`)

After writing the YAML files, write a `sources.md` file that logs every source used.

**Path:** `output/intelligence-data/sources.md`

```markdown
# Sources — Daily Brief YYYY-MM-DD

## Market Snapshot
- [Source name](URL) — what data was pulled (e.g., "US equities, VIX")

## Geopolitical & Macro
- [Source name](URL) — what was reported

## Regulatory & Ops Intel
- [Source name](URL) — what was reported

## Event Calendar
- [Source name](URL) — what events were found

## Notes
- Any data gaps, stale data, or blocked sources encountered
```

---

## Assembly Checklist

Before writing the files, verify:

- [ ] Daily brief YAML has EXACTLY 7 top-level fields: `title`, `date`, `author`, `status`, `summary`, `preview`, `full_content`
- [ ] NO other top-level fields exist (no `sections`, `subtitle`, `classification`, `footer`, `generated_at`, etc.)
- [ ] `preview` and `full_content` are YAML multiline strings (using `|`) containing HTML
- [ ] HTML uses `<h3>`, `<table>`, `<p>`, `<ul>`, `<li>`, `<strong>`, `<em>` — NOT markdown, NOT plain text
- [ ] `preview` contains sections 1-2 only
- [ ] `full_content` contains all 6 sections (1-6)
- [ ] Sections 1-2 appear identically in both `preview` and `full_content`
- [ ] `summary` is under 200 characters
- [ ] Numbers in Data Snapshot (section 4) match Market Snapshot (section 1)
- [ ] Both files start with `---` on line 1
- [ ] All `&` in HTML are escaped as `&amp;`
- [ ] Ticker YAML has EXACTLY 3 top-level fields: `date`, `updated_at`, `items`
- [ ] Ticker items have exactly 2 fields each: `text` and `category`
- [ ] Ticker has 4-6 items, each `text` under 80 characters
- [ ] No fabricated data — `N/A` for unavailable values
