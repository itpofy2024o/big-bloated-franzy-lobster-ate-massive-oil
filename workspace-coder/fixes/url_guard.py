import sys

def validate_url(url):
    # Reject Wikipedia encyclopedia entries
    if "en.wikipedia.org/wiki/" in url:
        return False
    
    # 1. Strip protocol
    temp_url = url.replace("http://", "").replace("https://", "")
    
    # 2. Check if it's just a domain (e.g., domain.com or domain.com/)
    parts = temp_url.split("/")
    # parts[0] is the domain.
    if len(parts) <= 1 or all(p == "" for p in parts[1:]):
        return False

    # 3. Reject section/category pages (e.g., domain.com/technology/)
    # We reject if it ends with a slash.
    if url.endswith("/"):
        return False
    
    return True

if __name__ == "__main__":
    if len(sys.argv) <= 1:
        sys.exit(1)
    url = sys.argv[1]
    if validate_url(url):
        sys.exit(0)
    else:
        sys.exit(1)
