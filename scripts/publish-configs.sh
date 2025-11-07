#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$(pwd)"

if [ "$PROJECT_DIR" = "$TOOLKIT_DIR" ]; then
  exit 0
fi

copy_if_missing() {
  local source_path="$1"
  local target_path="$2"

  if [ -e "$target_path" ]; then
    return
  fi

  mkdir -p "$(dirname "$target_path")"
  cp "$source_path" "$target_path"
  echo "📄 Published $(basename "$target_path")"
}

copy_if_missing "$TOOLKIT_DIR/.php-cs-fixer.dist.php" "$PROJECT_DIR/.php-cs-fixer.dist.php"
copy_if_missing "$TOOLKIT_DIR/configs/grumphp.yml" "$PROJECT_DIR/grumphp.yml"
