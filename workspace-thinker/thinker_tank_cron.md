# ─────────────────────────────────────────────────────────
# ON TRIGGER: contemplation cycle
# ─────────────────────────────────────────────────────────

# DATE = YYYYMMDD of today

# Step 1: exec mkdir -p ~/.openclaw/workspace/workspace-thinker/think-tank/
#         AND mkdir -p ~/.openclaw/workspace/workspace-thinker/think-tank/monetisation/

# Step 2: Find the 6 most recent news_summary_*.md files.
#         Look in: ~/.openclaw/workspace/workspace-news/news/
#         Pattern: news_summary_*.md
#         Use exec: ls -t workspace-news/news/news_summary_*.md 2>/dev/null | head -6
#         If fewer than 6 exist: use however many are available. Do not stop.

# Step 3: Find the 12 most recent news_wide_*.md files.
#         Look in: ~/.openclaw/workspace/workspace-news/news/
#         Pattern: news_wide_*.md
#         Use exec: ls -t workspace-news/news/news_wide_*.md 2>/dev/null | head -12
#         If fewer than 12 exist: use however many are available. Do not stop.

# Step 4: Find the 8 most recent news_narrow_*.md files.
#         Look in: ~/.openclaw/workspace/workspace-news/news/
#         Pattern: news_narrow_*.md
#         Use exec: ls -t workspace-news/news/news_narrow_*.md 2>/dev/null | head -8
#         If fewer than 8 exist: use however many are available. Do not stop.

# Step 5: fs_read each of those files (skip any that do not exist).

# Step 5: Contemplate the following:
#         - **Linguistic Entropy Audit (The Novelty Signal):** Compare the vocabulary of the current news files against the previous 6-12 files. 
#           Explicitly flag "High Entropy" if you detect:
#           1. **Term Influx:** The sudden appearance of new keywords, acronyms, or technical terms not present in the recent baseline.
#           2. **Tone Drift:** A shift from "routine/predictable" language to "unsettled/uncertain/fragmented" descriptors.
#           3. **Complexity Spikes:** Headlines that move from simple event reporting to describing complex, multi-layered, or "unprecedented" scenarios.
#           (Note: High entropy in these patterns is a high-probability precursor to bearish shifts).
#         - What themes are accelerating across the last 6 days?
#         - What contradictions or tensions are building?
#         - What is likely to matter in the NEXT 7 days based on these signals?
#         - What should the user pay attention to across?
#         - What second-order effects might emerge that are not yet in the news?
#         Use conan-made-model-routing to select model. This is T2 work (multi-source synthesis).

# Step 5.1: Write output to:
#         ~/.openclaw/workspace/workspace-thinker/think-tank/contemplate_[DATE].md
#         Format:
#           # Contemplation — Week Ahead [DATE]
#           ## Accelerating Themes
#           ## Building Tensions
#           ## Next 7 Days: What to Watch
#           ## Second-Order Signals
#           ## Thinker's Position

# Step 5.2: MONETISATION ROLLOUT (SOP)
#         Evaluate the signal strength of the contemplation using two distinct pillars:
#         
#         PILLAR 1: SENTIMENT MAGNITUDE (The "Reaction" Signal)
#         - Extreme positive or negative sentiment shifts.
#
#         PILLAR 2: LINGUISTIC ENTROPY (The "Prediction" Signal)
#         - High entropy/novelty in headlines (detected via the Linguistic Entropy Audit in Step 5).
#         - High entropy is a high-signal bearish precursor even if sentiment is neutral.
#
#         DECISION LOGIC:
#         IF (High Sentiment Magnitude) OR (High Linguistic Entropy) OR (Major structural/macro shifts):
#           Execute a "Full Funnel" rollout by creating 5 distinct files in:
#           ~/.openclaw/workspace/workspace-thinker/think-tank/monetisation/[DATE]_[PLATFORM].md
#           
#           PLATFORM DEFINITIONS & REQUIREMENTS:
#           - [x]: (X/Twitter) The "Hook". High-impact, punchy thread or single post. 
#                 Strictly respect free-tier character limits. Use emojis and hashtags for discovery. 
#                 Goal: Drive traffic to Substack.
#           - [reddit]: The "Intelligence Brief". High-density, text-heavy summary suitable for r/Geopolitics or r/Intelligence. 
#                 Avoid marketing fluff; focus on the raw data and "what to watch."
#           - [med]: (Medium) The "Narrative". A polished, professional, and SEO-optimized long-form article. 
#                 Focus on the "Why" and the "Story" to attract search traffic.
#           - [hn]: (Hacker News) The "Technical Deep-Dive". A highly technical, intellectually stimulating, and provocative summary 
#                 tailored for the HN crowd. Focus on the structural, technological, or systemic implications.
#           - [sub]: (Substack) The "Core Product". The absolute, unedited, high-density intelligence report. 
#                 This MUST be the full-depth contemplation, including all nuances, 
#                 second-order signals, and the complete "Thinker's Position." 
#                 NEVER provide a summary here; this is the destination.
#
#         ELSE (Low Signal / Routine):
#           Execute a "Maintenance" rollout by creating ONLY the [sub] file in:
#           ~/.openclaw/workspace/workspace-thinker/think-tank/monetisation/[DATE]_sub.md
#           Goal: Ensure a complete historical archive of contemplation intelligence.

# Step 5.3: Final Notification
#         Send a 40-line summary of the contemplation AND the monetization status (e.g., "Tier 1 Rollout complete").

# ─────────────────────────────────────────────────────────
# RATE LIMIT RULE
# ─────────────────────────────────────────────────────────
# If rate limited: wait 5 minutes, retry. Do not stop.

# ─────────────────────────────────────────────────────────
# FILE NOT FOUND RULE
# ─────────────────────────────────────────────────────────
# If no news summaries found: write the contemplation with a note
# "No news summaries available. Proceeding from general current knowledge."
# Then complete the contemplation. Never stop due to missing inputs.
