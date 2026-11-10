---
name: agent-rules
description: General rules to optimize content loaded into session. Use when asked for by user and inside all subagents.
---

# Guards

Applies to primary agents and all subagents.

1. Never overwrite human authored content unless given permission to do so
2.. Warn user if a tool you need isn't installed or available.  Do not install a tool unless approved. 

## General Research

2. Use context7 tool as primary source when its available 
3. Prefer primary sources: repo, docs, changelog, API. Not blog posts about the repo.

## Local Code & Files

1. Before searching or reading source code, check structural-tool availability:
   - Run `command -v ast-grep` once. If found, use it immediately.
   - Otherwise, run `command -v sg`. If found, run `sg --version`
     to verify that it is ast-grep.
   - Discovery budget: at most three simple shell calls. Do not write
     discovery scripts, scan filesystem locations, inspect package managers,
     or search for alternative parsers unless the user requests it.
   - Reuse the result within the task. Repeat checks only if the executable
     fails or the environment changes.
2. Use structural analysis to identify relevant files, symbols, or ranges
   before reading source text. Start with `ast-grep outline <known-path>`.
   If `outline` is unsupported, use `ast-grep run` or `ast-grep scan`;
   do not restart tool discovery. Reuse known source paths instead of
   rediscovering repository locations unless those paths are unavailable.
3. Text-search tools do not satisfy this requirement. Do not use grep,
   ripgrep, sed, awk, shell scripts, or equivalent text-search tools as
   substitutes for structural analysis.
4. After structural analysis identifies a relevant location, targeted text
   reads of that location are permitted. Do not read entire source files.
5. If neither executable is usable after these checks, STOP code inspection.
   Report the missing capability and ask permission to install a tool or
   use a text-search fallback. Do not silently fall back.
6. Do not assume that an executable named sg is ast-grep. Verify its identity.
7. Include these requirements in every delegated code-inspection task.
   Pass known source paths and discovered tool paths to subagents.
   Subagents must report which structural tool they used.
8. File-path discovery, tool-availability checks, and reading non-code
   configuration or documentation are exempt.
9. Never rewrite entire files. Always use patch tools to target specific edits. If a patch tool isn't available, stop and ask permission to install one.

## Web Search & Fetch

1. Never fetch entire, raw web results. Use web compression tools (ie. tinyfish, parallel) to retrieve specific content sections. 
2. If a web compression tool isn't available, stop and ask permission to install one.
