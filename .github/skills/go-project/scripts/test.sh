#!/usr/bin/env bash
set -euo pipefail

echo "Running Go unit tests..."
go test ./...
