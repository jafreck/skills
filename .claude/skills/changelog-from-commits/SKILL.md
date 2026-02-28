---
name: changelog-from-commits
description: Generate changelog sections from commit history using conventional commit types.
---

# Generate changelog from commits

Create release notes from commit history using conventional commit patterns.

## Usage

Use this skill when asked to generate release notes, build a changelog, or summarize changes between tags/commits.

## Steps

1. Determine commit range:
   - Prefer `LAST_TAG..HEAD` for release notes.
   - If no tag exists, use all commits on the current branch.

2. Collect commits in the range:
   ```bash
   git log --pretty=format:"%s" <RANGE>
   ```

3. Group commit subjects by type prefix:
   - `feat:` / `feat(scope):` -> Features
   - `fix:` / `fix(scope):` -> Fixes
   - `perf:` -> Performance
   - `docs:` -> Documentation
   - `refactor:` -> Refactors
   - `test:` -> Tests
   - `chore:` / `build:` / `ci:` -> Maintenance

4. Detect breaking changes:
   - Subject contains `!` after type/scope (e.g., `feat(api)!:`)
   - Body contains `BREAKING CHANGE:`

5. Produce a changelog with these sections (omit empty ones):
   - Breaking Changes
   - Features
   - Fixes
   - Performance
   - Documentation
   - Refactors
   - Tests
   - Maintenance

6. Keep each bullet concise and user-facing.

If commit messages are inconsistent, still produce the best possible grouped output and note any limitations.
