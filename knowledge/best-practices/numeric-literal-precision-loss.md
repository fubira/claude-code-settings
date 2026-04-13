---
title: 数値リテラルの目視コピーによる精度劣化
category: best-practices
tags: [universal, llm-workflow, ml, numerical-precision, data-integrity]
created: 2026-04-13
updated: 2026-04-13
status: verified
---

# 数値リテラルの目視コピーによる精度劣化

## 核心原則

**他プロセスの出力（ログ、画面表示、ドキュメント）に記載された数値を、コード中のリテラルとして手で打ち込まない。必ず source-of-truth からプログラムで抽出する。**

LLM（自分を含む）は、数値を「見て」「書き写す」とき、読みやすい桁数に無意識で丸める。これは意図しない精度劣化で、コードレビューでは検知できない。

## 起きる現象

1. 外部プロセス（Optuna trial log、ベンチマーク出力、API レスポンスのスクリーンショット、etc.）に full-precision の数値が出力されている
2. LLM がその数値を Python dict / JSON / config ファイルの literal として打ち込む
3. このとき `0.7302700512037856` → `0.73`、`8.715701573782917e-06` → `8.72e-06` のように目視で丸める
4. 丸めた literal は「意味的には同じ値」に見えるが、**実際の計算結果は異なる**
5. その literal を使って学習/推論/シミュレーションすると、元の数値で得られた結果が再現しない

## 実例: LightGBM HP の精度劣化（boatrace-tipster 2026-04-13）

### 発生経路

Optuna 500-trial 探索の log に trial #294 のベストパラメータが full precision で出力されていた:

```
'subsample': 0.7302700512037856,
'colsample_bytree': 0.6240721896783721,
'reg_alpha': 8.715701573782917e-06,
'reg_lambda': 0.09885538716630769,
'learning_rate': 0.006172936736632081,
```

LLM はこれを dev モデル作成スクリプトの `CANDIDATES` 辞書に literal として転記したが、目視で丸めた:

```python
CANDIDATES = {
    "294": {
        "hp": {
            "subsample": 0.73, "colsample_bytree": 0.62,
            "reg_alpha": 8.72e-6, "reg_lambda": 9.89e-2,
        },
        "lr": 0.0062,
        "n_est": 1333,
    }
}
```

### 影響

- 丸められた HP で学習したモデルの **growth（複利指標）が元の trial 値から 16% 下振れ** した（0.003004 → 0.002519）
- LightGBM の `subsample` / `colsample_bytree` は行・列サブサンプリングの割合で、わずかな値差が決定木の分岐構造を変え、予測結果が変わる
- 下流で「このモデルは Optuna の予想通りの性能が出ない」と誤認され、戦略全体の再評価が走りかけた
- 気づくまで1日以上デバッグ時間を消費

### なぜ見つかりにくかったか

- **`round()` や format 文字列がコードに存在しない**: grep しても「丸めている箇所」が出てこない
- **ユニットテストは通る**: 辞書リテラルは文法的に正しく、JSON シリアライズも成功する
- **コードレビューで気づけない**: `0.73` と `0.7302700512037856` は一見同じ値
- **pkl ファイルを見ても分からない**: model.pkl は鍵数値をバイナリに埋め込んで学習済み
- LLM は `subsample: 0.73` を見ても違和感を持たない（「きれいな数字」として受け入れる）

## 回避策

### 1. source-of-truth から自動抽出する

literal を打ち込む代わりに、元データをパースするコードを書く。

```python
# NG: 目視転記
CANDIDATES = {"294": {"subsample": 0.73, ...}}

# OK: log から自動抽出
def load_trial_hp(log_path: str, trial_num: int) -> dict:
    log = Path(log_path).read_text()
    pattern = rf"Trial {trial_num} finished.*parameters: (\{{[^}}]+\}})"
    m = re.search(pattern, log)
    params_str = m.group(1).replace("'", '"')
    return json.loads(params_str)
```

外部 API の値なら JSON レスポンスを直接保存する。スクリプトの出力を他スクリプトが食うなら pickle / JSON で渡す。**中間に人間（LLM）の目を挟まない**。

### 2. 精度を保つシリアライゼーションを確認する

- `json.dump(x, f)` は Python float の full precision を保持する（安心）
- `yaml.dump(x)` も同様（デフォルトで full precision）
- `f"{x}"` や `str(x)` も Python 3 ではデフォルトで full precision
- `f"{x:.2g}"` / `format(x, ".3f")` / `round(x, 2)` は **意図的な丸め**。使う時は理由をコメントで明記する
- `numpy.float32(x)` / `np.float16(x)` はバイナリ精度で丸める（近似は `numpy float with noise`）

### 3. 回帰テストを書く

source-of-truth に対する round-trip テスト:

```python
def test_float_precision_preserved(tmp_path):
    hp = {"subsample": 0.7302700512037856, "learning_rate": 0.006172936736632081}
    save_config(tmp_path / "config.json", hp)
    loaded = load_config(tmp_path / "config.json")
    for k, v in hp.items():
        assert loaded[k] == v, f"{k} lost precision"
```

これで将来コードに意図せず `round()` や format 文字列が混入しても検知できる。

## 検知パターン

数値が「きれいすぎる」とき、丸めを疑う:

- `0.73`, `0.62`, `0.0062` のように2-3桁で切れている
- `8.72e-6`, `9.89e-2` のように mantissa が2-3桁
- 同じ source から来たはずの他の値と桁数が統一されていない（`0.73` と `0.0062` が並ぶ）

これが LightGBM HP / 統計閾値 / 機械学習ハイパラ / 最適化結果などに現れたら、**source-of-truth に戻って full precision と比較**する。

## 関連知見

- 目視コピーで精度が落ちるのは数値だけではない。文字列の改行・特殊文字・エンコーディングも同じ失敗モードを持つ（ASCII に変換してしまう、zero-width space を落とす、etc.）
- 原則: **LLM / 人間の目を通す経路は lossy なチャネルだと扱う**。決定論的に保存したい値は、目を通さずにプログラム間で渡す
