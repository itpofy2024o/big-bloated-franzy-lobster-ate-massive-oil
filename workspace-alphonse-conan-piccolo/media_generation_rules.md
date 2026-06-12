# Media Generation Rules & Pricing

## Image Generation

### Fast Track
*   **Non-photorealistic / Non-fantasy / Non-scifi:**
    *   Model: `@cf/black-forest-labs/flux-1-schnell`
    *   Pricing: $0.000053 per 512x512 tile, $0.00011 per step.
*   **Photorealistic / Fantasy / Scifi:**
    *   Model: `@cf/black-forest-labs/flux-2-dev`
    *   Pricing: $0.00041 per 512x512 tile, per step.

### Swift Drama
*   **Non-photorealistic / Non-fantasy / Non-scifi:**
    *   Model: `black-forest-labs/flux.2-klein-4b`
    *   Pricing: $0.014 per output megapixel.
*   **Photorealistic / Fantasy / Scifi:**
    *   Model: `black-forest-labs/flux.2-pro`
    *   Pricing: $0.03 per output megapixel.

**Note on Model IDs:**
*   `cf` prefix: Cloudflare Worker AI (paid plan if exceeding monthly quota).
*   No `cf` prefix: OpenRouter.

---

## Image Dimensions

### Character Image
*   **Width:** 360–720 (random)
*   **Height:** 450–900 (random)

### Scene Image
*   **Width:** 700–1000 (random)
*   **Height:** 500–820 (random)

---

## Video Generation (Image Input Limits)

| Mode | Max Images | Breakdown | Character Consistency |
| :--- | :--- | :--- | :--- |
| **Fast Track** | 8 | 6 character, 2 scene | Yes (stay same across clips) |
| **Swift Drama** | 10 | 6 character, 4 scene | Yes (stay same across clips) |

---

## Video Model Pricing

### xAI: Grok Imagine Video (`x-ai/grok-imagine-video`)
*   **Video Output:**
    *   480p: $0.05 /sec
    *   720p: $0.07 /sec
*   **Image Input:** $0.002 /image

### Kling: Video v3.0 Standard (`kwaivgi/kling-v3.0-std`)
*   **With Audio:** $0.126 /sec
*   **No Audio:** $0.084 /sec

### Google: Veo 3.1 Fast (`google/veo-3.1-fast`)
*   **With Audio:**
    *   720p: $0.10 /sec
    *   1080p: $0.12 /sec
    *   4K: $0.30 /sec
*   **No Audio:**
    *   720p: $0.08 /sec
    *   1080p: $0.10 /sec
    *   4K: $0.25 /sec

### Google: Veo 3.1 Lite (`google/veo-3.1-lite`)
*   **With Audio:**
    *   720p: $0.05 /sec
    *   1080p: $0.08 /sec
*   **No Audio:**
    *   720p: $0.03 /sec
    *   1080p: $0.05 /sec
