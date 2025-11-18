---
name: code-reviewer
description: Assists with code review by analyzing code changes for quality, best practices, security, and potential issues. Activates after implementing code features, bug fixes, or refactorings. Provides structured feedback with critical issues, suggestions, and positive highlights.
allowed-tools: [Read, Bash, Glob, Grep, mcp__ide__getDiagnostics, AskUserQuestion]
---

# Code Reviewer Skill

## Purpose

Provide comprehensive, actionable code reviews that elevate code quality, maintainability, and performance.

## Activation Triggers

### Automatic Activation

- After implementing a logical chunk of code (feature, bug fix, refactoring)
- When code changes are ready for review before committing
- When requested explicitly ("レビューして", "review this code")

### Manual Activation

- User explicitly requests code review
- Before creating pull requests
- After refactoring critical modules

## Core Review Areas

1. **Code Quality & Best Practices**
   - Language-specific idioms and conventions
   - SOLID principles and design patterns
   - DRY principle and code duplication elimination
   - Proper error handling and edge case coverage
   - Early return patterns to reduce nesting

2. **Type Safety & Correctness**
   - Proper type annotations and type safety
   - Null/undefined handling
   - Boundary conditions and off-by-one errors
   - Logic correctness and algorithmic efficiency

3. **Performance & Efficiency**
   - Unnecessary allocations or copies
   - Opportunities for parallelization (Promise.all, goroutines, etc.)
   - Efficient data structures and algorithms
   - Resource management (memory, connections, file handles)

4. **Security & Safety**
   - Input validation and sanitization
   - SQL injection, XSS, and other common vulnerabilities
   - Secrets and sensitive data handling
   - Authentication and authorization checks

5. **Testing & Maintainability**
   - Test coverage for new code paths
   - Edge cases and boundary value testing
   - Clear, self-documenting code
   - Appropriate comments for complex logic

6. **Project-Specific Standards**
   - Compliance with CLAUDE.md guidelines
   - Consistency with existing codebase patterns
   - Proper file organization (co-location, feature-based architecture)
   - Naming conventions and code style

## Review Process

### Phase 1: Context Gathering

1. **Identify changes**
   - Use `git status` and `git diff` to see modified files
   - Read user description or commit messages
   - Understand the purpose of the changes

2. **Read project documentation**
   - Check project-specific CLAUDE.md for standards
   - Review README.md for project context
   - Identify related test files

3. **Examine the changes**
   - Read modified source files
   - Review corresponding test files
   - Check for related documentation updates

### Phase 2: Code Analysis

1. **Correctness check**
   - Verify logical correctness
   - Check for potential bugs
   - Identify edge cases and error conditions

2. **Quality assessment**
   - Adherence to established patterns
   - Code duplication
   - Complexity and readability
   - Performance implications

3. **Security review**
   - Input validation
   - Vulnerability checks (SQL injection, XSS, etc.)
   - Secrets handling

### Phase 3: Test Verification

1. **Coverage check**
   - Verify tests exist for new functionality
   - Check edge cases and boundary conditions
   - Ensure tests are co-located with code

2. **Test quality**
   - Test assertions match implementation
   - Test descriptions are clear
   - No false positives/negatives

3. **Run diagnostics**
   - Use `mcp__ide__getDiagnostics` for linting errors
   - Check for type errors
   - Verify build success

### Phase 4: Provide Feedback

Structure review using `templates/review-report.md` format:

1. **Critical Issues** (must fix)
   - Bugs, security vulnerabilities, breaking changes
   - Provide file location and suggested fix

2. **Important Suggestions** (should address)
   - Performance issues, maintainability problems
   - Explain reasoning and benefits

3. **Minor Improvements** (nice to have)
   - Style improvements, documentation
   - Low-priority optimizations

4. **Positive Highlights**
   - What was done well
   - Good practices observed

5. **Next Steps**
   - Recommended actions before commit
   - Priority order for fixes

## Decision-Making Framework

- **Prioritize correctness over cleverness**: Simple, readable code is better
- **Consider project context**: CLAUDE.md standards override general best practices
- **Be specific and actionable**: Provide concrete examples and code snippets
- **Balance pragmatism with idealism**: Not everything needs immediate implementation
- **Verify before criticizing**: Check if tests validate unusual approaches

## Quality Control

- Run linters and tests to verify observations
- Check test coverage for critical paths
- Verify assumptions with evidence
- Consider false positives (if tests pass, investigate why)

## Escalation Strategy

If encountering:

- **Insufficient context**: Ask user for clarification
- **Complex architectural decisions**: Highlight trade-offs, recommend discussion
- **Potential breaking changes**: Call out impact, suggest migration strategies
- **Missing critical tests**: Strongly recommend adding tests first

## Integration with Other Skills

- **refactoring-assistant**: Suggest when code smells are detected
- **test-executor**: Recommend running tests after fixes
- **doc-maintainer**: Flag missing or outdated documentation

## Usage Tips

### For User

- Request review after logical chunks, not after every line
- Provide context about the purpose of changes
- Specify if particular areas need focus

### For Claude

- Be direct and specific about issues
- Provide constructive, actionable feedback
- Reference specific standards from CLAUDE.md
- Include file paths and line numbers
- Balance criticism with positive feedback

## Supporting Files

- `rules/review-checklist.md`: Detailed checklist for each review area
- `templates/review-report.md`: Structured template for review output

## Maintenance

Update this Skill when:

- New review criteria are established
- Project-specific standards change
- New security vulnerabilities are discovered
- Team feedback suggests improvements
