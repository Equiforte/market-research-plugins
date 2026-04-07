# Market Research Plugins

Mono-repo for Equiforte market research plugins. Each plugin generates structured intelligence content for [equiforte.com/intelligence](https://www.equiforte.com/intelligence).

## Plugins

| Plugin | Description | Status |
|--------|-------------|--------|
| [daily-brief](daily-brief/) | Daily market brief + ticker banner for PE CFOs | Active |

## Structure

```
market-research-plugins/
├── marketplace.json              # Plugin registry
└── daily-brief/                  # Daily brief plugin
    ├── .claude-plugin/
    │   └── plugin.json           # Plugin manifest
    ├── CLAUDE.md                 # Plugin-level instructions
    ├── commands/                 # Slash commands
    │   └── daily-brief.md
    ├── agents/                   # Autonomous agents
    │   └── brief-generator.md
    ├── skills/                   # Auto-activating skills
    │   ├── daily-brief/
    │   │   └── SKILL.md
    │   ├── market-snapshot/
    │   │   └── SKILL.md
    │   ├── geopolitical-monitor/
    │   │   └── SKILL.md
    │   ├── regulatory-ops-intel/
    │   │   └── SKILL.md
    │   ├── event-calendar/
    │   │   └── SKILL.md
    │   └── intelligence-content/
    │       └── SKILL.md
    └── hooks/                    # Event handlers
        ├── hooks.json
        └── scripts/
            └── post-generate.sh
```

## Usage

```bash
# Run the daily brief
/daily-brief

# With options
/daily-brief --date 2026-04-07 --focus pe
```

## Output

Each run produces 3 files in `output/`:
- `YYYY-MM-DD.yaml` — Daily brief (6 HTML sections, preview/gated split)
- `latest.yaml` — Ticker banner (4-6 scrolling items)
- `sources.md` — Source attribution
