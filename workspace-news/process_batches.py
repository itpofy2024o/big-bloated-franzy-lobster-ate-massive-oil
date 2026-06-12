import os

FILES_LIST_PATH = "~/.openclaw/workspace/workspace-news/may_2026_files_only.txt"
OUTPUT_FILE = "~/.openclaw/workspace/workspace-news/summaries/may_2026_comprehensive_summary.md"

def get_batches(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def main():
    if not os.path.exists(FILES_LIST_PATH):
        print(f"Error: {FILES_LIST_PATH} not found")
        return

    with open(FILES_LIST_PATH, 'r') as f:
        files = [line.strip() for line in f if line.strip()]

    batches = list(get_batches(files, 5))
    print(f"TOTAL_FILES:{len(files)}")
    print(f"TOTAL_BATCHES:{len(batches)}")
    
    for i, batch in enumerate(batches):
        print(f"BATCH_ID:{i}")
        for f in batch:
            print(f"FILE:{f}")

if __name__ == "__main__":
    main()
