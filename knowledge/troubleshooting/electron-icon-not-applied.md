# Electron アプリの exe ファイルにアイコンが反映されない

**Tech Stack**: Electron / electron-builder
**Environment**: Windows 11
**Date Added**: 2025-01-21
**Severity**: Medium

## Symptoms

electron-builder でビルドした Windows 向け exe ファイルのアイコンが、設定ファイルで指定したカスタムアイコンではなく、デフォルトの Electron アイコンのままになる。

- `electron-builder.yml` や `package.json` で `win.icon` を設定しても反映されない
- インストーラーやショートカットのアイコンは正しく設定される
- 実行ファイル本体 (`.exe`) のみアイコンが変わらない

## Root Cause

electron-builder の `signAndEditExecutable` オプションがデフォルトで `false` になっているため、exe ファイルのアイコン埋め込みが行われない。

`signAndEditExecutable: true` を設定すると、内部で使用される `winCodeSign` パッケージが symbolic link を作成しようとするが、Windows のデフォルト設定ではユーザーに symbolic link 作成権限がないため、インストールに失敗する。

```
Error: EPERM: operation not permitted, symlink ...
```

この問題は electron-builder や winCodeSign のバージョンに依存する可能性がある（過去のバージョンでは発生しなかった事例あり）。

## Solution

### ステップ 1: ユーザーに Symbolic Link 作成権限を付与

1. **polsedit** をダウンロード
   - https://qiita.com/ucho/items/c5ea0beb8acf2f1e4772 を参照
   - または公式サイトから入手

2. **polsedit** を管理者権限で実行

3. 以下の設定を変更:
   - `Computer Configuration` → `Windows Settings` → `Security Settings` → `Local Policies` → `User Rights Assignment`
   - `Create symbolic links` を開く
   - 自分のユーザーアカウントを追加

4. **PC を再起動**（重要: 再起動しないと権限が反映されない）

### ステップ 2: electron-builder 設定を更新

`electron-builder.yml` または `package.json` に以下を追加:

```yaml
win:
  icon: resources/icons/icon.ico
  signAndEditExecutable: true
```

または `package.json`:

```json
{
  "build": {
    "win": {
      "icon": "resources/icons/icon.ico",
      "signAndEditExecutable": true
    }
  }
}
```

### ステップ 3: ビルド実行

```bash
# 通常通りビルド実行
npm run build:win
# または
bun run build:win
```

## Verification

ビルドが成功したら、以下を確認:

1. ビルドログに winCodeSign 関連のエラーがないこと
2. `dist/` に生成された `.exe` ファイルを右クリック → プロパティで、アイコンがカスタムアイコンになっていること
3. エクスプローラーで exe ファイルのサムネイルが正しいアイコンで表示されること

## Prevention

新しい Electron プロジェクトを作成する際:

1. Windows 環境では最初から `signAndEditExecutable: true` を設定
2. 開発環境セットアップ時に symbolic link 権限を付与しておく
3. `electron-builder.yml` のテンプレートに含めておく

## Notes

- **管理者権限でのビルドは非推奨**: polsedit による権限付与は、管理者モードでのビルド実行を避けるための解決策
- **根本原因は winCodeSign**: この問題は主に内部で使われている winCodeSign パッケージに起因すると考えられる。electron-builder のバージョンを複数試しても状況が改善しない場合、Windows 側の symbolic link 権限設定を確認すべき（検証時の最新版 26.3.0 を含む 26.0.1～26.3.0 の範囲で問題の発生を確認）
- **signAndEditExecutable: false での試行錯誤**: このオプションを `false` のままで様々な設定を試しても、exe ファイルのアイコンは変更できなかった（インストーラー等のアイコンは変更可能）

## Related Issues

なし（初回エントリ）

## Related Best Practices

- [Electronアプリケーションアイコン設定の完全ガイド](../best-practices/electron-application-icons.md) - アイコン設定の総合的なベストプラクティス

## References

- [Qiita: Windows で mklink を使えるようにする](https://qiita.com/ucho/items/c5ea0beb8acf2f1e4772)
- [electron-builder Documentation](https://www.electron.build/configuration/win.html)
