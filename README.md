# Claude Code グローバル設定

`~/.claude/` に置く個人用の Claude Code 設定。Skills と共有 Knowledge の参照ルールを Git 管理している。

## 構成

```text
~/.claude/
├── CLAUDE.md              # グローバルシステムプロンプト
├── skills/                # Personal Skills と Cloudflare / Web 開発スキル
├── scripts/               # ユーティリティスクリプト
├── settings.example.json  # permissions テンプレート
└── .gitignore
```

## セットアップ

```bash
git clone <repository-url> ~/.claude
cp ~/.claude/settings.example.json ~/.claude/settings.json  # 任意
```

## Personal Skills

開発ワークフローを補助する。条件に合えば自動起動する。`context-compactor` のみ手動。

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

## Cloudflare / Web 開発スキル

該当する開発タスクで起動する。Cloudflare 公式ドキュメント参照を優先する構成。

| Skill | やること |
|-------|---------|
| `cloudflare` | Workers / Pages / ストレージ / AI / ネットワークの総合リファレンス |
| `wrangler` | Workers CLI の構文・運用 |
| `workers-best-practices` | Workers コードのベストプラクティス点検・執筆 |
| `agents-sdk` | Agents SDK によるステートフルエージェント構築 |
| `durable-objects` | Durable Objects の作成・レビュー |
| `sandbox-sdk` | Sandbox SDK によるコード実行環境構築 |
| `cloudflare-email-service` | Email Sending / Email Routing でのメール送受信 |
| `turnstile-spin` | Turnstile（CAPTCHA）のエンドツーエンド導入 |
| `web-perf` | Core Web Vitals 計測・パフォーマンス分析 |

## Knowledge

開発中に見つけた汎用的なパターンや解決策は Obsidian Vault の `RESOURCES/AI_KNOWLEDGE/` に蓄積する。CLAUDE.md には含めず、必要なときだけ INDEX.md 経由で参照する。

## 共有時の注意

Git 管理対象: `CLAUDE.md`, `skills/`, `settings.example.json`, `.gitignore`

以下は `.gitignore` 済みだが、フォーク時に混入しないよう注意:

- `.credentials.json` — 認証情報
- `.mcp.json` — ローカルパスを含む
- `settings.json` — 個人の permissions
- `history.jsonl`, `sessions/` 等 — ランタイムデータ
