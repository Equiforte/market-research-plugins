---
name: event-calendar
description: Compile upcoming financial events, economic releases, earnings, conferences, central bank meetings, and deal milestones. Use when generating a daily brief or when the user asks about upcoming events, the economic calendar, or conference schedules.
---

# Event Calendar

Compile a forward-looking calendar of scheduled events relevant to financial professionals. All dates/times in Eastern Time (ET).

## CRITICAL: Search Strategy (Tested & Optimized)

You have a **budget of 4-5 steps** (2-3 WebSearch + 1-2 WebFetch).

**Key finding from testing:** WebSearch alone **fails** for calendar data — it returns links to aggregator sites but not actual event data. WebFetch of specific aggregator URLs is **essential** and must be run first.

### Step 1 — WebFetch: Economic calendar (ESSENTIAL — always run first)
```
https://investing.com/economic-calendar/
```
**Why this works:** This is the **only method tested that returns actual structured calendar data** — country, time, event name, importance level. Returns multi-day, multi-country events in a scannable format. All other approaches (WebSearch for "economic calendar") return links to aggregators, not the data itself.

### Step 2 — WebSearch: Central bank meeting schedule
```
"central bank meeting schedule [current year] Fed ECB BoE BoJ"
```
**Why this works:** Returns complete meeting date schedules for all 4 major central banks in structured date lists. Published for the full year — one search covers everything.

**Replace `[current year]` with the actual year.**

### Step 3 — WebSearch: Earnings calendar
```
"earnings calendar this week major companies reporting"
```
**Why this works:** Returns partial inline data (headline company names, EPS estimates) plus links to aggregators like Nasdaq and Yahoo Finance. Gets the key names.

**Optional supplement:** If step 3 returns insufficient inline data, use a WebFetch of `https://www.nasdaq.com/market-activity/earnings` as an additional step.

### Step 4 — WebSearch: Conferences & events
```
"investor conferences financial events [current month] [current year]"
```
**Why this works:** Returns real conference names, dates, and locations across industry verticals (healthcare, PE/VC, CLO, M&A). Mix of industry-specific and bank-hosted events.

**Replace `[current month]` and `[current year]` with actuals.**

### Step 5 — WebSearch: IPO calendar (OPTIONAL, separate query)
```
"IPO calendar upcoming [current month] [current year]"
```
**When to run:** Only if budget allows. Run as a **separate** query from Treasury auctions.

**CRITICAL: Never combine IPO and Treasury auction topics in one query.** This was tested and the combined query fails — Treasury dominates and no IPO data returns.

For Treasury auctions, search separately:
```
"Treasury auction schedule [current month] [current year]"
```

## CONFIRMED DUDS — Do Not Use

- `"economic calendar this week next week US Europe"` — returns links only, zero inline event data
- `"economic calendar today upcoming data releases"` — fully redundant with above, zero inline data
- `"IPO calendar upcoming Treasury auction schedule"` — combined query fails; always split these

## What to Collect

### Economic Calendar (This Week + Next Week)

**High-importance only** — do not list every minor release:
- US: NFP, CPI, PPI, PCE, GDP, FOMC, retail sales, ISM, jobless claims
- Europe: ECB decision, Eurozone CPI, GDP, PMIs
- UK: BoE decision, CPI, PMIs
- China: PBoC, CPI, PMIs, trade balance
- Japan: BoJ, CPI, Tankan

Format:
| Date | Time (ET) | Country | Indicator | Period | Prior | Consensus |

### Central Bank Calendar

| Bank | Next Meeting | Rate Decision Expected |

Cover: FOMC, ECB, BoE, BoJ, PBoC, RBA, BoC. Others only if returned by search.

### Earnings Calendar

**This week and next week only.** Focus on:
- S&P 500 constituents
- Sector bellwethers
- Do not list companies with market cap below $10B unless sector-relevant

Format:
| Date | Time | Company | Ticker | EPS Est | Rev Est |

### Conferences & Events (Next 4 Weeks)

Only list events found in a single search. Do not search for individual conference organizers.

| Dates | Event | Location | Key Sectors |

### IPO & Issuance Calendar

- Upcoming IPOs (if found)
- US Treasury auction schedule for the week
- Notable IG/HY issuance expected

### Options/Index Dates

Only mention if this week or next includes: monthly/quarterly options expiry, index rebalancing (Russell, MSCI, S&P), or triple/quad witching.

## Output Format

**This week**: Day-by-day with all categories merged per day.
**Next week**: Grouped by category, dates noted.

- `[TBD]` for tentative dates
- `N/A` for unavailable consensus
- Never fabricate dates or estimates
