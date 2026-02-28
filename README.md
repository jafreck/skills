# skills

Personal [Claude Code](https://code.claude.com) skills library — version-controlled and auto-synced to `~/.claude`.

## Setup

```bash
git clone <this-repo> ~/Source/skills
cd ~/Source/skills
./install-hooks.sh   # auto-sync on every commit/pull/branch switch
```

After the initial sync, skills are available in every project you open in Claude Code.

## Skills

| Skill | Description |
|---|---|
| `/live-monitor` | Poll a log file for new lines while a named process is running |
| `/run-cadre` | Run cadre against a config file (defaults to `~/.cadre`) |

## How it works

- All skills live in `.claude/skills/<name>/SKILL.md`
- `install-hooks.sh` installs git hooks (`post-commit`, `post-merge`, `post-checkout`) that sync `.claude/` → `~/.claude/` automatically
- Skills in `~/.claude/skills/` are available in **all** Claude Code projects, not just this repo

## Adding a skill

```bash
mkdir .claude/skills/my-skill
cat > .claude/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: What it does and when to use it.
---

Instructions for Claude go here.
EOF
git add .claude/skills/my-skill
git commit -m "Add my-skill"   # syncs automatically via git hook
```

## Files

```
.claude/
  skills/
    live-monitor/SKILL.md
    run-cadre/SKILL.md
install-hooks.sh    # run once after cloning
```

## Related

- [Agent Skills spec](https://agentskills.io/specification)
- [Claude Code skills docs](https://code.claude.com/docs/en/skills)
