#!/usr/bin/env bash
set -e

HOOK_DIR=".git/hooks"
HOOK_FILE="$HOOK_DIR/pre-commit"

cat_hook_block() {
  cat <<'HOOK'
# --- Voyager PHP Quality Tools Hook ---
echo "🚦 Running Voyager PHP Quality Tools..."
vendor/bin/quality-checks
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "❌ Quality checks failed (Voyager). Commit aborted."
  exit 1
fi
# --- End Voyager Hook ---
HOOK
}

echo ""
echo "🔧 Setting up Voyager PHP Quality Tools pre-commit hook..."
echo "---------------------------------------------------------"

if [ ! -d "$HOOK_DIR" ]; then
  echo "⚠️  No .git directory found. Please run this from your project root after 'git init'."
  exit 0
fi

mkdir -p "$HOOK_DIR"

if [ -f "$HOOK_FILE" ]; then
  if grep -q "Voyager PHP Quality Tools" "$HOOK_FILE"; then
    echo "ℹ️  Voyager hook already integrated. Nothing to do."
    exit 0
  fi

  BACKUP_FILE="${HOOK_FILE}.bak_$(date +%s)"
  echo "💾 Existing pre-commit hook found — backing up to $BACKUP_FILE"
  cp "$HOOK_FILE" "$BACKUP_FILE"

  echo "🔗 Appending Voyager quality check to existing hook..."
  {
    cat "$HOOK_FILE"
    cat_hook_block
  } > "${HOOK_FILE}.tmp"
  mv "${HOOK_FILE}.tmp" "$HOOK_FILE"
else
  echo "🆕 Creating new pre-commit hook..."
  {
    echo "#!/usr/bin/env bash"
    echo "set -e"
    cat_hook_block
  } > "$HOOK_FILE"
fi

chmod +x "$HOOK_FILE"

echo "✅ Voyager pre-commit hook installed or updated successfully."
echo "💡 Try committing to see automatic code quality checks!"
echo ""
