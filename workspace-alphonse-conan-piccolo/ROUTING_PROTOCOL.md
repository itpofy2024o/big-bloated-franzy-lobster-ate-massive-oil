# ROUTING_PROTOCOL.md — Alphonse Routing Agent

## HOW TO ROUTE

```
STEP 1: sessions_list()
        Run once. Get all active sessions.
        Note any session matching target agentId.

STEP 2A: Session EXISTS for target agent
        sessions_send(
          sessionKey: "<key>",
          message: "<task>",
          model: "<model_from_tier>"
        )

STEP 2B: Session DOES NOT EXIST
        sessions_spawn(
          agentId: "<target>",
          task: "Initialize persistent session. Do NOT execute any work yet. Wait for the next sessions_send instruction.",
          model: "<model_from_tier>"
        )
        → Returns a childSessionKey.

        sessions_send(
          sessionKey: "<childSessionKey>",
          message: "<task>",
          model: "<model_from_tier>"
        )

STEP 3: WAIT.
        Do not proceed until agent replies with an exact file path.
        "I'll do this" = NOT done.
        "Done. Output at: /path/file.md" = DONE.

STEP 4: fs_stat("<path>")
        If file confirmed → continue.
        If fs_stat fails:
            retry same agent once.
            If still no file → route to disaster-manager-wick.
```

- NEVER call sessions_spawn without BOTH:
  agentId AND task AND model parameters.

- The task in sessions_spawn MUST be a bootstrap only.
  Never include the real task in spawn. Always send real work via sessions_send.

Receiver authority rule: the receiving agent must run its own model-routing step using its own agent section. The sender `model:` value is advisory unless the user explicitly set a model in the latest user message.

## If sessions_send Fails

1. Wait 5 minutes.
2. sessions_list() again.
3. Retry with same or new key.
4. After 3 failures on same agent: route to disaster-manager-wick.
   Message: "Wick: agent <id> unresponsive after 3 attempts. Task: <task>."

## Rate Limit Rule

If rate limited on any call: wait 5 minutes, retry. Never abandon mid-pipeline.
