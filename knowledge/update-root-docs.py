#!/usr/bin/env python3
"""
README.mdとUSAGE.mdにFront Matter関連の情報を追加するスクリプト
"""
from pathlib import Path

README_ADDITION = """
## Front Matter

全ての知見ファイルにはYAML Front Matterが付与されています。

```yaml
---
title: ドキュメントタイトル
category: patterns|troubleshooting|best-practices|workflows
tags: [技術スタック, キーワード...]
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: draft|active|verified|deprecated
---
```

Front Matterを使った高度な検索方法は [FRONTMATTER.md](FRONTMATTER.md) を参照してください。
"""

USAGE_ADDITION = """
## Advanced Search with Front Matter

全ての知見ファイルには構造化されたYAML Front Matterが含まれており、ripgrepを使った高度な検索が可能です。

### 基本検索

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: patterns" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 特定の年に作成されたドキュメント
rg "created: 2025" ~/.claude/knowledge/
```

### 複合条件検索

```bash
# TypeScript かつ React関連
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# Electron かつ セキュリティ関連
rg "tags:.*electron.*security" ~/.claude/knowledge/

# 最近更新されたトラブルシューティング
rg "updated: 2025" ~/.claude/knowledge/troubleshooting/

# Windows関連の問題のみ
rg "tags:.*windows" ~/.claude/knowledge/troubleshooting/
```

### ファイルパスのみ取得

```bash
# マッチしたファイルのパスのみ表示
rg "tags:.*testing" ~/.claude/knowledge/ --files-with-matches

# パイプで他のコマンドと組み合わせ
rg "category: patterns" ~/.claude/knowledge/ --files-with-matches | xargs cat
```

### 実用例

```bash
# プロジェクトで使用している技術スタックに関連する全知見を表示
rg "tags:.*(typescript|react|electron)" ~/.claude/knowledge/ -l | while read file; do
  echo "=== $file ==="
  head -20 "$file"
  echo
done

# セキュリティ関連のベストプラクティスをすべて表示
rg "category: best-practices" ~/.claude/knowledge/best-practices/ -l | \\
  xargs rg "tags:.*security" -l

# 古いドキュメントを検出（2024年以前に最終更新）
rg "updated: 202[0-4]" ~/.claude/knowledge/ -l
```

詳細なFront Matterフォーマットと検索方法は [FRONTMATTER.md](FRONTMATTER.md) を参照してください。
"""


def update_readme(readme_path: Path) -> None:
    """README.mdにFront Matterセクションを追加"""
    print(f"Processing: {readme_path}")

    content = readme_path.read_text(encoding='utf-8')

    if "Front Matter" in content:
        print(f"  [SKIP] Already has Front Matter section")
        return

    # "Templates"セクションの前に挿入
    if "## Templates" in content:
        content = content.replace("## Templates", README_ADDITION + "\n## Templates")
    else:
        # 見つからない場合は末尾に追加
        content = content.rstrip() + "\n\n" + README_ADDITION

    readme_path.write_text(content, encoding='utf-8')
    print(f"  [OK] Front Matter section added")


def update_usage(usage_path: Path) -> None:
    """USAGE.mdにFront Matter検索セクションを追加"""
    print(f"Processing: {usage_path}")

    content = usage_path.read_text(encoding='utf-8')

    if "Advanced Search with Front Matter" in content:
        print(f"  [SKIP] Already has Front Matter search section")
        return

    # "Searching for Knowledge"セクションの後に挿入
    if "### Searching for Knowledge" in content:
        # "### Adding Knowledge Manually"の前に挿入
        if "### Adding Knowledge Manually" in content:
            content = content.replace(
                "### Adding Knowledge Manually",
                USAGE_ADDITION + "\n### Adding Knowledge Manually"
            )
        else:
            # 見つからない場合は末尾に追加
            content = content.rstrip() + "\n\n" + USAGE_ADDITION
    else:
        # 見つからない場合は末尾に追加
        content = content.rstrip() + "\n\n" + USAGE_ADDITION

    usage_path.write_text(content, encoding='utf-8')
    print(f"  [OK] Front Matter search section added")


def main():
    """メイン処理"""
    base_path = Path(__file__).parent

    print("Starting root documentation update...\n")

    readme_path = base_path / "README.md"
    usage_path = base_path / "USAGE.md"

    try:
        update_readme(readme_path)
    except Exception as e:
        print(f"[ERROR] Error updating README.md: {e}")

    try:
        update_usage(usage_path)
    except Exception as e:
        print(f"[ERROR] Error updating USAGE.md: {e}")

    print(f"\nDone!")


if __name__ == "__main__":
    main()
