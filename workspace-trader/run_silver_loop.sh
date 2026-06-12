#!/bin/bash
set -e
BASE_DIR=~/.openclaw/workspace/silvering/silver/zen
FILE_NAME_PATH="silver_loop/silver_loop_$(date +%Y-%m-%d_%H-%M).md"
mkdir -p "$(dirname "$FILE_NAME_PATH")"
touch "$FILE_NAME_PATH"

echo "# Check" > "$FILE_NAME_PATH"
echo "## Positions" >> "$FILE_NAME_PATH"
cd "$BASE_DIR/zen" && source venv/bin/activate && ./trading_exec.sh positions >> "$FILE_NAME_PATH"
echo "---" >> "$FILE_NAME_PATH"
echo "## Eligible Active Assets" >> "$FILE_NAME_PATH"
cd "$BASE_DIR/zen" && source venv/bin/activate && ./trading_exec.sh fresh >> "$FILE_NAME_PATH"
echo "---" >> "$FILE_NAME_PATH"

# Now the asset loops
for asset in ETH SOL XRP BTC; do
  for gap in 1m 3m 5m 15m; do
    echo "## ${asset} ${gap}" >> "$FILE_NAME_PATH"
    echo "### ${asset} ps" >> "$FILE_NAME_PATH"
    cd "$BASE_DIR/zen" && source venv/bin/activate && ./trading_exec.sh ps ${asset}_${gap} >> "$FILE_NAME_PATH"
    echo "### ${asset} fitness" >> "$FILE_NAME_PATH"
    cd "$BASE_DIR/zen" && source venv/bin/activate && ./trading_exec.sh fitness ${asset}_${gap} >> "$FILE_NAME_PATH"
    echo "### ${asset} authority" >> "$FILE_NAME_PATH"
    cd "$BASE_DIR/zen" && source venv/bin/activate && ./trading_exec.sh authority ${asset}_${gap} >> "$FILE_NAME_PATH"
    echo "---" >> "$FILE_NAME_PATH"
  done
done
