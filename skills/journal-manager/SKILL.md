---
name: journal-manager
description: Writes and maintains work journals under WORK/ in the Obsidian vault. Use after an experiment or analysis produces a reading that has no permanent home yet, and when consolidating or promoting existing journals. Do not use for ordinary implementation work, progress logs, or findings that already have a destination.
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, Agent, AskUserQuestion]
---

# Journal Manager Skill

**journal は恒久の置き場がまだ無い読みの待機場所。** 昇格させたら削除する。

## Activation Triggers

**Create**: 実験・分析・判断で、既存の恒久ページに収まらない読みが出たとき
**Organize**: `/journal-review`, `/journal-cleanup`、active が 20 を超えたとき

## Journal Location

- **Path**: `WORK/{ORG}_{PROJECT}/journal/YYYY-MM-DD_HHmm_topic.md`（vault root は global CLAUDE.md の「Obsidian」節）
- 日付は JST。topic は短く

## 書く前に昇格先を探す

**先に恒久の置き場を探し、あればそちらへ直接書く。** journal に置くのは行き先が無いものだけ。

| 内容 | 置き場 |
|---|---|
| 会話をまたぐ運用状態・判断待ち | auto memory |
| 方法論・規則・その根拠になる実測値 | `journal/` の親ディレクトリの知見ページ |
| 数値成績・セグメント分析 | 同上 |
| 汎用的な解法 | `AI_KNOWLEDGE/`（`knowledge-manager` Skill 経由） |
| コード差分・作業ログ・進捗 | 書かない |

## 書き方

- 1 ファイル 1 トピック。数値は表で
- **無いと読み手が判断を誤る情報だけ。** 何を誤るかを一文で言えないものは書かない
- 否定した命題（自分の誤りの記録）・検討経緯・将来予定は載せない

### 型

**実験・分析**: 背景 → 条件 → 結果（数値表） → 読み → 次の行動
**判断**: 状況 → 選択肢 → 判断と理由 → 次の行動
**事故対応**: 事象 → 根本原因 → 対処 → 再発防止

## 昇格と削除

内容が恒久ページ・memory・規則へ移ったら **journal ファイルを削除する**。同じ事実が
2 箇所にあると、どちらが正本か分からなくなる。

統合するとき（複数 journal を 1 本にまとめるとき）だけ、元を `archives/` へ移す。
手順は `references/review.md`。

## Directory Structure

```
{project}/journal/
├── *.md              # 昇格先が未定のもの
├── archives/         # 統合前の原本
└── deferred/         # 保留トピック
```

`deferred/` は「いつか」ではなく具体的な再開条件を書く。数値表は統合時も落とさない。
