---
title: Electron IPC通信パターン
category: patterns
tags: [electron, ipc, security, typescript]
created: 2025-01-19
updated: 2025-01-19
status: verified
---

# Electron IPC通信パターン

## Problem

Electronアプリケーションでは、セキュリティ上の理由からメインプロセスとレンダラープロセスが分離されている。両者間でデータをやり取りする際、安全で型安全な通信パターンが必要。

## Solution

PreloadスクリプトでcontextBridgeを使用し、2つの標準パターンを実装する：

1. **リクエスト/レスポンス型**: 非同期データ取得
2. **イベント送信型**: 一方向のイベント通知

## Implementation

### パターン1: リクエスト/レスポンス型

```typescript
// Main Process
import { ipcMain } from 'electron'

ipcMain.handle('get-data', async (_event, arg: string) => {
  // バリデーション
  if (!isValidInput(arg)) {
    throw new Error('Invalid input')
  }

  return await fetchData(arg)
})

// Preload
import { contextBridge, ipcRenderer } from 'electron'

contextBridge.exposeInMainWorld('electron', {
  getData: (arg: string) => ipcRenderer.invoke('get-data', arg)
})

// Renderer
const data = await window.electron.getData('example')
```

### パターン2: イベント送信型

```typescript
// Main Process
mainWindow.webContents.send('event-name', { data: 'value' })

// Preload
contextBridge.exposeInMainWorld('electron', {
  onEvent: (callback: (data: any) => void) => {
    ipcRenderer.on('event-name', (_event, data) => callback(data))
  }
})

// Renderer
window.electron.onEvent((data) => {
  console.log(data)
})
```

## Benefits

- **セキュリティ**: contextBridgeによる安全なAPI公開
- **型安全性**: TypeScriptで完全な型チェック
- **保守性**: 標準パターンによる一貫性

## Trade-offs

- Preloadスクリプトの追加ファイルが必要
- 両方向通信には2つのパターンを組み合わせる必要がある

## When to Use

- 全てのElectronアプリケーション
- メインプロセスの機能をレンダラーから呼び出す場合
- レンダラーにイベントを通知する場合

## When Not to Use

- Node.js単体アプリケーション（Electronでない場合）

## Related Patterns

- [Electron Security Best Practices](../../best-practices/electron-security.md)

## References

- [Electron IPC Official Docs](https://www.electronjs.org/docs/latest/tutorial/ipc)
