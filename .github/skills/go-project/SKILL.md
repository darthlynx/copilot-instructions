---
name: go-project
description: Use this skill when working in a Go repository for development, debugging, refactoring, testing, linting, code review, and CI validation.
---

# Go Project Skill

This skill is for working in Go repositories that use one or more of the following:
- `go.mod`
- `go.work`
- `cmd/`, `internal/`, or `pkg/`
- Docker Compose for local dependencies
- integration tests alongside unit tests
- CI checks driven by `make`, shell scripts, or plain `go` commands

## When to use this skill

Use this skill when:
- the repository contains `go.mod` or `go.work`
- the user asks to work on Go code
- the task involves debugging, refactoring, tests, code review, performance, concurrency, or CI failures
- the repository structure suggests a service, CLI, library, or monorepo with Go components

When the repository is Go, provide implementation and fixes in Go even if the user's broader default language preference is different.

## Goals

1. Prefer idiomatic Go.
2. Preserve correctness first, then improve readability and performance.
3. Keep changes minimal unless the user asks for broader refactoring.
4. Prefer repository conventions over generic style advice.
5. Prefer standard library solutions unless there is a clear reason not to.
6. Explain algorithmic time and space complexity when relevant.

## Initial repository checks

Before making changes: locate the module/work root (`go.mod`/`go.work`), inspect `README.md`, CI configs, and project `Makefile` if present. Prefer project-provided scripts (look under `scripts/`) and use `examples/expected-commands.md` for the canonical command list and preferred command order.

## Working rules

### Code style
- Use clear names.
- Keep functions focused.
- Return early when it improves readability.
- Handle errors explicitly.
- Avoid panic except for truly unrecoverable initialization scenarios.
- Do not overuse interfaces; define them where they are consumed.
- Prefer table-driven tests when appropriate.
- Prefer `context.Context` for request-scoped operations.
- Keep concurrency simple and safe.

### Performance
- Do not optimize blindly.
- Avoid needless allocations.
- Preallocate slices or maps when the size is known.
- Avoid converting between `string` and `[]byte` unnecessarily.
- Use benchmarks for non-trivial performance claims.
- Explain tradeoffs instead of making vague claims that code is faster.

### Testing
- Run the narrowest relevant tests first.
- Then run broader validation if needed.
- For bug fixes, add or update a test that would fail before the fix.
- For refactors, keep behavior unchanged unless the user asks otherwise.
- Separate unit-test validation from integration-test validation.

### Refactoring
When refactoring:
1. preserve public behavior
2. improve readability
3. reduce duplication
4. simplify control flow
5. keep package boundaries reasonable

Do not perform large architectural rewrites unless the user requests them.

## Preferred command order and commands

See `examples/expected-commands.md` for the preferred command order and common project commands. If the repository defines `make` targets as the canonical workflow, prefer them over ad-hoc commands.

## Docker Compose and local dependencies

If integration tests depend on local services:
- inspect `docker-compose.yml`, `compose.yaml`, or test helper scripts
- identify whether tests require Kafka, Postgres, Redis, LocalStack, or other containers
- avoid assuming integration tests are safe to run unless the repository explicitly supports them
- distinguish environment failures from code failures

## Review checklist

When reviewing Go code, check for:
- correctness
- edge cases
- nil handling
- slice bounds and indexing mistakes
- error wrapping and propagation
- race conditions
- goroutine leaks
- misuse of channels
- unnecessary interfaces
- poor package boundaries
- overly clever code
- missing tests
- incorrect complexity analysis

## Expected output style

When responding:
- explain the issue clearly
- propose the smallest reasonable fix first
- mention tradeoffs
- include time and space complexity for algorithms when relevant
- prefer concrete code over vague advice

## Additional resources

- `resources/repo-conventions.md`
- `resources/debugging-checklist.md`
- `resources/release-checklist.md`
- `examples/expected-commands.md`
- `examples/common-fixes.md`
- `overlays/work.md`
- `overlays/home.md`
