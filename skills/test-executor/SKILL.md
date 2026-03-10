---
name: test-executor
description: Executes tests, analyzes test results, checks test coverage, and provides comprehensive testing status overview. Primarily for Go projects. Activates after implementing/modifying code to verify correctness, or when explicitly requested to assess test suite health.
allowed-tools: [Bash, Read, Glob, Grep, AskUserQuestion]
---

# Test Executor Skill

Execute tests, analyze results, and report coverage. Primarily for Go projects.

## Activation Triggers

- After code implementation/modification (automatic)
- "test coverage", explicit test requests (manual)
- Before commit or PR creation

## Workflow

### Phase 1: Determine Test Scope

- Identify target packages from project structure
- Check for Makefile or custom test commands
- Coverage threshold: follow project settings (default 80%)

### Phase 2: Execute

```bash
# Tests + coverage
go test ./internal/... -coverprofile=coverage.out -covermode=atomic
go tool cover -func=coverage.out

# Benchmarks (on request only)
go test -bench=. -benchmem ./...
```

### Phase 3: Report Results

```markdown
## Test Results

### Summary
- Tests run: X
- Passed: Y ✅ / Failed: Z ❌
- Coverage: W% (threshold: N%)
- Verdict: [✅ All passing / ⚠️ Issues found / ❌ Critical failures]

### Package Coverage
[package-by-package breakdown]

### Issues
[items needing attention]

### Recommended Actions
[specific next steps]
```

## Failure Analysis

- Identify root cause, not just surface-level error message
- Suggest specific fixes
- Recommend adding tests for the failure scenario

## Edge Cases

- No tests found → suggest creating test files
- coverage.out generation failure → troubleshoot
- Flaky test → re-run to confirm
- Build error → distinguish compilation errors from test failures
