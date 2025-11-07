#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../configs/phpcs.xml"

if [ -f "$PROJECT_DIR/phpcs.xml" ]; then
  CONFIG_FILE="$PROJECT_DIR/phpcs.xml"
elif [ -f "$PROJECT_DIR/phpcs.xml.dist" ]; then
  CONFIG_FILE="$PROJECT_DIR/phpcs.xml.dist"
fi
PHPCS_BIN="$PROJECT_DIR/vendor/bin/phpcs"

if [ ! -x "$PHPCS_BIN" ]; then
  echo "vendor/bin/phpcs not found. Run 'composer install' first." >&2
  exit 1
fi

TARGETS=()
for DIR in src tests; do
  if [ -d "$PROJECT_DIR/$DIR" ]; then
    TARGETS+=("$PROJECT_DIR/$DIR")
  fi
done

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "⚠️  No src/ or tests/ directories found. Skipping PHP_CodeSniffer." >&2
  exit 0
fi

"$PHPCS_BIN" --standard="$CONFIG_FILE" "${TARGETS[@]}"
