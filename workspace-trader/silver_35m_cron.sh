# ──────────────────────────────────────────────────────────────────────────
# TASK: Silver zen hyperliquid position market data evaluation
# ──────────────────────────────────────────────────────────────────────────

# ─── STEP 1: START VENV ───
FILE_NAME_PATH=~/.openclaw/workspace/workspace-trader/silver_loop/silver_loop_$(date +%Y-%m-%d_%H-%M).md
touch $FILE_NAME_PATH
cd ~/silvering/silver/zen && source venv/bin/activate

# ─── STEP 2: EXECUTE Checking ───
echo "# Check" > $FILE_NAME_PATH
echo "## Positions" >> $FILE_NAME_PATH
./trading_exec.sh positions >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## Eligible Active Assets" >> $FILE_NAME_PATH
./trading_exec.sh fresh >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## ETH 1m" >> $FILE_NAME_PATH
echo "### ETH ps" >> $FILE_NAME_PATH
./trading_exec.sh ps ETH_1m >> $FILE_NAME_PATH
echo "### ETH fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness ETH_1m >> $FILE_NAME_PATH
echo "### ETH authority" >> $FILE_NAME_PATH
./trading_exec.sh authority ETH_1m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## ETH 3m" >> $FILE_NAME_PATH
echo "### ETH ps" >> $FILE_NAME_PATH
./trading_exec.sh ps ETH_3m >> $FILE_NAME_PATH
echo "### ETH fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness ETH_3m >> $FILE_NAME_PATH
echo "### ETH authority" >> $FILE_NAME_PATH
./trading_exec.sh authority ETH_3m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## ETH 5m" >> $FILE_NAME_PATH
echo "### ETH ps" >> $FILE_NAME_PATH
./trading_exec.sh ps ETH_5m >> $FILE_NAME_PATH
echo "### ETH fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness ETH_5m >> $FILE_NAME_PATH
echo "### ETH authority" >> $FILE_NAME_PATH
./trading_exec.sh authority ETH_5m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## ETH 15m" >> $FILE_NAME_PATH
echo "### ETH ps" >> $FILE_NAME_PATH
./trading_exec.sh ps ETH_15m >> $FILE_NAME_PATH
echo "### ETH fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness ETH_15m >> $FILE_NAME_PATH
echo "### ETH authority" >> $FILE_NAME_PATH
./trading_exec.sh authority ETH_15m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## SOL 1m" >> $FILE_NAME_PATH
echo "### SOL ps" >> $FILE_NAME_PATH
./trading_exec.sh ps SOL_1m >> $FILE_NAME_PATH
echo "### SOL fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness SOL_1m >> $FILE_NAME_PATH
echo "### SOL authority" >> $FILE_NAME_PATH
./trading_exec.sh authority SOL_1m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## SOL 3m" >> $FILE_NAME_PATH
echo "### SOL ps" >> $FILE_NAME_PATH
./trading_exec.sh ps SOL_3m >> $FILE_NAME_PATH
echo "### SOL fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness SOL_3m >> $FILE_NAME_PATH
echo "### SOL authority" >> $FILE_NAME_PATH
./trading_exec.sh authority SOL_3m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## SOL 5m" >> $FILE_NAME_PATH
echo "### SOL ps" >> $FILE_NAME_PATH
./trading_exec.sh ps SOL_5m >> $FILE_NAME_PATH
echo "### SOL fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness SOL_5m >> $FILE_NAME_PATH
echo "### SOL authority" >> $FILE_NAME_PATH
./trading_exec.sh authority SOL_5m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## SOL 15m" >> $FILE_NAME_PATH
echo "### SOL ps" >> $FILE_NAME_PATH
./trading_exec.sh ps SOL_15m >> $FILE_NAME_PATH
echo "### SOL fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness SOL_15m >> $FILE_NAME_PATH
echo "### SOL authority" >> $FILE_NAME_PATH
./trading_exec.sh authority SOL_15m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## XRP 1m" >> $FILE_NAME_PATH
echo "### XRP ps" >> $FILE_NAME_PATH
./trading_exec.sh ps XRP_1m >> $FILE_NAME_PATH
echo "### XRP fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness XRP_1m >> $FILE_NAME_PATH
echo "### XRP authority" >> $FILE_NAME_PATH
./trading_exec.sh authority XRP_1m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## XRP 3m" >> $FILE_NAME_PATH
echo "### XRP ps" >> $FILE_NAME_PATH
./trading_exec.sh ps XRP_3m >> $FILE_NAME_PATH
echo "### XRP fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness XRP_3m >> $FILE_NAME_PATH
echo "### XRP authority" >> $FILE_NAME_PATH
./trading_exec.sh authority XRP_3m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## XRP 5m" >> $FILE_NAME_PATH
echo "### XRP ps" >> $FILE_NAME_PATH
./trading_exec.sh ps XRP_5m >> $FILE_NAME_PATH
echo "### XRP fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness XRP_5m >> $FILE_NAME_PATH
echo "### XRP authority" >> $FILE_NAME_PATH
./trading_exec.sh authority XRP_5m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## XRP 15m" >> $FILE_NAME_PATH
echo "### XRP ps" >> $FILE_NAME_PATH
./trading_exec.sh ps XRP_15m >> $FILE_NAME_PATH
echo "### XRP fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness XRP_15m >> $FILE_NAME_PATH
echo "### XRP authority" >> $FILE_NAME_PATH
./trading_exec.sh authority XRP_15m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## BTC 1m" >> $FILE_NAME_PATH
echo "### BTC ps" >> $FILE_NAME_PATH
./trading_exec.sh ps BTC_1m >> $FILE_NAME_PATH
echo "### BTC fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness BTC_1m >> $FILE_NAME_PATH
echo "### BTC authority" >> $FILE_NAME_PATH
./trading_exec.sh authority BTC_1m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## BTC 3m" >> $FILE_NAME_PATH
echo "### BTC ps" >> $FILE_NAME_PATH
./trading_exec.sh ps BTC_3m >> $FILE_NAME_PATH
echo "### BTC fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness BTC_3m >> $FILE_NAME_PATH
echo "### BTC authority" >> $FILE_NAME_PATH
./trading_exec.sh authority BTC_3m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## BTC 5m" >> $FILE_NAME_PATH
echo "### BTC ps" >> $FILE_NAME_PATH
./trading_exec.sh ps BTC_5m >> $FILE_NAME_PATH
echo "### BTC fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness BTC_5m >> $FILE_NAME_PATH
echo "### BTC authority" >> $FILE_NAME_PATH
./trading_exec.sh authority BTC_5m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH
echo "## BTC 15m" >> $FILE_NAME_PATH
echo "### BTC ps" >> $FILE_NAME_PATH
./trading_exec.sh ps BTC_15m >> $FILE_NAME_PATH
echo "### BTC fitness" >> $FILE_NAME_PATH
./trading_exec.sh fitness BTC_15m >> $FILE_NAME_PATH
echo "### BTC authority" >> $FILE_NAME_PATH
./trading_exec.sh authority BTC_15m >> $FILE_NAME_PATH
echo "---" >> $FILE_NAME_PATH

# ─── STEP 3: DB LOG ───
START_NS=$(date +%s%N)
~/.openclaw/workspace/workspace-trader/build_json.sh
END_NS=$(date +%s%N)
MS=$(( (END_NS - START_NS) / 1000000 ))
JSON_CONTENT=$(cat ~/.openclaw/workspace/workspace-trader/json_summary.json)
cd ~/.openclaw/workspace/golang-db && ./golang-db log-cron "silver-ing" "trading loop" "trader" "goexec" "done" --output-content "$JSON_CONTENT" --duration-ms $MS

# ─── STEP 4: EXIT VENV ───
deactivate
