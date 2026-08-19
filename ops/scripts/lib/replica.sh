#!/usr/bin/env bash

replica_api_url() {
  printf '%s' "http://127.0.0.1:4943"
}

replica_is_running() {
  dfx ping &>/dev/null
}

wait_for_replica() {
  local i=0
  while ! replica_is_running; do
    i=$((i + 1))
    [[ $i -ge 60 ]] && return 1
    sleep 1
  done
}

start_local_replica() {
  cd "${FALCON_BACKEND_DIR:?}"
  if replica_is_running; then
    return 0
  fi
  dfx start --background
  wait_for_replica
}

stop_local_replica() {
  cd "${FALCON_BACKEND_DIR:?}"
  if ! replica_is_running; then
    return 0
  fi
  dfx stop
}

replica_canister_id() {
  dfx canister id "${FALCON_CANISTER:-app}" --network local 2>/dev/null || true
}
