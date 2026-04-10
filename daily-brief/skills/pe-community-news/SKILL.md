---
name: pe-community-news
description: Monitor 9 PE industry organizations (ACG, SBIA, M&A Source, ILPA, NAIC, TMA, LSTA, ACC/AIMA, MFA) for important news — conferences, policy positions, research reports, leadership changes. Use when generating a daily brief or when the user asks about PE community updates, industry association news, or upcoming PE conferences.
---

# PE Community News Monitor

Scan 9 private equity industry organizations for noteworthy news. Only surface items that are genuinely important — skip routine announcements, minor blog posts, podcast episodes, and marketing content.

**Output feeds into existing daily brief sections** — this skill does NOT produce a new section. Items go into:
- **Regulatory Watch** ← policy positions, advocacy actions, regulatory comment letters
- **Operational Intel** ← research reports, industry surveys, new initiatives
- **Coming This Week** ← conferences, events, deadlines

## CRITICAL: Search Strategy (Tested & Verified)

You have a **budget of 6 steps** (5 WebFetch + 1 WebSearch).

All URLs below were live-tested. Tier classification reflects actual accessibility.

### Organizations by Priority

| Priority | Organization | Abbreviation | Focus |
|----------|-------------|-------------|-------|
| 1 | Association for Corporate Growth | ACG | Middle-market dealmaking, M&A, PE networking |
| 2 | Small Business Investor Alliance | SBIA | Lower middle market PE, SBIC programs |
| 3 | M&A Source | — | Lower middle market transactions, advisors |
| 4 | Institutional Limited Partners Association | ILPA | LP-GP relationships, templates, allocator base |
| 5 | National Association of Investment Companies | NAIC | Diverse-owned PE/credit managers |
| 6 | Turnaround Management Association | TMA | Distressed, special situations, turnarounds |
| 7 | Loan Syndications and Trading Association | LSTA | Leveraged finance, syndicated loans |
| 8 | Alternative Credit Council (AIMA) | ACC | Private credit, direct lending |
| 9 | Managed Funds Association | MFA | Broad alternatives — credit, hedge funds |

---

### Step 1 — ACG (WebFetch) — ALWAYS RUN
```
URL: https://www.acg.org/news
```
**Why this works:** Returns 10 most recent articles — sponsor announcements, M&A data reports (GF Data quarterly), DealMAX conference updates, industry awards, chapter events. No dates in listings but articles are sorted newest-first.

**What to look for:** GF Data M&A reports, DealMAX or other conference announcements, new partnerships, industry awards, sector-specific forum recaps (aerospace, healthcare, etc.)

### Step 2 — ILPA (WebFetch) — ALWAYS RUN
```
URL: https://ilpa.org/news-insights/ilpa-updates/
```
**Why this works:** Returns 10 articles with exact dates (MM/DD/YYYY). Covers continuation fund templates, policy statements (401k alternatives, SEC), faculty announcements, industry reports.

**What to look for:** New templates or template refreshes, policy statements on regulation, industry reports (impact investing, PE performance), ILPA Institute updates.

**DEDUP RULE:** Skip ILPA Reporting Template/DDQ updates — those are already covered by `regulatory-ops-intel` step 3. Only report ILPA events, policy positions, and non-template news here.

### Step 3 — SBIA (WebFetch sitemap) — ALWAYS RUN
```
URL: https://sbia.org/post-sitemap.xml
```
**Why this works:** The actual SBIA news pages are JS-rendered and return empty content via WebFetch. However, the sitemap XML returns all post URLs with `<lastmod>` dates. Headlines are extractable from URL slugs (e.g., `/sbia-backs-senate-introduction-of-small-business-investor-capital-access-act/`).

**What to look for:** SBIC legislation (INVEST Act, Capital Access Act), SBIC leverage pricing announcements, board elections, award recipients, policy advocacy. SBIA publishes infrequently (~1-2 posts per month) so most items are significant.

### Step 4 — MFA (WebFetch) — CONDITIONAL
```
URL: https://www.mfaalts.org/news
```
**When to run:** Always run unless budget is tight — MFA publishes high-quality policy positions.

**Why this works:** Returns 10 articles with exact dates. Covers SEC/FCA/IRS advocacy, amicus briefs, UK securitisation reforms, FSOC commentary, 401(k) access proposals.

**What to look for:** Regulatory advocacy (SEC cost-benefit analysis, FCA reporting reform), tax policy positions (IRS proposals), cross-border regulatory commentary (UK, Abu Dhabi), FSOC reform statements.

### Step 5 — TMA (WebFetch) — CONDITIONAL
```
URL: https://www.turnaround.org/news
```
**When to run:** Run if budget allows or if distressed/turnaround activity is elevated. Skip if budget is tight and no distressed news in other phases.

