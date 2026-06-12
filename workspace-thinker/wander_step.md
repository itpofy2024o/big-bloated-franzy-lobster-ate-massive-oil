DO NOT ASK USER FOR PERMISSION.

TODAY = YYYYMMDD of today in cron timezone.

This is an Alphonse orchestration pipeline. You do NOT execute work yourself.
Your only job is to spawn agents in sequence using sessions_spawn.

Spawning rules:
- agentId must be the exact agent name
- task must include the exact paths and requirements from each step below
- Do NOT specify a model — each agent uses its own model routing (conan-made-model-routing)
- After each spawn, wait for it to complete, read its output file(s), then continue

Step 0: Read the reference files below to understand format and quality expectations. Do NOT copy-paste content from them — they are references only.
Then begin spawning.

================================================================================
SPAWN 1 — thinker (STEP 1 + STEP 2):
================================================================================

sessions_spawn(
  agentId="thinker",
  task="Read PROMPT.md at ~/.openclaw/workspace/workspace-thinker/new_idea_gen/PROMPT.md

Generate 13 business ideas. Brainstorm and rank them strongest to weakest based on:
- deployable with $0-$100 budget for solo NRA founder
- best viral/organic growth mechanism  
- best revenue model (Month 1 / Year 1.5 / Year 3.5 / Year 8)
- operates legally through NM LLC remotely
- best payment strategy (CRYPTO / FIAT / BOTH)

Rank 1 = strongest candidate.

NOW = current HHMM in cron timezone.

Write ONLY to: ~/.openclaw/workspace/workspace-thinker/gen/strider_[TODAY]_[NOW].md

--- READ BEFORE GENERATING: Avoid duplicates ---

1. FORMAT REFERENCE (structure only, do NOT copy content):
   Read: ~/.openclaw/workspace/workspace-thinker/new_idea_gen/SAMPLE.md
   This file shows the expected section layout, field names, output structure. Study the format, then write your own original content. Do NOT copy any text from this file into your output.

2. QUALITY CONTENT REFERENCE (depth/quality standard, do NOT copy content):
   Read: ~/.openclaw/workspace/workspace-thinker/gen/strider_20260502.md
   This file shows the expected completeness and detail depth — how thorough each section should be, the level of specificity, the quality bar. It is NOT source material. Do NOT copy any text from this file into your output.

3. DEDUPLICATION — scan all previous idea content to avoid repeats:
   List all files in ~/.openclaw/workspace/workspace-thinker/gen/ matching troller_*.md and strider_*.md.
   For each file, extract the full content of each ranked candidate (all 13 positions in troller_*.md; all ideas in strider_*.md).
   For each candidate, write a condensed concept summary covering: core concept, revenue model, target market, viral growth mechanism, and tech approach.
   Build a dedup corpus of all previous idea summaries.
   When generating each new idea:
     1. First draft its own concept summary (same fields as above).
     2. Compare it semantically against the dedup corpus.
     3. If the new idea's concept summary is ≥70% similar to ANY previous idea's summary → discard it and generate a genuinely new replacement.

CRITICAL: Write ALL 13 ideas in full with complete detail sections. No shortcuts. No "condensed for brevity." No "full list in attached file." Every single idea must have its own complete section with all fields populated. Verify count before finishing.",
)

After spawn 1 completes, read the strider file. Extract IDEA_NAME from rank 1. Set N=1.
Verify ALL 13 ideas have detail sections. If any are missing, reject and re-spawn SPAWN 1.

================================================================================
LOOP — N from 1 to 13 (one cycle per candidate):
================================================================================

Before each cycle, IDEA_NAME = rank N from strider. N starts at 1.

