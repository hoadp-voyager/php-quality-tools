#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(pwd)"
DETECT_BIN="$PROJECT_DIR/vendor/bin/detect-secrets"

if [ ! -x "$DETECT_BIN" ]; then
  echo "detect-secrets wrapper not found at vendor/bin/detect-secrets. Run 'composer install' to set it up." >&2
  exit 1
fi

if [ -f "$PROJECT_DIR/.secrets.baseline" ]; then
  "$DETECT_BIN" scan --all-files --baseline "$PROJECT_DIR/.secrets.baseline" --fail-on-secrets
else
  echo "ℹ️  No .secrets.baseline found. Running full scan without baseline." >&2
  echo "    Generate one with 'vendor/bin/detect-secrets scan --all-files > .secrets.baseline' and commit it." >&2
  "$DETECT_BIN" scan --all-files --fail-on-secrets
fi
