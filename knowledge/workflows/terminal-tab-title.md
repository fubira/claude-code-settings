---
category: workflows
title: Windows Terminal タブタイトル設定
tags: [terminal, wsl, bash, windows-terminal]
---

# Windows Terminal タブタイトル設定

## 課題

複数の Claude Code セッションを同時に起動すると、どのタブがどの作業かわからなくなる。

## 解決策

`~/.bashrc` に `settitle` 関数を追加し、タブタイトルを任意に変更できるようにする。

## セットアップ

`~/.bashrc` の末尾に追加:

```bash
# Set Windows Terminal tab title
settitle() {
  export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  echo -ne "\033]0;$1\a"
}
```

### 前提環境

- Windows Terminal + WSL (Ubuntu)
- PS1 は Ubuntu 既定の `.bashrc` のカラープロンプト形式をベースにしている。カスタム PS1 を使用している場合は `settitle` 内の PS1 も合わせて変更すること

### 仕組み

1. PS1 からタイトル自動設定部分（`\e]0;user@host: dir\a`）を除去
2. エスケープシーケンス `\033]0;TITLE\a` で任意のタイトルを設定

Ubuntu の既定 `.bashrc` では PS1 にタイトル設定が含まれており、プロンプト表示のたびにタイトルが `user@host: dir` に上書きされる。`settitle` はこの PS1 をタイトル設定なしのものに置き換えることで、手動設定したタイトルを維持する。

## 使い方

```bash
settitle 'Claude - たてやまくん'
settitle 'Claude - API実装'
```

## Claude Code での自動設定

`CLAUDE.md` にセッション開始時の自動設定ルールを記載済み。Claude がプロジェクト名と作業内容からタイトルを判断してタイトルを設定する。

### Bash ツールでの実行方法

Claude Code の Bash ツールは非インタラクティブシェルのため `~/.bashrc` の関数が読み込まれない。`settitle` 関数は使えないので、エスケープシーケンスを直接実行する:

```bash
echo -ne "\033]0;プロジェクト名 - 作業内容\a"
```

## 参考

- https://learn.microsoft.com/ja-jp/windows/terminal/tutorials/tab-title
