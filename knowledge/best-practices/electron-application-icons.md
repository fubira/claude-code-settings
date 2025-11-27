---
title: Electronアプリケーションアイコン設定の完全ガイド
category: best-practices
tags: [electron, electron-builder, windows, macos, linux, build-configuration]
created: 2025-01-20
updated: 2025-01-21
status: verified
---

# Electronアプリケーションアイコン設定の完全ガイド

## 概要

Electronアプリケーションでカスタムアイコンを正しく表示させるには、**2つの異なる場所**で設定が必要である:

1. **インストーラー/パッケージレベル**: electron-builder設定
2. **ランタイムウィンドウレベル**: BrowserWindow設定

この2つは独立しており、一方を設定しても他方には影響しない。アイコンが正しく表示されない問題の多くは、この区別を理解していないことに起因する。

## なぜこの設定が必要か

### 問題の背景

- **インストーラーアイコン**: ユーザーがアプリをインストールする際に表示される
- **ウィンドウアイコン**: アプリ実行中のタイトルバーやタスクバーに表示される
- **インストール済みアプリ一覧**: Windows設定などで表示される

これらはそれぞれ異なるソースから取得されるため、electron-builder.ymlでアイコンを指定しても、BrowserWindowのアイコンは自動的に変更されない。

### 実際に発生した問題

- electron-builder.ymlでアイコンを設定したのに、ウィンドウにはElectronデフォルトアイコンが表示される
- ビルドは成功するが、パッケージにアイコンファイルが含まれていない
- Windows設定の「インストール済みアプリ」でElectronロゴが表示される

## ガイドライン

### DO（推奨事項）

1. **プラットフォーム別の適切なフォーマットを使用する**
   - Windows: `.ico`形式（複数サイズを含む）
   - macOS: `.icns`形式（複数サイズを含む）
   - Linux: `.png`形式（512x512以上推奨）

2. **resources/ディレクトリに配置する**
   - electron-builderの`extraResources`設定により自動的にパッケージに含まれる
   - 実行時にアクセス可能なパスになる

3. **electron-builder.ymlで各プラットフォームのアイコンを指定する**
   ```yaml
   win:
     icon: resources/icon.ico
   mac:
     icon: resources/icon.icns
   linux:
     icon: resources/icon_512.png
   ```

4. **すべてのBrowserWindowインスタンスでアイコンを設定する**
   ```typescript
   function getIconPath(): string {
     if (process.platform === 'win32') {
       return join(__dirname, '../../resources/icon.ico');
     } else if (process.platform === 'darwin') {
       return join(__dirname, '../../resources/icon.icns');
     } else {
       return join(__dirname, '../../resources/icon_512.png');
     }
   }

   const icon = getIconPath();

   const mainWindow = new BrowserWindow({
     width: 900,
     height: 670,
     icon,  // すべてのプラットフォームで設定
     webPreferences: { /* ... */ }
   });
   ```

5. **package.jsonのauthorフィールドを適切に設定する**
   - Windowsの「インストール済みアプリ」の発行元名として使用される
   ```json
   {
     "author": "会社名または開発者名"
   }
   ```

6. **アイコンサイズの要件を満たす**
   - macOSビルドには最低512x512のPNGが必要
   - Windows: 16x16, 32x32, 48x48, 256x256を含む.ico推奨
   - macOS: 16x16から1024x1024までの各サイズを含む.icns推奨

### DON'T（避けるべき事項）

1. **Linux専用の条件分岐でアイコンを設定しない**
   ```typescript
   // ❌ Bad: Linuxでしか表示されない
   const mainWindow = new BrowserWindow({
     ...(process.platform === 'linux' ? { icon } : {})
   });
   ```

2. **PNGファイルをWindows/macOSのアイコンとして使用しない**
   - 各プラットフォームのネイティブフォーマットを使用すること
   - PNG使用時、複数サイズが埋め込まれず、スケーリング品質が低下する

3. **build/ディレクトリにアイコンを配置しない**
   - ビルド成果物用のディレクトリであり、ソースファイルは置かない
   - パッケージングプロセスで含まれない可能性がある

4. **アイコンファイルを重複配置しない**
   - resources/とbuild/icons/の両方に同じファイルを置かない
   - resources/に一本化すること

5. **インストーラーアイコンだけを設定して満足しない**
   - BrowserWindowのアイコンも忘れずに設定すること

## 実装例

### プロジェクト構造

```
project/
├── resources/
│   ├── icon.ico          # Windows用（インストーラー + ランタイム）
│   ├── icon.icns         # macOS用（インストーラー + ランタイム）
│   └── icon_512.png      # Linux用
├── electron-builder.yml
├── package.json
└── src/
    └── main/
        └── index.ts      # BrowserWindow設定
```

### electron-builder.yml

