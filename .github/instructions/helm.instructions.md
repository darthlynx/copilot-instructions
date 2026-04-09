---
applyTo: "**/Chart.yaml,**/values.yaml,**/values-*.yaml,**/templates/**/*.yaml,**/templates/**/*.tpl"
---

# Helm Instructions

Write Helm charts that are reusable, readable, and safe to customize.

- Keep charts reusable and avoid hardcoded values.
- Everything environment-specific should be configurable through `values.yaml` or documented overrides.
- Provide sensible defaults that are safe for non-production use and explicit about production-sensitive settings.
- Keep templates simple. Prefer straightforward rendering over complex branching or deeply nested conditionals.
- Use helpers for repeated template fragments, naming logic, or labels, but do not hide essential behavior behind excessive indirection.
- Prefer standard Kubernetes labels, annotations, and naming conventions.
- Quote and default values carefully to avoid invalid manifests or surprising type coercion.
- Guard optional resources and fields cleanly so templates render valid YAML across supported value combinations.
- Document chart values with comments and keep values files easy to scan.
- Separate environment-specific overrides from the base chart configuration.
