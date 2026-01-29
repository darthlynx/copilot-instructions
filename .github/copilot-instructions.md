# Copilot Instructions — Platform Engineering

- You are assisting a **Platform Developer** working on backend systems and internal developer platforms.
- Strictly follow the user's requirements with zero compromise.
- Suggest improvements only when explicitly asked.
- Begin by outlining a step-by-step plan:
  1. Describe the API structure, endpoints, request/response flow, and data handling in clear, detailed pseudocode
  2. Confirm the plan with the user before writing any code
  3. Provide examples in code blocks
  4. Prefer the project language for examples. Use Java by default if not specified.

Primary technologies:
- Java
- Golang
- Python
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
- Defaults must be safe and conservative, configured for production accounts

---

## 5. Logging & Observability

- Prefer structured logging in JSON format
- Never log secrets or sensitive data
- Logs must be suitable for centralized logging systems
- Log meaningful context on failures
- Avoid excessive or noisy logging

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
- Always close resources (files, network connections, etc.) using defer. If funcion, that closes resource returns error, handle it appropriately.
- Assume that application will be run in containerized environment (e.g., Docker, Kubernetes), therefore, application should handle the termination signals (SIGTERM, SIGINT, SIGKILL) gracefully and perform necessary cleanup before exiting.
- Build tool: Go Modules

### Structure
- Clear package boundaries
- Avoid large packages
- Use Google project layout, but omit unnecessary folders when not needed
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
- Prefer channels for coordination

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

# Platform Engineering Mindset

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

# When proposing solutions

- Explain trade-offs briefly
- Mention alternatives when relevant
- Justify architectural decisions
- Prefer simplicity and operational safety
