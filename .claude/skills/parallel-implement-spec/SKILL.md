---
name: parallel-implement-spec
description: Implement all tasks from a specification document using parallel subagents with isolated worktrees, independent code review, and cherry-pick integration.
---

# Parallel implement from specification

Implement **every task** from a specification/plan document using the implement → review → fix subagent workflow, parallelized across git worktrees.

## Hard rules

1. **Complete every task.** Count tasks before starting. After finishing, produce a completion table mapping every task ID to its commit SHA or failure reason. Never silently skip a task.
2. **Never modify the primary branch.** Create a dedicated integration branch and worktree before any work begins. That integration branch is the sole cherry-pick target. The primary worktree stays read-only. The user decides how to merge the integration branch when you're done.
3. **Match the launching model.** Pass the `model` parameter explicitly to every subagent so implement, review, and fix agents all run on the same model as the parent.

## Task lifecycle

Each task goes through three phases:

1. **Implement** — `general-purpose` subagent. Provide the spec path, the specific task section, and the worktree path. Instruct it to implement completely (no TODOs or stubs), study existing code patterns, register modules in index/mod files, and run the build and tests — but NOT commit.

2. **Review** — `code-review` subagent. Verify every spec requirement is addressed. Flag only genuine bugs, logic errors, missing requirements, or safety issues — not style. Call out any unimplemented spec requirements.

3. **Fix + Commit** — if the reviewer found issues, spawn a `general-purpose` subagent to fix them. Once clean, commit with a descriptive message and the co-author trailer.

## Git worktree strategy

### Setup (before any task work)

```bash
# 1. Create the integration worktree — branches off current HEAD
git worktree add ../<repo>-integration HEAD -b integration/<feature>
```

### Per-task worktrees

```bash
# 2. Branch each task off the integration branch (includes prior-wave commits)
git worktree add ../<repo>-<task-id> integration/<feature> -b task/<task-id>
```

### Cherry-pick into integration (never main)

```bash
# 3. After a task commits, cherry-pick into the integration worktree
cd ../<repo>-integration
git cherry-pick <commit-sha>
```

If `git branch --show-current` shows `main` or the original branch, **STOP** — wrong worktree.

After each cherry-pick, resolve conflicts (keep both sides of shared index/mod files, sort consistently) and verify the build passes.

### Cleanup

```bash
# 4. Remove task worktrees; keep the integration worktree for the user
git worktree remove ../<repo>-<task-id>
git branch -D task/<task-id>
```

Do NOT merge the integration branch into main.

## Parallelization

1. **Parse dependencies** from the spec. Group tasks into waves by dependency order.
2. **Wave 0** — all tasks with no dependencies, launched in parallel in separate worktrees.
3. **Subsequent waves** — after all current-wave tasks are cherry-picked into the integration branch, launch the next wave's tasks in parallel (branching from the updated integration HEAD).
4. Within a wave: review launches as soon as implement completes; fix launches as soon as review completes.

## Validation

After all tasks are integrated into the integration worktree:

1. Confirm every spec task has a commit. Print the completion table.
2. Run the full build and test suite.
3. Verify one clean commit per task in the log.

## Holistic review

After validation, launch parallel `code-review` subagents against the **integration worktree** to review the combined changeset against the spec:

- **Correctness** — every acceptance criterion met, no spec divergences.
- **Cross-cutting** — broken interactions, inconsistent conventions, duplicated logic across tasks.
- **Quality** — dead code, missing tests for public APIs, hardcoded values, panics in non-test code.

Present findings by severity (🔴 Blocking / 🟡 Advisory / ✅ Clean). Do NOT auto-fix — let the user decide.

## Error handling

- If a task fails to compile after the fix cycle, skip it and report explicitly.
- If a cherry-pick conflict can't be auto-resolved, ask the user.
- If the spec has circular dependencies, report the cycle and ask the user to break it.
