# Front Matter Standard Format

ナレッジベースの全markdownファイルは、以下のYAML Front Matterフォーマットに従う。

## 標準フォーマット

```yaml
---
title: ドキュメントのタイトル
category: パターン|トラブルシューティング|ベストプラクティス|ワークフロー
tags: [技術スタック, キーワード1, キーワード2, ...]
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: draft|active|verified|deprecated
---
```

## フィールド定義

### title（必須）

ドキュメントのタイトル。見出しレベル1（`# タイトル`）と同じ内容を記述する。

### category（必須）

ドキュメントのカテゴリ。以下のいずれかを指定：

- `patterns` - 設計パターン、アーキテクチャ、コード構造
- `troubleshooting` - 技術的問題と解決策
- `best-practices` - 品質・パフォーマンス・セキュリティ指針
- `workflows` - CI/CD、開発プロセス

### tags（必須）

検索性を高めるためのキーワード配列。以下を含める：

- **技術スタック**: `typescript`, `react`, `go`, `electron`, `tauri`, `mantine`, `vite` など
- **ドメイン**: `testing`, `security`, `performance`, `debugging`, `architecture` など
- **プラットフォーム**: `windows`, `linux`, `macos`, `mobile`, `web` など
- **汎用性**: `universal` - 全プロジェクト・全技術スタックで適用可能な知見

タグは小文字のケバブケース（`kebab-case`）で記述する。

### created（必須）

ドキュメントの初回作成日（YYYY-MM-DD形式）。

### updated（必須）

ドキュメントの最終更新日（YYYY-MM-DD形式）。初回作成時は `created` と同じ値。

### status（必須）

ドキュメントの状態。以下のいずれかを指定：

- `draft` - 作成中、検証前
- `active` - 有効、進行中の参考資料
- `verified` - 検証済み、推奨パターン
- `deprecated` - 非推奨、古い情報

## 具体例

### パターン

```yaml
---
title: TypeScript RORO Pattern
category: patterns
tags: [typescript, react, code-structure, parameters]
created: 2025-01-19
updated: 2025-01-19
status: verified
---
```

### トラブルシューティング

```yaml
---
title: TypeScript/React トラブルシューティング
category: troubleshooting
tags: [typescript, react, mantine, vite, windows, mcp]
created: 2025-01-19
updated: 2025-11-24
status: active
---
```

### ベストプラクティス

```yaml
---
title: 問題解決の原則：本質を見極める
category: best-practices
tags: [universal, problem-solving, debugging]
created: 2025-01-19
updated: 2025-01-19
status: verified
---
```

### ワークフロー

```yaml
---
title: GitHub Actions CI/CD セットアップ
category: workflows
tags: [github-actions, ci-cd, automation]
created: 2025-01-20
updated: 2025-01-20
status: verified
---
```

## 検索方法

### ripgrep による検索

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: patterns" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 複数条件（TypeScript かつ パフォーマンス関連）
rg "tags:.*typescript.*performance" ~/.claude/knowledge/

# 更新日が2025年3月以降のドキュメント
rg "updated: 2025-0[3-9]|2025-1[0-2]" ~/.claude/knowledge/
```

### grep による検索（Git Bash / Linux）

```bash
# 特定タグの検索
grep -r "tags:.*windows" ~/.claude/knowledge/

# カテゴリ + タグの複合検索
grep -rl "category: troubleshooting" ~/.claude/knowledge/ | xargs grep "tags:.*electron"
```

## 運用ルール

### 新規ドキュメント作成時

1. Front Matterを必ず記述する
2. `status: draft` で開始し、検証後 `active` または `verified` に変更
3. タグは3〜7個程度が目安（多すぎると検索性が低下）

### 既存ドキュメント更新時

1. `updated` フィールドを現在日付に更新
2. 内容が古くなった場合は `status: deprecated` に変更
3. タグを見直し、不足していれば追加

### 廃止ルール

- `status: deprecated` のドキュメントは削除せず、後方互換性のために残す
- 完全に不要になった場合のみ削除（Gitで履歴は残る）

## INDEX.md の更新

各カテゴリの `INDEX.md` には、Front Matterを活用した検索例を記載する。
