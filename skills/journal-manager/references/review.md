# Journal Review and Organization

Procedure for `/journal-review` and `/journal-cleanup` (and auto-suggested organization when active files exceed 20).

## Phase 1: Review (analysis only, no changes)

1. Read all files with Explore agent, classify by theme
2. Determine status for each file:
   - **Delete**: Conclusion already reflected elsewhere / superseded by later work / completed TODOs / approach replaced
   - **Consolidate**: 3+ consecutive files on same theme / problem-identification + solution pairs
   - **Defer**: Explicitly marked "future work" research topics (with start conditions)
   - **Keep**: Sole source of information / latest analysis on active theme / incident response records
3. Present organization proposal as a table, wait for user approval

## Phase 2: Organize (after approval)

- **Delete**: Remove the file. The surviving copy elsewhere is the sole source
- **Consolidate**: Read source files → create merged file (oldest date + theme name, list sources at top, preserve numeric tables faithfully) → move originals to `archives/`
- **Defer**: Merge related files into one in `deferred/` (state resume conditions at top) → delete originals

## Phase 3: Promotion Check

| Detected Pattern | Promote To |
|-----------------|------------|
| Operational state / pending decisions carried across sessions | MEMORY.md |
| Methodology, rules, and the measurements behind them | Knowledge page in the parent directory of `journal/` |
| Numeric results, segment analyses | Same as above |
| Project convention changes | CLAUDE.md |
| General-purpose solutions | `AI_KNOWLEDGE/` (via knowledge-manager skill) |

Delete the journal file once its content is promoted. Two copies of the same fact leave no clear source of truth.
