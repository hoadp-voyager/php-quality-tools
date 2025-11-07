#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(pwd)"
DETECT_BIN="$PROJECT_DIR/vendor/bin/detect-secrets"
BASELINE_FILE="$PROJECT_DIR/.secrets.baseline"

if [ ! -x "$DETECT_BIN" ]; then
  echo "detect-secrets wrapper not found at vendor/bin/detect-secrets. Run 'composer install' to set it up." >&2
  exit 1
fi

SCAN_ARGS=(scan --all-files)

if [ -f "$BASELINE_FILE" ]; then
  SCAN_ARGS+=(--baseline "$BASELINE_FILE")
else
  echo "ℹ️  No .secrets.baseline found. Running full scan without baseline." >&2
  echo "    Generate one with 'vendor/bin/detect-secrets scan --all-files > .secrets.baseline' and commit it." >&2
fi

if "$DETECT_BIN" scan --help 2>&1 | grep -q "--fail-on-secrets"; then
  "$DETECT_BIN" "${SCAN_ARGS[@]}" --fail-on-secrets
  exit $?
fi

set +e
JSON_OUTPUT="$("$DETECT_BIN" "${SCAN_ARGS[@]}" --json 2>&1)"
STATUS=$?
set -e

if [ $STATUS -ne 0 ]; then
  echo "$JSON_OUTPUT"
  exit $STATUS
fi

echo "$JSON_OUTPUT" | php -r '
$input = stream_get_contents(STDIN);
$data = json_decode($input, true);

if (!is_array($data)) {
    fwrite(STDERR, "Failed to decode detect-secrets output.\n");
    exit(2);
}

$results = $data["results"] ?? [];
$hasFindings = false;

foreach ($results as $file => $findings) {
    if (empty($findings)) {
        continue;
    }

    $hasFindings = true;
    fwrite(STDERR, "❌ Potential secrets detected in {$file}:\n");

    foreach ($findings as $finding) {
        $line = $finding["line_number"] ?? "?";
        $type = $finding["type"] ?? "unknown";
        $secret = $finding["hashed_secret"] ?? "(hash unavailable)";
        fwrite(STDERR, sprintf("    • line %s [%s] hash=%s\n", $line, $type, $secret));
    }
}

if ($hasFindings) {
    exit(1);
}

echo "✅ No secrets detected." . PHP_EOL;
exit(0);
'
