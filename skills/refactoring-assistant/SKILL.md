---
name: refactoring-assistant
description: Assists with code refactoring by detecting code smells, suggesting improvements, and providing refactoring patterns. Activates when writing/editing code, explicitly requested refactoring, or when code quality issues are detected. Maintains awareness of core principles while providing detailed patterns and examples.
allowed-tools: [Read, Grep, Glob, AskUserQuestion]
---

# Refactoring Assistant Skill

Detect code smells and assist refactoring during development. Proactively suggest improvements without waiting for explicit requests.

## Activation Triggers

- Threshold violations detected during code editing (automatic)
- "refactor", "code smell" (manual)

## Code Smell Thresholds

| Code Smell | Threshold | Action |
|-----------|-----------|--------|
| Long Method | > 50 lines | Extract functions |
| Duplicate Code | 3+ occurrences | Extract to shared function/constant |
| Deep Nesting | > 3 levels | Early return, extract conditions |
| Long Parameter List | > 5 params | Structured params (TS: RORO, Go: struct) |
| Large Module | > 300 lines | Split into smaller modules |
| Complex Conditional | > 3 conditions | Extract to named function/variable |

## Workflow

1. **Detect**: Read code, match against thresholds. Prioritize by severity (security > readability > style)
2. **Analyze**: Check tech-stack rules (`patterns/typescript-react.md`, `patterns/go.md`). Consider context (one-off vs recurring, business justification for complexity)
3. **Suggest**: Show location (file:line), present before/after with trade-offs. Execute after user approval (partial approval OK)
4. **Implement**: Make small incremental changes. Run tests/linter to verify. Record new patterns via knowledge-manager

## Guardrails

- Do not refactor without test coverage (add tests first)
- Do not change behavior (refactoring ≠ feature change)
- Prefer incremental improvement over large-scale rewrites

## Supporting Files

- `rules/code-smells.md`: Detection criteria and pattern details
- `patterns/typescript-react.md`: TS/React-specific patterns
- `patterns/go.md`: Go-specific patterns
