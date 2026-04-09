#!/usr/bin/env bash
set -euo pipefail

if command -v crossplane >/dev/null 2>&1; then
  echo "Crossplane CLI detected."
  echo "Use Crossplane CLI validation against your XRD, Composition, and provider schemas as needed."
else
  echo "Crossplane CLI not installed."
fi

if command -v kubectl >/dev/null 2>&1; then
  echo "kubectl detected."
else
  echo "kubectl not installed."
fi
