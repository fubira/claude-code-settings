# Claude Code "File has been unexpectedly modified" エラー

**Tech Stack**: Cross-stack (Claude Code)
**Environment**: Windows (特に顕著)
**Date Added**: 2025-01-19
**Severity**: High

## ⚠️ 注意事項

**これは Claude Code v1.0.111 のバグに対する一時的な回避策です。**
将来のバージョンで修正される予定のため、以下の対処は暫定的なものとして扱ってください。

## Symptoms

Read ツールでファイルを読み取った直後に Edit/Write ツールで編集しようとすると失敗する。

```
Error: File has been unexpectedly modified. Read it again before attempting to write it.
```

- 既存ファイルの編集が完全に不可能になる
- セッション中に作成したファイルは編集可能
- 相対パスで一度編集した後は絶対パスでも成功する場合がある

## Root Cause

Claude Code v1.0.111 で発生した回帰バグ。複数の原因が特定されています：

### 1. ホワイトスペース認識の問題（主要因）

Read ツールがタブ文字とスペースを視覚的に区別できず、Claude が推測して編集を試みるため実際のファイルと不一致が発生。

### 2. Windows環境でのパス処理の問題

- 絶対パス（`C:/path/to/file.ts`）→ 失敗
- 相対パス（`src/file.ts`）→ 成功

### 3. ファイル状態キャッシュのバグ

既存ファイルの状態が正しく初期化されない。

### 4. LSP/フォーマッターによる悪化

BiomeやPrettier等のLSPがバックグラウンドで自動修正を行うと、上記の問題がさらに悪化する可能性がある（主原因ではない）。

## Solution

### ✅ 推奨: 相対パスの使用（Windows環境）

**Windows環境では積極的に相対パスを使用する**ことで、多くのケースで問題を回避できます。

```typescript
// ❌ 絶対パス（失敗しやすい）
Read: C:/Users/user/project/src/components/Button.tsx

// ✅ 相対パス（成功しやすい）
Read: src/components/Button.tsx
```

**実装方法**:

1. プロジェクトルートからの相対パスを使用
2. Claude に「相対パスで編集してください」と明示的に指示
3. 必要に応じて現在のディレクトリ構造を提示

### ⚙️ 補助策1: LSP/フォーマッターの無効化

BiomeやPrettier等のLSP拡張機能を一時的に無効化：

**Biomeの場合**:

`.vscode/settings.json`:

```json
{
  "biome.lspBin": null,
  "editor.codeActionsOnSave": {
    "source.organizeImports.biome": "never"
  }
}
```

`biome.json`:

```json
{
  "assist": {
    "actions": {
      "source": {
        "organizeImports": "off"
      }
    }
  }
}
```

その後、VSCodeを完全再起動（リロードではなく完全終了）。

### ⚙️ 補助策2: バージョンダウン

最終動作版にダウングレード：

```bash
# Claude Code v1.0.100 へのダウングレード
npm install -g @anthropic/claude-code@1.0.100
```

### ⚙️ 補助策3: ホワイトスペースの明示

`cat -A` 等で正確なホワイトスペース文字を確認してから編集：

```bash
cat -A src/components/Button.tsx
```

## Verification

以下のテストで問題が解消されたか確認：

1. **既存ファイルの読み取り**（相対パス）:

   ```
   Read: src/preload/index.ts
   ```

2. **即座に編集を試行**:

   ```
   Edit: src/preload/index.ts（コメント追加など簡単な変更）
   ```

3. **エラーが出なければ成功**

## Prevention

### 短期的対策（バグ修正まで）

- ✅ **Windows環境では相対パスを優先使用**
- ⚠️ LSP/フォーマッター拡張機能の設定を確認
- ⚠️ Claude Codeのバージョン更新情報を定期的に確認

### 長期的対策（バグ修正後）

- Claude Codeの最新版へのアップデート
- LSP/フォーマッター設定を元に戻す
- この回避策を削除

## Related Issues

- GitHub anthropics/claude-code #10882: VSCode拡張でのEdit失敗
- GitHub anthropics/claude-code #7443: 絶対パスでの失敗報告
- GitHub anthropics/claude-code #7457, #11463: 同様の報告多数

## References

- [GitHub Issue #10882](https://github.com/anthropics/claude-code/issues/10882) - ホワイトスペース問題の特定
- [GitHub Issue #7443](https://github.com/anthropics/claude-code/issues/7443) - パス形式問題の検証
- [Biome Organize Imports](https://biomejs.dev/assist/actions/organize-imports/) - LSP設定リファレンス

## バージョン情報

- **発生バージョン**: Claude Code v1.0.111〜
- **最終動作バージョン**: v1.0.100
- **調査日**: 2025-01-19
- **ステータス**: 一時的回避策のみ（根本修正待ち）
