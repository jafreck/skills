---
name: parallel-implement-spec
description: Implement all tasks from a specification document using parallel subagents with isolated worktrees, independent code review, and cherry-pick integration.
---

# Parallel implement from specification

Implement **every task** from a specification/plan document using the implement->review->fix subagent workflow, parallelized across git worktrees where the dependency graph allows.

## ⚠️ CRITICAL: Never modify the primary branch directly

**All cherry-picks go into a dedicated integration worktree/branch — NEVER into main or the primary working branch.** Before any task work begins, you MUST create a new integration worktree and branch. That integration branch is the sole target for all cherry-picks. The primary worktree and its branch must remain untouched throughout the entire process. At the end, the user decides how to merge the integration branch.

## Completeness requirement

**ALL tasks in the spec MUST be implemented.** This is non-negotiable. Do not skip, defer, or partially implement any task. Before starting, count the total number of tasks. After finishing, verify that every task has a corresponding commit. If a task fails implementation after the fix cycle, report the failure explicitly - do not silently drop it.

At the end of execution, produce a completion table mapping every task ID from the spec to its commit SHA (or failure reason). Any task without a commit SHA is a failure that must be reported to the user.

## Usage

Use this skill when asked to implement a multi-task plan, specification, or implementation document. The user should provide the path to the spec document (or it should be discoverable in the repo). The spec must define discrete tasks with a dependency graph.

## Workflow per task

Each task goes through three phases:

1. **Implement** — spawn a `general-purpose` subagent (with the same model as the launching agent) to implement the task. Provide it with:
   - The spec document path and the specific task section to implement
   - An explicit instruction: "Implement this task COMPLETELY. Every requirement, edge case, and acceptance criterion described in the task must be addressed. Do not leave TODOs, stubs, or partial implementations."
   - The working directory (repo root or worktree path)
   - Instructions to study existing code patterns before writing new code
   - Instructions to register new modules in the appropriate mod/index files
   - Instructions to run the build and tests, but NOT commit

2. **Review** — spawn a `code-review` subagent (with the same model as the launching agent) to independently review the implementation. Instruct it to:
   - Verify the task is FULLY implemented - every requirement from the spec section is addressed
   - Focus on correctness, safety, edge cases, and interaction with existing code
   - Only flag genuine bugs, logic errors, missing requirements, or safety checks (not style)
   - Explicitly call out any spec requirements that were not implemented

3. **Fix + Commit** — if the reviewer found issues, spawn a `general-purpose` subagent (with the same model as the launching agent) to fix them. Whether the fixer or reviewer found no issues, the final agent commits with a descriptive message and the co-author trailer. If no issues were found, have the implement agent commit directly (or spawn a small commit agent).

## Subagent model

All subagents (implement, review, fix) **must** be launched with the same model as the launching agent. Pass the `model` parameter explicitly to every `task` tool call so that subagents run on the identical model.

## Parallelization strategy

1. **Parse the dependency graph** from the spec. Identify which tasks can run in parallel (no mutual dependencies, different output files).

2. **Wave execution**:
   - Start with tasks that have no dependencies (wave 0).
   - After wave 0 completes and is committed, launch all tasks whose dependencies are satisfied in parallel.
   - Continue until all tasks are done.

3. **Integration worktree (MANDATORY FIRST STEP)** — before launching any task, you MUST create a dedicated integration worktree and branch. This is a NEW branch off the primary worktree's current HEAD. This integration worktree is the ONLY target for cherry-picks — never cherry-pick into main or the primary worktree:
   ```bash
   # From the primary worktree — create the integration branch and worktree
   git worktree add ../<repo>-integration HEAD -b integration/<feature>
   ```
   After this point, the primary worktree is READ-ONLY. All integration happens in `../<repo>-integration`.

