#!/usr/bin/env bash
set -euo pipefail

ROOT="${FALCON_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/..}"
HUB_URL="${ICP_HUB_URL:-https://raw.githubusercontent.com/prasangapokharel/icp-hub/main}"
PKG_DIR="${FALCON_BACKEND_DIR}/pkg"
LOCK_FILE="${FALCON_BACKEND_DIR}/icp.pkg"

# shellcheck source=progress.sh
source "$ROOT/ops/scripts/progress.sh"

fail() { prog_fail "$1"; exit 1; }

fetch_index() {
  curl -fsSL "$HUB_URL/index.json"
}

pkg_field() {
  local pkg="$1"
  local field="$2"
  fetch_index | python3 -c "
import json, sys
data = json.load(sys.stdin)
pkg = data.get('packages', {}).get('$pkg')
if not pkg:
    sys.exit(1)
print(pkg.get('$field', ''))
" 2>/dev/null
}

list_packages() {
  fetch_index | python3 -c "
import json, sys
data = json.load(sys.stdin)
for name, meta in sorted(data.get('packages', {}).items()):
    print(f\"{name:16} {meta.get('version','?'):8} {meta.get('description','')}\")
"
}

list_installed() {
  [[ -f "$LOCK_FILE" ]] || { echo "No packages installed (icp.pkg missing)"; exit 0; }
  python3 -c "
import json
with open('$LOCK_FILE') as f:
    data = json.load(f)
for name, meta in sorted(data.get('packages', {}).items()):
    print(f\"{name:16} {meta.get('version','?'):8} {meta.get('source','')}\")
"
}

install_package() {
  local name="$1"
  [[ -n "$name" ]] || fail "usage: falcon add pkg <name>"

  local version path
  version="$(pkg_field "$name" version)" || fail "package not found in hub: $name"
  path="$(pkg_field "$name" path)" || fail "package path missing: $name"

  local base="$HUB_URL/$path"

  do_install() {
    local manifest
    manifest="$(curl -fsSL "$base/icp.pkg.yaml")"

    local install_path
    install_path="$(echo "$manifest" | grep '^install:' | sed 's/install: *//')"
    [[ -n "$install_path" ]] || install_path="pkg/$name"

    local dest="${PKG_DIR}/${install_path#pkg/}"
    mkdir -p "$dest"

    echo "$manifest" | grep '^  - ' | sed 's/^  - //' | while read -r file; do
      curl -fsSL "$base/$file" -o "$dest/$file" 2>&1
    done

    python3 -c "
import json, os
from datetime import datetime, timezone
lock = {'registry': 'github.com/prasangapokharel/icp-hub', 'packages': {}}
if os.path.exists('$LOCK_FILE'):
    with open('$LOCK_FILE') as f:
        lock = json.load(f)
lock['packages']['$name'] = {
    'version': '$version',
    'path': '$install_path',
    'source': '$path',
    'installed': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
}
with open('$LOCK_FILE', 'w') as f:
    json.dump(lock, f, indent=2)
    f.write('\n')
" 2>&1
  }

  prog_run "$name@$version" do_install
}

case "${1:-}" in
  list) list_packages ;;
  installed) list_installed ;;
  "") fail "usage: falcon add pkg <name>" ;;
  *) install_package "$1" ;;
esac
