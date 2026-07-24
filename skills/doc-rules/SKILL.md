---
name: doc-rules
description: Documentation rules — structure, length, style, and how-to writing. Creates, updates, and reviews README.md, CLAUDE.md, INSTALL/how-to docs, and code comments. Keeps docs concise, procedural, and free of AI-tone. Activates after implementing features, when docs are outdated, or on explicit request.
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Doc Rules Skill

## Activation Triggers（起動条件）

- 機能実装後にドキュメントが未更新
- README.md が 150 行超
- Go の public 関数・型に doc コメントが無い
- 「文章を見直して」「推敲して」「ドキュメント整理」等の依頼

## Standards（構造・長さ）

### README.md

- **150 行以内**。現状のみ書く（時系列・変更履歴は書かない）
- 変動する数値は CI バッジ。ハードコードしない
- 必須: Overview / Tech stack / Setup / Structure / Features / Dev commands / License
- 禁止: 詳細な技術解説、使わないプラットフォーム情報、冗長な説明

### CLAUDE.md

- prescriptive（「〜する」）。理想状態を書き、現状報告にしない
- 開発ルールは CLAUDE.md、使い方は README.md（関心の分離）

### コメント

- **Go**: public の関数・型に必須（関数名で始める）。why を書く
- **TS**: public API に JSDoc。型で自明なら省く
- 共通: 現在の挙動のみ。actionable な TODO/FIXME だけ残す

## Workflow（作業手順）

構造 → 文体の順にかける。構造を直してから語り口を整える。

1. **対象特定**: 変更されたドキュメントを特定し、プロジェクトの CLAUDE.md を読む
2. **構造**: 行数・時系列の漏れ・ハードコード数値・章立て・用語の一貫性を直す
3. **文体**: NG 例と直し方の一覧を読み、照らして洗い出す

   [検出パターン](references/patterns.md)

4. **提示と修正**: 該当箇所と修正案を提示し、承認後に Edit（一括修正はしない）
5. **QA**: コードとの整合、リンク、コード例の妥当性を確認

## Decision Criteria（判断基準）

- **削るか迷ったら削る**。足りなければ後で足せる
- **対象・読者・場所を勝手に規定しない**。文書の種類を問わず適用する
- **形容詞・副詞は疑う**。事実と動詞で伝わるなら不要
- **原文の意図は変えない**。言い回しだけ直す
