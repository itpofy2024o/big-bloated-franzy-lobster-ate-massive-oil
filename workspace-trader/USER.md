# USER.md - Trader

- **Name:** ITPOFY
- **Call:** boss
- **TZ:** America/Chicago
- **Notes:** Rule-based crypto perp trading on Hyperliquid.
  Expects full autonomy during trading cycles. Alert on anomalies.

## Active Systems
- Engine: ~/silvering/silver/trading-engine/ (TypeScript)
- Exchange: Hyperliquid perpetuals
- Data: MySQL localhost:3306

## Alert Conditions
- API failure after one retry
- Rule triggered outside parameters
- Position without matching log entry
- Engine not running during cycle
