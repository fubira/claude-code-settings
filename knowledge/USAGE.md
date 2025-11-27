# Knowledge Management System - Usage Guide

## Overview

This knowledge management system automatically captures and organizes project learnings without bloating your global CLAUDE.md. The `knowledge-manager` Skill handles everything automatically.

## How It Works

### Automatic Knowledge Capture

While working on projects, Claude will:

1. **Detect** valuable insights, patterns, or solutions
2. **Evaluate** them against quality criteria (Reusability, Impact, Learning Value)
3. **Propose** recording them in the appropriate category
4. **Create** structured documentation using templates
5. **Update** INDEX files for easy discovery

You just need to approve or decline the proposals.

## Categories

### Patterns (`patterns/`)

Reusable design patterns, architectural solutions, and code structures.

**Example triggers**:

- "I discovered a better way to structure React components"
- "This goroutine pattern could be useful in other projects"
- "We solved the N+1 query problem with this approach"

### Troubleshooting (`troubleshooting/`)

Technical issues, error resolutions, and debugging guides.

**Example triggers**:

- "After hours of debugging, I found the root cause"
- "This error message is cryptic, but here's what it actually means"
- "Windows-specific issue with MCP configuration"

### Best Practices (`best-practices/`)

Standards, conventions, and quality guidelines.

**Example triggers**:

- "We should always validate input at the boundary"
- "This testing pattern catches more edge cases"
- "Performance improved 10x with this optimization"

### Workflows (`workflows/`)

Process documentation, CI/CD patterns, and operational procedures.

**Example triggers**:

- "Our PR review process is working well"
- "This CI/CD setup prevents most deployment issues"
- "Release checklist that saved us multiple times"

## Manual Usage

### Searching for Knowledge

1. Check the relevant INDEX.md file:
   - `~/.claude/knowledge/patterns/INDEX.md`
   - `~/.claude/knowledge/troubleshooting/INDEX.md`
   - `~/.claude/knowledge/best-practices/INDEX.md`
   - `~/.claude/knowledge/workflows/INDEX.md`

2. Or ask Claude: "Do we have any knowledge about [topic]?"


## Advanced Search with Front Matter

全ての知見ファイルには構造化されたYAML Front Matterが含まれており、ripgrepを使った高度な検索が可能です。

### 基本検索

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: patterns" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 特定の年に作成されたドキュメント
rg "created: 2025" ~/.claude/knowledge/
```

### 複合条件検索

```bash
# TypeScript かつ React関連
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# Electron かつ セキュリティ関連
rg "tags:.*electron.*security" ~/.claude/knowledge/

# 最近更新されたトラブルシューティング
rg "updated: 2025" ~/.claude/knowledge/troubleshooting/

# Windows関連の問題のみ
rg "tags:.*windows" ~/.claude/knowledge/troubleshooting/
```

### ファイルパスのみ取得

```bash
# マッチしたファイルのパスのみ表示
rg "tags:.*testing" ~/.claude/knowledge/ --files-with-matches

# パイプで他のコマンドと組み合わせ
rg "category: patterns" ~/.claude/knowledge/ --files-with-matches | xargs cat
```

### 実用例

```bash
# プロジェクトで使用している技術スタックに関連する全知見を表示
rg "tags:.*(typescript|react|electron)" ~/.claude/knowledge/ -l | while read file; do
  echo "=== $file ==="
  head -20 "$file"
  echo
done

# セキュリティ関連のベストプラクティスをすべて表示
rg "category: best-practices" ~/.claude/knowledge/best-practices/ -l | \
  xargs rg "tags:.*security" -l

