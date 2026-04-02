---
title: GHCR + Watchtower 自動デプロイ
category: workflows
tags: [docker, ghcr, watchtower, github-actions, ci-cd]
created: 2026-02-28
updated: 2026-02-28
status: verified
---

# GHCR + Watchtower 自動デプロイ

GitHub Actions で Docker イメージを GHCR にプッシュし、自宅サーバの Watchtower が自動検知して再起動する構成。

## 構成

```
git tag v1.0.0 → GitHub Actions → GHCR push → Watchtower (5min poll) → container restart
```

## GitHub Actions ワークフロー

```yaml
name: Build and Push Docker Image

on:
  push:
    tags:
      - "v*"

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: <owner>/<app>

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/metadata-action@v5
        id: meta
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=semver,pattern={{version}}
            type=raw,value=latest
      - uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

## docker-compose.yml（サーバ側）

```yaml
services:
  app:
    image: ghcr.io/<owner>/<app>:latest
    restart: unless-stopped
    labels:
      - "com.centurylinklabs.watchtower.scope=<app>"

  watchtower:
    image: ghcr.io/nicholas-fedor/watchtower
    restart: unless-stopped
    environment:
      WATCHTOWER_SCOPE: <app>
      WATCHTOWER_POLL_INTERVAL: "300"
      WATCHTOWER_CLEANUP: "true"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/.docker/config.json:/config.json:ro
    command: --scope <app>
```

## サーバ側セットアップ

```bash
# GHCR認証（PAT に read:packages 権限が必要）
echo "<PAT>" | docker login ghcr.io -u <user> --password-stdin

# 起動
docker compose pull && docker compose up -d
```

## 注意事項

- **タグの打ち直し禁止**: GHCR に既にプッシュ済みのタグを削除して再作成すると `unknown blob` エラーになる。バージョンを上げて新タグを切ること
- **GITHUB_TOKEN で認証**: 追加シークレット不要（`packages: write` permission を明示するだけ）
- **Watchtower スコープ**: `--scope` で監視対象を限定し、他のコンテナに影響しないようにする
- **GHCR パッケージは初回プライベート**: サーバ側で `docker login` が必要

## Dockerfile Tips（Bun + Python）

- `oven/bun:1` には `python3.12` パッケージがない → `uv python install` を使う
- `better-sqlite3` 等のネイティブモジュールは `make g++ python3` が必要
