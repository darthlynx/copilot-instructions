#!/usr/bin/env bash
set -euo pipefail

bash ./scripts/fmt.sh
go build ./...
bash ./scripts/test.sh
bash ./scripts/integration-test.sh
bash ./scripts/lint.sh
