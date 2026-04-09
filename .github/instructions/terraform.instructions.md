---
applyTo: "**/*.tf,**/*.tfvars,**/.terraform.lock.hcl"
---

# Terraform Instructions

Write Terraform that is explicit, reusable, and safe to operate.

- Use Terraform 1.5+ unless the repository already pins a different supported version.
- Prefer small modules with one clear responsibility.
- Keep module inputs and outputs intentional. Every variable should have a type and description, and outputs should be meaningful.
- Add validation blocks when they prevent invalid or dangerous configurations.
- Avoid hardcoded names, regions, account IDs, and environment-specific values; expose them as inputs when appropriate.
- Follow consistent naming and tagging conventions for resources.
- Prefer data flow that is easy to read over clever indirection or over-abstracted module layering.
- Keep plans predictable. Avoid patterns that create hidden dependencies or surprising replacement behavior.
- Use safe defaults and least-privilege IAM policies.
- Pin providers and commit the lockfile when the repository uses one.
- Document module usage, assumptions, and any destructive or high-impact behaviors.
