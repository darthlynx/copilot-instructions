#!/usr/bin/env bash
set -euo pipefail

echo "Checking for Crossplane files..."

find . -maxdepth 4 \( \
  -name "*.yaml" -o -name "*.yml" \
\) | xargs grep -lE "CompositeResourceDefinition|Composition|ProviderConfig|ClusterProviderConfig|Function|apiVersion: apiextensions.crossplane.io" 2>/dev/null || true
