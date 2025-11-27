# Front Matter 仕様

全ての知見ファイルに付与するYAML Front Matterの仕様。

## フォーマット

```yaml
---
title: ドキュメントタイトル
category: patterns|troubleshooting|best-practices|workflows
tags: [技術スタック, キーワード...]
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: draft|active|verified|deprecated
---
```

## フィールド

| フィールド | 必須 | 説明 |
|-----------|------|------|
| title | ○ | ドキュメントタイトル |
| category | ○ | カテゴリ名 |
| tags | ○ | 検索用キーワード（小文字ケバブケース） |
| created | ○ | 作成日 |
| updated | ○ | 最終更新日 |
| status | ○ | draft/active/verified/deprecated |

## タグ例

- 技術スタック: `typescript`, `react`, `electron`, `go`
- ドメイン: `testing`, `security`, `performance`
- プラットフォーム: `windows`, `linux`, `macos`
- 汎用: `universal`

## 検索例

```bash
# タグで検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: patterns" ~/.claude/knowledge/

# 検証済みのみ
rg "status: verified" ~/.claude/knowledge/

# 複合条件
rg "tags:.*electron.*security" ~/.claude/knowledge/
```
