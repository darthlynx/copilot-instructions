#!/usr/bin/env bash
set -euo pipefail

if command -v golangci-lint >/dev/null 2>&1; then
  echo "Running golangci-lint..."
  golangci-lint run
else
  echo "golangci-lint is not installed; skipping."
fi
