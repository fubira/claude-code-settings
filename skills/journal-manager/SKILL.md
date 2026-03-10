---
name: journal-manager
description: Creates and manages Obsidian work journals. Automatically writes journals after experiments, analyses, and key decisions. Periodically reviews, consolidates, archives, and promotes journal entries to permanent documentation.
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, Agent, AskUserQuestion]
---

# Journal Manager Skill

Create and manage Obsidian work journals. Record "what I thought at this point" as thinking logs.

## Activation Triggers

**Create (proactive)**: After experiments/analyses, decisions, incident responses, comparisons, or user request
**Organize**: `/journal-review`, `/journal-cleanup`, auto-suggest when active files > 20

## Journal Location

- **Path**: `/mnt/c/Users/matsushita/obsidian/notes/WORK/{ORG}_{PROJECT}/journal/YYYY-MM-DD_HHmm_topic.md`
- Date in JST. Topic in hyphenated English or Japanese (keep short)

## auto memory vs Journal

- **auto memory**: Technical facts and patterns (long-lived) → `.claude/projects/*/memory/`
- **Journal**: Chronological thinking process (short-to-mid lived) → Obsidian `journal/`

## Part 1: Creating Journals

### Templates

**Experiment/Analysis**: Background → Conditions/Setup → Results (numeric tables) → Findings → Conclusion/Next actions
**Decision**: Context → Options → Judgment and reasoning → Trade-offs → Next actions
**Incident Response**: Situation → Root cause → Actions taken → Prevention measures → Lessons learned
**Work Log**: Tasks done → Design decisions (if any) → TODOs (remaining)

### Principles

- One topic per file (multiple per day OK). Use tables for numeric data
- Record "what I thought at this point" — valuable even if conclusions change later
- Place persistent data in the parent directory of `journal/`
- Do NOT record: code diffs (Git handles that), trivial task logs, technical facts suited for auto memory

## Part 2: Review and Organization

### Phase 1: Review (analysis only, no changes)

1. Read all files with Explore agent, classify by theme
2. Determine status for each file:
   - **Archive**: Conclusion already reflected elsewhere / superseded by later work / completed TODOs / approach replaced
   - **Consolidate**: 3+ consecutive files on same theme / problem-identification + solution pairs
   - **Defer**: Explicitly marked "future work" research topics (with start conditions)
   - **Keep**: Sole source of information / latest analysis on active theme / incident response records
3. Present organization proposal as a table, wait for user approval

### Phase 2: Organize (after approval)

- **Archive**: Move original file to `archives/` as-is (no content changes)
- **Consolidate**: Read source files → create merged file (oldest date + theme name, list sources at top, preserve numeric tables faithfully) → move originals to `archives/`
- **Defer**: Merge related files into one in `deferred/` (state resume conditions at top) → move originals to `archives/`

### Phase 3: Promotion Check

| Detected Pattern | Promote To |
|-----------------|------------|
| Confirmed technical facts/patterns | MEMORY.md |
| Project convention changes | CLAUDE.md |
| Model performance records | profile.md |
| General-purpose solutions | knowledge/ |

After promotion, add "→ reflected in X" marker to the journal entry.

## Directory Structure

```
{project}/journal/
├── *.md              # Active
├── archives/         # Consolidated/obsolete originals
└── deferred/         # Future research topics
```

## Important Notes

- Archive means move, not delete (originals kept in archives/)
- Never drop data during consolidation (faithfully copy numeric tables)
- When in doubt, keep. Create aggressively, organize cautiously
- Deferred entries must state concrete resume conditions (not just "someday")
