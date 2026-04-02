# Claude Code グローバル設定

個人向け Claude Code 開発環境の設定集。Personal Skills、知見管理システムにより、開発効率とコード品質を向上させる。

## 主要機能

### Personal Skills（Progressive Disclosure）

必要な場面でのみ自動起動する9つの Skill を提供。不要な時はプロンプトに含まれないため、コンテキストを効率的に活用できる。

- **release-assistant**: リリース作業支援（バージョン管理、タグ作成）
- **test-executor**: テスト実行・カバレッジ分析（主にGoプロジェクト向け）
- **git-commit-assistant**: Gitコミット支援（.gitignoreチェック、Conventional Commits生成）
- **code-reviewer**: コードレビュー（品質・セキュリティ・ベストプラクティス分析）
- **refactoring-assistant**: リファクタリング支援（Code Smell検出、パターン提案）
- **doc-maintainer**: ドキュメント品質管理（README.md、CLAUDE.md、コメント）
- **knowledge-manager**: 知見管理（後述）
- **journal-manager**: Obsidian作業ジャーナルの作成・整理
- **context-compactor**: コンテキスト圧縮（手動起動のみ）

### Knowledge 管理システム

プロジェクト横断的な学びを構造化して蓄積。グローバル CLAUDE.md を肥大化させることなく、必要な時だけ関連知見を参照できる。

#### カテゴリ構成

- **patterns/**: 設計パターン、アーキテクチャ、コード構造
- **troubleshooting/**: 技術的問題と解決策
- **best-practices/**: 品質・パフォーマンス・セキュリティ指針
- **workflows/**: CI/CD、開発プロセス

#### Progressive Disclosure の仕組み

1. 開発中に汎用的なパターンや解決策を発見すると、`knowledge-manager` Skill が自動提案
2. 承認すると、適切なカテゴリ・テンプレートで構造化して記録
3. 後続のタスクで関連する知見が必要な場合のみ、INDEX.md から検索して参照
4. 不要な知見はコンテキストに含まれないため、効率的

## ディレクトリ構造

```text
~/.claude/
├── CLAUDE.md              # グローバルシステムプロンプト
├── skills/                # Personal Skills
│   ├── test-executor/
│   ├── git-commit-assistant/
│   ├── code-reviewer/
│   ├── refactoring-assistant/
│   ├── release-assistant/
│   ├── doc-maintainer/
│   ├── knowledge-manager/
│   ├── journal-manager/
│   └── context-compactor/
├── scripts/               # ユーティリティスクリプト
├── knowledge/             # 知見管理システム
│   ├── README.md
│   ├── patterns/
│   ├── troubleshooting/
│   ├── best-practices/
│   └── workflows/
├── settings.example.json  # permissions 設定テンプレート
└── .gitignore             # 除外設定
```

## セットアップ

### 前提条件

- Claude Code がインストール済み

### インストール手順

#### 1. リポジトリをクローン

```bash
git clone <repository-url> ~/.claude
```

#### 2. settings.json を配置（任意）

頻繁に使うコマンドの permissions を事前承認したい場合、テンプレートをコピーしてカスタマイズ。

```bash
cp ~/.claude/settings.example.json ~/.claude/settings.json
```

## 基本的な使い方

### Skills の使用

Skills は設定された条件で自動的に起動する。例：

- コード実装後 → `test-executor` がテスト実行を提案
- コミット時 → `git-commit-assistant` が .gitignore チェックとメッセージ生成
- リファクタリング中 → `refactoring-assistant` が Code Smell を検出

Skill tool を使用して明示的に呼び出すことも可能。

### Knowledge 管理

開発中に汎用的なパターンや解決策を発見すると、Claude が自動的に記録を提案する。各カテゴリの INDEX.md ファイルから検索するか、Claude に「〜についての知見はあるか？」と尋ねる。

## カスタマイズ

- **CLAUDE.md**: `~/.claude/CLAUDE.md` を編集して開発スタイルや指針を追加
- **Skills**: `~/.claude/skills/` に新しいディレクトリを作成し `SKILL.md` を定義
- **MCP サーバー**: `~/.claude/.mcp.json` に設定を追加

## 社内共有時の注意事項

### Git 管理対象

- `CLAUDE.md`, `skills/`, `knowledge/`, `settings.example.json`, `.gitignore`

### 除外すべきファイル

- `.mcp.json` - ローカルパスを含む
- `settings.json` - 個人の permissions 設定
- `.credentials.json` - 認証情報
- `history.jsonl`, `file-history/`, `session-env/` - ランタイムデータ

## 参考リンク

- [Claude Code 公式ドキュメント](https://code.claude.com/docs)
- [Skills 詳細](./skills/)
- [Knowledge 管理システム](./knowledge/README.md)
