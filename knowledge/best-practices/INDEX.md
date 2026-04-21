# Best Practices Index

品質・パフォーマンス・セキュリティ指針。

## ベストプラクティス一覧

| タイトル | カテゴリ | 概要 |
|---------|---------|------|
| [問題解決の原則](problem-solving-principles.md) | Problem Solving | 本質を見極め、対症療法に走らない |
| [Electronセキュリティ](electron-security.md) | Security | nodeIntegration, contextIsolation, IPC入力検証 |
| [改行コード統一管理](line-ending-management.md) | Code Quality | LF必須化、.gitattributes設定 |
| [Electronアイコン設定](electron-application-icons.md) | Build | インストーラー/ウィンドウ両方のアイコン設定 |
| [外部ライブラリのテスト方針](testing-external-libraries.md) | Testing | ライブラリ自体はテストしない、vi.spyOn活用 |
| [Biomeインポートソート方針](biome-import-sorting.md) | Code Quality | グループ順のみ必要、文字順不要。将来の細粒度設定に備える |
| [数値リテラルの目視コピー](numeric-literal-precision-loss.md) | Data Integrity | LLMがログから数値を書き写すと無意識に丸める。必ず自動抽出する |
| [継承パラメータ・公式の妥当性検証](inherited-parameter-audit.md) | Problem Solving | 長期稼働パラメータは見落としになりやすい。異常値はばらつきで片付けず根本調査、公式の意味と実装の一致を検証、「構造的」主張の自己循環を疑う |
