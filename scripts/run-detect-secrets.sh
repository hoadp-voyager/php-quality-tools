#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(pwd)"
DETECT_BIN="$PROJECT_DIR/vendor/bin/detect-secrets"
FAIL_FLAG=""

if [ ! -x "$DETECT_BIN" ]; then
  echo "detect-secrets wrapper not found at vendor/bin/detect-secrets. Run 'composer install' to set it up." >&2
  exit 1
fi

if HELP_TEXT="$("$DETECT_BIN" scan --help 2>&1)"; then
  if printf '%s' "$HELP_TEXT" | grep -q -- '--fail-on-all'; then
    FAIL_FLAG="--fail-on-all"
  elif printf '%s' "$HELP_TEXT" | grep -q -- '--fail-on-secrets'; then
    FAIL_FLAG="--fail-on-secrets"
  else
    echo "⚠️  Installed detect-secrets version does not support automatic failure flags; scans may not fail on findings." >&2
  fi
else
  echo "Failed to determine detect-secrets capabilities." >&2
  exit 1
fi

EXTRA_ARGS=()

if [ -n "$FAIL_FLAG" ]; then
  EXTRA_ARGS=("$FAIL_FLAG")
fi

if [ -f "$PROJECT_DIR/.secrets.baseline" ]; then
  "$DETECT_BIN" scan --all-files --baseline "$PROJECT_DIR/.secrets.baseline" "${EXTRA_ARGS[@]}"
else
  echo "ℹ️  No .secrets.baseline found. Running scan without baseline." >&2
  echo "    Generate one with 'vendor/bin/detect-secrets scan --all-files > .secrets.baseline' and commit it." >&2
  "$DETECT_BIN" scan --all-files "${EXTRA_ARGS[@]}"
fi

if [ -n "$FAIL_FLAG" ]; then
  SCAN_ARGS+=("$FAIL_FLAG")
fi

"$DETECT_BIN" "${SCAN_ARGS[@]}" "${STAGED_FILES[@]}"
