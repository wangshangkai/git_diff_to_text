#!/bin/sh
set -eu

PATCH="${1:-staged.patch}"

if [ ! -f "$PATCH" ]; then
  echo "[ERROR] Patch file not found: $PATCH" >&2
  exit 1
fi

git apply --check "$PATCH"
git apply "$PATCH"
echo "Applied: $PATCH"