# 古いドキュメントを検出（2024年以前に最終更新）
rg "updated: 202[0-4]" ~/.claude/knowledge/ -l
```

詳細なFront Matterフォーマットと検索方法は [FRONTMATTER.md](FRONTMATTER.md) を参照してください。

### Adding Knowledge Manually

If you want to record something specific:

1. Say: "I want to record this pattern/troubleshooting/best-practice/workflow"
2. Claude will guide you through the process using the appropriate template

### Updating Knowledge

When updating existing knowledge:

1. Say: "Update the [knowledge entry name] with [new information]"
2. Claude will read the current entry and make updates preserving the structure

## Quality Criteria

Knowledge is evaluated against:

1. **Reusability**: Can be applied across different projects/tech stacks
2. **Impact**: Significantly improves quality, maintainability, or performance
3. **Learning Value**: Elevates team's technical capabilities

Must score Medium or High on at least 2/3 criteria.

## Templates

Templates ensure consistency:

- `pattern.md`: Design patterns, architectural solutions
- `troubleshooting.md`: Technical issues and resolutions
- `best-practice.md`: Quality and performance guidelines
- `workflow.md`: Process and operational procedures

Templates are located in `~/.claude/skills/knowledge-manager/templates/`

## Benefits

### For You

- **No repetition**: Stop explaining the same things repeatedly
- **Quick reference**: Find solutions to previously solved problems
- **Learning**: Build a personal knowledge base over time

### For Your Team

- **Knowledge sharing**: Team members benefit from each other's discoveries
- **Onboarding**: New members can quickly learn best practices
- **Consistency**: Everyone follows the same patterns and standards

### For Claude

- **Context awareness**: Claude can reference your knowledge automatically
- **Better suggestions**: Makes recommendations based on your established patterns
- **Efficient**: Only loads relevant knowledge when needed (progressive disclosure)

## Maintenance

### Regular Tasks

The `knowledge-manager` Skill handles most maintenance automatically, but you can:

- Review and consolidate duplicate entries
- Archive outdated knowledge
- Update cross-references
- Verify INDEX accuracy

### Archiving

Move low-value or deprecated knowledge to `archive/`:

```bash
mv ~/.claude/knowledge/[category]/old-entry.md ~/.claude/knowledge/archive/deprecated/
```

Update the relevant INDEX.md to remove the archived entry.

## Migration from Old System

If you have knowledge in the old `~/.claude/troubleshooting/` location:

1. Files have been moved to `~/.claude/knowledge/troubleshooting/`
2. INDEX.md has been updated with references
3. Old directory structure has been removed

## Tips

### When to Record

- After solving a non-obvious problem
- When discovering a reusable pattern
- After establishing a new standard
- When documenting a workflow that works

### When NOT to Record

- Project-specific implementation details
- One-off solutions
- Temporary workarounds
- Information already well-documented externally

### Writing Good Knowledge Entries

- **Clear titles**: Make them searchable
- **Concrete examples**: Show, don't just tell
- **Context**: Explain when to use (and when not to)
- **Cross-references**: Link to related knowledge

## Examples

### Good Knowledge Entry

**Title**: "React Component Composition with Render Props"

- Clear, specific title
- Concrete code examples
- Explains when to use vs. hooks
- Links to related patterns

### Poor Knowledge Entry

**Title**: "Fixed a bug"

- Vague title (what bug?)
- No context (when does this apply?)
- No example code
- No cross-references

## Troubleshooting

### Skill Not Activating

- Check: Is `~/.claude/skills/knowledge-manager/SKILL.md` present?
- Verify: Does the description match your use case?
- Try: Explicitly mention "I want to record this knowledge"

### Can't Find Knowledge

- Check: Relevant INDEX.md file up to date?
- Search: Use grep across knowledge directory
- Ask: "Do we have knowledge about [topic]?"

### Wrong Category

- Move: File to correct category directory
- Update: Both old and new INDEX.md files
- Fix: Cross-references in related entries

## Getting Help

For questions or issues:

1. Read: `~/.claude/knowledge/README.md`
2. Check: `~/.claude/skills/knowledge-manager/SKILL.md`
3. Ask: Claude can explain any aspect of the system
