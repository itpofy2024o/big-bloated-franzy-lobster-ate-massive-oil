# News Cron URL Guard Fix

## Problem (from audit)
The news cron output contained 60% invalid URLs:
- Wikipedia encyclopedia entries instead of news articles
- Reuters section/category landing pages (`/technology/artificial-intelligence/`) instead of specific articles
- Homepage URLs (`oilprice.com/`) providing zero context

## Solution
Created `/Users/nosensetxt/.openclaw/workspace/workspace-coder/fixes/url_guard.py` - a deterministic URL validation script that rejects generic URLs before delivery.

## Validation Rules Added

```python
INVALID_PATTERNS = [
    # Wikipedia - encyclopedia, not news
    (r'en\.wikipedia\.org/wiki/', 'Wikipedia encyclopedia'),
    
    # Homepages (no path after domain)
    (r'^https?://[^/]+/?$', 'Homepage URL'),
    
    # Section/category landing pages
    (r'/technology/artificial-intelligence/$', 'Tech AI category page'),
    (r'/business/energy/$', 'OPEC category page'),
    (r'/business/$', 'Business category page'),
    (r'/world/$', 'World category page'),
    (r'/opec/$', 'OPEC category page'),
]
```

### Rules for Valid Article URLs
1. Must have article slug pattern: `/YYYY/MM/DD/slug` or `/slug-with-hyphens`
2. Excluding URLs that are just domain + path segment (no article identifier)
3. Wikipedia URLs always rejected (encyclopedia, not breaking news)
4. Short paths (< 3 segments) without date indicators blocked

## Code Files Changed

### Created: `/Users/nosensetxt/.openclaw/workspace/workspace-coder/fixes/url_guard.py`
Python script that validates URLs via stdin and outputs PASS/BLOCK status.

### Modified: `/Users/nosensetxt/.openclaw/workspace/workspace-news/headline_cron.md`
Added Step 3.5 URL validation requirement between Step 3 and Step 3b.

### Modified: `/Users/nosensetxt/.openclaw/workspace/workspace-news/big_four_cron.md`
Added Step 3.5 URL validation requirement between Step 3 and Step 3b.

## Usage

```bash
# Validate single URL
echo "https://www.reuters.com/world/china/prices-nvidias-b300-server-1-million-china-us-curbs-sources-say-2026-04-30/" | python3 url_guard.py

# Validate in pipeline
cat news_file.md | grep -E 'https?://[^ ]+' | python3 url_guard.py
```

## Test Results

| URL | Result |
|-----|--------|
| `https://en.wikipedia.org/wiki/Middle_Eastern_crisis_(2023%E2%80%93present)` | ❌ BLOCK |
| `https://oilprice.com/` | ❌ BLOCK |
| `https://www.reuters.com/technology/artificial-intelligence/` | ❌ BLOCK |
| `https://www.reuters.com/business/energy/opec/` | ❌ BLOCK |
| `https://www.reuters.com/world/china/prices-nvidias-b300-server-1-million-china-us-curbs-sources-say-2026-04-30/` | ✅ PASS |

## Files Modified
- `/Users/nosensetxt/.openclaw/workspace/workspace-coder/fixes/url_guard.py` (created)
- `/Users/nosensetxt/.openclaw/workspace/workspace-news/big_four_cron.md` (instruction update)
- `/Users/nosensetxt/.openclaw/workspace/workspace-news/headline_cron.md` (instruction update)