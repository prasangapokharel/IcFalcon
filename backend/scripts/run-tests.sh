#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mops install

echo "==> unit tests (moc)"
SOURCES=$(mops sources)
MOC="$(pwd)/.mops/moc-wrapper"
"$MOC" -r -Werror $SOURCES --package pkg pkg --package app src testing/TestRunner.mo

echo "==> dfx build app"
dfx build app

echo "==> all tests passed"