```yaml
appId: com.company.app-name
productName: App Name
publish:
  provider: github
  owner: organization
  repo: repository
  private: true
extraResources:
  - from: resources
    to: .
win:
  executableName: app-name
  icon: resources/icon.ico
  signAndEditExecutable: true
mac:
  icon: resources/icon.icns
  notarize: false
linux:
  icon: resources/icon_512.png
  target:
    - AppImage
    - deb
```

### src/main/index.ts

```typescript
import { BrowserWindow, app } from 'electron';
import { join } from 'path';

/**
 * プラットフォーム別アイコンパス取得
 */
function getIconPath(): string {
  if (process.platform === 'win32') {
    return join(__dirname, '../../resources/icon.ico');
  } else if (process.platform === 'darwin') {
    return join(__dirname, '../../resources/icon.icns');
  } else {
    // Linux - PNG互換性のため
    return join(__dirname, '../../resources/icon_512.png');
  }
}

const icon = getIconPath();

function createWindow(): BrowserWindow {
  const mainWindow = new BrowserWindow({
    width: 900,
    height: 670,
    show: false,
    icon,  // すべてのプラットフォームで設定
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false
    }
  });

  return mainWindow;
}

// 動的に作成されるウィンドウでも同様に設定
function createDynamicWindow(url: string): BrowserWindow {
  const newWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    title: 'Dynamic Window',
    autoHideMenuBar: true,
    icon  // ここでも忘れずに設定
  });

  newWindow.loadURL(url);
  return newWindow;
}
```

### package.json

```json
{
  "name": "app-name",
  "version": "1.0.0",
  "author": "会社名",
  "repository": {
    "type": "git",
    "url": "https://github.com/organization/repository.git"
  }
}
```

## アイコンファイルの作成方法

### Windows (.ico)

複数サイズを含むICOファイルを作成:

```bash
# ImageMagickを使用（推奨）
convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico

# または、オンラインツール
# https://convertio.co/png-ico/
# https://www.icoconverter.com/
```

### macOS (.icns)

複数サイズを含むICNSファイルを作成:

```bash
# iconutilを使用（macOS標準）
mkdir icon.iconset
sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
iconutil -c icns icon.iconset

# または、electron-icon-builderを使用
npx electron-icon-builder --input=./icon.png --output=./resources
```

### Linux (.png)

512x512以上のPNGファイルを用意:

```bash
# sharpを使用してリサイズ（Node.js）
import sharp from 'sharp';

await sharp('icon.png')
  .resize(512, 512, {
    fit: 'contain',
    background: { r: 0, g: 0, b: 0, alpha: 0 }
  })
  .png()
  .toFile('resources/icon_512.png');
```

## よくある問題と解決策

### 問題1: ウィンドウにElectronデフォルトアイコンが表示される

**症状**: electron-builder.ymlでアイコンを設定したが、実行時のウィンドウにElectronのデフォルトアイコンが表示される

**原因**: BrowserWindowのicon optionが未設定、またはLinux専用の条件分岐になっている

**解決策**:
```typescript
// すべてのBrowserWindowインスタンスでiconを設定
const mainWindow = new BrowserWindow({
  icon: getIconPath(),  // プラットフォーム別のパス
  // その他のオプション...
});
```

### 問題2: ビルドエラー "image must be at least 512x512"

**症状**: electron-builderのビルド時にエラーが発生

**原因**: macOSビルドには最低512x512のアイコンが必要

**解決策**: 512x512以上のPNGファイルを用意、またはsharpでリサイズ

### 問題3: パッケージにアイコンファイルが含まれない

**症状**: ビルドは成功するが、実行時にアイコンファイルが見つからない

**原因**: アイコンファイルがextraResourcesで指定されたディレクトリに配置されていない

**解決策**:
1. resources/ディレクトリにアイコンファイルを配置
2. electron-builder.ymlでextraResourcesを設定:
   ```yaml
   extraResources:
     - from: resources
       to: .
   ```
3. ランタイムパスを正しく指定:
   ```typescript
   join(__dirname, '../../resources/icon.ico')
   ```

### 問題4: Windows「インストール済みアプリ」で発行元が"example.com"と表示される

**症状**: Windowsの設定画面で発行元名が正しく表示されない

**原因**: package.jsonのauthorフィールドが適切に設定されていない

**解決策**:
```json
{
  "author": "実際の会社名または開発者名"
}
```

### 問題5: exe ファイル本体のアイコンが Electron デフォルトアイコンのまま

**症状**: インストーラーやショートカットのアイコンは正しく表示されるが、exe ファイル本体のアイコンが Electron デフォルトのまま

**原因**: `signAndEditExecutable: false`（デフォルト）では exe ファイルへのアイコン埋め込みが行われない

**解決策**:
1. electron-builder.yml で `signAndEditExecutable: true` を設定
2. Windows 環境では symbolic link 作成権限が必要な場合がある（後述の「プラットフォーム固有の注意事項」参照）

