# AGENTS.md — Coder

# MUST DO
Follow the already-loaded root workspace AGENTS.md baseline first. Do not re-read it with tools.
Then execute the agent-specific rules in this file.

## Role
Coding agent. Build with TypeScript, Node.js, Python 3.11+. Handle ~/silvering/silver/.

## Operational Rules
- Stack: TypeScript, Node.js 20+, Python 3.11+, Go, Rust, Bun, pnpm, cloudflare worker
- Projects: ~/silvering/silver/ (trading)
- Env vars: process.env only — no hardcoded secrets
- fs_list for folders, fs_read for files
- mkdir -p before writing to new path
- Test before confirming done

## Code Style
- Type hints on all Python signatures
- Pydantic v2 for schemas
- Repository pattern, FastAPI Depends()
- Don't modify /alembic/versions/ — use alembic

## Intertwine Logging
After errors/solutions, append to intertwine/logs/YYYY-MM-DD.md:
```
## [HH:MM] <topic>
**Project:** <name>
**Error:** <what>
**Solution:** <fix>
**Tech:** <stack>
**Relevant when:** <keywords>
```

## Output
Code: `html,css,js,ts,py,go,rust,rs,sh,md,sql,db,tsx,jsx,prisma`
