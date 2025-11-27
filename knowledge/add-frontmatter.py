#!/usr/bin/env python3
"""
既存のナレッジベースファイルにFront Matterを追加するスクリプト
"""
import re
from pathlib import Path
from typing import Dict, Any

# ファイルごとのメタデータ定義
FILE_METADATA: Dict[str, Dict[str, Any]] = {
    "best-practices/problem-solving-principles.md": {
        "title": "問題解決の原則：本質を見極める",
        "category": "best-practices",
        "tags": ["universal", "problem-solving", "debugging"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "best-practices/electron-application-icons.md": {
        "title": "Electronアプリケーションアイコン設定の完全ガイド",
        "category": "best-practices",
        "tags": ["electron", "electron-builder", "windows", "macos", "linux", "build-configuration"],
        "created": "2025-01-20",
        "updated": "2025-01-21",
        "status": "verified",
    },
    "best-practices/electron-security.md": {
        "title": "Electronセキュリティベストプラクティス",
        "category": "best-practices",
        "tags": ["electron", "security", "ipc", "xss"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "best-practices/line-ending-management.md": {
        "title": "改行コード統一管理（LF必須化）",
        "category": "best-practices",
        "tags": ["universal", "git", "line-endings", "windows", "ci-cd"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "best-practices/testing-external-libraries.md": {
        "title": "外部ライブラリのテスト方針",
        "category": "best-practices",
        "tags": ["universal", "testing", "mocking", "dexie", "vitest"],
        "created": "2025-01-24",
        "updated": "2025-01-24",
        "status": "verified",
    },
    "patterns/cross-stack/external-process-integration.md": {
        "title": "外部プロセス統合パターン",
        "category": "patterns",
        "tags": ["cross-stack", "nodejs", "python", "security", "spawn"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "patterns/electron/ipc-communication.md": {
        "title": "Electron IPC通信パターン",
        "category": "patterns",
        "tags": ["electron", "ipc", "security", "typescript"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "patterns/typescript-react/roro-pattern.md": {
        "title": "TypeScript RORO Pattern",
        "category": "patterns",
        "tags": ["typescript", "react", "code-structure", "parameters"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "verified",
    },
    "troubleshooting/claude-code-file-modified-error.md": {
        "title": "Claude Code \"File has been unexpectedly modified\" エラー",
        "category": "troubleshooting",
        "tags": ["claude-code", "windows", "bugs", "workaround"],
        "created": "2025-01-19",
        "updated": "2025-01-19",
        "status": "active",
    },
    "troubleshooting/electron-icon-not-applied.md": {
        "title": "Electron アプリの exe ファイルにアイコンが反映されない",
        "category": "troubleshooting",
        "tags": ["electron", "electron-builder", "windows", "icons"],
        "created": "2025-01-21",
        "updated": "2025-01-21",
        "status": "verified",
    },
    "troubleshooting/typescript-react.md": {
        "title": "TypeScript/React トラブルシューティング",
        "category": "troubleshooting",
        "tags": ["typescript", "react", "mantine", "vite", "windows", "mcp", "cloudflare-workers", "testing"],
        "created": "2025-01-19",
        "updated": "2025-11-24",
        "status": "active",
    },
}


def generate_frontmatter(metadata: Dict[str, Any]) -> str:
    """YAML Front Matterを生成"""
    tags_str = ", ".join(metadata["tags"])
    return f"""---
title: {metadata["title"]}
category: {metadata["category"]}
tags: [{tags_str}]
created: {metadata["created"]}
updated: {metadata["updated"]}
status: {metadata["status"]}
---

"""


def remove_old_metadata(content: str) -> str:
    """古いメタデータフォーマットを削除"""
    # パターン1: **Category**: ... 形式
    content = re.sub(r'\*\*Category\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Tech Stack\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Date Added\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Added\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Last Updated\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Applicability\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Source Project\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Keywords\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Environment\*\*:.*?\n', '', content)
    content = re.sub(r'\*\*Severity\*\*:.*?\n', '', content)

    # 連続する空行を1つに統一
    content = re.sub(r'\n{3,}', '\n\n', content)

    return content


def process_file(file_path: Path, metadata: Dict[str, Any]) -> None:
    """ファイルにFront Matterを追加"""
    print(f"Processing: {file_path}")

    # ファイル読み込み
    content = file_path.read_text(encoding='utf-8')

    # 既にFront Matterがある場合はスキップ
    if content.startswith('---'):
        print(f"  [SKIP]  Already has front matter, skipping")
        return

    # 古いメタデータを削除
    content = remove_old_metadata(content)

    # Front Matterを生成
    frontmatter = generate_frontmatter(metadata)

    # Front Matterを追加
    new_content = frontmatter + content

    # ファイル書き込み
    file_path.write_text(new_content, encoding='utf-8')
    print(f"  [OK] Front matter added")


def main():
    """メイン処理"""
    base_path = Path(__file__).parent

    print(" Starting front matter migration...\n")

    processed = 0
    skipped = 0

    for relative_path, metadata in FILE_METADATA.items():
        file_path = base_path / relative_path

        if not file_path.exists():
            print(f"[WARN]  File not found: {file_path}")
            continue

        try:
            process_file(file_path, metadata)
            processed += 1
        except Exception as e:
            print(f"[ERROR] Error processing {file_path}: {e}")
            skipped += 1

    print(f"\n Done!")
    print(f"   Processed: {processed} files")
    if skipped > 0:
        print(f"   Skipped: {skipped} files")


if __name__ == "__main__":
    main()
