---
name: context-compactor
description: Analyzes and compacts context-affecting documents (project memory, CLAUDE.md, skill files) to reduce token usage and compaction frequency. Manual trigger only. Always requires user approval before making changes.
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, Agent, AskUserQuestion]
---

# Context Compactor Skill

Analyze and compact documents that affect context window size. Reduce token usage while preserving essential information.

## Activation Triggers

**Manual only** — never auto-activate.

- `/compact-context` — run full analysis
- "コンテキストを整理して", "compact context", "reduce context size"

## Target Files

| Target | Path Pattern | Description |
|--------|-------------|-------------|
| Project Memory | `.claude/projects/*/memory/*.md` | Auto-memory files that grow over time |
| Project CLAUDE.md | `{project}/CLAUDE.md` | Project-specific instructions |
| Global CLAUDE.md | `~/.claude/CLAUDE.md` | Global instructions |
| Skill files | `~/.claude/skills/*/SKILL.md` | Skill definitions |

## Workflow

### Phase 1: Measure

Run `~/.claude/scripts/context-audit.sh` to get sizes for CLAUDE.md, all projects' MEMORY.md, skills, and knowledge base in one pass (with token estimate and context-window usage %). Identify the largest contributors from the output.

### Phase 2: Analyze

For each target file, detect:

- **Redundancy**: Content duplicated across files (e.g., CLAUDE.md vs skills, memory vs CLAUDE.md)
- **Obsolescence**: Outdated information (completed tasks, old decisions, superseded patterns)
- **Verbosity**: Content that can be expressed more concisely without losing meaning
- **Language inefficiency**: Japanese text in technical/process docs where English would use fewer tokens

### Phase 3: Propose

Present findings as a structured table:

```markdown
| File | Current | Est. After | Reduction | Changes |
|------|---------|-----------|-----------|---------|
| ... | ... | ... | ... | Brief description |
```

For each file with proposed changes, show:
- What will be removed/compacted (with reasoning)
- What will be preserved (and why)

**Wait for user approval before proceeding.**

### Phase 4: Execute (after approval)

- Apply approved changes only
- Show before/after line counts
- Suggest committing if in a git repo

## Analysis Rules

### MUST preserve

- User-specified behavioral instructions (personality, output style, preferences)
- Active project conventions and standards
- Security-related rules and constraints
- Information that exists nowhere else (sole source of truth)

### Safe to compact

- Duplicated content (keep in the most appropriate location)
- Verbose explanations of standard practices (LLMs already know these)
- Completed/obsolete memory entries
- Boilerplate sections repeated across files

### Requires user judgment

- Content the user may consider important even if technically redundant
- Trade-offs between token savings and clarity
- Whether to convert Japanese → English for token efficiency

## Important Notes

- Never delete without showing what will be removed
- Preserve meaning even when reducing words
- When in doubt, keep — false deletion is worse than slight verbosity
- This skill does NOT auto-activate — context growth is normal and expected
