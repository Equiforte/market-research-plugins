# Daily Brief Plugin

## Output Paths

- Staging: `./output/intelligence-data/`
- Website repo: `~/git/equiforte.com/src/content/intelligence-data/`

## Output Files

Each run produces exactly 2 files:
1. `daily-brief/YYYY-MM-DD.yaml` — Full daily brief (6 sections, preview/gated split)
2. `ticker/latest.yaml` — Ticker banner (4-6 scrolling items)

## CRITICAL Rules

- Every YAML file MUST begin with `---` on the very first line. No whitespace, comments, or blank lines before it. The website parser requires this.
- All content is HTML within YAML `preview` and `full_content` fields.
- Facts and sourced data only. No opinions, forecasts, or fabrication.
- `N/A` for unavailable data — never make up numbers.
- `full_content` MUST include all preview content plus additional gated sections.

## Constraints

- Total web operations per run: max 20 (WebSearch + WebFetch combined)
- Total runtime: max 5 minutes
- Business days only (Mon-Fri, skip US market holidays)

## Search Strategy

This plugin uses a tested hybrid of WebSearch + WebFetch. Key findings:
- `tradingeconomics.com` is the best structured market data source (WebFetch)
- `investing.com/economic-calendar/` is the only reliable way to get calendar data (WebFetch)
- Bloomberg, Reuters, CNBC, WSJ all block WebFetch — do not attempt
- Credit spreads are always the hardest data point — accept approximation
- Never combine unrelated topics in a single search query

## Data Sources

- Primary: WebSearch (financial news) + WebFetch (tradingeconomics.com, investing.com)
- MCP servers (when available): FactSet, Morningstar, S&P Global, MT Newswires, PitchBook

## Formatting

- Positive changes: `+1.23`, Negative: `-1.23`, Unchanged: `Unchanged`
- Rate changes always in basis points (bps)
- Billions: `$12.3B`, Millions: `$456.7M`
- All times in Eastern Time (ET)
- Ticker direction indicators: `▲` (up), `▼` (down)
