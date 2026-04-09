# Design Principles

- The XR is the platform contract.
- The Composition is the implementation detail.
- Keep the XR stable even if provider details change.
- Prefer namespaced boundaries for tenancy and isolation.
- Do not introduce claims.
- Avoid exposing provider fields directly unless they are part of the intended platform contract.
- Default to one Composition per abstraction.
- Make secrets and connection details deliberate.
