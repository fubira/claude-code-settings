# Code Review Report Template

Use this template structure for all code reviews.

## Code Review Summary

[Brief overview of what was changed and overall assessment. Include scope of changes (files, lines) and general quality level.]

### Critical Issues ❌

> Must be fixed before committing. These are bugs, security vulnerabilities, or breaking changes.

- **[Issue 1 Title]** (`file/path.ts:123`)
  - **Problem**: [Describe the issue]
  - **Impact**: [Why this is critical]
  - **Suggested Fix**: [Concrete solution with code example if possible]

- **[Issue 2 Title]** (`file/path.go:45`)
  - **Problem**: [Describe the issue]
  - **Impact**: [Why this is critical]
  - **Suggested Fix**: [Concrete solution]

### Important Suggestions ⚠️

> Should be addressed. These are performance issues, maintainability problems, or significant improvements.

- **[Suggestion 1 Title]** (`file/path.tsx:67`)
  - **Observation**: [What was noticed]
  - **Reasoning**: [Why this matters]
  - **Recommendation**: [Proposed improvement]
  - **Benefit**: [Expected outcome]

- **[Suggestion 2 Title]** (`file/path.go:89`)
  - **Observation**: [What was noticed]
  - **Reasoning**: [Why this matters]
  - **Recommendation**: [Proposed improvement]

### Minor Improvements 💡

> Nice to have. These are style improvements, minor optimizations, or documentation enhancements.

- [Improvement 1]: Brief description
- [Improvement 2]: Brief description
- [Improvement 3]: Brief description

### Positive Highlights ✅

> Acknowledge good practices and well-executed code.

- **[Highlight 1]**: [What was done well and why it's good]
- **[Highlight 2]**: [Good practice observed]
- **[Highlight 3]**: [Effective solution or pattern used]

### Next Steps 🎯

**Before committing:**

1. [ ] Fix critical issues ([Issue 1], [Issue 2])
2. [ ] Address important suggestions ([Suggestion 1])
3. [ ] Run tests to verify changes
4. [ ] Update documentation if needed

**Optional improvements:**

- [ ] Consider minor improvements for future iterations
- [ ] Add tests for edge cases identified

**Review Status**: ✅ Approved with changes | ⚠️ Needs revision | ❌ Blocked by critical issues

---

## Example Review

### Code Review Summary

Reviewed authentication module refactoring (3 files, ~150 lines changed). Overall quality is good with proper error handling and type safety. Found one critical security issue and a few performance optimization opportunities.

### Critical Issues ❌

- **Potential JWT Secret Exposure** (`src/auth/jwt.ts:34`)
  - **Problem**: JWT secret is hardcoded in source file
  - **Impact**: Security vulnerability - secret visible in version control
  - **Suggested Fix**: Move to environment variable
    ```typescript
    const secret = process.env.JWT_SECRET;
    if (!secret) throw new Error('JWT_SECRET not configured');
    ```

### Important Suggestions ⚠️

- **Unnecessary Database Query in Loop** (`src/auth/validator.ts:78`)
  - **Observation**: User lookup inside loop, causing N+1 query problem
  - **Reasoning**: Performance degrades with large user lists
  - **Recommendation**: Batch fetch users before loop
  - **Benefit**: Reduces DB queries from O(n) to O(1)

### Minor Improvements 💡

- Consider extracting validation logic to separate function for reusability
- Add JSDoc comments for public API functions
- Use `const` instead of `let` where variables aren't reassigned

### Positive Highlights ✅

- **Excellent error handling**: All edge cases covered with meaningful error messages
- **Type safety**: Proper TypeScript types throughout, no `any` usage
- **Test coverage**: Comprehensive tests including edge cases and error paths

### Next Steps 🎯

**Before committing:**

1. [ ] Fix JWT secret exposure (move to env var)
2. [ ] Optimize database queries (batch fetch)
3. [ ] Run full test suite
4. [ ] Update README with new env var requirement

**Optional improvements:**

- [ ] Add JSDoc for public functions
- [ ] Extract validation logic

**Review Status**: ⚠️ Needs revision (fix critical security issue)
