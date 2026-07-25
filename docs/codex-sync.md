# Codex 設定との同期

`~/.claude/CLAUDE.md` と `~/.codex/AGENTS.md`（リポジトリ `fubira/codex-agent-settings`）は対になる。
両者が同じ判断をするよう、ミラー対象セクションは同一文面を保つ。片方を変更したらもう片方も同じターンで更新する。

## ミラー対象

基本情報 / 出力スタイル / Personal Skills（起動方針の段落のみ）/ アシスト対象 /
作業方針（コーディング・テスト・能力の能動的活用・委譲・軽微な判断の自律実行・行動規範）/
技術スタック / Git / ドキュメント・コメント / Obsidian

## ミラーしない（ハーネス固有）

Bash ツール節、CLAUDE.md とメモリの管理ポリシー、MCP サーバー、同期節そのもの。

Plugins・MCP の掃除手順・同期の詳細は `~/.claude/.claude/CLAUDE.md`（設定リポジトリのプロジェクト指示）に置く。ユーザー設定の CLAUDE.md には載せない。

## 固有差分の対応表

| 項目 | Claude | Codex |
|------|--------|-------|
| 指示ファイル | `CLAUDE.md` | `AGENTS.md` |
| Skill の手動専用化 | frontmatter `disable-model-invocation: true` | `agents/openai.yaml` の `policy.allow_implicit_invocation: false` |
| サブエージェント定義 | `~/.claude/agents/*.md` | `~/.codex/agents/*.toml` |
| サブエージェント呼び出し | `Agent` ツール | `spawn_agent` |
| Herdr 操作手順 | `herdr` Skill | `AGENTS.md` の「委譲」節に直接記載 |
| 軽量モデルの表現 | Sonnet / Haiku | 軽量モデル |
| リリース Skill | `release-assistant` | `release` |
| 異常時のセッション復旧 | `/rewind` または `/handoff` | 新しいセッションへ移行し、一次情報から再開 |
| メモリ | `MEMORY.md` 全行が常時プロンプトに載る（80行予算） | `memories/` + SQLite、関連時に検索注入 |
| コマンド権限 | `settings.json` の `permissions.allow` / `deny` | `rules/*.rules` の `prefix_rule`。sandbox・書込パス・ネットワークは別設定で1対1にならない |
