#!/bin/sh
set -e
HOOK_DIR=".git/hooks"
if [ ! -d "$HOOK_DIR" ]; then
  echo "No .git directory found. Run this from project root after git init."
  exit 0
fi
mkdir -p "$HOOK_DIR"
cp scripts/pre-commit "$HOOK_DIR/pre-commit"
chmod +x "$HOOK_DIR/pre-commit"
echo "Pre-commit hook installed to $HOOK_DIR/pre-commit"
