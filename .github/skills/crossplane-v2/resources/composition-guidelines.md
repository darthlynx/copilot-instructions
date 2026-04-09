# Composition Guidelines

- Prefer one clear abstraction per Composition.
- Use pipeline mode for modern Composition design.
- Use `function-patch-and-transform` by default.
- Keep patching readable and easy to trace.
- Avoid overloading one Composition with too many modes or provider-specific switches.
- Make secret and connection detail behavior explicit.
- Document any cluster-scoped exceptions clearly.
- Keep provider details behind the platform abstraction.
