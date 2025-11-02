#!/bin/bash
HOOKS_DIR=.git/hooks
mkdir -p $HOOKS_DIR
cp scripts/pre-commit $HOOKS_DIR/pre-commit
chmod +x $HOOKS_DIR/pre-commit
echo "Pre-commit hook installed."
