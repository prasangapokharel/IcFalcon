#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$HOME/.local/bin/falcon"
SOURCE="$ROOT/ops/falcon"

mkdir -p "$HOME/.local/bin"
ln -sf "$SOURCE" "$TARGET"
chmod +x "$SOURCE"

if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
  echo "Add to ~/.bashrc:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo "Installed: $TARGET -> $SOURCE"
echo ""
echo "Try:"
echo "  falcon help"
echo "  falcon b:test --local"
