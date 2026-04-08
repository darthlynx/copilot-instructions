#!/usr/bin/env bash
set -euo pipefail

if [[ -f "docker-compose.yml" || -f "compose.yaml" ]]; then
  echo "Docker Compose file detected."
fi

echo "Run integration tests using the repository's standard command."
echo "Examples: make integration-test, go test -tags=integration ./..., or a dedicated script."
