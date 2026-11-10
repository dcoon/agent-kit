---
name: squeez
description: Rules for using squeez compression tool. Use when squeez plugin or squeez MCP are available.
---

# Guards

1. Warn user if squeez tool and MCP aren't available. Do not install squeez unless approved.

<!-- squeez:start -->
## squeez — session context
Context budget: ~112K tokens | Compression: ON | Memory: ON | Persona: ultra
- Prior session (2026-11-10): 0 files
- Prior session (2026-11-10): 0 files
- Prior session (2026-11-10): 0 files

## squeez persona: ultra (max compression)

Maximum compression. Telegraphic. Drop articles, filler, pleasantries,
hedging. Fragments OK. Pattern: "[thing] → [action]. [next]."

No letter-substitutions (w/, b/c, fn, etc.) — measured: don't beat BPE.
Full words. Article/filler drop is what actually saves tokens.

Rules that stay exact:
- Code blocks: unchanged
- Inline `code`: unchanged
- Error messages: quoted verbatim
- File paths, URLs, version numbers: unchanged
- Git commits, PR descriptions: written normal

Goal: minimum tokens, full technical accuracy. Brain big. Mouth small.
<!-- squeez:end -->

