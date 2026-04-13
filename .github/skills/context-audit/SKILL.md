---
name: context-audit
description: Use this skill to audit GitHub Copilot repository instructions, skills, and supporting files for context bloat, duplication, contradictions, and poor reuse.
---

# Context Audit Skill

This skill is for repositories that use GitHub Copilot instruction files such as:
- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `.github/skills/*/SKILL.md`
- supporting `scripts/`, `resources/`, `examples/`, or `overlays/` inside skills

## When to use this skill

Use this skill when:
- the user asks to audit Copilot instructions or skills
- the repository has accumulated too many rules and the user wants to simplify them
- instruction files feel repetitive, contradictory, too broad, or hard to maintain
- the user wants to reduce prompt bloat without losing important repository guidance
- the task involves reviewing a new or draft skill before copying it into other repositories

## Goals

1. Keep instruction context small, clear, and reusable.
2. Preserve high-value repository guidance while removing noise.
3. Separate cross-cutting rules from narrow, task-specific guidance.
4. Prefer one clear source of truth for each rule.
5. Recommend structures that fit GitHub Copilot conventions used in this repository.

## Audit scope

Inspect these areas when present:
1. `.github/copilot-instructions.md`
2. `.github/instructions/*.instructions.md`
3. `.github/skills/*/SKILL.md`
4. skill support files under `scripts/`, `resources/`, `examples/`, and `overlays/`
5. `README.md` sections that describe how instructions and skills should be used

## Core review principles

- Prefer concise instructions over long narrative explanations.
- Keep durable repository rules in `.github/copilot-instructions.md`.
- Keep file-type or path-specific rules in `.github/instructions/*.instructions.md`.
- Keep reusable domain workflows in `.github/skills/<skill-name>/`.
- Avoid embedding agent-specific assumptions that do not match GitHub Copilot behavior.
- Avoid restating the same rule in multiple places unless a narrow file-specific restatement is truly needed.

## Audit checklist

### Structure and placement
- Check whether guidance is stored in the right place.
- Flag rules that belong in `.github/instructions/` but were placed in `.github/copilot-instructions.md`.
- Flag reusable workflow guidance that should be a skill instead of a repository-wide rule.
- Flag skills that include broad repository policy better suited to `.github/copilot-instructions.md`.

### Duplication and conflicts
- Look for repeated rules across `.github/copilot-instructions.md`, path-specific instructions, skills, and README examples.
- Flag contradictions in tone, tool preference, validation steps, or architecture guidance.
- Flag near-duplicates where multiple files say the same thing with slightly different wording.

### Skill quality
- Check whether each skill clearly states when to use it.
- Check whether the skill is scoped to one domain or workflow.
- Flag skills that depend on unsupported mechanisms, hidden state, or agent-specific commands.
- Flag long sections that repeat general coding advice already covered elsewhere.
- Check whether referenced `scripts/`, `resources/`, `examples/`, or `overlays/` actually exist.

### Path-specific instruction quality
- Check whether each `.instructions.md` file has a correct `applyTo` pattern.
- Flag patterns that are too broad, too narrow, or redundant with another file.
- Check whether the file contains language- or tool-specific guidance instead of generic advice.
- Flag instructions that would apply better as repository-wide guidance or a skill.

### Clarity and maintenance
- Flag vague advice such as "be clean", "be natural", or "use best practices" when it lacks repository-specific meaning.
- Flag bandaid rules added for one bad outcome instead of durable guidance.
- Flag hedging and filler that weakens the instruction signal.
- Prefer references to supporting files over copying large operational checklists into the main skill file.

## Heuristics for bloat

Treat these as review signals, not hard failures:
- repository-wide instruction files that keep growing without a clear split of concerns
- skills that mix trigger rules, policy, long tutorials, and operational detail in one file
- repeated explanations that could be replaced by a short pointer to `resources/` or `examples/`
- multiple files carrying the same coding style guidance
- agent-specific wording copied from another tool without adaptation for Copilot

## Review workflow

When performing a context audit:
1. Read the target skill or instruction file first.
2. Inspect nearby Copilot files for overlap, especially `.github/copilot-instructions.md`, `.github/instructions/`, and sibling skills.
3. Identify the top issues in this order:
   - unsupported or non-Copilot behavior
   - incorrect placement of guidance
   - contradictions and duplication
   - excessive length or poor reuse
   - missing support files or broken references
4. Recommend the smallest structural fix that improves clarity.
5. Rewrite the file if the user asks for changes, keeping the result concise and consistent with the repository style.

## Expected output style

When responding:
- lead with concrete findings
- explain why each finding matters for Copilot maintainability or context quality
- prefer actionable fixes over abstract critique
- preserve useful guidance while removing tool-specific or low-value instructions
- keep rewrites practical, concise, and easy to copy into another repository

## Typical fixes

- move broad engineering rules into `.github/copilot-instructions.md`
- move language-specific rules into `.github/instructions/*.instructions.md`
- rewrite skills to focus on one workflow or domain
- replace duplicated prose with a short pointer to a support file
- remove Claude-specific or Codex-specific mechanics from Copilot skill files
- tighten `applyTo` globs to match the intended files

## Success criteria

A good context-audit result leaves the repository with:
- one clear home for each kind of guidance
- minimal duplication
- no obvious contradictions
- skills that are reusable and Copilot-appropriate
- instruction files that are short enough to maintain comfortably
