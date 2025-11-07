#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(pwd)"
CONFIG_DIR="$SCRIPT_DIR/../configs"
DETECT_BIN="$PROJECT_DIR/vendor/bin/detect-secrets"

echo ""
echo "🚀 Running Voyager PHP Quality Checks"
echo "===================================="

echo "📂 Project directory: $PROJECT_DIR"
echo "🧰 Toolkit directory: $CONFIG_DIR"
echo ""

# PHP_CodeSniffer
if [ -x "$PROJECT_DIR/vendor/bin/phpcs" ]; then
  echo "🔹 Running PHP_CodeSniffer..."
  bash "$SCRIPT_DIR/run-phpcs.sh"
  echo ""
else
  echo "⚠️  vendor/bin/phpcs not found — did you run 'composer install'?" >&2
  exit 1
fi

# PHPStan
if [ -x "$PROJECT_DIR/vendor/bin/phpstan" ]; then
  echo "🔹 Running PHPStan..."
  bash "$SCRIPT_DIR/run-phpstan.sh"
  echo ""
else
  echo "⚠️  vendor/bin/phpstan not found — did you run 'composer install'?" >&2
  exit 1
fi

# GrumPHP
if [ -x "$PROJECT_DIR/vendor/bin/grumphp" ]; then
  echo "🔹 Running GrumPHP..."
  "$PROJECT_DIR/vendor/bin/grumphp" run
  echo ""
else
  echo "⚠️  vendor/bin/grumphp not found — did you run 'composer install'?" >&2
  exit 1
fi

# detect-secrets
if [ -x "$DETECT_BIN" ]; then
  echo "🔹 Running detect-secrets..."
  bash "$SCRIPT_DIR/run-detect-secrets.sh"
  echo ""
else
  echo "⚠️  detect-secrets is not installed. Ensure Python 3 is available and run 'composer install'." >&2
  exit 1
fi

echo "✅ All quality checks completed!"
echo "------------------------------------"
