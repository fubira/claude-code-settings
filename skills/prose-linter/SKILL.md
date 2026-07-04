---
name: prose-linter
description: Reviews prose for AI-generated tone, verbosity, and self-congratulatory language. Rewrites to be plain, concise, and human-sounding. Activates on documentation creation/update or when explicitly requested.
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Prose Linter Skill

文章をレビューし、AI臭さ・冗長さを除去する。人が書いたような簡潔な文章に直す。

## Activation Triggers

- ドキュメント（README.md, CLAUDE.md, AI_KNOWLEDGE 配下等）の作成・更新後（自動）
- 「文章を見直して」「推敲して」等（手動）

## Detection Patterns

3分類（AI-tone phrases / Verbose structure / Self-evident explanations）の NG 例と直し方は `references/patterns.md` を参照。検出フェーズで必ず読む。

## Workflow

1. **対象特定**: 変更されたドキュメントファイルを特定
2. **検出**: `references/patterns.md` のパターンに該当する箇所を洗い出す
3. **修正案提示**: 該当箇所と修正案をユーザーに提示。一括修正はしない
4. **修正実行**: ユーザー承認後に Edit で修正

## Decision Criteria

- **削るか迷ったら削る**。足りなければ後で足せる
- **形容詞・副詞は疑う**。事実と動詞で伝わるなら不要
- **読者は開発者**。背景説明より具体的な手順・仕様を優先
- **原文の意図は変えない**。言い回しだけ直す

## Boundary with doc-maintainer

- **prose-linter（本スキル）**: 文体・語彙のみ。構造や長さには踏み込まない
- **doc-maintainer**: 構造・長さ・メタ情報（章立て、行数制限、時系列情報）

構造の問題を見つけたら doc-maintainer に委ねる。本スキルは文体パスに専念する。
