#!/usr/bin/env bash
set -euo pipefail

echo "Checking Go repository layout..."

if [[ -f "go.mod" ]]; then
  echo "Found go.mod in current directory."
else
  ROOT="$(find .. -maxdepth 3 -name go.mod 2>/dev/null | head -n 1 || true)"
  if [[ -n "${ROOT}" ]]; then
    echo "Found module file near current directory: ${ROOT}"
  else
    echo "No go.mod found nearby."
  fi
fi

[[ -f "go.work" ]] && echo "Found go.work"
[[ -f "Makefile" ]] && echo "Found Makefile"
[[ -f ".golangci.yml" || -f ".golangci.yaml" ]] && echo "Found golangci-lint config"
[[ -d "cmd" ]] && echo "Found cmd/"
[[ -d "internal" ]] && echo "Found internal/"
[[ -d "pkg" ]] && echo "Found pkg/"
[[ -f "docker-compose.yml" || -f "compose.yaml" ]] && echo "Found Docker Compose config"
