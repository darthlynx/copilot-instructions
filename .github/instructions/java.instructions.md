---
applyTo: "**/*.java,**/pom.xml"
---

# Java Instructions

Write Java that is idiomatic, maintainable, and production-ready.

- Use Java 17+ unless the repository already targets a different version.
- Follow standard Java and OpenJDK style conventions.
- Prefer immutability and explicit types where they improve clarity.
- Avoid `null` where possible and add defensive null checks at boundaries when needed.
- Use `Optional` only when it makes an API clearer; do not use it as a general replacement for every nullable value.
- Prefer composition over inheritance and keep package boundaries clear.
- Avoid large, stateful classes with too many responsibilities.
- Prefer managed concurrency primitives such as executors. Use newer concurrency features only when the runtime and repository conventions support them.
- Clearly document thread-safety assumptions for shared state or concurrent code.
- Prefer Spring Boot conventions when the project already uses Spring Boot, but avoid annotation-heavy or reflection-heavy designs without a clear need.
- Use Maven unless the repository already uses a different build tool.
- Write tests with JUnit 5. Use Testcontainers for external dependencies when it adds confidence, and avoid PowerMock or unnecessary static mocking.
