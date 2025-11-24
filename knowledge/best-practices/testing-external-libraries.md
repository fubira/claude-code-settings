# 外部ライブラリのテスト方針

**Category**: Testing
**Tech Stack**: Cross-stack
**Applicability**: Universal
**Added**: 2025-01-24
**Keywords**: testing, external libraries, mocking, vi.spyOn, Dexie.js, responsibility separation

## 原則

外部ライブラリ自体の動作はテスト対象外とし、プロジェクトコード側のロジックのみをテストする。

## 理由

1. **責任分離**: ライブラリの動作保証はライブラリ開発者の責任
2. **保守性向上**: ライブラリの内部実装に依存しないテスト
3. **実行速度**: 重い初期化処理（fake-indexeddb等）が不要
4. **問題回避**: vi.mockのホイスティング問題などを回避

## 実装パターン

### Dexie.js（IndexedDB ORM）の例

❌ **Bad: ライブラリ自体をテスト**

```typescript
// fake-indexeddbで実際のDexieインスタンスを作成
import { indexedDB } from 'fake-indexeddb';
Dexie.dependencies.indexedDB = indexedDB;

test('データを保存できる', async () => {
  await db.betRecords.add(record);
  const result = await db.betRecords.toArray();
  expect(result).toEqual([record]);
});
```

**問題点**:
- Dexie.jsの動作をテストしている（不要）
- vi.mockのホイスティング問題が発生しやすい
- fake-indexeddbの初期化コストがかかる

✅ **Good: プロジェクトコードのロジックのみテスト**

```typescript
// vi.spyOn()でdbメソッドをモック
test('putBetRecords は bulkPut を呼び出す', async () => {
  const records = [record1, record2];
  const bulkPutSpy = vi.spyOn(db.betRecords, 'bulkPut')
    .mockResolvedValue('test-2');

  await putBetRecords(records);

  expect(bulkPutSpy).toHaveBeenCalledWith(records);
});
```

**利点**:
- operations.tsのロジック（正しいメソッド・引数で呼び出しているか）のみを検証
- Dexie.jsの動作は信頼
- vi.mockホイスティング問題を回避
- テスト実行が高速

## 適用例

### 1. HTTP クライアント（axios, fetch）

```typescript
const fetchSpy = vi.spyOn(global, 'fetch')
  .mockResolvedValue(new Response(JSON.stringify(data)));

await fetchData();

expect(fetchSpy).toHaveBeenCalledWith('/api/endpoint');
```

### 2. ストレージライブラリ（localforage, idb-keyval）

```typescript
const setSpy = vi.spyOn(store, 'set').mockResolvedValue();

await saveData('key', value);

expect(setSpy).toHaveBeenCalledWith('key', value);
```

### 3. 日付ライブラリ（dayjs, date-fns）

```typescript
vi.spyOn(dayjs.prototype, 'format').mockReturnValue('2024-01-01');

const result = formatDate(date);

expect(result).toBe('2024-01-01');
```

## ガイドライン

1. **外部ライブラリは信頼する**: ライブラリ自体の動作検証は不要
2. **インターフェースをテスト**: 正しいメソッド・引数で呼び出されているか
3. **戻り値をモック**: 期待する戻り値を設定し、コードの動作を検証
4. **vi.spyOn() を優先**: vi.mock()のホイスティング問題を避ける

## 実装例

プロジェクト: `codearts-patrecord-tauri`
ファイル: `src/features/patrecord/services/database/operations.test.ts`

Dexie.jsを使用したIndexedDB操作のラッパー関数をテスト。Dexie.js自体の動作はテスト対象外とし、vi.spyOn()で各dbメソッドをモックして、プロジェクトコードのロジック（適切なメソッド・引数で呼び出しているか）のみを検証している。

## 関連知見

- 問題解決の原則：本質を見極める（problem-solving-principles.md）

## 更新履歴

- 2025-01-24: 初版作成
