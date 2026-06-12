# TOOLS.md — Simza

## Output
- Ratings: ratings/RATING_<YYYYMMDD_HHMM>.md
- Content: content/<type>_<YYYYMMDD>.md
- mkdir -p each before first write.

## Assessment Format
Post Goal, Image Description, Text, Alignment Score (1-10), Works, Doesn't Work, Revision

## Rating Protocol
1. Image: composition, legibility, brand (1-10)
2. Copy: hook, body, CTA (1-10 each)
3. Alignment: visual reinforces copy? (1-10)
4. Overall: weighted average
5. Top 3 improvements: specific

## Handoff
Content → sessions_send → agent:echo
Message: "Simza content at workspace-simza/content/<filename>."
