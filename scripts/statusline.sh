#!/bin/bash
# Claude Code statusLine 用スクリプト
# stdin の JSON からモデル名・ディレクトリ・Git ブランチ・コンテキスト使用率を1行で表示する
# 設定: settings.json の statusLine.command から呼ばれる（引数なし・stdin JSON）

set -euo pipefail

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' | cut -d. -f1)

branch=$(git -C "$dir" branch --show-current 2>/dev/null || true)

CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

line="${CYAN}${model}${RESET} $(basename "$dir")"
if [[ -n "$branch" ]]; then
  line+=" ${GREEN}${branch}${RESET}"
fi
if [[ -n "$used" ]]; then
  color=$GREEN
  if (( used >= 60 )); then color=$YELLOW; fi
  if (( used >= 80 )); then color=$RED; fi
  line+=" ${color}ctx ${used}%${RESET}"
fi

printf '%s' "$line"
