#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_CONFIG="$SCRIPT_DIR/../configs/phpstan.neon"
PHPSTAN_BIN="$PROJECT_DIR/vendor/bin/phpstan"

if [ ! -x "$PHPSTAN_BIN" ]; then
  echo "vendor/bin/phpstan not found. Run 'composer install' first." >&2
  exit 1
fi

CONFIG_FILE="$DEFAULT_CONFIG"
if [ -f "$PROJECT_DIR/phpstan.neon" ]; then
  CONFIG_FILE="$PROJECT_DIR/phpstan.neon"
fi

TARGETS=()
for DIR in src tests; do
  if [ -d "$PROJECT_DIR/$DIR" ]; then
    TARGETS+=("$DIR")
  fi
done

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "⚠️  No src/ or tests/ directories found. Skipping PHPStan." >&2
  exit 0
fi

( cd "$PROJECT_DIR" && "$PHPSTAN_BIN" analyse --configuration="$CONFIG_FILE" "${TARGETS[@]}" )
