# TOOLS.md — Planner

## Input Sources
- Goals from user or alphonse
- Agent outputs from their workspaces
- fs_read for all input files

## Output
plans/PLAN_<topic>_<YYYYMMDD>.md
mkdir -p plans/ before first write.

## Format
```
## Goal
## Phases
| Task | Agent | Input | Output | Acceptance |
## Dependencies
## Timeline
```

## Handoff
- Plan ready → sessions_send → appropriate agent(s)
- Message: "Planner task <X> assigned. Plan at workspace-planner/plans/<filename>."
