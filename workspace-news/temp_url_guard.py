import sys
from urllib.parse import urlparse

def validate_url(url):
    try:
        parsed = urlparse(url.strip())
        path = parsed.path
        if "wikipedia.org" in parsed.netloc:
            return False
        if not path or path == "/":
            return False
        return True
    except Exception:
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
    url = sys.argv[1]
    if validate_url(url):
        sys.exit(0)
    else:
        sys.exit(1)
