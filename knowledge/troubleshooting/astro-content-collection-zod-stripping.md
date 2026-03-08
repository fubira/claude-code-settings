---
title: Astro Content Collection — Zodスキーマが未定義フィールドを除去する
category: troubleshooting
tags: [astro, zod, content-collection, ssg]
created: 2026-03-09
updated: 2026-03-09
status: verified
---

# Astro Content Collection — Zodが未定義フィールドを除去する

## 症状

- JSONデータソースに存在するフィールドが、Astroコンポーネントで `undefined` になる
- `getCollection()` で取得したデータから特定のフィールドが消えている
- データファイル自体は正しいのに、ビルド結果に反映されない

## 原因

Astro Content Collectionは `content.config.ts` で定義したZodスキーマでデータをバリデーションする。**Zodの `z.object()` はデフォルトで `strip` モード** — スキーマに定義されていないフィールドをサイレントに除去する。エラーは出ない。

```typescript
// content.config.ts
const items = defineCollection({
  schema: z.object({
    name: z.string(),
    // "hidden" フィールドは未定義 → サイレントに除去される
  }),
});
```

```json
// data/items/example.json
{ "name": "foo", "hidden": true }
```

```astro
---
const entries = await getCollection("items");
console.log(entries[0].data.hidden); // undefined — Zodが除去済み
---
```

## 対策

### 推奨: スキーマにフィールドを追加する

データソースに存在するフィールドは全て `content.config.ts` のスキーマに定義する。後から追加されたフィールドは特に漏れやすい。

```typescript
schema: z.object({
  name: z.string(),
  hidden: z.boolean().optional(), // optional にすれば既存データとも互換
}),
```

### 代替: passthrough() を使う（非推奨）

`z.object({}).passthrough()` で未知フィールドを保持できるが、型安全性が失われるため非推奨。

## チェックリスト

JSONデータソースにフィールドを追加した際:

1. `content.config.ts` のスキーマに対応するフィールドを追加
2. `site/src/lib/types.ts` 等のTypeScript型定義も更新
3. Astroキャッシュをクリアしてビルド確認: `rm -rf site/node_modules/.astro`

## 実例

tateyamakunプロジェクトで `buildDailySummary()` に `skipped`、`ev`、`finalOdds` 等のフィールドを追加したが、`content.config.ts` のスキーマに反映しなかった。結果、サイト上で全ベットが実購入として表示された（`skipped` フラグが除去されフィルタが効かなかった）。サマリーJSON自体は正しく、Zodスキーマの更新漏れが原因だった。
