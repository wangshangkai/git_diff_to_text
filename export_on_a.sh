#!/bin/sh
set -eu

OUT="${1:-staged.patch}"

git diff --cached --binary --full-index > "$OUT"

if [ ! -s "$OUT" ]; then
  echo "[WARN] No staged changes." >&2
fi

echo "Patch written to: $OUT"
echo "Changed files:"
git diff --cached --name-status
