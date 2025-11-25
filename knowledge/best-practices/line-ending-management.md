# 改行コード統一管理（LF必須化）

**Category**: Code Quality / Development Environment
**Tech Stack**: Cross-stack
**Applicability**: Universal
**Added**: 2025-01-19

## 概要

クロスプラットフォーム開発（特にWindows環境を含む）で改行コードをLFに統一し、CI/CDでのLintエラーや環境間の不要な差分を防ぐ。

## 問題

- Windows のデフォルト設定（`core.autocrlf=true`）により、チェックアウト時にLFがCRLFに変換される
- CI/CD環境（Linux）とローカル環境（Windows）で改行コードが異なり、Lintエラーが発生
- Git diff に改行コードの差分が大量に表示される

## 解決策

3つの設定を組み合わせて改行コードを完全に統一する。

### 1. `.gitattributes` の設定

```gitattributes
# Auto detect text files and normalize line endings to LF
* text=auto eol=lf

# Explicitly declare text files
*.js text eol=lf
*.ts text eol=lf
*.tsx text eol=lf
*.json text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
*.md text eol=lf
*.css text eol=lf

# Denote all files that are truly binary
*.png binary
*.jpg binary
*.exe binary
```

### 2. Git のローカル設定

```bash
# プロジェクトローカルで autocrlf を無効化
git config --local core.autocrlf false

# 既存ファイルを再正規化
git add --renormalize .
git rm --cached -r .
git reset --hard HEAD
```

### 3. フォーマッター設定

**Biome** (`biome.json`):

```json
{
  "formatter": {
    "lineEnding": "lf"
  }
}
```

**Prettier** (`.prettierrc`):

```json
{
  "endOfLine": "lf"
}
```

## 推奨ワークフロー

新規プロジェクト作成時：

1. `.gitattributes` をプロジェクトルートに配置
2. `git config --local core.autocrlf false` を実行
3. フォーマッター設定に `lineEnding: "lf"` を追加
4. 全ファイルをフォーマット実行
5. コミット・プッシュ

既存プロジェクト移行時：

1. `.gitattributes` を追加
2. Git設定を変更
3. `git add --renormalize .` で既存ファイルを再正規化
4. フォーマッター設定を追加
5. コミット・プッシュ（大量の改行変更が発生するため、専用コミットを推奨）

## 検証

```bash
# ファイルの改行コードを確認（Windowsの場合）
git ls-files --eol

# 期待される出力: すべてのテキストファイルが "i/lf w/lf"
```

## 注意事項

- **チーム全体で統一が必須**: 一部のメンバーのみ設定すると効果が薄い
- **既存プロジェクトでの移行は慎重に**: 改行コード変更コミットが大量の差分を生む
- **バイナリファイルの明示**: `.gitattributes` でバイナリファイルを明示的に指定

## 参考資料

- [Git Documentation - gitattributes](https://git-scm.com/docs/gitattributes)
- [Dealing with line endings - GitHub Docs](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)
