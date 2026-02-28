---
name: mermaid-request-flow-chart
description: Generate Mermaid request flow charts for inbound requests, service hops, data access, and responses.
---

# Generate Mermaid request flow charts

Create clear request-path flowcharts from entrypoint to response.

## Usage

Use this skill when asked to visualize API request flow, control flow, or high-level runtime behavior.

## Steps

1. Gather request path details:
   - Entry point (gateway/controller/handler)
   - Validation and auth steps
   - Service/business logic calls
   - Data store/queue interactions
   - Error and retry paths

2. Use Mermaid `flowchart` with directional layout:
   - Prefer `flowchart LR` for readability
   - Use decision nodes for conditionals

3. Include major branches:
   - Happy path
   - Auth/validation failures
   - Upstream timeout/error handling

4. Label critical edges:
   - sync vs async
   - retries/backoff
   - fallback behavior

5. Output:
   - Mermaid source
   - Assumptions and omitted details

## Quality rules

- Keep chart focused on one request/use case.
- Limit to key steps; avoid low-level implementation noise.
- Make failure paths explicit and easy to trace.
