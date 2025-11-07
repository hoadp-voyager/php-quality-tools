#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/../bin"
VENV_DIR="$BIN_DIR/detect-secrets-venv"
PYTHON=""

if [ -x "$VENV_DIR/bin/detect-secrets" ]; then
  exit 0
fi

if command -v python3 >/dev/null 2>&1; then
  PYTHON="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON="python"
else
  echo "⚠️  Python is not available. Skipping detect-secrets installation." >&2
  echo "    Install Python 3 and re-run 'composer install' to enable secret scanning." >&2
  exit 0
fi

"$PYTHON" -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel >/dev/null
"$VENV_DIR/bin/pip" install --upgrade detect-secrets >/dev/null

echo "✅ detect-secrets installed in $VENV_DIR"
