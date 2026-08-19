#!/usr/bin/env bash

if [[ -t 1 && "${FALCON_PROGRESS:-1}" != "0" ]]; then
  PROG_GREEN=$'\033[0;32m'
  PROG_CYAN=$'\033[0;36m'
  PROG_DIM=$'\033[2m'
  PROG_RED=$'\033[0;31m'
  PROG_NC=$'\033[0m'
  PROG_LIVE=true
else
  PROG_GREEN=''
  PROG_CYAN=''
  PROG_DIM=''
  PROG_RED=''
  PROG_NC=''
  PROG_LIVE=false
fi

prog_header() {
  printf '\n%s%s%s\n' "$PROG_CYAN" "$1" "$PROG_NC"
}

prog_ok() {
  printf '  %s %s\n' "${PROG_GREEN}✓${PROG_NC}" "$1"
}

prog_info() {
  printf '    %s%-10s%s %s\n' "$PROG_DIM" "$1" "$PROG_NC" "$2"
}

prog_fail() {
  printf '  %s %s\n' "${PROG_RED}✗${PROG_NC}" "$1" >&2
}

prog_run() {
  local label="$1"
  shift
  local log
  log="$(mktemp "${TMPDIR:-/tmp}/falcon-prog.XXXXXX")"

  if $PROG_LIVE; then
    printf '  %s' "$label"
    "$@" >"$log" 2>&1 &
    local pid=$!
    local i=0
    local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 "$pid" 2>/dev/null; do
      local frame="${frames:i:1}"
      printf '\r  %s %s' "$frame" "$label"
      i=$(((i + 1) % 10))
      sleep 0.08
    done
    wait "$pid"
    local code=$?
    if [[ $code -eq 0 ]]; then
      printf '\r  %s %s\n' "${PROG_GREEN}✓${PROG_NC}" "$label"
    else
      printf '\r  %s %s\n' "${PROG_RED}✗${PROG_NC}" "$label" >&2
      cat "$log" >&2
      rm -f "$log"
      return "$code"
    fi
  else
    printf '  %s ...\n' "$label"
    if "$@" >"$log" 2>&1; then
      printf '  %s %s\n' "${PROG_GREEN}✓${PROG_NC}" "$label"
    else
      printf '  %s %s\n' "${PROG_RED}✗${PROG_NC}" "$label" >&2
      cat "$log" >&2
      rm -f "$log"
      return 1
    fi
  fi

  rm -f "$log"
}

prog_success() {
  printf '\n%s┌─────────────────────────────────────┐%s\n' "$PROG_GREEN" "$PROG_NC"
  printf '%s│  ✓  Setup complete                  │%s\n' "$PROG_GREEN" "$PROG_NC"
  printf '%s└─────────────────────────────────────┘%s\n\n' "$PROG_GREEN" "$PROG_NC"
  printf '%s  Backend%s      online (local)\n' "$PROG_DIM" "$PROG_NC"
  printf '%s  Frontend%s     ready\n' "$PROG_DIM" "$PROG_NC"
  printf '%s  Toolchain%s    Motoko 1.6.0\n' "$PROG_DIM" "$PROG_NC"
  printf '%s  Dev server%s    http://localhost:3000\n' "$PROG_DIM" "$PROG_NC"
  printf '\n%sStarting dev server...%s\n' "$PROG_DIM" "$PROG_NC"
}
