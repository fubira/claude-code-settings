# Claude Code グローバル設定

個人向け Claude Code 開発環境の設定集。Personal Skills、知見管理システム、MCP サーバー統合により、開発効率とコード品質を向上させる。

## 主要機能

### Personal Skills（Progressive Disclosure）

必要な場面でのみ自動起動する7つの Skill を提供。不要な時はプロンプトに含まれないため、コンテキストを効率的に活用できる。

- **release-assistant**: リリース作業支援（バージョン管理、タグ作成）
- **test-executor**: テスト実行・カバレッジ分析（主にGoプロジェクト向け）
- **git-commit-assistant**: Gitコミット支援（.gitignoreチェック、Conventional Commits生成）
- **code-reviewer**: コードレビュー（品質・セキュリティ・ベストプラクティス分析）
- **refactoring-assistant**: リファクタリング支援（Code Smell検出、パターン提案）
- **doc-maintainer**: ドキュメント品質管理（README.md、CLAUDE.md、コメント）
- **knowledge-manager**: 知見管理（後述）

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

### MCP サーバー統合

2つの MCP サーバーを統合済み。

- **serena**: LSPベースのセマンティックコード検索（調査のみ、編集には使わない）
- **ide**: VSCode診断情報

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
│   └── knowledge-manager/
├── knowledge/             # 知見管理システム
│   ├── README.md          # システム概要
│   ├── patterns/
│   │   └── INDEX.md       # パターン一覧
│   ├── troubleshooting/
│   │   └── INDEX.md
│   ├── best-practices/
│   │   └── INDEX.md
│   └── workflows/
│       └── INDEX.md
├── .mcp.json              # MCP サーバー設定
├── settings.example.json  # permissions 設定テンプレート
└── .gitignore             # 除外設定
```

## セットアップ

### 前提条件

- Claude Code がインストール済み
- Node.js 環境（MCPサーバー用）
- Python/uv 環境（serena用）

### インストール手順

#### 1. リポジトリをクローン

```bash
git clone <repository-url> ~/.claude
```

#### 2. MCP サーバーをインストール

各サーバーのインストール方法：

```bash
# serena
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server

# その他のサーバー（npx経由で自動インストール）
# 設定は .mcp.json を参照
```

#### 3. settings.json を配置（任意）

頻繁に使うコマンドの permissions を事前承認したい場合、テンプレートをコピーしてカスタマイズ。

```bash
cp ~/.claude/settings.example.json ~/.claude/settings.json
```

## 基本的な使い方

### Skills の使用

#### 自動起動

Skills は設定された条件で自動的に起動する。例：

- コード実装後 → `test-executor` がテスト実行を提案
- コミット時 → `git-commit-assistant` が .gitignore チェックとメッセージ生成
- リファクタリング中 → `refactoring-assistant` が Code Smell を検出

#### 手動起動

Skill tool を使用して明示的に呼び出すことも可能。

### Knowledge 管理

#### 知見の記録

開発中に汎用的なパターンや解決策を発見すると、Claude が自動的に記録を提案する。承認するだけで適切なカテゴリに構造化して保存される。

#### 知見の検索

各カテゴリの INDEX.md ファイルから検索するか、Claude に「〜についての知見はあるか？」と尋ねる。

### MCP サーバーの活用

- **コード調査**: serena のシンボル検索、参照検索（編集には使わない）
- **診断情報**: ide で VSCode のエラー・警告を取得

## カスタマイズ

### CLAUDE.md の編集

`~/.claude/CLAUDE.md` を編集して、個人の開発スタイルや指針を追加できる。

### Skills の追加

`~/.claude/skills/` に新しい Skill ディレクトリを作成。`SKILL.md` に以下を定義：

- `name`: Skill 名
- `description`: 起動条件と役割
- `allowed-tools`: 使用可能なツール

### MCP サーバーの追加

`~/.claude/.mcp.json` に新しいサーバー設定を追加。

## 社内共有時の注意事項

### Git 管理対象

以下のファイルは Git で管理し、チーム共有可能：

- `CLAUDE.md`
- `skills/`
- `knowledge/`
- `settings.example.json` - permissions テンプレート
- `.gitignore`

### 除外すべきファイル

以下は個人環境依存のため `.gitignore` で除外：

- `.mcp.json` - ローカルパスを含む
- `settings.json` - 個人の permissions 設定（`settings.example.json` からコピー）
- `.credentials.json` - 認証情報
- `history.jsonl`, `file-history/`, `session-env/` - ランタイムデータ

各メンバーは `settings.example.json` をコピーし、自分の環境に合わせてカスタマイズする。

## 参考リンク

- [Claude Code 公式ドキュメント](https://code.claude.com/docs)
- [Skills 詳細](./skills/)
- [Knowledge 管理システム](./knowledge/README.md)
- [MCP サーバー一覧](https://github.com/modelcontextprotocol/servers)
