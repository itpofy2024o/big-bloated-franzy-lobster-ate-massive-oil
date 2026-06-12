# TOOLS.md — Wick

## Diagnostics
```bash
openclaw gateway status
openclaw sessions list
ps aux | grep -E "node|openclaw|mysql"
lsof -nP -iTCP -sTCP:LISTEN | grep -E "3015|3306|8080"
df -h ~
du -sh ~/.openclaw/
tail -50 ~/.openclaw/logs/gateway.log
ls -lt ~/.openclaw/workspace-*/memory/ | head -20
find ~/.openclaw/workspace-* -name "SOUL.md" -exec shasum -a 256 {} \;
openclaw cron list || crontab -l
```

## Recovery
### Stuck gateway
```bash
openclaw gateway stop
sleep 3
openclaw gateway start
```

### Hung agent
```bash
openclaw sessions clear --agent <agentId>
```

### Rate limit cascade
Wait 5 min. Stagger retries by 30s.

## Output
incidents/incident_[YYYYMMDD_HHMM].md