SPAWN 2 — planner (STEP 3):
sessions_spawn(
  agentId="planner",
  task="Read: ~/.openclaw/workspace/workspace-thinker/gen/strider_[TODAY]_[NOW].md
Use candidate rank N only (IDEA_NAME).
Write to: ~/.openclaw/workspace/workspace-planner/plans/plan_[IDEA_NAME].md
Include: problem, users, MVP features only, system design, monetization, assumptions, risks, region/demographic, non-MVP at bottom.
No idea drift. No over-engineering. Choose the database that actually fits the product's data model, access patterns, and scale expectations.

PAYMENT GATEWAY RESTRICTION: Monetization must use ONLY: Stripe, BTCPayServer, Shkeeper, L402, X402, BitCart, PayRam, PayGate, ETH L2 Smart Contract, PayPal.

MUST explicitly specify (with 1-line justification per choice):
- Hosting approach:
  - No: Fly.io, Render, Railway, Vercel, Netlify, and Azure.
  - Yes: Cloudflare Pages, AWS, GCP, VPS, Heroku, Clouflare Worker, .
- Frontend approach (Make sure frontend framework needs to be compatible inside the chosen hosting approach, such as if deployed to Cloudflare Pages, frontend must be static or server-rendered, if deployed to Cloudflare Worker, frontend must be compatible with Worker):
  - If none: State "No frontend needed (e.g., Cloudflare Pages static, agentic AI API, pure backend API)" and note no frontend scaffolding needed
  - If server-rendered: State "Server-rendered HTML (e.g., Express + EJS)" and note no separate frontend framework needed
  - If framework: Exact framework (React/Next.js/Nuxt) + exact init CLI command
- Backend framework (Make sure backend framework needs to be compatible inside the chosen hosting approach, such as if deployed to Cloudflare Worker, backend must be compatible with that):
  - If none: State "No backend needed (e.g., Cloudflare Pages static, pure frontend SPA)" and note no backend scaffolding needed
  - If framework: Exact framework + exact init CLI command
- Database (Make sure database choice needs to be compatible inside the chosen hosting approach, such as if deployed to Cloudflare Worker, database must be compatible with that):
  - Exact choice + justification (or "none" if no database needed)
- AI Model Provider (Only if the product needs LLM or AI service integration for generative responses. If so, MUST choose from the OKAYAI list below and specify exact provider + model):
  - EXACT provider + model (e.g., "OpenRouter / openai/gpt-4o-mini", "xAI / grok-2")
  - OKAYAI: If the app needs LLM/AI model integration for generative responses, you MAY use ONLY these providers:
    - OpenRouter (openrouter.ai)
    - Kilocode / Kilogateway (kilocode.ai)
    - xAI (x.ai)
    - Fal AI (fal.ai)
    - ElevenLabs (elevenlabs.io)
    - Gemini AI Studio / Vertex AI (Google)
    - RunwayML (runwayml.com)
    - Pika (pika.art)
    - Luma AI (lumalabs.ai)
    - Stability AI (stability.ai)
  - Do NOT use OpenAI, Anthropic, or any other provider not in this OKAYAI list.
  - If a provider outside the list was previously considered, replace it with OpenRouter (which supports most models via its unified API).
- This section is REQUIRED for Step 7. Do not omit any field.",
)

After planner finishes, read the plan file.

SPAWN 3 — mira (STEP 4):
sessions_spawn(
  agentId="mira",
  task="Read: ~/.openclaw/workspace/workspace-planner/plans/plan_[IDEA_NAME].md
Write to: ~/.openclaw/workspace/workspace-mira/reviews/rima_moral_test_[IDEA_NAME].md
Minimum 700 words. Evaluate: harm, privacy/data misuse, manipulation/dark patterns, exploitation/addiction, fairness/bias, mitigations.
Must include:
- Executive judgement
- ETHICAL_SCORE: 0-100
- ETHICAL_DECISION: PASS/FAIL
- Risk table with severity + likelihood
- At least 5 concrete risks
- At least 5 mitigations
- Red-line conditions that would make this unethical
- Safer MVP design recommendation
PASS only if score >=70 and no critical unresolved harm.",
)

