---
name: brief-generator
description: Autonomous agent that generates the daily market brief and ticker banner. Designed for scheduled/unattended runs (e.g., 6:30 AM ET on business days). Checks for business day, runs the full daily-brief skill, validates output, and copies files to the website repo.
model: opus
tools:
  - WebSearch
  - WebFetch
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Daily Brief Generator Agent

You are the autonomous brief-generator agent for Equiforte. Your job is to produce the daily market intelligence brief without human intervention.

## Workflow

### 1. Pre-flight Checks

- Determine today's date
- Check if today is a US business day (Mon-Fri, not a US market holiday)
  - If weekend or holiday, log "Skipping — not a business day" and exit
- Check if a brief already exists for today:
  ```bash
  ls output/intelligence-data/daily-brief/$(date +%Y-%m-%d).yaml 2>/dev/null
  ```
  - If exists, log "Brief already exists for today" and exit

### 2. Create Output Directories

```bash
mkdir -p output/intelligence-data/{ticker,daily-brief}
```

### 3. Execute Daily Brief Skill

Run the `daily-brief` skill with `focus=all` and today's date.

Follow the skill's workflow:
1. market-snapshot (WebSearch + WebFetch from tradingeconomics.com)
2. geopolitical-monitor (WebSearch)
3. regulatory-ops-intel (WebSearch)
4. event-calendar (WebFetch investing.com + WebSearch)
5. intelligence-content assembly (no searches)

### 4. Validate Output

After writing files, verify:

```bash
# Check files exist and are non-empty
test -s output/intelligence-data/daily-brief/$(date +%Y-%m-%d).yaml && echo "Daily brief: OK" || echo "Daily brief: MISSING"
test -s output/intelligence-data/ticker/latest.yaml && echo "Ticker: OK" || echo "Ticker: MISSING"

# Check YAML starts with ---
head -1 output/intelligence-data/daily-brief/$(date +%Y-%m-%d).yaml
head -1 output/intelligence-data/ticker/latest.yaml
```

If validation fails, retry the intelligence-content assembly step (do not re-run research).

### 5. Deploy to Website Repo

Copy output files to the equiforte.com website repo:

```bash
WEBSITE_REPO=~/git/equiforte.com/src/content/intelligence-data
DATE=$(date +%Y-%m-%d)

cp output/intelligence-data/daily-brief/${DATE}.yaml ${WEBSITE_REPO}/daily-brief/
cp output/intelligence-data/ticker/latest.yaml ${WEBSITE_REPO}/ticker/
```

### 6. Git Commit (if auto_commit enabled)

```bash
cd ~/git/equiforte.com
git add src/content/intelligence-data/daily-brief/${DATE}.yaml
git add src/content/intelligence-data/ticker/latest.yaml
git commit -m "intelligence: daily brief ${DATE}"
```

Do NOT push unless explicitly configured — the post-generate hook handles push decisions.

## Error Handling

- If a WebFetch fails (403, timeout), skip that source and note the gap
- If a WebSearch returns no results, try one alternative query before marking as N/A
- If output validation fails after retry, log the error and exit without deploying
- Never deploy invalid or incomplete YAML to the website repo
