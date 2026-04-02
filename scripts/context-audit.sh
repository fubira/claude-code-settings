#!/bin/bash
# Claude Code コンテキスト監査スクリプト
# 各セッションで自動ロードされるファイルのサイズを計測する
# Usage: ~/.claude/scripts/context-audit.sh [project-dir]

set -euo pipefail

PROJECT_DIR="${1:-.}"
CLAUDE_HOME="$HOME/.claude"

echo "=== Claude Code Context Audit ==="
echo ""

total_lines=0
total_chars=0

measure() {
  local label="$1" path="$2"
  if [[ -f "$path" ]]; then
    local lines chars
    lines=$(wc -l < "$path")
    chars=$(wc -c < "$path")
    printf "  %-40s %4d lines  %6d chars\n" "$label" "$lines" "$chars"
    total_lines=$((total_lines + lines))
    total_chars=$((total_chars + chars))
  else
    printf "  %-40s %s\n" "$label" "(not found)"
  fi
}

# 1. CLAUDE.md files
echo "[CLAUDE.md]"
measure "Global (~/.claude/CLAUDE.md)" "$CLAUDE_HOME/CLAUDE.md"
global_real=$(realpath "$CLAUDE_HOME/CLAUDE.md" 2>/dev/null || true)
project_real=$(realpath "$PROJECT_DIR/CLAUDE.md" 2>/dev/null || true)
if [[ -n "$project_real" && "$project_real" != "$global_real" ]]; then
  measure "Project (CLAUDE.md)" "$PROJECT_DIR/CLAUDE.md"
fi
echo ""

# 2. MEMORY.md
echo "[Auto Memory]"
for memdir in "$CLAUDE_HOME/projects/"*/memory/; do
  if [[ -d "$memdir" ]]; then
    proj=$(basename "$(dirname "$memdir")")
    if [[ -f "$memdir/MEMORY.md" ]]; then
      measure "MEMORY.md ($proj)" "$memdir/MEMORY.md"
    fi
    # Count topic files
    topic_count=$(find "$memdir" -name "*.md" ! -name "MEMORY.md" 2>/dev/null | wc -l)
    if [[ $topic_count -gt 0 ]]; then
      topic_chars=$(find "$memdir" -name "*.md" ! -name "MEMORY.md" -exec cat {} + 2>/dev/null | wc -c)
      printf "  %-40s %4d files  %6d chars (not auto-loaded)\n" "  Topic files" "$topic_count" "$topic_chars"
    fi
  fi
done
echo ""

# 3. Skills
echo "[Skills]"
skill_total_lines=0
skill_total_chars=0
skill_count=0
for skill_dir in "$CLAUDE_HOME/skills/"*/; do
  if [[ -d "$skill_dir" ]]; then
    skill_name=$(basename "$skill_dir")
    if [[ -f "$skill_dir/SKILL.md" ]]; then
      lines=$(wc -l < "$skill_dir/SKILL.md")
      chars=$(wc -c < "$skill_dir/SKILL.md")
      printf "  %-40s %4d lines  %6d chars\n" "$skill_name" "$lines" "$chars"
      skill_total_lines=$((skill_total_lines + lines))
      skill_total_chars=$((skill_total_chars + chars))
      skill_count=$((skill_count + 1))
      total_lines=$((total_lines + lines))
      total_chars=$((total_chars + chars))
    fi
  fi
done
printf "  %-40s %4d lines  %6d chars (%d skills)\n" "Skills subtotal" "$skill_total_lines" "$skill_total_chars" "$skill_count"
echo ""

# 4. Knowledge (referenced but not auto-loaded)
echo "[Knowledge] (referenced on demand, not auto-loaded)"
if [[ -d "$CLAUDE_HOME/knowledge" ]]; then
  kb_count=$(find "$CLAUDE_HOME/knowledge" -name "*.md" 2>/dev/null | wc -l)
  kb_chars=$(find "$CLAUDE_HOME/knowledge" -name "*.md" -exec cat {} + 2>/dev/null | wc -c)
  printf "  %-40s %4d files  %6d chars\n" "Knowledge base" "$kb_count" "$kb_chars"
fi
echo ""

# Summary
echo "=== Summary ==="
printf "  Auto-loaded total:  %d lines / %d chars (~%d tokens est.)\n" \
  "$total_lines" "$total_chars" "$((total_chars / 4))"
echo ""
echo "Token estimate: chars/4 (rough approximation for mixed JP/EN)"
echo "Claude Code context window: ~200k tokens"
printf "Estimated usage: ~%.1f%%\n" "$(echo "scale=1; $total_chars / 4 / 2000" | bc)"
