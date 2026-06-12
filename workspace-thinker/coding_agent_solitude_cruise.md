DO NOT ASK USER FOR PERMISSION.

This is a standalone pipeline to be executed directly by you.

TODAY = YYYYMMDD of the current date.
NOW = current HHMM in cron timezone.

Step 0: Read the reference files below to understand format and quality expectations. Do NOT copy-paste content from them — they are references only.
Then begin executing steps.

================================================================================
STEP 1 + STEP 2: Generate 13 ranked business ideas
================================================================================

Read PROMPT.md at ~/.openclaw/workspace/workspace-thinker/new_idea_gen/PROMPT.md

Generate 13 business ideas. Brainstorm and rank them strongest to weakest based on:
- deployable with $0-$100 budget for solo NRA founder
- best viral/organic growth mechanism  
- best revenue model (Month 1 / Year 1.5 / Year 3.5 / Year 8)
- operates legally through NM LLC remotely
- best payment strategy (CRYPTO / FIAT / BOTH)

Rank 1 = strongest candidate.

CRITICAL: Write ALL 13 ideas in full with complete detail sections. No shortcuts. No "condensed for brevity." No "full list in attached file." Every single idea must have its own complete section with all fields populated. Verify count before finishing.

Write ONLY to: ~/.openclaw/workspace/workspace-thinker/gen/troller_[TODAY]_[NOW].md

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

After completing this step, verify ALL 13 ideas have complete detail sections. If any are missing, repeat STEP 1+2.
Extract IDEA_NAME from rank 1. Set N=1.

================================================================================
LOOP — N from 1 to 13 (one cycle per candidate):
================================================================================

Before each cycle, IDEA_NAME = rank N from troller. N starts at 1.

================================================================================
STEP 3: Generate business plan for candidate N
================================================================================

Read: ~/.openclaw/workspace/workspace-thinker/gen/troller_[TODAY]_[NOW].md
Use candidate rank N only (IDEA_NAME).
Write to: ~/.openclaw/workspace/workspace-planner/plans/scheme_[IDEA_NAME].md
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
- This section is REQUIRED for Step 7. Do not omit any field.

After completing this step, read the plan file.

================================================================================
STEP 4: Ethical review for candidate N
================================================================================

Read: ~/.openclaw/workspace/workspace-planner/plans/scheme_[IDEA_NAME].md
Write to: ~/.openclaw/workspace/workspace-mira/reviews/rima_ethical_crunching_[IDEA_NAME].md
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
PASS only if score >=70 and no critical unresolved harm.

After completing this step, read the review file. Record ETHICAL_DECISION.

================================================================================
STEP 5: Legal review for candidate N
================================================================================

Read: ~/.openclaw/workspace/workspace-planner/plans/scheme_[IDEA_NAME].md
Write to: ~/.openclaw/workspace/workspace-legolas-the-unyielder/output/
Decide filename:
  SAFE -> milton_is_angry_[IDEA_NAME].md
  RISK -> milton_is_bored_[IDEA_NAME].md
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
- Final go/no-go recommendation

After completing this step, read the output file. Record LEGAL_DECISION.

Evaluate:
- WORKABLE = MVP buildable in one run
- ETHICAL = ETHICAL_DECISION == PASS
- LEGAL = LEGAL_DECISION == SAFE

If ANY is FAIL → skip this candidate. Increment N. Go to next cycle.
Delete files for this IDEA_NAME from:
  ~/.openclaw/workspace/workspace-planner/plans/
  ~/.openclaw/workspace/workspace-mira/reviews/
  ~/.openclaw/workspace/workspace-legolas-the-unyielder/output/
  ~/alu/

If ALL are PASS → break out of loop. Continue to STEP 7.

If N > 13 and all failed → go to STEP 6 (report only).

================================================================================
STEP 7a/7b/7c: Build MVP for candidate N
================================================================================

