#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BACKEND="${FALCON_BACKEND_DIR:-$ROOT/backend}"
FRONTEND="$ROOT/frontend"
export ROOT BACKEND FRONTEND FALCON_BACKEND_DIR="$BACKEND" FALCON_CANISTER="${FALCON_CANISTER:-app}"

# shellcheck source=lib/replica.sh
source "$ROOT/ops/scripts/lib/replica.sh"

deploy_local_canister() {
  cd "$BACKEND"
  if dfx canister id app --network local &>/dev/null; then
    dfx build app --network local
    dfx deploy app --mode=upgrade --network local
  else
    dfx deploy app --network local
  fi
}

write_frontend_env() {
  local id
  id="$(cd "$BACKEND" && dfx canister id app --network local)"
  cat > "$FRONTEND/.env.local" <<EOF
NEXT_PUBLIC_CANISTER_ID=$id
NEXT_PUBLIC_IC_HOST=http://127.0.0.1:4943
NEXT_PUBLIC_II_URL=http://rdmx6-jaaaa-aaaaa-aaadq-cai.localhost:4943
EOF
}

verify_local_ping() {
  cd "$BACKEND"
  dfx canister call app ping --query --network local | grep -q .
}
