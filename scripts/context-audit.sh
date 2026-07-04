#!/bin/bash
# Claude Code コンテキスト関連ファイルのサイズ一覧
# ファイルごとの行数・文字数という事実のみを出力する。
# token 推定・使用率・「自動ロード合計」は出力しない。何がいつロードされるかは
# Claude Code 本体の仕様に依存して変わるため、スクリプトに写し取ると必ず陳腐化する。
# 実際のコンテキスト使用量はビルトインの /context コマンドで確認する。
# Usage: ~/.claude/scripts/context-audit.sh [project-dir]

set -euo pipefail

PROJECT_DIR="${1:-.}"
CLAUDE_HOME="$HOME/.claude"

measure() {
  local label="$1" path="$2"
  if [[ -f "$path" ]]; then
    printf "  %-46s %5d lines  %7d chars\n" "$label" "$(wc -l < "$path")" "$(wc -c < "$path")"
  else
    printf "  %-46s %s\n" "$label" "(not found)"
  fi
}

echo "=== Claude Code Context File Inventory ==="
echo ""

echo "[CLAUDE.md]"
measure "Global (~/.claude/CLAUDE.md)" "$CLAUDE_HOME/CLAUDE.md"
global_real=$(realpath "$CLAUDE_HOME/CLAUDE.md" 2>/dev/null || true)
project_real=$(realpath "$PROJECT_DIR/CLAUDE.md" 2>/dev/null || true)
if [[ -n "$project_real" && "$project_real" != "$global_real" ]]; then
  measure "Project (CLAUDE.md)" "$PROJECT_DIR/CLAUDE.md"
fi
echo ""

echo "[Memory] (per project: MEMORY.md / topic files)"
for memdir in "$CLAUDE_HOME/projects/"*/memory/; do
  [[ -d "$memdir" ]] || continue
  proj=$(basename "$(dirname "$memdir")")
  if [[ -f "$memdir/MEMORY.md" ]]; then
    measure "MEMORY.md ($proj)" "$memdir/MEMORY.md"
  fi
  topic_count=$(find "$memdir" -name "*.md" ! -name "MEMORY.md" | wc -l)
  if [[ $topic_count -gt 0 ]]; then
    topic_chars=$(find "$memdir" -name "*.md" ! -name "MEMORY.md" -exec cat {} + | wc -c)
    printf "  %-46s %5d files  %7d chars\n" "  topic files" "$topic_count" "$topic_chars"
  fi
done
echo ""

echo "[Skills] (SKILL.md total / frontmatter description)"
for skill_dir in "$CLAUDE_HOME/skills/"*/; do
  skill="$skill_dir/SKILL.md"
  [[ -f "$skill" ]] || continue
  name=$(basename "$skill_dir")
  desc_chars=$(awk '
    NR == 1 && /^---$/ { infm = 1; next }
    infm && /^---$/ { exit }
    infm && /^description:/ { cap = 1; sub(/^description:[ ]*/, ""); print; next }
    cap && /^[A-Za-z_-]+:/ { cap = 0 }
    cap { print }
  ' "$skill" | wc -c)
  printf "  %-30s %5d lines  %7d chars  (desc %4d chars)\n" \
    "$name" "$(wc -l < "$skill")" "$(wc -c < "$skill")" "$desc_chars"
done
echo ""
echo "Note: 実際のコンテキスト使用量は /context コマンドで確認する。"
