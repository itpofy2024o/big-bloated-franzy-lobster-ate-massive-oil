#!/usr/bin/env python3
"""
Validate news article freshness based on published date vs timestamp.
Filters out articles older than max_hours from timestamp.

Usage:
  python3 validate_news_freshness.py --max-hours 24 --timestamp "2026-05-04 02:16:00" input.json
  python3 validate_news_freshness.py --max-hours 28 input.json

Input JSON format:
  [
    {"url": "...", "published": "2026-05-04", "headline": "..."},
    ...
  ]

Output: JSON with only fresh articles.
"""

import json
import sys
import argparse
from datetime import datetime, timezone
import re


def parse_published_date(published_str):
    """Try to parse various date formats."""
    if not published_str or published_str.lower() in ["unknown", "n/a", ""]:
        return None

    # Try various formats
    formats = [
        "%Y-%m-%d",
        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%dT%H:%M:%S",
        "%Y-%m-%dT%H:%M:%SZ",
        "%B %d, %Y",
        "%b %d, %Y",
    ]

    for fmt in formats:
        try:
            return datetime.strptime(published_str, fmt)
        except ValueError:
            continue

    # Try to extract year from string
    year_match = re.search(r"\b(202[0-9])\b", published_str)
    if year_match:
        year = int(year_match.group(1))
        # If year is old, reject
        if year < 2026:
            return datetime(year, 1, 1)  # Will be filtered as old

    return None


def is_fresh(published_date, timestamp, max_hours):
    """Check if article is within max_hours of timestamp."""
    if published_date is None:
        return None  # Unknown - caller decides

    # Make both timezone-aware
    if timestamp.tzinfo is None:
        timestamp = timestamp.replace(tzinfo=timezone.utc)
    if published_date.tzinfo is None:
        published_date = published_date.replace(tzinfo=timezone.utc)

    diff = timestamp - published_date
    return diff.total_seconds() <= (max_hours * 3600)


def main():
    parser = argparse.ArgumentParser(description="Validate news article freshness")
    parser.add_argument(
        "--max-hours", type=int, required=True, help="Maximum age in hours"
    )
    parser.add_argument(
        "--timestamp",
        type=str,
        default=None,
        help="Reference timestamp (YYYY-MM-DD HH:MM:SS). Defaults to now.",
    )
    parser.add_argument("input", type=str, help="Input JSON file")
    parser.add_argument(
        "--output", type=str, default=None, help="Output JSON file (default: stdout)"
    )
    parser.add_argument(
        "--include-unknown",
        action="store_true",
        help="Include articles with unknown dates",
    )

    args = parser.parse_args()

    # Parse timestamp
    if args.timestamp:
        timestamp = datetime.strptime(args.timestamp, "%Y-%m-%d %H:%M:%S")
    else:
        timestamp = datetime.now(timezone.utc)

    # Read input
    with open(args.input, "r") as f:
        articles = json.load(f)

    # Filter
    fresh_articles = []
    rejected = []

    for article in articles:
        published = article.get("published", "unknown")
        pub_date = parse_published_date(published)

        fresh = is_fresh(pub_date, timestamp, args.max_hours)

        if fresh is True:
            fresh_articles.append(article)
        elif fresh is None and args.include_unknown:
            fresh_articles.append(article)
        else:
            rejected.append(
                {
                    "url": article.get("url", ""),
                    "published": published,
                    "reason": "too old" if fresh is False else "parse error",
                }
            )

    # Output
    output_data = {
        "fresh": fresh_articles,
        "rejected": rejected,
        "timestamp": timestamp.isoformat(),
        "max_hours": args.max_hours,
        "total_input": len(articles),
        "total_fresh": len(fresh_articles),
        "total_rejected": len(rejected),
    }

    if args.output:
        with open(args.output, "w") as f:
            json.dump(output_data, f, indent=2)
        print(f"Output written to {args.output}")
    else:
        print(json.dumps(output_data, indent=2))


if __name__ == "__main__":
    main()
