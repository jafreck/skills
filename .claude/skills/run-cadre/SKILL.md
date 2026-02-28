---
name: run-cadre
description: Run cadre with a given config file. Use when the user asks to run cadre, execute cadre, or apply a cadre config. Cadre lives in the git repo root's parent directory.
---

# Run cadre

Run cadre from the repo root's parent directory, pointed at a config file.

## Usage

The config path is passed as an argument. If no argument is given, default to `~/.cadre`.

## Steps

1. Find the git repo root:
   ```bash
   REPO_ROOT=$(git rev-parse --show-toplevel)
   ```

2. Set the cadre binary path (lives in the repo root's parent):
   ```bash
   CADRE="$REPO_ROOT/../cadre"
   ```

3. Resolve the config path. Use `$ARGUMENTS` if provided, otherwise default to `~/.cadre`:
   ```bash
   CONFIG="${ARGUMENTS:-~/.cadre}"
   ```

4. Run cadre:
   ```bash
   "$CADRE" "$CONFIG"
   ```

If cadre is not found at `$REPO_ROOT/../cadre`, check one level up or ask the user to confirm the path.
