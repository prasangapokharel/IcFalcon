#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# shellcheck source=progress.sh
source "$ROOT/ops/scripts/progress.sh"
# shellcheck source=lib/replica.sh
source "$ROOT/ops/scripts/lib/replica.sh"

export FALCON_BACKEND_DIR="${FALCON_BACKEND_DIR:-$ROOT/backend}"

cd "$FALCON_BACKEND_DIR"

if ! replica_is_running; then
  prog_ok "Local replica already stopped"
  exit 0
fi

prog_run "Stopping local replica" dfx stop
prog_ok "Local replica stopped"
