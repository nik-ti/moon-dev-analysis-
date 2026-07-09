#!/usr/bin/env bash
# Creates the algo-trading workspace folder structure described in
# 03-workspace-setup.md. Run this once, from wherever you want the
# workspace to live, e.g.:
#   bash setup-workspace.sh ~/Documents/Projects/algo-trading

set -euo pipefail

TARGET="${1:-algo-trading}"

if [ -e "$TARGET" ]; then
  echo "Error: $TARGET already exists. Choose a new path or remove it first." >&2
  exit 1
fi

mkdir -p "$TARGET"/{research,lib,backtests,bots,docs}
touch "$TARGET/research/graveyard.md"
echo "# Graveyard — killed ideas and why" > "$TARGET/research/graveyard.md"

touch "$TARGET/docs/strategies-live.md"
echo "# Currently incubating / scaled strategies" > "$TARGET/docs/strategies-live.md"

cat > "$TARGET/.gitignore" <<'EOF'
.env
.venv/
__pycache__/
*.pyc
.DS_Store
EOF

touch "$TARGET/.env"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
fi
if [ -f "$SCRIPT_DIR/.env.example" ]; then
  cp "$SCRIPT_DIR/.env.example" "$TARGET/.env.example"
fi

echo "Workspace created at: $TARGET"
echo "Next steps:"
echo "  cd $TARGET"
echo "  python3 -m venv .venv && source .venv/bin/activate"
echo "  pip install backtesting pandas numpy python-dotenv requests"
echo "  git init && git add -A && git commit -m 'init algo-trading workspace'"
