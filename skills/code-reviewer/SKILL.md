---
name: code-reviewer
description: Assists with code review by analyzing code changes for quality, best practices, security, and potential issues. Activates after implementing code features, bug fixes, or refactorings. Provides structured feedback with critical issues, suggestions, and positive highlights.
allowed-tools: [Read, Bash, Glob, Grep, AskUserQuestion]
---

# Code Reviewer Skill

Review code changes for quality, security, and performance. Provide structured, actionable feedback.

## Activation Triggers

- After completing a feature, bug fix, or refactoring (automatic)
- "review this code" (manual)
- Before PR creation

## Review Areas

1. **Correctness**: Logic, bugs, edge cases, boundary values
2. **Quality**: Language idioms, DRY, early return, duplication, structured params (TS: RORO)
3. **Type Safety**: Type annotations, null/undefined, off-by-one
4. **Performance**: Unnecessary allocations, parallelization opportunities, data structure choice
5. **Security**: Input validation, SQLi/XSS, secrets handling
6. **Testing**: Coverage for new code paths, edge case tests
7. **Project Compliance**: CLAUDE.md standards, consistency with existing patterns
8. **Root-cause adequacy** (when the diff responds to a prior finding): does the fix address the violated invariant, or only its symptom?

## Workflow

1. **Context**: `git diff` to understand changes, check project CLAUDE.md, identify related tests
2. **Analysis**: Review against above areas. Run project lint/type-check commands for errors
3. **Test Verification**: Check coverage and test quality
4. **Feedback**: Report using the format below
5. **Re-review**: when the diff answers earlier findings, verify each one is closed by a root-cause fix. Passing tests are not evidence — a relaxed test passes too

## Symptom-Only Fixes

A finding is not closed by silencing its symptom. Treat these as unresolved until the root cause is stated:

- A branch, guard, or special case added only for the reported input
- Thresholds, expected values, or tolerances adjusted to match observed output
- Exceptions swallowed, or errors downgraded to warnings/logs
- Tests relaxed, skipped, or rewritten to assert the new behavior
- The fix touches one call path when the invariant is enforced in several

Ask what invariant was broken. If the answer is only "the test failed", the root cause is not established. Re-raise the original finding rather than closing it, and check the other paths that enforce the same invariant.

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
- A symptom-only fix is a Critical Issue, even when the reported symptom is gone
