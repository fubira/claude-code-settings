# Knowledge Base

`knowledge-manager` Skill が管理する知見集。CLAUDE.md に入れるほどではないが、次に同じ技術を使うときに役立つ情報を貯めておく場所。

## カテゴリ

| カテゴリ | 内容 | INDEX |
|---------|------|-------|
| patterns | 設計パターン、アーキテクチャ | [INDEX.md](patterns/INDEX.md) |
| troubleshooting | ハマった問題と解決策 | [INDEX.md](troubleshooting/INDEX.md) |
| best-practices | 品質・セキュリティ指針 | [INDEX.md](best-practices/INDEX.md) |
| workflows | CI/CD・開発フロー | [INDEX.md](workflows/INDEX.md) |

## 検索

```bash
rg "tags:.*typescript" ~/.claude/knowledge/   # タグで検索
rg "status: verified" ~/.claude/knowledge/    # ステータスで検索
```

Front Matter の仕様: [FRONTMATTER.md](FRONTMATTER.md)

## 追加方法

`knowledge-manager` Skill が自動提案する。手動で追加する場合はテンプレートに従う: `~/.claude/skills/knowledge-manager/templates/`
