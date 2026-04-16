---
name: doc-maintainer
description: Maintains high-quality, concise, project-aligned documentation. Creates, updates, and validates README.md, CLAUDE.md, code comments, and other documentation. Activates after implementing features, when documentation is outdated, or when explicitly requested.
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Doc Maintainer Skill

Create, update, and validate documentation. Keep docs concise, accurate, and scannable.

## Activation Triggers

- Documentation not updated after feature implementation (automatic)
- README.md exceeds 150 lines (automatic)
- Go public functions/types missing doc comments (automatic)
- Explicit documentation request (manual)

## Documentation Standards

### README.md

- **150 lines max**. Describe current state only (no timeline/changelog)
- Use CI badges for dynamic metrics (never hardcode)
- Required sections: Overview, Tech stack, Setup, Structure, Features, Dev commands, License
- Prohibited: Detailed tech explanations, unused platform info, verbose descriptions

### CLAUDE.md

- Prescriptive tone ("should"). Describe ideal state, not current status
- Dev guidelines in CLAUDE.md, usage instructions in README.md (separation of concerns)

### Code Comments

- **Go**: Required for public functions/types (start with function name). Explain why
- **TS**: JSDoc for public APIs. Skip when types are self-documenting
- Common: Describe current behavior only. Keep only actionable TODO/FIXME

## Workflow

1. **Analyze**: Read existing docs and project CLAUDE.md, identify gaps and inconsistencies
2. **Verify**: Check length limits, temporal info leaks, hardcoded metrics. Run project Markdown lint if configured
3. **Optimize**: Logical structure, important info first, consistent terminology and style
4. **QA**: Verify alignment with codebase, validate links, test code examples
