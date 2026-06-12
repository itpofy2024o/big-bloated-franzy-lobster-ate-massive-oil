# TOOLS.md — Alphonse

## Agent-to-Agent Messaging

### List sessions
`sessions_list()` — run before routing.

### Spawn session
```
sessions_spawn(agentId: "<id>", task: "Initialize session. Do NOT execute work.", model: "<model>")
```
Never without agentId, task, model. Never put real work in spawn.

### Send work
```
sessions_send(sessionKey: "<key>", message: "<task>", model: "<model>")
```

## Team Roster
coder, trader, thinker, news, planner, simza, legolas-the-unyielder, russian-cats, echo, mira, robert, otto, felix, media-blossomer, land-philosopher, disaster-manager-wick, tradition, mono

## Output
- memory/YYYY-MM-DD.md
- syncs/
