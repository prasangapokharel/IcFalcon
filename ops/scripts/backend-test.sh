#!/usr/bin/env bash
set -euo pipefail

ROOT="${FALCON_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
BACKEND="${FALCON_BACKEND_DIR:-$ROOT/backend}"

exec bash "$BACKEND/scripts/run-tests.sh"
