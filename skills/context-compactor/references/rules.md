# Analysis Rules

Apply during Phase 2 (Analyze) and Phase 3 (Propose) to classify content.

## MUST preserve

- User-specified behavioral instructions (personality, output style, preferences)
- Active project conventions and standards
- Security-related rules and constraints
- Information that exists nowhere else (sole source of truth)

## Safe to compact

- Duplicated content (keep in the most appropriate location)
- Verbose explanations of standard practices (LLMs already know these)
- Completed/obsolete memory entries
- Boilerplate sections repeated across files

## Requires user judgment

- Content the user may consider important even if technically redundant
- Trade-offs between token savings and clarity
- Whether to convert Japanese → English for token efficiency
