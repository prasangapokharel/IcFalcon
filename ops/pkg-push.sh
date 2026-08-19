#!/usr/bin/env bash
set -euo pipefail

ROOT="${FALCON_ROOT:?}"
PKG_DIR="${FALCON_BACKEND_DIR}/pkg"
LOCK_FILE="${FALCON_BACKEND_DIR}/icp.pkg"
HUB_DIR="${ICP_HUB_DIR:-$ROOT/hub}"

fail() { echo "error: $1" >&2; exit 1; }

NAME="${1:-}"
[[ -n "$NAME" ]] || fail "usage: falcon pkg:push <local-pkg-folder>"

SRC=""
if [[ -d "$PKG_DIR/$NAME" ]]; then
  SRC="$PKG_DIR/$NAME"
elif [[ -d "$PKG_DIR/${NAME%%/*}" && -f "$PKG_DIR/${NAME%%/*}/${NAME##*/}.mo" ]]; then
  SRC="$PKG_DIR/${NAME%%/*}"
  NAME="${NAME%%/*}"
else
  fail "local package not found: backend/pkg/$NAME"
fi

DEST="$HUB_DIR/packages/$NAME"
mkdir -p "$DEST"

echo "==> push $NAME to hub/"
cp "$SRC"/*.mo "$DEST/" 2>/dev/null || fail "no .mo files in $SRC"

if [[ ! -f "$DEST/icp.pkg.yaml" ]]; then
  MO_FILE="$(ls "$DEST"/*.mo | head -1 | xargs basename)"
  cat > "$DEST/icp.pkg.yaml" <<EOF
name: $NAME
version: 1.0.0
maintainer: prasangapokharel
install: pkg/$NAME
files:
  - $MO_FILE
EOF
fi

echo "  + $DEST"
echo ""
echo "Next: commit hub/ and push to github.com/prasangapokharel/icp-hub"
echo "  cd hub && git add . && git commit -m \"add pkg $NAME\" && git push"
