---
name: regulatory-ops-intel
description: Compile SEC/CFTC/EU regulatory actions, fund administration technology news, ILPA updates, and operational developments relevant to PE CFOs. Use when generating a daily brief or when the user asks about regulatory changes, fund admin, compliance deadlines, or operational developments.
---

# Regulatory & Operational Intel

Compile regulatory actions and operational developments relevant to PE/credit fund CFOs. Focus on actionable items with specific deadlines and affected parties.

## CRITICAL: Search Strategy (Tested & Optimized)

You have a **budget of 4 WebSearches** (optional 5th for EU/FCA coverage).

These queries were dry-tested. WebSearch works well for regulatory content — law firm blogs and agency press releases surface effectively.

### Step 1 — SEC enforcement & rulemaking
```
"SEC regulatory actions today private funds investment advisers"
```
**Why this works:** Strong results from law firm blogs (Kirkland, Proskauer, Ropes & Gray) and SEC.gov press releases. Returns enforcement actions, proposed/final rules, comment period openings, and compliance deadlines.

### Step 2 — CFTC regulatory news
```
"CFTC regulatory news today derivatives funds"
```
**Why this works:** Clean CFTC-specific results — no-action letters, pilot programs, enforcement actions. Focused on derivatives/fund regulation without noise from other agencies.

### Step 3 — ILPA updates (HIGHEST SIGNAL SEARCH)
```
"ILPA reporting templates updates [current year]"
```
**Why this works:** This was the **single best search across all skills tested**. Returns highly specific, structured, actionable data — template features, implementation timelines, specific dates. Sources include BDO, MGO, Gen II, Katten, and ILPA itself.

**Replace `[current year]` with the actual year (e.g., 2026).**

### Step 4 — Fund admin & PE operations
```
"fund admin technology PE CFO operational news"
```
**Why this works:** Returns PE operational content — CFO surveys, co-sourcing trends, vendor changes, technology adoption. Key source: `privatefundscfo.com` is high-signal for this category.

### Step 5 — Multi-jurisdiction sweep (OPTIONAL)
```
"financial regulation news today SEC CFTC EU FCA"
```
**When to run:** Only when EU or UK regulatory activity is expected (AIFMD updates, SFDR changes, FCA actions). Otherwise skip to save budget.

**Why this works:** Broad multi-jurisdiction sweep that captures EU DORA, FCA actions, and cross-border regulatory coordination. Risk: too broad = shallow depth on any one topic.

## CONFIRMED DUDS — Do Not Use

- `"private equity fund administration technology news"` — returns vendor marketing pages, low news signal
- `"SEC CFTC regulatory actions private equity hedge funds today"` — redundant with steps 1+2, less depth than either

## What to Report

### Regulatory Actions
For each item, include:
- **Agency** (SEC, CFTC, EU/ESMA, FCA)
- **Action type** (proposed rule, final rule, no-action letter, enforcement, guidance)
- **Affected parties** (fund type, size threshold, registration status)
- **Key dates** (effective date, comment period deadline, compliance deadline)
- **Required action** for a PE CFO

Focus areas:
- Proposed/final rules affecting fund managers
- Comment period openings and deadlines
- Enforcement actions relevant to PE/credit
- Tax law changes (carried interest, SALT, international tax treaties)
- State-level regulatory changes (blue sky, ESG disclosure mandates)

### ILPA & Industry Standards
- Template updates and adoption deadlines
- DDQ template changes
- Best practice guidance updates
- LP expectations and benchmarking criteria

### Operational Developments
- Fund admin platform changes (Allvue, eFront, Burgiss, Investran, iLevel)
- PE tech M&A and product launches
- Audit/accounting standard changes (ASC 820, GAAP/IFRS updates)
- Cybersecurity incidents affecting fund services
- Insurance market changes (D&O, cyber, E&O)
- Outsourcing trends (NAV calculation, tax compliance, ESG reporting)

## Output Format

Each item as:
```html
<p><strong>Headline</strong> — Description with affected parties, dates, and required actions.</p>
```

- 2-4 regulatory items per day
- 2-3 operational items per day
- If no significant news in a category, state "No significant developments"
- Include specific deadlines and effective dates
- Actionable — each item should answer: "What should a CFO do about this?"
