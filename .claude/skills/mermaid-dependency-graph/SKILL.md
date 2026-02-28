---
name: mermaid-dependency-graph
description: Generate Mermaid dependency graphs for services, packages, modules, and external systems.
---

# Generate Mermaid dependency graphs

Create dependency graphs in Mermaid from repository or architecture context.

## Usage

Use this skill when asked to map dependencies between modules, packages, services, or external systems.

## Steps

1. Identify graph scope:
   - Code modules/package imports
   - Service-to-service dependencies
   - Runtime dependencies (DB, cache, queue, third-party APIs)

2. Choose diagram type:
   - `flowchart LR` for most dependency maps
   - `graph TD` when top-down is clearer

3. Build nodes and directed edges:
   - `A --> B` means A depends on B
   - Label edge only when dependency type needs clarity

4. Group related nodes with Mermaid `subgraph` blocks.

5. Highlight risky coupling:
   - Cycles
   - High fan-in / fan-out components
   - Optional or weak dependencies

6. Output:
   - Mermaid diagram source
   - Short notes on key dependency risks

## Quality rules

- Keep naming consistent with repo terminology.
- Avoid clutter; split into multiple diagrams if needed.
- Prefer one diagram per concern (build-time vs runtime).
