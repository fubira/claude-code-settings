# Claude Code グローバル設定

`~/.claude/` に置く個人用の Claude Code 設定。Skills と Knowledge を Git 管理している。

## 構成

```text
~/.claude/
├── CLAUDE.md              # グローバルシステムプロンプト
├── skills/                # 自動起動する Personal Skills（10個）
├── knowledge/             # 開発中に貯まった知見（オンデマンド参照）
│   ├── patterns/          #   設計パターン
│   ├── troubleshooting/   #   トラブルシュート
│   ├── best-practices/    #   ベストプラクティス
│   └── workflows/         #   CI/CD・開発フロー
├── scripts/               # ユーティリティスクリプト
├── settings.example.json  # permissions テンプレート
└── .gitignore
```

## セットアップ

```bash
git clone <repository-url> ~/.claude
cp ~/.claude/settings.example.json ~/.claude/settings.json  # 任意
```

## Skills 一覧

条件に合えば自動起動する。`context-compactor` のみ手動。

| Skill | やること |
|-------|---------|
| `git-commit-assistant` | .gitignore チェック、Conventional Commits 生成 |
| `release-assistant` | Lint → Test → Version Bump → Tag → Push |
| `test-executor` | テスト実行・カバレッジ確認（主に Go） |
| `code-reviewer` | 品質・セキュリティレビュー |
| `refactoring-assistant` | Code Smell 検出・パターン提案 |
| `doc-maintainer` | README.md / CLAUDE.md の品質管理 |
| `knowledge-manager` | 知見の記録・分類 |
| `journal-manager` | Obsidian 作業ジャーナルの作成・整理 |
| `prose-linter` | AI調・冗長な文章の検出・修正 |
| `context-compactor` | コンテキスト圧縮（`/compact-context`） |

## Knowledge

開発中に見つけた汎用的なパターンや解決策を `knowledge/` に蓄積している。CLAUDE.md には含めず、必要なときだけ INDEX.md 経由で参照する。

## 共有時の注意

Git 管理対象: `CLAUDE.md`, `skills/`, `knowledge/`, `settings.example.json`, `.gitignore`

以下は `.gitignore` 済みだが、フォーク時に混入しないよう注意:

- `.credentials.json` — 認証情報
- `.mcp.json` — ローカルパスを含む
- `settings.json` — 個人の permissions
- `history.jsonl`, `sessions/` 等 — ランタイムデータ
