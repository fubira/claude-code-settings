# Electronセキュリティベストプラクティス

**Category**: Security
**Tech Stack**: Electron
**Date Added**: 2025-01-19
**Applicability**: Framework-specific

## Overview

Electronアプリケーションのセキュリティを確保するための必須設定とコーディングパターン。

## Rationale

ElectronはWebコンテンツからNode.js APIへのアクセスを許可するため、不適切な設定ではXSS攻撃、コマンドインジェクション、任意コード実行などの深刻な脆弱性につながる。

## Guidelines

### Do

- `nodeIntegration: false` を設定（デフォルト）
- `contextIsolation: true` を設定（デフォルト）
- PreloadスクリプトでcontextBridgeを使用
- IPCハンドラーで入力バリデーション実施
- `spawn()` 使用時は引数を配列で渡す
- ユーザー入力をサニタイズ

### Don't

- レンダラープロセスでNode.js APIを直接使用しない
- `nodeIntegration: true` を設定しない
- ユーザー入力を直接コマンドに含めない
- 外部コンテンツを信頼しない

## Examples

### Good Example: 安全なBrowserWindow設定

```typescript
const mainWindow = new BrowserWindow({
  webPreferences: {
    nodeIntegration: false,        // デフォルト
    contextIsolation: true,         // デフォルト
    preload: path.join(__dirname, 'preload.js')
  }
})
```

### Good Example: IPC入力バリデーション

```typescript
ipcMain.handle('set-mode', (_event, mode: string) => {
  const validModes = ['authentication', 'achievement', 'pdf']

  if (!validModes.includes(mode)) {
    throw new Error(`Invalid mode: ${mode}`)
  }

  cardManager.setMode(mode as AppMode)
})
```

### Good Example: 安全なコマンド実行

```typescript
// ✅ Good: 引数を配列で渡す
spawn('python3', ['script.py', '--uid', uid])

// ❌ Bad: 文字列結合（コマンドインジェクションリスク）
spawn(`python3 script.py --uid ${uid}`)
```

### Bad Example: nodeIntegration有効化

```typescript
// ❌ 危険: レンダラーから任意のNode.js APIにアクセス可能
const mainWindow = new BrowserWindow({
  webPreferences: {
    nodeIntegration: true  // セキュリティリスク
  }
})
```

## Implementation Steps

1. BrowserWindowで `nodeIntegration: false`, `contextIsolation: true` を確認
2. Preloadスクリプトを作成し、contextBridgeでAPIを公開
3. IPCハンドラーに入力バリデーションを追加
4. 外部プロセス実行時は引数配列を使用

## Common Pitfalls

- 開発時の便利さのために `nodeIntegration: true` を有効化してしまう
- バリデーションを省略し、レンダラーからの入力を信頼してしまう
- 文字列結合でコマンドを構築してしまう

## Verification

- `nodeIntegration: false` が設定されているか確認
- `contextIsolation: true` が設定されているか確認
- IPCハンドラーに入力チェックが存在するか確認
- `spawn()` で引数配列を使用しているか確認

## Related Practices

- [Electron IPC Patterns](../patterns/electron/ipc-communication.md)

## References

- [Electron Security Checklist](https://www.electronjs.org/docs/latest/tutorial/security)
