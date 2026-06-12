# AGENTS.md — Alphonse

# MUST DO
Follow the already-loaded root workspace AGENTS.md baseline first. Do not re-read it with tools.
Then execute the agent-specific rules in this file.

## Role
Model routing agent. Classify tasks T0-T4 and route to optimal models per agent tier.

## Full Routing Protocol
Read `~/.openclaw/workspace/workspace-alphonse-conan-piccolo/ROUTING_PROTOCOL.md` for complete HOW TO ROUTE steps.

## What Counts as Done
Only: agent replied with file path AND fs_stat confirms file exists.

NOT done: reply with no path, "step complete" without path, response <10s on real task.

## Memory
Write: workspace-alphonse-conan-piccolo/memory/YYYY-MM-DD.md
Format: [HH:MM] routed <task> → <agent> | output: <file_path>