After mira finishes, read the review file. Record ETHICAL_DECISION.

SPAWN 4 — legolas (STEP 5):
sessions_spawn(
  agentId="legolas-the-unyielder",
  task="Read: ~/.openclaw/workspace/workspace-planner/plans/plan_[IDEA_NAME].md
Write to: ~/nosensetxt/.openclaw/workspace/workspace-legolas-the-unyielder/output/
Decide filename:
  SAFE -> green_prince_is_astonished_[IDEA_NAME].md
  RISK -> green_prince_appalled_[IDEA_NAME].md
Minimum 900 words.
Score these dimensions: REGULATORY, CUSTODY, DATA, PLATFORM, MVP_FEASIBILITY (LOW=0 MEDIUM=1 HIGH=2)
LEGAL_SCORE = sum 0-10. SAFE if <=3, RISK if >=4.
Must include:
- Executive legal judgement
- LEGAL_SCORE and dimension breakdown
- LEGAL_DECISION: SAFE/RISK
- Jurisdiction assumptions
- Major legal risks
- Compliance requirements
- What the MVP may safely do
- What the MVP must avoid
- Mitigations
- Final go/no-go recommendation",
)

After legolas finishes, read the output file. Record LEGAL_DECISION.

Evaluate (thinker-owned, you do this yourself): 
- WORKABLE = MVP buildable in one coder run
- ETHICAL = mira ETHICAL_DECISION == PASS
- LEGAL = legolas LEGAL_DECISION == SAFE

If ANY is FAIL → skip this candidate. Increment N. Go to next cycle.
Delete files for this IDEA_NAME from:
  ~/.openclaw/workspace/workspace-planner/plans/
  ~/.openclaw/workspace/workspace-mira/reviews/
  ~/.openclaw/workspace/workspace-legolas-the-unyielder/output/
  ~/alu/

If ALL are PASS → break out of loop. Continue to SPAWN 5.

If N > 13 and all failed → go to SPAWN 6 (report only).

================================================================================
SPAWN 5 — coder (STEP 7a/7b/7c):
================================================================================

Score build dimensions: COMPONENTS, INTEGRATIONS, DATA, UI, ONE_RUN_RISK (LOW=0 MEDIUM=1 HIGH=2)
BUILD_SCORE = sum 0-10

