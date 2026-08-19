#!/usr/bin/env bash
set -euo pipefail

cd "${FALCON_BACKEND_DIR:-backend}"
mops install
mops toolchain use moc 1.6.0
echo "Toolchain ready."
