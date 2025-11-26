# Troubleshooting Index

Technical issues, error resolutions, and debugging guides.

## By Tech Stack

### Electron

- [Electron アプリの exe ファイルにアイコンが反映されない](electron-icon-not-applied.md) - signAndEditExecutable と Windows symbolic link 権限の問題

### TypeScript/React

- [TypeScript/React トラブルシューティング](typescript-react.md) - Mantineコンポーネント、Vite、Cloudflare Workers、テスト環境等の問題と解決策

### Go

None yet.

### Cross-stack

- [Claude Code "File has been unexpectedly modified" エラー](claude-code-file-modified-error.md) - Windows環境での相対パス使用を中心とした回避策
- [TypeScript/React トラブルシューティング](typescript-react.md) - MCP設定（Windows環境）

## By Severity

### Critical

None yet.

### High

- [Claude Code "File has been unexpectedly modified" エラー](claude-code-file-modified-error.md) - Edit/Writeツールが使用不可になる
- [TypeScript/React トラブルシューティング](typescript-react.md) - Mantineハイドレーションエラー、CSS変数未定義エラー

### Medium

- [Electron アプリの exe ファイルにアイコンが反映されない](electron-icon-not-applied.md) - Windows symbolic link 権限問題
- [TypeScript/React トラブルシューティング](typescript-react.md) - localStorage永続化、モーダルレイアウトシフト

### Low

- [TypeScript/React トラブルシューティング](typescript-react.md) - テストモック、静的サイト設定

## All Issues

### [Electron アプリの exe ファイルにアイコンが反映されない](electron-icon-not-applied.md)

**Tech Stack**: Electron / electron-builder
**Environment**: Windows 11
**Severity**: Medium
**Added**: 2025-01-21
**Keywords**: icon, .ico, signAndEditExecutable, winCodeSign, symbolic link, polsedit, Windows, electron-builder

electron-builder でビルドした exe ファイルにカスタムアイコンが反映されない問題。signAndEditExecutable オプションと Windows の symbolic link 作成権限が原因。polsedit を使用してユーザー権限を付与することで解決。

### [Claude Code "File has been unexpectedly modified" エラー](claude-code-file-modified-error.md)

**Tech Stack**: Cross-stack (Claude Code)
**Environment**: Windows (特に顕著)
**Severity**: High
**Added**: 2025-01-19
**Keywords**: Edit tool, Write tool, relative path, absolute path, whitespace, LSP, Biome, Windows

Windows環境での相対パス使用を中心とした一時的な回避策。Claude Code v1.0.111のバグによりEdit/Writeツールが使用不可になる問題への対処。

### [TypeScript/React トラブルシューティング](typescript-react.md)

**Tech Stack**: TypeScript/React
**Environment**: WSL / Windows / Cloudflare Workers
**Added**: 2024-11-18
**Keywords**: Mantine, hydration, CSS variables, Vite, Cloudflare Workers, localStorage, testing, MCP, Windows

包括的なTypeScript/Reactプロジェクトのトラブルシューティングガイド。Mantineコンポーネント、Vite、Cloudflare Workers、テスト環境、MCP設定等の問題と解決策を含む。

<!--
Template for new entries:

### [Issue Title](issue-name.md)

**Tech Stack**: [TypeScript/React / Go / etc.]
**Environment**: [WSL / Linux / macOS / Windows / Docker / etc.]
**Severity**: [Low / Medium / High / Critical]
**Added**: YYYY-MM-DD
**Keywords**: keyword1, keyword2, keyword3, keyword4

Brief one-sentence description of the issue.

---
-->

## Statistics

- Total issues: 3
- Critical: 0
- High: 3 (Claude Code Edit/Writeエラー、Mantineハイドレーションエラー、CSS変数未定義エラー)
- Medium: 3 (Electron exeアイコン、localStorage永続化、モーダルレイアウトシフト)
- Low: 3 (テストモック、静的サイト設定、その他)

## Recently Added

- 2025-01-21: [Electron アプリの exe ファイルにアイコンが反映されない](electron-icon-not-applied.md)
- 2025-01-19: [Claude Code "File has been unexpectedly modified" エラー](claude-code-file-modified-error.md)
- 2024-11-18: [TypeScript/React トラブルシューティング](typescript-react.md)

## Most Referenced

None yet.

## Front Matterによる検索

ナレッジベース全体でYAML Front Matterを使った高度な検索が可能です。

### 基本的な検索例

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: troubleshooting" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 複数条件（TypeScript かつ React）
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# 更新日が2025年3月以降のドキュメント
rg "updated: 2025-0[3-9]|2025-1[0-2]" ~/.claude/knowledge/
```

### カテゴリ固有の検索

```bash
# このカテゴリ内で特定タグを検索
rg "tags:.*windows" ~/.claude/knowledge/troubleshooting/

# このカテゴリで最近更新されたドキュメント
rg "updated: 2025" ~/.claude/knowledge/troubleshooting/ --files-with-matches
```

詳細な検索方法は [FRONTMATTER.md](../FRONTMATTER.md) を参照してください。
