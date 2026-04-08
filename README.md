# copilot-instructions

Reusable GitHub Copilot instructions and skills for platform engineering projects.

## What this repository contains

- `.github/copilot-instructions.md`: repository-wide guidance for GitHub Copilot
- `.github/skills/go-project`: reusable skill for Go repositories
- `.github/skills/crossplane-v2-namespaced`: reusable skill for Crossplane v2 platform APIs

## How to use in a single project

1. Copy `.github/copilot-instructions.md` into the target repository at `.github/copilot-instructions.md`.
2. Copy only the skill folders you need into `.github/skills/` in the target repository.
3. Keep the copied skill directory structure intact, including `SKILL.md`, `scripts/`, `resources/`, `examples/`, and `overlays/`.
4. Adjust the instruction file only where the target repository has stronger local conventions.

Example:

```text
target-repo/
  .github/
    copilot-instructions.md
    skills/
      go-project/
      crossplane-v2-namespaced/
```

## How to use across many projects

GitHub Copilot repository instructions are repository-scoped. A single `.github/copilot-instructions.md` file does not automatically apply to every repository on your machine or organization.

If you want similar behavior across many projects, use one of these approaches:

1. Keep this repository as the source template and copy `.github/copilot-instructions.md` plus the needed `.github/skills/*` folders into each project.
2. Keep a smaller shared baseline in your personal or IDE-level Copilot custom instructions, then keep repository-specific rules in `.github/copilot-instructions.md`.
3. Create repository-specific prompt files or path-specific instruction files only when a project truly needs narrower guidance.

Recommended split:

- Put stable, cross-project engineering principles in personal or IDE-level instructions.
- Put repository-specific standards, architecture rules, and workflows in `.github/copilot-instructions.md`.
- Put reusable domain expertise in `.github/skills/<skill-name>/`.

## Notes on path-specific instructions

Use `.github/instructions/` only when you need narrower rules for specific files or directories. Those files should use the GitHub Copilot path-specific instruction format, for example `terraform.instructions.md` with the required frontmatter.

If you do not need path-specific behavior, you can leave `.github/instructions/` empty.

## Reusing these skills with other agents

The content is reusable across agents, but the mechanism is not fully portable. `.github/copilot-instructions.md` and `.github/skills/*/SKILL.md` are GitHub Copilot conventions, not universal agent standards.

### Codex

For Codex, reuse the guidance in one of these ways:

1. Move the repository-wide rules into `AGENTS.md` or another repo-level instruction file used by your Codex workflow.
2. Convert each skill into a Codex-friendly instruction bundle, keeping the existing `scripts/`, `resources/`, and `examples/` as supporting assets.
3. Keep the skill trigger text from `SKILL.md`, but rewrite any GitHub-specific wording into direct execution guidance for Codex.

### Claude Code

For Claude Code, the same content can be adapted into `CLAUDE.md` plus supporting docs:

1. Put the shared repository rules into `CLAUDE.md`.
2. Move each skill's usage rules into `docs/ai/`, `docs/agents/`, or another predictable location.
3. Reference the existing shell scripts and checklists from those docs instead of duplicating operational steps.

### Practical portability advice

- Treat `SKILL.md` as the source content, not the source format.
- Keep scripts and checklists tool-agnostic so every agent can reuse them.
- Keep one canonical copy of each skill, then generate or adapt thin wrappers for GitHub Copilot, Codex, and Claude Code.
- If you want true multi-agent reuse, store the durable guidance under `docs/ai/` and treat `.github/skills/`, `AGENTS.md`, and `CLAUDE.md` as agent-specific entry points.
