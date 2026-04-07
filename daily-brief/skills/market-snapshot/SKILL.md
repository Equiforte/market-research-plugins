---
name: market-snapshot
description: Gather global equity indices, treasury yields, credit spreads, commodities, FX, and volatility data. Uses a tested hybrid of WebSearch + WebFetch for maximum data coverage. Use when generating a daily brief or when the user asks about market data, indices, rates, or asset prices.
---

# Market Snapshot

Compile a comprehensive market data snapshot covering all major asset classes. All data as of latest available.

## CRITICAL: Search Strategy (Tested & Optimized)

You have a **budget of 6 steps maximum** (2-3 WebSearch + 3 WebFetch).

The strategy below was dry-tested and verified to produce structured, actionable data. Follow this exact sequence.

### Step 1 — WebSearch: Broad market catch-all
```
"market summary today equities bonds commodities currencies"
```
**Why this works:** Best single catch-all query tested. Returns 5+ asset classes with actual numbers — equities, bonds, commodities, FX, crypto. Also picks up VIX and narrative context.

### Step 2 — WebFetch: Structured equities + VIX
```
https://tradingeconomics.com/united-states/stock-market
```
**Why this works:** Returns structured data for S&P 500, Dow, Nasdaq, Russell 2000, VIX, plus some commodities/FX. Clean numerical format with levels, changes, and percentages. Best structured data source tested.

### Step 3 — WebFetch: Complete commodities
```
https://tradingeconomics.com/commodities
```
**Why this works:** Returns 18+ commodities across energy (WTI, Brent, natgas), metals (gold, silver, copper), and agriculture — all with prices, daily changes, and percentages. Far superior to any WebSearch approach for commodities.

### Step 4 — WebFetch: Complete FX
```
https://tradingeconomics.com/currencies
```
**Why this works:** Returns 13+ currency pairs including DXY, EUR/USD, USD/JPY, GBP/USD, plus crypto. Best FX source tested.

### Step 5 — WebSearch: Treasury yield curve
```
"US treasury yields today 2 year 10 year 30 year"
```
**Why this works:** Essential — broad searches and tradingeconomics only return the 10Y yield. This dedicated search gets the full curve (2Y, 5Y, 10Y, 30Y). Always returns clean numbers.

### Step 6 — WebSearch: Credit spreads (conditional)
```
"credit spreads high yield OAS basis points"
```
**Why this works:** Credit spread data is the hardest to get — results are often lagged 1-2 days. This is the only way to get HY OAS, IG OAS, and leveraged loan index data. Accept approximation and note the data date.

**Skip step 6 if** the broad search in step 1 already returned credit spread data.

## BLOCKED SOURCES — Do Not Attempt

These sites block WebFetch (403/paywall). Do not waste steps on them:
- `cnbc.com/markets`
- `wsj.com/market-data`
- `bloomberg.com/*`
- `fred.stlouisfed.org`
- `finance.yahoo.com/markets` (returns stock movers, not summary data)

## What to Collect

### U.S. Equity Indices
| Index | Level | Change | % Change |
S&P 500, Dow Jones, Nasdaq Composite, Russell 2000

### Global Equity Indices
| Index | Level | Change | % Change |
Nikkei 225, Euro Stoxx 600, FTSE 100, DAX, Hang Seng, Shanghai Composite, ASX 200 — include whatever step 1 returns.

### U.S. Treasury Yields
| Tenor | Yield | Change (bps) |
2-Year, 5-Year, 10-Year, 30-Year, Fed Funds Rate

### Credit Spreads
| Metric | Level | Change |
IG OAS, HY OAS (ICE BofA), S&P/LSTA Leveraged Loan Index, CLO AAA Spreads

### Commodities
| Commodity | Price | Change |
WTI Crude, Brent Crude, Gold (spot + futures), Silver, Natural Gas

### FX & Digital Assets
| Pair | Level | Change |
EUR/USD, DXY, USD/JPY, GBP/USD, BTC/USD

### Volatility
| Index | Level | Change | % Change |
VIX

## Output Format

Organize into HTML tables grouped by asset class. Include a 1-2 sentence narrative summary after each table highlighting the most significant move or theme.

- Use `N/A` for any data point not returned by searches
- Positive: `+1.23`, Negative: `-1.23`
- Rate changes always in bps
- Note data staleness if credit spread data is >1 day old
