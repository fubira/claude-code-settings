---
name: knowledge-manager
description: Records and retrieves the AI_KNOWLEDGE base in the Obsidian vault (patterns, troubleshooting, best practices). Use when a non-obvious finding is worth reusing across projects, when entering an unfamiliar technical area, or when the user asks to record knowledge. Do not use for findings that belong in the repository itself or in project memory.
allowed-tools: [Read, Write, Glob, Grep, AskUserQuestion]
---

# Knowledge Manager Skill

Manage a structured knowledge base. Progressive disclosure: reference knowledge only when relevant, keeping CLAUDE.md minimal.

## Activation Triggers

- Discovered a reusable solution (automatic)
- Solved a non-obvious technical problem (automatic)
- Established a new coding convention or pattern (automatic)

## Knowledge Base Location

All entries live under `RESOURCES/AI_KNOWLEDGE/` in the Obsidian vault (vault root path is defined in the global CLAUDE.md "Obsidian" section; referred to as `AI_KNOWLEDGE/` below). Global, cross-project — not project-local, and shared with Codex, so keep entries tool-neutral.

## Categories

| Category | Path | When to Record |
|----------|------|---------------|
| Patterns | `AI_KNOWLEDGE/patterns/` | Reusable design patterns, architecture |
| Troubleshooting | `AI_KNOWLEDGE/troubleshooting/` | Non-obvious technical problem solutions |
| Best Practices | `AI_KNOWLEDGE/best-practices/` | Coding standards, quality guidelines |
| Workflows | `AI_KNOWLEDGE/workflows/` | Dev processes, CI/CD, operational procedures |

## Recording Process

1. **Detect**: Identify valuable insights during development
2. **Evaluate**: Assess on 3 axes — Reusability, Impact, Learning Value (record if 2/3 are Medium+)
3. **Record**: Check category INDEX.md → deduplicate → create entry with front matter per `AI_KNOWLEDGE/FRONTMATTER.md` → update that category's INDEX.md
4. **User Approval**: Present summary, category, evaluation, and usage examples; create only after approval

## Entry Structure

Keep entries concise (< 100 lines). Common elements:

- **Overview**: 1-2 sentence summary
- **Context/Rationale**: When/why this applies
- **Details**: Commands, code, or steps (language-tagged fenced blocks)
- **Pitfalls**: Known failure modes
- **References**: External docs or related entries

Infer exact structure from the category — no fixed template required. See existing entries in `AI_KNOWLEDGE/` for style.

## Search and Retrieval

1. Check relevant category INDEX.md
2. Read only the specific files needed — never read a category in bulk
3. Provide answers with source references

## Maintenance

- Periodically update INDEX files, archive low-value entries, consolidate duplicates
