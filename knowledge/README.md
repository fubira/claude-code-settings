# Knowledge Base

`knowledge-manager` Skill が管理する構造化されたナレッジベース。

## 目的

グローバル CLAUDE.md を肥大化させずにプロジェクト横断的な学びを蓄積する。知見は必要な時だけ参照される（Progressive Disclosure）。

## カテゴリ

| カテゴリ | 内容 | INDEX |
|---------|------|-------|
| patterns | 設計パターン、アーキテクチャ、コード構造 | [INDEX.md](patterns/INDEX.md) |
| troubleshooting | 技術的問題と解決策 | [INDEX.md](troubleshooting/INDEX.md) |
| best-practices | 品質・パフォーマンス・セキュリティ指針 | [INDEX.md](best-practices/INDEX.md) |
| workflows | CI/CD、開発プロセス | [INDEX.md](workflows/INDEX.md) |

## 知見の検索

各カテゴリの INDEX.md から検索するか、Front Matter を使った ripgrep 検索が可能。

```bash
# タグで検索
rg "tags:.*typescript" ~/.claude/knowledge/

# ステータスで検索
rg "status: verified" ~/.claude/knowledge/
```

詳細は [FRONTMATTER.md](FRONTMATTER.md) を参照。

## 知見の追加

`knowledge-manager` Skill が自動的に提案・記録する。手動で追加する場合は、各カテゴリのテンプレートに従う。

テンプレート: `~/.claude/skills/knowledge-manager/templates/`
