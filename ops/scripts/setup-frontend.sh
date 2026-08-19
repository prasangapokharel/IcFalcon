#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FRONTEND="$ROOT/frontend"

cd "$FRONTEND"

npm install

if [[ ! -f postcss.config.mjs ]]; then
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
fi

if [[ ! -f components.json ]]; then
  npx shadcn@latest init --preset bbVJxYW -y
fi

npx shadcn@latest add --all -y

npm run build

echo "Frontend ready (Tailwind + shadcn + static export in out/)."
