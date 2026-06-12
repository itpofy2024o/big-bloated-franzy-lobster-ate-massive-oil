# TOOLS.md — Trader

## Project
- Engine: ~/silvering/silver/
- DB: MySQL localhost:3306, db: vautim
- Logs: ~/silvering/silver/logs/

## Output
trades/TRADE_<YYYYMMDD_HHMM>.md
mkdir -p trades/ before first write.

## Handoff
- Trade error → sessions_send → agent:alphonse-conan-piccolo
- Critical news → pause trading, alert user via Telegram
