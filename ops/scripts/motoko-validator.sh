#!/usr/bin/env bash
# Motoko Code Validator & Linter (IcFalcon Standard)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/code/motoko/validate-code.sh" "$@"