**詳細**: [Electron アプリの exe ファイルにアイコンが反映されない](../troubleshooting/electron-icon-not-applied.md)

### 問題6: アイコンファイルが重複している

**症状**: build/icons/とresources/に同じファイルが存在

**原因**: 設定の混乱や移行途中の状態

**解決策**:
1. resources/に一本化
2. build/icons/を削除
3. electron-builder.ymlでresources/を参照するように統一

## 検証方法

### 開発環境での確認

1. **ビルドログの確認**
   ```bash
   bun run build:win
   # または
   bun run build:mac
   ```
   - アイコンファイルが正しくコピーされているか確認

2. **パッケージ内容の確認**
   - Windows: `dist/win-unpacked/resources/` にアイコンファイルが存在するか
   - macOS: `dist/mac/YourApp.app/Contents/Resources/` にアイコンファイルが存在するか

3. **実行時の確認**
   - アプリを起動してウィンドウのタイトルバーアイコンを確認
   - タスクバー/Dockのアイコンを確認

### リリース後の確認

1. **インストーラーアイコン**
   - .exeファイルのアイコンを確認（Windows Explorer）
   - .dmgファイルのアイコンを確認（Finder）

2. **インストール後**
   - Windowsスタートメニューのアイコン
   - macOSアプリケーションフォルダのアイコン
   - Windows設定 > アプリ > インストール済みアプリ の一覧

3. **実行中**
   - すべてのウィンドウのタイトルバー
   - タスクバー/Dock
   - Alt+Tabアプリ切り替え画面

## プラットフォーム固有の注意事項

### Windows: symbolic link 作成権限

`signAndEditExecutable: true` を使用する場合、Windows 環境では内部で使用される winCodeSign パッケージが symbolic link を作成しようとします。

**問題**: Windows のデフォルト設定ではユーザーに symbolic link 作成権限がないため、以下のようなビルドエラーが発生する可能性があります：

```
Error: EPERM: operation not permitted, symlink ...
```

**影響**:
- electron-builder のバージョン 26.0.1〜26.3.0（最新版含む）で確認されている
- winCodeSign のインストールに失敗し、結果として exe ファイルにアイコンが埋め込まれない

**解決方法**: 詳細な手順は [Electron アプリの exe ファイルにアイコンが反映されない](../troubleshooting/electron-icon-not-applied.md) を参照してください。

**概要**:
1. polsedit を使用してユーザーに symbolic link 作成権限を付与
2. PC を再起動（権限反映のため必須）
3. `signAndEditExecutable: true` を設定してビルド

### macOS

特別な権限設定は不要です。通常通り `.icns` ファイルを指定するだけで動作します。

### Linux

特別な権限設定は不要です。通常通り `.png` ファイルを指定するだけで動作します。

## 関連リソース

- [electron-builder公式ドキュメント - Icons](https://www.electron.build/icons)
- [Electron公式ドキュメント - BrowserWindowOptions](https://www.electronjs.org/docs/latest/api/browser-window#new-browserwindowoptions)
- [electron-icon-builder](https://github.com/jaretburkett/electron-icon-builder)
- [ImageMagick](https://imagemagick.org/)

## チェックリスト

アイコン設定を実装・変更する際のチェックリスト:

- [ ] 各プラットフォーム用のアイコンファイルを作成（.ico, .icns, .png）
- [ ] アイコンファイルをresources/ディレクトリに配置
- [ ] electron-builder.ymlでwin/mac/linuxの各セクションにicon指定
- [ ] electron-builder.ymlのwinセクションで`signAndEditExecutable: true`を設定
- [ ] Windows環境の場合、symbolic link作成権限を確認・付与
- [ ] electron-builder.ymlでextraResourcesにresourcesディレクトリを指定
- [ ] package.jsonのauthorフィールドを適切に設定
- [ ] src/main/index.tsでgetIconPath()関数を実装
- [ ] すべてのBrowserWindowインスタンスでiconオプションを設定
- [ ] ローカルビルドでパッケージ内容を確認（resources/に含まれているか）
- [ ] アプリ実行時にウィンドウアイコンが正しく表示されるか確認
- [ ] インストーラーアイコンが正しく表示されるか確認
- [ ] **exe ファイル本体のアイコンが正しく表示されるか確認**（Windows）
- [ ] インストール後のアプリ一覧で正しく表示されるか確認

## 技術スタック

- Electron
- electron-builder
- TypeScript
- Node.js

## 関連ファイル例

- `electron-builder.yml` - ビルド設定
- `src/main/index.ts` - メインプロセス
- `package.json` - アプリメタデータ
- `resources/icon.ico` - Windowsアイコン
- `resources/icon.icns` - macOSアイコン
- `resources/icon_512.png` - Linuxアイコン

## 関連トラブルシューティング

- [Electron アプリの exe ファイルにアイコンが反映されない](../troubleshooting/electron-icon-not-applied.md) - Windows環境での symbolic link 権限問題と解決策
