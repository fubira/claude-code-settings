---
title: Claude Code "File has been unexpectedly modified" エラー
category: troubleshooting
tags: [claude-code, windows, bugs, workaround, serena, mcp, cli-patch]
created: 2025-01-19
updated: 2026-01-13
status: active
---

## ⚠️ 注意事項

**これは Claude Code v1.0.111 以降で継続しているクリティカルなリグレッションバグである。**
v2.1.6（2026年1月時点の最新）でも未修正。Edit/Writeツールが完全に使用不可能になるため、代替手段を使用する必要がある。

## Symptoms

Read ツールでファイルを読み取った直後に Edit/Write ツールで編集しようとすると必ず失敗する。

```text
Error: File has been unexpectedly modified. Read it again before attempting to write it.
```

**重要な特徴**:

- 既存ファイルの編集が完全に不可能になる
- Readツール直後でも必ず失敗する
- セッション中に作成したファイルは編集可能
- 環境変数 `CLAUDE_BASH_NO_LOGIN=1` を設定しても効果なし

## Root Cause

Claude Code v1.0.111 で発生したクリティカルな回帰バグ。`cli.js`のファイル変更検出ロジックが壊れている。

### 技術的詳細

1. **タイムスタンプ精度の問題（主要因）**
   - `fs.statSync(path).mtime` と `Date.now()` の比較で誤検出
   - Windows/NTFSのタイムスタンプ精度が異なる
   - Node.js の `mtime` がキャッシュされた古い値を返す場合がある
   - タイミングジッターで「変更された」と誤判定

2. **ファイル状態トラッキングの不具合**
   - Readツールが成功してもEdit/Writeツールがその情報を認識しない
   - 内部的なファイル状態キャッシュがツール呼び出し間で永続化されない

3. **Windows環境での問題（特に顕著）**
   - Git Bash (MINGW64) 環境で特に問題が起きやすい
   - CRLF/LF変換が「変更」として検出される場合もあり

## Solution

### ✅ 推奨1: cli.js にパッチを当てる

**根本的な回避策。タイムスタンプチェックを無効化する。**

⚠️ **注意**: パッチパターンはバージョンごとに変数名が変わる。動作しない場合は Issue #12805 で最新パターンを確認すること。

#### Git Bash (MINGW64) の場合（v2.0.75+）

```bash
CLAUDE_CLI="/c/Users/$USER/AppData/Roaming/npm/node_modules/@anthropic-ai/claude-code/cli.js"

# バックアップ
cp "$CLAUDE_CLI" "${CLAUDE_CLI}.backup"

# パッチ適用
sed -i 's/if(Ew(B)>J.timestamp)return{result:!1,message:"File has been modified since read/if(false)return{result:!1,message:"File has been modified since read/' "$CLAUDE_CLI"
sed -i 's/if(Ew(Y)>W.timestamp)return{result:!1,behavior:"ask"/if(false)return{result:!1,behavior:"ask"/' "$CLAUDE_CLI"
sed -i 's/if(!z||E>z.timestamp)throw Error("File has been unexpectedly modified/if(false)throw Error("File has been unexpectedly modified/' "$CLAUDE_CLI"

echo "Patched! Restart Claude Code."
```

#### PowerShell の場合（v2.0.75+）

```powershell
$cliPath = "$env:APPDATA\npm\node_modules\@anthropic-ai\claude-code\cli.js"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
Copy-Item $cliPath "$cliPath.backup.$timestamp"

$content = Get-Content $cliPath -Raw
$content = $content -replace 'if\(Ew\(B\)>J\.timestamp\)return\{result:!1,message:"File has been modified since read', 'if(false)return{result:!1,message:"File has been modified since read'
$content = $content -replace 'if\(!z\|\|E>z\.timestamp\)throw Error\("File has been unexpectedly modified', 'if(false)throw Error("File has been unexpectedly modified'

Set-Content $cliPath $content -NoNewline
Write-Host "Patched! Restart Claude Code."
```

**注意**: Claude Code のアップデート後は再度パッチを当てる必要がある。SessionStart Hook で自動化することも可能（Issue #12805 参照）。

### ✅ 推奨2: serena MCP のシンボル編集ツールを使用

**パッチを当てられない場合や、より安全な方法を求める場合。**

#### 1. serena の初期化

```bash
# serena をアクティブ化（必須）
mcp__serena__initial_instructions

# プロジェクトをアクティブ化
mcp__serena__activate_project("project-name")
```

#### 2. ファイル編集

serena のシンボル編集ツールを使用：

```typescript
// シンボル単位で編集（クラス、関数、メソッド等）
mcp__serena__replace_symbol_body({
  relative_path: "src/services/auth.ts",
  name_path: "AuthService/login",
  body: "async login(credentials: Credentials): Promise<User> {\n  // 新しい実装\n}"
})

// パターン検索で編集箇所を特定
mcp__serena__search_for_pattern({
  substring_pattern: "export interface SystemInfo",
  relative_path: "src/types"
})
```

**serena の利点**:

- ✅ Claude Code のバグの影響を受けない
- ✅ シンボルレベルの精密な編集が可能
- ✅ 大規模なリファクタリングに適している

### ⚠️ 非推奨: sed/cat での回避策

```bash
# sed を使った直接編集（効率が悪い）
sed -i 's/old/new/g' file.ts

# cat heredoc での書き込み（効率が悪い）
cat > file.ts << 'EOF'
content here
EOF
```

これらの方法は緊急時のみ使用し、通常は推奨1または推奨2を使用すること。

## Related Issues

- [GitHub #12805](https://github.com/anthropics/claude-code/issues/12805) - Open（メイントラッカー、最新パッチ情報あり）
- [GitHub #12462](https://github.com/anthropics/claude-code/issues/12462) - Open（duplicate マーク付き）
- [GitHub #14516](https://github.com/anthropics/claude-code/issues/14516) - Closed（#12462 の duplicate）

## バージョン情報

- **影響バージョン**: v1.0.111 以降
- **確認済み未修正バージョン**: v2.0.55, v2.0.61, v2.0.62, v2.0.64, v2.0.72, v2.0.75, v2.1.6
- **調査日**: 2025-01-19, 2026-01-13
