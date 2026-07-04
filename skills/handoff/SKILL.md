---
name: handoff
description: Session migration for context corruption recovery. Writes a fact-based handoff file so work can continue in a fresh session, or resumes from one. Manual trigger only (`/handoff`). Use when a session shows confabulation (phantom instructions, derailed context) and the user wants to move to a clean session instead of rewinding.
allowed-tools: [Read, Write, Bash, Glob, Grep, AskUserQuestion]
disable-model-invocation: true
---

# Handoff Skill

Migrate work to a fresh session via a small, fact-only handoff file. Designed for recovery from context corruption: the handoff must be reconstructable from primary sources, never from the model's narrative memory of the session.

## Activation Triggers

**Manual only** — never auto-activate.

- `/handoff` — auto-detects mode (see below)
- "引き継ぎを書いて", "新しいセッションに移行したい", "ハンドオフ"

## Mode Detection

Check for `.claude/handoff.md` in the current project root (`git rev-parse --show-toplevel`, fall back to cwd).

- File exists → **Resume mode**
- File absent → **Write mode**

## Write Mode

The current session may be confabulating. Therefore the handoff content must come only from sources listed below. Do NOT write a narrative summary of "what happened this session" from memory.

Allowed sources, in priority order:

1. **User messages quoted verbatim** — the original goal/request, copied exactly from actual user messages in this conversation. If the instruction cannot be traced to a specific user message, it does not go in the file.
2. **Command output gathered now** — run fresh: current branch, `git status --short`, `git diff --stat`, `git log --oneline -5`. Paste results as-is.
3. **Concrete next actions** — means only (file paths, commands, steps). No evaluations, no judgment words, per the global 評価・感想 policy.

Write `.claude/handoff.md`:

```markdown
# Handoff

## 元の依頼（ユーザー発言の引用）
> <verbatim quote(s)>

## リポジトリの現状（コマンド出力）
- branch: <name>
- git status --short / git diff --stat / git log --oneline -5 の出力

## 次にやること
1. <concrete action with file paths / commands>
```

Then tell the user:

1. The file path written
2. To review it briefly before trusting it (the writing session may be corrupted)
3. To start a fresh session in the project and run `/handoff` to resume

Do not commit the file. It is transient working state.

## Resume Mode

1. Read `.claude/handoff.md` and restate the task to the user in one or two sentences.
2. Verify the recorded repo state against reality (`git status --short`, branch). Report any mismatch before acting — the handoff may be stale or contaminated.
3. Delete `.claude/handoff.md` (it has served its purpose; a stale handoff must not trigger resume mode later).
4. Continue the work from "次にやること".

## Important Notes

- Facts only: what was requested, what state the repo is in, what to do next. Never record impressions, evaluations, or session history.
- If the user invokes write mode but there are no traceable user instructions to quote (fully derailed context), say so and recommend `/rewind` instead — a handoff written from nothing but confabulated memory is worse than none.