If BELOW_T3 (0-3) or T3 (4-6):
sessions_spawn(
  agentId="coder",
  task="Build a production-grade MVP for IDEA_NAME.

First: Read the plan file's framework specification section. Extract:
1. Frontend init command (or "none" if no frontend needed/static/server-rendered)
2. Backend init command (or "none" if no backend needed)
3. Database choice (or "none" if no database needed)

CRITICAL: Run ONLY the init commands specified in the plan. If frontend is "none", skip all frontend scaffolding. If backend is "none", skip all backend scaffolding. Do NOT guess or add extra frameworks.

Run official framework CLI init commands (e.g., `npx create-react-app frontend`, `npx create-next-app@latest frontend`, `nuxi init backend`, `npm create cloudflare@latest backend`; these are only recommendations, feel free to use python golang rust bun pnpm nuxt remix tanstack wasm) inside ~/alu/[IDEA_NAME]/ to scaffold project structure. Do NOT create core app files from scratch via `mkdir -p` and manual file creation. Edit scaffolded files and add only necessary new files.

Read these files:
- ~/.openclaw/workspace/workspace-planner/plans/plan_[IDEA_NAME].md
- ~/.openclaw/workspace/workspace-mira/reviews/rima_moral_test_[IDEA_NAME].md
- ~/.openclaw/workspace/workspace-legolas-the-unyielder/output/green_prince*_[IDEA_NAME].md

Copy these three files into ~/alu/[IDEA_NAME]/ after scaffolding.

Build the MVP into: ~/alu/[IDEA_NAME]/

CLOUDFLARE AUTO-DEPLOY (if the plan specifies Cloudflare Pages, Worker, or D1):
1. After building, run `npx wrangler whoami` to verify user is already authenticated (no login needed)
2. If using D1: Create remote D1 database (no `--remote` flag needed -- `d1 create` is always remote):
   `npx wrangler d1 create [IDEA_NAME]-db`
   Capture the returned `database_id` and update `wrangler.toml` under `[[d1_databases]]`.
   Then find the schema SQL file (e.g. `worker/schema.sql`, `db/schema.sql`, or `schema.sql` in project root) and apply it to the remote DB:
   `npx wrangler d1 execute [IDEA_NAME]-db --file=path/to/schema.sql --remote`
3. Run `npx wrangler deploy` (or `npx wrangler pages deploy` for Pages projects)
4. If the project uses secrets (API keys, etc.), note them in a .dev.vars.template file but do NOT commit real secrets
Do NOT prompt the user for wrangler auth — they're already authenticated locally.

QUALITY STANDARDS (non-negotiable):
- Configurable architecture: env-based config, env vars for all configuration points, no hardcoded values
- Proper error handling: try/catch on all fallible ops, meaningful error messages, graceful degradation
- Input validation: sanitize all user inputs, reject malformed data with clear errors
- Logging: structured logging (not console.log spam), appropriate log levels
- Web conventions: proper HTTP status codes where applicable, standard request/response patterns
- Readable, modular code: split by concern, consistent naming, comments only where logic is non-obvious
- Basic security: injection prevention for chosen stack (parameterized queries for SQL, proper escaping for others), no secrets in source, rate limiting where applicable
- Stack-appropriate patterns: follow conventions of the language/framework chosen. MUST use official framework scaffolding CLI tools to initialize project structure before editing files. Include schema setup for the chosen database. For SQL: migration-ready setup. For document/NoSQL: schema validation layer.

Build each file as if the next developer will extend it. Make it functional AND defensible.",
)

If T4 (7-10):
sessions_spawn(
  agentId="coder",
  task="Do NOT build the full MVP.
Write a no-build note to: ~/alu/[IDEA_NAME]/NO_BUILD_T4.md
Include: IDEA_NAME, BUILD_SCORE, reason it is T4, which parts made it too large for one coder run, smallest possible partial MVP suggestion.",
)

After coder finishes, check if files exist in ~/alu/[IDEA_NAME]/.
If yes, proceed to SPAWN 6a/6b/6c. If no, skip.

================================================================================
SPAWN 6a/6b/6c — simza / echo / robert (STEP 8, parallel):
================================================================================

Only if coder created files in ~/alu/[IDEA_NAME]/:

sessions_spawn(
  agentId="simza",
  task="Create Substack, Twitter/X, Reddit, and Hacker News launching posts for IDEA_NAME.
Save to ~/alu/[IDEA_NAME]/marketing/",
)

sessions_spawn(
  agentId="echo",
  task="Create market-orientation narrative for IDEA_NAME.
Save to ~/alu/[IDEA_NAME]/marketing/",
)

sessions_spawn(
  agentId="robert",
  task="Simulate user/character reactions for IDEA_NAME.
Save to ~/alu/[IDEA_NAME]/marketing/",
)

================================================================================
SPAWN 7 — thinker (STEP 9 — report):
================================================================================

sessions_spawn(
  agentId="thinker",
  task="Write a report to: ~/.openclaw/workspace/workspace-thinker/reports/wander_report_[TODAY]_[IDEA_NAME].md
Max 800 words.
Include: idea, rank, rejected ideas, planner/mira/legolas results, ethical score, legal score, tier/build score, build result, marketing result, all paths, failures/skips.",
)

================================================================================
FINAL OUTPUT
================================================================================

Return concise final summary only. One paragraph max.
Include: which idea won, what was built, key findings.
