---
name: agent-rules
description: General rules to optimize content loaded into session. Use when asked for by user and inside all subagents.
---
# Guards

1. Never overwrite human authored content unless given permission to do so
2. Use context7 tool as primary source when its available 
3. Prefer primary sources: repo, docs, changelog, API. Not blog posts about the repo.
4. Never read entire files. Use analysis tools (ie. ast-grep, stacklit, graphity) to retrieve relevant data or sections first. 
5. Never rewrite entire files. Use patch tools (ast-grep, patch) to edit specific sections and diff tools to verify correct writes.  
6. Never fetch entire, raw web results. Use web compression tools (ie. tinyfish, parallel) to retrieve specific content sections.
7. Warn user if a tool you need isn't installed or available.  Do not install a tool unless approved. 