# Best Practices Index

Standards, conventions, and quality guidelines.

## By Category

### Problem Solving

- [問題解決の原則：本質を見極める](problem-solving-principles.md) - Universal (2025-01-19)

### Testing

- [外部ライブラリのテスト方針](testing-external-libraries.md) - Cross-stack (2025-01-24)

### Performance

None yet.

### Security

- [Electronセキュリティベストプラクティス](electron-security.md) - Electron (2025-01-19)

### Code Quality

- [改行コード統一管理（LF必須化）](line-ending-management.md) - Cross-stack (2025-01-19)

### Build & Configuration

- [Electronアプリケーションアイコン設定の完全ガイド](electron-application-icons.md) - Electron (2025-01-20)

### Documentation

None yet.

## By Tech Stack

### TypeScript/React

None yet.

### Go

None yet.

### Cross-stack

- [問題解決の原則：本質を見極める](problem-solving-principles.md) (2025-01-19)
- [改行コード統一管理（LF必須化）](line-ending-management.md) (2025-01-19)
- [外部ライブラリのテスト方針](testing-external-libraries.md) (2025-01-24)

### Electron

- [Electronセキュリティベストプラクティス](electron-security.md) (2025-01-19)
- [Electronアプリケーションアイコン設定の完全ガイド](electron-application-icons.md) (2025-01-20)

## All Best Practices

### [問題解決の原則：本質を見極める](problem-solving-principles.md)

**Category**: Problem Solving
**Tech Stack**: Universal
**Applicability**: Universal
**Added**: 2025-01-19
**Keywords**: problem solving, debugging, root cause, troubleshooting, methodology

問題の本質を見極めずに対症療法を繰り返さないための原則。手詰まり時に目線を広げ、既知の問題を調査する。

---

### [Electronセキュリティベストプラクティス](electron-security.md)

**Category**: Security
**Tech Stack**: Electron
**Applicability**: Framework-specific
**Added**: 2025-01-19
**Keywords**: security, nodeIntegration, contextIsolation, XSS, command injection, validation, spawn

Electronアプリケーションのセキュリティを確保するための必須設定とコーディングパターン。

---

### [改行コード統一管理（LF必須化）](line-ending-management.md)

**Category**: Code Quality / Development Environment
**Tech Stack**: Cross-stack
**Applicability**: Universal
**Added**: 2025-01-19
**Keywords**: line endings, LF, CRLF, .gitattributes, autocrlf, cross-platform, Windows

クロスプラットフォーム開発で改行コードをLFに統一し、CI/CDでのLintエラーや環境間の不要な差分を防ぐ。

---

### [Electronアプリケーションアイコン設定の完全ガイド](electron-application-icons.md)

**Category**: Build & Configuration
**Tech Stack**: Electron
**Applicability**: Framework-specific
**Added**: 2025-01-20
**Last Updated**: 2025-01-21
**Keywords**: icon, .ico, .icns, .png, electron-builder, BrowserWindow, signAndEditExecutable, extraResources

Electronアプリでカスタムアイコンを正しく表示させるための、インストーラーとランタイムウィンドウの両方の設定方法。exe本体のアイコン設定（`signAndEditExecutable: true`）とWindows環境での注意事項を含む。

---

### [外部ライブラリのテスト方針](testing-external-libraries.md)

**Category**: Testing
**Tech Stack**: Cross-stack
**Applicability**: Universal
**Added**: 2025-01-24
**Keywords**: testing, external libraries, mocking, vi.spyOn, Dexie.js, responsibility separation

外部ライブラリ自体の動作はテスト対象外とし、vi.spyOn()でモックすることで、プロジェクトコードのロジックのみをテストする方針。

---

<!--
Template for new entries:

### [Best Practice Title](practice-name.md)

**Category**: [Testing / Performance / Security / Code Quality / etc.]
**Tech Stack**: [Cross-stack / TypeScript/React / Go / etc.]
**Applicability**: [Universal / Language-specific / Framework-specific]
**Added**: YYYY-MM-DD
**Keywords**: keyword1, keyword2, keyword3, keyword4

Brief one-sentence description.

---
-->

## Statistics

- Total practices: 5
- Problem Solving: 1
- Testing: 1
- Performance: 0
- Security: 1
- Code Quality: 1
- Build & Configuration: 1
- Documentation: 0

## Recently Added

1. [外部ライブラリのテスト方針](testing-external-libraries.md) - 2025-01-24
2. [Electronアプリケーションアイコン設定の完全ガイド](electron-application-icons.md) - 2025-01-20（更新: 2025-01-21）
3. [問題解決の原則：本質を見極める](problem-solving-principles.md) - 2025-01-19
4. [改行コード統一管理（LF必須化）](line-ending-management.md) - 2025-01-19
5. [Electronセキュリティベストプラクティス](electron-security.md) - 2025-01-19

## Most Referenced

None yet.

## Front Matterによる検索

ナレッジベース全体でYAML Front Matterを使った高度な検索が可能です。

### 基本的な検索例

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: best-practices" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 複数条件（TypeScript かつ React）
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# 更新日が2025年3月以降のドキュメント
rg "updated: 2025-0[3-9]|2025-1[0-2]" ~/.claude/knowledge/
```

### カテゴリ固有の検索

```bash
# このカテゴリ内で特定タグを検索
rg "tags:.*security" ~/.claude/knowledge/best-practices/

# このカテゴリで最近更新されたドキュメント
rg "updated: 2025" ~/.claude/knowledge/best-practices/ --files-with-matches
```

詳細な検索方法は [FRONTMATTER.md](../FRONTMATTER.md) を参照してください。
