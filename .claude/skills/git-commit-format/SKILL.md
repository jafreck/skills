---
name: git-commit-format
description: Enforce commit subject format: type(scope): summary (#issue).
---

# Format git commit messages

Use a strict commit subject format:

`type(scope): summary (#issue)`

## Allowed types

- `feat`
- `fix`
- `docs`
- `refactor`
- `test`
- `chore`
- `perf`
- `build`
- `ci`

## Rules

1. Subject must match:
   - `type(scope): summary (#issue)`
2. `type` must be one of the allowed types.
3. `scope` is required and should be short/lowercase.
4. `summary` should be concise, imperative, and no trailing period.
5. `#issue` is required and must be numeric.

## Validation regex

Use this regex for validation:

```regex
^(feat|fix|docs|refactor|test|chore|perf|build|ci)\([a-z0-9._-]+\): [^\.].* \(#\d+\)$
```

## Examples

Valid:
- `feat(auth): add token refresh (#142)`
- `fix(ci): retry flaky integration step (#87)`
- `docs(readme): clarify setup prerequisites (#19)`

Invalid:
- `feat: add token refresh` (missing scope and issue)
- `fix(Auth): update login (#12)` (scope must be lowercase)
- `chore(repo): cleanup.` (trailing period and missing issue)

When creating commits, always format the message to this pattern.
