# Patterns Index

Reusable design patterns, architectural solutions, and code structures.

## Quick Navigation

- [TypeScript/React Patterns](typescript-react/)
- [Go Patterns](go/)
- [Cross-stack Patterns](cross-stack/)
- [Electron Patterns](electron/)

## All Patterns

### [Electron IPC通信パターン](electron/ipc-communication.md)

**Tech Stack**: Electron
**Category**: Code Structure
**Added**: 2025-01-19
**Keywords**: IPC, contextBridge, ipcMain, ipcRenderer, preload, security, type-safe

Electronのメインプロセスとレンダラープロセス間の安全で型安全なIPC通信パターン。

---

### [外部プロセス統合パターン](cross-stack/external-process-integration.md)

**Tech Stack**: Cross-stack
**Category**: Code Structure
**Added**: 2025-01-19
**Keywords**: spawn, child_process, Python, external script, command injection, timeout, security

JavaScriptランタイムから外部スクリプトを安全に実行するパターン。

---

### [TypeScript RORO Pattern](typescript-react/roro-pattern.md)

**Tech Stack**: TypeScript/React
**Category**: Code Structure
**Added**: 2025-01-19
**Keywords**: RORO, object parameters, function arguments, readability, maintainability, destructuring, default values

RORO (Receive an Object, Return an Object) parameter passing pattern that improves function readability and maintainability.

---

<!--
Template for new entries:

### [Pattern Name](category/pattern-name.md)

**Tech Stack**: [Cross-stack / TypeScript/React / Go / etc.]
**Category**: [Design Pattern / Architecture / Code Structure / etc.]
**Added**: YYYY-MM-DD
**Keywords**: keyword1, keyword2, keyword3, keyword4

Brief one-sentence description.

---
-->

## Statistics

- Total patterns: 3
- TypeScript/React: 1
- Go: 0
- Cross-stack: 1
- Electron: 1

## Recently Added

1. [TypeScript RORO Pattern](typescript-react/roro-pattern.md) - 2025-01-19
2. [Electron IPC通信パターン](electron/ipc-communication.md) - 2025-01-19
3. [外部プロセス統合パターン](cross-stack/external-process-integration.md) - 2025-01-19

## Most Referenced

None yet.

## Front Matterによる検索

ナレッジベース全体でYAML Front Matterを使った高度な検索が可能です。

### 基本的な検索例

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: patterns" ~/.claude/knowledge/

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
rg "tags:.*typescript" ~/.claude/knowledge/patterns/

# このカテゴリで最近更新されたドキュメント
rg "updated: 2025" ~/.claude/knowledge/patterns/ --files-with-matches
```

詳細な検索方法は [FRONTMATTER.md](../FRONTMATTER.md) を参照してください。
