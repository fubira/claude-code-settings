#!/bin/bash
# settings.json から共有可能な部分だけを抽出して settings.example.json を生成する
# 手動同期による drift を防ぐため、settings.json 変更時はこのスクリプトで再生成する
# 抽出は許可リスト方式。下の jq に書いたキーだけが example に載り、それ以外
# （model / tui / effortLevel など個人設定を含む）はすべて落ちる。
# 共有したいキーを settings.json に足したときは、jq 側にも追加すること。
# attribution は個人設定に見えるが共有対象。キーが無いマシンでは帰属ありが既定になり、
# 値が空文字なので検証エラーも出ない（型は string で、空文字が非表示を意味する）。
# permissions のうち特定ホスト・特定プロジェクト向けの項目は EXCLUDE_PATTERN で除く。
# Usage: ~/.claude/scripts/generate-settings-example.sh

set -euo pipefail

CLAUDE_HOME="$HOME/.claude"

# 共有すべきでない permissions のパターン（正規表現、| 区切りで追記する）
EXCLUDE_PATTERN='server-tune|ssh one'

jq --arg exclude "$EXCLUDE_PATTERN" '{
  attribution: .attribution,
  permissions: {
    allow: [ .permissions.allow[] | select(test($exclude) | not) ],
    deny: (.permissions.deny // [])
  },
  statusLine: .statusLine,
  enabledPlugins: (.enabledPlugins // {})
} | with_entries(select(.value != null))' "$CLAUDE_HOME/settings.json" > "$CLAUDE_HOME/settings.example.json"

echo "generated: $CLAUDE_HOME/settings.example.json"
