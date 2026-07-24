#!/bin/bash
# README.md の Skill 表を skills/*/SKILL.md の frontmatter から生成する
# 手書き同期による drift（表への追加漏れ・起動条件のずれ）を防ぐため、
# スキルの追加・変更時はこのスクリプトで README のマーカー区間を再生成する
# 表の内容:
#   - Skill 名: ディレクトリ名（SKILL.md へのリンク）
#   - Description: frontmatter description の先頭文（英語のまま抽出）
#   - 起動: frontmatter に disable-model-invocation: true があれば「手動」、なければ「自動」
# Usage: ~/.claude/scripts/generate-readme-skills.sh

set -euo pipefail

CLAUDE_HOME="$HOME/.claude"
README="$CLAUDE_HOME/README.md"

# Cloudflare / Web 開発スキル（外部由来）。ここに無いものは Personal Skills として扱う
VENDORED="agents-sdk cloudflare cloudflare-email-service durable-objects sandbox-sdk turnstile-spin web-perf workers-best-practices wrangler"

is_vendored() {
  local name="$1" v
  for v in $VENDORED; do
    [[ "$v" == "$name" ]] && return 0
  done
  return 1
}

# frontmatter から値を1行で取り出す（description は先頭文のみ）
skill_row() {
  local skill_md="$1" name desc trigger
  name=$(basename "$(dirname "$skill_md")")
  desc=$(awk '
    NR == 1 && /^---$/ { infm = 1; next }
    infm && /^---$/ { exit }
    infm && /^description:/ {
      sub(/^description:[ ]*/, "")
      sub(/^["'"'"']/, ""); sub(/["'"'"']$/, "")
      if (match($0, /\. /)) print substr($0, 1, RSTART)
      else print $0
      exit
    }
  ' "$skill_md")
  trigger="自動"
  if awk 'NR == 1 && /^---$/ { infm = 1; next } infm && /^---$/ { exit }
          infm && /^disable-model-invocation:[ ]*true/ { found = 1 } END { exit !found }' "$skill_md"; then
    trigger="手動"
  fi
  printf '| [`%s`](skills/%s/SKILL.md) | %s | %s |\n' "$name" "$name" "$desc" "$trigger"
}

gen_table() {
  local kind="$1" skill_md name
  echo "| Skill | Description | 起動 |"
  echo "|-------|-------------|------|"
  for skill_md in "$CLAUDE_HOME/skills/"*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    name=$(basename "$(dirname "$skill_md")")
    # git 管理外のスキルは他所からの導入物。このリポジトリの提供物ではないため載せない
    git -C "$CLAUDE_HOME" check-ignore -q "skills/$name" && continue
    if [[ "$kind" == "vendored" ]] && is_vendored "$name"; then
      skill_row "$skill_md"
    elif [[ "$kind" == "personal" ]] && ! is_vendored "$name"; then
      skill_row "$skill_md"
    fi
  done
}

# README のマーカー区間を生成結果で置き換える
splice() {
  local marker="$1" table="$2"
  awk -v begin="<!-- BEGIN GENERATED: $marker -->" \
      -v end="<!-- END GENERATED: $marker -->" \
      -v table="$table" '
    $0 == begin { print; printf "%s", table; found = 1; skip = 1; next }
    $0 == end { skip = 0 }
    !skip { print }
    END { if (!found) exit 1 }
  ' "$README" > "$README.tmp"
  mv "$README.tmp" "$README"
}

splice "personal-skills" "$(gen_table personal)
"
splice "vendored-skills" "$(gen_table vendored)
"

echo "generated: skill tables in $README"
