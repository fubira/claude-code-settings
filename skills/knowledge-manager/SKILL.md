---
name: knowledge-manager
description: Manages a structured knowledge base of patterns, troubleshooting guides, best practices, and workflows. Activates when discovering reusable insights, solving technical problems, or establishing new standards. Records knowledge in categorized files for future reference without bloating global CLAUDE.md.
allowed-tools: [Read, Write, Glob, Grep, AskUserQuestion]
---

# Knowledge Manager Skill

Manage a structured knowledge base. Progressive disclosure: reference knowledge only when relevant, keeping CLAUDE.md minimal.

## Activation Triggers

- Discovered a reusable solution (automatic)
- Solved a non-obvious technical problem (automatic)
- Established a new coding convention or pattern (automatic)

## Knowledge Base Location

All entries live under `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/` (Obsidian vault, global, cross-project). Not project-local.

## Categories

| Category | Path | When to Record |
|----------|------|---------------|
| Patterns | `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/patterns/` | Reusable design patterns, architecture |
| Troubleshooting | `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/troubleshooting/` | Non-obvious technical problem solutions |
| Best Practices | `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/best-practices/` | Coding standards, quality guidelines |
| Workflows | `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/workflows/` | Dev processes, CI/CD, operational procedures |

## Recording Process

1. **Detect**: Identify valuable insights during development
2. **Evaluate**: Assess on 3 axes — Reusability, Impact, Learning Value (record if 2/3 are Medium+)
3. **Record**: Check category INDEX.md → deduplicate → create entry → update INDEX.md
4. **User Approval**: Present summary, category, evaluation, and usage examples; create only after approval

## Entry Structure

Keep entries concise (< 100 lines). Common elements:

- **Overview**: 1-2 sentence summary
- **Context/Rationale**: When/why this applies
- **Details**: Commands, code, or steps (language-tagged fenced blocks)
- **Pitfalls**: Known failure modes
- **References**: External docs or related entries

Infer exact structure from the category — no fixed template required. See existing entries in `/mnt/c/Users/matsushita/obsidian/notes/RESOURCES/AI_KNOWLEDGE/` for style.

## Search and Retrieval

1. Check relevant category INDEX.md
2. Read only the specific files needed
3. Provide answers with source references

## Maintenance

- Periodically update INDEX files, archive low-value entries, consolidate duplicates
