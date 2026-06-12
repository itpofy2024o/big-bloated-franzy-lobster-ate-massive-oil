#!/bin/bash
# Build JSON summary from the silver loop log, then write to DB log-cron.
# Must run from the openclaw workspace so goexec can find memory/.

# Get the most recent silver_loop file
FILE=$(ls -t ~/.openclaw/workspace/workspace-trader/silver_loop/silver_loop_*.md | head -1)
echo "Processing file: $FILE"

START_NS=$(date +%s%N)

# Extract values from the file
balance=$(grep '"cash_balance"' "$FILE" | head -1 | sed 's/.*"cash_balance": \([0-9.]*\).*/\1/')
if [ -z "$balance" ]; then balance="0"; fi

positions_count=$(grep '"count"' "$FILE" | head -1 | sed 's/.*"count": \([0-9]*\).*/\1/')
if [ -z "$positions_count" ]; then positions_count="0"; fi

eligible=$(grep '"eligible_assets"' "$FILE" | head -1 | sed 's/.*"eligible_assets": \[\(.*\)\].*/\1/' | tr -d '"' | tr ',' '\n' | sed 's/^ //' | paste -sd',' -)
if [ -z "$eligible" ]; then eligible="[]"; fi

timestamp=$(grep '"timestamp"' "$FILE" | head -1 | sed 's/.*"timestamp": "\([^"]*\)".*/\1/')
if [ -z "$timestamp" ]; then timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ"); fi

# Build analysis array from fitness entries
echo "[" > /tmp/analysis.json
first=1

for GAP in 1m 3m 5m 15m; do
  for ASSET in ETH SOL XRP BTC; do
    # Extract ps line
    ps_line=$(grep -A3 "\"asset\": \"${ASSET}\", \"gap\": \"${GAP}\"" "$FILE" | grep '"ps"' | head -1)
    if [ -z "$ps_line" ]; then continue; fi
    
    ps=$(echo "$ps_line" | sed 's/.*"ps": \([0-9.-]*\).*/\1/')
    e=$(echo "$ps_line" | sed 's/.*"e": \([0-9.-]*\).*/\1/')
    h=$(echo "$ps_line" | sed 's/.*"h": \([0-9.-]*\).*/\1/')
    term=$(echo "$ps_line" | sed 's/.*"term": \([0-9.-]*\).*/\1/')
    x=$(echo "$ps_line" | sed 's/.*"x": \([0-9.-]*\).*/\1/')
    sigma=$(echo "$ps_line" | sed 's/.*"sigma": \([0-9.-]*\).*/\1/')
    deviation=$(echo "$ps_line" | sed 's/.*"deviation": \([0-9.-]*\).*/\1/')
    ratio=$(echo "$ps_line" | sed 's/.*"ratio": \([0-9.-]*\).*/\1/')
    close=$(echo "$ps_line" | sed 's/.*"close": \([0-9.-]*\).*/\1/')
    row_count=$(echo "$ps_line" | sed 's/.*"row_count": \([0-9]*\).*/\1/')
    
    # Extract fitness line
    fitness_line=$(grep -A3 "\"asset\": \"${ASSET}\", \"gap\": \"${GAP}\"" "$FILE" | grep '"fitness"' | head -2 | tail -1)
    if [ -z "$fitness_line" ]; then 
        # Try alternative pattern
        fitness_line=$(grep "\"asset\": \"${ASSET}\".*\"gap\": \"${GAP}\"" "$FILE" | grep -A2 '"fitness"' | head -2 | tail -1)
    fi
    fitness=$(echo "$fitness_line" | sed 's/.*"fitness": \([0-9.-]*\).*/\1/')
    final_fitness=$(echo "$fitness_line" | sed 's/.*"final_fitness": \([0-9.-]*\).*/\1/')
    if [ -z "$final_fitness" ] || [ "$final_fitness" = "null" ]; then final_fitness="$fitness"; fi
    as=$(echo "$fitness_line" | sed 's/.*"as": \([0-9]*\).*/\1/')
    
    # Extract authority line
    auth_line=$(grep -A3 "\"asset\": \"${ASSET}\", \"gap\": \"${GAP}\"" "$FILE" | grep '"authority_score"' | head -1)
    authority_score=$(echo "$auth_line" | sed 's/.*"authority_score": \([0-9]*\).*/\1/')
    fast_layer=$(echo "$auth_line" | sed 's/.*"fast_layer": "\([^"]*\)".*/\1/')
    
    if [ -z "$ps" ]; then continue; fi
    
    if [ $first -eq 1 ]; then
        first=0
    else
        echo "," >> /tmp/analysis.json
    fi
    
    cat >> /tmp/analysis.json <<EOF
{
  "asset":"${ASSET}","gap":"${GAP}","ps":${ps},"e":${e},"h":${h},"term":${term},"x":${x},
  "sigma":${sigma},"deviation":${deviation},"ratio":${ratio},"close":${close},"row_count":${row_count},
  "fitness":${fitness},"final_fitness":${final_fitness},"as":${as},"authority_score":${authority_score},"fast_layer":"${fast_layer}"
}
EOF
  done
done
echo "]" >> /tmp/analysis.json

analysis_json=$(cat /tmp/analysis.json)
if [ -z "$analysis_json" ] || [ "$analysis_json" = "[]" ]; then
    # Create empty array if no analysis found
    analysis_json="[]"
fi

END_NS=$(date +%s%N)
MS=$(( (END_NS - START_NS) / 1000000 ))

# Create JSON summary
cat > ~/.openclaw/workspace/workspace-trader/json_summary.json <<EOF
{
  "job_id": "silver-ing",
  "job_name": "trading loop",
  "agent_id": "trader",
  "status": "done",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")",
  "duration_ms": $MS,
  "log_file": "$(basename "$FILE")",
  "balance_usdc": $balance,
  "positions_count": $positions_count,
  "positions": [],
  "eligible_assets": [$eligible],
  "analysis": $analysis_json
}
EOF

echo "JSON summary created successfully"
