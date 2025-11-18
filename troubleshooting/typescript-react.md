# TypeScript/React トラブルシューティング

## ⚠️ 注意すべき問題と解決策

### 1. Mantineコンポーネントのハイドレーションエラー

Modal/DrawerのtitleプロパティにJSXを渡すと見出し階層エラー。文字列のみ使用。

```tsx
// ❌ <Modal title={<Title order={3}>タイトル</Title>}>
// ✅ <Modal title="✨ タイトル">
```

### 2. CSS変数未定義エラー

main.tsxでindex.cssを明示的にimport。

```tsx
import './index.css';
```

### 3. Vite minifyはesbuildを使用

terserは別途インストールが必要。esbuild推奨。

```ts
build: { minify: 'esbuild' }
```

### 4. Cloudflare Workers Static Assets

静的サイトはPagesでなくWorkers + Static Assets機能を使用。wrangler.tomlで[assets]設定。

### 5. Mantineテスト環境モック

test/setup.tsで`matchMedia`、`IntersectionObserver`、`ResizeObserver`をモック。

```typescript
Object.defineProperty(window, "matchMedia", {
  writable: true,
  value: (query: string) => ({
    matches: false, media: query, onchange: null,
    addListener: () => {}, removeListener: () => {},
    addEventListener: () => {}, removeEventListener: () => {},
    dispatchEvent: () => false,
  }),
});
```

### 6. localStorage永続化パターン

`useState`初期化関数で読み込み、`useEffect`で保存。try-catchでSSR対応。

```typescript
const [value, setValue] = useState(() => {
  try {
    const saved = localStorage.getItem("key");
    return saved ? JSON.parse(saved) : DEFAULT_VALUE;
  } catch { return DEFAULT_VALUE; }
});

useEffect(() => {
  try { localStorage.setItem("key", JSON.stringify(value)); } catch {}
}, [value]);
```

### 7. React Turnstileのモック

test/mocks.tsでモジュールモック。

```typescript
import { mock } from "bun:test";
mock.module("react-turnstile", () => ({
  Turnstile: ({ onVerify }: { onVerify: (token: string) => void }) => null,
}));
```

### 8. Windows環境でのMCP設定

Windows環境では `npx` を直接実行できないため、`cmd /c` ラッパーが必要。

```json
// ❌ Windows環境でエラーになる設定
{
  "mcpServers": {
    "mcp-ripgrep": {
      "command": "npx",
      "args": ["mcp-ripgrep"]
    }
  }
}

// ✅ Windows環境での正しい設定
{
  "mcpServers": {
    "mcp-ripgrep": {
      "command": "cmd",
      "args": ["/c", "npx", "mcp-ripgrep"]
    }
  }
}
```

**エラーメッセージ例**:

```
[Warning] [mcp-ripgrep] mcpServers.mcp-ripgrep: Windows requires 'cmd /c' wrapper to execute npx
```

**対処法**:

1. `~/.claude.json` を開く
2. 該当するMCPサーバー設定の `command` を `"cmd"` に変更
3. `args` の先頭に `"/c"` を追加
4. Claude Codeを再起動

### 9. MantineのModalでのlockScrollによるレイアウトシフト

Mantineの`Modal`コンポーネントは、デフォルトで背景スクロールをロックする際、`body`に`padding-right`を自動追加してスクロールバー消失によるレイアウトシフトを補正しようとする。しかし、この処理自体がヘッダーなどのレイアウトシフトを引き起こす場合がある。

**問題**:

- モーダル表示時に`body { overflow: hidden; padding-right: XXpx; }`が自動適用される
- スクロールバー領域分の幅変化により、ヘッダーなどの固定要素が伸び縮みする
- 視覚的なチラつきやトランジションが発生

**解決策**:

```tsx
// ✅ lockScroll={false} を設定してレイアウトシフトを防止
<Modal
  opened={opened}
  onClose={onClose}
  lockScroll={false}  // bodyのスタイル変更を無効化
>
  {/* ... */}
</Modal>
```

**トレードオフ**:

- モーダル表示中も背景がスクロール可能になる
- 全画面に近い大きなモーダルの場合は問題ない
- 小さなモーダルで背景スクロールを防ぎたい場合は、CSS側で対処する

**補足（CSS側の対処）**:

```css
/* グローバルスタイルでスクロールバー領域を常に確保 */
html {
  overflow-y: auto;
  scrollbar-gutter: stable;  /* スクロールバー領域を常に確保 */
}
```

## 📝 備忘録更新ルール

1. **新しい問題発見時**: 即座に備忘録セクションに追記
2. **解決策確認時**: 具体的なコード例と理由を記載
3. **重要度分類**: ⚠️（重要）、ℹ️（参考）、🔧（ツール固有）
4. **検索性向上**: 明確なキーワードとタグ付け
5. **Git管理**: 変更履歴はコミットログで管理
