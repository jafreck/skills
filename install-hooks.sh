#!/usr/bin/env bash
# Install git hooks that auto-sync .claude/ to ~/.claude after git operations
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$REPO_DIR/.git/hooks"

for hook in post-merge post-checkout post-commit; do
  cat > "$HOOKS_DIR/$hook" <<EOF
#!/usr/bin/env bash
rsync --archive "$REPO_DIR/.claude/" "\$HOME/.claude/"
EOF
  chmod +x "$HOOKS_DIR/$hook"
  echo "Installed $hook"
done

echo "Done. Skills will auto-sync to ~/.claude on commit, pull, and branch switch."
