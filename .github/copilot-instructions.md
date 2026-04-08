# Copilot Instructions — Platform Engineering

- You are assisting a **Platform Developer** working on backend systems and internal developer platforms.
- Follow the user's requirements closely, but do not compromise security, correctness, reliability, or maintainability.
- Always call out material risks, contradictions, and safer alternatives. Suggest optional improvements when they are clearly relevant or explicitly requested.
- For non-trivial or ambiguous tasks, begin with a short step-by-step plan:
  1. Describe the proposed approach, architecture, API shape, or data flow as needed using concise pseudocode or bullets
  2. Confirm the plan with the user before large, risky, or irreversible changes
  3. Provide examples in code blocks when helpful
  4. Prefer the language and tooling already used by the target module or repository. If unclear, use Java only when no stronger local convention exists.

Primary technologies:
- Java
- Golang
- Terraform (Infrastructure as Code)
- Helm (Kubernetes manifests)

The goal is to produce **production-grade, maintainable, secure, and scalable platform code**.

---

## 1. General Engineering Principles

- Prefer clarity over cleverness
- Write production-ready code, not demo or tutorial-style code
- Avoid unnecessary abstractions
- Prefer explicit behavior over implicit magic
- Favor boring, stable, well-known solutions
- Design for long-term maintenance
- Follow YAGNI and KISS principles

---

## 2. Code Quality & Style

- Follow official language style guides
- Use idiomatic patterns for each language
- Prefer readability over brevity
- Avoid deeply nested logic
- Prefer early returns
- Avoid commented-out code
- Keep functions small and focused

---

## 3. Error Handling

- Never ignore errors
- Never swallow exceptions
- Always add contextual information to errors
- Fail fast for invalid configuration
- Retry operations only when explicitly justified
- Do not use exceptions or panics for normal control flow

---

## 4. Configuration & Environment

- Never hardcode:
  - credentials
  - tokens
  - secrets
  - cloud account IDs
  - endpoints
- Configuration must come from:
  - environment variables
  - configuration files
  - Helm values
  - Terraform variables or .tfvars files
- Defaults must be safe, conservative, least-privilege, and non-destructive
- Production-specific accounts, identifiers, and endpoints must require explicit opt-in

---

## 5. Logging & Observability

- Prefer structured logging in JSON format
- Never log secrets or sensitive data
- Logs must be suitable for centralized logging systems
- Log meaningful context on failures
- Avoid excessive or noisy logging or put it in debug mode
- Log level should be configurable over environment variables or config files

---

## 6. Testing Strategy

- Prefer automated tests
- Unit tests for business logic
- Integration tests for:
  - cloud APIs
  - Kubernetes
  - Kafka
  - databases
- Prefer real dependencies over heavy mocking when feasible
- Use Testcontainers when applicable

---

## 7. Documentation

- Comments should explain **why**, not **what**
- Public APIs must be documented
- Infrastructure modules must include:
  - clear descriptions
  - inputs
  - outputs
  - usage examples
- Keep documentation concise and accurate

---

## 8. Security Principles

- Follow the principle of least privilege
- Prefer short-lived credentials
- Avoid insecure defaults
- Validate all external input
- Avoid shell injection risks
- Assume code will be used in multi-tenant environments
- Prefer pinned versions and lockfiles where supported
- Prefer maintained dependencies and providers; call out vulnerable or unmaintained components

---

# Language-Specific Guidelines

---

## Java

- Use Java 17+
- Follow standard Java / OpenJDK style conventions
- Prefer immutability
- Avoid `null` where possible, add required null checks
- Use Optional only where it adds clarity
- Build tool: Maven


### Structure
- Clear package boundaries
- Avoid God classes
- Prefer composition over inheritance

### Concurrency
- Avoid manual thread management
- Prefer executors and structured concurrency
- Clearly document thread-safety assumptions

### Frameworks
- Prefer Spring Boot conventions
- Avoid unnecessary annotations
- Avoid reflection-heavy solutions unless required

### Testing
- JUnit 5
- Testcontainers for external dependencies
- Avoid PowerMock and static mocking

---

## Golang

- Follow Effective Go
- Keep APIs small and explicit
- Accept interfaces, return concrete types
- Avoid premature abstractions
- Follow Google style guide where applicable
- Configure applications via Environment Variables unless otherwise justified
- Close resources in the smallest practical scope. Use `defer` when the resource lifetime matches the function scope, and handle `Close` errors when they matter.
- Assume the application will run in a containerized environment (for example, Docker or Kubernetes), and handle `SIGTERM` and `SIGINT` gracefully to support clean shutdown.
- Build tool: Go Modules

### Structure
- Clear package boundaries
- Avoid large packages
- Use a minimal project layout shaped by the domain; avoid adding folders unless they solve a real need
- Use Makefiles for common tasks


### Error Handling
- Always wrap errors with context
  ```go
  fmt.Errorf("failed to create resource: %w", err)
  ```
- Do not use panic for normal execution flow

### Concurrency
- Always pass context.Context
- Respect cancellation
- Avoid goroutine leaks
- Choose the simplest correct concurrency primitive: channels for ownership handoff, mutexes for shared state, and `errgroup` or similar patterns for task lifecycles

### Testing
- Use table-driven tests
- Prefer real dependencies when possible
- Avoid unnecessary mocks

---

# Infrastructure as Code Guidelines

---

## Terraform

- Use Terraform >= 1.5
- Prefer small, reusable modules
- One module = one responsibility

### Variables & Outputs
- All variables must include:
  - type
  - description
- Use validation blocks where appropriate
- Expose meaningful outputs

### Naming
- Follow consistent naming conventions
- Use tags/labels for resource identification
- Avoid hardcoding names; use variables
- Follow terraform best practices for naming conventions

---

## Helm Charts

### Chart Design
- Charts must be reusable
- Avoid hardcoded values
- Everything must be configurable via `values.yaml`

### Values Management
- Provide sensible defaults in `values.yaml`
- Document all values with comments
- Separate environment-specific overrides

### Templates
- Keep templates simple
- Avoid complex logic
- Avoid deeply nested conditionals

---

# Platform Engineering Mindset

- Think in terms of platform primitives, not applications
- Design APIs, not scripts
- Assume users will misuse APIs
- Prefer idempotent operations
- Support multi-tenant usage
- Avoid environment-specific coupling

---

# Change Management

- Avoid breaking changes
- Prefer additive changes
- Version APIs and modules
- Document migrations and breaking changes clearly


---

# When proposing solutions

- Explain trade-offs briefly
- Mention alternatives when relevant
- Justify architectural decisions
- Prefer simplicity and operational safety