Read these files to determine required frameworks and MVP requirements:
- ~/.openclaw/workspace/workspace-planner/plans/scheme_[IDEA_NAME].md
- ~/.openclaw/workspace/workspace-mira/reviews/rima_ethical_crunching_[IDEA_NAME].md
- ~/.openclaw/workspace/workspace-legolas-the-unyielder/output/milton*_[IDEA_NAME].md

First: Read the plan file's framework specification section. Extract:
1. Frontend init command (or "none" if no frontend needed/static/server-rendered)
2. Backend init command (or "none" if no backend needed)
3. Database choice (or "none" if no database needed)

CRITICAL: Run ONLY the init commands specified in the plan. If frontend is "none", skip all frontend scaffolding. If backend is "none", skip all backend scaffolding. Do NOT guess or add extra frameworks.

First: Create ~/alu/[IDEA_NAME]/ directory using exec mkdir.
Run official framework CLI init commands (e.g., `npx create-react-app frontend`, `npx create-next-app@latest frontend`, `nuxi init backend`, `npm create cloudflare@latest backend`; these are only recommendations, feel free to use python golang rust bun pnpm nuxt remix tanstack wasm) inside ~/alu/[IDEA_NAME]/ to scaffold project structure. Do NOT create core app files from scratch via `mkdir -p` and manual file creation. Edit scaffolded files and add only necessary new files.

Copy the three files read above into ~/alu/[IDEA_NAME]/ after scaffolding.

Build the MVP into: ~/alu/[IDEA_NAME]/

CLOUDFLARE AUTO-DEPLOY (if applicable):
If the plan specifies Cloudflare Pages, Cloudflare Worker, or Cloudflare D1:
1. After building, run `npx wrangler whoami` to verify user is already authenticated (no login needed)
2. If using D1: Create remote D1 database (no `--remote` flag needed — `d1 create` is always remote):
   `npx wrangler d1 create [IDEA_NAME]-db`
   Capture the returned `database_id` and update `wrangler.toml` under `[[d1_databases]]`.
   Then find the schema SQL file (e.g. `worker/schema.sql`, `db/schema.sql`, or `schema.sql` in project root — whatever was scaffolded or created in this step) and apply it to the remote DB:
   `npx wrangler d1 execute [IDEA_NAME]-db --file=path/to/schema.sql --remote`
   The `--remote` flag is required here to push schema to the live Cloudflare D1 instance.
3. Run `npx wrangler deploy` (or `npx wrangler pages deploy` for Pages projects)
4. Verify the deploy succeeded by checking the output URL
5. If the project uses secrets (API keys, etc.), note them in a .dev.vars.template file but do NOT commit real secrets
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
- Build each file as if the next developer will extend it. Make it functional AND defensible.

After completing this step, check if files exist in ~/alu/[IDEA_NAME]/.
If yes, proceed to STEP 8a/8b/8c. If no, skip.

================================================================================
STEP 8a/8b/8c: Generate marketing content for candidate N (parallel)
================================================================================

Only if files were created in ~/alu/[IDEA_NAME]/:

1. Create Substack, Twitter/X, Reddit, and Hacker News launching posts for IDEA_NAME. (simza role)
Save to ~/alu/[IDEA_NAME]/marketing/

2. Create market-orientation narrative for IDEA_NAME. (echo role)
Save to ~/alu/[IDEA_NAME]/marketing/

3. Simulate user/character reactions for IDEA_NAME. (robert role)
Save to ~/alu/[IDEA_NAME]/marketing/

These three tasks can be completed in parallel.

================================================================================
STEP 9: Final report for candidate N
================================================================================

Write a report to: ~/.openclaw/workspace/workspace-thinker/reports/troller_report_[TODAY]_[IDEA_NAME].md
Max 800 words.
Include: idea, rank, rejected ideas, planner/mira/legolas results, ethical score, legal score, tier/build score, build result, marketing result, all paths, failures/skips.

================================================================================
FINAL OUTPUT
================================================================================

Return concise final summary only. One paragraph max.
Include: which idea won, what was built, key findings.
