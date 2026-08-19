#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
export FALCON_ROOT="$ROOT"
export FALCON_BACKEND_DIR="${FALCON_BACKEND_DIR:-$ROOT/backend}"

# shellcheck source=progress.sh
source "$ROOT/ops/scripts/progress.sh"

prog_header "Setup in progress"

cd "$FALCON_BACKEND_DIR"
prog_run "Installing backend packages" mops install
prog_run "Pinning Motoko toolchain" mops toolchain use moc 1.6.0

bash "$ROOT/ops/scripts/setup-frontend.sh"

# shellcheck source=setup-backend-local.sh
source "$ROOT/ops/scripts/setup-backend-local.sh"
export -f start_local_replica deploy_local_canister write_frontend_env verify_local_ping
prog_run "Starting local replica" start_local_replica
prog_run "Deploying canister locally" deploy_local_canister
prog_run "Wiring frontend env" write_frontend_env
prog_run "Verifying backend health" verify_local_ping

prog_success

cd "$ROOT/frontend"
exec npm run dev
