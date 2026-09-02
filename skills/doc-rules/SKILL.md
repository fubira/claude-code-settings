---
name: doc-rules
description: Documentation rules — what earns a place on the page, plus structure, length, style, and how-to writing. Use when writing or revising a README, CLAUDE.md, INSTALL, how-to, design note, knowledge entry or release note, or when asked to review prose for AI-tone or trim it down. Do not use for code comments or commit messages in ordinary edits.
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Doc Rules Skill

## Activation Triggers（起動条件）

- 機能実装後にドキュメントが未更新
- README.md が 150 行超
- Go の public 関数・型に doc コメントが無い
- 「文章を見直して」「推敲して」「ドキュメント整理」等の依頼

## Inclusion Gate（書く前の関門）

削る判断は事後には効きにくい。書かれた文は一行ずつ見ればどれも正しく、削る側だけが根拠を求められるため、残る方に倒れる。書く前に一項目ずつ通す。

- その行が無いと読み手が何を間違えるかを一文で言えるか。言えないなら書かない
- 読み手がその場で取る行動が変わるか。変わらない背景・経緯・検討過程は書かない
- コード・型・設定ファイル・`git log` から読めることは書かない
- 作業でわかったことではなく、読み手が要ることを書く。ドキュメントは作業ログではない

## 変更を語る文が混ざる理由

書き手は「経緯」ではなく「根拠」だと思って書いている。だから「検討経緯を載せない」という分類名の規則では止まらない。止まるのは語彙の名指しと、消してみる検査だけ。

背景にあるのは宛先の取り違えで、間違えた本人が書くときに強く出る —— 規則を述べる仕事と、間違っていたことの始末をつける仕事を、同じ文章にさせている。

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

- **書くか迷ったら書かない。削るか迷ったら削る**。足りなければ後で足せる
- **対象・読者・場所を勝手に規定しない**。文書の種類を問わず適用する
- **形容詞・副詞は疑う**。事実と動詞で伝わるなら不要
- **原文の意図は変えない**。言い回しだけ直す
