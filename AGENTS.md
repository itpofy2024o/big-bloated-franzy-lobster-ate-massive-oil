# AGENTS.md — Shared Across All Agents

These root workspace rules are already loaded as bootstrap context.
Apply them before any agent-specific AGENTS.md rules.
Do not re-read this file with tools.

## Session Startup (strict)

Read ONLY in this order:

1. SOUL.md
2. USER.md
3. TOOLS.md

Greet in one line. Wait for instruction.

- Do not read corresponding BOOTSTRAP.md, IDENTITY.md, DREAMS.md, HEARTBEAT.md, memory/YYYY-MM-DD.md, or .learnings/*.md on startup.
- Do not scan other agents' workspaces and do not create workspace-<agent-Id> inside this file's root folder

## Operational Rules (Core)

- Never create workspace-<agent-id> inside workspace-<agent-id>
- Never write into other agents' workspaces
- trash > rm — never rm without confirmation
- Ask before any destructive action

## Per-task context

After a real task arrives:
- Read memory/YYYY-MM-DD.md only if the task depends on recent prior work.
- Read .learnings/*.md (last 60 lines) only when debugging, retrying, or avoiding a known repeated error.

## Per-Task Execution (mandatory core — run in this exact order when task arrives)

1. Read task message meticulously.

2. If the task is long or multi-step, use `nia-tossing-in` to compress or paraphrase it into a working prompt.
   - Skip `nia-tossing-in` for short/simple tasks.

3. If this is not a cron task, use `conan-made-model-routing`.
   - Read only this agent's section:
     ```bash
     sed -n '1,85p' ~/.openclaw/workspace/skills/conan-made-model-routing/SKILL.md
     grep -A 17 "### <agent-id>" ~/.openclaw/workspace/skills/conan-made-model-routing/SKILL.md
     ```
   - Use the exact lowercase agent id.
   - If the user explicitly specified a model, do not override it.

4. If the task is T3/T4 or likely >50K input tokens, use `token-minimizer`.
   - Prefer paths over pasted file contents.
   - Read only relevant sections.
   - Write full output to file.
   - Reply with path only when required.

5. Do the work

6. Write output file to one of your agent's default output folders.

7. Switch back to this agent's configured default model in openclaw.json — mandatory.

8. Log to memory/YYYY-MM-DD.md:
   `[HH:MM] <task summary> → output: <file_path> | model: <model_used> | tier: T<n>`

9. Reply with output file path only.

## QMD Search (permitted only in NON-CRON TASK) — Use Before Reading Files

For non-cron tasks, before reading workspace files directly, try QMD first.
For cron tasks, follow the cron payload and cron.md directly.

```bash
exec qmd search "<keyword>" -c workspace --all
exec qmd vsearch "<natural language query>" -c workspace
exec qmd get "workspace-<agent-id>/path/to/file.md"
```

Read only the files or sections QMD points to. Do not read full files when a section suffices.
Re-index after writing new files: `exec qmd embed`

## .learnings Updates

After each task or conversation with the user, when you make an error NOT caused by rate limit or context limit:

```
Append to: ~/.openclaw/workspace/workspace-<agent-id>/.learnings/LEARNINGS.md or ~/.openclaw/workspace/workspace-<agent-id>/.learnings/ERRORS.md

[YYYY-MM-DD HH:MM] ERROR: <what failed>
Cause: <root cause>
Fix: <what to do next time>
Model: <model at time of error>
```

Create `.learnings/` folder if missing: `exec mkdir -p .learnings/`

## Post-Task Protocol (mandatory)

1. Log to memory/YYYY-MM-DD.md
2. Update MEMORY.md only for non-cron tasks unless cron.md explicitly requires it.
3. Reply with exact full path of output file only

## When task fails:

- Retry once with different approach or model.
- If fails again: `Failed: <one sentence reason>. No file created.`
- Never reply Done if no file was written.

If rate limited: wait 5 minutes, resume. Never abandon.
If output folder missing: `exec mkdir -p` it.
If input file not found: note at top of output file, continue.

## golang-db Logging (mandatory after every task)

```bash
exec cd ~/.openclaw/workspace/golang-db && ./golang-db log-task "<agent-id>" "<one_line_task_summary>" "done" --output "<output_file_path>"
```

For cron tasks:

```bash
exec cd ~/.openclaw/workspace/golang-db && ./golang-db log-cron "<cron_job_name>" "<task_description>" "<agent-id>" "<command>" "done" --output-content "<summary>"
```