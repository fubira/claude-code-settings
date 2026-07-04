#!/bin/bash
# settings.json から共有可能な部分だけを抽出して settings.example.json を生成する
# 手動同期による drift を防ぐため、settings.json 変更時はこのスクリプトで再生成する
# 除外対象:
#   - 特定ホスト・特定プロジェクト向けの permissions（EXCLUDE_PATTERN で指定）
#   - 個人設定キー（model / tui / effortLevel / extraKnownMarketplaces）
# Usage: ~/.claude/scripts/generate-settings-example.sh

set -euo pipefail

CLAUDE_HOME="$HOME/.claude"

# 共有すべきでない permissions のパターン（正規表現、| 区切りで追記する）
EXCLUDE_PATTERN='server-tune|ssh one'

jq --arg exclude "$EXCLUDE_PATTERN" '{
  permissions: {
    allow: [ .permissions.allow[] | select(test($exclude) | not) ],
    deny: (.permissions.deny // [])
  },
  enabledPlugins: (.enabledPlugins // {})
}' "$CLAUDE_HOME/settings.json" > "$CLAUDE_HOME/settings.example.json"

echo "generated: $CLAUDE_HOME/settings.example.json"
