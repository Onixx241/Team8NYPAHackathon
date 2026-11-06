#!/usr/bin/env bash
# Starts the React + Vite frontend dev server (http://localhost:5173).
# Usage: ./run_frontend.sh
set -euo pipefail

cd "$(dirname "$0")/frontend"

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm not found. Install Node.js (https://nodejs.org) and try again." >&2
  exit 1
fi

if [ ! -d node_modules ] || [ package.json -nt node_modules ] || [ package-lock.json -nt node_modules ]; then
  echo "Installing dependencies..."
  npm install
fi

echo "Starting frontend at http://localhost:5173 (Ctrl+C to stop)"
exec npm run dev -- "$@"
