#!/bin/sh
LOG=~/.openclaw/workspace/workspace-trader/silver_loop/silver_loop_2026-06-12_05-39.md
cd ~/silvering/silver/zen
source venv/bin/activate

run() {
  label="$1"
  cmd="$2"
  printf '%s\n' "$label" >> "$LOG"
  eval "$cmd" >> "$LOG" 2>&1 || true
}

fill_section() {
  asset="$1"; gap="$2"
  run "### $asset ps"  "./trading_exec.sh ps ${asset}_${gap}"
  run "### $asset fitness" "./trading_exec.sh fitness ${asset}_${gap}"
  run "### $asset authority" "./trading_exec.sh authority ${asset}_${gap}"
}

fill_asset() {
  asset="$1"
  printf '%s\n' "## $asset 1m" >> "$LOG"
  fill_section "$asset" 1m
  printf '%s\n' "---" >> "$LOG"

  printf '%s\n' "## $asset 3m" >> "$LOG"
  fill_section "$asset" 3m
  printf '%s\n' "---" >> "$LOG"

  printf '%s\n' "## $asset 5m" >> "$LOG"
  fill_section "$asset" 5m
  printf '%s\n' "---" >> "$LOG"

  printf '%s\n' "## $asset 15m" >> "$LOG"
  fill_section "$asset" 15m
  printf '%s\n' "---" >> "$LOG"
}

for asset in ETH SOL XRP BTC; do
  fill_asset "$asset"
done
