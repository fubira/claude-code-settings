# Claude Code グローバル設定

`~/.claude/` に置く個人用の Claude Code 設定。Skills と共有 Knowledge の参照ルールを Git 管理している。

## 構成

```text
~/.claude/
├── CLAUDE.md              # グローバルシステムプロンプト
├── rules/                 # CLAUDE.md と一緒に毎セッション読み込まれる指示
├── skills/                # Personal Skills と Cloudflare / Web 開発スキル
├── skills-disabled/       # Git 管理のみ。必要なプロジェクトへコピーして使う
├── agents/                # サブエージェント定義
├── docs/                  # CLAUDE.md から参照する補足ドキュメント
├── scripts/               # ユーティリティスクリプト
├── settings.example.json  # permissions / statusLine テンプレート
└── .gitignore
```

## セットアップ

Claude Code を使っているマシンでは `~/.claude` に既存のランタイムデータがあり `git clone` できない。既存ディレクトリに履歴を後付けする。

```bash
cd ~/.claude
git init -b main
git remote add origin <repository-url>
git fetch origin
git reset --hard origin/main   # 既存の CLAUDE.md・skills/ は上書きされる
cp settings.example.json settings.json  # 任意。既存の settings.json がある場合は手でマージする
```

## Personal Skills

開発ワークフローを補助する。「起動」列が「自動」のものは条件に合えば自動起動し、「手動」のものはスラッシュコマンドで呼び出す。

以下の表は `scripts/generate-readme-skills.sh` が各 `SKILL.md` の frontmatter から生成する（手で編集しない）。

<!-- BEGIN GENERATED: personal-skills -->
| Skill | Description | 起動 |
|-------|-------------|------|
| [`code-reviewer`](skills/code-reviewer/SKILL.md) | Assists with code review by analyzing code changes for quality, best practices, security, and potential issues. | 自動 |
| [`context-compactor`](skills/context-compactor/SKILL.md) | Analyzes and compacts context-affecting documents (project memory, CLAUDE.md, skill files) to reduce token usage and compaction frequency. | 手動 |
| [`doc-rules`](skills/doc-rules/SKILL.md) | Documentation rules — structure, length, style, and how-to writing. | 自動 |
| [`git-commit-assistant`](skills/git-commit-assistant/SKILL.md) | Assists with careful Git commits in any repository. | 自動 |
| [`handoff`](skills/handoff/SKILL.md) | Session migration for context corruption recovery. | 手動 |
| [`journal-manager`](skills/journal-manager/SKILL.md) | Creates and manages Obsidian work journals. | 自動 |
| [`knowledge-manager`](skills/knowledge-manager/SKILL.md) | Manages a structured knowledge base of patterns, troubleshooting guides, best practices, and workflows. | 自動 |
| [`refactoring-assistant`](skills/refactoring-assistant/SKILL.md) | Assists with code refactoring by detecting code smells, suggesting improvements, and providing refactoring patterns. | 自動 |
| [`release-assistant`](skills/release-assistant/SKILL.md) | Automates and ensures reliable release workflows with automatic version bump based on commit history, mandatory lint/build/test execution before release, and safe tag creation and push. | 自動 |
| [`test-executor`](skills/test-executor/SKILL.md) | Executes tests, analyzes results, and reports coverage for Go and Node/Bun projects. | 自動 |
<!-- END GENERATED: personal-skills -->

## Cloudflare / Web 開発スキル

該当する開発タスクで起動する。Cloudflare 公式ドキュメント参照を優先する構成。

<!-- BEGIN GENERATED: vendored-skills -->
| Skill | Description | 起動 |
|-------|-------------|------|
| [`workers-best-practices`](skills/workers-best-practices/SKILL.md) | Reviews and authors Cloudflare Workers code against production best practices. | 自動 |
| [`wrangler`](skills/wrangler/SKILL.md) | Cloudflare Workers CLI for deploying, developing, and managing Workers, KV, R2, D1, Vectorize, Hyperdrive, Workers AI, Containers, Queues, Workflows, Pipelines, and Secrets Store. | 自動 |
<!-- END GENERATED: vendored-skills -->

## Knowledge

開発中に見つけた汎用的なパターンや解決策は Obsidian Vault の `RESOURCES/AI_KNOWLEDGE/` に蓄積する。CLAUDE.md には含めず、必要なときだけ INDEX.md 経由で参照する。

## 共有時の注意

Git 管理対象は `.gitignore` が正（全除外＋許可リスト方式）。認証情報・個人 permissions・セッション履歴などのランタイムデータは既定で除外される。許可リストを広げるときは、機微情報（認証情報・ローカルパス・個人設定）が混入しないか確認する。
