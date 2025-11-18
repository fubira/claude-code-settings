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

### Primary Types

| Type | When to Use | Example Subject |
|------|-------------|-----------------|
| `feat` | New feature or capability | feat(auth): add OAuth2 login |
| `fix` | Bug fix | fix(parser): handle null values correctly |
| `docs` | Documentation only | docs: update API usage examples |
| `refactor` | Code restructuring, no behavior change | refactor(api): extract validation logic |
| `perf` | Performance improvement | perf(db): add query result caching |
| `test` | Add or update tests | test(utils): add edge case coverage |

### Secondary Types

| Type | When to Use | Example Subject |
|------|-------------|-----------------|
| `style` | Formatting, whitespace, no code logic change | style: format with prettier |
| `build` | Build system or external dependencies | build: upgrade to webpack 5 |
| `ci` | CI configuration changes | ci: add test coverage reporting |
| `chore` | Maintenance, dependency updates | chore: update dependencies |

## Scope Guidelines

**What is scope?**
- Identifies the affected module, component, or area
- Optional but recommended for clarity

**Good scopes**:
- Module names: `auth`, `api`, `db`, `ui`
- Component names: `Button`, `UserProfile`
- Feature areas: `login`, `checkout`, `dashboard`

**When to omit scope**:
- Changes affect the entire project
- No clear single scope (but consider splitting commit)

**Examples**:
- `feat(auth): add password reset flow`
- `fix(Button): correct hover state styling`
- `docs: update README installation steps` (no scope - affects whole project)

## Subject Guidelines

**Rules**:
- Use imperative mood: "add" not "added" or "adds"
- No period at the end
- Max 50 characters (English) / 25 characters (Japanese)
- Be specific but concise
- Start with lowercase (except proper nouns)

**Good subjects**:
- ✅ `add user authentication`
- ✅ `fix memory leak in image processing`
- ✅ `update API documentation`

**Bad subjects**:
- ❌ `Added new feature` (past tense)
- ❌ `Fixes bug.` (past tense + period)
- ❌ `Update stuff` (too vague)
- ❌ `Fixed the issue where users couldn't login after...` (too long)

## Body Guidelines (Bullets)

**Purpose**: Provide context that `git diff` cannot show

**What to include**:
- **What** changed (high-level, not line-by-line)
- **Why** the change was needed
- **Impact** or benefits of the change

**Language**:
- Japanese is preferred for detailed explanations
- English is fine for short, technical points

**Format**:
- Use bullet points (- or *)
- 3-5 bullets typically sufficient
- Each bullet should be self-contained
- Order: usually what → why → impact

**What NOT to include**:
- ❌ File lists (git already tracks this)
- ❌ Line-by-line changes (use `git show`)
- ❌ Future plans (belongs in issues/roadmap)

## Complete Examples

### Example 1: Feature Addition

```
feat(knowledge): add knowledge management system with progressive disclosure

- 知見管理システムを導入し、Global CLAUDE.mdの肥大化を防止
- Progressive Disclosure: 必要な知見のみを必要な時に読み込む仕組み
- 4つのカテゴリで構造化: Patterns, Troubleshooting, Best Practices, Workflows
- 各カテゴリにINDEX.mdを配置し、検索可能に

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Why this is good**:
- Clear type (`feat`) and scope (`knowledge`)
- Concise subject describes what was added
- Bullets explain what, why, and structure (in Japanese for clarity)
- No file lists

### Example 2: Bug Fix

```
fix(parser): handle null values in JSON parsing

- JSON.parse が null 値を含む配列で失敗する問題を修正
- エッジケースのテストを追加して再発を防止
- ユーザーエラーの原因となっていた主要なバグの解消

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Why this is good**:
- Specific bug description
- Explains what was wrong
- Mentions prevention measure
- Impact on users

### Example 3: Documentation Update

```
docs: update README setup instructions

- Node.js 18以降が必要であることを明記
- 環境変数の設定手順を追加
- トラブルシューティングセクションを拡充

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Why this is good**:
- Clear that only docs changed
- Lists specific improvements
- Helps new users

### Example 4: Refactoring

```
refactor(api): extract validation logic into separate module

- バリデーションロジックを専用モジュールに分離し、再利用性を向上
- 各エンドポイントのコードが簡潔になり、保守性が改善
- テストカバレッジを90%に向上（バリデーション専用テストを追加）

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Why this is good**:
- Clear that behavior didn't change
- Explains the architectural improvement
- Quantifies testing improvement

## Anti-Patterns (What NOT to Do)

### Bad Example 1: Vague

```
chore: update files

- Updated some files
- Fixed things
```

**Problems**:
- Too vague (which files? what things?)
- No context for future developers
- Type probably wrong (should be `fix` or `feat`)

### Bad Example 2: File List

```
feat: new feature

Modified:
- src/app.ts
- src/utils.ts
- src/components/Button.tsx
- test/app.test.ts
```

**Problems**:
- File list is redundant (git tracks this)
- Doesn't explain what or why
- Wastes space

### Bad Example 3: Too Much Detail

```
fix: bug fix

Line 45: Changed `if (x > 0)` to `if (x >= 0)` because the original
condition didn't handle the case where x equals zero which was causing
the function to return undefined instead of the expected value...
```

**Problems**:
- Too detailed (belongs in code comments)
- Can see exact changes in `git diff`
- Hard to skim

### Bad Example 4: Wrong Tense

```
feat(auth): added login functionality

- Added JWT authentication
- Implemented password hashing
- Created user database schema
```

**Problems**:
- Past tense ("added", not "add")
- Should use imperative mood

### Bad Example 5: With Emojis

```
feat: ✨ add cool new feature 🎉

- Feature is super awesome! 😎
- Users will love it ❤️
```

**Problems**:
- Emojis (except attribution) not allowed
- Unprofessional tone
- May break CI/CD parsing

## Type Selection Decision Tree

```
Is it a bug fix?
├─ Yes → fix
└─ No
    │
    Is it a new feature?
    ├─ Yes → feat
    └─ No
        │
        Is it documentation only?
        ├─ Yes → docs
        └─ No
            │
            Is it code restructuring (no behavior change)?
            ├─ Yes → refactor
            └─ No
                │
                Is it a performance improvement?
                ├─ Yes → perf
                └─ No
                    │
                    Is it test-related?
                    ├─ Yes → test
                    └─ No
                        │
                        Is it build/CI config?
                        ├─ Yes → build or ci
                        └─ No → chore
```

## Tips for Writing Good Commit Messages

1. **Write for your future self**
   - In 6 months, will you understand why this change was made?

2. **Focus on "why", not just "what"**
   - The diff shows what changed
   - Your message should explain why

3. **Be specific**
   - "fix login" → "fix login failure with expired tokens"

4. **Keep it concise**
   - Remove unnecessary words
   - Get to the point quickly

5. **Use active voice**
   - "add feature" not "feature was added"

6. **Proofread**
   - Typos in commit messages last forever
   - Check before committing
