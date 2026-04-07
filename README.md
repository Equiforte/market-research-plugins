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
└── daily-brief/                  # Daily brief plugin (self-contained)
    ├── plugin.json
    ├── CLAUDE.md
    ├── skills/                   # Research + assembly skills
    ├── commands/                 # Slash commands
    ├── agents/                   # Autonomous agents
    ├── hooks/                    # Post-generation hooks
    └── shared/                   # Schemas + templates
        ├── schemas/
        └── templates/
```

## Usage

```bash
# Run the daily brief
/daily-brief

# With options
/daily-brief --date 2026-04-07 --focus pe
```

## Output

Each run produces 2 YAML files committed to the `equiforte.com` website repo:
- `src/content/intelligence-data/daily-brief/YYYY-MM-DD.yaml`
- `src/content/intelligence-data/ticker/latest.yaml`
