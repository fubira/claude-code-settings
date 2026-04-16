---
name: test-executor
description: Executes tests, analyzes results, and reports coverage for Go and Node/Bun projects. Activates after code implementation/modification to verify correctness, or when explicitly requested.
allowed-tools: [Bash, Read, Glob, Grep, AskUserQuestion]
---

# Test Executor Skill

Execute tests, analyze results, report coverage. Supports Go and Node/Bun.

## Activation Triggers

- After code implementation/modification (automatic)
- "test coverage", explicit test requests (manual)
- Before commit or PR creation

## Workflow

### Phase 1: Detect project type and runner

| Indicator | Project type | Test command |
|-----------|-------------|-------------|
| `go.mod` | Go | `go test ./... -coverprofile=coverage.out -covermode=atomic` |
| `package.json` + `"test": "bun test"` | Bun | `bun test --coverage` |
| `package.json` + vitest/jest config | Node (vitest/jest) | `npm test` / `npx vitest run --coverage` |
| `Cargo.toml` | Rust | `cargo test` |
| Custom `Makefile` | Any | Prefer Makefile target over default |

Check `package.json` scripts first — respect custom commands. Coverage threshold defaults to 80% (override via project CLAUDE.md).

### Phase 2: Execute

Run detected command. For coverage report:

- Go: `go tool cover -func=coverage.out`
- Bun/Vitest: coverage summary in stdout

Benchmarks only on explicit request (e.g. `go test -bench=. -benchmem ./...`).

### Phase 3: Report

```markdown
## Test Results

- Tests: X passed / Y failed
- Coverage: Z% (threshold: N%)
- Verdict: [passing / issues / failing]

### Package coverage
[per-package breakdown]

### Issues
[failures with root cause]

### Recommended actions
[specific next steps]
```

## Failure Analysis

- Identify root cause, not surface-level message
- Suggest specific fixes
- Recommend adding regression tests for the failure

## Edge Cases

- No tests found → suggest creating test files
- Coverage generation failure → troubleshoot config
- Flaky test → re-run to confirm
- Build error → distinguish compile failure from test failure
