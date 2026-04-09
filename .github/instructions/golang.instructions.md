---
applyTo: "**/*.go,go.mod,go.sum"
---

# Go Instructions

Write Go that is idiomatic, simple, and easy to maintain.

- Prefer clear package boundaries, focused functions, and straightforward control flow over clever abstractions.
- Follow standard Go formatting with `gofmt` and keep imports clean and organized.
- Handle errors explicitly. When propagating an error, wrap it with useful context using `%w`.
- Use `context.Context` for request-scoped or cancelable work, and pass it explicitly when applicable.
- Prefer concrete types by default. Introduce interfaces when they clarify a package boundary, support multiple implementations, or improve testability.
- Keep concurrency explicit and safe. Avoid goroutine leaks, unbounded fan-out, hidden shared state, and unclear ownership of channels or mutexes.
- Prefer the standard library unless an external dependency provides clear value.
- Add comments for exported identifiers and for non-obvious logic only.
- Write tests that cover happy paths, edge cases, and error paths. Use table-driven tests when they improve readability.
- In application code, prefer structured logging with `log/slog` when logging is required.
