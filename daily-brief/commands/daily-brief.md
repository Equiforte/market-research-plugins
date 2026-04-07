---
name: daily-brief
description: Generate today's daily market brief and ticker for equiforte.com/intelligence. Produces 2 YAML files — a daily brief with 6 sections and a ticker banner with key data points.
arguments:
  - name: date
    description: "Date for the briefing (YYYY-MM-DD). Defaults to today."
    required: false
  - name: focus
    description: "Focus area: 'pe' (private equity), 'pd' (private debt/credit), 'hf' (hedge funds), 'ib' (investment banking), or 'all' (default)."
    required: false
---

Run the `daily-brief` skill with the provided arguments.

- Date: **{{ date | default: "today" }}**
- Focus: **{{ focus | default: "all" }}**

Execute the full daily-brief skill workflow — market-snapshot, geopolitical-monitor, regulatory-ops-intel, event-calendar, then intelligence-content assembly.

Output files will be written to `./output/intelligence-data/`.
