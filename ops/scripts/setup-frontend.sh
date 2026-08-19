#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FRONTEND="$ROOT/frontend"

# shellcheck source=progress.sh
source "$ROOT/ops/scripts/progress.sh"

setup_postcss() {
  npm install -D tailwindcss @tailwindcss/postcss postcss
  cat > postcss.config.mjs <<'EOF'
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
}

export default config
EOF
}

cd "$FRONTEND"

prog_run "Installing frontend packages" npm install

if [[ ! -f postcss.config.mjs ]]; then
  prog_run "Configuring PostCSS + Tailwind" setup_postcss
fi

if [[ ! -f components.json ]]; then
  prog_run "Initializing shadcn/ui" npx shadcn@latest init --preset bbVJxYW -y
fi

prog_run "Installing shadcn components" npx shadcn@latest add --all -y
prog_run "Building frontend" npm run build
