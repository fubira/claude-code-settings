---
name: code-reviewer
description: Assists with code review by analyzing code changes for quality, best practices, security, and potential issues. Activates after implementing code features, bug fixes, or refactorings. Provides structured feedback with critical issues, suggestions, and positive highlights.
allowed-tools: [Read, Bash, Glob, Grep, mcp__ide__getDiagnostics, AskUserQuestion]
---

# Code Reviewer Skill

Review code changes for quality, security, and performance. Provide structured, actionable feedback.

## Activation Triggers

- After completing a feature, bug fix, or refactoring (automatic)
- "review this code" (manual)
- Before PR creation

## Review Areas

1. **Correctness**: Logic, bugs, edge cases, boundary values
2. **Quality**: Language idioms, DRY, early return, duplication (per CLAUDE.md)
3. **Type Safety**: Type annotations, null/undefined, off-by-one
4. **Performance**: Unnecessary allocations, parallelization opportunities, data structure choice
5. **Security**: Input validation, SQLi/XSS, secrets handling
6. **Testing**: Coverage for new code paths, edge case tests
7. **Project Compliance**: CLAUDE.md standards, consistency with existing patterns

## Workflow

1. **Context**: `git diff` to understand changes, check project CLAUDE.md, identify related tests
2. **Analysis**: Review against above areas. Run `mcp__ide__getDiagnostics` for lint/type errors
3. **Test Verification**: Check coverage and test quality
4. **Feedback**: Report using the format below

## Output Format

1. **Critical Issues** (must fix): Bugs, vulnerabilities, breaking changes → file:line + fix suggestion
2. **Important Suggestions** (should address): Performance, maintainability
3. **Minor Improvements** (nice to have): Style, documentation
4. **Positive Highlights**: Good implementations
5. **Next Steps**: Prioritized recommended actions

Template details: `templates/review-report.md`

## Decision Criteria

- Correctness > cleverness. CLAUDE.md standards > general best practices
- Provide specific, actionable feedback (file:line + code examples)
- Investigate why unusual approaches pass tests before flagging them
