---
name: geopolitical-monitor
description: Monitor and compile geopolitical and macroeconomic developments relevant to financial markets. Use when generating a daily brief or when the user asks about geopolitical risks, macro developments, central bank actions, or market-moving events.
---

# Geopolitical & Macro Monitor

Compile today's geopolitical and macroeconomic developments relevant to financial markets. Report only confirmed facts with sources. No speculation.

## CRITICAL: Search Strategy (Tested & Optimized)

You have a **budget of 5 WebSearches maximum**.

The strategy below was dry-tested and verified. Each query targets a distinct category with minimal overlap.

### Step 1 — Broad catch-all (ALWAYS run first)
```
"major financial news today market moving developments"
```
**Why this works:** Best catch-all tested. Returns the broadest mix — geopolitical, energy, corporate, macro commentary — with actual numbers and names. Anchors the entire scan. Use this to decide whether step 4 is needed.

### Step 2 — Central bank actions & commentary
```
"central bank decisions speeches today Fed ECB BoE BoJ"
```
**Why this works:** Only reliable source for rate decision details, basis point changes, specific policy language, and upcoming meeting dates. Tight, structured, highly actionable.

**Note:** This query also captures Fed speeches and commentary — no need for a separate "Fed speech today Powell" search (tested and confirmed redundant).

### Step 3 — Geopolitical & trade policy
```
"geopolitical developments today tariffs trade policy sanctions markets"
```
**Why this works:** Trade/fiscal policy actions, tariff changes, sanctions, geopolitical risk events. Returns rich analytical content with tariff rates, GDP impact estimates, and specific timelines.

### Step 4 — Energy & commodity supply (CONDITIONAL)
```
"OPEC oil supply energy commodity developments today"
```
**When to run:** Only if step 1 or step 3 surfaces energy-related developments (price spikes, supply disruptions, OPEC decisions, geopolitical events affecting energy flows). Otherwise skip.

**Why this works:** Best energy-specific search — production quotas, supply disruptions, barrel prices with high precision. Numbers-rich and actionable.

### Step 5 — Economic data releases
```
"economic data releases today CPI GDP PMI jobless claims"
```
**Why this works:** Captures data release calendar and actual vs. consensus results. Essential for the "Data Snapshot" section. Returns dates, figures, and surprise indicators.

## CONFIRMED DUDS — Do Not Use

These were tested and returned redundant or low-value results:
- `"market moving news today breaking financial"` — nearly identical to step 1
- `"Reuters top financial news today"` — overlaps with step 1, adds ~1 unique item
- `"trade policy tariffs today executive orders"` — overlaps with step 3, too backward-looking
- `"major M&A deals announced today corporate news"` — low signal; step 1 catches major deals
- `"Fed speech today Powell central bank commentary"` — redundant with step 2

## What to Report

### Central Bank & Monetary Policy (from Step 2)
- Rate decisions, speeches, minutes releases from today only
- Include direct quotes for key policy language
- **Do not** separately search for minor central banks (SNB, Riksbank, Norges, etc.) — include only if returned

### Economic Data Releases (from Step 5)
For each release:
| Time (ET) | Country | Indicator | Period | Actual | Prior | Consensus | Surprise |

### Fiscal & Trade Policy (from Step 3)
- Only report confirmed actions: executive orders, tariff changes, sanctions, legislation passed
- State what happened, when, and which sectors/assets are directly affected
- **DO NOT** report SEC/CFTC/FCA regulatory actions here — those belong in regulatory-ops-intel

### Geopolitical Events (from Steps 1, 3)
- Only report developments confirmed by official sources or multiple credible outlets
- **Scope limit**: Only include if there is a clear, direct financial market impact (commodity prices, trade flows, sanctions, currency). Skip general political news.

### Corporate & Deal Activity (from Step 1)
- M&A announcements >$1B
- Major defaults, restructurings, or rating changes
- IPO pricings
- CEO departures at S&P 500 companies

## Output Format

Organize into sections. Each item:

```
**[TIME ET] [HEADLINE]**
[1-2 sentence factual description]. Source: [source name].
```

- If a section has no developments, state "No significant developments"
- Do not omit sections
- `[BREAKING]` only if within last 2 hours
