# Electron Builder + Bun: ネストした依存が含まれない問題

## 概要

- **Tech Stack**: Electron, electron-builder, Bun
- **症状**: パッケージング後のアプリで `Cannot find module 'ms'` などのエラー
- **原因**: Bunとelectron-builderの互換性問題

## 問題の詳細

electron-builderがパッケージング時に依存関係を収集する際、以下のメッセージが表示される：

```
bun does not support any CLI for dependency tree extraction, falling back to NPM node module collector
```

BunはNPM互換の依存ツリー抽出CLIを提供していないため、electron-builderはNPMコレクターにフォールバックする。この際、Bunの `node_modules` 構造とNPMコレクターの期待が一致せず、**ネストした依存**が正しく収集されないことがある。

### 典型的なケース

```
electron-updater
  └── builder-util-runtime
        └── debug
              └── ms  ← これが収集されない
```

## なぜ以前は動いていたか

別のパッケージ（例: `express`）が同じ依存（`debug` → `ms`）を持っていた場合、それらがトップレベルの依存として含まれていたため、偶然動作していた可能性がある。

そのパッケージを削除すると、ネストした依存だけが残り、問題が顕在化する。

## 解決策

### 推奨: 明示的にdependenciesに追加

```bash
bun add ms debug
```

```json
{
  "dependencies": {
    "debug": "^4.4.3",
    "ms": "^2.1.3",
    "electron-updater": "^6.6.2"
  }
}
```

見た目は冗長だが、Bunとelectron-builderの組み合わせでは**正当な回避策**である。

### 代替案

1. **externalizeDepsPluginで除外**: `externalizeDepsPlugin({ exclude: ['debug', 'ms'] })` でバンドルに含める
2. **package-lock.jsonを使用**: NPMコレクターが正しく動作する（ただしBunの利点が失われる）

## 関連リンク

- [electron-builder issue: bun support](https://github.com/electron-userland/electron-builder/issues)
- electron-viteの `externalizeDepsPlugin` の動作

## 教訓

- 未使用の依存を削除する際は、その依存が持っていた**間接的な依存**が他で必要とされていないか確認する
- Bunとelectron-builderの組み合わせでは、ネストした依存の問題に注意する
