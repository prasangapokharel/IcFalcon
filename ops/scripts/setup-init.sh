#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

cd "${FALCON_BACKEND_DIR:-$ROOT/backend}"
mops install
mops toolchain use moc 1.6.0

bash "$ROOT/ops/scripts/setup-frontend.sh"

echo ""
echo "Setup complete."
echo "  falcon r:start --local"
echo "  falcon b:deploy --local"
echo ""
echo "Open the deployed frontend URL (no dev server required)."
