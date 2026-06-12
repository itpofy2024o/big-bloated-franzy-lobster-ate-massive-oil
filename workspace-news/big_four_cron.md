# TIMEZONE: Asia/Bangkok

# Restriction: news search result must be within the last 7.5 hours counting from TIMESTAMP, to ensure relevance and timeliness of the news stories included in the output. This means that any news article published more than 7.5 hours before the TIMESTAMP should be excluded from the results, even if it is still accessible online. This helps maintain a focus on current events and developments that are most likely to impact markets, geopolitics, and other areas of interest in a timely manner. For example when it is May 3rd but you gave me a source that published at 2026-04-28 16:22, that is more than 7.5 hours old, so it should be excluded. Please ensure that all news articles included in the output adhere to this 7.5-hour freshness requirement.

# SLOT = HH:MM (cron execution time in Asia/Bangkok; not the machine local timezone)
# DATE = YYYYMMDD of today in Asia/Bangkok
# TIMESTAMP = YYYY-MM-DD HH:MM:SS of the sweep in Asia/Bangkok

# Step 1: exec mkdir -p ~/.openclaw/workspace/workspace-news/news/
# Step 2: Use ddg-web-search skill first. If unavailable, use news-summary. If unavailable, use agent browser. If unavailable, use tavily (tavily, tavily_search, tavily_extract). And If still failed, wait 5 minutes and retry.
#         Search for EACH of the following domains (think of relevant search query for each domain based on recent relevance) separately (limit to last 7.5 hours counting from TIMESTAMP):
#           - global economy 
#           - central banks interest rates sovereign debt
#           - geopolitics military conflict sanctions
#           - energy supply OPEC oil gas grid
#           - technology regulatory AI chips semiconductors LLM
#           - political elections legislation policy
# ⚠️ Step 2b: QMD/LOCAL SEARCH PROHIBITION
#         NEVER use QMD, local document search, or local file indexing tools for news searches.
#         Use ONLY live web search tools: ddg-web-search, news-summary, tavily, brave search api.
#         QMD returns old indexed documents and will produce stale articles — this is banned.

# Step 3: Classify each story: CRITICAL / SIGNIFICANT / NOISE
#         Drop NOISE. Keep CRITICAL and SIGNIFICANT only.

# ⚠️ STEP 3.5: URL VALIDATION (NEW)
#         Validate each URL through url_guard.py before including in output:
#           - Reject Wikipedia encyclopedia entries (en.wikipedia.org/wiki/)
#           - Reject homepage URLs (domain.com/ only)
#           - Reject section/category pages (domain.com/technology/, domain.com/business/, etc.)
#           - Accept only direct article URLs with date paths (e.g. /2026/04/30/slug) or article slugs
#         Command: echo "$URL" | python3 ~/.openclaw/workspace/workspace-coder/fixes/url_guard.py
#         If URL fails validation, find replacement article or drop entry.

# Step 3b: SURGICAL ASSESSMENT — If any CRITICAL stories require deeper analysis
#           (geopolitical risk, market impact, supply chain disruption), produce a surgical assessment
#           and save to: ~/.openclaw/workspace/workspace-news/news/surgical_assessment_[DATE]_[SLOT].md
#           This is the ONLY correct save location for surgical assessments. Do NOT save elsewhere.

# Step 4: Write output to:
#         ~/.openclaw/workspace/workspace-news/news/news_narrow_[DATE]_[SLOT].md
#         Format per entry (prolific, detailed):
#           ### [HH:MM] Source Name
#             **Headline:** Full headline text (not truncated)
#             **URL:** <source article URL>
#             **Published:** <original article date if available, else "unknown">
#             **Summary:** 5 sentence, at least, explanation of what happened, key facts, and why it matters. Include specific numbers, locations, actors, and potential/immediate consequences.
#             **Classification:** CRITICAL or SIGNIFICANT
#             **Domain:** categorise the news into class tag relevant to the content such as entertainment, military, religion, fun, as such
#           Use markdown ### for each entry header, and indent subsequent fields by two spaces.
# Step 5: If any CRITICAL stories found: Telegram alert with one-line summary per story
# Step 6: If CRITICAL and trade-relevant:
#           6a: exec mkdir -p ~/.openclaw/workspace/workspace-trader/trader_related_news/
#           6b: Write trade-relevant CRITICAL analysis to BOTH locations:
#               - ~/.openclaw/workspace/workspace-news/news/news_narrow_[DATE]_[SLOT].md (already done in Step 4)
#               - ~/.openclaw/workspace/workspace-trader/trader_related_news/trader_related_news_analysis_[DATE]_[TIMESLOT_IN_DESIGNATED_TZ_OF_THE_CRON].md
#               Format for trader copy: headline, summary, trade relevance, classification, source URL
#           6c: sessions_list()
#               → if trader session found: sessions_send(sessionKey: "<key>", message: "News alert: <headline>. File: workspace-trader/trader_related_news/trader_related_news_analysis_[DATE]_[TIMESLOT_IN_DESIGNATED_TZ_OF_THE_CRON].md")
#               → if not found: sessions_spawn(agentId: "trader", label: "main") then sessions_send

# ─────────────────────────────────────────────────────────
# RATE LIMIT RULE (applies to all sweeps)
# ─────────────────────────────────────────────────────────
# If rate limited by any tool: wait 10 minutes, then retry.
# Do not stop. Do not skip the sweep. Just wait and continue.

# ─────────────────────────────────────────────────────────
# FILE NOT FOUND RULE
# ─────────────────────────────────────────────────────────
# If a file to be read does not exist: skip it silently.
# Never error-stop on missing input files.
# Always mkdir -p before any write.
