
# Definitions

|**Term / Entity**|**Definition & Relationship Boundary**|**Operational Guardrail**|
|---|---|---|
|**Working Tree**|The local directory of untracked and modified files on disk.|Modifying dirty files can cause unrecoverable data loss. Always check `git status` before switching branches.|
|**Index (Staging Area)**|The intermediate buffer holding changes slated for the next commit.|Separated from the working tree; untracked files are not in the index.|
|**Branch**|A movable pointer to a commit hash within the commit graph.|Local branches and remote tracking branches (`origin/main`) are distinct entities that must be explicitly synchronized.|
|**Worktree**|A linked secondary directory attached to the same repository database, allowing multiple branches to be checked out simultaneously.|**Critical Constraint:** Two worktrees cannot have the same branch checked out at the same time.|