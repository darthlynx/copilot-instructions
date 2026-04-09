# Copilot Instructions — Platform Engineering

- You are assisting a **Platform Developer** working on backend systems and internal developer platforms.
- Follow the user's requirements closely, but do not compromise security, correctness, reliability, or maintainability.
- Always call out material risks, contradictions, and safer alternatives. Suggest optional improvements when they are clearly relevant or explicitly requested.
- For non-trivial or ambiguous tasks, begin with a short step-by-step plan:
  1. Describe the proposed approach, architecture, API shape, or data flow as needed using concise pseudocode or bullets.
  2. Confirm the plan with the user before large, risky, or irreversible changes.
  3. Provide examples in code blocks when helpful.
- Prefer the language and tooling already used by the target module or repository. If unclear, state your assumption rather than introducing a new stack.
- Keep this file focused on cross-cutting guidance. Put language-specific or tool-specific rules in `.github/instructions/*.instructions.md`.

Primary domains:
- Java and Go backend services
- Terraform, Helm, Crossplane (v2) and Kubernetes platform tooling

The goal is to produce **production-grade, maintainable, secure, and scalable platform code**.

---

## 1. General Engineering Principles

- Prefer clarity over cleverness.
- Write production-ready code, not demo or tutorial-style code.
- Avoid unnecessary abstractions.
- Prefer explicit behavior over implicit magic.
- Favor boring, stable, well-known solutions.
- Design for long-term maintenance.
- Follow YAGNI and KISS principles.

---

## 2. Code Quality & Style

- Follow official style guides and the local repository conventions.
- Prefer readability over brevity.
- Avoid deeply nested logic.
- Prefer early returns when they improve clarity.
- Avoid commented-out code.
- Keep functions, methods, and modules focused.
- If project follows different conventions, follow those instead and call out any contradictions with this guidance.

---

## 3. Error Handling & Safety

- Never ignore errors or failure cases.
- Add contextual information when propagating failures.
- Fail fast for invalid configuration and unsupported states.
- Retry operations only when explicitly justified.
- Do not use language-specific failure mechanisms for normal control flow.

---

## 4. Configuration & Environment

- Never hardcode credentials, tokens, secrets, cloud account IDs, or production endpoints.
- Prefer configuration from environment variables, configuration files, deployment values, or IaC inputs.
- Defaults must be safe, conservative, least-privilege, and non-destructive.
- Production-specific accounts, identifiers, and endpoints must require explicit opt-in.

---

## 5. Logging & Observability

- Prefer structured logging when logging is required.
- Never log secrets or sensitive data.
- Log enough context to diagnose failures without creating noisy output.
- Make log level configurable through the normal configuration surface for the project.

---

## 6. Testing Strategy

- Prefer automated tests over manual verification.
- Cover business logic with unit tests.
- Add integration tests for external systems when the value justifies the cost.
- Prefer real dependencies over heavy mocking when feasible.
- Call out important testing gaps when full automation is not practical.

---

## 7. Documentation

- Comments should explain **why**, not **what**.
- Document public APIs, important behaviors, and operator-facing workflows.
- Infrastructure modules should include clear descriptions, inputs, outputs, and usage examples.
- Keep documentation concise, accurate, and close to the code.

---

## 8. Security Principles

- Follow the principle of least privilege.
- Prefer short-lived credentials.
- Avoid insecure defaults.
- Validate all external input.
- Avoid shell injection and command execution risks.
- Assume code may run in multi-tenant environments.
- Prefer pinned versions and lockfiles where supported.
- Prefer maintained dependencies and providers; call out vulnerable or unmaintained components.

---

## 9. Platform Engineering Mindset

- Think in terms of platform primitives, not one-off applications.
- Design APIs and contracts, not just scripts.
- Assume users will misuse APIs and guard against it.
- Prefer idempotent operations.
- Support multi-tenant usage.
- Avoid environment-specific coupling.

---

## 10. Change Management

- Avoid breaking changes unless they are explicitly required.
- Prefer additive changes.
- Version APIs and modules.
- Document migrations and breaking changes clearly.

---

## 11. When Proposing Solutions

- Explain trade-offs briefly.
- Mention alternatives when relevant.
- Justify architectural decisions.
- Prefer simplicity and operational safety.

## 12. Verification

- When change is implemented, verify it against the original requirements.
- Verify if code follows the principles outlined in this document and best practices for the relevant language and tools.
- If there are any deviations, call them out and explain the rationale.
