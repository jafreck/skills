---
name: parallel-implement-spec
description: Implement all tasks from a specification document using parallel subagents with isolated worktrees, independent code review, and cherry-pick integration.
---

# Parallel implement from specification

Implement all tasks from a specification/plan document using the implement→review→fix subagent workflow, parallelized across git worktrees where the dependency graph allows.

## Usage

Use this skill when asked to implement a multi-task plan, specification, or implementation document. The user should provide the path to the spec document (or it should be discoverable in the repo). The spec must define discrete tasks with a dependency graph.

## Workflow per task

Each task goes through three phases:

1. **Implement** — spawn a `general-purpose` subagent to implement the task. Provide it with:
   - The spec document path and the specific task section to implement
   - The working directory (repo root or worktree path)
   - Instructions to study existing code patterns before writing new code
   - Instructions to register new modules in the appropriate mod/index files
   - Instructions to run the build and tests, but NOT commit

2. **Review** — spawn a `code-review` subagent to independently review the implementation. Instruct it to:
   - Focus on correctness, safety, edge cases, and interaction with existing code
   - Only flag genuine bugs, logic errors, or missing safety checks (not style)
   - Reference the spec to verify completeness

3. **Fix + Commit** — if the reviewer found issues, spawn a `general-purpose` subagent to fix them. Whether the fixer or reviewer found no issues, the final agent commits with a descriptive message and the co-author trailer. If no issues were found, have the implement agent commit directly (or spawn a small commit agent).

## Parallelization strategy

1. **Parse the dependency graph** from the spec. Identify which tasks can run in parallel (no mutual dependencies, different output files).

2. **Wave execution**:
   - Start with tasks that have no dependencies (wave 0).
   - After wave 0 completes and is committed, launch all tasks whose dependencies are satisfied in parallel.
   - Continue until all tasks are done.

3. **Isolated worktrees** — for each parallel task, create a git worktree:
   ```bash
   git worktree add ../<repo>-<task-id> <current-branch> -b <task-branch>
   ```
   - Each subagent works in its own worktree, avoiding file conflicts.
   - The worktree branches from the current HEAD (which includes all completed prior tasks).

4. **Cherry-pick integration** — after a task's commit is finalized in its worktree:
   ```bash
   # From the main worktree
   git cherry-pick <commit-sha>
   ```
   - Resolve any merge conflicts in shared files (e.g., mod.rs, index files) by combining both sides.
   - After cherry-picking, verify the build with `cargo check`/`npm run build`/etc.

5. **Cleanup** — after all cherry-picks are integrated:
   ```bash
   git worktree remove ../<repo>-<task-id>
   git branch -D <task-branch>
   ```

## Conflict resolution

Cherry-picks into the main branch may conflict on shared registration files (mod.rs, package index, barrel exports). The parent agent resolves these by:
- Keeping all module declarations from both sides
- Sorting/ordering declarations consistently
- Running the build to verify resolution correctness

## Sequencing rules

- Tasks within the same wave run in parallel (isolated worktrees).
- The review agent for a task launches as soon as its implement agent completes.
- The fix agent launches as soon as the review agent completes (if issues found).
- The next wave starts only after all tasks in the current wave are cherry-picked into the main branch.
- The final integration task (if one exists) runs last in its own wave.

## Validation

After all tasks are integrated:
1. Run the full build (`cargo check`, `npm run build`, `go build`, etc.)
2. Run the full test suite
3. Verify the final commit log shows one clean commit per task

## Error handling

- If an implement agent fails to produce compiling code after its fix cycle, skip that task and report it to the user.
- If cherry-pick conflicts cannot be resolved automatically, pause and ask the user.
- If the spec has circular dependencies, report the cycle and ask the user to break it.
