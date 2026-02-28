---
name: docs-sync
description: Check documentation against repository behavior and produce a focused outdated-docs report.
---

# Sync docs with repo behavior

Compare docs with actual repository scripts/config and identify mismatches.

## Usage

Use this skill when asked to verify, update, or audit docs for accuracy.

## Steps

1. Gather source-of-truth behavior from the repo:
   - Entrypoints (`README`, scripts, Makefile, task files)
   - Commands in `package.json`, `pyproject.toml`, `Cargo.toml`, etc.
   - Required environment variables and config files
   - CI workflows and test/build commands

2. Read docs to validate:
   - Setup/install instructions
   - Run/build/test commands
   - Environment variable names/defaults
   - Project structure references

3. Identify mismatches and classify:
   - Missing docs
   - Stale command/config names
   - Wrong paths or prerequisites
   - Ambiguous or incomplete steps

4. Produce an "Outdated Docs Report" containing:
   - What is incorrect
   - Evidence from repo behavior
   - Exact replacement text (minimal edits)

5. If asked to apply changes, update docs with minimal, surgical edits.

Prefer concise docs that reflect current behavior exactly; avoid adding speculative guidance.
