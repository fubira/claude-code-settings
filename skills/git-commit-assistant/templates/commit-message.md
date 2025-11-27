# Commit Message Template & Guidelines

## Standard Template

```
<type>(<scope>): <subject>

- <bullet point 1: what changed>
- <bullet point 2: why the change was needed>
- <bullet point 3: impact or benefits>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Type Selection

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature or capability | feat(auth): add OAuth2 login |
| `fix` | Bug fix | fix(parser): handle null values correctly |
| `docs` | Documentation only | docs: update API usage examples |
| `refactor` | Code restructuring, no behavior change | refactor(api): extract validation logic |
| `perf` | Performance improvement | perf(db): add query result caching |
| `test` | Add or update tests | test(utils): add edge case coverage |
| `style` | Formatting, whitespace | style: format with prettier |
| `build` | Build system or dependencies | build: upgrade to webpack 5 |
| `ci` | CI configuration changes | ci: add test coverage reporting |
| `chore` | Maintenance tasks | chore: update dependencies |

## Subject Guidelines

- Use imperative mood: "add" not "added" or "adds"
- No period at the end
- Max 50 characters
- Be specific but concise

## Body Guidelines

**Include**:
- **What** changed (high-level)
- **Why** the change was needed
- **Impact** or benefits

**Avoid**:
- File lists (git tracks this)
- Line-by-line changes (use `git show`)

## Examples

### Feature Addition

```
feat(knowledge): add knowledge management system

- 知見管理システムを導入し、Global CLAUDE.mdの肥大化を防止
- Progressive Disclosure: 必要な知見のみを必要な時に読み込む仕組み
- 4つのカテゴリで構造化: Patterns, Troubleshooting, Best Practices, Workflows

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Bug Fix

```
fix(parser): handle null values in JSON parsing

- JSON.parse が null 値を含む配列で失敗する問題を修正
- エッジケースのテストを追加して再発を防止

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Refactoring

```
refactor(api): extract validation logic into separate module

- バリデーションロジックを専用モジュールに分離し、再利用性を向上
- 各エンドポイントのコードが簡潔になり、保守性が改善

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Anti-Patterns

| Pattern | Problem |
|---------|---------|
| `chore: update files` | Too vague |
| File lists in body | Redundant (git tracks this) |
| Past tense ("added") | Use imperative mood |
| Emojis in subject | May break CI/CD parsing |
