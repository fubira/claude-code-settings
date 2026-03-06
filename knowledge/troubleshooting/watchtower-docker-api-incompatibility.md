---
title: Watchtower Docker API非互換エラー
category: troubleshooting
tags: [docker, watchtower, container, deployment]
created: 2026-03-03
updated: 2026-03-03
status: verified
---

# Watchtower Docker API非互換エラー

## 症状

```
Error response from daemon: client version 1.25 is too old.
Minimum supported API version is 1.44, please upgrade your client to a newer version
```

## 原因

`containrrr/watchtower` は2025年12月にアーカイブされメンテナンス終了。
内蔵Docker ClientのAPIバージョンが1.25のため、Docker v29+（API 1.44以上）で動作しない。

## 解決策

アクティブにメンテされているフォーク `nicholas-fedor/watchtower` に切り替える。

- リポジトリ: https://github.com/nicholas-fedor/watchtower
- イメージ: `ghcr.io/nicholas-fedor/watchtower`

```yaml
# Before
image: containrrr/watchtower

# After
image: ghcr.io/nicholas-fedor/watchtower
```

設定やラベル（`com.centurylinklabs.watchtower.scope` 等）はそのまま互換性あり。

## 代替ツール

- **Dockhand**: https://github.com/izm1chael/Dockhand
  - healthcheck + 自動ロールバック、dry-runモード対応
  - 新しめのプロジェクトだが、更新失敗時の安全性が高い
