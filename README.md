# copilot-instructions

Reusable GitHub Copilot instructions and skills for platform engineering projects.

> [!IMPORTANT]
> Prefer the official documentation for GitHub Copilot and other coding agents when you need authoritative behavior, feature support, or setup guidance. Models, instruction formats, and agent capabilities evolve quickly, so this repository should be treated as a practical template, not the canonical source of truth.

This repository is published under the [MIT License](LICENSE). Contributions are welcome; see [CONTRIBUTING.md](CONTRIBUTING.md).

## What this repository contains

- `.github/copilot-instructions.md`: repository-wide, cross-cutting guidance for GitHub Copilot
- `.github/instructions/`: path-specific instruction files for stacks and file types such as Go, Java, Terraform, and Helm
- `.github/agents/`: agent-specific instruction files such as the Go code review agent
- `.github/skills/go-project`: reusable skill for Go repositories
- `.github/skills/crossplane-v2`: reusable skill for Crossplane v2 platform APIs
- `LICENSE`: MIT license for reuse
- `CONTRIBUTING.md`: minimal contribution guidance for public collaboration

## How to use in a single project

1. Copy `.github/copilot-instructions.md` into the target repository at `.github/copilot-instructions.md`.
2. Copy the relevant path-specific instruction files from `.github/instructions/` into the target repository when you want narrower rules for specific file types or directories.
3. Copy only the skill folders you need into `.github/skills/` in the target repository.
4. Keep the copied skill directory structure intact, including `SKILL.md`, `scripts/`, `resources/`, `examples/`, and `overlays/`.
5. Adjust the instruction files only where the target repository has stronger local conventions.

Example:

```text
target-repo/
  .github/
    copilot-instructions.md
    instructions/
      golang.instructions.md
      java.instructions.md
      terraform.instructions.md
      helm.instructions.md
    skills/
      go-project/
      crossplane-v2/
```

## How to use across many projects

GitHub Copilot repository instructions are repository-scoped. A single `.github/copilot-instructions.md` file does not automatically apply to every repository on your machine or organization.

If you want similar behavior across many projects, use one of these approaches:

1. Keep this repository as the source template and copy `.github/copilot-instructions.md`, any needed `.github/instructions/*.instructions.md` files, and the needed `.github/skills/*` folders into each project.
2. Keep a smaller shared baseline in your personal or IDE-level Copilot custom instructions, then keep repository-specific rules in `.github/copilot-instructions.md`.
3. Create repository-specific prompt files or path-specific instruction files only when a project truly needs narrower guidance.

Recommended split:

- Put stable, cross-project engineering principles in personal or IDE-level instructions.
- Put repository-wide standards, architecture rules, and workflows in `.github/copilot-instructions.md`.
- Put language-specific and tool-specific rules in `.github/instructions/*.instructions.md`.
- Put reusable domain expertise in `.github/skills/<skill-name>/`.

## Notes on path-specific instructions

Use `.github/instructions/` when you want narrower rules for specific files or directories without overloading the repository-wide instructions. These files should use the GitHub Copilot path-specific instruction format with `applyTo` frontmatter.

Current examples in this repository:

- `golang.instructions.md`
- `java.instructions.md`
- `terraform.instructions.md`
- `helm.instructions.md`

This split works well when `.github/copilot-instructions.md` stays focused on cross-cutting guidance and the narrower files carry stack-specific rules.

## Reusing these skills with other agents

The content is reusable across agents, but the mechanism is not fully portable. `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, and `.github/skills/*/SKILL.md` are GitHub Copilot conventions, not universal agent standards.

### Codex

For Codex, reuse the guidance in one of these ways:

1. Move the repository-wide rules into `AGENTS.md` or another repo-level instruction file used by your Codex workflow.
2. Adapt path-specific instruction files into Codex-friendly repo docs or agent entry points where narrower guidance is useful.
3. Convert each skill into a Codex-friendly instruction bundle, keeping the existing `scripts/`, `resources/`, and `examples/` as supporting assets.
4. Keep the skill trigger text from `SKILL.md`, but rewrite any GitHub-specific wording into direct execution guidance for Codex.

### Claude Code

For Claude Code, the same content can be adapted into `CLAUDE.md` plus supporting docs:

1. Put the shared repository rules into `CLAUDE.md`.
2. Move path-specific guidance into `docs/ai/`, `docs/agents/`, or another predictable location.
3. Move each skill's usage rules into the same documentation structure or an equivalent agent-specific entry point.
4. Reference the existing shell scripts and checklists from those docs instead of duplicating operational steps.

### Practical portability advice

- Start with the official documentation for each agent, then adapt this repository's content to match the current capabilities and file conventions of that tool.
- Treat `SKILL.md` as the source content, not the source format.
- Treat `.github/instructions/*.instructions.md` as reusable guidance, not a portable standard.
- Keep scripts and checklists tool-agnostic so every agent can reuse them.
- Keep one canonical copy of each skill, then generate or adapt thin wrappers for GitHub Copilot, Codex, and Claude Code.
- If you want true multi-agent reuse, store the durable guidance under `docs/ai/` and treat `.github/skills/`, `AGENTS.md`, and `CLAUDE.md` as agent-specific entry points.

## Contributing

For small public repos like this one, the contribution model is intentionally lightweight:

- keep changes focused
- preserve the split between repo-wide guidance and path-specific instructions
- update the README when structure or usage changes
- prefer improving existing guidance over adding overlapping files

See [CONTRIBUTING.md](CONTRIBUTING.md) for the short version.
