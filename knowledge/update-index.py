#!/usr/bin/env python3
"""
INDEX.mdファイルにFront Matter検索セクションを追加するスクリプト
"""
from pathlib import Path

# 各カテゴリのINDEX.mdに追加する検索セクション
SEARCH_SECTION = """
## Front Matterによる検索

ナレッジベース全体でYAML Front Matterを使った高度な検索が可能です。

### 基本的な検索例

```bash
# 特定の技術スタックを含む全知見を検索
rg "tags:.*typescript" ~/.claude/knowledge/

# カテゴリで検索
rg "category: {category}" ~/.claude/knowledge/

# 検証済みドキュメントのみ検索
rg "status: verified" ~/.claude/knowledge/

# 複数条件（TypeScript かつ React）
rg "tags:.*typescript.*react" ~/.claude/knowledge/

# 更新日が2025年3月以降のドキュメント
rg "updated: 2025-0[3-9]|2025-1[0-2]" ~/.claude/knowledge/
```

### カテゴリ固有の検索

```bash
# このカテゴリ内で特定タグを検索
rg "tags:.*{tag_example}" ~/.claude/knowledge/{category}/

# このカテゴリで最近更新されたドキュメント
rg "updated: 2025" ~/.claude/knowledge/{category}/ --files-with-matches
```

詳細な検索方法は [FRONTMATTER.md](../FRONTMATTER.md) を参照してください。
"""

# カテゴリごとの設定
CATEGORIES = {
    "best-practices": {
        "category": "best-practices",
        "tag_example": "security",
    },
    "patterns": {
        "category": "patterns",
        "tag_example": "typescript",
    },
    "troubleshooting": {
        "category": "troubleshooting",
        "tag_example": "windows",
    },
    "workflows": {
        "category": "workflows",
        "tag_example": "ci-cd",
    },
}


def add_search_section(index_path: Path, category_config: dict) -> None:
    """INDEX.mdに検索セクションを追加"""
    print(f"Processing: {index_path}")

    # ファイル読み込み
    content = index_path.read_text(encoding='utf-8')

    # 既に検索セクションがある場合はスキップ
    if "Front Matterによる検索" in content:
        print(f"  [SKIP] Already has search section")
        return

    # 検索セクションを生成
    search_section = SEARCH_SECTION.format(
        category=category_config["category"],
        tag_example=category_config["tag_example"],
    )

    # セクションを最後に追加
    new_content = content.rstrip() + "\n" + search_section

    # ファイル書き込み
    index_path.write_text(new_content, encoding='utf-8')
    print(f"  [OK] Search section added")


def main():
    """メイン処理"""
    base_path = Path(__file__).parent

    print("Starting INDEX.md update...\n")

    processed = 0

    for category, config in CATEGORIES.items():
        index_path = base_path / category / "INDEX.md"

        if not index_path.exists():
            print(f"[WARN] File not found: {index_path}")
            continue

        try:
            add_search_section(index_path, config)
            processed += 1
        except Exception as e:
            print(f"[ERROR] Error processing {index_path}: {e}")

    print(f"\nDone!")
    print(f"   Processed: {processed} files")


if __name__ == "__main__":
    main()
