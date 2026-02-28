# skills

These are mine, but you can have them.

Auto-synced to `~/.claude` on commit/checkout/pull.

## Setup

```bash
git clone <this-repo> ~/Source/skills
cd ~/Source/skills
./install-hooks.sh   # auto-sync on every commit/pull/branch switch
```

## Skills

| Skill | Description |
|---|---|
| `/adr-writer` | Draft Architecture Decision Records (ADRs) from project context |
| `/algorithm-visualization-web` | Build a lightweight web visualization for an algorithm with playback controls |
| `/architecture-diagram-generator` | Generate architecture diagrams using Mermaid (optional C4-style) |
| `/changelog-from-commits` | Generate changelog sections from commit history |
| `/docs-sync` | Check docs against repo behavior and produce an outdated-docs report |
| `/git-commit-format` | Enforce commit subject format: `type(scope): summary (#issue)` |
| `/live-monitor` | Poll a log file for new lines while a named process is running |
| `/mermaid-dependency-graph` | Generate Mermaid dependency graphs for modules/services/systems |
| `/mermaid-request-flow-chart` | Generate Mermaid request flow charts |
| `/mermaid-sequence-request-chart` | Generate Mermaid sequence diagrams for request lifecycles |
| `/run-cadre` | Run cadre against a config file (defaults to `~/.cadre`) |


## Adding a skill

```bash
mkdir .claude/skills/my-skill
cat > .claude/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: What it does and when to use it.
---

Instructions for Claude go here.
```

## Related

- [Agent Skills spec](https://agentskills.io/specification)
- [Claude Code skills docs](https://code.claude.com/docs/en/skills)
