# Workflows Index

Process documentation, CI/CD patterns, and operational procedures.

## By Category

### CI/CD

None yet.

### Code Review

None yet.

### Release Management

None yet.

### Development Process

None yet.

## All Workflows

Currently no workflows documented. Workflows will be listed here as they are established.

<!--
Template for new entries:

### [Workflow Title](workflow-name.md)

**Category**: [CI/CD / Code Review / Release Management / etc.]
**Tools**: [GitHub Actions / Git / etc.]
**Applicability**: [Universal / Project-specific]
**Added**: YYYY-MM-DD
**Keywords**: keyword1, keyword2, keyword3, keyword4

Brief one-sentence description.

---
-->

## Statistics

- Total workflows: 0
- CI/CD: 0
- Code Review: 0
- Release Management: 0
- Development Process: 0

## Recently Added

None yet.

## Most Referenced

None yet.

## Front Matterによる検索

ナレッジベース全体でYAML Front Matterを使った高度な検索が可能です。

### 基本的な検索例

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: workflows" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 複数条件（TypeScript かつ React）
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# 更新日が2025年3月以降のドキュメント
rg "updated: 2025-0[3-9]|2025-1[0-2]" ~/.claude/knowledge/
```

### カテゴリ固有の検索

```bash
# このカテゴリ内で特定タグを検索
rg "tags:.*ci-cd" ~/.claude/knowledge/workflows/

# このカテゴリで最近更新されたドキュメント
rg "updated: 2025" ~/.claude/knowledge/workflows/ --files-with-matches
```

詳細な検索方法は [FRONTMATTER.md](../FRONTMATTER.md) を参照してください。
