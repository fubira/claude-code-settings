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

開発ワークフローを補助する。「起動」列が「自動」のものは条件に合えば自動起動し、「手動」のものはスラッシュコマンドで呼び出す。

以下の表は `scripts/generate-readme-skills.sh` が各 `SKILL.md` の frontmatter から生成する（手で編集しない）。

<!-- BEGIN GENERATED: personal-skills -->
| Skill | Description | 起動 |
|-------|-------------|------|
| [`code-reviewer`](skills/code-reviewer/SKILL.md) | Assists with code review by analyzing code changes for quality, best practices, security, and potential issues. | 自動 |
| [`context-compactor`](skills/context-compactor/SKILL.md) | Analyzes and compacts context-affecting documents (project memory, CLAUDE.md, skill files) to reduce token usage and compaction frequency. | 手動 |
| [`doc-maintainer`](skills/doc-maintainer/SKILL.md) | Maintains high-quality, concise, project-aligned documentation. | 自動 |
| [`git-commit-assistant`](skills/git-commit-assistant/SKILL.md) | Assists with careful Git commits in any repository. | 自動 |
| [`handoff`](skills/handoff/SKILL.md) | Session migration for context corruption recovery. | 手動 |
| [`journal-manager`](skills/journal-manager/SKILL.md) | Creates and manages Obsidian work journals. | 自動 |
| [`knowledge-manager`](skills/knowledge-manager/SKILL.md) | Manages a structured knowledge base of patterns, troubleshooting guides, best practices, and workflows. | 自動 |
| [`prose-linter`](skills/prose-linter/SKILL.md) | Reviews prose for AI-generated tone, verbosity, and self-congratulatory language. | 自動 |
| [`refactoring-assistant`](skills/refactoring-assistant/SKILL.md) | Assists with code refactoring by detecting code smells, suggesting improvements, and providing refactoring patterns. | 自動 |
| [`release-assistant`](skills/release-assistant/SKILL.md) | Automates and ensures reliable release workflows with automatic version bump based on commit history, mandatory lint/build/test execution before release, and safe tag creation and push. | 自動 |
| [`test-executor`](skills/test-executor/SKILL.md) | Executes tests, analyzes results, and reports coverage for Go and Node/Bun projects. | 自動 |
<!-- END GENERATED: personal-skills -->

## Cloudflare / Web 開発スキル

該当する開発タスクで起動する。Cloudflare 公式ドキュメント参照を優先する構成。

<!-- BEGIN GENERATED: vendored-skills -->
| Skill | Description | 起動 |
|-------|-------------|------|
| [`agents-sdk`](skills/agents-sdk/SKILL.md) | Build AI agents on Cloudflare Workers using the Agents SDK. | 自動 |
| [`cloudflare-email-service`](skills/cloudflare-email-service/SKILL.md) | Send and receive transactional emails with Cloudflare Email Service (Email Sending + Email Routing). | 自動 |
| [`cloudflare`](skills/cloudflare/SKILL.md) | Comprehensive Cloudflare platform skill covering Workers, Pages, storage (KV, D1, R2), AI (Workers AI, Vectorize, Agents SDK), feature flags (Flagship), networking (Tunnel, Spectrum), security (WAF, DDoS), and infrastructure-as-code (Terraform, Pulumi). | 自動 |
| [`durable-objects`](skills/durable-objects/SKILL.md) | Create and review Cloudflare Durable Objects. | 自動 |
| [`sandbox-sdk`](skills/sandbox-sdk/SKILL.md) | Build sandboxed applications for secure code execution. | 自動 |
| [`turnstile-spin`](skills/turnstile-spin/SKILL.md) | Set up Cloudflare Turnstile end-to-end in a project: scan the codebase, create the widget via the Cloudflare API, deploy the managed siteverify Worker, write the frontend snippets, validate, and persist the skill. | 自動 |
| [`web-perf`](skills/web-perf/SKILL.md) | Analyzes web performance using Chrome DevTools MCP. | 自動 |
| [`workers-best-practices`](skills/workers-best-practices/SKILL.md) | Reviews and authors Cloudflare Workers code against production best practices. | 自動 |
| [`wrangler`](skills/wrangler/SKILL.md) | Cloudflare Workers CLI for deploying, developing, and managing Workers, KV, R2, D1, Vectorize, Hyperdrive, Workers AI, Containers, Queues, Workflows, Pipelines, and Secrets Store. | 自動 |
<!-- END GENERATED: vendored-skills -->

## Knowledge

開発中に見つけた汎用的なパターンや解決策は Obsidian Vault の `RESOURCES/AI_KNOWLEDGE/` に蓄積する。CLAUDE.md には含めず、必要なときだけ INDEX.md 経由で参照する。

## 共有時の注意

Git 管理対象は `.gitignore` が正（全除外＋許可リスト方式）。認証情報・個人 permissions・セッション履歴などのランタイムデータは既定で除外される。許可リストを広げるときは、機微情報（認証情報・ローカルパス・個人設定）が混入しないか確認する。
