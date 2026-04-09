---
name: crossplane-v2
description: Use this skill when working with Crossplane v2 APIs, namespaced composite resources, namespaced managed resources where supported, and Compositions without claims.
---

# Crossplane v2 Namespaced Skill

This skill is for repositories and platforms using Crossplane v2 with:
- namespaced XRs
- namespaced managed resources where supported
- Composition pipeline mode
- `function-patch-and-transform` by default
- no claims
- no legacy v1-style claim-based abstractions

## When to use this skill

Use this skill when:
- the task involves Crossplane v2 platform APIs
- the task mentions XRDs, XRs, Compositions, Functions, Providers, or managed resources
- the repository contains Crossplane YAML, package manifests, or composition functions
- the user wants help designing or reviewing internal platform abstractions on Crossplane v2

## Scope assumptions

This skill assumes:
1. Crossplane v2 only
2. namespaced resources first
3. no claims
4. pipeline mode by default
5. `function-patch-and-transform` by default
6. no v1 legacy patterns unless explicitly asked
7. one Composition per abstraction unless specified otherwise

Do not recommend legacy claim-based patterns unless the user explicitly asks for migration guidance.

## Core principles

1. Prefer namespaced XRs over legacy claim-based designs.
2. Do not introduce claims.
3. Prefer clear XRD schemas with tight validation.
4. Keep compositions small, explicit, and reviewable.
5. Prefer one Composition per abstraction.
6. Keep tenant and namespace boundaries explicit.
7. Minimize provider-specific leakage in the XR API.
8. Treat the XR as the platform contract and the Composition as the implementation.
9. Treat secret publishing and connection details as a deliberate contract choice.

## Initial checks

Before proposing changes:
1. Inspect Crossplane version and installed providers.
2. Inspect XRDs, Compositions, Functions, and provider configs.
3. Check whether the repository uses:
   - `Composition`
   - `CompositeResourceDefinition`
   - composition functions
   - `function-patch-and-transform`
   - namespaced `ProviderConfig`
   - package dependencies
4. Identify whether any resources still use:
   - legacy claim patterns
   - cluster-scoped assumptions
   - deprecated composition styles
   - provider fields exposed directly to platform consumers without abstraction

If scripts are available, use:
- `scripts/detect.sh`
- `scripts/validate.sh`

## Design rules

### XR and XRD design
- Design the XR API for platform consumers, not around provider CRDs.
- Keep field names business-oriented and stable.
- Expose only the minimum set of fields needed by consumers.
- Add schema validation wherever possible.
- Prefer enums, defaults, and required fields when they improve safety.
- Keep optional fields truly optional.

### Composition shape
Prefer one Composition per abstraction.

Default to:
- one XR contract
- one clear Composition implementing that contract
- one focused platform abstraction per boundary

Do not create broad multi-mode Compositions unless the user explicitly asks for that design.

When variation is needed, prefer:
- a separate Composition for a separate abstraction
- or an explicitly discussed exception

Avoid giant Compositions that combine unrelated concerns or expose provider-specific branching to platform consumers.

### Composition design
- Use pipeline mode by default.
- Use `function-patch-and-transform` by default unless the task clearly requires something else.
- Keep each Composition focused on one platform abstraction.
- Prefer explicit resource naming and patch flow.
- Be careful with cross-resource patching and readiness assumptions.
- Keep secrets and connection details deliberate and easy to trace.

### Namespacing
- Prefer namespaced resources wherever supported.
- Keep provider config and managed resource namespace behavior explicit.
- Avoid hidden cross-namespace coupling.
- Call out when a composed resource must be cluster-scoped.

### Provider configuration
- Prefer namespaced `ProviderConfig` by default.
- Always make `providerConfigRef` explicit.
- Do not rely on implicit defaults.
- Use `ClusterProviderConfig` only when shared credentials or provider behavior explicitly require a cluster-scoped configuration.
- When cluster scope is required, call it out clearly and keep the exception narrow.

### Provider usage
- Do not expose raw provider CRDs directly as the platform API.
- Keep provider-specific fields inside the Composition unless there is a strong reason not to.
- Prefer namespaced `ProviderConfig` when the provider supports it and the tenancy model benefits from it.

### Scope exceptions
Prefer namespaced resources and namespaced `ProviderConfig` by default.

When a provider or specific resource requires cluster scope:
- call that out explicitly
- explain why cluster scope is required
- keep the exception as narrow as possible
- do not normalize it into the default design
- separate the platform API from the cluster-scoped implementation detail

Do not discourage cluster-scoped resources on principle when they are genuinely required by the provider.
Do not hide the scope difference; make it visible in the recommendation and review notes.

### Secrets and connection details
- Treat secret publishing and connection details as part of the platform contract.
- Do not publish secrets automatically just because the provider can.
- Expose connection details only when they provide clear value to platform consumers.
- Make secret names, namespaces, and ownership explicit.
- Avoid broad or incidental secret fan-out.

### Backward compatibility
- Do not reintroduce claims.
- Do not recommend legacy v1 patterns unless the user explicitly asks for migration guidance.
- Call out when a suggested design depends on v1 compatibility mode rather than v2-native behavior.

## Validation and review

When reviewing Crossplane YAML, check for:
- v2-native design vs legacy carryover
- clear XR schema
- safe defaults
- namespace boundaries
- correct `compositeTypeRef`
- correct function pipeline wiring
- correct patches and transforms
- secret handling
- provider config references
- readiness and dependency ordering assumptions
- excessive provider leakage into the XR
- operational debuggability

## Troubleshooting approach

When troubleshooting:
1. Inspect the XR first.
2. Inspect composed resources next.
3. Inspect events with `kubectl describe`.
4. Verify function pipeline inputs and outputs.
5. Verify provider config references.
6. Check whether the issue is schema, patching, readiness, or provider reconciliation.

## Expected output style

When responding:
- prefer v2-native guidance
- explicitly avoid claims unless asked
- explain whether a recommendation is namespaced-only or requires cluster scope
- propose the smallest safe abstraction first
- separate platform API design from provider implementation details
- call out exceptions clearly when a provider/resource requires cluster scope

## Additional resources

- `resources/design-principles.md`
- `resources/composition-guidelines.md`
- `resources/review-checklist.md`
- `resources/troubleshooting.md`
- `examples/xrd-checklist.md`
- `examples/composition-checklist.md`
- `overlays/work.md`
- `overlays/home.md`