4. **Task worktrees** — for each parallel task, create a git worktree branching from the integration worktree's HEAD (which includes all completed prior-wave tasks):
   ```bash
   # Branch from the integration worktree's branch
   git worktree add ../<repo>-<task-id> integration/<feature> -b task/<task-id>
   ```
   - Each subagent works in its own task worktree, avoiding file conflicts.

5. **Cherry-pick integration** — after a task's commit is finalized in its task worktree, cherry-pick it into the **integration worktree's branch** (NEVER into main or the primary worktree):
   ```bash
   # ALWAYS operate in the integration worktree — not the primary worktree
   cd ../<repo>-integration
   git cherry-pick <commit-sha>
   ```
   - **Double-check:** if `git branch --show-current` shows `main` or the original branch, STOP — you are in the wrong worktree.
   - Resolve any merge conflicts in shared files (e.g., mod.rs, index files) by combining both sides.
   - After cherry-picking, verify the build with `cargo check`/`npm run build`/etc.

6. **Cleanup** — after all cherry-picks are integrated into the integration worktree:
   ```bash
   git worktree remove ../<repo>-<task-id>
   git branch -D task/<task-id>
   ```
   The integration worktree and its branch (`integration/<feature>`) remain for the user to review, merge, or rebase into their primary branch. **Do NOT merge the integration branch into main automatically.**

## Conflict resolution

Cherry-picks into the integration worktree may conflict on shared registration files (mod.rs, package index, barrel exports). The parent agent resolves these by:
- Keeping all module declarations from both sides
- Sorting/ordering declarations consistently
- Running the build to verify resolution correctness

## Sequencing rules

- Tasks within the same wave run in parallel (isolated worktrees).
- The review agent for a task launches as soon as its implement agent completes.
- The fix agent launches as soon as the review agent completes (if issues found).
- The next wave starts only after all tasks in the current wave are cherry-picked into the integration worktree.
- The final integration task (if one exists) runs last in its own wave.

## Validation

After all tasks are integrated:
1. **Verify completeness** — confirm every task from the spec has a commit in the integration branch. Print the completion table (task ID -> commit SHA). If any task is missing, stop and report.
2. Run the full build (`cargo check`, `npm run build`, `go build`, etc.)
3. Run the full test suite
4. Verify the final commit log shows one clean commit per task

## Holistic review

After validation passes, launch a final round of review subagents (same model as the launching agent) against the **integration worktree**. These agents review the complete set of changes — not individual tasks — against the original spec.

1. **Diff the integration branch** against the base commit to produce the full combined diff.

2. **Launch parallel `code-review` subagents**, each with a focused mandate. Provide every agent with the spec document, the full diff, and the integration worktree path. Suggested split:

   - **Correctness reviewer** — verify that every task's acceptance criteria from the spec are actually met. Flag any missing functionality, incomplete implementations, or behaviors that diverge from what the spec describes.
   - **Cross-cutting reviewer** — look for issues that only emerge when all tasks are combined: broken interactions between new modules, inconsistent naming or conventions across tasks, duplicated logic, missing error propagation across boundaries.
   - **Quality reviewer** — check for regressions in code quality: unused imports/dead code introduced, missing tests for new public APIs, hardcoded values that should be configurable, panics/unwraps in non-test code, missing documentation on public items.

3. **Collect findings** — gather all reviewer reports. Present a consolidated summary to the user, organized by severity:
   - 🔴 **Blocking** — bugs, spec divergences, or correctness issues that must be fixed
   - 🟡 **Advisory** — quality concerns or suggestions worth considering
   - ✅ **Clean** — areas that passed review with no issues

4. **Do NOT auto-fix** — the holistic review is informational. Present findings and let the user decide whether to address them (manually or by invoking another round of implementation).

## Error handling

- If an implement agent fails to produce compiling code after its fix cycle, skip that task and report it to the user.
- If cherry-pick conflicts cannot be resolved automatically, pause and ask the user.
- If the spec has circular dependencies, report the cycle and ask the user to break it.
