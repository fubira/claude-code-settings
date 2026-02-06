---
name: test-executor
description: Executes tests, analyzes test results, checks test coverage, and provides comprehensive testing status overview. Primarily for Go projects. Activates after implementing/modifying code to verify correctness, or when explicitly requested to assess test suite health.
allowed-tools: [Bash, Read, Glob, Grep, AskUserQuestion]
---

# Test Executor Skill

## Purpose

Execute tests, analyze results comprehensively, and provide actionable insights about testing status of Go projects.

## Activation Triggers

### Automatic Activation

- After implementing or modifying code
- After refactoring critical modules
- When preparing to commit changes

### Manual Activation

- User explicitly requests test execution
- User asks about test coverage status
- Before creating pull requests

## Core Responsibilities

1. **Test Execution**: Run tests using appropriate commands (`go test`, `make test`)
2. **Coverage Analysis**: Calculate and report test coverage for target packages
3. **Result Interpretation**: Analyze results, identify failures, provide clear explanations
4. **Status Reporting**: Deliver comprehensive summaries with actionable recommendations

## Test Execution Process

### Phase 1: Identify Test Scope

1. **Check project structure**
   - Determine which packages to test
   - Identify coverage calculation scope
   - Check for Makefile or custom test commands

2. **Project-specific settings**
   - プロジェクトの構造に応じて対象パッケージを決定
   - Coverage threshold: CLAUDE.md またはプロジェクト設定に従う（デフォルト: 80%）
   - Test command: `make test` or `go test ./...`

### Phase 2: Run Tests with Coverage

1. **Execute tests**
   ```bash
   go test ./internal/... -coverprofile=coverage.out -covermode=atomic
   ```
   - Capture both test results and coverage data
   - Note test failures, panics, or timeout issues

2. **Generate coverage report**
   ```bash
   go tool cover -func=coverage.out
   ```
   - Calculate total coverage percentage
   - Identify uncovered or poorly covered packages

3. **Run benchmarks** (if requested)
   ```bash
   go test -bench=. -benchmem ./...
   ```
   - Capture performance metrics (ns/op, allocations, memory)

### Phase 3: Analyze Results

For each test execution, provide:

**1. Executive Summary**
- Total tests run / passed / failed
- Overall coverage percentage
- Comparison to threshold
- Quick verdict: ✅ All passing, ⚠️ Issues found, ❌ Critical failures

**2. Detailed Breakdown**
- Package-by-package coverage report
- List of failed tests with error messages
- Uncovered code sections (if coverage below threshold)

**3. Actionable Recommendations**
- Specific tests that need attention
- Suggestions for improving coverage
- Performance concerns from benchmarks (if applicable)
- Next steps for the developer

### Phase 4: Report Results

Use structured format (in Japanese, だ・である調):

```markdown
## テスト実行結果

### 📊 サマリー
- 実行テスト数: X件
- 成功: Y件 ✅
- 失敗: Z件 ❌
- カバレッジ: W% (閾値: プロジェクト設定値)
- 総合評価: [verdict]

### 📦 パッケージ別カバレッジ
[package-by-package breakdown]

### ⚠️ 注意が必要な項目
[issues and concerns]

### 💡 推奨アクション
[specific recommendations]
```

## Quality Standards

- **Accuracy**: Report exact numbers from test output, never estimate
- **Completeness**: Cover all aspects (unit tests, coverage, benchmarks if run)
- **Clarity**: Use clear formatting with emojis for visual scanning
- **Actionability**: Always provide specific next steps, not vague advice

## Edge Cases and Handling

- **No tests found**: Report clearly and suggest creating test files
- **Coverage tool errors**: Check if `coverage.out` was generated, provide troubleshooting
- **Flaky tests**: Note if re-running gives different results
- **Build failures**: Distinguish between compilation errors and test failures
- **Timeout issues**: Identify long-running tests and suggest optimization

### Test Failure Analysis

When test failures occur:

1. **Identify root cause**
   - Not just surface-level error message
   - Analyze what condition caused failure

2. **Provide guidance**
   - Suggest specific fixes
   - Recommend additional tests if edge cases found

3. **Prevent regression**
   - Ensure fix includes test for the failure scenario

## Integration with Other Skills

- **code-reviewer**: Run after review to verify fixes don't break tests
- **refactoring-assistant**: Verify refactoring doesn't cause regressions
- **git-commit-assistant**: Ensure all tests pass before committing

## Usage Tips

### For User

- Run tests before committing changes
- Check coverage regularly, especially after adding new features
- Investigate failing tests immediately, don't accumulate tech debt

### For Claude

- Always provide exact test output, not paraphrased summaries
- Guide toward root cause, not just making tests pass
- Prioritize test quality over coverage numbers
- Suggest additional tests for edge cases

## Maintenance

Update this Skill when:

- Test standards or thresholds change
- New testing frameworks are adopted
- Project-specific test commands change
- CI/CD pipeline requirements evolve
