# Claude Code: コマンド実行時のセキュリティチェック誤検知

## 症状

Bashツールで `sqlite3` やその他のコマンドを実行する際、以下のような警告が表示されて承認待ちになる：

```
Command contains empty quotes before dash (potential bypass)
```

## 原因

Claude Code内蔵のセキュリティチェックが、コマンド引数内のクォート＋ダッシュの組み合わせをコマンドインジェクションのバイパス手法として検知する。

### トリガーされるパターン

- `'---'`（クォート内にダッシュ）
- `''` の直後に `-` が続くパターン
- SQLリテラル内の `'2025-01%'` のような日付パターンでも発生しうる

### 例：検知される

```bash
sqlite3 db.sqlite "SELECT '--- label ---'; SELECT * FROM t;"
```

### 例：検知されない

```bash
sqlite3 db.sqlite "SELECT '[label]'; SELECT * FROM t;"
```

## 回避策

1. **コマンド出力のラベルにダッシュを使わない** — `'--- label ---'` の代わりに `'[label]'` や `'== label =='` を使う
2. **SQLファイル経由で実行** — `sqlite3 db.sqlite < query.sql`
3. **承認して続行** — 実害はないため、手動承認で続行可能

## 補足

- `Bash(sqlite3:*)` をpermissions allowリストに入れていても発生する
- permissions設定とは別レイヤーの安全性チェックであり、ユーザー側で無効化する手段は現時点で不明
- sqlite3に限らず、あらゆるBashコマンドの引数で同様のパターンがあれば発生する
