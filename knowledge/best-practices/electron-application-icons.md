---
title: Electronアプリケーションアイコン設定
category: best-practices
tags: [electron, electron-builder, windows, macos, linux, build-configuration]
created: 2025-01-20
updated: 2025-01-21
status: verified
---

# Electronアプリケーションアイコン設定

## 重要ポイント

Electronでカスタムアイコンを表示するには**2箇所**で設定が必要：

1. **electron-builder** - インストーラー/パッケージ用
2. **BrowserWindow** - ランタイムウィンドウ用

この2つは独立しており、一方を設定しても他方には影響しない。

## 必要なファイル

```
resources/
├── icon.ico      # Windows
├── icon.icns     # macOS
└── icon_512.png  # Linux
```

## electron-builder.yml

```yaml
extraResources:
  - from: resources
    to: .
win:
  icon: resources/icon.ico
  signAndEditExecutable: true  # exe本体にアイコン埋め込み
mac:
  icon: resources/icon.icns
linux:
  icon: resources/icon_512.png
```

## BrowserWindow設定

```typescript
function getIconPath(): string {
  if (process.platform === 'win32') {
    return join(__dirname, '../../resources/icon.ico');
  } else if (process.platform === 'darwin') {
    return join(__dirname, '../../resources/icon.icns');
  }
  return join(__dirname, '../../resources/icon_512.png');
}

const mainWindow = new BrowserWindow({
  icon: getIconPath(),  // 全プラットフォームで設定
  // ...
});
```

## よくある問題

### ウィンドウにデフォルトアイコンが表示される

BrowserWindowの`icon`オプションが未設定。全ウィンドウで設定が必要。

### exe本体のアイコンが変わらない

`signAndEditExecutable: true`が未設定。Windows環境ではsymbolic link作成権限も必要な場合がある。

→ 詳細: [electron-icon-not-applied.md](../troubleshooting/electron-icon-not-applied.md)

### ビルドエラー "image must be at least 512x512"

macOSビルドには512x512以上のPNGが必要。

## アイコン作成

```bash
# Windows (.ico)
convert icon.png -define icon:auto-resize=256,128,64,48,32,16 icon.ico

# macOS (.icns) - electron-icon-builder推奨
npx electron-icon-builder --input=./icon.png --output=./resources
```

## 参考

- [electron-builder Icons](https://www.electron.build/icons)
- [BrowserWindow Options](https://www.electronjs.org/docs/latest/api/browser-window)
