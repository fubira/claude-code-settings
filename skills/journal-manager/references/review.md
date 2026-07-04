# Journal Review and Organization

Procedure for `/journal-review` and `/journal-cleanup` (and auto-suggested organization when active files exceed 20).

## Phase 1: Review (analysis only, no changes)

1. Read all files with Explore agent, classify by theme
2. Determine status for each file:
   - **Archive**: Conclusion already reflected elsewhere / superseded by later work / completed TODOs / approach replaced
   - **Consolidate**: 3+ consecutive files on same theme / problem-identification + solution pairs
   - **Defer**: Explicitly marked "future work" research topics (with start conditions)
   - **Keep**: Sole source of information / latest analysis on active theme / incident response records
3. Present organization proposal as a table, wait for user approval

## Phase 2: Organize (after approval)

- **Archive**: Move original file to `archives/` as-is (no content changes)
- **Consolidate**: Read source files → create merged file (oldest date + theme name, list sources at top, preserve numeric tables faithfully) → move originals to `archives/`
- **Defer**: Merge related files into one in `deferred/` (state resume conditions at top) → move originals to `archives/`

## Phase 3: Promotion Check

| Detected Pattern | Promote To |
|-----------------|------------|
| Confirmed technical facts/patterns | MEMORY.md |
| Project convention changes | CLAUDE.md |
| Model performance records | Data files in the parent directory of `journal/` |
| General-purpose solutions | `AI_KNOWLEDGE/` (via knowledge-manager skill) |

After promotion, add "→ reflected in X" marker to the journal entry.
