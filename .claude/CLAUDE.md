# claude-code-settings（`~/.claude`）

Claude Code のユーザー設定リポジトリ。ここでの作業にだけ必要な運用ルールを置く。全プロジェクト共通のルールは `~/.claude/CLAUDE.md`（ユーザー設定）にある。

## Plugins

有効な Plugin は `settings.json` の `enabledPlugins` で管理する。LSP（TypeScript / Go / Rust）と `frontend-design` が常用。PR レビューはビルトイン `/code-review`。

## MCP サーバー

利用しない方針のため、誤って追加されたときは掃除する。手順はメモリの「MCP 削除時の掃除ポイント」を参照。

## Codex 設定との同期

`~/.codex/AGENTS.md`（リポジトリ `fubira/codex-agent-settings`）と対になる。ミラー対象セクションは同一文面を保ち、片方を変更したらもう片方も同じターンで更新する。対象範囲と固有差分の対応表は `docs/codex-sync.md`。

Skill も両者で対になっている（`~/.claude/skills/` と `~/.codex/skills/`）。片方の運用ルールを変えたら、対応する Skill も同じターンで揃える。
