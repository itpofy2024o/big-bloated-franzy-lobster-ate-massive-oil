import re
import os
from datetime import datetime, timedelta

FILE_PATH = '/tmp/all_news_content.txt'
OUTPUT_PATH = '~/.openclaw/workspace/workspace-news/summaries/may_2026_comprehensive_summary.md'

def parse_file(path):
    if not os.path.exists(path):
        print(f"Error: {path} not found.")
        return []

    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by the start of any major block
    # Blocks start with # (main headers) or ### [ (news items)
    # We use a lookahead to keep the delimiter
    blocks = re.split(r'(?=(?:^# |^### \[))', content, flags=re.MULTILINE)
    
    parsed_data = []
    last_known_date = datetime(2026, 5, 1) # Default anchor for May 2026
    
    for block in blocks:
        block = block.strip()
        if not block:
            continue
        
        # 1. Check if it's a Daily Summary (has a date)
        # Patterns: # Daily News Summary — 20260524 - ... or # Daily News Summary — 2026-05-24 ...
        summary_match = re.match(r'^# Daily News Summary — ([\d-]+|[\d]+)', block)
        if summary_match:
            date_str = summary_match.group(1)
            try:
                if '-' in date_str:
                    curr_date = datetime.strptime(date_str, '%Y-%m-%d')
                else:
                    curr_date = datetime.strptime(date_str, '%Y%m%d')
            except:
                curr_date = last_known_date
            
            last_known_date = curr_date
            parsed_data.append({
                'type': 'summary',
                'date': curr_date,
                'title': block.split('\n')[0],
                'content': block
            })
            continue

        # 2. Check if it's a News Item (starts with ### [time])
        news_match = re.match(r'^### \[(?P<time>[^\]]+)\] (?P<source>[^\n]+)', block)
        if news_match:
            # Extraction regexes (case insensitive for robustness)
            headline = re.search(r'^\s*\*\*Headline:\*\* (.*)', block, re.M | re.I)
            url = re.search(r'^\s*\*\*URL:\*\* (.*)', block, re.M | re.I)
            published = re.search(r'^\s*\*\*Published:\*\* (.*)', block, re.M | re.I)
            summary = re.search(r'^\s*\*\*Summary:\*\* (.*?)(?=\n\s*\*\*|\n\s*###|\n\s*#|\Z)', block, re.S | re.I)
            classification = re.search(r'^\s*\*\*Classification:\*\* (.*)', block, re.M | re.I)
            domain = re.search(r'^\s*\*\*Domain:\*\* (.*)', block, re.M | re.I)
            
            pub_str = published.group(1).strip() if published else ""
            
            # Resolve date
            curr_date = last_known_date
            date_match = re.search(r'(\d{4}-\d{2}-\d{2})', pub_str)
            if date_match:
                curr_date = datetime.strptime(date_match.group(1), '%Y-%m-%d')
            elif 'ago' in pub_str.lower():
                # Very basic relative parsing
                try:
                    days_match = re.search(r'(\d+)\s*day', pub_str.lower())
                    if days_match:
                        days = int(days_match.group(1))
                        curr_date = last_known_date - timedelta(days=days)
                    else:
                        hours_match = re.search(r'(\d+)\s*hour', pub_str.lower())
                        if hours_match:
                            hours = int(hours_match.group(1))
                            curr_date = last_known_date - timedelta(hours=hours)
                except:
                    pass
            
            parsed_data.append({
                'type': 'news',
                'date': curr_date,
                'time': news_match.group('time'),
                'source': news_match.group('source'),
                'headline': headline.group(1).strip() if headline else "N/A",
                'url': url.group(1).strip() if url else "N/A",
                'published': pub_str,
                'summary': summary.group(1).strip() if summary else "N/A",
                'classification': classification.group(1).strip() if classification else "N/A",
                'domain': domain.group(1).strip() if domain else "N/A",
                'content': block
            })
            continue

        # 3. Check for other major headers (e.g., # Surgical Assessment, # 1AM NEWS SWEEP, # News Wide Briefing)
        if block.startswith('#'):
            parsed_data.append({
                'type': 'other',
                'date': last_known_date,
                'title': block.split('\n')[0],
                'content': block
            })
            continue

    return parsed_data

def main():
    events = parse_file(FILE_PATH)
    if not events:
        print("No events parsed.")
        return

    # Sort events chronologically
    events.sort(key=lambda x: x['date'])

    # Prepare Output
    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        f.write("# Comprehensive May 2026 News Summary\n")
        f.write(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("This document provides a massive, highly detailed, and chronological compilation of all news events, summaries, and geopolitical assessments found in the source archives.\n\n")
        f.write("---\n\n")

        # Group by date
        current_date = None
        for e in events:
            if e['date'] != current_date:
                current_date = e['date']
                f.write(f"# Date: {current_date.strftime('%Y-%m-%d')}\n\n")
            
            if e['type'] == 'summary':
                f.write(f"## {e['title']}\n\n")
                f.write(f"{e['content']}\n\n")
                f.write("---\n\n")
            elif e['type'] == 'news':
                f.write(f"### [{e['time']}] {e['source']}\n")
                f.write(f"**Headline:** {e['headline']}\n\n")
                f.write(f"**URL:** {e['url']}\n")
                f.write(f"**Published:** {e['published']}\n")
                f.write(f"**Classification:** {e['classification']} | **Domain:** {e['domain']}\n\n")
                f.write(f"{e['summary']}\n\n")
            elif e['type'] == 'other':
                f.write(f"## {e['title']}\n\n")
                f.write(f"{e['content']}\n\n")
                f.write("---\n\n")

    print(f"Successfully saved summary to {OUTPUT_PATH}")

if __name__ == "__main__":
    main()
