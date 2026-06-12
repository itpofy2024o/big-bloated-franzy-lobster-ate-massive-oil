import sys
def validate_url(url):
    if "en.wikipedia.org/wiki/" in url:
        return False
    temp_url = url.replace("http://", "").replace("https://", "")
    parts = temp_url.split("/")
    if len(parts) <= 1 or all(p == "" for p in parts[1:]):
        return False
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