**Why this works:** Returns 10 articles with exact dates. Covers Distressed Investing Conference, Turnaround Tourney, leadership appointments, thought leadership calls, chapter events.

**What to look for:** Conference announcements (DIC, Annual Conference), CEO/leadership changes, award recipients, industry partnership announcements. TMA publishes ~1-2 posts per month.

### Step 6 — Blocked/Partial Sites (WebSearch batch) — CONDITIONAL
```
"M&A Source" OR "LSTA loan syndication" OR "NAIC diverse managers" OR "AIMA alternative credit council" news
```
**When to run:** Run if budget allows. This is the lowest-priority step.

**Why this works:** Batch WebSearch picks up press coverage and announcements from the 4 orgs whose sites block WebFetch. Returns third-party coverage from trade publications and wire services.

**Covers:**
- **M&A Source** (`masource.org` — 403 on all pages): Lower middle market transaction community events
- **LSTA** (`lsta.org` — 403 on all pages): Loan market conferences, regulatory positions
- **NAIC** (`naicpe.com` — JS-rendered, homepage only): Diverse manager events (Spring Fling, NextGen Symposium), PE performance studies
- **ACC/AIMA** (`acc.aima.org` — homepage only, sub-pages 404): Private credit investor forums, CLO model advocacy, regulatory material

## CONFIRMED BLOCKED/FAILED URLs — Do Not Attempt

| URL | Status | Notes |
|-----|--------|-------|
| `masource.org/*` | 403 | All pages including sitemap blocked |
| `lsta.org/*` | 403 | All pages including sitemap blocked |
| `naicpe.com/news-insights/` | JS-rendered | Returns 0-1 items, dynamic loading |
| `acc.aima.org/press-office.html` | 404 | Sub-pages don't exist |
| `acc.aima.org/regulation.html` | No articles | Only staff roster, no news links |
| `aima.org/news.html` | 404 | AIMA news pages not found |
| `aima.org/sitemap.xml` | 404 | No sitemap available |
| `sbia.org/news/` | JS-rendered | Page loads empty, use sitemap instead |
| `sbia.org/resources/` | 404 | Page not found |

## Importance Filter — What to Report

**INCLUDE (genuinely newsworthy):**
- Major conferences announced or upcoming (with dates, locations, registration deadlines)
- New research reports or industry surveys (PE performance, M&A data, market studies)
- Policy positions, advocacy actions, or regulatory comment letters filed
- Leadership changes (CEO appointments, board elections)
- Significant new initiatives or partnerships
- Legislative support/advocacy (SBIC legislation, 401k access, FSOC reform)

**SKIP (routine/low-signal):**
- Sponsor announcements ("Firm X becomes Official Sponsor of Growth")
- Podcast episodes (unless featuring a major policy announcement)
- Minor blog posts or thought leadership articles
- Marketing content, membership drives
- Faculty/speaker announcements (unless keynote at major event)
- Award recipients (unless industry-wide significance)

## Deduplication with Other Skills

| Content Type | Owned By | NOT in pe-community-news |
|-------------|----------|--------------------------|
| ILPA Reporting Templates / DDQ updates | regulatory-ops-intel | Skip — covered by regulatory-ops-intel step 3 |
| SEC/CFTC regulatory actions | regulatory-ops-intel | Skip — even if MFA or ILPA comments on them |
| General PE market commentary | geopolitical-monitor | Skip — only report org-specific news |
| Economic data / central bank actions | geopolitical-monitor | Skip — not relevant to org monitoring |

| Content Type | Owned By pe-community-news | NOT in other skills |
|-------------|---------------------------|---------------------|
| ILPA events, policy statements, non-template news | pe-community-news | Do not duplicate in regulatory-ops-intel |
| ACG/SBIA/TMA conference announcements | pe-community-news | Do not duplicate in event-calendar |
| MFA/ACC advocacy positions on regulation | pe-community-news | Do not duplicate in regulatory-ops-intel |

## Output Format

Report items grouped by destination section. Each item as:

**For Regulatory Watch:**
```html
<p><strong>[ORG] — Headline</strong> — Description with specific policy position, affected regulation, and date filed.</p>
```

**For Operational Intel:**
```html
<p><strong>[ORG] — Headline</strong> — Description with key findings, publication date, and relevance to PE CFOs.</p>
```

**For Coming This Week:**
Add rows to the event calendar table:
```html
<tr><td>Date</td><td>[ORG] Event Name — Location</td><td>Significance description</td></tr>
```

- 0-3 items total per day (most days will have 0-1 items — these orgs publish infrequently)
- If no significant news from any organization, state "No significant PE community developments"
- Always attribute: `[ACG]`, `[SBIA]`, `[ILPA]`, `[TMA]`, `[MFA]`, etc.
