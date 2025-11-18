# Knowledge Base

This directory contains a structured knowledge base managed by the `knowledge-manager` Skill.

## Purpose

Capture project learnings without bloating global CLAUDE.md. Knowledge is organized by category and referenced only when relevant (progressive disclosure).

## Categories

### [Patterns](patterns/INDEX.md)

Reusable design patterns, architectural solutions, and code structures.

**Tech Stack Subcategories**:

- [TypeScript/React](patterns/typescript-react/)
- [Go](patterns/go/)
- [Cross-stack](patterns/cross-stack/)

### [Troubleshooting](troubleshooting/INDEX.md)

Technical issues, error resolutions, and debugging guides.

### [Best Practices](best-practices/INDEX.md)

Standards, conventions, and quality guidelines.

### [Workflows](workflows/INDEX.md)

Process documentation, CI/CD patterns, and operational procedures.

### [Archive](archive/)

Low-priority or deprecated knowledge for historical reference.

## How It Works

### Automatic Recording

The `knowledge-manager` Skill automatically detects valuable knowledge during development and proposes recording it in the appropriate category.

### Progressive Disclosure

Knowledge files are read only when relevant to the current task, keeping context windows efficient.

### Search and Discovery

Use INDEX.md files in each category to quickly find relevant knowledge.

## Management

### Adding Knowledge

Knowledge is added via the `knowledge-manager` Skill, which:

1. Evaluates the knowledge against quality criteria
2. Selects the appropriate category and template
3. Creates or updates the knowledge file
4. Updates the INDEX.md file

### Updating Knowledge

When updating existing knowledge:

1. Read the current entry
2. Make updates preserving the template structure
3. Update the "Last Updated" date
4. Note changes in the INDEX.md if significant

### Archiving Knowledge

Move low-value or outdated knowledge to `archive/` to keep active knowledge relevant.

## Quality Standards

All knowledge entries should:

- Use the appropriate template
- Have clear, scannable titles
- Include concrete examples
- Provide proper categorization
- Maintain accurate INDEX entries
- Cross-reference related knowledge

## Templates

Template files are located in `~/.claude/skills/knowledge-manager/templates/`:

- `pattern.md`
- `troubleshooting.md`
- `best-practice.md`
- `workflow.md`
