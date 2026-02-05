---
title: PWA + ローカルデバイス通信パターン
category: patterns
tags: [typescript, react, pwa, service-worker, mqtt, websocket, offline]
created: 2026-01-09
updated: 2026-01-09
status: active
---

# PWA + ローカルデバイス通信パターン

## 概要

PWA（Progressive Web App）とローカルデバイス（localhost）へのWebSocket/MQTT通信を組み合わせるパターン。静的アセットをキャッシュしつつ、ローカルデバイスとのリアルタイム通信を維持する。

## ユースケース

- ローカルPCに接続されたIoTデバイス（Zigbee等）との通信
- 塾・教室など、ネットワーク環境が不安定な場所での使用
- オフライン時も静的アセット（音声、画像）を再生したい場合

## アーキテクチャ

```
[ブラウザ] ----WebSocket----> [localhost:8083] ----> [Zigbee2MQTT] ----> [Zigbeeデバイス]
    |
    +-- Service Worker (Cache First) --> キャッシュされた静的アセット
```

## 実装

### 1. Service Worker（Cache First戦略）

```javascript
// public/sw.js
const CACHE_NAME = 'app-v1';

const STATIC_ASSETS = [
  '/',
  '/sound/push.mp3',
  '/images/logo.png',
  // ... その他の静的アセット
];

// インストール時にキャッシュ
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

// フェッチ時: WebSocket/MQTTはキャッシュしない
self.addEventListener('fetch', (event) => {
  const { request } = event;

  // WebSocket/MQTTはスルー
  if (request.url.includes('/mqtt') || request.url.startsWith('ws')) {
    return;
  }

  event.respondWith(
    caches.match(request).then((cached) => {
      return cached || fetch(request);
    })
  );
});
```

### 2. Service Worker登録

```typescript
// src/main.tsx
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js");
  });
}
```

### 3. PWA Manifest

```json
{
  "name": "アプリ名",
  "display": "fullscreen",
  "orientation": "landscape",
  "start_url": "/",
  "icons": [...]
}
```

### 4. MQTT接続（環境変数経由）

```typescript
// src/hooks/useMqtt.ts
const brokerUrl = import.meta.env.VITE_MQTT_BROKER_URL || "ws://localhost:8083/mqtt";
```

## ポイント

### なぜこのパターンが有効か

1. **localhostへの通信はオフラインでも動作**: ブラウザの「オフライン」判定は外部ネットワークに対するもの。ローカルPCへの通信は影響を受けない
2. **静的アセットがキャッシュされる**: 音声、画像などがキャッシュされることで、外部CDN障害時も再生可能
3. **PWAインストール可能**: フルスクリーン表示、ホーム画面追加が可能

### 注意点

- **キャッシュ更新**: `CACHE_NAME`を更新して古いキャッシュを削除する必要あり
- **WebSocket除外**: `ws://`や`/mqtt`パスをキャッシュ対象から除外すること
- **同一オリジンのみ**: 外部オリジンのリクエストはService Workerの対象外にすることを推奨

## 関連プロジェクト

- sutton-buzzer-quiz: Zigbeeボタンを使った早押しクイズシステム
