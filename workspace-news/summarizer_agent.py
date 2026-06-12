import os
import subprocess
import re

FILES_LIST_PATH = "~/.openclaw/workspace/workspace-news/may_2026_files_only.txt"
OUTPUT_FILE = "~/.openclaw/workspace/workspace-news/summaries/may_2026_comprehensive_summary.md"

def read_file(path):
    try:
        with open(path, 'r') as f:
            return f.read()
    except Exception as e:
        return f"Error reading {path}: {str(e)}"

def get_batches(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def main():
    with open(FILES_LIST_PATH, 'r') as f:
        files = [line.strip() for line in f if line.strip()]

    batches = list(get_batches(files, 5))
    
    # We will use a shell command to call a specialized instruction to the LLM
    # However, since I am the agent, I will simulate the batch loop by reading files 
    # and providing the content for the next step.
    # Actually, for efficiency in this environment, I will read the batches one by one
    # and then I'll perform the final synthesis.
    
    # But the instructions say: "Process them in groups of 5 files. For each group, read all 5, 
    # write a detailed summary... and APPEND this to .../may_2026_comprehensive_summary.md."
    
    # Since I cannot "loop" and "read" via a single tool call for 300 files effectively 
    # without hitting token limits, I will process them in chunks.
    
    pass

if __name__ == "__main__":
    main()
