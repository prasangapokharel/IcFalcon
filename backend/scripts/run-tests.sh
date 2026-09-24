#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p .mops
mops install
MOC_BIN="$(mops toolchain bin moc 2>/dev/null || which moc || true)"
if [ -n "$MOC_BIN" ] && [ -f "$MOC_BIN" ]; then
  ln -sf "$MOC_BIN" .mops/moc-wrapper
fi
export PATH="$(pwd)/.mops:$PATH"

echo "==> unit tests (moc)"
SOURCES=$(mops sources)
MOC="${MOC:-$(pwd)/.mops/moc-wrapper}"
"$MOC" -r -Werror $SOURCES --package pkg pkg --package app src testing/TestRunner.mo

echo "==> dfx build app"
dfx build app

echo "==> all tests passed"
