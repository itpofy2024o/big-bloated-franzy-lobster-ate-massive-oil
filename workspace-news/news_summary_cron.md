# TIMEZONE: Europe/Bucharest

# ─────────────────────────────────────────────────────────
# ON TRIGGER: news summary
# ─────────────────────────────────────────────────────────

# DATE = YYYYMMDD of today in Europe/Bucharest
# ⚠️ CRITICAL: The isolated agent session runs on the machine's local time.
# Use the exec command below to get the correct date, do NOT rely on the LLM's knowledge of current time.
# Run this at the START of Step 1:
# exec export TZ=Europe/Bucharest && DATE=$(TZ=Europe/Bucharest date +%Y%m%d) && echo "DATE=$DATE"

# Step 1: exec mkdir -p ~/.openclaw/workspace/workspace-news/news/
# Step 2: fs_read each of these files IF they exist (skip if not found, do not error):
#           workspace-news/news/*[DATE]*.md
#           Use the DATE variable set in Step 1 (TZ=Europe/Bucharest)
# Step 3: Use summarize skill to consolidate into a single structured summary.
#         If summarize fails, write summary manually from content read.
# Step 4: Write to:
#           workspace-news/news/news_summary_[DATE].md
#           IMPORTANT: Use $DATE from Step 1 (TZ=Europe/Bucharest).
#           Do NOT substitute YYYYMMDD with the system clock.
#         Format:
#           # Daily News Summary — [DATE] - Berlin Timezone
#           ## CRITICAL (today total)
#           ## SIGNIFICANT (today total)
#           ## Key Themes
#           ## Trade-Relevant Signals

# ─────────────────────────────────────────────────────────
# RATE LIMIT RULE (applies to all sweeps)
# ─────────────────────────────────────────────────────────
# If rate limited by any tool: wait 5 minutes, then retry.
# Do not stop. Do not skip the sweep. Just wait and continue.

# ─────────────────────────────────────────────────────────
# FILE NOT FOUND RULE
# ─────────────────────────────────────────────────────────
# If a file to be read does not exist: skip it silently.
# Never error-stop on missing input files.
# Always mkdir -p before any write.
