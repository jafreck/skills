---
name: adr-writer
description: Draft Architecture Decision Records (ADRs) from project context with clear status, context, decision, and consequences.
---

# Write architecture decision records

Create concise, actionable ADRs grounded in repository context.

## Usage

Use this skill when asked to draft an ADR, document architecture decisions, or compare decision alternatives.

## ADR template

Use this structure:

- Title
- Status (Proposed, Accepted, Superseded)
- Date
- Context
- Decision
- Alternatives considered
- Consequences (positive, negative, neutral)
- Rollout or migration notes (if applicable)
- Related links/issues

## Steps

1. Gather decision context from code, docs, and constraints.
2. Identify decision drivers (cost, reliability, performance, security, operability, team velocity).
3. Propose one clear decision statement.
4. Capture 2-4 realistic alternatives with trade-offs.
5. Write concrete consequences and expected impact.
6. Keep language implementation-focused and avoid vague claims.

## Output quality rules

- Prefer measurable statements over opinions.
- Include assumptions explicitly.
- Keep ADR concise and skimmable.
- If uncertainty remains, list open questions.

When requested, also draft a filename using: `docs/adr/NNNN-short-title.md`.
