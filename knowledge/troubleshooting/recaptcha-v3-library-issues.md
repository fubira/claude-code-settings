---
title: "reCAPTCHA v3: react-google-recaptcha-v3 ライブラリの問題と解決策"
category: troubleshooting
tags: [react, nextjs, recaptcha, google-api]
created: 2026-02-05
updated: 2026-02-05
status: active
---

# reCAPTCHA v3: react-google-recaptcha-v3 ライブラリの問題と解決策

## 問題

`react-google-recaptcha-v3` ライブラリを使用すると、以下のエラーが発生することがある：

```
Invalid site key or not loaded in api.js: [サイトキー]
```

### 症状

- ブラウザの Console で直接 `grecaptcha.execute()` を呼び出すとトークンが取得できる
- しかしライブラリの `executeRecaptcha()` を使うとエラーになる
- サーバー側で `browser-error` が返される

## 原因

`react-google-recaptcha-v3` ライブラリが内部で何らかの問題を起こしている可能性がある（古いAPI、初期化タイミングなど）。

## 解決策

ライブラリを使わず、直接 Google の reCAPTCHA API を呼び出す。

### 実装例

```tsx
import Script from "next/script";
import { useState } from "react";

// グローバル型定義
declare global {
  interface Window {
    grecaptcha: {
      ready: (callback: () => void) => void;
      execute: (siteKey: string, options: { action: string }) => Promise<string>;
    };
  }
}

const RECAPTCHA_SITE_KEY = process.env.NEXT_PUBLIC_RECAPTCHA_SITE_KEY || "";

function ContactForm() {
  const getRecaptchaToken = (): Promise<string> => {
    return new Promise((resolve, reject) => {
      if (typeof window === "undefined" || !window.grecaptcha) {
        reject(new Error("reCAPTCHA not loaded"));
        return;
      }
      window.grecaptcha.ready(() => {
        window.grecaptcha
          .execute(RECAPTCHA_SITE_KEY, { action: "contact" })
          .then(resolve)
          .catch(reject);
      });
    });
  };

  const onSubmit = async (form: FormData) => {
    const recaptchaToken = await getRecaptchaToken();
    // フォーム送信処理
  };

  // ...
}

function Contact() {
  return (
    <>
      <Script
        src={`https://www.google.com/recaptcha/api.js?render=${RECAPTCHA_SITE_KEY}`}
        strategy="lazyOnload"
      />
      {/* コンテンツ */}
    </>
  );
}
```

## 関連トラブルシューティング

### Vercel + さくらインターネット SMTP で 550 エラー

```
550 5.7.1 <email@example.com>... Command rejected
```

**原因**: さくらインターネットの「国外IPアドレスフィルタ」が有効になっている。Vercel のサーバーは海外にあるため拒否される。

**解決策**: さくらインターネットのコントロールパネルで「国外IPアドレスフィルタ」を無効にする。

## 環境変数

- `NEXT_PUBLIC_RECAPTCHA_SITE_KEY`: クライアント側で使用するサイトキー
- `RECAPTCHA_SECRET_KEY`: サーバー側で検証に使用するシークレットキー

## 参考

- [Google reCAPTCHA v3 ドキュメント](https://developers.google.com/recaptcha/docs/v3)
- [Next.js Script コンポーネント](https://nextjs.org/docs/pages/building-your-application/optimizing/scripts)
