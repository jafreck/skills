---
name: mermaid-sequence-request-chart
description: Generate Mermaid sequence diagrams for request lifecycles across clients, services, and dependencies.
---

# Generate Mermaid sequence request charts

Create sequence diagrams showing message order and timing across components.

## Usage

Use this skill when asked to visualize request timelines, protocol interactions, or multi-service handshakes.

## Steps

1. Identify participants:
   - Client/UI
   - Gateway/API
   - Internal services
   - Datastores/queues/external APIs

2. Use Mermaid `sequenceDiagram` syntax.

3. Model request lifecycle in order:
   - Request initiation
   - Validation/auth
   - Service orchestration
   - Data reads/writes
   - Response or error

4. Capture important interaction semantics:
   - `->>` request/call
   - `-->>` response
   - `alt/else` for branches
   - `loop` for retries/polling
   - `par` for parallel actions when needed

5. Output:
   - Mermaid sequence diagram source
   - Notes for assumptions and edge cases

## Quality rules

- Keep participant names stable and concise.
- One primary use case per diagram.
- Include failure/timeout path when relevant.
